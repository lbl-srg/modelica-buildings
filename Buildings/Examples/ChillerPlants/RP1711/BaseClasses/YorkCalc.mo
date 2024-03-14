within Buildings.Examples.ChillerPlants.RP1711.BaseClasses;
model YorkCalc
  "Cooling tower with variable speed using the York calculation for the approach temperature and output the actual fan speed"
  extends Buildings.Fluid.HeatExchangers.CoolingTowers.YorkCalc;

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yFanSpe
    annotation (Placement(transformation(extent={{100,30},{120,50}}),
        iconTransformation(extent={{100,20},{140,60}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant minFanSpe(
    final k=yMin)
    "Minimum tower fan speed"
    annotation (Placement(transformation(extent={{-60,24},{-40,44}})));
  Buildings.Controls.OBC.CDL.Reals.Max actSpe
    "Actual fan speed"
    annotation (Placement(transformation(extent={{60,30},{80,50}})));

equation
  connect(actSpe.y, yFanSpe)
    annotation (Line(points={{82,40},{110,40}}, color={0,0,127}));
  connect(y, actSpe.u1) annotation (Line(points={{-120,80},{40,80},{40,46},{58,46}},
        color={0,0,127}));
  connect(minFanSpe.y, actSpe.u2)
    annotation (Line(points={{-38,34},{58,34}}, color={0,0,127}));

annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Text(extent={{72,34},{106,16}}, textColor={0,0,127}, textString="yFanSpe")}),
  Diagram(coordinateSystem(preserveAspectRatio=false)),
Documentation(info="<HTML>
<p>
This model extends <a href=\"modelica://Buildings.Fluid.HeatExchangers.CoolingTowers.YorkCalc\">
Buildings.Fluid.HeatExchangers.CoolingTowers.YorkCalc</a>, with the output of the
actual fan speed, which is the lower value between <code>y</code> and the tower
minimum speed <code>yMin</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
March 12, 2024, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end YorkCalc;
