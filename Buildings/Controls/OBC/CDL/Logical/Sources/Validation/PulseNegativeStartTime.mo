within Buildings.Controls.OBC.CDL.Logical.Sources.Validation;
model PulseNegativeStartTime
  "Validation model for the Boolean Pulse block with negative start time"
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
      StartTime=-10,
      StopTime=1,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Logical/Sources/Validation/PulseNegativeStartTime.mos" "Simulate and plot"),
    Documentation(
      info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Logical.Sources.Pulse\">
Buildings.Controls.OBC.CDL.Logical.Sources.Pulse</a>.
</p>
<p>
This validates the blocks with a start time of <i>-10</i> seconds.
All blocks with the same letter after the underscore are configured to produce
the same output.
</p>
</html>",
      revisions="<html>
<ul>
<li>
October 19, 2020, by Michael Wetter:<br/>
First implementation.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2170\">#2170</a>.
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
end PulseNegativeStartTime;
