within Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Validation;
model AddParameter "Validation model for the AddParameter block"
extends Modelica.Icons.Example;

  Buildings.Experimental.OpenBuildingControl.CDL.Continuous.AddParameter addpara1(
    p = 0.5,
    k = 1.0)
    "Block that outputs the sum of an input plus a parameter"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Ramp ramp1(
    duration=1,
    offset=-2,
    height=4)  "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
equation
  connect(ramp1.y, addpara1.u)
    annotation (Line(points={{-39,0},{-26,0},{-12,0}}, color={0,0,127}));
  annotation (
experiment(StopTime=1.0),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/CDL/Continuous/Validation/AddParameter.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Experimental.OpenBuildingControl.CDL.Continuous.AddParameter\">
Buildings.Experimental.OpenBuildingControl.CDL.Continuous.AddParameter</a>.
</p>
<p>
The input <code>u</code> varies from <i>-2</i> to <i>+2</i>. 
</p>
</html>", revisions="<html>
<ul>
<li>
March 17, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>

</html>"));
end AddParameter;
