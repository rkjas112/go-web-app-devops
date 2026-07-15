# Lesson 1 — Understand what will be deployed

Video segment:
[05:25–09:50](https://www.youtube.com/watch?v=HGu9sgoHaJ0&t=325s).

## Goal

Before containerizing an application, identify its runtime contract: how it
starts, where it listens, which files it needs, and how success can be tested.

## Read the application

```bash
sed -n '1,220p' main.go
sed -n '1,220p' main_test.go
sed -n '1,80p' go.mod
find static -maxdepth 2 -type f | sort
```

While reading `main.go`, locate:

- The program entry point.
- The four URL routes.
- The TCP port.
- The files served by each route.
- The error-handling behavior when the server cannot start.

## Runtime contract

The baseline application requires two things at runtime:

1. A compiled Go executable.
2. The `static` directory in the executable's working directory.

This matters during containerization. Copying only the executable would compile
successfully but produce missing pages at runtime.

## Compare source with the running reference

The final reference is already running in Kind. In one terminal:

```bash
kubectl --context kind-cka-cluster2 -n go-web-app-kind \
  port-forward service/go-web-app 18080:80
```

In a second terminal:

```bash
curl -i http://127.0.0.1:18080/home
curl -i http://127.0.0.1:18080/healthz
```

The baseline source does not contain `/healthz`, but the reference application
does. Do not copy its implementation yet. First explain why Kubernetes and load
balancers benefit from a lightweight health endpoint.

## Checkpoint questions

Write answers in `notes/lesson-01-answers.md`:

1. Which function starts the server?
2. Which address and port does it listen on?
3. What happens when you request `/` in the baseline application?
4. Why must the `static` directory be included in the container image?
5. What does `main_test.go` verify, and what important behavior does it not test?
6. Why should a health endpoint avoid rendering a full HTML page?

## Small design exercise

Without editing code yet, write a proposed contract for `/healthz`:

- HTTP method:
- Expected status:
- Response body:
- External dependency checks, if any:

We will implement and test that design as part of the Docker lesson, where Go
will run inside the builder container—no local Go installation required.
