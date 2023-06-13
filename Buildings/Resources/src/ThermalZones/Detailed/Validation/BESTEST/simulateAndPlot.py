#!/usr/bin/env python3

import matplotlib
matplotlib.use('Agg')

import matplotlib.pyplot as plt

import io
import json
import os
import sys
import shutil

# If true, run simulations and not only the post processing.
DO_SIMULATIONS = True
# If true, delete the simulation result files.
CLEAN_MAT = True
# If true, temporary directories will be deleted.
DelTemDir = True

CWD = os.getcwd()

# BuildingsPy working branch.
# The working branch makes the communication points ('ncp') of jmodelica or optimica to be 8761,
# so that the regression test will generate high resolution results.
BP_BRANCH = 'issue335_high_ncp'
# simulator, JModelica and optimica are supported
TOOL = 'optimica'

# standard data file
ASHRAE_DATA = './ASHRAE140_data.dat'
PACKAGE = 'Buildings.ThermalZones.Detailed.Validation.BESTEST'
CASES = ['Case600', 'Case600FF', 'Case610', 'Case620', 'Case630', 'Case640', 'Case650', 'Case650FF', \
         'Case660', 'Case670', 'Case680', 'Case680FF', 'Case685', 'Case695', \
         'Case900', 'Case900FF', 'Case910', 'Case920', 'Case930', 'Case940', 'Case950', 'Case950FF', \
         'Case960', 'Case980', 'Case980FF', 'Case985', 'Case995']

plt.rc('axes', labelsize=9)
plt.rc('xtick', labelsize=9)
plt.rc('ytick', labelsize=9)
plt.rc('legend', fontsize=9)
plt.rcParams['axes.facecolor']='whitesmoke'

def save_plot(figure, file_name):
    """ Save the figure to a pdf and png file in the directory `img`
    """

    out_dir = "../../../../../Images/ThermalZones/Detailed/Validation/BESTEST"
    if not os.path.exists(out_dir):
        os.makedirs(out_dir)
    figure.savefig(os.path.join(out_dir, '{}.pdf'.format(file_name)))
    figure.savefig(os.path.join(out_dir, '{}.png'.format(file_name)))
    plt.clf()

def configure_axes(axes):
    """ Configure the axis style
    """
    axes.spines['right'].set_linewidth(0.25)
    axes.spines['right'].set_color('lightgrey')
    axes.spines['top'].set_visible(False)
    axes.spines['left'].set_linewidth(0.25)
    axes.spines['left'].set_color('lightgrey')
    axes.spines['bottom'].set_visible(False)
    axes.grid(color='lightgrey', linewidth=0.25)
    return

def create_library_directory(repoNam):
    ''' Create directory to be as temporary directory to save library.
    '''
    import tempfile
    import getpass
    if repoNam == 'MBL':
        prefixName = 'tmp-MBL-'
    else:
        prefixName = 'tmp-BP-'
    worDir = tempfile.mkdtemp( prefix=prefixName + getpass.getuser() )
    print("Created directory {}".format(worDir))
    return worDir

def checkout_buildingspy_repository(working_directory):
    ''' Clone buildingspy repository to working directory and checkout to target branch.
    '''
    from git import Repo
    import git
    print("*** Checking out BuildingsPy repository branch {} ***".format(BP_BRANCH))
    git_url = "https://github.com/lbl-srg/BuildingsPy.git"
    repo = Repo.clone_from(git_url, working_directory)
    for sub_module in repo.submodules:
        sub_module.update()
    g = git.Git(working_directory)
    g.checkout(BP_BRANCH)

def copy_mbl(working_directory):
    ''' Copy buildings library to working directory
    '''
    # This is a hack to get the local copy of the buildings library repository
    des = working_directory
    shutil.rmtree(des)
    print("*** Copying Buildings library to {}".format(des))
    mblPath = (os.path.sep).join((os.getcwd().split(os.path.sep))[:-7])
    shutil.copytree(mblPath, des)

def _runTests(tool, package, lib_dir, bp_dir):
    ''' Run regression test, return the temporary directory path for the test.
    '''
    sys.path.insert(0, bp_dir)
    import buildingspy.development.regressiontest as u

    ut = u.Tester(tool=tool, skip_verification=True)
    ut.batchMode(True)
    ut.pedanticModelica(True)
    ut.showGUI(False)
    ut.deleteTemporaryDirectories(False)

    path = os.path.join(lib_dir, 'Buildings')

    ut.setLibraryRoot(path)
    if package is not None:
        ut.setSinglePackage(package)

    # Run the regression tests
    retVal = ut.run()
    # List of temporary directories that were used to run the simulations
    tempDir = ut._temDir

    return tempDir

def _get_results_directory(lib_dir, bp_dir):
    ''' Trigger the regression test, return the list of temporary directories of the regression tests.
    '''
    resultDirs = list()
    tempDirs = _runTests(TOOL, PACKAGE, lib_dir, bp_dir)
    for tempDir in tempDirs:
        resultDirs.append(tempDir)
    return resultDirs

def _move_results(resultDirs):
    ''' Move the mat file from the temporary directory of regression test, to current directory.
    '''
    mat_dir = os.path.join(CWD, 'mat')
    if not os.path.exists(mat_dir):
        os.makedirs(mat_dir)

    for resultDir in resultDirs:
        haveMat = False
        if (TOOL == 'optimica'):
            resultsFolder = resultDir
        else:
            resultsFolder = os.path.join(resultDir, 'Buildings')
        for file in os.listdir(resultsFolder):
            if file.endswith('.mat'):
                haveMat = True
                source = os.path.join(resultsFolder, file)
                destination = os.path.join(mat_dir, file)
                shutil.copyfile(source, destination)
        
        if not haveMat:
            raise ValueError("*** There is no result file in tmp folder: {}. Check the simulation. ***".format(resultDir))

        if DelTemDir:
            shutil.rmtree(resultDir)
            print("*** After moving the result file, deleted the temporary directory {} . ***".format(resultDir))
        else:
            print("*** After moving the result file, kept the temporary directory {} . ***".format(resultDir))
    _clean_record_files()

