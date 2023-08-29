within Buildings.Controls.OBC.CDL.Psychrometrics.Validation;
model SpecificEnthalpy_TDryBulPhi
  "Model to test the specific enthalpy computation"
  Buildings.Controls.OBC.CDL.Psychrometrics.SpecificEnthalpy_TDryBulPhi hBulPhi
    "Model for specific enthalpy computation"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp phi(
    duration=1,
    height=1,
    offset=0.001)
    "Relative humidity"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TDryBul(
    k=273.15+29.4)
    "Dry bulb temperature"
    annotation (Placement(transformation(extent={{-64,24},{-44,44}})));

equation
  connect(TDryBul.y,hBulPhi.TDryBul)
    annotation (Line(points={{-42,34},{-30,34},{-30,6},{-12,6}},color={0,0,127}));
  connect(phi.y,hBulPhi.phi)
    annotation (Line(points={{-38,-30},{-30,-30},{-30,-6},{-12,-6}},color={0,0,127}));
  annotation (
    experiment(
      StopTime=1.0,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Psychrometrics/Validation/SpecificEnthalpy_TDryBulPhi.mos" "Simulate and plot"),
    Documentation(
      info="<html>
<p>
This examples is a unit test for the specific enthalpy computation <a href=\"modelica://Buildings.Controls.OBC.CDL.Psychrometrics.SpecificEnthalpy_TDryBulPhi\">
Buildings.Controls.OBC.CDL.Psychrometrics.SpecificEnthalpy_TDryBulPhi</a>.
</p>
</html>",
      revisions="<html>
<ul>
<li>
September 29, 2020, by Michael Wetter:<br/>
Renamed model and updated for new input of the psychrometric blocks.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2139\">issue 2139</a>
</li>
<li>
April 7, 2017 by Jianjun Hu:<br/>
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
end SpecificEnthalpy_TDryBulPhi;
