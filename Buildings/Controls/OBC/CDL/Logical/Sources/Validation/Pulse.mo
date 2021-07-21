within Buildings.Controls.OBC.CDL.Logical.Sources.Validation;
<<<<<<< HEAD
model Pulse "Validation model for the Boolean Pulse block"

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    width = 0.5,
    period = 1)
    "Block that generates pulse signal of type Boolean"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  annotation (
  experiment(StopTime=5.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Logical/Sources/Validation/Pulse.mos"
        "Simulate and plot"),
    Documentation(info="<html>
=======
model Pulse
  "Validation model for the Boolean Pulse block"
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul_a1(
    width=0.2,
    period=2)
    "Boolean pulse signal"
    annotation (Placement(transformation(extent={{-90,40},{-70,60}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul_b1(
    width=0.2,
    period=2,
    shift=0.1)
    "Boolean pulse signal"
    annotation (Placement(transformation(extent={{-90,0},{-70,20}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul_c1(
    width=0.2,
    period=2,
    shift=0.6)
    "Boolean pulse signal"
    annotation (Placement(transformation(extent={{-90,-40},{-70,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul_a2(
    width=0.2,
    period=2,
    shift=2)
    "Boolean pulse signal"
    annotation (Placement(transformation(extent={{-50,40},{-30,60}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul_b2(
    width=0.2,
    period=2,
    shift=2.1)
    "Boolean pulse signal"
    annotation (Placement(transformation(extent={{-50,0},{-30,20}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul_c2(
    width=0.2,
    period=2,
    shift=2.6)
    "Boolean pulse signal"
    annotation (Placement(transformation(extent={{-50,-40},{-30,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul_a3(
    width=0.2,
    period=2,
    shift=4)
    "Boolean pulse signal"
    annotation (Placement(transformation(extent={{-10,40},{10,60}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul_b3(
    width=0.2,
    period=2,
    shift=4.1)
    "Boolean pulse signal"
    annotation (Placement(transformation(extent={{-10,0},{10,20}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul_c3(
    width=0.2,
    period=2,
    shift=4.6)
    "Boolean pulse signal"
    annotation (Placement(transformation(extent={{-10,-40},{10,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul_a4(
    width=0.2,
    period=2,
    shift=-2)
    "Boolean pulse signal"
    annotation (Placement(transformation(extent={{30,40},{50,60}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul_b4(
    width=0.2,
    period=2,
    shift=-1.9)
    "Boolean pulse signal"
    annotation (Placement(transformation(extent={{30,0},{50,20}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul_c4(
    width=0.2,
    period=2,
    shift=-1.4)
    "Boolean pulse signal"
    annotation (Placement(transformation(extent={{30,-40},{50,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul_a5(
    width=0.2,
    period=2,
    shift=-4)
    "Boolean pulse signal"
    annotation (Placement(transformation(extent={{70,40},{90,60}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul_b5(
    width=0.2,
    period=2,
    shift=-3.9)
    "Boolean pulse signal"
    annotation (Placement(transformation(extent={{70,0},{90,20}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul_c5(
    width=0.2,
    period=2,
    shift=-3.4)
    "Boolean pulse signal"
    annotation (Placement(transformation(extent={{70,-40},{90,-20}})));
  annotation (
    experiment(
      StartTime=0,
      StopTime=10,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Logical/Sources/Validation/Pulse.mos" "Simulate and plot"),
    Documentation(
      info="<html>
>>>>>>> master
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Logical.Sources.Pulse\">
Buildings.Controls.OBC.CDL.Logical.Sources.Pulse</a>.
</p>
<<<<<<< HEAD
</html>", revisions="<html>
=======
<p>
This validates the blocks with a start time of <i>0</i>.
All blocks with the same letter after the underscore are configured to produce
the same output.
</p>
</html>",
      revisions="<html>
>>>>>>> master
<ul>
<li>
July 17, 2017, by Jianjun Hu:<br/>
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
end Pulse;
