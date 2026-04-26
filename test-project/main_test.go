package main

import "testing"

func TestGreet(t *testing.T) {
	got := Greet("Pipery")
	want := "Hello, Pipery!"
	if got != want {
		t.Errorf("got %q want %q", got, want)
	}
}
