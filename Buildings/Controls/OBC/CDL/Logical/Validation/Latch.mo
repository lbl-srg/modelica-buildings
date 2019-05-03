within Buildings.Controls.OBC.CDL.Logical.Validation;
model Latch "Validation model for the Latch block"

  Buildings.Controls.OBC.CDL.Logical.Latch iniTruOut(
    pre_y_start=true)
    "Initial false clear input, initial true output"
    annotation (Placement(transformation(extent={{60,30},{80,50}})));

  Buildings.Controls.OBC.CDL.Logical.Latch iniFalOut
    "Initial false clear input, initial false output"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));

  Buildings.Controls.OBC.CDL.Logical.Latch swiCleInp
    "Initial false output, with clear input switch between false and true"
    annotation (Placement(transformation(extent={{60,-50},{80,-30}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse latInp(
    final width=0.5,
    final period=2) "Block that outputs cyclic on and off"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse cleInp(
    final width=0.5,
    final period=6) "Block that outputs cyclic on and off"
    annotation (Placement(transformation(extent={{-60,-56},{-40,-36}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant fal(
    final k=false) "False clear input"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));

  Buildings.Controls.OBC.CDL.Logical.Latch swiCleInp1
    "Initial false output, with clear input switch between false and true"
    annotation (Placement(transformation(extent={{60,-80},{80,-60}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    annotation (Placement(transformation(extent={{-20,-86},{0,-66}})));
equation
  connect(fal.y, iniTruOut.u0)
    annotation (Line(points={{-39,0},{-20,0},{-20,34},{59,34}}, color={255,0,255}));
  connect(fal.y, iniFalOut.u0)
    annotation (Line(points={{-39,0},{-20,0},{-20,-6},{59,-6}}, color={255,0,255}));
  connect(latInp.y, iniTruOut.u)
    annotation (Line(points={{-39,40},{59,40}}, color={255,0,255}));
  connect(latInp.y, iniFalOut.u)
    annotation (Line(points={{-39,40},{20,40},{20,0},{59,0}},
                                                            color={255,0,255}));
  connect(cleInp.y, swiCleInp.u0)
    annotation (Line(points={{-39,-46},{59,-46}},                     color={255,0,255}));
  connect(latInp.y, swiCleInp.u)
    annotation (Line(points={{-39,40},{20,40},{20,-40},{59,-40}},
                                                                color={255,0,255}));

  connect(latInp.y, swiCleInp1.u) annotation (Line(points={{-39,40},{20,40},{20,
          -70},{59,-70}}, color={255,0,255}));
  connect(not1.u, cleInp.y) annotation (Line(points={{-22,-76},{-30,-76},{-30,
          -46},{-39,-46}}, color={255,0,255}));
  connect(not1.y, swiCleInp1.u0)
    annotation (Line(points={{1,-76},{59,-76}}, color={255,0,255}));
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
