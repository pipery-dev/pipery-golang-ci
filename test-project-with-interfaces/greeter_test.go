package main

import "testing"

func TestEnglishGreeter(t *testing.T) {
	g := EnglishGreeter{}
	got := g.Greet("Pipery")
	want := "Hello, Pipery!"
	if got != want {
		t.Errorf("got %q want %q", got, want)
	}
}

func TestSpanishGreeter(t *testing.T) {
	g := SpanishGreeter{}
	got := g.Greet("Pipery")
	want := "¡Hola, Pipery!"
	if got != want {
		t.Errorf("got %q want %q", got, want)
	}
}

func TestPrintGreeting(t *testing.T) {
	got := PrintGreeting(EnglishGreeter{}, "World")
	if got != "Hello, World!" {
		t.Errorf("unexpected greeting: %q", got)
	}
}
