#!/usr/bin/env python3
#####################################################################
# This script is used to validate weather reading and postprocessing
# for tilted and oriented surfaces according to the BESTEST standard.
# It will create a folder in
# Resources/Data/BoundaryConditions/Validation/BESTEST/
# called results and inside there will be the .mat files and the
# .json files or just the .json files
#
# This script creates folders in the temporary directory.
# It copies the library from a local GitHub repository,
# executes simulations and prints results in current working directory
#
# ettore.zanetti@polimi.it
#####################################################################
import json
import os
import shutil
import numpy as np
import copy
import sys
from pathlib import Path
from datetime import date
import stat
import git


# Check if it just implements post-process (from .mat files to Json files)
POST_PROCESS_ONLY = False
# Erase old .mat files
CLEAN_MAT = False
# Erase anything but the Json file results in the ResultJson folder and .mat
# files
DEL_EVR = False

# Path to local library copy (This assumes the script is run inside
# the library folder)
script_path = os.path.dirname(os.path.realpath(__file__))
path = Path(script_path)
levels_up = 5  # Goes up five levels to get the IBPSA folder
LIBPATH = str(path.parents[levels_up - 1])
# Simulator, Dymola
TOOL = 'dymola'

# Modelica Library working branch
# BRANCH = 'master'

try:
    BRANCH = git.Repo(search_parent_directories=True).active_branch.name
except TypeError as e:
    # Branch is detached from head. This is if one run "git checkout
    # commit_hash"
    BRANCH = None

# Software specifications
# Set library_name to IBPSA, or Buildings, etc.
library_name = LIBPATH.split(os.path.sep)[-1]
library_version = 'v4.0.0dev'
modeler_organization = 'LBNL'
modeler_organization_for_tables_and_charts = 'LBNL'
program_name_for_tables_and_charts = library_name
results_submission_date = str(date.today().strftime('%m/%d/%Y'))

# Make sure script is run from correct directory
if os.path.abspath(".").split(os.path.sep)[-1] != library_name:
    raise ValueError(f"Script must be run from directory \
                     {library_name}")

# List of cases and result cases
PACKAGES = f'{library_name}.BoundaryConditions.Validation.BESTEST'

CASES = ['WD100', 'WD200', 'WD300', 'WD400', 'WD500', 'WD600']


result_vars = [
    'azi000til00.H',
    'azi000til00.HPer',
    'azi000til00.HDir.H',
    'azi000til00.HDiffIso.H',
    'azi000til00.HDiffPer.H',
    'azi000til90.H',
    'azi000til90.HPer',
    'azi000til90.HDir.H',
    'azi000til90.HDiffIso.H',
    'azi000til90.HDiffPer.H',
    'azi270til90.H',
    'azi270til90.HPer',
    'azi270til90.HDir.H',
    'azi270til90.HDiffIso.H',
    'azi270til90.HDiffPer.H',
    'azi180til90.H',
    'azi180til90.HPer',
    'azi180til90.HDir.H',
    'azi180til90.HDiffIso.H',
    'azi180til90.HDiffPer.H',
    'azi090til90.H',
    'azi090til90.HPer',
    'azi090til90.HDir.H',
    'azi090til90.HDiffIso.H',
    'azi090til90.HDiffPer.H',
    'azi315til90.H',
    'azi315til90.HPer',
    'azi315til90.HDir.H',
    'azi315til90.HDiffIso.H',
    'azi315til90.HDiffPer.H',
    'azi045til90.H',
    'azi045til90.HDir.H',
    'azi045til90.HDiffIso.H',
    'azi045til90.HDiffPer.H',
    'azi270til30.H',
    'azi270til30.HDir.H',
    'azi270til30.HDiffIso.H',
    'azi270til30.HDiffPer.H',
    'azi000til30.H',
    'azi000til30.HDir.H',
    'azi000til30.HDiffIso.H',
    'azi000til30.HDiffPer.H',
    'azi000til30.HPer',
    'azi090til30.H',
    'azi090til30.HPer',
    'azi090til30.HDir.H',
    'azi090til30.HDiffPer.H',
    'toDryAir.XiDry',
    'weaBusHHorIR.pAtm',
    'weaBusHHorIR.TDryBul',
    'weaBusHHorIR.relHum',
    'weaBusHHorIR.TBlaSky',
    'weaBusHHorIR.TDewPoi',
    'weaBusHHorIR.TWetBul',
    'weaBusHHorIR.nOpa',
    'weaBusHHorIR.nTot',
    'weaBusHHorIR.winDir',
    'weaBusHHorIR.winSpe',
    'weaBusTDryBulTDewPoiOpa.TBlaSky',
    'azi270til30.HPer',
    'azi045til90.HPer',
    'azi090til30.HDiffIso.H']


def create_working_directory():
    ''' Create working directory in temp folder
    '''
    import tempfile
    import getpass
    wor_dir = tempfile.mkdtemp(prefix='tmp_Weather_Bestest' +
                               getpass.getuser())
    if CODE_VERBOSE:
        print("Created directory {}".format(wor_dir))
    return wor_dir


def checkout_repository(working_directory, case_dict):
    ''' The function will download the repository from GitHub or a copy from a
    local library to the temporary working directory

    :param working_directory: Current working directory
    :param case_dict : from_git_hub get the library repository from local copy
    or git_hub, BRANCH, to specify branch from git_hub, LIBPATH, to specify
    the local library path

    '''
    import os
    from git import Repo
    import git
    import time
    d = {}
    d['lib_name'] = case_dict['lib_name']
    if case_dict['from_git_hub']:
        git_url = git.Repo(search_parent_directories=True).remotes.origin.url
        r = Repo.clone_from(git_url, working_directory)
        g = git.Git(working_directory)
        g.checkout(BRANCH)
        if case_dict['CODE_VERBOSE']:
            print("Checking out repository IBPSA repository branch \
                  {}".format(BRANCH))
        # Print commit
        d['branch'] = case_dict['BRANCH']
        d['commit'] = str(r.active_branch.commit)
        headcommit = r.head.commit
        time.asctime(time.gmtime(headcommit.committed_date))
        d['commit_time'] = time.strftime("%m/%d/%Y", time.gmtime
                                         (headcommit.committed_date))
    else:
        # This uses the local copy of the repository
        des = os.path.join(working_directory, d['lib_name'])
        shutil.copytree(case_dict['LIBPATH'], des)
        if case_dict['CODE_VERBOSE']:
            print("Since a local copy of the library is used, remember to manually add software version and commit.")
        d['branch'] = 'AddManually'
        d['commit'] = 'AddManually'
        d['commit_time'] = 'AddManually'
    return d

