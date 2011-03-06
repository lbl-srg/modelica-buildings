within Buildings.BoundaryConditions.WeatherData.BaseClasses.Examples;
model GetHeaderElement "Test model to get header element"
  parameter Modelica.SIunits.Angle longitude(fixed=false, displayUnit="deg");
  parameter Modelica.SIunits.Time timeZone(fixed=false, displayUnit="h");

initial equation
  longitude = Buildings.BoundaryConditions.WeatherData.BaseClasses.getLongitudeTMY3(
    filNam="Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos");
  timeZone = Buildings.BoundaryConditions.WeatherData.BaseClasses.getTimeZoneTMY3(
    filNam="Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos");
  assert(abs(timeZone+6*3600) < 1, "Error when parsing time zone, timeZone = "
    + realString(timeZone));
  assert(abs(longitude*180/Modelica.Constants.pi+87.92) < 1,
      "Error when parsing longitude, longitude = " + realString(longitude));

  annotation (Commands(file="GetHeaderElement.mos" "run"));
end GetHeaderElement;
