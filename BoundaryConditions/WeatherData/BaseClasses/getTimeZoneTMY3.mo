within Buildings.BoundaryConditions.WeatherData.BaseClasses;
function getTimeZoneTMY3 "Gets the time zone from a TMY3 weather data file"
 input String filNam "Name of weather data file"
 annotation (Dialog(
        __Dymola_loadSelector(filter="Weather files (*.mos)", caption=
            "Select weather file")));
 output Modelica.SIunits.Time timZon "Time zone from the weather file";
protected
 Integer nexInd "Next index, used for error handling";
 String element "String representation of the returned element";
algorithm
  element :=
    Buildings.BoundaryConditions.WeatherData.BaseClasses.getHeaderElementTMY3(
      filNam=filNam,
      start="#LOCATION",
      name=  "longitude",
      position=9);
   (nexInd, timZon) :=Modelica.Utilities.Strings.Advanced.scanReal(
    string=element,
    startIndex=1,
    unsigned=false);
   assert(nexInd > 1, "Error when converting the time zone '" +
                      element + "' from a String to a Real.");
   timZon :=timZon*3600;
   // Check if time zone is valid
   assert(abs(timZon) < 24*3600,
       "Wrong value for time zone. Received timZon = " +
       String(timZon) + " (= " + String(timZon/3600) + " hours).");

  annotation (Documentation(info="<html>
This function returns the time zone of the TMY3 weather data file.
</html>", revisions="<html>
<ul>
<li>
March 5, 2011, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end getTimeZoneTMY3;
