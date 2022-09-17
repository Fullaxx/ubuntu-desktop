# Helpful Hints

## Jammy and Seccomp
If you see errors like the following: \
![Openbox Error Message 1](https://github.com/Fullaxx/ubuntu-desktop/blob/master/images/openbox_error_1.jpg)
![Openbox Error Message 2](https://github.com/Fullaxx/ubuntu-desktop/blob/master/images/openbox_error_2.jpg) \
try adding --security-opt seccomp=unconfined to your docker run command:
```
docker run -it --rm --name ud --security-opt seccomp=unconfined -p 5901:5901 fullaxx/ubuntu-desktop
```
