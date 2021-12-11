within Buildings.BoundaryConditions.WeatherData.BaseClasses;
impure function getLongitudeTMY3 "Gets the longitude from a TMY3 weather data file"
  extends Modelica.Icons.Function;
 input String filNam "Name of weather data file"
 annotation (Dialog(
        loadSelector(filter="Weather files (*.mos)", caption=
            "Select weather file")));
  output Modelica.Units.SI.Angle lon "Longitude from the weather file";
protected
 Integer nexInd "Next index, used for error handling";
 String element "String representation of the returned element";
algorithm
  element :=
    Buildings.BoundaryConditions.WeatherData.BaseClasses.getHeaderElementTMY3(
      filNam=filNam,
      start="#LOCATION",
      name = "longitude",
      position=8);
   (nexInd, lon) :=Modelica.Utilities.Strings.Advanced.scanReal(
    string=element,
    startIndex=1,
    unsigned=false);
   assert(nexInd > 1, "Error when converting the longitude '" +
                      element + "' from a String to a Real.");
   // Convert from degree to rad
   lon :=lon*Modelica.Constants.pi/180;
   // Check if longitude is valid
   assert(abs(lon) < 2*Modelica.Constants.pi,
       "Wrong value for longitude. Received lon = " +
       String(lon) + " (= " + String(lon*180/Modelica.Constants.pi) + " degrees).");

  annotation (Documentation(info="<html>
This function returns the longitude of the TMY3 weather data file.
</html>", revisions="<html>
<ul>
<li>
December 11, 2021, by Michael Wetter:<br/>
Added <code>impure</code> declaration for MSL 4.0.0.
</li>
<li>
September 24, 2015, by Marcus Fuchs:<br/>
Replace Dymola specific annotation by <code>loadSelector</code>
for MSL compliancy as reported by @tbeu at
<a href=\"https://github.com/RWTH-EBC/AixLib/pull/107\">RWTH-EBC/AixLib#107</a>
</li>
<li>
March 5, 2011, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end getLongitudeTMY3;
