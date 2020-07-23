within Buildings.ThermalZones.EnergyPlus;
model Schedule "Block to write to an EnergyPlus schedule"
  extends Buildings.ThermalZones.EnergyPlus.BaseClasses.Writer(
  final objectType=2,
  final variableName="",
  final componentType="",
  final controlType="");

initial equation
  assert(not usePrecompiledFMU, "Use of pre-compiled FMU is not supported for block Schedule.");

  annotation (
  defaultComponentName="sch",
  Icon(graphics={
    Line(points={{-58,56},{-58,-24},{62,-24},{62,56},{32,56},{32,-24},{-28,-24},
              {-28,56},{-58,56},{-58,36},{62,36},{62,16},{-58,16},{-58,-4},{62,
              -4},{62,-24},{-58,-24},{-58,56},{62,56},{62,-24}}),
    Line(points={{2,56},{2,-24}}),
    Rectangle(fillColor={255,215,136},
      fillPattern=FillPattern.Solid,
      extent={{-58,36},{-28,56}}),
    Rectangle(fillColor={255,215,136},
      fillPattern=FillPattern.Solid,
      extent={{-58,16},{-28,36}}),
    Rectangle(fillColor={255,215,136},
      fillPattern=FillPattern.Solid,
      extent={{-58,-4},{-28,16}}),
    Rectangle(fillColor={255,215,136},
      fillPattern=FillPattern.Solid,
      extent={{-58,-24},{-28,-4}})}),
    Documentation(info="<html>
<p>
Block that writes to a schedule object in EnergyPlus.
</p>
<p>
This model instantiates an FMU with the name <code>idfName</code> and
writes at every EnergyPlus zone time step the value of the input <code>u</code>
to an EnergyPlus schedule with name <code>name</code>.
If <code>useSamplePeriod = true</code>, then the value <code>u</code> is
written at each multiple of <code>samplePeriod</code>, in addition to the EnergyPlus zone time step.
</p>
<p>
The parameter <code>unit</code> specifies the unit of the signal <code>u</code>.
This unit is then converted internally to the units required by EnergyPlus before
the value is sent to EnergyPlus.
See <a href=\"modelica://Buildings.ThermalZones.EnergyPlus.Types.Units\">Buildings.ThermalZones.EnergyPlus.Types.Units</a>
for the supported units.
If the value of the parameter <code>unit</code> is left at its default value of
<code>Buildings.ThermalZones.EnergyPlus.Types.Units.unspecified</code>, then
the simulation will stop with an error.
</p>
<h4>Usage</h4>
<p>
To use an schedule, set up the schedule in the EnergyPlus idf file.
For example, an entry may be
</p>
<pre>
Schedule:Compact,
  INTERMITTENT,            !- Name
  Fraction,                !- Schedule Type Limits Name
  Through: 12/31,          !- Field 1
  For: WeekDays,           !- Field 2
  Until: 8:00,0.0,         !- Field 3
  Until: 18:00,1.00,       !- Field 5
  Until: 24:00,0.0,        !- Field 7
  For: AllOtherDays,       !- Field 9
  Until: 24:00,0.0;        !- Field 10
</pre>
<p>
Next, instantiate the actuator in Modelica. For the above
<code>Schedule:Compact</code>, the Modelica instantiation would be
</p>
<pre>
  Buildings.ThermalZones.EnergyPlus.Schedule schInt(
    name = \"INTERMITTENT\",
    unit = Buildings.ThermalZones.EnergyPlus.Types.Units.Normalized)
    \"Block that writes to the EnergyPlus schedule INTERMITTENT\";
</pre>
<p>
The entry <code>units=Buildings.ThermalZones.EnergyPlus.Types.Units.Normalized</code>
will cause the value to be sent to EnergyPlus without any unit conversion.
</p>
</html>", revisions="<html>
<ul>
<li>
November 8, 2019, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Schedule;
