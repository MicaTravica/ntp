package main

import (
	"fmt"
	"math"

	"github.com/MicaTravica/ntp/golang/parallel"
	"github.com/MicaTravica/ntp/golang/sequential"
	"github.com/MicaTravica/ntp/golang/util"
)

func main() {
	fmt.Println("Cannon’s algorithm for matrix multiplication")
	n := 0
	for {
		n = util.InsertNumber("Insert the matrix dimensions(nxn), just one number(n): ")
		if n > 0 {
			break
		}
		fmt.Println("Dimension must be positive integer!")
	}

	fmt.Println("Choose option:\n" +
		"1. Sequential\n" +
		"2. Parallel")
	for {
		t := util.InsertNumber("Insert the option: ")
		if t == 1 {
			sequential.Sequential(n)
			break
		} else if t == 2 {
			var p int
			for {
				p = util.InsertNumber("Insert the p: ")
				intRoot := int(math.Sqrt(float64(p)))
				divCh := float64(n) / math.Sqrt(float64(p))
				if intRoot*intRoot != p {
					fmt.Println("P must be perfect square!")
				} else if math.Trunc(divCh) != divCh {
					fmt.Println("Sqrt(p) can't divide n (size of matrix)!")
				} else {
					break
				}
			}
			parallel.Parallel(n, p)
			break
		} else {
			fmt.Println("Must insert number 1 or 2!")
		}
	}
}
