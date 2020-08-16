import math
import json
import copy


class SaveMatrix:

    def __init__(self, a, b, p=1):
        self.n = len(a)
        self.a = copy.deepcopy(a)
        self.b = copy.deepcopy(b)
        self.c = [[] * self.n for _ in range(self.n)]
        self.p = p
        self.p_sqrt = int(math.sqrt(p))
        self.p_size = int(self.n / self.p_sqrt)

    def add_to_c_sequential(self, c, init=False):
        for i in range(self.n):
            for j in range(self.n):
                if init:
                    self.c[i].append([c[i % self.p_size][j % self.p_size]])
                else:
                    self.c[i][j].append(c[i % self.p_size][j % self.p_size])

    def add_to_c_parallel(self, c, p_num):
        first_index1 = (p_num - 1) // self.p_sqrt * self.p_size
        last_index1 = first_index1 + self.p_size
        first_index2 = (p_num - 1) % self.p_sqrt * self.p_size
        last_index2 = first_index2 + self.p_size
        for i in range(first_index1, last_index1):
            for j in range(first_index2, last_index2):
                self.c[i].append([c[0][i % self.p_size][j % self.p_size]])
                for t in range(1, self.n):
                    self.c[i][j].append(c[t][i % self.p_size][j % self.p_size])

    def to_json_file(self):
        with open('matrix.json', 'w') as f:
            f.write(json.dumps(self.__dict__))