def _clean_record_files():
    files = os.listdir(CWD)
    for item in files:
        if item.endswith('.txt') or item.endswith('.c') \
           or item.endswith('.log') or item.endswith('sim'):
          os.remove(os.path.join(CWD, item))
        if 'funnel_comp' in item:
            shutil.rmtree(item)

def _organize_cases(mat_dir):
    ''' Create a list of dictionaries. Each dictionary include the case name and the mat file path.
    '''
    matFiles = list()
    for file in os.listdir(mat_dir):
        if file.endswith('.mat'):
            matFiles.append(file)
    caseList = list()
    if len(CASES) == len(matFiles):
        for case in CASES:
            temp = {'case': case}
            for matFile in matFiles:
                if (TOOL == 'optimica'):
                    tester = '{}_'.format(case)
                else:
                    tester = '{}.'.format(case)
                if tester in matFile:
                    temp['matFile'] = os.path.join(mat_dir, matFile)
            caseList.append(temp)
    else:
        raise ValueError("*** There is failed simulation and has no result file. Check the simulations. ***")
    return caseList

# --------------------------------------------------------------------------------------------------
# Extract needed time series data from modelica simulation results
# --------------------------------------------------------------------------------------------------
def _extract_data(matFile, relVal):
    """
    Extract time series data from mat file.

    :param matFile: modelica simulation result path
    :param relVal: list of variables that the data should be extracted
    """
    from buildingspy.io.outputfile import Reader
    from buildingspy.io.postprocess import Plotter
    import re

    nPoi = 8761

    try:
        r = Reader(matFile, TOOL)
    except IOError:
        raise ValueError("Failed to read {}.".format(matFile))

    result = list()
    for var in relVal:
        time = []
        val = []
        try:
            var_mat = var
            # Matrix variables in JModelica are stored in mat file with no space e.g. [1,1].
            var_mat = re.sub(' ', '', var_mat)
            (time, val) = r.values(var_mat)
            tMin = float(min(time))
            tMax = float(max(time))
            ti = _getTimeGrid(tMin, tMax, nPoi)
        except KeyError:
            raise ValueError("Result {} does not have variable {}.".format(matFile, var))
        else:
            intVal = Plotter.interpolate(ti, time, val)
        temp = {'variable': var,
                'time': ti,
                'value': intVal}
        result.append(temp)
    return result

def _getTimeGrid(tMin, tMax, nPoi):
    """
    Return the time grid for the output result interpolation

    :param tMin: Minimum time of the results.
    :param tMax: Maximum time of the results.
    :param nPoi: Number of result points.
    """
    return [tMin + float(i) / (nPoi - 1) * (tMax - tMin) for i in range(nPoi)]

def get_time_series_result():
    """
    Extract time series data and organize the data structure.
    """
    mat_dir = os.path.join(CWD, 'mat')
    # case name and the corresponded mat file path
    cases = _organize_cases(mat_dir)

    results = list()
    for case in cases:
        temp = {'case': case['case']}
        if 'FF' in case['case']:
            # free floating cases
            resVal = ['TRooHou.y', 'TRooAnn.y']
        elif (case['case'] == 'Case960'):
            # case with sun space: back zone is conditioned and sun space is free floating
            resVal = ['PCoo.y', 'PHea.y', 'ECoo.y', 'EHea.y', 'TSunSpaHou.y', 'TSunSpaAnn.y']
        else:
            # cases with heating and cooling
            resVal = ['PCoo.y', 'PHea.y', 'ECoo.y', 'EHea.y']
        # extract time and value of the variables
        time_series_data = _extract_data(case['matFile'], resVal)
        temp['result'] = time_series_data
        results.append(temp)
    if CLEAN_MAT:
        shutil.rmtree('mat')
    return results
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
# Extract necessary data set from time series data set of modelica simulation results
# --------------------------------------------------------------------------------------------------
def _find_date(day):
    """
    Return the exactly date

    :param day: which day it is in the 365 days of one year
    """
    if day > 0 and day<=31:
        mon = 'Jan'
        date = day
    elif day>31 and day <= 59:
        mon = 'Feb'
        date = day - 31
    elif day > 59 and day <= 90:
        mon = 'Mar'
        date = day - 59
    elif day > 90 and day <= 120:
        mon = 'Apr'
        date = day - 90
    elif day > 120 and day <= 151:
        mon = 'May'
        date = day - 120
    elif day > 151 and day <= 181:
        mon = 'Jun'
        date = day - 151
    elif day > 181 and day <= 212:
        mon = 'Jul'
        date = day - 181
    elif day > 212 and day <= 243:
        mon = 'Aug'
        date = day - 212
    elif day > 243 and day <= 273:
        mon = 'Sep'
        date = day - 243
    elif day > 273 and day <= 304:
        mon = 'Oct'
        date = day - 273
    elif day > 304 and day <= 334:
        mon = 'Nov'
        date = day - 304
    else:
        mon = 'Dec'
        date = day - 334
    return '{}-{}'.format(int(date), mon)

