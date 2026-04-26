package main

import "fmt"

// Greeter defines something that can greet.
type Greeter interface {
	Greet(name string) string
}

// EnglishGreeter greets in English.
type EnglishGreeter struct{}

func (g EnglishGreeter) Greet(name string) string {
	return fmt.Sprintf("Hello, %s!", name)
}

// SpanishGreeter greets in Spanish.
type SpanishGreeter struct{}

func (g SpanishGreeter) Greet(name string) string {
	return fmt.Sprintf("¡Hola, %s!", name)
}

func PrintGreeting(g Greeter, name string) string {
	return g.Greet(name)
}