def get_result_directory():
    return os.path.join(os.path.dirname(os.path.realpath(__file__)), "results")

def get_cases(case_dict):
    ''' Return the simulation cases that are used for the case study.
        The cases are stored in this function as they are used
        for the simulation and for the post processing.

        :param case_dict : In the dictionary are reported the options for
        the Dymola simulations
    '''
    cases = list()
    for case in case_dict["CASES"]:
        wor_dir = create_working_directory()
        cases.append(
            {'model': case_dict["PACKAGES"] + '.' + case,
             "name": case,
             'wor_dir': wor_dir,
             "tex_label": "p",
             "start_time": case_dict["start_time"],
             "stop_time": case_dict["StopTime"],
             "solver": case_dict["Solver"],
             "set_tolerance": case_dict["set_tolerance"],
             "show_GUI": case_dict["show_GUI"],
             "n_intervals": case_dict["n_intervals"],
             "CLEAN_MAT": case_dict['CLEAN_MAT'],
             "DEL_EVR": case_dict["DEL_EVR"],
             "CODE_VERBOSE": case_dict["CODE_VERBOSE"]})
    return cases


def _simulate(spec):
    '''
    This function execute the simulation of a specific Case model and stores
    the result in the simulation directory, then copies the result to the
    current working directory and if CLEAN_MAT option is selected the old .mat
    files are removed
    :param spec: dictionary with the simulation specifications

    '''
    import glob

    from buildingspy.simulate.Dymola import Simulator

    # Write git information if the simulation is based on a github checkout
    if 'git' in spec:
        with open("version.txt", "w+") as text_file:
            text_file.write("branch={}\n".format(spec['git']['branch']))
            text_file.write("commit={}\n".format(spec['git']['commit']))

    # Change to working directory
    cur_dir = path.cwd()
    wor_dir = spec['wor_dir']
    os.chdir(wor_dir)

    # Set MODELICAPATH
    #os.environ['MODELICAPATH'] = LIBPATH
    # Set Model to simulate, the output dir and the package directory
    s = Simulator(spec["model"])
    # Add all necessary parameters from Case Dict
    s.addPreProcessingStatement("OutputCPUtime:= true;")
    # fixme: Printing current directory for diagnostics
    s.addPreProcessingStatement("cd")
    # fixme: Print directories and files
    s.addPreProcessingStatement("Modelica.Utilities.Files.list(\".\");")
    s.setSolver(spec["solver"])
    if 'parameters' in spec:
        s.addParameters(spec['parameters'])
    s.setStartTime(spec["start_time"])
    s.setStopTime(spec["stop_time"])
    s.setNumberOfIntervals(spec["n_intervals"])
    s.setTolerance(spec["set_tolerance"])
    s.showGUI(spec["show_GUI"])
    if spec['CODE_VERBOSE']:
        print("Starting simulation in {}".format(path.cwd()))
    s.simulate()

    # Change back to current directory
    os.chdir(cur_dir)
    # Copy results back
    res_des = os.path.join(get_result_directory(), spec["name"])

    def _copy_results(wor_dir, des_dir):
        os.mkdir(des_dir)
        files = glob.glob(os.path.join(wor_dir, '*.mat'))
        files.extend(glob.glob(os.path.join(wor_dir, '*.log')))
        for file in files:
            shutil.copy(file, res_des)

    # Removing old results directory
    if os.path.isdir(res_des) and spec["CLEAN_MAT"]:
        shutil.rmtree(res_des)
        _copy_results(wor_dir, res_des)
    elif os.path.isdir(res_des) and not spec["CLEAN_MAT"]:
        pass
    else:
        _copy_results(wor_dir, res_des)


def _organize_cases(mat_dir,case_dict):
    ''' Create a list of dictionaries. Each a dictionary include the case name
    and the mat file path.
    :param mat_dir: path to .mat_files directory
    :param case_dict : In the dictionary are reported the general options for
                       simulation and other parameters
    '''
    mat_files = list()
    if case_dict['CODE_VERBOSE']:
        print(f"Searching for .mat files in {mat_dir}.")
    for r, _, f in os.walk(mat_dir):
        for file in f:
            if '.mat' in file:
                mat_files.append(os.path.join(r, file))
                if case_dict['CODE_VERBOSE']:
                    print(f"Appending {os.path.join(r, file)} to mat_files.")

    case_list = list()
    if len(CASES) == len(mat_files):
        for case in CASES:
            temp = {'case': case}
            for mat_file in mat_files:
                # mat_filen = os.path.basename(mat_file)
                tester = case + '.mat'
                if tester in mat_file:
                    temp['mat_file'] = os.path.join(mat_dir, mat_file)
            case_list.append(temp)
    else:
        raise ValueError(
            f"*** There is failed simulation, no result file was found. \
                Check the simulations. len(CASES) = {len(CASES)}, len(mat_files) = {len(mat_files)}")
    return case_list


def _extract_data(mat_file, re_val):
    """
    Extract time series data from mat file.

    :param mat_file: Path of .mat output file
    :param re_val: List of variables that the data should be extracted
    """
    from buildingspy.io.outputfile import Reader

    nPoi = case_dict["n_intervals"]

    try:
        if case_dict['CODE_VERBOSE']:
            print(f"**** Extracting {mat_file}")
        r = Reader(mat_file, TOOL)
    except IOError:
        raise ValueError("Failed to read {}.".format(mat_file))

    result = list()
    for var in re_val:
        time = []
        val = []
        try:
            var_mat = var
            (time, val) = r.values(var_mat)
            timen, valn = clean_time_series(time, val, nPoi)
        except KeyError:
            raise ValueError("Result {} does not have variable {}."
                             .format(mat_file, var))
        # Convert variable to compact format to save disk space.
        temp = {'variable': var,
                'time': timen,
                'value': valn}
        result.append(temp)
    return result


def clean_time_series(time, val, nPoi):
    """
    Clean doubled time values and checks with wanted number of nPoi

    :param time: Time.
    :param val: Variable values.
    :param nPoi: Number of result points.
    """
    import numpy as np
    # Create shift array
    Shift = np.array([0.0], dtype='f')
    # Shift time to right and left and subtract
    time_sr = np.concatenate((Shift, time))
    time_sl = np.concatenate((time, Shift))
    time_d = time_sl - time_sr
    time_dn = time_d[0:-1]
    # Get new values for time and val
    tol = 1E-5
    timen = time[time_dn > tol]
    valn = val[time_dn > tol]
    if len(timen) != nPoi:
        raise ValueError(
            "Error: In clean_time_series, length and number of results \
                points do not match.")
    return timen, valn


