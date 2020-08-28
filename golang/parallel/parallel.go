package parallel

import (
	"math"
	"time"

	"github.com/MicaTravica/ntp/golang/savematrix"
	"github.com/MicaTravica/ntp/golang/util"
)

type resultP struct {
	Num    int
	Matrix [][]float64
}

func pMatrix(n int, mtx [][][]float64, chanals map[string]chan []float64, num int, main chan resultP, saveMatrix savematrix.SaveMatrix) {
	pSize := len(mtx[0][0])
	for t := 0; t < n; t++ {
		util.AddAndMultiply(mtx[2], mtx[0], mtx[1], pSize)
		saveMatrix.AddToCParallel(mtx[2], num, t)
		if t == n-1 {
			main <- resultP{num, mtx[2]}
			break
		}
		d1 := make([]float64, pSize)
		for i := 0; i < pSize; i++ {
			d1[i] = mtx[0][i][0]
		}
		chanals["dest1"] <- d1
		chanals["dest2"] <- mtx[1][0]
		s1 := <-chanals["source1"]
		for i := 0; i < pSize; i++ {
			mtx[0][i] = append(mtx[0][i][1:], s1[i])

		}
		s2 := <-chanals["source2"]
		mtx[1] = append(mtx[1][1:], s2)

	}
}

// Parallel matrix multiplication
func Parallel(n, p int) {
	matrix1, matrix2 := util.CreateMatrix2(n)

	saveMatrix := savematrix.SaveMatrix{}
	saveMatrix.CrateSaveMatrix(matrix1, matrix2, p)

	start := time.Now()

	result := make([][]float64, n)
	for i := range result {
		result[i] = make([]float64, n)
		for j := range result[i] {
			result[i][j] = 0
		}
	}

	pSqrt := int(math.Sqrt(float64(p)))
	pSize := int(n / pSqrt)

	chanals := make([][][]chan []float64, pSqrt)
	for i := range chanals {
		chanals[i] = make([][]chan []float64, pSqrt)
		for j := range chanals[i] {
			chanals[i][j] = make([]chan []float64, 2)
			for k := range chanals[i][j] {
				chanals[i][j][k] = make(chan []float64, 1)
			}
		}
	}
	main := make(chan resultP)
	for i := 0; i < pSqrt; i++ {
		for j := 0; j < pSqrt; j++ {
			mtx := make([][][]float64, 3)
			chs := make(map[string]chan []float64)
			mtx[0] = make([][]float64, pSize)
			mtx[1] = make([][]float64, pSize)
			mtx[2] = make([][]float64, pSize)
			row := i * pSize
			col := j * pSize
			for r := row; r < row+pSize; r++ {
				rM := r % pSize
				mtx[0][rM] = make([]float64, pSize)
				mtx[1][rM] = make([]float64, pSize)
				mtx[2][rM] = make([]float64, pSize)
				for c := col; c < col+pSize; c++ {
					cM := c % pSize
					mtx[0][rM][cM] = matrix1[r][(c+r)%n]
					mtx[1][rM][cM] = matrix2[(r+c)%n][c]
				}
			}
			chs["dest1"] = chanals[i][(j-1+pSqrt)%pSqrt][0]
			chs["dest2"] = chanals[(i-1+pSqrt)%pSqrt][j][1]
			chs["source1"] = chanals[i][j][0]
			chs["source2"] = chanals[i][j][1]
			go pMatrix(n, mtx, chs, i*pSqrt+j, main, saveMatrix)
		}
	}
	for t := 0; t < p; t++ {
		rp := <-main
		for k := 0; k < pSize; k++ {
			i := rp.Num/pSqrt*pSize + k
			j := rp.Num % pSqrt * pSize
			result[i] = append(append(result[i][:j], rp.Matrix[k]...), result[i][j+pSize:]...)
		}
	}
	elapsed := time.Since(start)

	util.PrintResult(result, elapsed)
	saveMatrix.WriteToFile()
}
