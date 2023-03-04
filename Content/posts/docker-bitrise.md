---
date: 2020-07-03 13:00
title: Building (almost) anything on Bitrise using Docker
image: https://www.oliverbinns.co.uk/wp-content/uploads/2020/10/wFlFGsF3_400x400.jpg
color: #683D87
tags: Swift, Server-Side, Vapor, Bitrise
---
Bitrise is gaining a lot of users in the mobile development community- but did you know you can also use it as a CI tool for non-mobile projects too?

For [Little Journey](https://littlesparkshospital.com/) we use Bitrise to build our full stack of applications including front-end (Angular) and back-end (Vapor) web. The web applications are both deployed to a Linode server.

Docker 18.09 came with a new tool called BuildKit which allows you to export executables built inside a container so that they can be deployed directly on the target platform.

```
DOCKER_BUILDKIT=1 docker build --output type=tar,dest=release.tar .
```

By setting the DOCKER_BUILDKIT variable, we can output a tarfile containing the build artifacts we need, such as executables or compiled code.

In order to do this, we need to create a Dockerfile with a multi-stage (two stages) build. The first stage will install any dependencies and run the build. The second stage copies our build files into a clean container so that we can export just the build files that we need, rather than the whole codebase.

```
FROM swift:xenial AS build-stage
WORKDIR /root
COPY . .
RUN apt-get -qq update && apt-get install -yq libssl-dev libicu-dev
RUN swift build -c release

FROM scratch AS export-stage
# Vapor Swift stores build files in .build/release
COPY --from=build-stage /root/.build/release /
```