def _convert_to_dateHour(hour):
    """
    Return the exactly date and hour in one year

    :param hour: which hour it is in the 8760 hours of one year
    """
    import numpy as np
    dayOfYear = np.floor(hour/24) + 1
    whichDate = _find_date(dayOfYear)
    whichHour = hour - (dayOfYear-1)*24
    if hour > 8759:
        whichDate = '31-Dec'
        whichHour = 24.0
    return '{}:{}'.format(whichDate, int(whichHour))

def _find_peak(data, isTemp, flag):
    """
    Find the peak value and when it is happens

    :param data: data set
    :param flag: check it is maximum or minimum
    """
    import numpy as np
    valueSet = data['value']
    secondSet = data['time']
    if flag == 'max':
        maxValue = max(valueSet)
        value = '{:.1f}'.format(maxValue -273.15) if isTemp else '{:.3f}'.format(abs(maxValue / 1000))
        pos = _find_pos(valueSet, maxValue)
        second_in_year = secondSet[pos]
        hour_in_year = np.floor(second_in_year/3600)
    else:
        minValue = _min_temperature(valueSet) if isTemp else min(valueSet)
        value = '{:.1f}'.format(minValue -273.15) if isTemp else '{:.3f}'.format(abs(minValue / 1000))
        pos = _find_pos(valueSet, minValue)
        second_in_year = secondSet[pos]
        hour_in_year = np.floor(second_in_year/3600)
    dateHour = _convert_to_dateHour(hour_in_year)
    return {'value': value, 'hour': dateHour}

def _min_temperature(data):
    minTemp = 273.15 + 100
    for i in range(len(data)):
        ithTemp = data[i]
        if ithTemp > 150 and ithTemp < minTemp:
            minTemp = ithTemp
    return minTemp

def _find_pos(data, value):
    pos = 1e+10
    for i in range(len(data)):
        if data[i] == value:
            pos = i
    return pos

def _find_load(dataSet):
    """
    Return the load profile by adding the heating load an cooling load

    :param dataSet: data set in which heating and cooling load should be summed to a load
    """
    for varVal in dataSet:
        if varVal['variable'] == 'PCoo.y':
            cooLoa = varVal['value']
        if varVal['variable'] == 'PHea.y':
            heaLoa = varVal['value']
    load = list()
    for i in range(len(cooLoa)):
        load.append(cooLoa[i] + heaLoa[i])
    return load

def _find_data_bin(dataSet):
    import numpy as np
    totalBin = 98+50+1
    results = list()
    results = ['0' for i in range(totalBin)]
    results = np.zeros(totalBin)
    for i in range(totalBin-1):
        lowTem = i - 50
        counter = 0
        for j in range(len(dataSet)):
            degC = dataSet[j] - 273.15
            if degC >= lowTem and degC < lowTem + 1:
                counter += 1
        results[i] = '{}'.format(int(counter))
    return results

def get_mo_data(data_set):
    MWh = 3600*1e6
    results = list()
    for data in data_set:
        temp = {'case': data['case']}
        # free-floating cases
        if 'FF' in data['case']:
            for varVal in data['result']:
                if varVal['variable'] == 'TRooAnn.y':
                    annAveTemp = varVal['value'][-1]
                else:
                    peaMax = _find_peak(varVal, True, 'max')
                    peaMin = _find_peak(varVal, True, 'min')
                    Feb1 = varVal['value'][745:769]
                    Jul14 = varVal['value'][4657:4681]
                    binData = _find_data_bin(varVal['value'])
            temp1 = {'annAveTem': '{:.1f}'.format(annAveTemp-273.15),
                     'peaMax': peaMax,
                     'peaMin': peaMin,
                     'Feb1': ['{:.2f}'.format(ele - 273.15) for ele in Feb1],
                     'Jul14': ['{:.2f}'.format(ele - 273.15) for ele in Jul14],
                     'binData': binData}
        else:
            for varVal in data['result']:
                if (data['case'] == 'Case960'):
                    if varVal['variable'] == 'TSunSpaAnn.y':
                        annAveTemp1 = varVal['value'][-1]
                    elif varVal['variable'] == 'TSunSpaHou.y':
                        peaMax1 = _find_peak(varVal, True, 'max')
                        peaMin1 = _find_peak(varVal, True, 'min')
                if varVal['variable'] == 'PCoo.y':
                    pCoo = _find_peak(varVal, False, 'min')
                elif varVal['variable'] == 'PHea.y':
                    pHea = _find_peak(varVal, False, 'max')
                elif varVal['variable'] == 'ECoo.y':
                    eCoo = varVal['value'][-1]
                elif varVal['variable'] == 'EHea.y':
                    eHea = varVal['value'][-1]
            load = _find_load(data['result'])
            if (data['case'] == 'Case960'):
                temp1 = {'annAveTem': '{:.1f}'.format(annAveTemp1-273.15),
                         'peaMax': peaMax1,
                         'peaMin': peaMin1,
                         'peaCoo': pCoo,
                         'peaHea': pHea,
                         'Feb1': ['{:.2f}'.format(ele / 1000) for ele in load[745:769]],
                         'eCoo': '{:.3f}'.format(abs(eCoo / MWh)),
                         'eHea': '{:.3f}'.format(abs(eHea / MWh))}
            else:
                temp1 = {'peaCoo': pCoo,
                         'peaHea': pHea,
                         'Feb1': ['{:.2f}'.format(ele / 1000) for ele in load[745:769]],
                         'eCoo': '{:.3f}'.format(abs(eCoo / MWh)),
                         'eHea': '{:.3f}'.format(abs(eHea / MWh))}
        temp['extData'] = list()
        temp['extData'].append(temp1)
        results.append(temp)
    return results

