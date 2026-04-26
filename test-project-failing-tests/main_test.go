package main

import "testing"

func TestGreet(t *testing.T) {
	// Intentionally wrong expectation
	got := Greet("Pipery")
	want := "Goodbye, Pipery!"
	if got != want {
		t.Errorf("got %q want %q", got, want)
	}
}
