# docker-registry-ex4100

Docker Distribution Registry 3.1.1 adapted for the WD My Cloud EX4100 (ARMv7 / My Cloud OS 5).

The official Registry images tested on this NAS were not reliable and could terminate with `exit 139`, so this image uses Debian Bullseye and the official `linux_armv7` Registry binary.

## Docker image

```text
ovelayos/docker-registry-wd-ex4100:3.1.1-bullseye
```

## Build and push

From Windows PowerShell with Docker Desktop / Buildx:

```powershell
.\build-and-push.ps1
```

The script publishes both:

```text
ovelayos/docker-registry-wd-ex4100:3.1.1-bullseye
ovelayos/docker-registry-wd-ex4100:latest
```

## Runtime

The Registry listens on port `5000` and stores data in `/var/lib/registry` inside the container.

For the EX4100 deployment used by OsCrisCloud, persistent data is mounted from:

```text
/mnt/HD/HD_a2/docker/registry
```

## HTTP local registry

If the Registry is used over plain HTTP, Docker on the EX4100 must allow it as an insecure registry. Example `/etc/docker/daemon.json`:

```json
{
  "insecure-registries": [
    "192.168.178.130:5000"
  ]
}
```

Reload the daemon configuration without rebooting the NAS:

```sh
kill -HUP $(pidof dockerd)
```

Verify:

```sh
docker info | grep -A10 "Insecure Registries"
```
