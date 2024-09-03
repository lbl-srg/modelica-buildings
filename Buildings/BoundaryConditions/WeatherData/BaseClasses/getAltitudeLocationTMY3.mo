within Buildings.BoundaryConditions.WeatherData.BaseClasses;
impure function getAltitudeLocationTMY3 "Gets the altitude from TMY3 file"
  extends Modelica.Icons.Function;
 input String filNam "Name of weather data file"
 annotation (Dialog(
        loadSelector(filter="Weather files (*.mos)", caption=
            "Select weather file")));
  output Modelica.Units.SI.Length alt "Altitude of TMY3 location";
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
December 11, 2021, by Michael Wetter:<br/>
Added <code>impure</code> declaration for MSL 4.0.0.
</li>
<li>
May 2, 2021, by Ettore Zanetti:<br/>
First implementation.
</li>
</ul>
</html>"));
end getAltitudeLocationTMY3;
