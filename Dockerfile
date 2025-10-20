FROM alpine/git AS base

ARG TAG=latest
RUN git clone https://github.com/Mantan21/HSR-Warp-Simulator.git && \
    cd HSR-Warp-Simulator && \
    ([[ "$TAG" = "latest" ]] || git checkout ${TAG}) && \
    rm -rf .git

FROM --platform=$BUILDPLATFORM node:alpine AS build

WORKDIR /HSR-Warp-Simulator
COPY --from=base /git/HSR-Warp-Simulator .
RUN npm install --global pnpm && \
    pnpm install --frozen-lockfile && \
    pnpm build

FROM joseluisq/static-web-server

COPY --from=build /HSR-Warp-Simulator/build ./public
