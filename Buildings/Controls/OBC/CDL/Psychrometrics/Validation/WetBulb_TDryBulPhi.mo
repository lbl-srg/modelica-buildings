within Buildings.Controls.OBC.CDL.Psychrometrics.Validation;
model WetBulb_TDryBulPhi
  "Model to test the wet bulb temperature computation"

  Buildings.Controls.OBC.CDL.Psychrometrics.WetBulb_TDryBulPhi wetBulPhi
    "Model for wet bulb temperature"
    annotation (Placement(transformation(extent={{20,30},{40,50}})));
  Buildings.Controls.OBC.CDL.Psychrometrics.WetBulb_TDryBulPhi wetBulPhi1
    "Model for wet bulb temperature"
    annotation (Placement(transformation(extent={{20,-50},{40,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp phi(
    duration=1,
    height=0.95,
    offset=0.05) "Relative humidity"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TDryBul(
    k=273.15+29.4) "Dry bulb temperature"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TDryBul1(
    duration=1,
    height=40,
    offset=273.15) "Dry bulb temperature"
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant phi2(k=0.6)
    "Relative humidity"
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));

equation
  connect(TDryBul.y,wetBulPhi.TDryBul)
    annotation (Line(points={{-18,70},{0,70},{0,46},{18,46}}, color={0,0,127}));
  connect(phi.y,wetBulPhi.phi)
    annotation (Line(points={{-18,20},{0,20},{0,34},{18,34}}, color={0,0,127}));
  connect(TDryBul1.y, wetBulPhi1.TDryBul) annotation (Line(points={{-18,-20},{0,
          -20},{0,-34},{18,-34}}, color={0,0,127}));
  connect(phi2.y, wetBulPhi1.phi) annotation (Line(points={{-18,-70},{0,-70},{0,
          -46},{18,-46}}, color={0,0,127}));
  annotation (
    experiment(
      StopTime=1.0,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Psychrometrics/Validation/WetBulb_TDryBulPhi.mos" "Simulate and plot"),
    Documentation(
      info="<html>
<p>
This examples is a unit test for the dew point temperature computation
<a href=\"modelica://Buildings.Controls.OBC.CDL.Psychrometrics.WetBulb_TDryBulPhi\">
Buildings.Controls.OBC.CDL.Psychrometrics.WetBulb_TDryBulPhi</a>.
</p>
</html>",
      revisions="<html>
<ul>
<li>
March 17, 2023, by Jianjun Hu:<br/>
Removed instances that use blocks outside of
<a href=\"modelica://Buildings.Controls.OBC.CDL\">Buildings.Controls.OBC.CDL</a> package.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3302\">issue 3302</a>
</li>
<li>
September 29, 2020, by Michael Wetter:<br/>
Renamed model and updated for new input of the psychrometric blocks.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2139\">issue 2139</a>
</li>
<li>
April 7, 2017, by Jianjun Hu:<br/>
First implementation in CDL package.
</li>
<li>
June 23, 2016, by Michael Wetter:<br/>
Changed graphical annotation.
</li>
<li>
May 24, 2016, by Filip Jorissen:<br/>
Updated example with validation data.
See  <a href=\"https://github.com/ibpsa/modelica/issues/474\">#474</a>
for a discussion.
</li>
<li>
October 1, 2012 by Michael Wetter:<br/>
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
end WetBulb_TDryBulPhi;
