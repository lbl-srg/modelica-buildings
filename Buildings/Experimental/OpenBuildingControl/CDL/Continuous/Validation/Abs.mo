within Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Validation;
model Abs "Validation model for the absolute block"
  extends Modelica.Icons.Example;

  Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Abs abs1
    "Block that outputs the absolute value of the input"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.Ramp ramp(
    height=2,
    duration=1,
    offset=-1) "fixme: this need to be replaced with a CDL block"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
equation
  connect(ramp.y, abs1.u)
    annotation (Line(points={{-39,0},{-26,0},{-12,0}}, color={0,0,127}));
  annotation (
experiment(StopTime=1.0),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/CDL/Continuous/Validation/Abs.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Abs\">
Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Abs</a>.
The input varies from <i>-1</i> to <i>+1</i>.
</p>
</html>", revisions="<html>
<ul>
<li>
February 22, 2017, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Abs;
