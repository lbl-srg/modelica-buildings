within Buildings.Controls.OBC.DemandFlexibility.Generic.Subsequences.Validation;
model ExactEqualReal "Exact equal block for real numbers"
  extends Modelica.Icons.Example;
  Buildings.Controls.OBC.DemandFlexibility.Generic.Subsequences.ExactEqualReal
    exactEqualReal
    annotation (Placement(transformation(extent={{-6,-12},{14,8}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin sin(
    final freqHz=1/86400,
    final amplitude=1,
    phase=3.1415926535898,
    final offset=273.15 + 20)
    annotation (Placement(transformation(extent={{-72,0},{-52,20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin sin1(
    final freqHz=1/21600,
    final amplitude=10,
    final offset=273.15 + 25)
    annotation (Placement(transformation(extent={{-70,-48},{-50,-28}})));
equation
  connect(sin.y, exactEqualReal.u1) annotation (Line(points={{-50,10},{-30,10},{
          -30,4},{-8,4}}, color={0,0,127}));
  connect(sin1.y, exactEqualReal.u2) annotation (Line(points={{-48,-38},{-28,-38},
          {-28,-8},{-8,-8}}, color={0,0,127}));

    annotation (experiment(
      StopTime=172800,
      Interval=60,
      __Dymola_Algorithm="Dassl"), Documentation(info="<html>
<p>This example validates <a href=\"modelica://Buildings.Controls.OBC.DemandFlexibility.Generic.Subsequences.ExactEqualReal\">
Buildings.Controls.OBC.DemandFlexibility.Generic.Subsequences.ExactEqualReal</a>.</p>
</html>",
        revisions="<html>
<ul>
<li>
April 03, 2026, by Weiping Huang:<br/>
First implementation.
</li>

</ul>
</html>"));
end ExactEqualReal;
