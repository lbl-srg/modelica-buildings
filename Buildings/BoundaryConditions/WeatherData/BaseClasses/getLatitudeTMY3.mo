within Buildings.BoundaryConditions.WeatherData.BaseClasses;
impure function getLatitudeTMY3 "Gets the latitude from a TMY3 weather data file"
  extends Modelica.Icons.Function;
 input String filNam "Name of weather data file"
 annotation (Dialog(
        loadSelector(filter="Weather files (*.mos)", caption=
            "Select weather file")));
  output Modelica.Units.SI.Angle lat "Latitude from the weather file";
protected
 Integer nexInd "Next index, used for error handling";
 String element "String representation of the returned element";
algorithm
  element :=
    Buildings.BoundaryConditions.WeatherData.BaseClasses.getHeaderElementTMY3(
      filNam=filNam,
      start="#LOCATION",
      name = "latitude",
      position=7);
   (nexInd, lat) :=Modelica.Utilities.Strings.Advanced.scanReal(
    string=element,
    startIndex=1,
    unsigned=false);
   assert(nexInd > 1, "Error when converting the latitude '" +
                      element + "' from a String to a Real.");
   // Convert from degree to rad
   lat :=lat*Modelica.Constants.pi/180;
   // Check if latitude is valid
   assert(abs(lat) <= Modelica.Constants.pi+Modelica.Constants.eps,
       "Wrong value for latitude. Received lat = " +
       String(lat) + " (= " + String(lat*180/Modelica.Constants.pi) + " degrees).");

  annotation (Documentation(info="<html>
This function returns the latitude of the TMY3 weather data file.
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
February 25, 2012, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end getLatitudeTMY3;
