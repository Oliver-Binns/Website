---
date: 2020-07-03 13:00
title: Building (almost) anything on Bitrise using Docker
image: /Images/bitrise.jpg
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

For our front-end Angular app, the deployment is now as simple as transferring this tar file to the relevant folder on our Linode server and decompressing it by running `tar -xvf release.tar` from the command line.

For our Vapor API, we can ensure that the executable is built in a container that matches our server (Ubuntu 16.04 LTS) so that it will run correctly when deployed to the server, even though we are building it using a macOS agent on Bitrise.

Docker is also great for running our tests so that we can be sure they all pass before each pull request gets merged into our main codebase.

Multi-stage Docker builds are also great for doing this. We can add a test-stage between our initial setup / build and export stages.

If required, it’s also possible to add additional phases for different release environments (such as pre-production) environments if different build configurations are required.

```
# Create a Lightweight Node environment with our 
# dependencies to use as a base container
FROM timbru31/node-alpine-firefox AS base
WORKDIR /root
COPY . .
# Skip Chromium download as we use Firefox for testing
RUN npm config set puppeteer_skip_chromium_download true -g
# Install our dependencies
RUN npm install

# Create a test container (on top of base), set path to Firefox
# Run lint to ensure code-style and run the unit tests
FROM base AS test
ENV FIREFOX_BIN=/usr/bin/firefox
RUN npm run-script lint && npm test

# Create a build container (on top of base) and run the build
FROM base AS prod
RUN npm run-script build-prod

# Create an empty container copying the output
FROM scratch AS build-prod
COPY --from=prod /dist/little-journey /
```

We can now pass a stage target parameter into Docker to either

* run the tests for pull requests: \
`docker build --target test .`
* build an executable on code-merge: \
`DOCKER_BUILDKIT=1 docker build --output type=tar,dest=release.tar --target build-beta .`

## Want to know more?

I’d recommend this article from [@ZachSimone](https://twitter.com/zachsimone) on how to deploy a Vapor app to a Linode Ubuntu server.

> prettylink https://zachsim.one/blog/2020/6/28/deploying-swift-vapor-to-ubuntu-server
> image /Images/linode.png
> title Deploying a Swift Vapor Project to a Ubuntu Server — zachsim.one
> description Zach Simone’s homepage. Student and iOS developer from Sydney.

Check out the full documentation on Docker BuildKit and Bitrise.

> prettylink https://docs.docker.com/develop/develop-images/build_enhancements/
> image /Images/docker.ico
> title Build images with BuildKit
> description Learn the new features of Docker Build with BuildKit

> prettylink https://www.bitrise.io/
> image /Images/bitrise.jpg
> title Bitrise - Mobile Continuous Integration and Delivery
> description Continuous integration and delivery built for mobile: Automate iOS and Android builds, testing and deployment from your first install to the one millionth.

We **used** these techniques for building our front-end (Admin Panel) and back-end web applications at Little Journey. Little Journey is an interactive, virtual reality (VR) mobile app designed to prepare children aged 3 to 12 years for day-case surgery.
