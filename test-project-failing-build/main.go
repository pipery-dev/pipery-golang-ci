package main

import "fmt"

func main() {
	// Intentional compile error: wrong type, undefined variable
	var x int = "this is not an int"  // type error
	fmt.Println(undefinedVar)          // undefined var
	_ = x
}
