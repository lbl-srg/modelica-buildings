within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences;
block EfficiencyCondition
  "Efficiency condition used in staging up and down"

  parameter Real effConTruDelay(
    final unit="s",
    final quantity="Time",
    displayUnit="h")=900
      "Enable delay";

  parameter Real sigDif = 0.05
    "Signal hysteresis deadband";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uOpe(
    final unit="1")
    "Operative part load ratio of the current stage"
    annotation (Placement(transformation(extent={{-140,0},{-100,40}}),
        iconTransformation(extent={{-140,30},{-100,70}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uStaUp(
    final unit="1")
    "Staging part load ratio of the next stage up"
    annotation (Placement(transformation(extent={{-140,-40},{-100,0}}),
        iconTransformation(extent={{-140,-70},{-100,-30}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y
    "Efficiency condition for chiller staging"
    annotation (Placement(transformation(extent={{80,-20},{120,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));

protected
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(
    final delayTime=effConTruDelay,
    final delayOnInit=true)
    "Delays a true signal"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));

  Buildings.Controls.OBC.CDL.Reals.Hysteresis hysOpe(
    final uLow=0,
    final uHigh=sigDif)
    "Checks if the current stage operating part load ratio exceeds the stage up part load ratio"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));

  Buildings.Controls.OBC.CDL.Reals.Subtract sub
    "Subtracts part load ratios"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));

equation
  connect(truDel.y, y)
    annotation (Line(points={{42,0},{100,0}},color={255,0,255}));
  connect(hysOpe.y, truDel.u)
    annotation (Line(points={{2,0},{18,0}}, color={255,0,255}));
  connect(sub.y, hysOpe.u)
    annotation (Line(points={{-38,0},{-22,0}}, color={0,0,127}));
  connect(uOpe, sub.u1) annotation (Line(points={{-120,20},{-80,20},{-80,6},{-62,
          6}}, color={0,0,127}));
  connect(uStaUp, sub.u2) annotation (Line(points={{-120,-20},{-80,-20},{-80,-6},
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
          textColor={0,0,255},
          textString="%name")}),
        Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-60},{80,60}})),
Documentation(info="<html>
<p>
Efficiency condition used in staging up and down for plants primary-only and
primary-secondary plants, both with and without a water side economizer.
It is implemented according to the specification provided in section 5.20.4.15 of
Guideline36-2021.
</p>
</html>",
revisions="<html>
<ul>
<li>
April 5, 2020, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end EfficiencyCondition;