def _filter_cases(caseType):
    """
    Return free-floating or not free-floating cases list

    :param caseType: case type, 'free-float' or 'non-free-float'
    """
    caseList = list()
    for case in CASES:
        if caseType == 'free-float':
            if 'FF' in case:
                caseList.append(case)
        else:
            if 'FF' not in case:
                caseList.append(case)
    return caseList
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
# Read ASHRAE140 data from external file and write it to a dictionary
# --------------------------------------------------------------------------------------------------
def parse_standard_data():
    dataList = get_data_list()
    _add_data(dataList)
    _filter_data_set(dataList)
    _refactor_data_structure(dataList)
    return dataList

def _value_and_hour(peakList):
    """
    Return dictionary of the peak value and the hour

    :param peakList: list of peak value and the hour, the element has the form like '64.9(17-Oct:15)'
    """
    peakValue = list()
    peakHour = list()
    for i in range(len(peakList)):
        peak = peakList[i]
        if '(' in peak:
            leftBra = peak.index('(')
            value = peak[0:leftBra]
            hour = peak[leftBra+1:-1]
        else:
            value = peak
            hour = 'N/A'
        peakValue.append(value)
        peakHour.append(hour)
    return {'value': peakValue, 'hour': peakHour}

def get_data_list():
    """
    Return structure of the standard data list
    """
    allTool = ['BSIMAC', 'CSE', 'DeST', 'EnergyPlus', 'ESP-r', 'TRNSYS']
    dataList = list()
    dataList.append({'data_set': 'annual_heating', \
                     'data_head': '# Table B8-1. Annual Heating Loads (MWh)', \
                     'tools': allTool})
    dataList.append({'data_set': 'annual_cooling', \
                     'data_head': '# Table B8-2. Annual Sensible Cooling Loads (MWh)', \
                     'tools': allTool})
    dataList.append({'data_set': 'peak_heating', \
                     'data_head': '# Table B8-3. Annual Hourly Integrated Peak Heating Loads (kW)', \
                     'tools': allTool})
    dataList.append({'data_set': 'peak_cooling', \
                     'data_head': '# Table B8-4. Annual Hourly Integrated Peak Sensible Cooling Loads (kW)', \
                     'tools': allTool})
    dataList.append({'data_set': 'max_temperature', \
                     'data_head': '# MAXIMUM ANNUAL HOURLY INTEGRATED ZONE TEMPERATURE', \
                     'tools': allTool})
    dataList.append({'data_set': 'min_temperature', \
                     'data_head': '# MINIMUM ANNUAL HOURLY INTEGRATED ZONE TEMPERATURE', \
                     'tools': allTool})
    dataList.append({'data_set': 'ave_temperature', \
                     'data_head': '# AVERAGE ANNUAL HOURLY INTEGRATED ZONE TEMPERATURE', \
                     'tools': allTool})
    dataList.append({'data_set': 'FF_temperature_600FF_Feb1', \
                     'data_head': '# HOURLY FREE FLOAT TEMPERATURE DATA (degC): CASE 600FF, FEB 1', \
                     'tools': allTool})
    dataList.append({'data_set': 'FF_temperature_900FF_Feb1', \
                     'data_head': '# HOURLY FREE FLOAT TEMPERATURE DATA (degC): CASE 900FF, FEB 1', \
                     'tools': allTool})
    dataList.append({'data_set': 'FF_temperature_650FF_Jul14', \
                     'data_head': '# HOURLY FREE FLOAT TEMPERATURE DATA (degC): CASE 650FFV, JULY 14', \
                     'tools': allTool})
    dataList.append({'data_set': 'FF_temperature_950FF_Jul14', \
                     'data_head': '# HOURLY FREE FLOAT TEMPERATURE DATA (degC): CASE 950FFV, JULY 14', \
                     'tools': allTool})
    dataList.append({'data_set': 'hourly_load_600_Feb1', \
                     'data_head': '# HOURLY HEATING & COOLING LOAD DATA (kWh): CASE 600 FEB 1', \
                     'tools': allTool})
    dataList.append({'data_set': 'hourly_load_900_Feb1', \
                     'data_head': '# HOURLY HEATING & COOLING LOAD DATA (kWh): CASE 900 FEB 1', \
                     'tools': allTool})
    dataList.append({'data_set': 'bin_temperature_900FF', \
                     'data_head': '# HOURLY ANNUAL ZONE TEMPERATURE BIN DATA (hours): CASE 900FF', \
                     'tools': allTool})
    return dataList

def _add_data(dataList):
    """
    Add the standard data to the data structure

    :param dataList: the structure to be added data into it
    """
    data_file = open(ASHRAE_DATA)
    count = 0
    startLine = 0
    table_end = True
    data_head = ''
    for line in data_file:
        count += 1
        for i in range(len(dataList)):
            if dataList[i]['data_head'] in line:
                singleTable = dataList[i]
                data_head = singleTable['data_head']
                startLine = count + 2
                table_end = False
                temp = list()
        if '-----' in line:
            table_end = True
            startLine = 0
            data_head = ''
            singleTable['data'] = temp
        if count >= startLine and startLine > 0 and not table_end:
            data = get_line_data(line, singleTable)
            temp.append(data)
    data_file.close()

