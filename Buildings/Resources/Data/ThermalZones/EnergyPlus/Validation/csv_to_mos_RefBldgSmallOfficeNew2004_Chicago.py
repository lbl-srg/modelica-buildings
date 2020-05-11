import pandas as pd
import os
import sys

data_file = os.path.join('EnergyPlus', 'eplusout.csv')
dat_fil = "RefBldgSmallOffice.dat"

df = pd.read_csv(data_file, delimiter=',')

column_names = ( df.columns.tolist() )
#print("\n".join(column_names))

# Step-1.0 read data into dictionary with lists
di = [
       {"name": "Time in seconds"},
       {"name": "Environment:Site Outdoor Air Drybulb Temperature [C](TimeStep)"},
       {"name": "Environment:Site Outdoor Air Relative Humidity [%](TimeStep)"},
       {"name": "ATTIC:Zone Mean Air Temperature [C](TimeStep)"},
       {"name": "CORE_ZN:Zone Mean Air Temperature [C](TimeStep)"},
       {"name": "PERIMETER_ZN_1:Zone Mean Air Temperature [C](TimeStep)"},
       {"name": "PERIMETER_ZN_2:Zone Mean Air Temperature [C](TimeStep)"},
       {"name": "PERIMETER_ZN_3:Zone Mean Air Temperature [C](TimeStep)"},
       {"name": "PERIMETER_ZN_4:Zone Mean Air Temperature [C](TimeStep)"},
     ]


for i in range(len(di)):
    name = di[i]['name']

    if name != "Time in seconds":

        found = False
        for x in column_names:
            if name == x:
               # Round and store in list
               di[i].update(x = [f"{ele:.3e}" for ele in df[x].values])
               found = True
               break
        if not found:
            raise ValueError(f"Failed to find output series {name}")

# Step-2.0 make timesteps, because energyplus timesteps is not in seconds
# timestep size in EnergyPlus is 10 minutes = 600 seconds
step_size = 600 # seconds
tot_steps = int (7*24*3600 / step_size )
print("steps {}".format(tot_steps))
time_seconds=[]
for y in range(tot_steps):
    time_seconds.append( y * step_size)
di[0]['x'] = time_seconds

#step-3.0 organizing data together
data=[]
for i in range(tot_steps):
    rowdata = []
    for ele in di:
        if len(rowdata) > 0:
            rowdata.append(",")
        rowdata.append(ele['x'][i])
    data.append(rowdata)


# Step-4.0 making headdata together
headdata=[]
headdata.append("#1")
headdata.append(f"double EnergyPlus({tot_steps},{len(di)})")
headdata.append("#This file contains the results from the EnergyPlus simulation of RefBldgSmallOfficeNew2004.idf for Chicago")

i = 0
for ele in di:
    headdata.append(f"#Column {i}: {ele['name']}")
    i = i + 1


# Step-5: writing data to file
if os.path.exists(dat_fil):
    os.remove(dat_fil)

with open(dat_fil, "a") as f:
    for x in headdata:
        f.write(f"{x}\n")
    for i in range(tot_steps):
        each_row = data[i][:]
        for y in each_row:
            f.write(f"{y}")
        f.write("\n")

