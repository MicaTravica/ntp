import random


def print_matrix(matrix):
    for m_i in range(0, len(matrix)):
        print(" ".join("{0:10}".format(m_j) for m_j in matrix[m_i]))


def insert_number(text):
    while True:
        try:
            num = int(input(text))
            break
        except ValueError:
            print("Try again, must be number!")
    return num


def create_matrix(m_size, name):
    print("Creating " + name + " matrix:\n"
                               "1. Manually\n"
                               "2. Random\n"
                               "3. From 1 to n*n\n"
                               "4. All 1\n"
                               "5. 1 on diagonal\n")
    while True:
        t = insert_number("Insert the option: ")
        if t == 1:
            matrix = []
            for m_i in range(0, m_size):
                matrix.append([])
                for m_j in range(0, m_size):
                    matrix[m_i].append(insert_number("Insert number row {0} column {1}: ".format(m_i, m_j)))
            break
        elif t == 2:
            matrix = [[random.randint(-(m_size ** 2), m_size ** 2) for _ in range(m_size)] for _ in range(m_size)]
            break
        elif t == 3:
            matrix = [list(range(1 + m_size * m_i, 1 + m_size * (m_i + 1))) for m_i in range(m_size)]
            break
        elif t == 4:
            matrix = [[1] * m_size for _ in range(m_size)]
            break
        elif t == 5:
            matrix = [[0] * m_i + [1] + [0] * (m_size - m_i - 1) for m_i in range(m_size)]
            break
        else:
            print("Must insert number from 1 to 5!")
    return matrix


def create_2matrix(size):
    matrix1 = create_matrix(size, "first")
    matrix2 = create_matrix(size, "second")

    print("First matrix: ")
    print_matrix(matrix1)
    print("Second matrix: ")
    print_matrix(matrix2)

    return matrix1, matrix2


def add_and_multiply(result_mtx, mtx1, mtx2, m_size):
    for m_i in range(0, m_size):
        for m_j in range(0, m_size):
            result_mtx[m_i][m_j] += mtx1[m_i][m_j] * mtx2[m_i][m_j]


def print_result(matrix, time):
    print("Result:")
    print_matrix(matrix)
    print("Time: ")
    print(time)
