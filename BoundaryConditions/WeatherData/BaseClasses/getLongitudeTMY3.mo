within Buildings.BoundaryConditions.WeatherData.BaseClasses;
function getLongitudeTMY3 "Gets the longitude from a TMY3 weather data file"
 input String filNam "Name of weather data file"
 annotation (Dialog(
        __Dymola_loadSelector(filter="Weather files (*.mos)", caption=
            "Select weather file")));
 output Modelica.SIunits.Angle lon "Longitude from the weather file";
protected
 Integer nexInd "Next index, used for error handling";
 String element "String representation of the returned element";
algorithm
  element :=
    Buildings.BoundaryConditions.WeatherData.BaseClasses.getHeaderElementTMY3(
      filNam=filNam,
      start="#LOCATION",
      name=  "longitude",
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
March 5, 2011, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end getLongitudeTMY3;
