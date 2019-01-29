within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences;
block EfficiencyCondition
  "Efficiency condition used in staging up and down"

  parameter Modelica.SIunits.Time delayStaCha = 15*60
  "Enable delay";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uOplr(final unit="1")
    "Operating part load ratio of the current stage" annotation (Placement(
        transformation(extent={{-140,0},{-100,40}}),   iconTransformation(
          extent={{-120,40},{-100,60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uSplrUp(final unit="1")
    "Staging part load ratio of the next stage up" annotation (Placement(
        transformation(extent={{-140,-40},{-100,0}}), iconTransformation(extent={{-120,
            -60},{-100,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y "Efficiency condition for chiller staging"
    annotation (Placement(transformation(extent={{80,-10},{100,10}}),
        iconTransformation(extent={{100,-10},{120,10}})));

protected
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(
    final delayTime=delayStaCha)
    "Delays a true signal"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hysOplr(
    final uLow=0,
    final uHigh=0.05)
    "Checks if the current stage operating part load ratio exceeds the stage up part load ratio"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));

  Buildings.Controls.OBC.CDL.Continuous.Add add(final k2=-1) "Subtracts part load ratios"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));

equation
  connect(truDel.y, y)
    annotation (Line(points={{41,0},{90,0}}, color={255,0,255}));
  connect(hysOplr.y, truDel.u)
    annotation (Line(points={{1,0},{18,0}}, color={255,0,255}));
  connect(add.y, hysOplr.u)
    annotation (Line(points={{-39,0},{-22,0}}, color={0,0,127}));
  connect(uOplr, add.u1) annotation (Line(points={{-120,20},{-80,20},{-80,6},{-62,
          6}}, color={0,0,127}));
  connect(uSplrUp, add.u2) annotation (Line(points={{-120,-20},{-80,-20},{-80,-6},
          {-62,-6}}, color={0,0,127}));
  annotation (defaultComponentName = "effCon",
        Icon(graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-120,146},{100,108}},
          lineColor={0,0,255},
          textString="%name")}),
                          Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-60},{80,60}})),
Documentation(info="<html>
<p>
Efficiency condition used in staging up and down, according to 2019-01-07 RP 1711 Task 2 document, section 5.2.4.11.
</p>
</html>",
revisions="<html>
<ul>
<li>
January 28, 2019, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end EfficiencyCondition;
