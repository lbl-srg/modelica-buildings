within Buildings.BoundaryConditions.WeatherData.BaseClasses;
function getTimeSpanTMY3
  "Get the time span of the weather data from the file"

  input String filNam "Name of weather data file";
  input String tabName "Name of table on weather file";
  output Modelica.SIunits.Time[2] timeSpan "Start time, end time of weather data";

protected
 String lin "Line that is used in parser";
 Integer iLin "Line number";
 Integer index =  0 "Index of string";
 Integer staInd "Start index used when parsing a real number";
 Integer nextIndex "Dummy for return value of scanInteger / scanReal";
 Integer nrRows "Number of rows in table";
 Boolean EOF "Flag, true if EOF has been reached";
 Boolean headerOn "Still reading the header";
 Modelica.SIunits.Time avgIncrement "Average time increment of weather data";
 Modelica.SIunits.Time firstTimeStamp "first time stamp of weather data";
 Modelica.SIunits.Time lastTimeStamp "last time stamp of weather data";

algorithm
  iLin :=0;
  EOF :=false;
  // Get line where table dimensions is defined
  while (not EOF) and (index == 0) loop
    iLin:=iLin + 1;
    (lin, EOF) :=Modelica.Utilities.Streams.readLine(fileName=filNam,
      lineNumber=iLin);
    index :=Modelica.Utilities.Strings.find(
      string=lin,
      searchString=tabName + "(",
      startIndex=1,
      caseSensitive=false);
  end while;
  assert(not EOF, "Error: Did not find definition of table" + tabName
          + ", in weather file " + filNam  +" when scanning the weather file."
          + "\n   Check for correct weather file syntax.");
  // Get number of rows
  staInd :=index + Modelica.Utilities.Strings.length(tabName) + 1;
  (nrRows, nextIndex) :=Modelica.Utilities.Strings.scanInteger(string=lin,
  startIndex=staInd);

  assert(nrRows > 1, "Error: Just " + String(nrRows) +" row in table " + tabName
         + ", in weather file " + filNam  +" when scanning the weather file."
                      + "\n   You need at least two rows for the table");

  headerOn :=true;
  // Get first line of table
  while (not EOF) and (headerOn) loop
    iLin:=iLin + 1;
    (lin, EOF) :=Modelica.Utilities.Streams.readLine(fileName=filNam,
      lineNumber=iLin);
    index :=Modelica.Utilities.Strings.find(
    string=lin,
    searchString="#",
    startIndex=1,
    caseSensitive=false);
    if index == 0 then
      headerOn :=false;
    end if;
  end while;
  assert(not EOF, "Error: Did not find first line of table" + tabName
         + ", in weather file " + filNam  +" when scanning the weather file."
         + "\n   Check for correct weather file syntax.");
  // Get first time stamp
  (firstTimeStamp, nextIndex) :=Modelica.Utilities.Strings.scanReal(string=lin,
  startIndex=1);
  // Get last line of table
  (lin, EOF) :=Modelica.Utilities.Streams.readLine(fileName=filNam,
   lineNumber= iLin + nrRows - 1);
   assert(not EOF, "Error: Did not find line number " + String( iLin + nrRows - 1)
         +  " in table" + tabName + ", in weather file " + filNam
         +  " when scanning the weather file."
         +  "\n   Check for correct weather file syntax.");
  (lastTimeStamp, nextIndex) :=Modelica.Utilities.Strings.scanReal(string=lin,
  startIndex=1);
  avgIncrement := (lastTimeStamp - firstTimeStamp) / (nrRows -1);
  timeSpan[1] := firstTimeStamp;
  timeSpan[2] := lastTimeStamp + avgIncrement;

  annotation (Documentation(info="<html>
<p>
This function returns the start time (first time stamp) and end time
(last time stamp + average increment) of the TMY3 weather data file.
</p>
</html>", revisions="<html>
<ul>
<li>
November 15, 2017, by Ana Constantin:<br/>
First implementation, as part of solution to <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/842\">#842</a>.
</li>
</ul>
</html>"));
end getTimeSpanTMY3;
