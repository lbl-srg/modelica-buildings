within Buildings.Controls.OBC.DemandFlexibility.Generic.Subsequences.Validation;
model RealNumberEqual "Exact equal block for real numbers"
  extends Modelica.Icons.Example;
  Buildings.Controls.OBC.DemandFlexibility.Generic.Subsequences.RealNumberEqual
    realNumberEqual(alwDev=1) "Exact equal block"
    annotation (Placement(transformation(extent={{-6,-12},{14,8}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin sin(
    final freqHz=1/43200,
    final amplitude=3,
    final offset=6)           "Sine wave"
    annotation (Placement(transformation(extent={{-72,0},{-52,20}})));
  CDL.Reals.Sources.Constant                   con(k=5) "Sine wave"
    annotation (Placement(transformation(extent={{-70,-48},{-50,-28}})));
equation
  connect(sin.y, realNumberEqual.u1) annotation (Line(points={{-50,10},{-30,10},
          {-30,4},{-8,4}}, color={0,0,127}));
  connect(con.y, realNumberEqual.u2) annotation (Line(points={{-48,-38},{-28,-38},
          {-28,-8},{-8,-8}}, color={0,0,127}));

    annotation (experiment(
      StopTime=86400,
      Interval=60,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"), Documentation(info="<html>
<p>This example validates <a href=\"modelica://cdl_models.Move.Generic.Subsequences.RealNumberEqual\">
Buildings.Controls.OBC.DemandFlexibility.Generic.Subsequences.ExactEqualReal</a> by
providing 2 varying real number inputs through sine waves.</p>
</html>",
        revisions="<html>
<ul>
<li>
April 03, 2026, by Weiping Huang:<br/>
First implementation.
</li>

</ul>
</html>"));
end RealNumberEqual;