def get_line_data(line, table):
    """
    Return the data from one line, as dictionary like {'name': 'Case600', 'value': []}

    :param line: the line text to be parsed
    :param table: table type
    """
    data_set = table['data_set']
    # split the line
    lineList = [ele.strip() for ele in line.split(',')]
    for i in range(len(lineList)):
        if lineList[i] == 'N/A':
            lineList[i] = '0.000'
    # annual heating/cooling energy, or, average temperature for free-floating cases
    if 'annual_' in data_set or 'ave_' in data_set:
        temp = {'firstCol': 'Case{}'.format(lineList[0])}
        temp['value'] = lineList[1:]
    # peak heating/cooling load, or maximum or minimum temperature of free-floating cases
    # it should also have entries of 'hour' or when it happens
    elif 'peak_' in data_set or 'max_' in data_set or 'min_' in data_set:
        temp = {'firstCol': 'Case{}'.format(lineList[0])}
        # # remove the 5th item
        # lineList.pop(5)
        resultsList = lineList[1:]
        valueHour = _value_and_hour(resultsList)
        temp['value'] = valueHour['value']
        temp['hour'] = valueHour['hour']
    # 24-hour profile of free-floating temperature, or load
    elif 'FF_temperature' in data_set or 'hourly_load' in data_set:
        temp = {'firstCol': lineList[0]}
        # lineList.pop(5)
        temp['value'] = lineList[1:]
    # hourly temperature bin data
    else:
        temp = {'firstCol': lineList[0]}
        temp['value'] = lineList[1:]
    return temp

def _refactor_data_structure(dataList):
    """
    Transpose of the standard data set

    :param dataList: standard data set
    """
    for ele in dataList:
        data = ele['data']
        col_1 = list()
        col_2 = list()
        col_3 = list()
        col_4 = list()
        col_5 = list()
        col_6 = list()
        col_7 = list()
        lowerLimit = list()
        upperLimit = list()
        have_limits = False

        col_1_hr = list()
        col_2_hr = list()
        col_3_hr = list()
        col_4_hr = list()
        col_5_hr = list()
        col_6_hr = list()
        haveHour = False
        for row in data:
            col_1.append(row['firstCol'])
            col_2.append(row['value'][0])
            col_3.append(row['value'][1])
            col_4.append(row['value'][2])
            col_5.append(row['value'][3])
            col_6.append(row['value'][4])
            col_7.append(row['value'][5])
            if (len(row['value']) > 6):
                have_limits = True
                lowerLimit.append(row['value'][6])
                upperLimit.append(row['value'][7])
            if 'hour' in row:
                haveHour = True
                col_1_hr.append(row['hour'][0])
                col_2_hr.append(row['hour'][1])
                col_3_hr.append(row['hour'][2])
                col_4_hr.append(row['hour'][3])
                col_5_hr.append(row['hour'][4])
                col_6_hr.append(row['hour'][5])
        ele['data'] = list()
        temp = {'firstCol': col_1}
        if have_limits:
            temp['lowerLimits'] = lowerLimit
            temp['upperLimits'] = upperLimit
        temp['BSIMAC'] = col_2
        temp['CSE'] = col_3
        temp['DeST'] = col_4
        temp['EnergyPlus'] = col_5
        temp['ESP-r'] = col_6
        temp['TRNSYS'] = col_7
        if haveHour:
            temp['BSIMAC_hour'] = col_1_hr
            temp['CSE_hour'] = col_2_hr
            temp['DeST_hour'] = col_3_hr
            temp['EnergyPlus_hour'] = col_4_hr
            temp['ESP-r_hour'] = col_5_hr
            temp['TRNSYS_hour'] = col_6_hr
        ele['data'].append(temp)

def _filter_data_set(dataList):
    """
    Filter the standard data set so to keep only the cases that are simulated in modelica buildings library

    :param dataList: the set of entire standard data
    """
    for ele in dataList:
        table_name = ele['data_set']
        if 'annual_' in table_name or 'ave_' in table_name or \
           'peak_' in table_name or 'max_' in table_name or 'min_' in table_name:
           temp = list()
           for case in CASES:
               for data in ele['data']:
                   if case == data['firstCol']:
                       temp.append(data)
           ele['data'] = list()
           ele['data'] = temp
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
# Add modelica simulation results to ASHRAE-140 data set
# --------------------------------------------------------------------------------------------------
def combine_data(standard_data, moData):
    """
    Add modelica buildings library simulation results to standard results set

    :param standard_data: data set from ASHRAE-140
    :param moData: data set extract from Modelica simulation
    """
    tool = 'MBL'
    temp = list()
    for i in range(len(standard_data)):
        ithData = standard_data[i]
        data_set = ithData['data_set']
        if 'annual_heating' in data_set:
            temp.append(_add_to_standard('eHea', moData, ithData, tool, False))
        if 'annual_cooling' in data_set:
            temp.append(_add_to_standard('eCoo', moData, ithData, tool, False))
        if 'peak_heating' in data_set:
            temp.append(_add_to_standard('peaHea', moData, ithData, tool, True))
        if 'peak_cooling' in data_set:
            temp.append(_add_to_standard('peaCoo', moData, ithData, tool, True))
        if 'max_temperature' in data_set:
            temp.append(_add_to_standard('peaMax', moData, ithData, tool, True))
        if 'min_temperature' in data_set:
            temp.append(_add_to_standard('peaMin', moData, ithData, tool, True))
        if 'ave_temperature' in data_set:
            temp.append(_add_to_standard('annAveTem', moData, ithData, tool, False))
        if 'FF_temperature_600FF_Feb1' in data_set or \
           'FF_temperature_900FF_Feb1' in data_set or \
           'hourly_load_600_Feb1' in data_set or \
           'hourly_load_900_Feb1' in data_set:
            temp.append(_addSingleCase_to_standard('Feb1', data_set, moData, ithData, tool))
        if 'FF_temperature_650FF_Jul14' in data_set or \
           'FF_temperature_950FF_Jul14' in data_set:
            temp.append(_addSingleCase_to_standard('Jul14', data_set, moData, ithData, tool))
        if 'bin_temperature_900FF' in data_set:
            temp.append(_addSingleCase_to_standard('binData', data_set, moData, ithData, tool))
    return temp

