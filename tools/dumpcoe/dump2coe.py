try:
    with open('hex.txt', 'r') as hexfile:
        hexlines = list(map(lambda line: line[:-1], hexfile.readlines()))
except FileNotFoundError:
    print('Error occured during assembly.')
    print('')
    print('--- MARS output ---')
    with open('mars.out', 'r') as marsout:
        print(marsout.read())
    exit()

lines = ['memory_initialization_radix=16;', 'memory_initialization_vector=']

for i, line in enumerate(hexlines):
    if (i == len(hexlines) -1):
        lines.append(line + ';')
    else:
        lines.append(line + ',')

with open('test.coe', 'w') as coefile:
    coefile.write('\n'.join(lines))