#!/usr/bin/env python3

def energyplus_csv_to_mos(output_list, dat_file_name):

    import pandas as pd
    import os
    import sys

    data_file = os.path.join('EnergyPlus', 'eplusout.csv')


    df = pd.read_csv(data_file, delimiter=',')

    column_names = ( df.columns.tolist() )
    #print("\n".join(column_names))

    # Step-1.0 read data into dictionary with lists
    di = []

    for name in output_list:
        found = False
        for x in column_names:
            if name == x:
               # Round and store in list
               di.append({"name": name, "x": [f"{ele:.3e}" for ele in df[x].values]})
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

    # Insert time in the front
    di.insert(0, {"name": "Time in seconds", 'x': time_seconds})

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
    headdata.append("#This file contains the results from the EnergyPlus simulation")

    i = 0
    for ele in di:
        headdata.append(f"#Column {i}: {ele['name']}")
        i = i + 1


    # Step-5: writing data to file
    if os.path.exists(dat_file_name):
        os.remove(dat_file_name)

    with open(dat_file_name, "a") as f:
        for x in headdata:
            f.write(f"{x}\n")
        for i in range(tot_steps):
            each_row = data[i][:]
            for y in each_row:
                f.write(f"{y}")
            f.write("\n")

