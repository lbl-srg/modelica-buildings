within Buildings.Experimental.DistrictHeatingCooling.SubStations.VaporCompression.BaseClasses;
function getPeakLoad "Function that reads the peak load from the load profile"
  input String string "String that is written before the '=' sign";
  input String filNam "Name of data file with heating and cooling load"
   annotation (Dialog(
        loadSelector(filter="Load file (*.mos)", caption=
            "Select load file")));
  output Real number "Number that is read from the file";
protected
 String lin "Line that is used in parser";
 Integer iLin "Line number";
 Integer index =  0 "Index of string 'string'";
 Integer staInd "Start index used when parsing a real number";
 Integer nexInd "Next index used when parsing a real number";
 Boolean found "Flag, true if 'string' has been found";
 Boolean EOF "Flag, true if EOF has been reached";
 String del "Found delimiter";
algorithm
  // Get line that contains 'string'
  iLin :=0;
  EOF :=false;
  while (not EOF) and (index == 0) loop
    iLin:=iLin + 1;
    (lin, EOF) :=Modelica.Utilities.Streams.readLine(
      fileName=Buildings.BoundaryConditions.WeatherData.BaseClasses.getAbsolutePath(filNam),
      lineNumber=iLin);
    index :=Modelica.Utilities.Strings.find(
      string=lin,
      searchString=string,
      startIndex=1,
      caseSensitive=true);
  end while;
  assert(not EOF, "Error: Did not find '" + string + "' when scanning '" + filNam + "'."
                      + "\n   Check for correct file syntax.");

  // Search for the equality sign
  (del, nexInd) :=Modelica.Utilities.Strings.scanDelimiter(
    string=lin,
    startIndex=Modelica.Utilities.Strings.length(string)+1,
    requiredDelimiters={"="},
    message="Failed to find '=' when reading peak load in '" + filNam + "'.");

  // Read the value behind it.
  number :=Modelica.Utilities.Strings.scanReal(
    string=lin,
    startIndex=nexInd,
    message="Failed to read double value when reading peak load in '" + filNam + "'.");

// fixme: add documentation
end getPeakLoad;
