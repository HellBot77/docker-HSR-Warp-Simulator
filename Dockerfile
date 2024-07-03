FROM alpine/git AS base

ARG TAG=latest
RUN git clone https://github.com/Mantan21/HSR-Warp-Simulator.git && \
    cd HSR-Warp-Simulator && \
    ([[ "$TAG" = "latest" ]] || git checkout ${TAG}) && \
    rm -rf .git

FROM node AS build

WORKDIR /HSR-Warp-Simulator
COPY --from=base /git/HSR-Warp-Simulator .
RUN yarn && \
    export NODE_ENV=production && \
    yarn build

FROM lipanski/docker-static-website

COPY --from=build /HSR-Warp-Simulator/build .
