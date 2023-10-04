#!/usr/bin/env python3

def energyplus_csv_to_mos(output_list, dat_file_name, step_size, final_time, start_time = 0):
    """ Reads `EnergyPlus/eplusout.csv` and writes `dat_file_name`
        in the format required by the Modelica data reader.

       :param output_list: List with outputs as written in the EnergyPlus csv output file.
       :param dat_file_name: Name of `.mos` file to be written.
       :param step_size: Step size in EnergyPlus output file in seconds.
       :param final_time: Final time of the data that should be written to the `.mos` file.
       :param start_time: Start time of the data that should be written to the `.mos` file.

    """

    import pandas as pd
    import os
    import sys

    data_file = os.path.join('EnergyPlus', 'eplusout.csv')


    df = pd.read_csv(data_file, delimiter=',')
    #print("\n".join(column_names))

    column_names = df.columns.tolist()

    # EnergyPlus reports the first results after the first time step.
    # In order to have a value at time=0, we add one time step, and
    # write the results of the first time step twice to the data file.
    df = pd.concat([df.head(1), df])
    tot_steps = int ((final_time - start_time) / step_size ) + 1
    end_steps = int(final_time/step_size) + 1

    # Step-1.0 read data into dictionary with lists
    di = []

    for name in output_list:
        found = False
        for x in column_names:
            # Below, strip is needed for Resources/Data/ThermalZones/EnergyPlus/Examples/RefBldgSmallOffice
            # and EnergyPlus 9.5.0 as it adds a space in 'PERIMETER_ZN_4:Zone Mean Air Temperature [C](TimeStep) '
            cleaned_name = x.strip()
            if name == cleaned_name:
               # Round and store in list
               di.append({"name": name, "x": [f"{ele:.3e}" for ele in df[x].values]})
               found = True
               break
        if not found:
            raise ValueError(f"Failed to find output series {name}.")

    # Step-2.0 make timesteps, because energyplus timesteps are not in seconds
    time_seconds=[]
    for y in range(end_steps):
        time_seconds.append(y * step_size)

    # Insert time in the front
    di.insert(0, {"name": "Time in seconds", 'x': time_seconds})

    #step-3.0 organizing data together
    data=[]
    start_index = int(start_time/step_size)
    for i in range(tot_steps):
        rowdata = []
        for ele in di:
            if len(rowdata) > 0:
                rowdata.append(",")
            rowdata.append(ele['x'][start_index + i])
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
