within Buildings.Experimental.EnergyPlus;
model Schedule "Block to write to an EnergyPlus schedule"
  extends Buildings.Experimental.EnergyPlus.BaseClasses.Writer(
  final objectType=2,
  final componentName="",
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
See <a href=\"modelica://Buildings.Experimental.EnergyPlus.Types.Units\">Buildings.Experimental.EnergyPlus.Types.Units</a>
for the supported units.
If the value of the parameter <code>unit</code> is left at its default value of
<code>Buildings.Experimental.EnergyPlus.Types.Units.unspecified</code>, then
the simulation will stop with an error.
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
