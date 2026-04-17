within Buildings.Controls.OBC.DemandFlexibility.Generic.Subsequences.Validation;
model RealEqual "Check whether two real numbers are approximately equal"
  extends Modelica.Icons.Example;
  Buildings.Controls.OBC.DemandFlexibility.Generic.Subsequences.RealEqual reaEqu(alwDev=1)
    "Real number equal block"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin u1(
    final freqHz=1/43200,
    final amplitude=3,
    final offset=6) "A sine wave input signal"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant u2(k=5)
    "A constant input signal"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
equation
  connect(u1.y, reaEqu.u1) annotation (Line(points={{-38,30},{-30,30},{-30,6},{
          18,6}}, color={0,0,127}));
  connect(u2.y, reaEqu.u2) annotation (Line(points={{-38,-50},{-28,-50},{-28,-6},
          {18,-6}}, color={0,0,127}));

    annotation (experiment(
      StopTime=86400,
      Interval=60,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
      __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/DemandFlexibility/Generic/Subsequences/Validation/RealEqual.mos"
        "Simulate and plot"),
      Documentation(info="<html>
<p>
This example validates <a href=\"modelica://Buildings.Controls.OBC.DemandFlexibility.Generic.Subsequences.RealEqual\">
Buildings.Controls.OBC.DemandFlexibility.Generic.Subsequences.RealEqual</a> by
providing a sine waves input and a constant real number input.
</p>
</html>",
        revisions="<html>
<ul>
<li>
April 03, 2026, by Weiping Huang:<br/>
First implementation.
</li>

</ul>
</html>"));
end RealEqual;
