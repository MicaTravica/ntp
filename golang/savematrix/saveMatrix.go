package savematrix

import (
	"log"
	"math"
	"os"
	"strconv"
	"sync"
)

// SaveMatrix for json file
type SaveMatrix struct {
	N     int
	A     [][]float64
	B     [][]float64
	C     [][][]float64
	P     int
	PSqrt int
	PSize int
	mux   sync.Mutex
}

// CrateSaveMatrix - constructor
func (saveMatrix *SaveMatrix) CrateSaveMatrix(m1, m2 [][]float64, p int) {
	n := len(m1)
	sqrt := int(math.Sqrt(float64(p)))
	size := int(n / sqrt)

	a := make([][]float64, n)
	b := make([][]float64, n)
	c := make([][][]float64, n)
	for i := range c {
		a[i] = make([]float64, n)
		b[i] = make([]float64, n)
		c[i] = make([][]float64, n)
		for j := range c[i] {
			a[i][j] = m1[i][j]
			b[i][j] = m2[i][j]
			c[i][j] = make([]float64, n)
		}
	}
	saveMatrix.N = n
	saveMatrix.A = a
	saveMatrix.B = b
	saveMatrix.C = c
	saveMatrix.P = p
	saveMatrix.PSqrt = sqrt
	saveMatrix.PSize = size
}

func (saveMatrix *SaveMatrix) toJSON() string {
	json := "{ \"n\": " + strconv.Itoa(saveMatrix.N) + ", \"a\": "
	jsonA := "["
	jsonB := "["
	jsonC := "["
	for i := 0; i < saveMatrix.N; i++ {
		jsonA = jsonA + "["
		jsonB = jsonB + "["
		jsonC = jsonC + "["
		for j := 0; j < saveMatrix.N; j++ {
			jsonA = jsonA + strconv.FormatFloat(saveMatrix.A[i][j], 'f', -1, 64)
			jsonB = jsonB + strconv.FormatFloat(saveMatrix.B[i][j], 'f', -1, 64)
			jsonC = jsonC + "["
			for t := 0; t < saveMatrix.N; t++ {
				jsonC = jsonC + strconv.FormatFloat(saveMatrix.C[i][j][t], 'f', -1, 64)
				if t < saveMatrix.N-1 {
					jsonC = jsonC + ","
				}
			}
			jsonC = jsonC + "]"
			if j < saveMatrix.N-1 {
				jsonA = jsonA + ","
				jsonB = jsonB + ","
				jsonC = jsonC + ","
			}
		}
		jsonA = jsonA + "]"
		jsonB = jsonB + "]"
		jsonC = jsonC + "]"
		if i < saveMatrix.N-1 {
			jsonA = jsonA + ","
			jsonB = jsonB + ","
			jsonC = jsonC + ","
		}
	}
	jsonA = jsonA + "]"
	jsonB = jsonB + "]"
	jsonC = jsonC + "]"
	json = json + jsonA + ", \"b\": " + jsonB + ", \"c\": " + jsonC
	json = json + ", \"p\": " + strconv.Itoa(saveMatrix.P) + ", \"p_sqrt\": " + strconv.Itoa(saveMatrix.PSqrt) + ", \"p_size\": " + strconv.Itoa(saveMatrix.PSize) + "}"
	return json
}

// WriteToFile - write json object to file
func (saveMatrix *SaveMatrix) WriteToFile() {
	f, err := os.Create("matrix.json")

	if err != nil {
		log.Fatal(err)
	}

	defer f.Close()

	_, err2 := f.WriteString(saveMatrix.toJSON())

	if err2 != nil {
		log.Fatal(err2)
	}
}

// AddToCSequential - adding result by iterations
func (saveMatrix *SaveMatrix) AddToCSequential(c [][]float64, iter int) {
	for i := 0; i < saveMatrix.N; i++ {
		for j := 0; j < saveMatrix.N; j++ {
			saveMatrix.C[i][j][iter] = c[i][j]
		}
	}
}

// AddToCParallel - adding result by iterations
func (saveMatrix *SaveMatrix) AddToCParallel(c [][]float64, pNum, iter int) {
	saveMatrix.mux.Lock()
	firstIndex1 := pNum / saveMatrix.PSqrt * saveMatrix.PSize
	lastIndex1 := firstIndex1 + saveMatrix.PSize
	firstIndex2 := pNum % saveMatrix.PSqrt * saveMatrix.PSize
	lastIndex2 := firstIndex2 + saveMatrix.PSize
	for i := firstIndex1; i < lastIndex1; i++ {
		for j := firstIndex2; j < lastIndex2; j++ {
			saveMatrix.C[i][j][iter] = c[i%saveMatrix.PSize][j%saveMatrix.PSize]
		}
	}
	saveMatrix.mux.Unlock()
}
