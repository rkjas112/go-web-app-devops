# syntax=docker/dockerfile:1.7

FROM golang:1.26-alpine AS test

WORKDIR /src

COPY go.mod ./
RUN go mod download

COPY . .
RUN go test ./...

FROM test AS build

RUN CGO_ENABLED=0 go build -trimpath -ldflags="-s -w" -o /out/go-web-app .

FROM gcr.io/distroless/static-debian12:nonroot AS runtime

WORKDIR /app

COPY --from=build --chown=nonroot:nonroot /out/go-web-app ./go-web-app
COPY --from=build --chown=nonroot:nonroot /src/static ./static

USER nonroot:nonroot
EXPOSE 8080

ENTRYPOINT ["./go-web-app"]
