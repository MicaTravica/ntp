import math
import os
from sequential import sequential
from util import insert_number

if __name__ == '__main__':
    print("Cannon’s algorithm for matrix multiplication")
    while True:
        size = insert_number("Insert the matrix dimensions(nxn), just one number(n): ")
        if size > 0:
            break
        print("Dimension must be positive integer!")

    print("Choose option:\n"
          "1. Sequential\n"
          "2. Parallel")
    while True:
        t = insert_number("Insert the option: ")
        if t == 1:
            sequential(size)
            break
        elif t == 2:
            while True:
                p = insert_number("Insert the p: ")
                if math.sqrt(p) % 1 != 0:
                    print("P must be perfect square!")
                elif size / math.sqrt(p) % 1 != 0:
                    print("Sqrt(p) can't divide n (size of matrix)!")
                else:
                    break

            os.system("mpiexec -n {0} python -m mpi4py parallel.py {1}".format(p + 1, size))
            break
        else:
            print("Must insert number 1 or 2!")
