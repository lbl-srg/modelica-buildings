import csv
import os

def convert_row(time, row):
    def to_K(degC):
        return float(degC) + 273.15
    data = {'time': time, \
        'TOut': to_K(row[1]), \
        'TCor': to_K(row[5]), \
        'TSou': to_K(row[6]), \
        'TEas': to_K(row[7]), \
        'TNor': to_K(row[8]), \
        'TWes': to_K(row[9]), \
        'TAtt': to_K(row[4])}
    return "{time} {TOut} {TCor} {TSou} {TEas} {TNor} {TWes}  {TAtt}".format(**data)


ent = []

nSki = 49
with open(os.path.join('EnergyPlus', 'eplusout.csv'), 'r') as csvfile:
    rows = csv.reader(csvfile, delimiter=',')
    # Skip the first 50 rows, which are the header and design days
    iRow = 0
    for row in rows:
        if iRow >= nSki:
            if iRow == nSki:
                # Enter first row twice, as E+ does not record t=0
                ent.append(convert_row(0, row))
            ent.append(convert_row((iRow-nSki)*3600, row))
        if iRow > 215:
            break
        iRow = iRow + 1
with open('RefBldgSmallOffice.dat', 'w') as out:
    out.write("#1\n")
    out.write("double EnergyPlus({}, 8)\n".format(str(len(ent))))
    for e in ent:
        out.write("{}\n".format(e))