def _add_to_standard(keyWord, moData, oneSet, tool, haveHour):
    newSet = oneSet
    temp = list()
    tools = list()
    for ele in newSet['tools']:
        tools.append(ele)
    tools.append(tool)
    if haveHour:
        temp_hour = list()
        tool_hour = '{}_hour'.format(tool)
    for case in newSet['data'][0]['firstCol']:
        for caseData in moData:
            if caseData['case'] == case:
                extVal = caseData['extData'][0][keyWord]
                if haveHour:
                    temp.append(extVal['value'])
                    temp_hour.append(extVal['hour'])
                else:
                    temp.append(extVal)
    newSet['tools'] = tools
    newSet['data'][0][tool] = temp
    if haveHour:
        newSet['data'][0][tool_hour] = temp_hour
    return newSet

def _addSingleCase_to_standard(keyWord, table_name, moData, oneSet, tool):
    newSet = oneSet
    tools = list()
    for ele in newSet['tools']:
        tools.append(ele)
    tools.append(tool)
    textList = ['Case{}'.format(ele) for ele in table_name.split('_')]
    curCase = ''
    for case in CASES:
        for singleText in textList:
            if case == singleText:
                curCase = case
    for caseData in moData:
        if caseData['case'] == curCase:
            newSet['data'][0][tool] = caseData['extData'][0][keyWord]
    newSet['tools'] = tools
    return newSet
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
# Generate plots
# --------------------------------------------------------------------------------------------------
def bar_compare(data, yLabel, minimum, maximum):
    import numpy as np

    tools = ['BSIMAC', 'CSE', 'DeST', 'EnergyPlus', 'ESP-r', 'TRNSYS', 'MBL']
    fillColor = plt.get_cmap('tab20c')
    yLim = [minimum, maximum]
    pltName = data['data_set']
    plt.clf()
    fig, ax = plt.subplots(figsize=(10,5))
    dataSet = data['data'][0]
    cases = dataSet['firstCol']
    toolData = dict()
    for i in range(len(tools)):
        if tools[i] in dataSet:
            toolData[tools[i]] = [float(ele) for ele in dataSet[tools[i]]]
    # total number of tools
    totalTool = len(toolData)
    keySet = list()
    for key in toolData:
        keySet.append(key)
    # total number of bar sets
    index = np.arange(len(cases))

    bar_width = 0.08
    opacity = 0.8
    staPos = 0
    for i in range(totalTool):
        fColor = 'k' if i == totalTool-1 else fillColor(i)
        ax.bar(index + staPos, toolData[keySet[i]], bar_width, alpha=opacity, color=fColor, label=keySet[i])
        staPos = staPos + bar_width
    ax.set_ylim(yLim)
    ax.set_ylabel(yLabel)
    ax.set_xticks(index + (totalTool-1)*bar_width/2)
    ax.set_xticklabels(cases, rotation=90)
    fig.legend(loc='lower left', frameon=True, bbox_to_anchor=(0, 1.01, 1, 0.2), ncol = 5, mode = 'expand', bbox_transform=ax.transAxes)
    # fig.legend(loc='lower center', frameon=True, bbox_to_anchor=(0.2, -0.02, 1.0, 0.2), ncol = 5, mode = 'expand', bbox_transform=fig.transFigure)
    ax.grid(color='lightgrey', axis='y', linewidth=0.25)

    for spine in ax.spines.values():
        spine.set_visible(False)
    plt.tick_params(axis=u'x', which=u'both', length=0)
    plt.subplots_adjust(bottom=0.2)
    for spine in plt.gca().spines.values():
        spine.set_visible(False)
    save_plot(plt, pltName)

def plot_lines(data, xLabel, yLabel, xMin, xMax, dx, yMin, yMax):
    import numpy as np
    tools = ['BSIMAC', 'CSE', 'DeST', 'EnergyPlus', 'ESP-r', 'TRNSYS', 'MBL']
    lineColor = plt.get_cmap('tab20c')
    lineMarker = ['.', ',', 'o', 's', 'p', '*', 'x']
    pltName = data['data_set']
    plt.clf()
    _,ax = plt.subplots(figsize=(10,5))
    configure_axes(ax)
    dataSet = data['data'][0]
    xSet = [float(ele) for ele in dataSet['firstCol']]
    xticks = np.arange(xMin, xMax, dx)
    toolData = dict()
    for i in range(len(tools)):
        if tools[i] in dataSet:
            toolData[tools[i]] = [float(ele) for ele in dataSet[tools[i]]]
    # total number of tools
    totalTool = len(toolData)
    keySet = list()
    for key in toolData:
        keySet.append(key)
    for i in range(totalTool):
        lineCo = 'k' if i==totalTool-1 else lineColor(i)
        lineWt = 1.0 if i==totalTool-1 else 0.5
        markerShape = 'd' if i==totalTool-1 else lineMarker[i]
        ax.plot(xSet, toolData[keySet[i]], color=lineCo, label=keySet[i], linewidth=lineWt, marker=markerShape, markersize=4)
    ax.set_xticks(xticks)
    ax.set_xlim([xMin, xMax])
    ax.set_ylim([yMin, yMax])
    ax.set_xlabel(xLabel)
    ax.set_ylabel(yLabel)
    ax.legend(loc='lower left', frameon=True, bbox_to_anchor=(0, 1.01, 1, 0.2), ncol = 5, mode = 'expand', bbox_transform=ax.transAxes)
    save_plot(plt, pltName)

