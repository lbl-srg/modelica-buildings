#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#######################################################
# Script that runs all unit tests or, optionally,
# only checks the html syntax or the validity of
# the simulation parameters of the models
#
# To run the unit tests, this script
# - creates temporary directories for each processor,
# - copies the library directory into these
#   temporary directories,
# - creates run scripts that run all unit tests,
# - runs these unit tests,
# - collects the dymola log files from each process,
# - writes the combined log file 'unitTests.log'
#   in the current directory,
# - checks whether all unit tests run successfully,
#   and produced the same results as the reference
#   results, and
# - exits with the message
#    'Unit tests completed successfully.' or with
#   an error message.
#
# If no errors occurred during the unit tests, then
# this script returns 0. Otherwise, it returns a
# non-zero exit value.
#######################################################
from __future__ import absolute_import
from __future__ import division
from __future__ import print_function


def _validate_experiment_setup(path):
    import buildingspy.development.validator as v

    val = v.Validator()
    # This throws a ValueError exception if the experiment setup is incorrect
    val.validateExperimentSetup(path)


def _validate_html(path):
    import buildingspy.development.validator as v

    val = v.Validator()
    errMsg = val.validateHTMLInPackage(path)
    n_msg = len(errMsg)
    for i in range(n_msg):
        if i == 0:
            print(
                "The following malformed html syntax has been found:\n{}".format(errMsg[i]))
        else:
            print(errMsg[i])

    if n_msg == 0:
        return 0
    else:
        return 1


def _setEnvironmentVariables(var, value):
    ''' Add to the environment variable `var` the value `value`
    '''
    import os
    import platform
    if var in os.environ:
        if platform.system() == "Windows":
            os.environ[var] = value + ";" + os.environ[var]
        else:
            os.environ[var] = value + ":" + os.environ[var]
    else:
        os.environ[var] = value


def _runUnitTests(batch, tool, package, path, n_pro, show_gui, skip_verification, debug, color, rewriteConfigurationFile):
    import buildingspy.development.regressiontest as u

    ut = u.Tester(tool=tool, skip_verification=skip_verification, color=color, rewriteConfigurationFile=rewriteConfigurationFile)
    ut.batchMode(batch)
    ut.setLibraryRoot(path)
    if package is not None:
        ut.setSinglePackage(package)
    ut.setNumberOfThreads(n_pro)
    ut.pedanticModelica(True)
    ut.showGUI(show_gui)
    if debug:
        ut.deleteTemporaryDirectories(False)

    # Below are some option that may occassionally be used.
    # These are currently not exposed as command line arguments.
#    ut.useExistingResults(['/tmp/tmp-Buildings-0-fagmeZ'])
    ut.writeOpenModelicaResultDictionary()
    # Run the regression tests
    retVal = ut.run()

    # Display HTML report if not run in batch mode.
    # (For buildingspy.__version__ >= 2)
    if not batch:
        try:
            if not skip_verification:
                ut.report()
        except AttributeError:
            pass

    return retVal


if __name__ == '__main__':
    import multiprocessing
    import platform
    import argparse
    import os
    import sys

    # Configure the argument parser
    parser = argparse.ArgumentParser(
        description='Run the unit tests or the html validation only.')
    unit_test_group = parser.add_argument_group("arguments to run unit tests")

    unit_test_group.add_argument("-b", "--batch",
                                 action="store_true",
                                 help="Run in batch mode without user interaction")
    unit_test_group.add_argument('-t', "--tool",
                                 metavar="dymola",
                                 default="dymola",
                                 help="Tool for the regression tests. Set to dymola, openmodelica or optimica")
    unit_test_group.add_argument('-s', "--single-package",
                                 metavar="Modelica.Package",
                                 help="Test only the Modelica package Modelica.Package")
    unit_test_group.add_argument("-p", "--path",
                                 default=".",
                                 help="Path where top-level package.mo of the library is located")
    unit_test_group.add_argument("-n", "--number-of-processors",
                                 type=int,
                                 default=multiprocessing.cpu_count(),
                                 help='Maximum number of processors to be used')
    unit_test_group.add_argument("--show-gui",
                                 help='Show the GUI of the simulator',
                                 action="store_true")
    unit_test_group.add_argument("--skip-verification",
                                 help='If specified, do not verify simulation results against reference points',
                                 action="store_true")
    unit_test_group.add_argument('-d', "--debug",
                                 action="store_true",
                                 help="Enable debug output.")
    unit_test_group.add_argument("--rewrite-configuration-file",
                                 help='If specified, rewrite the configuration file conf.yml (implemented for openmodelica only)',
                                 action="store_true")

    html_group = parser.add_argument_group(
        "arguments to check html syntax only")
    html_group.add_argument("--validate-html-only",
                            action="store_true")

    experiment_setup_group = parser.add_argument_group(
        "arguments to check validity of .mos and .mo experiment setup only")
    experiment_setup_group.add_argument("--validate-experiment-setup",
                                        action="store_true")

    # Set environment variables
    if platform.system() == "Windows":
        _setEnvironmentVariables("PATH",
                                 os.path.join(os.path.abspath('.'),
                                              "Resources", "Library", "win32"))
    else:
        # For https://github.com/lbl-srg/modelica-buildings/issues/559, we add
        # 32 and 64 bit resources to run the Utilities.IO.Python27 regression tests.
        _setEnvironmentVariables("LD_LIBRARY_PATH",
                                 os.path.join(os.path.abspath('.'),
                                              "Resources", "Library", "linux32") + ":" +
                                 os.path.join(os.path.abspath('.'),
                                              "Resources", "Library", "linux64"))

    # The path to buildingspy must be added to sys.path to work on Linux.
    # If only added to os.environ, the Python interpreter won't find buildingspy
    sys.path.append(os.path.join(
        os.path.abspath('.'), "..", "..", "BuildingsPy"))

    # Parse the arguments
    args = parser.parse_args()

    if args.validate_html_only:
        # Validate the html syntax only, and then exit
        ret_val = _validate_html(args.path)
        exit(ret_val)

    if args.validate_experiment_setup:
        # Match the mos file parameters with the mo files only, and then exit
        # The call below throws a ValueError exception if the experiment setup is incorrect
        _validate_experiment_setup(args.path)
        exit(0)

    if args.single_package:
        single_package = args.single_package
    else:
        single_package = None

    retVal = _runUnitTests(batch=args.batch,
                           tool=args.tool,
                           package=single_package,
                           path=args.path,
                           n_pro=args.number_of_processors,
                           show_gui=args.show_gui,
                           skip_verification=args.skip_verification,
                           debug=args.debug,
                           color=True,
                           rewriteConfigurationFile=args.rewrite_configuration_file)
    exit(retVal)
