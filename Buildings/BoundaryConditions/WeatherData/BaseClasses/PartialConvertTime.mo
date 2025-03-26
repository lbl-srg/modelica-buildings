within Buildings.BoundaryConditions.WeatherData.BaseClasses;
partial block PartialConvertTime
  "Converts the simulation time to calendar time in scale of 1 year (365 days), or a multiple of a year"
  extends Modelica.Blocks.Icons.Block;
  parameter Modelica.Units.SI.Time weaDatStaTim(displayUnit="d") = 0
    "Start time of weather data";
  parameter Modelica.Units.SI.Time weaDatEndTim(displayUnit="d") = 31536000
    "End time of weather data";
  Modelica.Units.SI.Time modTimAux "Model time";
  Modelica.Units.SI.Time calTimAux "Calendar time";

protected
  parameter Modelica.Units.SI.Time lenWea=weaDatEndTim - weaDatStaTim
    "Length of weather data";

  parameter Boolean canRepeatWeatherFile = abs(mod(lenWea, 365*24*3600)) < 1E-2
    "=true, if the weather file can be repeated, since it has the length of a year or a multiple of it";

  discrete Modelica.Units.SI.Time tNext(start=0, fixed=true)
    "Start time of next period";

equation
  when {initial(), canRepeatWeatherFile and modTimAux > pre(tNext)} then
    // simulation time stamp went over the end time of the weather file
    //(last time stamp of the weather file + average increment)
    tNext = if canRepeatWeatherFile then integer(modTimAux/lenWea)*lenWea + lenWea else time;
  end when;
  calTimAux = if canRepeatWeatherFile then modTimAux - tNext + lenWea else modTimAux;


  annotation (
    defaultComponentName="conTim",
    Documentation(info="<html>
<p>
This component converts the simulation time to calendar time in a scale of 1 year (365 days),
or a multiple of it, if this is the length of the weather file.
</p>
</html>", revisions="<html>
<ul>
<li>
March 27, 2023, by Ettore Zanetti:<br/>
Added partial class for conversion from simulation time to calendar time, to be
used by solar models that require calendar time for calculations.<br/>
This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1716\">IBPSA #1716</a>.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}})));
end PartialConvertTime;
