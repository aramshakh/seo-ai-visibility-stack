# 2. Server: before installing anything

## Sizing

Verified on **2 vCPU / 3.7 GiB RAM / 4 GiB swap**: enough for OpenSEO + Elmo + an agent at a weekly cycle. OpenSEO **starts slowly**: 60–90 seconds before its health endpoint answers. Don't restart it in a loop.

## Pitfall #1: Docker publishes ports around ufw

`ufw status` will say a port is closed while a container with `ports: "5432:5432"` happily answers from the internet. Docker inserts its rules into its own `DOCKER` iptables chain; `DOCKER-USER`, the chain ufw users are told about, is empty by default.

**Rule:** in every compose file, bind **all** ports to loopback:

```yaml
ports:
  - "127.0.0.1:5432:5432"
```

After **every** `docker compose up`, check from the server **and** from outside:

```bash
# on the server: must print nothing
docker ps --format '{{.Names}} {{.Ports}}' | grep -E '0\.0\.0\.0|:::'
```

```bash
# from another machine
nc -z -G 5 <SERVER_IP> 5432 && echo OPEN || echo closed
```

(On Linux `nc` use `-w 5` instead of `-G 5`.)

## Access to the UIs: SSH tunnel only

Neither tool is exposed. Both run without real authentication in this setup (see [OpenSEO](04-openseo.md) `AUTH_MODE=local_noauth`), so the only acceptable path to their web UIs is a tunnel:

```bash
ssh -L 1515:127.0.0.1:1515 -L 3001:127.0.0.1:3001 <server>
```

Then open `http://localhost:1515` (Elmo) and `http://localhost:3001` (OpenSEO) on your machine.

Next: [Elmo](03-elmo.md)
