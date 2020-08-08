package util

import (
	"fmt"
	"math/rand"
	"strconv"
	"time"
)

func printMatrix(mtx [][]float64) {
	for i := range mtx {
		for j := range mtx[i] {
			fmt.Printf("%g ", mtx[i][j])
		}
		fmt.Println()
	}
}

// InsertNumber returns int
func InsertNumber(text string) int {
	var s string
	var i int
	for {
		fmt.Println(text)
		_, err := fmt.Scan(&s)
		i, err = strconv.Atoi(s)
		if err != nil {
			fmt.Println("Try again, must be number!")
		} else {
			break
		}
	}
	return i
}

func insertNumberFloat(text string) float64 {
	var s string
	var i float64
	for {
		fmt.Println(text)
		_, err := fmt.Scan(&s)
		i, err = strconv.ParseFloat(s, 64)
		if err != nil {
			fmt.Println("Try again, must be number!")
		} else {
			break
		}
	}
	return i
}

func createMatrixBase(n int, fun func(int, int, int) float64) [][]float64 {
	matrix := make([][]float64, n)
	for i := range matrix {
		matrix[i] = make([]float64, n)
		for j := range matrix[i] {
			matrix[i][j] = fun(i, j, n)
		}
	}
	return matrix
}

func manually(i, j, n int) float64 {
	return insertNumberFloat(fmt.Sprintf("Insert number row %d column %d: ", i, j))
}

func random(i, j, n int) float64 {
	return rand.Float64()
}

func m1toN(i, j, n int) float64 {
	return float64(i*n + j + 1)
}

func ones(i, j, n int) float64 {
	return 1
}

func diagonal(i, j, n int) float64 {
	if i == j {
		return 1
	}
	return 0
}

func createMatrix(n int, name string) [][]float64 {
	fmt.Println("Crating " + name + " matrix:\n" +
		"1. Manually\n" +
		"2. Random\n" +
		"3. From 1 to n*n\n" +
		"4. All ones\n" +
		"5. One on diagonal\n")
	var matrix [][]float64 = nil
	for {
		t := InsertNumber("Insert the option: ")
		var fun func(i, j, n int) float64
		switch t {
		case 1:
			fun = manually
		case 2:
			fun = random
		case 3:
			fun = m1toN
		case 4:
			fun = ones
		case 5:
			fun = diagonal
		default:
			fmt.Println("Must insert number from 1 to 5!")
		}
		if fun != nil {
			matrix = createMatrixBase(n, fun)
		}
		if matrix != nil {
			break
		}
	}
	return matrix
}

// CreateMatrix2 manualy or automaticaly creating two matrix
func CreateMatrix2(n int) (matrix1, matrix2 [][]float64) {
	matrix1 = createMatrix(n, "first")
	matrix2 = createMatrix(n, "second")

	fmt.Println("First matrix:")
	printMatrix(matrix1)
	fmt.Println("Second matrix:")
	printMatrix(matrix2)

	return
}

// AddAndMultiply first two matrix multiply by cell and add to third matrix sell
func AddAndMultiply(resultMtx [][]float64, mtx1 [][]float64, mtx2 [][]float64, n int) {
	for i := 0; i < n; i++ {
		for j := 0; j < n; j++ {
			resultMtx[i][j] += mtx1[i][j] * mtx2[i][j]
		}
	}
}

// PrintResult matrix and time
func PrintResult(matrix [][]float64, time time.Duration) {
	fmt.Println("Result: ")
	printMatrix(matrix)
	fmt.Println("Time: ")
	fmt.Println(time)
}
