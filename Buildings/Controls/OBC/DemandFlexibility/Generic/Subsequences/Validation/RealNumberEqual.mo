within Buildings.Controls.OBC.DemandFlexibility.Generic.Subsequences.Validation;
model RealNumberEqual "Exact equal block for real numbers"
  extends Modelica.Icons.Example;
  Buildings.Controls.OBC.DemandFlexibility.Generic.Subsequences.RealNumberEqual
    reaNumEqu(alwDev=1) "Real number equal block"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin sin(
    final freqHz=1/43200,
    final amplitude=3,
    final offset=6)           "Sine wave"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant                   con(k=5) "Constant"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
equation
  connect(sin.y, reaNumEqu.u1) annotation (Line(points={{-38,30},{-30,30},{-30,6},
          {18,6}}, color={0,0,127}));
  connect(con.y, reaNumEqu.u2) annotation (Line(points={{-38,-50},{-28,-50},{-28,
          -6},{18,-6}}, color={0,0,127}));

    annotation (experiment(
      StopTime=86400,
      Interval=60,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"), Documentation(info="<html>
<p>This example validates <a href=\"modelica://Buildings.Controls.OBC.DemandFlexibility.Generic.Subsequences.RealNumberEqual\">
Buildings.Controls.OBC.DemandFlexibility.Generic.Subsequences.RealNumberEqual</a> by
providing a sine waves input and a constant real number input.</p>
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
