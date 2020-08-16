package sequential

import (
	"time"

	"github.com/MicaTravica/ntp/golang/savematrix"
	"github.com/MicaTravica/ntp/golang/util"
)

func multiply(mtx1 [][]float64, mtx2 [][]float64, n int) [][]float64 {
	mtx3 := make([][]float64, n)
	for i := range mtx3 {
		mtx3[i] = make([]float64, n)
		for j := 0; j < n; j++ {
			mtx3[i][j] = mtx1[i][j] * mtx2[i][j]
		}
	}
	return mtx3
}

// Sequential matrix multiplication
func Sequential(n int) {

	matrix1, matrix2 := util.CreateMatrix2(n)

	saveMatrix := savematrix.SaveMatrix{}
	saveMatrix.CrateSaveMatrix(matrix1, matrix2, 1)

	start := time.Now()

	for i := 0; i < n; i++ {
		matrix1[i] = append(matrix1[i][i:], matrix1[i][:i]...)
		a := make([]float64, n)
		for j := 0; j < n; j++ {
			a[j] = matrix2[(j+i)%n][i]
		}
		for j := 0; j < n; j++ {
			matrix2[j][i] = a[j]
		}
	}

	resultMatrix := multiply(matrix1, matrix2, n)
	saveMatrix.AddToCSequential(resultMatrix, 0)

	for s := 1; s < n; s++ {
		for i := 0; i < n; i++ {
			matrix1[i] = append(matrix1[i][1:], matrix1[i][:1]...)
		}
		matrix2 = append(matrix2[1:], matrix2[:1]...)
		util.AddAndMultiply(resultMatrix, matrix1, matrix2, n)
		saveMatrix.AddToCSequential(resultMatrix, s)
	}

	elapsed := time.Since(start)
	util.PrintResult(resultMatrix, elapsed)
	saveMatrix.WriteToFile()
}
