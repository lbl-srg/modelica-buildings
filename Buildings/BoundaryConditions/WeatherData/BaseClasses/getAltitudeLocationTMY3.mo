within Buildings.BoundaryConditions.WeatherData.BaseClasses;
function getAltitudeLocationTMY3 "Gets the altitude from TMY3 file"
  extends Modelica.Icons.Function;
 input String filNam "Name of weather data file"
 annotation (Dialog(
        loadSelector(filter="Weather files (*.mos)", caption=
            "Select weather file")));
 output Modelica.SIunits.Length alt "Altitude of TMY3 location";
protected
 Integer nexInd "Next index, used for error handling";
 String element "String representation of the returned element";
algorithm
  element :=
    Buildings.BoundaryConditions.WeatherData.BaseClasses.getLastHeaderElementTMY3(
      filNam=filNam,
      start="#LOCATION",
      name = "Altitude");
   (nexInd, alt) :=Modelica.Utilities.Strings.Advanced.scanReal(
    string=element,
    startIndex=1,
    unsigned=false);

  annotation (Documentation(info="<html>
This function returns the altitude of the TMY3 weather data file.
</html>", revisions="<html>
<ul>
<li>
May 2, 2021, by Ettore Zanetti:<br/>
First implementation.
</li>
</ul>
</html>"));
end getAltitudeLocationTMY3;
