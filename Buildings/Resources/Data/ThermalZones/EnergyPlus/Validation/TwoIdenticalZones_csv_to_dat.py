import pandas as pd
import os

data_file = "TwoIdenticalZones.csv"
df = pd.read_csv(data_file, delimiter=',')

column_names = ( df.columns.tolist() )
print (column_names)

# Step-1.0 read data into list: drybulb-temp, wetbulb-temp, zone-temp, zone-humidity
for x in column_names:
    if "Drybulb" in x:
        OAT_Drybulb = df[x].values
    elif "Wetbulb" in x:
        OAT_Wetbulb = df[x].values
    elif "THERMAL ZONE 1:Zone Air Temperature [C](TimeStep)" in x:
        ZoneT = df[x].values
    elif "THERMAL ZONE 1:Zone Air Relative Humidity [%](TimeStep)" in x:
        ZoneH = df[x].values
    else:
        pass

# Step-2.0 make timesteps, because energyplus timesteps is not in seconds
# timestep size in EnergyPlus is 10 minutes = 600 seconds
step_size = 600 # seconds
tot_steps = int (7*24*3600 / step_size )
print("steps {}".format(tot_steps))
time_seconds=[]
for y in range(tot_steps):
    time_seconds.append( y * step_size)


#step-3.0 organizing data together
data=[]
for i in range(tot_steps):
    rowdata = []
    rowdata.append(time_seconds[i])
    rowdata.append(",")
    rowdata.append(OAT_Drybulb[i])
    rowdata.append(",")
    rowdata.append(OAT_Wetbulb[i])
    rowdata.append(",")
    rowdata.append(ZoneT[i])
    rowdata.append(",")
    rowdata.append(ZoneH[i])
    data.append(rowdata)


# Step-4.0 making headdata together
headdata=[]
headdata.append("#1\n")
headdata.append("double EnergyPlus({},5)\n".format(tot_steps))
headdata.append("#This file contains the results from the EnergyPlus simulation of TwoIdenticalZones.idf for Chicago\n")
headdata.append("#Column 1: Time in seconds\n")
headdata.append("#Column 2: Outdoor drybulb temperature in degC\n")
headdata.append("#Column 3: Outdoor wetbulb temperature in degC\n")
headdata.append("#Column 4: Zone 1 and 2 temperature in degC\n")
headdata.append("#Column 5: Zone 1 and 2 relative humidity in percentage\n")

# Step-5: writing data to file
if os.path.exists("TwoIdenticalZones.dat"):
    os.remove("TwoIdenticalZones.dat")

with open("TwoIdenticalZones.dat", "a") as f:
    for x in headdata:
        f.write("%s" % x)
    for i in range(tot_steps):
        each_row = data[i][:]
        for y in each_row:
            f.write("%s" % y)
        f.write("\n")
