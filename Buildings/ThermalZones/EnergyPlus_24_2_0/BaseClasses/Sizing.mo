within Buildings.ThermalZones.EnergyPlus_24_2_0.BaseClasses;
record Sizing "Record of sizing parameters"
  extends Modelica.Icons.Record;
  parameter Modelica.Units.SI.Power QSen_flow(fixed=false)
    "Design sensible load";
  parameter Modelica.Units.SI.Power QLat_flow(fixed=false)
    "Design latent load";
  parameter Modelica.Units.SI.Temperature TSet(fixed=false)
    "Indoor temperature set point at the design load";
  parameter Modelica.Units.SI.MassFraction XSet(fixed=false, start=0.01)
    "Indoor humidity ratio set point at the design load per total air mass";
  parameter Modelica.Units.SI.Temperature TOut(fixed=false)
    "Outdoor drybulb temperature at the design load";
  parameter Modelica.Units.SI.MassFraction XOut(fixed=false, start=0.01)
    "Outdoor humidity ratio at the design load per total air mass";
  parameter Modelica.Units.SI.MassFlowRate mOut_flow(fixed=false)
    "Minimum outdoor air flow rate during the design load";
  parameter Modelica.Units.SI.Time t(fixed=false)
    "Time at which the design load occurred";
  annotation (
    Icon(
      coordinateSystem(
        preserveAspectRatio=false)),
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false)),
    Documentation(
      info="<html>
<p>
Record that stores design-load sizing parameters for a thermal zone,
obtained from EnergyPlus.
An instance is created for the cooling design condition and another
for the heating design condition inside
<a href=\"modelica://Buildings.ThermalZones.EnergyPlus_24_2_0.BaseClasses.ThermalZoneAdapter\">
Buildings.ThermalZones.EnergyPlus_24_2_0.BaseClasses.ThermalZoneAdapter</a>.
The parameters are populated during initialization by the function
<a href=\"modelica://Buildings.ThermalZones.EnergyPlus_24_2_0.BaseClasses.getParameters\">
Buildings.ThermalZones.EnergyPlus_24_2_0.BaseClasses.getParameters</a>,
which retrieves them from the EnergyPlus FMU.
</p>
</html>",
      revisions="<html>
<ul>
<li>
September 30, 2026, by Michael Wetter:<br/>
Added <code>start</code> values to avoid warning in Optimica.
</li>
<li>
April 2, 2026, by Michael Wetter:<br/>
Exchanged <code>TSet</code> and <code>XSet</code>, and converted humidity ratio.
</li>
<li>
September 17, 2025, by Michael Wetter:<br/>
Changed time variable name from <code>T</code> to <code>t</code>.
Changed parameter order to be the same for heating and cooling.
</li>
<li>
August 19, 2025, by Michael Wetter:<br/>
Made two separate instances of this record for the heating and cooling
design conditions, and made them public in
<a href=\"modelica://Buildings.ThermalZones.EnergyPlus_24_2_0.BaseClasses.ThermalZoneAdapter\">
Buildings.ThermalZones.EnergyPlus_24_2_0.BaseClasses.ThermalZoneAdapter</a>.
</li>
<li>
June 25, 2025, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Sizing;
