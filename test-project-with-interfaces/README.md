# hello-pipery-interfaces

A more complex Go test project using interfaces, used to validate that the pipery Go CI action handles multi-file projects with interface types correctly.

## Structure

- `greeter.go` — defines the `Greeter` interface and two implementations (`EnglishGreeter`, `SpanishGreeter`)
- `main.go` — entry point
- `greeter_test.go` — tests for both greeter implementations and `PrintGreeting`
