from mpi4py import MPI
import sys
import time
import math
import copy
from util import create_2matrix, add_and_multiply, print_result
from save_matrix import SaveMatrix

if __name__ == '__main__':
    comm = MPI.COMM_WORLD
    p = comm.Get_size()
    rank = comm.Get_rank()

    p_sqrt = int(math.sqrt(p-1))
    m_size = int(sys.argv[1])
    p_size = int(m_size / p_sqrt)
    if rank == 0:
        matrix1, matrix2 = create_2matrix(m_size)
        save_matrix = SaveMatrix(matrix1, matrix2, p-1)
        start_time = time.time()
        matrix = [[0] * m_size for _ in range(m_size)]
        for i in range(p_sqrt):
            for j in range(p_sqrt):
                dest = p_sqrt * i + j + 1
                row = p_size * i
                col = p_size * j
                mtx1 = []
                mtx2 = []
                for r in range(row, row + p_size):
                    mtx1.append([])
                    mtx2.append([])
                    for c in range(col, col + p_size):
                        mtx1[r % p_size].append(matrix1[r][(c + r) % m_size])
                        mtx2[r % p_size].append(matrix2[(r + c) % m_size][c])
                mtx3 = [matrix[r][j * p_size:j * p_size + p_size] for r in range(i * p_size, i * p_size + p_size)]
                data = [mtx1, mtx2, mtx3]
                # data = [mtx1, mtx2, [[0] * p_size for i in range(p_size)]]
                comm.send(data, dest=dest, tag=dest)

        for i in range(p_sqrt):
            for j in range(p_sqrt):
                dest = p_sqrt * i + j + 1
                mtx = comm.recv(source=dest, tag=dest)
                for k in range(p_size):
                    matrix[i * p_size + k][j * p_size: j * p_size + p_size] = mtx[m_size-1][k]
                save_matrix.add_to_c_parallel(mtx, dest)

        end_time = time.time()
        print_result(matrix, end_time - start_time)
        save_matrix.to_json_file()
    else:
        data = comm.recv(source=0, tag=rank)
        r_one = rank - 1
        r_size = rank - p_sqrt
        x = rank + 1
        y = rank + p_sqrt
        p_sqrt_2 = p_sqrt ** 2
        dest1 = r_one if r_one % p_sqrt != 0 else r_one + p_sqrt
        dest2 = r_size if r_size > 0 else p_sqrt_2 + r_size
        source1 = x if rank % p_sqrt != 0 else x - p_sqrt
        source2 = y if y <= p_sqrt_2 else y - p_sqrt_2
        init = True
        all_iter = []
        for t in range(m_size):
            add_and_multiply(data[2], data[0], data[1], len(data[0]))
            all_iter.append(copy.deepcopy(data[2]))
            if t == 0:
                init = False
            if t == m_size - 1:
                break
            comm.send([i[0] for i in data[0]], dest=dest1, tag=dest1)
            comm.send(data[1][0], dest=dest2, tag=dest2)
            new_col = comm.recv(source=source1, tag=rank)
            for i in range(p_size):
                data[0][i] = data[0][i][1:] + [new_col[i]]
            new_row = comm.recv(source=source2, tag=rank)
            data[1] = data[1][1:] + [new_row]
        req = comm.send(all_iter, dest=0, tag=rank)