def weather_json(res_form, Matfd, case_dict):
    """
    This function take the results and writes them in the required json BESTEST
    format

    :param res_form: json file format.
    :param Matfd: List of the results mat files and their path.
    :param case_dict: case_dict are stored the simulation cases "result_vars"
    """
    # List of type of results
    # Taking hourly variables
    res_fin = copy.deepcopy(res_form)
    for dic in Matfd:
        mat_file = dic["mat_file"]
        results = _extract_data(mat_file, case_dict["result_vars"])
        k = 0
        for result in results:
            resSplit = result['variable'].split('.')
            if resSplit[-1] in 'TDryBul_TBlaSky_TWetBul_TDewPoi':
                # Pass from K to °C
                results[k]['value'] = results[k]['value'] - 273.15
            elif 'relHum' in resSplit[-1]:
                # Pass from [0,1] to %
                results[k]['value'] = results[k]['value'] * 100
            elif 'pAtm' in resSplit[-1]:
                # Pass from Pa to mbar
                results[k]['value'] = results[k]['value'] / 100
            elif 'winDir' in resSplit[-1]:
                # Pass from rad to °
                Pi = 3.141592653589793
                results[k]['value'] = results[k]['value'] * 180 / Pi
            elif ('nOpa' in resSplit[-1]) or ('nTot' in resSplit[-1]):
                # Sky coverage from [0-1] to tenth of sky
                results[k]['value'] = results[k]['value'] * 10

            k += 1
        map_dymola_and_json(results, dic['case'], res_fin, case_dict)
    return res_fin


