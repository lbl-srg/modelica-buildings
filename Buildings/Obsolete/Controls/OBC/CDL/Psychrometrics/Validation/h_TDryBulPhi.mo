within Buildings.Obsolete.Controls.OBC.CDL.Psychrometrics.Validation;
model h_TDryBulPhi "Model to test the specific enthalpy computation"

  Buildings.Obsolete.Controls.OBC.CDL.Psychrometrics.h_TDryBulPhi   hBulPhi
   "Model for specific enthalpy computation"
    annotation (Placement(transformation(extent={{46,-10},{66,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant p(k=101325) "Pressure"
    annotation (Placement(transformation(extent={{-64,-42},{-44,-22}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp phi(
    duration=1,
    height=1,
    offset=0.001) "Relative humidity"
    annotation (Placement(transformation(extent={{-64,-10},{-44,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TDryBul(k=273.15 + 29.4)
    "Dry bulb temperature"
    annotation (Placement(transformation(extent={{-64,24},{-44,44}})));

 // ============ Below blocks are from Buildings Library ============
  // ===================================================================

equation
  connect(TDryBul.y, hBulPhi.TDryBul)
    annotation (Line(points={{-42,34},{0,34},{0,8},{44,8}},
      color={0,0,127}));
  connect(phi.y, hBulPhi.phi)
    annotation (Line(points={{-42,0},{44,0}},
      color={0,0,127}));
  connect(p.y, hBulPhi.p)
    annotation (Line(points={{-42,-32},{0,-32},{0,-8},{44,-8}},
      color={0,0,127}));

annotation (experiment(StopTime=1.0, Tolerance = 1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Obsolete/Controls/OBC/CDL/Psychrometrics/Validation/h_TDryBulPhi.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This examples is a unit test for the specific enthalpy computation <a href=\"modelica://Buildings.Obsolete.Controls.OBC.CDL.Psychrometrics.h_TDryBulPhi\">
Buildings.Obsolete.Controls.OBC.CDL.Psychrometrics.h_TDryBulPhi</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
April 7, 2017 by Jianjun Hu:<br/>
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
end h_TDryBulPhi;
