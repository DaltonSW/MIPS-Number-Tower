import random

def main():
        for file in range(1, 11):
            tower = []
            output = open("{}.txt".format(file), "w")

            for i in range(0, 7):
                tower.append(random.randint(1, 16))

            for i in range(0, 6):
                tower.append(tower[i] + tower[i+1])

            for i in range(7, 12):
                tower.append(tower[i] + tower[i+1])

            for i in range(13, 17):
                tower.append(tower[i] + tower[i+1])

            for i in range(18, 21):
                tower.append(tower[i] + tower[i+1])

            for i in range(22, 24):
                tower.append(tower[i] + tower[i+1])

            for i in range(25, 26):
                tower.append(tower[i] + tower[i+1])

            for i in range(27, -1, -1):
                    if tower[i] / 100 >= 1:
                            tower[i] = "{}\n".format(tower[i])

                    elif tower[i] / 10 >= 1:
                            tower[i] = "0{}\n".format(tower[i])

                    else:
                            tower[i] = "00{}\n".format(tower[i])
                    output.write(tower[i])

main()