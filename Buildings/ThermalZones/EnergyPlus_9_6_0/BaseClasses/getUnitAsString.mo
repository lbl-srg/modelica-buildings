within Buildings.ThermalZones.EnergyPlus_9_6_0.BaseClasses;
pure function getUnitAsString
  "Return the unit enumeration as a string"
  extends Modelica.Icons.Function;
  input Buildings.ThermalZones.EnergyPlus_9_6_0.Types.Units unit
    "Unit as enumeration value";
  output String unitAsString
    "String representation of the unit";

algorithm
  unitAsString :=
    if unit == Types.Units.Normalized then
      "1"
    elseif unit == Types.Units.AngleRad then
      "rad"
    elseif unit == Types.Units.AngleDeg then
      "deg"
    elseif unit == Types.Units.Energy then
      "J"
    elseif unit == Types.Units.Illuminance then
      "lm/m2"
    elseif unit == Types.Units.HumidityAbsolute then
      "kg/kg"
    elseif unit == Types.Units.HumidityRelative then
      "1"
    elseif unit == Types.Units.LuminousFlux then
      "cd.sr"
    elseif unit == Types.Units.MassFlowRate then
      "kg/s"
    elseif unit == Types.Units.Power then
      "W"
    elseif unit == Types.Units.Pressure then
      "Pa"
    elseif unit == Types.Units.Status then
      "1"
    elseif unit == Types.Units.Temperature then
      "K"
    elseif unit == Types.Units.Time then
      "s"
    elseif unit == Types.Units.VolumeFlowRate then
      "m3/s"
    else
      "error";
  annotation (
    Documentation(
      info="<html>
<p>
Function that returns the string representation of a unit enumeration from
<a href=\"modelica://Buildings.ThermalZones.EnergyPlus_9_6_0.Types.Units\">Buildings.ThermalZones.EnergyPlus_9_6_0.Types.Units</a>.
</p>
</html>",
      revisions="<html>
<ul>
<li>
December 11, 2021, by Michael Wetter:<br/>
Declared function as <code>pure</code> for MSL 4.0.0.
</li>
<li>
July 23, 2020, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end getUnitAsString;