def plot_figures(comDat):
    barPlot_variable = ['annual_heating', 'annual_cooling', 'peak_heating', 'peak_cooling', \
                        'max_temperature', 'min_temperature', 'ave_temperature']
    barPlot_yLabel = ['Annual Heating Load [MWh]', 'Annual Cooling Load [MWh]', 'Peak Heating Load [kW]', 'Peak Cooling Load [kW]', \
                      'Maximum Temperature [degC]', 'Minimum Temperature [degC]', 'Average Temperature [degC]']
    barPlot_yMin = [0, 0, 0, 0, 0, -25, 0]
    barPlot_yMax = [8, 10, 8, 8, 80, 10, 35]
    line_variable = ['FF_temperature_600FF_Feb1', 'FF_temperature_900FF_Feb1', 'FF_temperature_650FF_Jul14', \
                     'FF_temperature_950FF_Jul14', 'hourly_load_600_Feb1', 'hourly_load_900_Feb1', 'bin_temperature_900FF']
    line_xLable = ['Hour of Day (Case600FF, Feb1)', 'Hour of Day (Case900FF, Feb1)', 'Hour of Day (Case650FF, Jul14)', \
                   'Hour of Day (Case950FF, Jul14)', 'Hour of Day (Case600, Feb1)', 'Hour of Day (Case900, Feb1)', 'Temperature Bins [degC] (Case900FF)']
    line_yLable = ['Temperature [degC]', 'Temperature [degC]', 'Temperature [degC]', 'Temperature [degC]', \
                   'Heating or Cooling Load [kW]', 'Heating or Cooling Load [kW]', 'Number of Occurrences']
    line_xMin = [1, 1, 1, 1, 1, 1, -10]
    line_xMax = [24, 24, 24, 24, 24, 24, 50]
    line_dx = [1, 1, 1, 1, 1, 1, 5]
    line_yMin = [-10, -10, 10, 10, -6, -2, 0]
    line_yMax = [50, 50, 50, 50, 4, 2, 500]

    for i in range(len(comDat)):
        data = comDat[i]
        if i < 7:
            for j in range(len(barPlot_variable)):
                if data['data_set'] == barPlot_variable[j]:
                    bar_compare(data, barPlot_yLabel[j], barPlot_yMin[j], barPlot_yMax[j])
        else:
            for k in range(len(line_variable)):
                if data['data_set'] == line_variable[k]:
                    plot_lines(data, line_xLable[k], line_yLable[k], line_xMin[k], line_xMax[k], line_dx[k], line_yMin[k], line_yMax[k])
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
# Generate html tables
# --------------------------------------------------------------------------------------------------
def update_html_tables(comDat):
    allTools = '''
<tr>
<th>Case</th>
<th>BSIMAC</th>
<th>CSE</th>
<th>DeST</th>
<th>EnergyPlus</th>
<th>ESP-r</th>
<th>TRNSYS</th>
<th>MBL</th>
</tr>'''
    lessTools = '''
<tr>
<th rowspan=\\"2\\">Case</th>
<th colspan=\\"2\\">BSIMAC</th>
<th colspan=\\"2\\">CSE</th>
<th colspan=\\"2\\">DeST</th>
<th colspan=\\"2\\">EnergyPlus</th>
<th colspan=\\"2\\">ESP-r</th>
<th colspan=\\"2\\">TRNSYS</th>
<th colspan=\\"2\\">MBL</th>
</tr>'''
    loadContent = _generate_load_tables(comDat, allTools, lessTools)
    ffContent = _generate_ff_tables(comDat, lessTools)
    userGuideFile = "../../../../../../ThermalZones/Detailed/Validation/BESTEST/UsersGuide.mo"
    moFile = open(userGuideFile)
    beforeTables = ''
    betweenTables = ''
    afterTables = ''
    startSec = True
    midSec = False
    endSec = False
    for line in moFile:
        if startSec:
            beforeTables = beforeTables + line
        if ('<!-- table start: load data -->' in line):
            startSec = False
        if ('<!-- table end: load data -->' in line):
            midSec = True
        if midSec:
            betweenTables = betweenTables + line
        if ('<!-- table start: free float data -->' in line):
            midSec = False
        if ('<!-- table end: free float data -->' in line):
            endSec = True
        if endSec:
            afterTables = afterTables + line
    moFile.close()
    newMoContent = beforeTables + loadContent \
                   + betweenTables + ffContent \
                   + afterTables
    with open(userGuideFile, 'wt') as f:
        f.write(newMoContent)

