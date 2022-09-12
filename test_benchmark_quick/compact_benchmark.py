import os

BASE_PATH = "./benchmark"

file_benchmark = open("./benchmark.csv", "w")


for n in range(4,7) :

    for part in ["a"] :
        file_name = '{root_path}/times_n{n}.part_{part}.csv'.format(root_path=BASE_PATH,n=n, part=part)
        print(file_name)

        f_csv = open(file_name, "r")
        content = f_csv.read()

        if part != "a":
            file_benchmark.write(";")
        else:
            file_benchmark.write(str(n) + ";")

        file_benchmark.write(content)

    file_benchmark.write("\n")

file_benchmark.close()
