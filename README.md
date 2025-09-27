# docker-ledfx-server
Dockerfile for Ledfx with a built-in Snapcast client. Audio routed via pipewire into a null sink. Based on Alpine linux.

## Compose Example
```yaml
services:
  ledfx:
    image: ledfx:latest
    container_name: ledfx
    restart: unless-stopped
    ports:
      - 8888:8888/tcp
    environment:
      LEDFX_OPTS: "--offline --clear-effects"
      SNAPCAST_OPTS: "tcp://10.100.1.6"

```
