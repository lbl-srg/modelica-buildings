import os
import numpy as np
import pandas as pd
import datetime
from dateutil import parser

import logging
log = logging.getLogger(__name__)
log.setLevel(logging.DEBUG)

from pdb import set_trace as bp



def trend_data_csv2mos(path2csv, outpath, earliest_timestamp_string):
    """Converts trend data downloaded from the ALC webserver from csv to mos
    readable by the Modelica data reader. The first column in the mos file
    is the time in seconds elapsed starting from the desired earliest
    timestamp (relative timestamp).

    CSV data contains columns:
    - "Date" : a string datastamp
    - "Excel Time" : excel time timestamp
    - "Value" : value at each timestamp
    - "Notes" : string comment

    Parameters
    ----------
    path2csv : str
        Path to the csv file

    outpath : str
        Path for the output mos file

    earliest_timestamp_string : str
        Starting timestamp for the mos file. Use the format identical to the
        one provided in the csv ("Date" column).
        Values between the timestamps are allowed. Values before the first
        timestamp in the csv file are to be used with caution.
        In detail:
        - If the csv file contains timestamps before the
        `earliest_timestamp_string`, those will be excluded from the mos file
        - If the csv file starts with a timestamp occuring after the
        `earliest_timestamp_string`, the value from the first available
        timestamp will be prepended to the data as the new earliest
        timestamp, along with a warning that this type of extrapolation has
        been performed. This may be useful if the user is certain off the
        status of the variable (e.g. it is known that the fan was on)
        - If the csv file has a timestep such that the `earliest_timestamp_s`
        is not listed, but there exist both timestamps before and after the
        `earliest_timestamp_s`, all values before the `earliest_timestamp_s`
        are removed, `earliest_timestamp_s` is prepended and populated with
        a first available value recorded before it.

    Notes
    -----
    Units are the same as in the csv file, for data from ALC web server:
        - T [F]
        - Flow [cfm]
        - Status [%]

    Example
    -------
    inpath = "//csv//OA Temp.csv"
    mospath = "//mos//"
    starting_timestamp = "6/7/2018 00:00:00 PDT"

    # run the conversion

    >>> trend_data_csv2mos(inpath, mospath, starting_timestamp)
    """
    # read in the csv file, including the leading rows containing the trend info
    raw_data_for_names = pd.read_csv(path2csv, header = 0)

    # convert the string earliest_timestamp_string to seconds (unix time)
    earliest_timestamp_s = return_unix_time(earliest_timestamp_string)

    # set mos filename
    outfilename = raw_data_for_names.columns[\
        0].replace(" ", "_").replace('_/_','_') + '.mos'
    # set mos table name
    tablename = raw_data_for_names.columns[\
        0].split("/")[-1].strip().replace(" ", "_")

    # read in the csv file, get only the trends and headers
    raw_data = pd.read_csv(path2csv, header = 1)


    # Clean data and prepare timestamp for usage in the Modelica data reader

    # if there is a Notes column, drop it
    if "Notes" in raw_data.columns:
        raw_data = raw_data.drop("Notes", axis = 1)

    # we use the string timestamp, so drop the excel date:
    if "Excel Time" in raw_data.columns:
        raw_data = raw_data.drop("Excel Time", axis = 1)

    # drop missing values, data reader interpolation will fill it
    # with the values recorded in the previous timestep
    for column_label in raw_data.columns:
        null_values_index = pd.isnull(raw_data[column_label]) == True
        rows_to_drop = null_values_index.index[null_values_index]
        data = raw_data.drop(rows_to_drop)


    # Synchronize timeseries and create a relative timestamp

    # create a timestamp array in unix time from the string timestamp
    time_in_s = np.vectorize(return_unix_time)(data["Date"])
    data['Unix_Time'] = time_in_s
    data = data.reindex(data.columns[-1:].append( \
        data.columns[:-1]), axis = 1)

    # get the first timestamp provided in the recorded trend
    time_in_s_0 = parser.parse(data.loc[0, "Date"]).timestamp()

    # remove any data recorded prior to the desired earliest timestamp,
    # if they exist, but save the last value before the earliest timestamp
    # if the earliest timestamp is not explicitly provided (due to timestep
    # differences)
    if time_in_s_0 < earliest_timestamp_s:
        # exclude
        excluded_data = data.loc[data['Unix_Time'] < earliest_timestamp_s, \
            :].reset_index(drop = True)
        last_excluded_row = excluded_data.loc[
            excluded_data.shape[0]-1:,:]
        # keep
        data = data.loc[data['Unix_Time']>=earliest_timestamp_s, \
            :].reset_index(drop = True)

        # if earliest_timestamp_s is between the provided timestamps
        # append it and populate with the first recorded value occuring
        # before it
        if data.loc[0,'Unix_Time'] != earliest_timestamp_s:
            # move data 1 row down
            data = pd.DataFrame(
                data.loc[:0,:]).append(data).reset_index(drop = True)
            data.loc[0,'Unix_Time'] = earliest_timestamp_s
            data.loc[0,'Date'] = earliest_timestamp_string
            for column_label in raw_data.columns[2:]:
                data.loc[0,column_label] = last_excluded_row[column_label][0]

        # check that the data starts with the earliest_timestamp_s
        if data.loc[0,'Unix_Time'] != earliest_timestamp_s:
            message = \
            'The data does not start with the required ' \
            'earliest_timestamp_s, but with {}'
            log.error(message.format(data.loc[0,'Unix_Time']))


    # extrapolate initial value backwards to earliest timestamp and warn user
    if time_in_s_0 > earliest_timestamp_s:
        # move data a row down
        data = pd.DataFrame(
            data.loc[:0,:]).append(data).reset_index(drop = True)
        # fill in the new 0th row with values from the 1st row
        for column_label in raw_data.columns:
            data.loc[0,column_label] = data.loc[1,column_label]
        # replace the timestamp (string and unix) in the 0th row
        # with the earliest timestamp
        data.loc[0,"Date"] = earliest_timestamp_string
        data.loc[0,"Unix_Time"] = earliest_timestamp_s
        # update the time in s
        time_in_s = np.vectorize(return_unix_time)(data["Date"])
        # notify user
        message = 'Note that data before the first recorded timestamp ' \
                  'has been extrapolated backwards using values from ' \
                  'the first available timestamp. Make sure that ' \
                  'this is a suitable substitute.'
        log.warning(message)

    # create time elapsed from the `earliest_timestamp_string`, in seconds
    # initiate column
    data["Seconds_Delta"] = 0
    # update the timestamp in seconds array
    time_in_s = np.vectorize(return_unix_time)(data["Date"])

    # populate with the time elapsed and reindex
    data.loc[1:,"Seconds_Delta"] = time_in_s[1:] - time_in_s[:-1]
    data["Seconds_Elapsed"] = data["Seconds_Delta"].cumsum(axis = 0)
    data = data.reindex(data.columns[-1:].append( \
        data.columns[:-1]), axis = 1)

    # drop "Date" and "Seconds_Delta" column and reorder columns
    data = data.drop(["Date", "Seconds_Delta"], axis = 1)

    # make sure mos file contains only floats
    try:
        data = data.astype(float)
    except:
        message = "Some fields cannot be converted to floats."
        log.error(message)

    # write mos file
    print(write_mos(outpath + outfilename, tablename, data))


