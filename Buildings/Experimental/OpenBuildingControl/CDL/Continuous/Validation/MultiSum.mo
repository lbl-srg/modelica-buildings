within Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Validation;
model MultiSum "Model to validate the application of MultiSum block"
  extends Modelica.Icons.Example;
  Buildings.Experimental.OpenBuildingControl.CDL.Sources.Ramp ramp1(
    duration=1,
    offset=-2,
    height=4)  "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Sources.Ramp ramp2(
    height=2,
    duration=1,
    offset=-1) "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Sources.Ramp ramp3(
    height=3,
    duration=1,
    offset=-1) "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Sources.Ramp ramp4(
    height=3,
    duration=1,
    offset=-2) "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Sources.Ramp ramp5(
    height=3,
    duration=1,
    offset=-3) "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Continuous.MultiSum mulSum(
    nu=5,
    k={1,0.5,0.1,1,2})
    "Sum of Reals: y = k[1]*u[1] + k[2]*u[2] + ... + k[n]*u[n]"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
equation
  connect(ramp1.y, mulSum.u[1]) annotation (Line(points={{-39,60},{-4,60},{32,60},
          {32,5.6},{40,5.6}}, color={0,0,127}));
  connect(ramp2.y, mulSum.u[2]) annotation (Line(points={{-39,30},{-10,30},{22,30},
          {22,2.8},{40,2.8}}, color={0,0,127}));
  connect(ramp3.y, mulSum.u[3])
    annotation (Line(points={{-39,0},{40,0}}, color={0,0,127}));
  connect(ramp4.y, mulSum.u[4]) annotation (Line(points={{-39,-30},{20,-30},{20,
          -2.8},{40,-2.8}}, color={0,0,127}));
  connect(ramp5.y, mulSum.u[5]) annotation (Line(points={{-39,-60},{30,-60},{30,
          -5.6},{40,-5.6}}, color={0,0,127}));
  annotation (
  experiment(StopTime=1.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/CDL/Continuous/Validation/MultiSum.mos"
        "Simulate and plot"),
  Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Experimental.OpenBuildingControl.CDL.Continuous.MultiSum\">
Buildings.Experimental.OpenBuildingControl.CDL.Continuous.MultiSum</a>.
</p>
<ul>
<li>input <code>u1</code> varies from <i>-2</i> to <i>+2</i>, 
with gain factor of 1;</li>
<li>input <code>u2</code> varies from <i>-1</i> to <i>+1</i>, 
with gain factor of 0.5;</li>
<li>input <code>u3</code> varies from <i>-1</i> to <i>+2</i>, 
with gain factor of 0.1;</li>
<li>input <code>u3</code> varies from <i>-2</i> to <i>+1</i>, 
with gain factor of 1;</li>
<li>input <code>u3</code> varies from <i>-3</i> to <i>0</i>, 
with gain factor of 2;</li>
</ul>

</html>", revisions="<html>
<ul>
<li>
June 28, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>

</html>"));
end MultiSum;
