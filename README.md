# Simple Tor Relay Docker container
This is a simple docker container to run the most updated version of tor on your computer in a safe way.

Now, you cannot say anymore: "*I cannot create my node, it's too complicated*'.

## Getting Started

### About tor
Find more information about tor on the officiel tor website https://www.torproject.org/.

### Prerequisites
To run this container, you will need [docker](https://www.docker.com/) and *docker-compose* (optionnal).

### Reasons why you should use this container
- Onion Router Port: 443
- Directory Server Port: 80
- Docker container running on separate user (tor)
- Compiled from [official source code](https://www.torproject.org/download/tor/) with official, **non altered code** (see [Dockerfile](https://hub.docker.com/r/fedorage/tor-simple-relay/dockerfile))

### Relay Node example
**docker-compose.yml**
```yml
version: "2"
services:
  tor:
    image: fedorage/tor-simple-relay:latest
    ports:
      - "443:9001"
      - "80:9030"
      - "46396:46396"
    environment:
      TOR_EXTRA_CONF: |
        Nickname MyTorSimpleRelay
        ContactInfo tor@hack.me
```

### Relay Node but not exit node example
**docker-compose.yml**
```yml
version: "2"
services:
  tor:
    image: fedorage/tor-simple-relay:latest
    ports:
      - "443:9001"
      - "80:9030"
      - "46396:46396"
    environment:
      TOR_EXTRA_CONF: |
        Nickname MyTorSimpleRelay
        ContactInfo tor@hack.me
        Exitpolicy reject *:* # Exit node not allowed
```

### How to launch
```bash
docker-compose up -d
```

Then wait for 20 minutes, and check if your node is in the list of nodes in https://torstatus.blutmagie.de/.

## Versioning 
### On Git
We use **Github** for source versionning:
- [Sources](https://github.com/rofra/docker-tor-simple-relay/)
- [Releases](https://github.com/rofra/docker-tor-simple-relay/releases)

### On Docker Hub
We use **Docker Hub** for image versioning and auto-building docker images:
- [Project](https://hub.docker.com/r/fedorage/tor-simple-relay)
- [Releases](https://hub.docker.com/r/fedorage/tor-simple-relay/tags)

## Authors
* **Rodolphe Franceschi** - *Initial work* - ([github](https://github.com/rofra) / [linkedin](https://www.linkedin.com/in/rodolphe-franceschi-2a47b636/))

## License
This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.