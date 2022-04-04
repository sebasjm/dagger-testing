package image_output

import (
  "dagger.io/dagger"
  "universe.dagger.io/docker"
)

dagger.#Plan & {
  actions: {
    linux: {
      build: docker.#Build & {
        steps: [
          docker.#Pull & {
            source: "index.docker.io/debian:11.3"
          },
        ]
      }
    },
    updated: {
      build: docker.#Build & {
        steps: [
          linux.build,
          docker.#Run & {
              command: {
                name: "apt"
                args: ["update"],
              }
          },
        ]
      }
    },
    box: {
      build: docker.#Build & {
        steps: [
          updated.build,
          docker.#Run & {
              command: {
                name: "apt"
                args: ["install", "-y", "git"],
              }
          },
        ]
      }
    }
  }
}
