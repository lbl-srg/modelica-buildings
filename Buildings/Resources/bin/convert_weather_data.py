#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
EPW to MOS Weather Data Converter

This script converts weather data files from EnergyPlus .epw format to
Modelica Buildings Library .mos format.

The EPW (EnergyPlus Weather) format is a CSV-based format containing hourly
or sub-hourly weather data including temperature, humidity, solar radiation,
wind, and other meteorological variables.

The MOS format is a tab-delimited text file with header comments that can
be read by the Modelica Buildings Library weather data reader.

Original Java implementation by:
    Wangda Zuo (WZuo@lbl.gov)
    Michael Wetter (MWetter@lbl.gov)
    Lawrence Berkeley National Laboratory
    Version 1.0, July 14, 2010

Python conversion maintains full compatibility with the original converter by:
    Ettore Zanetti (ezanetti@lbl.gov)
    Version 1.0, January 2, 2026

Usage:
    python convert_weather_data.py input_file.epw
    python convert_weather_data.py input_file.epw -o output_file.mos
    python convert_weather_data.py input_file.epw --verbose
"""

import argparse
import logging
import sys
from pathlib import Path
from typing import Optional

# -----------------------------------------------------------------------------
# Logging Configuration
# -----------------------------------------------------------------------------
# Set up a module-level logger. The logging level and format can be adjusted
# via command-line arguments or by modifying the configuration below.

logger = logging.getLogger(__name__)
logger.setLevel(logging.DEBUG)

# Create console handler with formatting
console_handler = logging.StreamHandler()
console_handler.setLevel(logging.WARNING)  # Default to WARNING, can be set to DEBUG with --verbose
formatter = logging.Formatter('%(levelname)s: %(message)s')
console_handler.setFormatter(formatter)
logger.addHandler(console_handler)


# -----------------------------------------------------------------------------
# Constants
# -----------------------------------------------------------------------------
# These constants define the structure of the EPW file and the missing data
# indicators used by the EPW format specification.

# Number of header lines in an EPW file before weather data begins.
# Lines 1-8 contain metadata about the location, design conditions, etc.
EPW_HEADER_LINES = 8

# Number of data columns in the output MOS file.
# This corresponds to time (column 1) plus 29 weather variables (columns 2-30).
MOS_DATA_COLUMNS = 30

# Column descriptions for the MOS file.
# These describe each column in the output data table and are written as
# comments in the MOS file header. The index corresponds to the column number.
COLUMN_DESCRIPTIONS = [
    "#C1 Time in seconds. Beginning of a year is 0s.",
    "#C2 Dry bulb temperature in Celsius at indicated time",
    "#C3 Dew point temperature in Celsius at indicated time",
    "#C4 Relative humidity in percent at indicated time",
    "#C5 Atmospheric station pressure in Pa at indicated time",
    "#C6 Extraterrestrial horizontal radiation in Wh/m2",
    "#C7 Extraterrestrial direct normal radiation in Wh/m2",
    "#C8 Horizontal infrared radiation intensity in Wh/m2",
    "#C9 Global horizontal radiation in Wh/m2",
    "#C10 Direct normal radiation in Wh/m2",
    "#C11 Diffuse horizontal radiation in Wh/m2",
    "#C12 Averaged global horizontal illuminance in lux during minutes preceding the indicated time",
    "#C13 Direct normal illuminance in lux during minutes preceding the indicated time",
    "#C14 Diffuse horizontal illuminance in lux during minutes preceding the indicated time",
    "#C15 Zenith luminance in Cd/m2 during minutes preceding the indicated time",
    "#C16 Wind direction at indicated time. N=0, E=90, S=180, W=270",
    "#C17 Wind speed in m/s at indicated time",
    "#C18 Total sky cover at indicated time",
    "#C19 Opaque sky cover at indicated time",
    "#C20 Visibility in km at indicated time",
    "#C21 Ceiling height in m",
    "#C22 Present weather observation",
    "#C23 Present weather codes",
    "#C24 Precipitable water in mm",
    "#C25 Aerosol optical depth",
    "#C26 Snow depth in cm",
    "#C27 Days since last snowfall",
    "#C28 Albedo",
    "#C29 Liquid precipitation depth in mm at indicated time",
    "#C30 Liquid precipitation quantity",
]

# Missing data indicators for each weather variable in the EPW format.
# When these values appear in the EPW file, they indicate the data is missing
# and should be replaced with the previous valid value (or flagged as an error
# if it's the first data line).
#
# The dictionary keys correspond to the 1-based column index in the output
# MOS file (after the time column). These values are defined by the EPW
# file format specification.
MISSING_DATA_INDICATORS = {
    1: "99.9",      # Dry bulb temperature
    2: "99.9",      # Dew point temperature
    3: "999",       # Relative humidity
    4: "999999",    # Atmospheric pressure
    5: "9999",      # Extraterrestrial horizontal radiation
    6: "9999",      # Extraterrestrial direct normal radiation
    7: "9999",      # Horizontal infrared radiation
    8: "9999",      # Global horizontal radiation
    9: "9999",      # Direct normal radiation
    10: "9999",     # Diffuse horizontal radiation
    11: "999999",   # Global horizontal illuminance
    12: "999999",   # Direct normal illuminance
    13: "999999",   # Diffuse horizontal illuminance
    14: "9999",     # Zenith luminance
    15: "999",      # Wind direction
    16: "999",      # Wind speed
    17: "99",       # Total sky cover
    18: "99",       # Opaque sky cover
    19: "9999",     # Visibility
    20: "99999",    # Ceiling height
    21: "9",        # Present weather observation
    22: "9",        # Present weather codes (note: stored as string)
    23: "999",      # Precipitable water
    24: "999",      # Aerosol optical depth
    25: "999",      # Snow depth
    26: "99",       # Days since last snowfall
}

# Cumulative days at the start of each month (non-leap year).
# Used to convert month/day to day-of-year for time calculations.
# Index 0 is unused; indices 1-12 correspond to January-December.
DAYS_BEFORE_MONTH = {
    1: 0,     # January
    2: 31,    # February
    3: 59,    # March
    4: 90,    # April
    5: 120,   # May
    6: 151,   # June
    7: 181,   # July
    8: 212,   # August
    9: 243,   # September
    10: 273,  # October
    11: 304,  # November
    12: 334,  # December
}

def get_simulation_time(year: int, month: int, day: int, hour: int, 
                        minute: int, has_subhourly_data: bool) -> float:
    """
    Convert calendar time to simulation time in seconds.
    
    This function converts a timestamp from the EPW file (given as year, month,
    day, hour, minute) into simulation time in seconds since the beginning of
    the year. The Modelica Buildings Library expects time to start at 0 seconds
    at the beginning of the year.
    
    EPW files use an "end of hour" convention, meaning that the timestamp
    indicates the end of the reporting period. For hourly data, a timestamp
    of hour=1 means data for the period 00:00-01:00. For sub-hourly data,
    the minute field is also populated.
    
    Args:
        year: The year (not used in calculation but included for completeness)
        month: Month of year (1-12)
        day: Day of month (1-31)
        hour: Hour of day (0-24, where 24 means end of day)
        minute: Minute of hour (0-59)
        has_subhourly_data: If True, indicates sub-hourly data is present,
                           which affects the time offset calculation
    
    Returns:
        Simulation time in seconds since the start of the year.
    
    Example:
        >>> get_simulation_time(2020, 1, 1, 1, 0, False)
        0.0  # First hour of data maps to t=0
        >>> get_simulation_time(2020, 1, 1, 2, 0, False)
        3600.0  # Second hour maps to t=3600s
    """
    # Get the number of days completed before this month
    days_completed = DAYS_BEFORE_MONTH.get(month, 0)
    
    # Add the completed days in the current month (day - 1 because current day
    # is not complete)
    total_days = days_completed + (day - 1)
    
    # Convert to hours
    total_hours = (total_days * 24) + hour
    
    # Convert to minutes
    total_minutes = (total_hours * 60) + minute
    
    # Convert to seconds
    simulation_time = float(total_minutes * 60)
    
    # Apply offset for sub-hourly data
    # When sub-hourly data is present, we need to shift back by one hour
    # to align the timestamps correctly with Modelica's expectations
    if has_subhourly_data:
        simulation_time = simulation_time - 3600
    
    logger.debug(f"Time conversion: {month}/{day} {hour}:{minute:02d} -> {simulation_time}s")
    
    return simulation_time

def check_data(value: str, previous_value: Optional[str], missing_indicator: str,
               column_index: int, line_number: int, is_first_data_line: bool) -> str:
    """
    Validate a data value and handle missing data.
    
    EPW files use specific sentinel values to indicate missing data. When
    missing data is encountered, this function either raises an error (if
    it's the first data line and no previous value exists to substitute)
    or returns the previous valid value as a replacement.
    
    Args:
        value: The raw value read from the EPW file
        previous_value: The value from the previous line for this column,
                       used as a replacement for missing data
        missing_indicator: The sentinel value indicating missing data for
                          this particular column
        column_index: The 1-based column index (used for error messages)
        line_number: The current line number in the EPW file (used for
                    error messages)
        is_first_data_line: True if this is the first data line (line 9),
                           which requires valid data in all checked columns
    
    Returns:
        The validated (or corrected) data value as a string.
    
    Raises:
        ValueError: If data is missing on the first data line where no
                   previous value exists for substitution.
    """
    # Get the column description for error messages (strip the #Cn prefix)
    description = COLUMN_DESCRIPTIONS[column_index - 1]
    description = description.split(' ', 1)[1] if ' ' in description else description
    
    # Check if the value matches the missing data indicator
    if value.strip() == missing_indicator:
        if is_first_data_line:
            # Cannot substitute missing data on the first line
            # The EPW column index is offset by 6 due to the time fields
            epw_column = column_index + 6
            error_msg = (
                f"Missing data detected at line 9, column {epw_column} "
                f"({description}). Value '{missing_indicator}' indicates "
                f"missing data. Please fix the EPW file before converting."
            )
            logger.error(error_msg)
            raise ValueError(error_msg)
        else:
            # Substitute with the previous value
            # The MOS line number is offset by 32 from EPW line (8 header + 24 comment lines)
            mos_line = line_number + 32
            logger.warning(
                f"Missing data corrected at line {mos_line}, column {column_index} "
                f"({description}). Using previous value: {previous_value}"
            )
            return previous_value
    
    return value


def check_ceiling_height(value: str, previous_value: Optional[str],
                         line_number: int, is_first_data_line: bool) -> str:
    """
    Validate and correct ceiling height data.
    
    Ceiling height has special handling because certain codes in the EPW
    format indicate unlimited ceiling (clear sky) or missing data:
    - 77777: Unlimited ceiling (clear sky)
    - 88888: Cirroform clouds (essentially unlimited)
    - 99999: Missing data
    
    These are all replaced with 2000m, which is a reasonable default for
    simulation purposes and indicates a high ceiling.
    
    Args:
        value: The raw ceiling height value from the EPW file
        previous_value: The value from the previous line
        line_number: Current line number for error reporting
        is_first_data_line: True if this is the first data line
    
    Returns:
        The validated or corrected ceiling height value as a string.
    """
    # First check for standard missing data
    checked_value = check_data(
        value, previous_value, 
        MISSING_DATA_INDICATORS[20],  # Column 20 is ceiling height
        21,  # MOS column index (20 + 1 for time column)
        line_number, 
        is_first_data_line
    )
    
    # Handle special ceiling height codes
    special_codes = {"77777", "88888", "99999"}
    if checked_value.strip() in special_codes:
        logger.debug(
            f"Ceiling height code {checked_value} replaced with 2000m "
            f"(line {line_number})"
        )
        return "2000"
    
    return checked_value


# -----------------------------------------------------------------------------
# File I/O Functions
# -----------------------------------------------------------------------------

def read_epw_file(filepath: Path) -> tuple[list[str], list[str]]:
    """
    Read an EPW file and separate header lines from data lines.
    
    Args:
        filepath: Path to the EPW file to read
    
    Returns:
        A tuple containing:
        - header_lines: List of the first 8 lines (metadata)
        - data_lines: List of all remaining lines (weather data)
    
    Raises:
        FileNotFoundError: If the EPW file does not exist
        IOError: If there are problems reading the file
    """
    logger.info(f"Reading EPW file: {filepath}")
    
    if not filepath.exists():
        raise FileNotFoundError(f"EPW file not found: {filepath}")
    
    with open(filepath, 'r', encoding='utf-8', errors='replace') as f:
        all_lines = f.readlines()
    
    # Separate header and data
    header_lines = all_lines[:EPW_HEADER_LINES]
    data_lines = all_lines[EPW_HEADER_LINES:]
    
    logger.info(f"Read {len(header_lines)} header lines and {len(data_lines)} data lines")
    
    return header_lines, data_lines


def detect_subhourly_data(data_lines: list[str]) -> bool:
    """
    Detect whether the EPW file contains sub-hourly data.
    
    Sub-hourly data is indicated by non-zero values in the minute field
    (column 5) of the data lines. This function checks the first two data
    lines to make this determination.
    
    The presence of sub-hourly data affects the time offset calculation
    in the conversion process.
    
    Args:
        data_lines: List of data lines from the EPW file
    
    Returns:
        True if sub-hourly data is detected, False otherwise
    """
    if len(data_lines) < 2:
        logger.warning("Not enough data lines to detect sub-hourly data")
        return False
    
    for i, line in enumerate(data_lines[:2]):
        fields = line.strip().split(',')
        if len(fields) >= 5:
            minute = int(fields[4])
            if minute > 0:
                logger.info(f"Sub-hourly data detected (minute={minute} on data line {i+1})")
                return True
    
    logger.debug("No sub-hourly data detected (minute field is 0)")
    return False


def parse_data_line(line: str, line_number: int) -> tuple[list[int], list[str]]:
    """
    Parse a single data line from the EPW file.
    
    Args:
        line: A single line of CSV data from the EPW file
        line_number: The line number in the original file (for error messages)
    
    Returns:
        A tuple containing:
        - time_values: List of 5 integers [year, month, day, hour, minute]
        - weather_values: List of 29 string values for weather variables
    
    Raises:
        ValueError: If the line does not have enough fields
    """
    # Split on comma, handling potential spaces after commas
    fields = [f.strip() for f in line.strip().split(',')]
    
    # EPW data lines should have at least 35 fields
    # (5 time + 1 flag + 29 weather = 35 minimum)
    expected_fields = 35
    if len(fields) < expected_fields:
        raise ValueError(
            f"Line {line_number}: Expected at least {expected_fields} fields, "
            f"got {len(fields)}"
        )
    
    # Extract time values (fields 0-4)
    try:
        time_values = [int(fields[i]) for i in range(5)]
    except ValueError as e:
        raise ValueError(f"Line {line_number}: Error parsing time fields: {e}")
    
    # Skip field 5 (data quality flag) and extract weather values (fields 6-34)
    weather_values = fields[6:35]
    
    logger.debug(
        f"Parsed line {line_number}: time={time_values}, "
        f"weather fields={len(weather_values)}"
    )
    
    return time_values, weather_values

def convert_epw_to_mos(epw_filepath: Path, mos_filepath: Optional[Path] = None) -> Path:
    """
    Convert an EPW weather file to MOS format.
    
    This is the main conversion function that orchestrates the entire process:
    1. Read the EPW file
    2. Detect if sub-hourly data is present
    3. Build the MOS header (metadata + column descriptions)
    4. Convert each data line, validating and correcting missing data
    5. Add a duplicate of the first data point at t=0 for Modelica compatibility
    6. Write the output MOS file
    
    The MOS file structure is:
    - Line 1: "#1" (file format identifier)
    - Line 2: Table dimensions "double tab1(rows, 30)"
    - Lines 3-10: Original EPW header lines (prefixed with #)
    - Lines 11-40: Column descriptions
    - Lines 41+: Tab-separated weather data
    
    Args:
        epw_filepath: Path to the input EPW file
        mos_filepath: Path for the output MOS file. If None, uses the same
                     name as the input file with .mos extension
    
    Returns:
        Path to the created MOS file
    
    Raises:
        FileNotFoundError: If the EPW file doesn't exist
        ValueError: If the EPW file has invalid data that cannot be corrected
    """
    # Determine output filepath if not specified
    if mos_filepath is None:
        mos_filepath = epw_filepath.with_suffix('.mos')
    
    logger.info(f"Converting {epw_filepath} to {mos_filepath}")
    
    # Step 1: Read the EPW file
    header_lines, data_lines = read_epw_file(epw_filepath)
    
    if not data_lines:
        raise ValueError("No data lines found in EPW file")
    
    # Step 2: Detect sub-hourly data
    has_subhourly_data = detect_subhourly_data(data_lines)
    
    # Step 3: Initialize output data structure
    output_lines = []
    
    # Add file format identifier
    output_lines.append("#1")
    
    # Placeholder for table dimensions (will be updated after processing)
    output_lines.append("DIMENSIONS_PLACEHOLDER")
    
    # Add original EPW header lines as comments
    for header_line in header_lines:
        output_lines.append("#" + header_line.strip())
    
    # Add column descriptions
    output_lines.extend(COLUMN_DESCRIPTIONS)
    
    # Step 4: Process data lines
    # Storage for previous values (used for missing data substitution)
    previous_values = {}
    
    # Storage for converted data rows
    data_rows = []
    first_data_row = None
    
    for i, line in enumerate(data_lines):
        # Calculate EPW line number (1-based, accounting for header)
        epw_line_number = EPW_HEADER_LINES + i + 1
        is_first_data_line = (i == 0)
        
        # Skip empty lines
        if not line.strip():
            logger.debug(f"Skipping empty line {epw_line_number}")
            continue
        
        try:
            # Parse the data line
            time_values, weather_values = parse_data_line(line, epw_line_number)
            
            # Convert time to simulation seconds
            sim_time = get_simulation_time(
                time_values[0],  # year
                time_values[1],  # month
                time_values[2],  # day
                time_values[3],  # hour
                time_values[4],  # minute
                has_subhourly_data
            )
            
            # Process weather values with validation
            processed_values = []
            
            # Columns 1-4: Dry bulb temp, dew point temp, relative humidity, pressure
            # These columns require missing data checking
            for col in range(4):
                mos_col = col + 1  # 1-based column index
                value = check_data(
                    weather_values[col],
                    previous_values.get(mos_col),
                    MISSING_DATA_INDICATORS.get(mos_col, ""),
                    mos_col,
                    epw_line_number,
                    is_first_data_line
                )
                processed_values.append(value)
                previous_values[mos_col] = value
            
            # Columns 5-7: Radiation values (no missing data check)
            for col in range(4, 7):
                processed_values.append(weather_values[col])
            
            # Column 8: Global horizontal radiation (missing data check)
            mos_col = 8
            value = check_data(
                weather_values[7],
                previous_values.get(mos_col),
                MISSING_DATA_INDICATORS.get(mos_col, ""),
                mos_col,
                epw_line_number,
                is_first_data_line
            )
            processed_values.append(value)
            previous_values[mos_col] = value
            
            # Column 9: Direct normal radiation (no missing data check)
            processed_values.append(weather_values[8])
            
            # Column 10: Diffuse horizontal radiation (missing data check)
            mos_col = 10
            value = check_data(
                weather_values[9],
                previous_values.get(mos_col),
                MISSING_DATA_INDICATORS.get(mos_col, ""),
                mos_col,
                epw_line_number,
                is_first_data_line
            )
            processed_values.append(value)
            previous_values[mos_col] = value
            
            # Columns 11-16: Illuminance, luminance, wind (no missing data check)
            for col in range(10, 16):
                processed_values.append(weather_values[col])
            
            # Columns 17-18: Total sky cover, opaque sky cover (missing data check)
            for col_offset, mos_col in enumerate([17, 18]):
                value = check_data(
                    weather_values[16 + col_offset],
                    previous_values.get(mos_col),
                    MISSING_DATA_INDICATORS.get(mos_col, ""),
                    mos_col,
                    epw_line_number,
                    is_first_data_line
                )
                processed_values.append(value)
                previous_values[mos_col] = value
            
            # Column 19: Visibility (no missing data check)
            processed_values.append(weather_values[18])
            
            # Column 20: Ceiling height (special handling)
            value = check_ceiling_height(
                weather_values[19],
                previous_values.get(20),
                epw_line_number,
                is_first_data_line
            )
            processed_values.append(value)
            previous_values[20] = value
            
            # Columns 21-29: Remaining weather variables (no missing data check)
            for col in range(20, 29):
                processed_values.append(weather_values[col])
            
            # Build the data row string (tab-separated)
            data_row = str(sim_time) + "\t" + "\t".join(processed_values)
            
            # Handle first data line specially - duplicate at t=0
            if is_first_data_line:
                first_data_row = "0.0" + "\t" + "\t".join(processed_values)
                data_rows.append(first_data_row)
                logger.debug("Added duplicate of first data point at t=0")
            
            data_rows.append(data_row)
            
        except ValueError as e:
            logger.error(f"Error processing line {epw_line_number}: {e}")
            raise
    
    # Step 5: Finalize output
    # Calculate number of data rows (excluding the row at t=31536000 which would
    # duplicate end-of-year data
    data_rows.pop()
    num_data_rows = len(data_rows)
    # Unwrap wind direction (column 16 in MOS, index 15 in tab-separated fields)
    # so that Modelica interpolates along the shorter arc
    wind_dir_col = 15
    wind_dirs = []
    for row in data_rows:
        fields = row.split("\t")
        wind_dirs.append(float(fields[wind_dir_col]))
    
    unwrapped = interpolate_shortest_path(wind_dirs)
    
    for i, row in enumerate(data_rows):
        fields = row.split("\t")
        val = unwrapped[i]
        fields[wind_dir_col] = str(int(val)) if val == int(val) else str(val)
        data_rows[i] = "\t".join(fields)
    
    # Update dimensions placeholder
    dimensions_line = f"double tab1({num_data_rows},{MOS_DATA_COLUMNS})"
    output_lines[1] = dimensions_line
    
    # Add all data rows to output
    output_lines.extend(data_rows)
    
    logger.info(f"Processed {num_data_rows} data rows")
    
    # Step 6: Write output file
    logger.info(f"Writing MOS file: {mos_filepath}")
    
    with open(mos_filepath, 'w', encoding='utf-8') as f:
        for line in output_lines:
            f.write(line + "\n")
    
    logger.info(f"Successfully created {mos_filepath}")
    
    return mos_filepath

def interpolate_shortest_path(angles_deg):
    """Interpolate by always taking the shorter arc between consecutive points."""
    result = [0.0] * len(angles_deg)
    result[0] = angles_deg[0]
    
    for i in range(1, len(angles_deg)):
        diff = angles_deg[i] - angles_deg[i-1]
        while diff > 180:
            diff -= 360
        while diff <= -180:
            diff += 360
        result[i] = result[i-1] + diff
        # Clamp to [-720, 720] while preserving the equivalent angle
        while result[i] > 720:
            result[i] -= 360
        while result[i] < -720:
            result[i] += 360
    
    return result

def parse_arguments() -> argparse.Namespace:
    """
    Parse command line arguments.
    
    Returns:
        Parsed argument namespace containing:
        - input_file: Path to the input EPW file
        - output_file: Optional path to the output MOS file
        - verbose: Boolean flag for verbose output
    """
    parser = argparse.ArgumentParser(
        description="Convert EnergyPlus weather files (.epw) to Modelica format (.mos)",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
    python convert_weather_data.py weather.epw
    python convert_weather_data.py weather.epw -o custom_output.mos
    python convert_weather_data.py weather.epw --verbose
        """
    )
    
    parser.add_argument(
        "input_file",
        type=str,
        help="Path to the input EPW weather data file"
    )
    
    parser.add_argument(
        "-o", "--output",
        type=str,
        default=None,
        dest="output_file",
        help="Path for the output MOS file (default: same name as input with .mos extension)"
    )
    
    parser.add_argument(
        "-v", "--verbose",
        action="store_true",
        help="Enable verbose (debug) output"
    )
    
    return parser.parse_args()


def main():
    """
    Main entry point for the weather data converter.
    
    This function handles command line argument parsing, input validation,
    and orchestrates the conversion process. It also handles errors gracefully
    and provides appropriate exit codes.
    
    Exit codes:
        0: Success
        1: Invalid arguments or file not found
        2: Conversion error (invalid data in EPW file)
    """
    # Parse command line arguments
    args = parse_arguments()
    
    # Configure logging level based on verbose flag
    if args.verbose:
        console_handler.setLevel(logging.DEBUG)
        logger.info("Verbose mode enabled")
    
    # Validate input file
    input_path = Path(args.input_file)
    
    if not input_path.suffix.lower() == '.epw':
        logger.error(
            f"Input file must have .epw extension. Got: {input_path.suffix}"
        )
        logger.info("Usage: python convert_weather_data.py inputFile.epw")
        sys.exit(1)
    
    if not input_path.exists():
        logger.error(f"Input file not found: {input_path}")
        sys.exit(1)
    
    # Determine output path
    output_path = Path(args.output_file) if args.output_file else None
    
    # Perform conversion
    try:
        result_path = convert_epw_to_mos(input_path, output_path)
        logger.info(f"Conversion complete: {result_path}")
        sys.exit(0)
        
    except FileNotFoundError as e:
        logger.error(f"File error: {e}")
        sys.exit(1)
        
    except ValueError as e:
        logger.error(f"Data error: {e}")
        logger.info("Please fix the EPW file and try again.")
        sys.exit(2)
        
    except Exception as e:
        logger.error(f"Unexpected error: {e}")
        if args.verbose:
            import traceback
            traceback.print_exc()
        sys.exit(2)


if __name__ == "__main__":
    main()

