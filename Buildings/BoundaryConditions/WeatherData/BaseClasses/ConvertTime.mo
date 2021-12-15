within Buildings.BoundaryConditions.WeatherData.BaseClasses;
block ConvertTime
  "Converts the simulation time to calendar time in scale of 1 year (365 days), or a multiple of a year"
  extends Modelica.Blocks.Icons.Block;

  parameter Modelica.Units.SI.Time weaDatStaTim(displayUnit="d")
    "Start time of weather data";
  parameter Modelica.Units.SI.Time weaDatEndTim(displayUnit="d")
    "End time of weather data";

  Modelica.Blocks.Interfaces.RealInput modTim(
    final quantity="Time",
    final unit="s") "Simulation time"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput calTim(
    final quantity="Time",
    final unit="s") "Calendar time"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

protected
  constant Modelica.Units.SI.Time shiftSolarRad=1800
    "Number of seconds for the shift for solar radiation calculation";
  parameter Modelica.Units.SI.Time lenWea=weaDatEndTim - weaDatStaTim
    "Length of weather data";

  parameter Boolean canRepeatWeatherFile = abs(mod(lenWea, 365*24*3600)) < 1E-2
    "=true, if the weather file can be repeated, since it has the length of a year or a multiple of it";

  discrete Modelica.Units.SI.Time tNext(start=0, fixed=true)
    "Start time of next period";

equation
  when {initial(), canRepeatWeatherFile and modTim > pre(tNext)} then
    // simulation time stamp went over the end time of the weather file
    //(last time stamp of the weather file + average increment)
    tNext = if canRepeatWeatherFile then integer(modTim/lenWea)*lenWea + lenWea else time;
  end when;
  calTim = if canRepeatWeatherFile then modTim - tNext + lenWea else modTim;

  assert(canRepeatWeatherFile or noEvent((time - weaDatEndTim) < shiftSolarRad),
    "In " + getInstanceName() + ": Insufficient weather data provided for the desired simulation period.
    The simulation time " + String(time) +
    " exceeds the end time " + String(weaDatEndTim) + " of the weather data file.",
    AssertionLevel.error);

  assert(canRepeatWeatherFile or noEvent(time >= weaDatStaTim),
    "In " + getInstanceName() + ": Insufficient weather data provided for the desired simulation period.
    The simulation time " + String(time) +
    " is less than the start time " + String(weaDatStaTim) + " of the weather data file.",
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
April 15, 2020, by Michael Wetter:<br/>
Added <code>noEvent</code> to assertion to remove zero crossing function in OPTIMICA.
</li>
<li>
January 29, 2020, by Filip Jorissen:<br/>
Revised end time assert and added assert that verifies whether the time is before the
start time of the weather file.<br/>
This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1281\">#1281</a>.
</li>
<li>
June 12, 2019, by Michael Wetter:<br/>
Reformulated model to avoid having to evaluate the weather file during compilation
(as it determined the structural parameter <code>lenWea</code>). The new formulation
allows inclusion of the weather file in JModelica-generated FMUs, and it works with
Dymola as well.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1147\">#1147</a>.
</li>
<li>
May 21, 2019, by Michael Wetter:<br/>
Corrected code to avoid wrong type conversion.<br/>
This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1142\">#1142</a>.
</li>
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
          textColor={0,0,127},
          textString="modTim"),
        Text(
          extent={{74,6},{98,-4}},
          textColor={0,0,127},
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