def _generate_load_tables(comDat, allTools, lessTools):
    withLimits = '''
<tr>
<th>Case</th>
<th>Lower limit</th>
<th>Upper limit</th>
<th>BSIMAC</th>
<th>CSE</th>
<th>DeST</th>
<th>EnergyPlus</th>
<th>ESP-r</th>
<th>TRNSYS</th>
<th>MBL</th>
</tr>'''
    for ele in comDat:
        setName = ele['data_set']
        if setName == 'annual_cooling':
            allTools = withLimits
            annCoo = ele
        if setName == 'annual_heating':
            allTools = withLimits
            annHea = ele
        if setName == 'peak_cooling':
            peaCoo = ele
        if setName == 'peak_heating':
            peaHea = ele
    tableText = '''<table border = \\"1\\" summary=\\"Annual load\\">
<tr><td colspan=\\"10\\"><b>Annual heating load (MWh)</b></td></tr>''' + allTools
    # add annual heating load data
    annHeaLoa = _write_table_content(annHea, True)
    tableText = tableText + annHeaLoa
    # add annual cooling load data
    tableText = tableText + '''<tr><td colspan=\\"10\\"><b>Annual cooling load (MWh)</b></td></tr>'''
    tableText = tableText + allTools
    annCooLoa = _write_table_content(annCoo, True)
    tableText = tableText + annCooLoa + '''</table>
<br/>'''

    peakUnits = '''
<tr>
<td>kW</td><td>hour</td>
<td>kW</td><td>hour</td>
<td>kW</td><td>hour</td>
<td>kW</td><td>hour</td>
<td>kW</td><td>hour</td>
<td>kW</td><td>hour</td>
<td>kW</td><td>hour</td>
</tr>'''
    # add peak heating load data
    tableText = tableText + '''
<table border = \\"1\\" summary=\\"Peak load\\">
<tr><td colspan=\\"15\\"><b>Peak heating load (kW)</b></td></tr>'''
    tableText = tableText + lessTools + peakUnits
    peaHeaLoa = _write_table_content(peaHea)
    tableText = tableText + peaHeaLoa
    # add peak cooling load data
    tableText = tableText + '''<tr><td colspan=\\"15\\"><b>Peak cooling load (kW)</b></td></tr>'''
    tableText = tableText + lessTools + peakUnits
    peaCooLoa = _write_table_content(peaCoo)
    tableText = tableText + peaCooLoa + '''</table>
<br/>
'''
    return tableText

def _generate_ff_tables(comDat, lessTools):
    for ele in comDat:
        setName = ele['data_set']
        if setName == 'max_temperature':
            maxTem = ele
        if setName == 'min_temperature':
            minTem = ele
    peakUnits = '''
<tr>
<td>&deg;C</td><td>hour</td>
<td>&deg;C</td><td>hour</td>
<td>&deg;C</td><td>hour</td>
<td>&deg;C</td><td>hour</td>
<td>&deg;C</td><td>hour</td>
<td>&deg;C</td><td>hour</td>
<td>&deg;C</td><td>hour</td>
</tr>'''
    tableText = '''<table border = \\"1\\" summary=\\"Peak temperature\\">
<tr><td colspan=\\"15\\"><b>Maximum temperature (&deg;C)</b></td></tr>''' + lessTools + peakUnits
    # add maximum temperature data
    maxTemData = _write_table_content(maxTem)
    tableText = tableText + maxTemData
    # add minimum temperature data
    tableText = tableText + '''<tr><td colspan=\\"15\\"><b>Minimum temperature (&deg;C)</b></td></tr>'''
    tableText = tableText + lessTools + peakUnits
    minTemData = _write_table_content(minTem)
    tableText = tableText + minTemData + '''</table>
<br/>
'''
    return tableText

def _write_table_content(dataSet, have_limits=False):
    setName = dataSet['data_set']
    data = dataSet['data'][0]
    tools = dataSet['tools']
    outText = ''
    for i in range(len(data['firstCol'])):
        temp = "<tr>" + os.linesep
        temp = temp + "<td>{}</td>".format(data['firstCol'][i]) + os.linesep
        if have_limits:
            temp = temp + "<td>{}</td>".format(data['lowerLimits'][i]) + os.linesep
            temp = temp + "<td>{}</td>".format(data['upperLimits'][i]) + os.linesep
        for j in range(len(tools)):
            tool = tools[j]
            if have_limits and (j == len(tools)-1):
                lim1 = float(data['lowerLimits'][i])
                lim2 = float(data['upperLimits'][i])
                lowLim = lim1 if lim1 < lim2 else lim2
                uppLim = lim2 if lim1 < lim2 else lim1
                mblVal = float(data[tool][i])
                if ((mblVal > uppLim or mblVal < lowLim) and uppLim > 0.0):
                    temp = temp + '''<td bgcolor=\\"#FF4500\\">''' + "{}</td>".format(data[tool][i]) + os.linesep
                else:
                    temp = temp + '''<td bgcolor=\\"#90EE90\\">''' + "{}</td>".format(data[tool][i]) + os.linesep
            else:
                temp = temp + "<td>{}</td>".format(data[tool][i]) + os.linesep

            if 'peak_' in setName or 'max_' in setName or 'min_' in setName:
                toolHour = '{}_hour'.format(tool)
                temp = temp + "<td>{}</td>".format(data[toolHour][i]) + os.linesep
        temp = temp + "</tr>" + os.linesep
        outText = outText + temp
    return outText
# --------------------------------------------------------------------------------------------------

if __name__=="__main__":

    if DO_SIMULATIONS:
        # create directory to be as temporary buildings library directory
        mbl_dir = create_library_directory('MBL')
        copy_mbl(mbl_dir)

        # create directory to be as temporary buildingspy directory
        bp_dir = create_library_directory('BP')
        checkout_buildingspy_repository(bp_dir)

        # find temporary directories that were used for run simulations
        resultDirs = _get_results_directory(mbl_dir, bp_dir)
        shutil.rmtree(mbl_dir)
        shutil.rmtree(bp_dir)

        # move the mat files to current working directory
        _move_results(resultDirs)

    # get time series data from the mat file
    time_series_data = get_time_series_result()

    # from the time series data, get the datas used for comparison
    moData = get_mo_data(time_series_data)

    # parse standard data
    standard_data = parse_standard_data()

    # add data simulated with modelica buildings library, to the standard data
    comDat = combine_data(standard_data, moData)

    plot_figures(comDat)

    # write html tables to mo file
    update_html_tables(comDat)
