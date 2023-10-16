within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers;
block WaterLevel
  "Sequences to control water level in cooling tower"

  parameter Real watLevMin(
    final min=0)
    "Minimum cooling tower water level recommended by manufacturer";
  parameter Real watLevMax(
    final min=0)
    "Maximum cooling tower water level recommended by manufacturer";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput watLev
    "Measured water level"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yMakUp
    "Makeup water valve On-Off status"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));

protected
  Buildings.Controls.OBC.CDL.Reals.Hysteresis hys(
    final uLow=watLevMin,
    final uHigh=watLevMax)
    "Check if water level is lower than minimum level"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant minWatLev(
    final k=watLevMin) "Minimum water level"
    annotation (Placement(transformation(extent={{-40,-90},{-20,-70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant maxWatLev(
    final k=watLevMax) "Maximum water level"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes(
    final message="The maximum level has to be greater than the minimum level.")
    "Print warning when the maximum level is not set to be greater than the minimum level"
    annotation (Placement(transformation(extent={{60,-50},{80,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Greater greEqu
    "Check if maximum level is set to be greater than minimum level"
    annotation (Placement(transformation(extent={{20,-50},{40,-30}})));

equation
  connect(watLev, hys.u)
    annotation (Line(points={{-120,0},{-12,0}}, color={0,0,127}));
  connect(hys.y, not1.u)
    annotation (Line(points={{12,0},{38,0}}, color={255,0,255}));
  connect(not1.y, yMakUp)
    annotation (Line(points={{62,0},{120,0}}, color={255,0,255}));
  connect(maxWatLev.y, greEqu.u1)
    annotation (Line(points={{-18,-40},{18,-40}}, color={0,0,127}));
  connect(minWatLev.y, greEqu.u2)
    annotation (Line(points={{-18,-80},{0,-80},{0,-48},{18,-48}}, color={0,0,127}));
  connect(greEqu.y, assMes.u)
    annotation (Line(points={{42,-40},{58,-40}}, color={255,0,255}));

annotation (
  defaultComponentName = "makUpWat",
  Diagram(
        coordinateSystem(preserveAspectRatio=false)), Icon(graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-96,6},{-56,-6}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="watLev"),
        Text(
          extent={{58,8},{98,-4}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yMakUp"),
        Text(
          extent={{-120,146},{100,108}},
          textColor={0,0,255},
          textString="%name")}),
Documentation(info="<html>
<p>
Block that outputs <code>yMakUp</code> to control cooling tower make-up water
valve. It is implemented according to 
ASHRAE RP-1711 Advanced Sequences of Operation for HVAC Systems Phase II –
Central Plants and Hydronic Systems (Draft on March 23, 2020), 
section 5.2.13, tower make-up water.
</p>
<p>
Make-up water valve shall cycle based on tower water fill level sensor. The
valve shall open when water level <code>watLev</code> falls below the minimum
fill level <code>watLevMin</code> recommended by the tower manufacturer. It 
shall close when the water level goes above the maximum level <code>watLevMax</code>. 
</p> 
</html>",
revisions="<html>
<ul>
<li>
March 07, 2018, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end WaterLevel;
