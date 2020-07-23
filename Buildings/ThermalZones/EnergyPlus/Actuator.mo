within Buildings.ThermalZones.EnergyPlus;
model Actuator "Block to write to an EnergyPlus actuator"
  extends Buildings.ThermalZones.EnergyPlus.BaseClasses.Writer(
    final name="",
    final objectType=1);

initial equation
  assert(not usePrecompiledFMU, "Use of pre-compiled FMU is not supported for block Actuator.");

  annotation (
  defaultComponentName="act",
    Documentation(info="<html>
<p>
Block that writes to an EMS actuator object in EnergyPlus.
</p>
<p>
This model instantiates an FMU with the name <code>idfName</code> and
writes at every EnergyPlus zone time step the value of the input <code>u</code>
to an EnergyPlus EMS actuator with name <code>variableName</code>.
<!--
If <code>useSamplePeriod = true</code>, then the value <code>u</code> is
written at each multiple of <code>samplePeriod</code>, in addition to the EnergyPlus zone time step.
-->
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
To use an actuator, set up the EMS actuator in the EnergyPlus idf file.
For example, an entry may be
</p>
<pre>
EnergyManagementSystem:Actuator,
  Zn001_Wall001_Win001_Shading_Deploy_Status,  !- Name
  Zn001:Wall001:Win001,    !- Actuated Component Unique Name
  Window Shading Control,  !- Actuated Component Type
  Control Status;          !- Actuated Component Control Type
</pre>
<p>
Next, instantiate the actuator in Modelica. For the above
<code>EnergyManagementSystem:Actuator</code>, the Modelica instantiation would be
</p>
<pre>
  Buildings.ThermalZones.EnergyPlus.Actuator actSha(
    name =          \"Zn001_Wall001_Win001_Shading_Deploy_Status\",
    unit =          Buildings.ThermalZones.EnergyPlus.Types.Units.Normalized,
    variableName = \"Zn001:Wall001:Win001\",
    componentType = \"Window Shading Control\",
    controlType =   \"Control Status\") \"Actuator for window shade\";
</pre>
<p>
The entry <code>units=Buildings.ThermalZones.EnergyPlus.Types.Units.Normalized</code>
will cause the value to be sent to EnergyPlus without any unit conversion.
</p>
</html>", revisions="<html>
<ul>
<li>
November 13, 2019, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(graphics={
        Polygon(points={{-42,28},{38,-28},{38,30},{-42,-28},{-42,28}},
            lineColor={0,0,0}),
        Line(points={{-62,0},{-42,0}}, color={0,0,0}),
        Line(points={{38,0},{58,0}}, color={0,0,0}),
        Line(
          points={{-10,0},{24,1.60689e-15}},
          color={0,0,0},
          origin={-2,10},
          rotation=90),
        Rectangle(extent={{-22,34},{20,70}}, lineColor={0,0,0})}));
end Actuator;
