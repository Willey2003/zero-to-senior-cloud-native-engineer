# Lab 04: Docker, Basic to Advanced

## Why this matters
A container packages an app with everything it needs, so it runs the same on your laptop, a server,
or Kubernetes. Under the hood it is just a Linux process with namespaces (isolation) and cgroups (limits),
exactly what you built by hand in Lab 02.

## Concepts
- **Image**: a read-only template (like a class). Built from a **Dockerfile** in **layers**.
- **Container**: a running instance of an image (like an object).
- **Registry**: a store of images (Docker Hub, GitHub Container Registry, AWS ECR, Quay).
- **Volume**: storage that survives when the container is deleted.

## Level 1: Basics
```bash
docker run hello-world
docker run -d --name web -p 8080:80 nginx      # -d background, -p host:container
docker ps ; docker logs web ; docker exec -it web sh
docker stop web && docker rm web
docker images ; docker pull alpine:3.20
docker run --rm -it alpine sh                  # throwaway container
docker inspect web | less                      # everything about a container
```

## Level 2: Build your own image (the Lab 03 API)
Look at `app/Dockerfile` (multi-stage, non-root, small).
```bash
cp ../03-bash-git-python/python/app.py ../03-bash-git-python/python/requirements.txt app/
docker build -t lab-api:v1 app/
docker run -d --name api -p 8000:8000 -e APP_VERSION=v1 lab-api:v1
curl localhost:8000/health
docker history lab-api:v1                      # see each layer and its size
```
Exercise: change a line in `app.py`, rebuild, and notice which layers are cached. Reorder the Dockerfile badly
(COPY everything before `pip install`) and see how the cache breaks.

## Level 3: Volumes and Compose
```bash
docker volume create pgdata
docker compose -f app/compose.yaml up -d       # API + Postgres + Redis
docker compose ps ; docker compose logs -f api
docker compose down                            # add -v to also delete volumes
```

## Level 4: Advanced
- Resource limits: `docker run --memory 256m --cpus 0.5 ...` then trigger OOM and read `docker inspect` → `OOMKilled`.
- Health checks in Dockerfile (`HEALTHCHECK`) and `depends_on: condition: service_healthy` in Compose.
- Multi-arch builds: `docker buildx build --platform linux/amd64,linux/arm64 ...`.
- Push to a registry: `docker tag lab-api:v1 ghcr.io/<you>/lab-api:v1 && docker push ...`.
- Podman (Red Hat's daemonless Docker): `podman run`, `podman generate systemd`, rootless by default.
- Look under the hood: `docker inspect -f '{{.State.Pid}}' api` then `sudo ls -l /proc/<pid>/ns`.

## Real-world scenarios
1. **"Works on my laptop, crashes in prod."** Run `docker run lab-api:v1 python -c "import os; os.environ['DB_URL']"` and read the error.
   Fix with env vars and defaults.
2. **"Container keeps restarting."** Set `--memory 30m`, watch it get OOM-killed, diagnose with `docker inspect` and `docker events`.
3. **"Image is 1.2 GB, deploys are slow."** Shrink it with multi-stage and slim/distroless base.
4. **"Data lost after redeploy."** Postgres without a volume; fix with a named volume.

## Check yourself
- [ ] Explain image vs container vs layer.
- [ ] Write a multi-stage Dockerfile that runs as non-root, from memory.
- [ ] Explain what `-p 8080:80` actually does (hint: iptables DNAT, Lab 05).
