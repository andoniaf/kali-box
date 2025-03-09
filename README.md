# Kali Box

A Docker container for Kali Linux with a GUI, accessible via VNC or a web browser.


## Setup
### 1) Build
```bash
docker build . -t kali-box
```
You can also specify additional packages to be installed during the build process using the `EXTRA_PACKAGES` build argument:
```bash
docker build --build-arg EXTRA_PACKAGES="dirb" . -t kali-box
```

### 2) Run
```bash
docker run --rm -it -p 9020:8080 -p 9021:5900 kali-box
```

Yoy can also mount a local folder for faster sharing between container and host:
```bash
docker run --rm -it -p 9020:8080 -p 9021:5900 -v ~/CTFs:/mnt/local/CTFs kali-box
```

## Configuration
The default configuration is set as follows. Feel free to change this as required.

- `-e VNCEXPOSE=1`
  - By default, the VNC server is exposed. Use your VNC client of choice and connect to `localhost:9020` with the default password `password`. Can also access using IP:PORT.
  - Use `-e VNCEXPOSE=0` to only allow localhost access
  - The default port mapping for the VNC server is configured with the `-p 9021:5900` parameter.
- `-e VNCPORT=5900`
  - By default, the VNC server runs on port 5900 within the container.
  - Note: If you change this port, you also need to change the port mapping with the `-p 9021:5900` parameter.
- `-e VNCPWD=password`
  - Change the default password of the VNC server. If no password is provided, a random password will be generated on startup.
- `-e VNCDISPLAY=1920x1080`
  - Change the default display resolution of the VNC connection.
- `-e VNCDEPTH=16`
  - Change the default display depth of the VNC connection. Possible values are 8, 16, 24, and 32. Higher values mean better quality but more bandwidth requirements.
- `-e VNCWEB=0`
  - By default, the noVNC is disabled. Use `VNCWEB:1` to enable it.
- `-e NOVNCPORT=8080`
  - By default, the noVNC server runs on port 8080 within the container.
  - Note: If you change this port, you also need to change the port mapping with the `-p 9020:8080` parameter.
- entrypoint.sh includes two commands to start postgresql and create and initialize the msf database with the msfdb command.

## Customization
XFCE Desktop is configured by default.
You may also edit the `Dockerfile` or `entrypoint.sh` to install custom packages.
You can specify different Kali Linux metapackages, i.e., `core`, `default`, `light`, `large`, `everything`, or `top10`.

This image installs kali-tools-top10 and iputils-ping for basic Capture the Flag usage.
See [https://www.kali.org/news/major-metapackage-makeover/](https://www.kali.org/news/major-metapackage-makeover/) for more details and metapackages.

Packages are installed in three different layers (base, common and extra) to optimize build time and size while allowing quick modifications.

```
git clone https://github.com/andoniaf/kali-box
cd kali-docker
docker build -t kali-box .
docker run --rm -it -p 9020:8080 -p 9021:5900 kali-box
```

## Issues
- [ ] Copy/pasting though VNC not working by default:
  - I need to run `autocutsel -fork` manually to enable it.


---
Based on https://github.com/steinruck/kali-xfce-novnc