def return_unix_time(timestamp_string):
    """Converts a string timestamp into a float timestamp in
    seconds.

    Parameters
    ----------
    timestamp_string : str
        String timestamp in a human-readable format.

    Returns
    -------
    float unix time timestamp, s
    """
    return parser.parse(timestamp_string).timestamp()


def write_mos(outfilepath, tablename, data):
    """Writes contents to mos file with
    appropriate header information

    Parameters
    ----------
    outfilepath : str
        Path to *.mos file, including the filename and the mos extension

    tablename : str
        Table name to be entered into the data reader

    data : array
        Comma-separated rows for each time instance containing timestamp and
        any data recorded
    """

    file = open(outfilepath,"w")

    file.write("#1\n")
    file.write("# Recorded trend: " + outfilepath + "\n")
    file.write("# Columns: " + ', '.join(list(data.columns)) + "\n")
    file.write("double " + tablename + str(data.shape) + "\n")
    for inx, row in data.iterrows():
        file.write(', '.join(list(row.astype(str))) + "\n")

    file.close()

    return "Wrote " + outfilepath + ".\n"


## Script to convert all trend csv files for the validation example study
## 5s data, June 18
#ahu_id_1 = ""
#ahu_id_2 = ""
#ahu_id_3 = ""
#filenames = [ahu_id_2 + " VFD Fan Enable.csv", \
#             ahu_id_2 + " VFD Fan Feedback.csv", "OA Temp.csv", ahu_id_1 + " Supply Air Temp.csv", \
#             "SA Clg Stpt.csv", ahu_id_3 + " Clg Coil Valve.csv"]
#
#folderpath = ""
#outpath = ""
#
#starting_timestamp = "6/7/2018 00:00:00 PDT"
#
#for filename in filenames:
#    print("Initiated: ", filename)
#    path = folderpath + filename
#    print(path)
#    trend_data_csv2mos(path, outpath, starting_timestamp)