def map_dymola_and_json(results, case, res_fin, case_dict):
    """
    This function couples the .mat file variable with the final .json variable

    :param results: Result obtained from the _extract_data function
    :param case: Dictionary that specifies the BESTEST case
    :param res_fin: Dictionary with the same format as the desired json file
    :param case_dict: in case_dict is stored TestN (which .json file format\
                                                  should be used)"
    """

    dict_hourly = [{'json': 'dry_bulb_temperature',
                    'mat': 'weaBusHHorIR.TDryBul'},
                   {'json': 'relative_humidity',
                    'mat': 'weaBusHHorIR.relHum'},
                   {'json': 'humidity_ratio',
                    'mat': 'toDryAir.XiDry'},
                   {'json': 'dewpoint_temperature',
                    'mat': 'weaBusHHorIR.TDewPoi'},
                   {'json': 'wet_bulb_temperature',
                    'mat': 'weaBusHHorIR.TWetBul'},
                   {'json': 'wind_speed',
                    'mat': 'weaBusHHorIR.winSpe'},
                   {'json': 'wind_direction',
                    'mat': 'weaBusHHorIR.winDir'},
                   {'json': 'station_pressure',
                    'mat': 'weaBusHHorIR.pAtm'},
                   {'json': 'total_cloud_cover',
                    'mat': 'weaBusHHorIR.nTot'},
                   {'json': 'opaque_cloud_cover',
                    'mat': 'weaBusHHorIR.nOpa'},
                   {'json': 'sky_temperature',
                    'matHor': 'weaBusHHorIR.TBlaSky',
                    'matDew': 'weaBusTDryBulTDewPoiOpa.TBlaSky'},
                   {'json': 'total_horizontal_radiation',
                    'matIso': 'azi000til00.H',
                    'matPer': 'azi000til00.HPer'},
                   {'json': 'beam_horizontal_radiation',
                    'mat': 'azi000til00.HDir.H'},
                   {'json': 'diffuse_horizontal_radiation',
                    'matIso': 'azi000til00.HDiffIso.H',
                    'matPer': 'azi000til00.HDiffPer.H'},
                   {'json': 'total_radiation_s_90',
                    'matIso': 'azi000til90.H',
                    'matPer': 'azi000til90.HPer'},
                   {'json': 'beam_radiation_s_90',
                    'mat': 'azi000til90.HDir.H'},
                   {'json': 'diffuse_radiation_s_90',
                    'matIso': 'azi000til90.HDiffIso.H',
                    'matPer': 'azi000til90.HDiffPer.H'},
                   {'json': 'total_radiation_e_90',
                    'matIso': 'azi270til90.H',
                    'matPer': 'azi270til90.HPer'},
                   {'json': 'beam_radiation_e_90',
                    'mat': 'azi270til90.HDir.H'},
                   {'json': 'diffuse_radiation_e_90',
                    'matIso': 'azi270til90.HDiffIso.H',
                    'matPer': 'azi270til90.HDiffPer.H'},
                   {'json': 'total_radiation_n_90',
                    'matIso': 'azi180til90.H',
                    'matPer': 'azi180til90.HPer'},
                   {'json': 'beam_radiation_n_90',
                    'mat': 'azi180til90.HDir.H'},
                   {'json': 'diffuse_radiation_n_90',
                    'matIso': 'azi180til90.HDiffIso.H',
                    'matPer': 'azi180til90.HDiffPer.H'},
                   {'json': 'total_radiation_w_90',
                    'matIso': 'azi090til90.H',
                    'matPer': 'azi090til90.HPer'},
                   {'json': 'beam_radiation_w_90',
                    'mat': 'azi090til90.HDir.H'},
                   {'json': 'diffuse_radiation_w_90',
                    'matIso': 'azi090til90.HDiffIso.H',
                    'matPer': 'azi090til90.HDiffPer.H'},
                   {'json': 'total_radiation_45_e_90',
                    'matIso': 'azi315til90.H',
                    'matPer': 'azi315til90.HPer'},
                   {'json': 'beam_radiation_45_e_90',
                    'mat': 'azi315til90.HDir.H'},
                   {'json': 'diffuse_radiation_45_e_90',
                    'matIso': 'azi315til90.HDiffIso.H',
                    'matPer': 'azi315til90.HDiffPer.H'},
                   {'json': 'total_radiation_45_w_90',
                    'matIso': 'azi045til90.H',
                    'matPer': 'azi045til90.HPer'},
                   {'json': 'beam_radiation_45_w_90',
                    'mat': 'azi045til90.HDir.H'},
                   {'json': 'diffuse_radiation_45_w_90',
                    'matIso': 'azi045til90.HDiffIso.H',
                    'matPer': 'azi045til90.HDiffPer.H'},
                   {'json': 'total_radiation_e_30',
                    'matIso': 'azi270til30.H',
                    'matPer': 'azi270til30.HPer'},
                   {'json': 'beam_radiation_e_30',
                    'mat': 'azi270til30.HDir.H'},
                   {'json': 'diffuse_radiation_e_30',
                    'matIso': 'azi270til30.HDiffIso.H',
                    'matPer': 'azi270til30.HDiffPer.H'},
                   {'json': 'total_radiation_s_30',
                    'matIso': 'azi000til30.H',
                    'matPer': 'azi000til30.HPer'},
                   {'json': 'beam_radiation_s_30',
                    'mat': 'azi000til30.HDir.H'},
                   {'json': 'diffuse_radiation_s_30',
                    'matIso': 'azi000til30.HDiffIso.H',
                    'matPer': 'azi000til30.HDiffPer.H'},
                   {'json': 'total_radiation_w_30',
                    'matIso': 'azi090til30.H',
                    'matPer': 'azi090til30.HPer'},
                   {'json': 'beam_radiation_w_30',
                    'mat': 'azi090til30.HDir.H'},
                   {'json': 'diffuse_radiation_w_30',
                    'matIso': 'azi090til30.HDiffIso.H',
                    'matPer': 'azi090til30.HDiffPer.H'}]
    dict_sub_hourly = [{'json': 'dry_bulb_temperature',
                        'mat': 'weaBusHHorIR.TDryBul'},
                       {'json': 'relative_humidity',
                        'mat': 'weaBusHHorIR.relHum'},
                       {'json': 'total_horizontal_radiation',
                        'matIso': 'azi000til00.H',
                        'matPer': 'azi000til00.HPer'},
                       {'json': 'beam_horizontal_radiation',
                        'mat': 'azi000til00.HDir.H'},
                       {'json': 'diffuse_horizontal_radiation',
                        'matIso': 'azi000til00.HDiffIso.H',
                        'matPer': 'azi000til00.HDiffPer.H'},
                       {'json': 'total_radiation_s_90',
                        'matIso': 'azi000til90.H',
                        'matPer': 'azi000til90.HPer'},
                       {'json': 'beam_radiation_s_90',
                        'mat': 'azi000til90.HDir.H'},
                       {'json': 'diffuse_radiation_s_90',
                        'matIso': 'azi000til90.HDiffIso.H',
                        'matPer': 'azi000til90.HDiffPer.H'},
                       {'json': 'total_radiation_e_90',
                        'matIso': 'azi270til90.H',
                        'matPer': 'azi270til90.HPer'},
                       {'json': 'beam_radiation_e_90',
                        'mat': 'azi270til90.HDir.H'},
                       {'json': 'diffuse_radiation_e_90',
                        'matIso': 'azi270til90.HDiffIso.H',
                        'matPer': 'azi270til90.HDiffPer.H'},
                       {'json': 'total_radiation_n_90',
                        'matIso': 'azi180til90.H',
                        'matPer': 'azi180til90.HPer'},
                       {'json': 'beam_radiation_n_90',
                        'mat': 'azi180til90.HDir.H'},
                       {'json': 'diffuse_radiation_n_90',
                        'matIso': 'azi180til90.HDiffIso.H',
                        'matPer': 'azi180til90.HDiffPer.H'},
                       {'json': 'total_radiation_w_90',
                        'matIso': 'azi090til90.H',
                        'matPer': 'azi090til90.HPer'},
                       {'json': 'beam_radiation_w_90',
                        'mat': 'azi090til90.HDir.H'},
                       {'json': 'diffuse_radiation_w_90',
                        'matIso': 'azi090til90.HDiffIso.H',
                        'matPer': 'azi090til90.HDiffPer.H'},
                       {'json': 'total_radiation_45_e_90',
                        'matIso': 'azi315til90.H',
                        'matPer': 'azi315til90.HPer'},
                       {'json': 'beam_radiation_45_e_90',
                        'mat': 'azi315til90.HDir.H'},
                       {'json': 'diffuse_radiation_45_e_90',
                        'matIso': 'azi315til90.HDiffIso.H',
                        'matPer': 'azi315til90.HDiffPer.H'},
                       {'json': 'total_radiation_45_w_90',
                        'matIso': 'azi045til90.H',
                        'matPer': 'azi045til90.HPer'},
                       {'json': 'beam_radiation_45_w_90',
                        'mat': 'azi045til90.HDir.H'},
                       {'json': 'diffuse_radiation_45_w_90',
                        'matIso': 'azi045til90.HDiffIso.H',
                        'matPer': 'azi045til90.HDiffPer.H'},
                       {'json': 'total_radiation_e_30',
                        'matIso': 'azi270til30.H',
                        'matPer': 'azi270til30.HPer'},
                       {'json': 'beam_radiation_e_30',
                        'mat': 'azi270til30.HDir.H'},
                       {'json': 'diffuse_radiation_e_30',
                        'matIso': 'azi270til30.HDiffIso.H',
                        'matPer': 'azi270til30.HDiffPer.H'},
                       {'json': 'total_radiation_s_30',
                        'matIso': 'azi000til30.H',
                        'matPer': 'azi000til30.HPer'},
                       {'json': 'beam_radiation_s_30',
                        'mat': 'azi000til30.HDir.H'},
                       {'json': 'diffuse_radiation_s_30',
                        'matIso': 'azi000til30.HDiffIso.H',
                        'matPer': 'azi000til30.HDiffPer.H'},
                       {'json': 'total_radiation_w_30',
                        'matIso': 'azi090til30.H',
                        'matPer': 'azi090til30.HPer'},
                       {'json': 'beam_radiation_w_30',
                        'mat': 'azi090til30.HDir.H'},
                       {'json': 'diffuse_radiation_w_30',
                        'matIso': 'azi090til30.HDiffIso.H',
                        'matPer': 'azi090til30.HDiffPer.H'},
                       {'json': 'integrated_total_horizontal_radiation',
                        'matIso': 'azi000til00.H',
                        'matPer': 'azi000til00.HPer'},
                       {'json': 'integrated_beam_horizontal_radiation',
                        'mat': 'azi000til00.HDir.H'},
                       {'json': 'integrated_diffuse_horizontal_radiation',
                        'matIso': 'azi000til00.HDiffIso.H',
                        'matPer': 'azi000til00.HDiffPer.H'}]
    dict_yearly = [{'json': 'average_dry_bulb_temperature',
                    'mat': 'weaBusHHorIR.TDryBul'},
                   {'json': 'average_relative_humidity',
                    'mat': 'weaBusHHorIR.relHum'},
                   {'json': 'average_humidity_ratio',
                    'mat': 'toDryAir.XiDry'},
                   {'json': 'average_wet_bulb_temperature',
                    'mat': 'weaBusHHorIR.TWetBul'},
                   {'json': 'average_dew_point_temperature',
                    'mat': 'weaBusHHorIR.TDewPoi'},
                   {'json': 'total_horizontal_solar_radiation',
                    'matIso': 'azi000til00.H',
                    'matPer': 'azi000til00.HPer'},
                   {'json': 'total_horizontal_beam_solar_radiation',
                    'mat': 'azi000til00.HDir.H'},
                   {'json': 'total_horizontal_diffuse_solar_radiation',
                    'matIso': 'azi000til00.HDiffIso.H',
                    'matPer': 'azi000til00.HDiffPer.H'},
                   {'json': 'total_radiation_s_90',
                    'matIso': 'azi000til90.H',
                    'matPer': 'azi000til90.HPer'},
                   {'json': 'total_beam_radiation_s_90',
                    'mat': 'azi000til90.HDir.H'},
                   {'json': 'total_diffuse_radiation_s_90',
                    'matIso': 'azi000til90.HDiffIso.H',
                    'matPer': 'azi000til90.HDiffPer.H'},
                   {'json': 'total_radiation_e_90',
                    'matIso': 'azi270til90.H',
                    'matPer': 'azi270til90.HPer'},
                   {'json': 'total_beam_radiation_e_90',
                    'mat': 'azi270til90.HDir.H'},
                   {'json': 'total_diffuse_radiation_e_90',
                    'matIso': 'azi270til90.HDiffIso.H',
                    'matPer': 'azi270til90.HDiffPer.H'},
                   {'json': 'total_radiation_n_90',
                    'matIso': 'azi180til90.H',
                    'matPer': 'azi180til90.HPer'},
                   {'json': 'total_beam_radiation_n_90',
                    'mat': 'azi180til90.HDir.H'},
                   {'json': 'total_diffuse_radiation_n_90',
                    'matIso': 'azi180til90.HDiffIso.H',
                    'matPer': 'azi180til90.HDiffPer.H'},
                   {'json': 'total_radiation_w_90',
                    'matIso': 'azi090til90.H',
                    'matPer': 'azi090til90.HPer'},
                   {'json': 'total_beam_radiation_w_90',
                    'mat': 'azi090til90.HDir.H'},
                   {'json': 'total_diffuse_radiation_w_90',
                    'matIso': 'azi090til90.HDiffIso.H',
                    'matPer': 'azi090til90.HDiffPer.H'},
                   {'json': 'total_radiation_45_e_90',
                    'matIso': 'azi315til90.H',
                    'matPer': 'azi315til90.HPer'},
                   {'json': 'total_beam_radiation_45_e_90',
                    'mat': 'azi315til90.HDir.H'},
                   {'json': 'total_diffuse_radiation_45_e_90',
                    'matIso': 'azi315til90.HDiffIso.H',
                    'matPer': 'azi315til90.HDiffPer.H'},
                   {'json': 'total_radiation_45_w_90',
                    'matIso': 'azi045til90.H',
                    'matPer': 'azi045til90.HPer'},
                   {'json': 'total_beam_radiation_45_w_90',
                    'mat': 'azi045til90.HDir.H'},
                   {'json': 'total_diffuse_radiation_45_w_90',
                    'matIso': 'azi045til90.HDiffIso.H',
                    'matPer': 'azi045til90.HDiffPer.H'},
                   {'json': 'total_radiation_e_30',
                    'matIso': 'azi270til30.H',
                    'matPer': 'azi270til30.HPer'},
                   {'json': 'total_beam_radiation_e_30',
                    'mat': 'azi270til30.HDir.H'},
                   {'json': 'total_diffuse_radiation_e_30',
                    'matIso': 'azi270til30.HDiffIso.H',
                    'matPer': 'azi270til30.HDiffPer.H'},
                   {'json': 'total_radiation_s_30',
                    'matIso': 'azi000til30.H',
                    'matPer': 'azi000til30.HPer'},
                   {'json': 'total_beam_radiation_s_30',
                    'mat': 'azi000til30.HDir.H'},
                   {'json': 'total_diffuse_radiation_s_30',
                    'matIso': 'azi000til30.HDiffIso.H',
                    'matPer': 'azi000til30.HDiffPer.H'},
                   {'json': 'total_radiation_w_30',
                    'matIso': 'azi090til30.H',
                    'matPer': 'azi090til30.HPer'},
                   {'json': 'total_beam_radiation_w_30',
                    'mat': 'azi090til30.HDir.H'},
                   {'json': 'total_diffuse_radiation_w_30',
                    'matIso': 'azi090til30.HDiffIso.H',
                    'matPer': 'azi090til30.HDiffPer.H'}]
    Days = {'WD100': {'days': ['yearly', 'may4', 'jul14', 'sep6'],
                      'tstart': [0, 10627200, 16761600, 21427200],
                      'tstop': [0, 10713600, 16848000, 21513600]},
            'WD200': {'days': ['yearly', 'may24', 'aug26'],
                      'tstart': [0, 12355200, 20476800, 0],
                      'tstop': [0, 12441600, 20563200, 31536000]},
            'WD300': {'days': ['yearly', 'feb7', 'aug13'],
                      'tstart': [0, 3196800, 19353600],
                      'tstop': [0, 3283200, 19440000]},
            'WD400': {'days': ['yearly', 'jan24', 'jul1'],
                      'tstart': [0, 1987200, 15638400],
                      'tstop': [0, 2073600, 15724800]},
            'WD500': {'days': ['yearly', 'mar1', 'sep14'],
                      'tstart': [0, 5097600, 22118400],
                      'tstop': [0, 5184000, 22204800]},
            'WD600': {'days': ['yearly', 'may4', 'jul14', 'sep6'],
                      'tstart': [0, 10627200, 16761600, 21427200],
                      'tstop': [0, 10713600, 16848000, 21513600]}}
    Days2 = {'WD100': {'days': ['test2'],
                       'tstart': [0],
                       'tstop': [31536000+3600]},
             'WD200': {'days': ['test2'],
                       'tstart': [0],
                       'tstop': [31536000+3600]},
             'WD300': {'days': ['test2'],
                       'tstart': [0],
                       'tstop': [31536000+3600]},
             'WD400': {'days': ['test2'],
                       'tstart': [0],
                       'tstop': [31536000+3600]},
             'WD500': {'days': ['test2'],
                       'tstart': [0],
                       'tstop': [31536000+3600]},
             'WD600': {'days': ['test2'],
                       'tstart': [0],
                       'tstop': [31536000+3600]}}

    dictTest2 =  [{'json': 'dry_bulb_temperature',
                   'mat': 'weaBusHHorIR.TDryBul'},
                  {'json': 'relative_humidity',
                   'mat': 'weaBusHHorIR.relHum'},
                  {'json': 'humidity_ratio',
                   'mat': 'toDryAir.XiDry'},
                  {'json': 'dewpoint_temperature',
                   'mat': 'weaBusHHorIR.TDewPoi'},
                  {'json': 'wet_bulb_temperature',
                   'mat': 'weaBusHHorIR.TWetBul'},
                  {'json': 'wind_speed',
                   'mat': 'weaBusHHorIR.winSpe'},
                  {'json': 'wind_direction',
                   'mat': 'weaBusHHorIR.winDir'},
                  {'json': 'station_pressure',
                   'mat': 'weaBusHHorIR.pAtm'},
                  {'json': 'total_cloud_cover',
                   'mat': 'weaBusHHorIR.nTot'},
                  {'json': 'opaque_cloud_cover',
                   'mat': 'weaBusHHorIR.nOpa'},
                  {'json': 'sky_temperature',
                   'matHor': 'weaBusHHorIR.TBlaSky',
                   'matDew': 'weaBusTDryBulTDewPoiOpa.TBlaSky'},
                  {'json': 'total_horizontal_radiation',
                   'matIso': 'azi000til00.H',
                   'matPer': 'azi000til00.HPer'},
                  {'json': 'beam_horizontal_radiation',
                   'mat': 'azi000til00.HDir.H'},
                  {'json': 'diffuse_horizontal_radiation',
                   'matIso': 'azi000til00.HDiffIso.H',
                   'matPer': 'azi000til00.HDiffPer.H'},
                  {'json': 'total_radiation_s_90',
                   'matIso': 'azi000til90.H',
                   'matPer': 'azi000til90.HPer'},
                  {'json': 'beam_radiation_s_90',
                   'mat': 'azi000til90.HDir.H'},
                  {'json': 'diffuse_radiation_s_90',
                   'matIso': 'azi000til90.HDiffIso.H',
                   'matPer': 'azi000til90.HDiffPer.H'},
                  {'json': 'total_radiation_e_90',
                   'matIso': 'azi270til90.H',
                   'matPer': 'azi270til90.HPer'},
                  {'json': 'beam_radiation_e_90',
                   'mat': 'azi270til90.HDir.H'},
                  {'json': 'diffuse_radiation_e_90',
                   'matIso': 'azi270til90.HDiffIso.H',
                   'matPer': 'azi270til90.HDiffPer.H'},
                  {'json': 'total_radiation_n_90',
                   'matIso': 'azi180til90.H',
                   'matPer': 'azi180til90.HPer'},
                  {'json': 'beam_radiation_n_90',
                   'mat': 'azi180til90.HDir.H'},
                  {'json': 'diffuse_radiation_n_90',
                   'matIso': 'azi180til90.HDiffIso.H',
                   'matPer': 'azi180til90.HDiffPer.H'},
                  {'json': 'total_radiation_w_90',
                   'matIso': 'azi090til90.H',
                   'matPer': 'azi090til90.HPer'},
                  {'json': 'beam_radiation_w_90',
                   'mat': 'azi090til90.HDir.H'},
                  {'json': 'diffuse_radiation_w_90',
                   'matIso': 'azi090til90.HDiffIso.H',
                   'matPer': 'azi090til90.HDiffPer.H'},
                  {'json': 'total_radiation_45_e_90',
                   'matIso': 'azi315til90.H',
                   'matPer': 'azi315til90.HPer'},
                  {'json': 'beam_radiation_45_e_90',
                   'mat': 'azi315til90.HDir.H'},
                  {'json': 'diffuse_radiation_45_e_90',
                   'matIso': 'azi315til90.HDiffIso.H',
                   'matPer': 'azi315til90.HDiffPer.H'},
                  {'json': 'total_radiation_45_w_90',
                   'matIso': 'azi045til90.H',
                   'matPer': 'azi045til90.HPer'},
                  {'json': 'beam_radiation_45_w_90',
                   'mat': 'azi045til90.HDir.H'},
                  {'json': 'diffuse_radiation_45_w_90',
                   'matIso': 'azi045til90.HDiffIso.H',
                   'matPer': 'azi045til90.HDiffPer.H'},
                  {'json': 'total_radiation_e_30',
                   'matIso': 'azi270til30.H',
                   'matPer': 'azi270til30.HPer'},
                  {'json': 'beam_radiation_e_30',
                   'mat': 'azi270til30.HDir.H'},
                  {'json': 'diffuse_radiation_e_30',
                   'matIso': 'azi270til30.HDiffIso.H',
                   'matPer': 'azi270til30.HDiffPer.H'},
                  {'json': 'total_radiation_s_30',
                   'matIso': 'azi000til30.H',
                   'matPer': 'azi000til30.HPer'},
                  {'json': 'beam_radiation_s_30',
                   'mat': 'azi000til30.HDir.H'},
                  {'json': 'diffuse_radiation_s_30',
                   'matIso': 'azi000til30.HDiffIso.H',
                   'matPer': 'azi000til30.HDiffPer.H'},
                  {'json': 'total_radiation_w_30',
                   'matIso': 'azi090til30.H',
                   'matPer': 'azi090til30.HPer'},
                  {'json': 'beam_radiation_w_30',
                   'mat': 'azi090til30.HDir.H'},
                  {'json': 'diffuse_radiation_w_30',
                   'matIso': 'azi090til30.HDiffIso.H',
                   'matPer': 'azi090til30.HDiffPer.H'}]

    if case_dict['TestN']:
        caseDays = [{key: value[i] for key, value in Days2[case].items()}
                    for i in range(len(Days2[case]['days']))]
    else:
        caseDays = [{key: value[i] for key, value in Days[case].items()}
                    for i in range(len(Days[case]['days']))]

    out_dir = res_fin

    missing = list()
    for dR in results:
        for day in caseDays:
            if day['days'] in 'yearly':
                res = extrapolate_results(dict_yearly, dR, day)
                if not res:
                    missing.append(day['days'] + '_' + dR['variable'])
                else:
                    # float(res['res'])
                    out_dir[case]['annual_results'][res['json']] =\
                        float(res['res'])
            elif day['days'] in 'test2':
                ressH = extrapolate_results(dictTest2, dR, day)
                if 'dry_bulb_temperature' in ressH['json']:
                    out_dir[case]['hour_of_year'] = (ressH['time']/
                                                     3600).tolist()
                out_dir[case][ressH['json']] = ressH['res'].tolist()

            else:
                resH = extrapolate_results(dict_hourly, dR, day)
                ressH = extrapolate_results(dict_sub_hourly, dR, day)
                if not resH:
                    missing.append(day['days'] + '_hourly_' + dR['variable'])
                else:
                    resH['res'] = resH['res'][0::4]
                    resH['time'] = resH['time'][0::4]
                    HRlist = list()
                    k = 0
                    for HR in resH['res']:
                        HRdict = {}
                        HRdict['time'] = float((resH['time'][k] -
                                                resH['time'][0]) / 3600)
                        HRdict['value'] = float(HR)
                        HRlist.append(HRdict)
                        k += 1
                    out_dir[case]['hourly_results'][day['days']]\
                        [resH['json']] = HRlist

                if not ressH:
                    missing.append(day['days'] + '_subhourly_' +
                                   dR['variable'])
                else:
                    sHRlist = list()
                    k = 0
                    for sHR in ressH['res']:

                        sHRdict = {}
                        sHRdict['time'] = float((ressH['time'][k] -
                                                 ressH['time'][0]) / 3600)
                        if 'radiation' in ressH['json']:
                            sHRdict['value'] = float(sHR)
                        else:
                            sHRdict['value'] = float(sHR)
                        sHRlist.append(sHRdict)
                        k += 1
                    out_dir[case]['subhourly_results'][day['days']]\
                        [ressH['json']] = sHRlist
                    # Manually update integrated values for 'integrated'
                    # variables for subhourly results
                    if 'horizontal_radiation' in ressH['json']:
                        ressH['time'] = ressH['time']
                        time_int = ressH['time'][0::4]
                        H_int = np.interp(time_int, ressH['time'],
                                          ressH['res'])
                        sHRlist = list()
                        k = 0
                        for sHR in H_int:
                            sHRdict = {}
                            sHRdict['time'] = float((time_int[k] -
                                                     time_int[0]) / 3600)
                            sHRdict['value'] = float(sHR)
                            sHRlist.append(sHRdict)
                            k += 1
                        out_dir[case]['subhourly_results']\
                            [day['days']]['integrated_' +
                                          ressH['json']] = sHRlist
    return out_dir

