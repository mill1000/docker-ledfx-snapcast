# docker-ledfx-server
Dockerfile for Ledfx with a built-in Snapcast client. Audio routed via pipewire into a null sink. Based on Alpine linux.

## Compose Example
```yaml
services:
  ledfx:
    image: ledfx:latest
    container_name: ledfx
    hostname: LedFX
    restart: unless-stopped
    ports:
      - 8888:8888/tcp
    environment:
      LEDFX_OPTS: "--offline --clear-effects"
      SNAPCAST_OPTS: "--hostID ledfx_snapcast <SNAPCAST_HOST>"
    volumes:
      - ./ledfx/config.json:/app/ledfx/config.json
```
