#!/bin/bash
# Start an ubuntu-desktop image the way users do and check that the desktop comes up:
# the VNC server answers on :5901 and openbox is running. Run it on a Docker host, as
# .github/workflows/monthly.yml does before it publishes:  tests/desktop.sh IMAGE

set -euo pipefail

IMAGE="${1:?usage: ${0##*/} IMAGE}"
NAME="ud-desktop-test-$$"

fail() {
  echo "FAIL: $*" >&2
  docker logs --tail 40 "${NAME}" 2>&1 || true
  exit 1
}

trap 'docker rm -f "${NAME}" >/dev/null 2>&1 || true' EXIT

docker run -d --name "${NAME}" "${IMAGE}" >/dev/null

# A VNC server speaks first, with an RFB ProtocolVersion banner such as "RFB 003.008"
BANNER=""
for _ in $(seq 60); do
  if [ "$(docker inspect -f '{{.State.Running}}' "${NAME}")" != "true" ]; then
    fail "${IMAGE} exited before the desktop came up"
  fi
  BANNER=$(docker exec "${NAME}" timeout 5 bash -c 'exec 3<>/dev/tcp/127.0.0.1/5901 && head -c 12 <&3' 2>/dev/null || true)
  if [[ "${BANNER}" == RFB* ]]; then
    break
  fi
  sleep 1
done
[[ "${BANNER}" == RFB* ]] || fail "no VNC server answered on :5901 within 60 s"

# The window manager starts after the VNC server, from its xstartup
for _ in $(seq 30); do
  if docker exec "${NAME}" sh -c 'grep -qsx openbox /proc/[0-9]*/comm'; then
    echo "OK: ${IMAGE} serves VNC (${BANNER}) and runs openbox"
    exit 0
  fi
  sleep 1
done
fail "the VNC server is up but openbox did not start within 30 s"