def extrapolate_results(dicT, dR, day):
    """
    This function takes a result time series, matches it with the corresponding
    json, and extrapolates the data

    :param dictT: This is the dictionary with the mapping between .mat and \
        .Json variables
    :param dR: Dictionary with the name, time and value of certain variables\
         in the .mat file
    :param day: Subdictionary with all the days required for the bestest. \
        See table 3 in BESTEST package
    """
    OutDict = {}
    for dT in dicT:
        if dR['variable'] in list(dT.values()) and 'integrated' not in\
           dT['json']:
            if day['days'] in 'yearly':
                if 'azi' in dR['variable']:
                    res = np.trapz(dR['value'], x=dR['time']) / 3600

                else:
                    res = np.mean(dR['value'])
            else:
                tStart = day['tstart']
                tStop = day['tstop']
                idxStart = find_nearest(dR['time'], tStart)
                idxStop = find_nearest(dR['time'], tStop)
                res = dR['value'][idxStart:idxStop+1]
                OutDict['time'] = dR['time'][idxStart:idxStop+1]
            OutDict['res'] = res
            OutDict.update(dT)
    return OutDict


def find_nearest(array, value):
    '''
    This function finds the nearest desired value 'value' in an array 'array'
    :param array: np.array
    :param value: treshold value to calculate nearest
    '''
    array = np.asarray(array)
    idx = (np.abs(array - value)).argmin()
    return idx


