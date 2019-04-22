within Buildings.Controls.OBC.CDL.Logical.Validation;
model Toggle "Validation model for the Toggle block"

  Buildings.Controls.OBC.CDL.Logical.Toggle iniTruOut(
    pre_y_start=true)
    "Initial false clear input, initial true output"
    annotation (Placement(transformation(extent={{40,30},{60,50}})));

  Buildings.Controls.OBC.CDL.Logical.Toggle iniFalOut
    "Initial false clear input, initial false output"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));

  Buildings.Controls.OBC.CDL.Logical.Toggle swiCleInp
    "Initial false output, with clear input switch between false and true"
    annotation (Placement(transformation(extent={{40,-50},{60,-30}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse togInp(
    final width=0.5,
    final period=2) "Block that outputs cyclic on and off"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse cleInp(
    final width=0.5,
    final period=6) "Block that outputs cyclic on and off"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant fal(
    final k=false) "False clear input"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));

equation
  connect(togInp.y, iniTruOut.u)
    annotation (Line(points={{-39,40},{39,40}}, color={255,0,255}));
  connect(togInp.y, iniFalOut.u)
    annotation (Line(points={{-39,40},{0,40},{0,0},{39,0}}, color={255,0,255}));
  connect(togInp.y, swiCleInp.u)
    annotation (Line(points={{-39,40},{0,40},{0,-40},{39,-40}}, color={255,0,255}));
  connect(fal.y, iniTruOut.u0)
    annotation (Line(points={{-39,0},{-20,0},{-20,34},{39,34}}, color={255,0,255}));
  connect(fal.y, iniFalOut.u0)
    annotation (Line(points={{-39,0},{-20,0},{-20,-6},{39,-6}}, color={255,0,255}));
  connect(cleInp.y, swiCleInp.u0)
    annotation (Line(points={{-39,-40},{-20,-40},{-20,-46},{39,-46}}, color={255,0,255}));

annotation (
  experiment(StopTime=10.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Logical/Validation/Toggle.mos"
          "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Logical.Toggle\">
Buildings.Controls.OBC.CDL.Logical.Toggle</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
April 4, 2019, by Jianjun Hu:<br/>
Added test to validate initial output. 
This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1402\">issue 1402</a>.
</li>
<li>
March 31, 2017, by Jianjun Hu:<br/>
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
end Toggle;
