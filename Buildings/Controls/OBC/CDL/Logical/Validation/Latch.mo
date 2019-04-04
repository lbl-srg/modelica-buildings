within Buildings.Controls.OBC.CDL.Logical.Validation;
model Latch "Validation model for the Latch block"

  Buildings.Controls.OBC.CDL.Logical.Latch latch1
    annotation (Placement(transformation(extent={{40,30},{60,50}})));

  Buildings.Controls.OBC.CDL.Logical.Latch latch2
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));

  Buildings.Controls.OBC.CDL.Logical.Latch latch3
    annotation (Placement(transformation(extent={{40,-70},{60,-50}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse latInp(
    final width=0.5,
    final period=1.5)
    "Block that outputs cyclic on and off"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse conInp(
    final width=0.5,
    final period=5)
    "Block that outputs cyclic on and off"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse conInp1(
    final width=0.9,
    final period=12,
    final startTime=0.5) "Block that outputs cyclic on and off"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));

  Buildings.Controls.OBC.CDL.Logical.And and2
    annotation (Placement(transformation(extent={{-20,-30},{0,-10}})));

  Buildings.Controls.OBC.CDL.Logical.Not not1
    annotation (Placement(transformation(extent={{-20,-70},{0,-50}})));

equation
  connect(latInp.y, latch1.u)
    annotation (Line(points={{-59,60},{-40,60},{-40,40},{39,40}}, color={255,0,255}));
  connect(conInp.y, latch1.u0)
    annotation (Line(points={{-59,20},{-50,20},{-50,34},{39,34}}, color={255,0,255}));
  connect(latInp.y, latch2.u)
    annotation (Line(points={{-59,60},{-40,60},{-40,0},{39,0}}, color={255,0,255}));
  connect(conInp1.y, and2.u2)
    annotation (Line(points={{-59,-40},{-50,-40},{-50,-28},{-22,-28}}, color={255,0,255}));
  connect(conInp.y, and2.u1)
    annotation (Line(points={{-59,20},{-50,20},{-50,-20},{-22,-20}}, color={255,0,255}));
  connect(and2.y, latch2.u0)
    annotation (Line(points={{1,-20},{20,-20},{20,-6},{39,-6}}, color={255,0,255}));
  connect(latInp.y, not1.u)
    annotation (Line(points={{-59,60},{-40,60},{-40,-60},{-22,-60}}, color={255,0,255}));
  connect(not1.y, latch3.u)
    annotation (Line(points={{1,-60},{39,-60}}, color={255,0,255}));
  connect(and2.y, latch3.u0)
    annotation (Line(points={{1,-20},{20,-20},{20,-66},{39,-66}}, color={255,0,255}));

annotation (
  experiment(StopTime=10.0, Tolerance=1e-06),
   __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Logical/Validation/Latch.mos"
         "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Logical.Latch\">
Buildings.Controls.OBC.CDL.Logical.Latch</a>.
</p>
<p>
The <code>latch</code> input <code>u</code> cycles from OFF to ON, with cycle 
period of <code>1.5 s</code> and <code>50%</code> ON time.
The <code>clr</code> input <code>u0</code> cycles from OFF to ON, with cycle 
period of <code>5 s</code> and <code>50%</code> ON time.
</p>
</html>", revisions="<html>
<ul>
<li>
April 4, 2019, by Jianjun Hu:<br/>
Added test to validate initial output. 
This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1402\">issue 1402</a>.
</li>
<li>
March 30, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}));
end Latch;