def removestring(Slist, String):
    '''
    This function strips a list of strings from elements that contain a
     certain substring
    :param Slist: list of strings to be stripped
    :param String: string that will be stripped
    '''
    Slist[:] = [x for x in Slist if String not in x]
    return Slist


def remove_readonly(fn, path, excinfo):
    '''
    This function is complementary to shutil remove tree, allowing to remove
    the generated read only file from git when using the FROM_GIT_HUB option
    :param fn: file name
    :param path: file path
    :param excinfo: execption info
    '''
    try:
        os.chmod(path, stat.S_IWRITE)
        fn(path)
    except Exception as exc:
        print("Skipped:", path, "because:\n", exc)


# ###########End of functions main code portion###################
if __name__ == '__main__':
    from multiprocessing import Pool, freeze_support

    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument('-c', help='Specify to enable ci-testing (will delete\
                        output files not stored in version control).',
                        action='store_true')
    parser.add_argument('-g', help='Specify to get the library from github.',
                        action='store_true')
    parser.add_argument('-p', help='Specify to pretty print json output.',
                        action='store_true')
    parser.add_argument('-t', help='Specify .json result type -t for \
                        .jsonFormat2 no -t for .jsonFormat1',
                        action='store_true')
    parser.add_argument('-v', help='Specify if code will be verbose',
                        action='store_true')
    args = parser.parse_args()

    CI_TESTING = args.c
    FROM_GIT_HUB = args.g
    # Make code Verbose
    CODE_VERBOSE = args.v
    pretty_print = args.p
    TestN = args.t

    case_dict = {'PACKAGES': PACKAGES,
                 'CASES': CASES,
                 'result_vars': result_vars,
                 'start_time': 0,
                 'StopTime': 31536000,
                 'Solver': 'Euler',
                 'set_tolerance': 1E-6,
                 'show_GUI': False,
                 'n_intervals': 35040,
                 'from_git_hub': FROM_GIT_HUB or not CI_TESTING,
                 'BRANCH': BRANCH,
                 'LIBPATH': LIBPATH,
                 'CLEAN_MAT': CLEAN_MAT,
                 'DEL_EVR': DEL_EVR or CI_TESTING,
                 'CODE_VERBOSE': CODE_VERBOSE,
                 'lib_name': library_name,
                 'TestN': TestN}
    if CI_TESTING or not POST_PROCESS_ONLY:
        # Get list of case to simulate with their parameters
        list_of_cases = get_cases(case_dict)
        # Directory where library is checked out out copied to
        temp_lib_dir = create_working_directory()
        d = checkout_repository(temp_lib_dir, case_dict)
        # Copy library to temporary directories
        for case in list_of_cases:
            shutil.copytree(
                os.path.join(temp_lib_dir, library_name),
                os.path.join(case['wor_dir'], library_name))

        program_version_release_date = d['commit_time']
        program_name_and_version = d['lib_name'] + ' ' + library_version +\
            ' commit: ' + d['commit']
        program_name = d['lib_name']
        program_version = library_version + ' commit: ' + d['commit']

        # Run all cases
        # Create top-level result directory if it does not yet exist
        if not os.path.exists(get_result_directory()):
            os.mkdir(get_result_directory())
        freeze_support()  # You need this in windows
        po = Pool()
        po.map(_simulate, list_of_cases)
        po.close()
        po.join()  # Block at this line until all processes are done

        # Delete temporary directories
        for case in list_of_cases:
            # Delete simulation directory
            shutil.rmtree(case['wor_dir'])
        # Delete temporary library directory
        shutil.rmtree(temp_lib_dir, onerror=remove_readonly)

    # Post process only
    if POST_PROCESS_ONLY:
        print('Add Manually program realease date and version at the end\
              of the script')
        program_version_release_date = 'AddManually'
        program_name_and_version = 'AddManually'
        program_name = "AddManually"
        program_version = "AddManually"

    # Organize results
    mat_dir = get_result_directory()
    Matfd = _organize_cases(mat_dir,case_dict)
    # Create Json file for each case (ISO,PEREZ,TBSKY_HOR,TBSKY_DEW)
    # Import results template
    if TestN:
        json_name = os.path.join(script_path, 'WeatherDriversResultsSubmittal2.json')
    else:
        json_name = os.path.join(script_path, 'WeatherDriversResultsSubmittal1.json')
    res_form = None
    with open(json_name) as f:
        res_form = json.load(f)
    # Add library and organization details
    res_form["modeler_organization"] = modeler_organization
    res_form["modeler_organization_for_tables_and_charts"] = \
        modeler_organization_for_tables_and_charts

    if TestN:
        res_form["program_name"] = program_name
        res_form["program_version"] = program_version
    else:
        res_form["program_name_and_version"] = program_name_and_version

    res_form["program_name_for_tables_and_charts"] = \
        program_name_for_tables_and_charts
    res_form["program_version_release_date"] = program_version_release_date
    res_form["results_submission_date"] = results_submission_date

    # Create new Json result folder
    nJsonRes = os.path.join(mat_dir, 'JsonResults')
    if not os.path.exists(nJsonRes):
        os.makedirs(nJsonRes)
    # Execute all the Subcases
    if CODE_VERBOSE:
        print(f"Converting .mat files into .json and copying it into {nJsonRes}")
    Subcases = ['Iso', 'Per']
    separators = None if pretty_print else (',', ':')
    indent = 2 if pretty_print else None
    for Subcase in Subcases:
        if Subcase in 'Iso':
            case_dictIsoHor = copy.deepcopy(case_dict)
            case_dictIsoHor['result_vars'] = removestring(
                case_dictIsoHor['result_vars'], 'Per')
            case_dictIsoHor['result_vars'] = removestring(
                case_dictIsoHor['result_vars'], 'weaBusTDryBulTDewPoiOpa')
            res_finIsoHor = weather_json(res_form, Matfd, case_dictIsoHor)
            with open(os.path.join(nJsonRes, 'WeatherIsoHHorIR.json'), 'w') as\
                outfile :
                json.dump(res_finIsoHor, outfile, sort_keys=True,
                          indent=indent, separators=separators)
            case_dictIsoDew = copy.deepcopy(case_dict)
            case_dictIsoDew['result_vars'] = \
                removestring(case_dictIsoDew['result_vars'], 'Per')
            case_dictIsoDew['result_vars'] = removestring(
                case_dictIsoDew['result_vars'], 'weaBusHHorIR.TBlaSky')
            res_finIsoDew = weather_json(res_form, Matfd, case_dictIsoDew)
            with open(os.path.join(nJsonRes,
                        'WeatherIsoTDryBulTDewPoinOpa.json'), 'w') as outfile:
                json.dump(res_finIsoDew, outfile, sort_keys=True, indent=indent,
                          separators=separators)
        elif Subcase in 'Per':
            case_dictPerHor = copy.deepcopy(case_dict)
            TestList = copy.deepcopy(case_dictPerHor['result_vars'])
            remove_list = removestring(TestList, 'Per')
            remove_list = removestring(remove_list, 'weaBus')
            remove_list = removestring(remove_list, 'toDryAir')
            remove_list = removestring(remove_list, 'HDir')
            case_list = list(filter(lambda i: i not in remove_list,
                                    case_dictPerHor['result_vars']))
            case_dictPerHor['result_vars'] = case_list
            case_dictPerHor['result_vars'] = removestring(
                case_dictPerHor['result_vars'], 'weaBusTDryBulTDewPoiOpa')
            res_finPerHor = weather_json(res_form, Matfd, case_dictPerHor)
            with open(os.path.join(nJsonRes, 'WeatherPerHHorIR.json'), 'w') \
                      as outfile:
                json.dump(res_finPerHor, outfile, sort_keys=True,
                          indent=indent, separators=separators)
            case_dictPerDew = copy.deepcopy(case_dict)
            TestList = copy.deepcopy(case_dictPerDew['result_vars'])
            remove_list = removestring(TestList, 'Per')
            remove_list = removestring(remove_list, 'weaBus')
            remove_list = removestring(remove_list, 'toDryAir')
            remove_list = removestring(remove_list, 'HDir')
            case_list = list(filter(lambda i: i not in remove_list,
                                    case_dictPerDew['result_vars']))
            case_dictPerDew['result_vars'] = case_list
            case_dictPerDew['result_vars'] = removestring(
                case_dictPerDew['result_vars'], 'weaBusHHorIR.TBlaSky')
            res_finPerDew = weather_json(res_form, Matfd, case_dictPerDew)
            with open(os.path.join(nJsonRes,
                      'WeatherPerTDryBulTDewPoinOpa.json'), 'w') as outfile:
                json.dump(res_finPerDew, outfile, sort_keys=True,
                          indent=indent, separators=separators)
    if DEL_EVR or CI_TESTING:
        if CODE_VERBOSE:
            print(" Erasing .mat result files.")
            for matfd in Matfd:
                shutil.rmtree(os.path.dirname(matfd['mat_file']))

    # If part of CI testing, delete the results directory because
    # results/JsonResults is around 8 MB large and hence not worth storing
    # in git
    if CI_TESTING:
        print(" Erasing .json result files.")
        shutil.rmtree(get_result_directory())
