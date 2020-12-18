# IP Spoofing Tester v1.0

## About the project

This image will run the CAIDA Spoofer (http://spoofer.caida.org/) to measure the Internet's
susceptibility to spoofed source address IP packets.

## Build

```
  docker build -t caida-spoofer-docker .
```

## Run

```
  docker run --network=host -it --rm caida-spoofer-docker:latest
```

## Original repo
[caida-spoofer-docker](https://github.com/zmaximo1990/caida-spoofer-docker)
