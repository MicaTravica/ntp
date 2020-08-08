import time
from util import create_2matrix, add_and_multiply, print_result


def multiply(mtx1, mtx2, m_size):
    mtx3 = [[0] * m_size for _ in range(m_size)]
    for m_i in range(0, m_size):
        for m_j in range(0, m_size):
            mtx3[m_i][m_j] = mtx1[m_i][m_j] * mtx2[m_i][m_j]
    return mtx3


def sequential(size):
    matrix1, matrix2 = create_2matrix(size)

    start_time = time.time()
    # inicijalizacija matrica
    for i in range(1, size):
        matrix1[i] = matrix1[i][i:] + matrix1[i][:i]

        n = [matrix2[(j + i) % size][i] for j in range(0, size)]
        for j in range(0, size):
            matrix2[j][i] = n[j]

    result_matrix = multiply(matrix1, matrix2, size)

    for _ in range(1, size):
        for i in range(0, size):
            matrix1[i] = matrix1[i][1:] + matrix1[i][:1]
        matrix2 = matrix2[1:] + matrix2[:1]
        add_and_multiply(result_matrix, matrix1, matrix2, size)

    end_time = time.time()
    print_result(result_matrix, end_time - start_time)
