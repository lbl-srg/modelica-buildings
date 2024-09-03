within Buildings.ThermalZones.EnergyPlus_9_6_0.Validation.RunPeriod;
model StartDayOfWeek "Validation model for the start day of the week"
  extends Modelica.Icons.Example;

  Buildings.ThermalZones.EnergyPlus_9_6_0.Validation.OutputVariable.OneZoneOneOutputVariable sun
    "Model with first day of the week being Sunday"
    annotation (Placement(transformation(extent={{-10,20},{10,40}})));
  Buildings.ThermalZones.EnergyPlus_9_6_0.Validation.OutputVariable.OneZoneOneOutputVariable mon(
    building(
      runPeriod(
        startDayOfYear=Buildings.ThermalZones.EnergyPlus_9_6_0.Types.WeekDays.Monday)))
    "Model with first day of the week being Monday"
    annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));

  Modelica.Blocks.Sources.RealExpression sunEle(y(final unit="W")=sun.equEle.y)
    "Electricity consumption for model with Sunday as the first day of the week"
    annotation (Placement(transformation(extent={{40,20},{60,40}})));
  Modelica.Blocks.Sources.RealExpression monEle(y(final unit="W") = mon.equEle.y)
    "Electricity consumption for model with Monday as the first day of the week"
    annotation (Placement(transformation(extent={{40,-30},{60,-10}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This validation case simulates two instances of
<a href=\"modelica://Buildings.ThermalZones.EnergyPlus_9_6_0.Validation.OutputVariable.OneZoneOneOutputVariable\">
Buildings.ThermalZones.EnergyPlus_9_6_0.Validation.OutputVariable.OneZoneOneOutputVariable</a>,
a model that outputs the electricity consumption that is specified via an EnergyPlus schedule.
This schedule set the electricity consumption to zero for the whole day on Saturday and Sunday,
but not on other days.
In the instance <code>sun</code>, the start day of the year is left as the default, which is Sunday,
and in the instance <code>mon</code>, it is set to Monday.
Plotting the electricity consumption verifies that the setting is properly applied
in EnergyPlus.
</p>
</html>", revisions="<html>
<ul>
<li>
May 18, 2021, by Michael Wetter:<br/>
First implementation for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2926\">#2926</a>.
</li>
</ul>
</html>"),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/EnergyPlus_9_6_0/Validation/RunPeriod/StartDayOfWeek.mos" "Simulate and plot"),
    experiment(
      StopTime=604800,
      Tolerance=1e-06));
end StartDayOfWeek;
