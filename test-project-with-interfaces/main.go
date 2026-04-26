package main

import "fmt"

func main() {
	g := EnglishGreeter{}
	fmt.Println(PrintGreeting(g, "Pipery"))
}
