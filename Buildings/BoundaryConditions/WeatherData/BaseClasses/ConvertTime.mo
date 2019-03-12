within Buildings.BoundaryConditions.WeatherData.BaseClasses;
block ConvertTime
  "Converts the simulation time to calendar time in scale of 1 year (365 days), or a multiple of a year"
  extends Modelica.Blocks.Icons.Block;

  parameter Modelica.SIunits.Time weaDatStaTim(displayUnit="d") "Start time of weather data";
  parameter Modelica.SIunits.Time weaDatEndTim(displayUnit="d") "End time of weather data";

  Modelica.Blocks.Interfaces.RealInput modTim(
    final quantity="Time",
    final unit="s") "Simulation time"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput calTim(
    final quantity="Time",
    final unit="s") "Calendar time"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

protected
  constant Modelica.SIunits.Time shiftSolarRad=1800 "Number of seconds for the shift for solar radiation calculation";
  parameter Modelica.SIunits.Time lenWea = weaDatEndTim-weaDatStaTim "Length of weather data";

  parameter Boolean canRepeatWeatherFile = abs(mod(lenWea, 365*24*3600)) < 1E-2
    "=true, if the weather file can be repeated, since it has the length of a year or a multiple of it";

  Modelica.SIunits.Time tNext "Start time of next period";
  function getNextTime "Function that computes the next time when a switch needs to happen"
    input Modelica.SIunits.Time modelTime "Model time";
    input Modelica.SIunits.Time lengthWeather "Length of weather data";
    output Modelica.SIunits.Time t "Next time when switch needs to happen";
  algorithm
    t := integer(modelTime/lengthWeather)*lengthWeather + lengthWeather;
  end getNextTime;
initial equation
  tNext = getNextTime(modTim, lenWea);

equation
  when modTim > pre(tNext) then
    // simulation time stamp went over the end time of the weather file
    //(last time stamp of the weather file + average increment)
    tNext = if canRepeatWeatherFile then getNextTime(modTim, lenWea) else integer(Modelica.Constants.inf);
  end when;
  calTim = if canRepeatWeatherFile then modTim - (tNext - lenWea) else modTim;
  assert(canRepeatWeatherFile or (time - weaDatEndTim) < shiftSolarRad,
    "In " + getInstanceName() + ": Insufficient weather data provided for the desired simulation period.",
    AssertionLevel.error);

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
March 4, 2019, by Michael Wetter:<br/>
Refactored implementation to correctly account for negative start times.<br/>
This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/842\">#842</a>.
</li>
<li>
July 27, 2018, by Ana Constantin:<br/>
Added shift for multiple time spans.
</li>
<li>
September 27, 2011, by Wangda Zuo and Michael Wetter:<br/>
Modify it to convert negative value of time.
Use the when-then to allow dymola differentiating this model when
conducting index reduction which is not allowed in previous implementation.
</li>
<li>
February 27, 2011, by Wangda Zuo:<br/>
Renamed the component.
</li>
<li>
July 08, 2010, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={
        Text(
          extent={{-98,6},{-74,-4}},
          lineColor={0,0,127},
          textString="modTim"),
        Text(
          extent={{74,6},{98,-4}},
          lineColor={0,0,127},
          textString="calTim"),
        Rectangle(
          extent={{-66,76},{60,58}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={120,120,120}),
        Rectangle(extent={{-66,58},{60,-62}}, lineColor={0,0,0}),
        Line(
          points={{-24,-62},{-24,58}}),
        Line(
          points={{18,-62},{18,58}}),
        Line(
          points={{60,28},{-66,28}}),
        Line(
          points={{60,-2},{-66,-2}}),
        Line(
          points={{60,-32},{-66,-32}})}));
end ConvertTime;
