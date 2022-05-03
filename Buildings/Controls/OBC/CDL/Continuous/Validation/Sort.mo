within Buildings.Controls.OBC.CDL.Continuous.Validation;
model Sort
  "Validation model for the Sort block"
  Buildings.Controls.OBC.CDL.Continuous.Sort sorAsc(
    nin=5)
    "Block that sorts signals in ascending order"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ramp1(
    duration=1,
    offset=-2,
    height=4)
    "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-60,56},{-40,76}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ramp2(
    duration=1,
    offset=-1,
    height=3)
    "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-60,22},{-40,42}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ramp3(
    duration=1,
    offset=2,
    height=-4)
    "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ramp4(
    duration=1,
    offset=3,
    height=-1)
    "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-60,-42},{-40,-22}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ramp5(
    duration=1,
    offset=0,
    height=4)
    "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-60,-74},{-40,-54}})));
  Buildings.Controls.OBC.CDL.Continuous.Sort sorDes(
    nin=5,
    ascending=false)
    "Block that sorts signals in ascending order"
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));

equation
  connect(ramp1.y,sorAsc.u[1])
    annotation (Line(points={{-39,66},{-22,66},{-22,28.4},{-2,28.4}},color={0,0,127}));
  connect(ramp2.y,sorAsc.u[2])
    annotation (Line(points={{-39,32},{-20,32},{-20,29.2},{-2,29.2}},color={0,0,127}));
  connect(ramp3.y,sorAsc.u[3])
    annotation (Line(points={{-39,0},{-22,0},{-22,30},{-2,30}},color={0,0,127}));
  connect(ramp4.y,sorAsc.u[4])
    annotation (Line(points={{-39,-32},{-22,-32},{-22,30.8},{-2,30.8}},color={0,0,127}));
  connect(ramp5.y,sorAsc.u[5])
    annotation (Line(points={{-39,-64},{-20,-64},{-20,31.6},{-2,31.6}},color={0,0,127}));
  connect(ramp1.y,sorDes.u[1])
    annotation (Line(points={{-39,66},{-22,66},{-22,-31.6},{-2,-31.6}},color={0,0,127}));
  connect(ramp2.y,sorDes.u[2])
    annotation (Line(points={{-39,32},{-20,32},{-20,-30.8},{-2,-30.8}},color={0,0,127}));
  connect(ramp3.y,sorDes.u[3])
    annotation (Line(points={{-39,0},{-22,0},{-22,-30},{-2,-30}},color={0,0,127}));
  connect(ramp4.y,sorDes.u[4])
    annotation (Line(points={{-39,-32},{-22,-32},{-22,-29.2},{-2,-29.2}},color={0,0,127}));
  connect(ramp5.y,sorDes.u[5])
    annotation (Line(points={{-39,-64},{-20,-64},{-20,-28.4},{-2,-28.4}},color={0,0,127}));
  annotation (
    experiment(
      StopTime=1.0,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Continuous/Validation/Sort.mos" "Simulate and plot"),
    Documentation(
      info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Continuous.Sort\">
Buildings.Controls.OBC.CDL.Continuous.Sort</a>.
</p>
<p>
The input <code>u1</code> varies from <i>-2</i> to <i>+2</i>, input <code>u2</code> varies from <i>-1</i> to <i>+2</i>,
input <code>u3</code> varies from <i>+2</i> to <i>-2</i>, input <code>u4</code> varies from <i>+3</i> to <i>+2</i>,
input <code>u5</code> varies from <i>0</i> to <i>+4</i>,
</p>
</html>",
      revisions="<html>
<ul>
<li>
September 14, 2017, by Jianjun Hu:<br/>
Changed model name.
</li>
<li>
March 22, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(
      graphics={
        Ellipse(
          lineColor={75,138,73},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}),
        Polygon(
          lineColor={0,0,255},
          fillColor={75,138,73},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-36,60},{64,0},{-36,-60},{-36,60}})}));
end Sort;
