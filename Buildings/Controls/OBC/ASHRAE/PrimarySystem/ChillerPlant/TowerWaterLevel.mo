within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant;
block TowerWaterLevel
  "Sequences to control water level in cooling tower"
  parameter Modelica.SIunits.Length watLevMin(
    final min=0,
    final max=watLevMax)
    "Minimum cooling tower water level recommended by manufacturer";
  parameter Modelica.SIunits.Length watLevMax(
    final min=watLevMin)
    "maximum cooling tower water level recommended by manufacturer";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput watLev(
    final quantity="Length")
    "Measured water level"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yMakUp
    "Makeup water valve On-Off status"
    annotation (Placement(transformation(extent={{100,-10},{120,10}}),
        iconTransformation(extent={{100,-10},{120,10}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant watLevMinCon(
    final k=watLevMin)
    "Minimum water level"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant watLevMaxCon(
    final k=watLevMax)
    "Maximum water level"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterEqual greEqu
    "Check if water level above maximum"
    annotation (Placement(transformation(extent={{-20,-30},{0,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.LessEqual lesEqu
    "Check if water level below minimum"
    annotation (Placement(transformation(extent={{-20,10},{0,30}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat
    "Latch makeup water valve control"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));

equation
  connect(watLevMaxCon.y, greEqu.u2)
    annotation (Line(points={{-59,-50},{-40,-50},{-40,-28},{-22,-28}},
      color={0,0,127}));
  connect(watLev, greEqu.u1)
    annotation (Line(points={{-120,0},{-60,0},{-60,-20},{-22,-20}},
      color={0,0,127}));
  connect(watLev, lesEqu.u1)
    annotation (Line(points={{-120,0},{-60,0},{-60,20},{-22,20}},
      color={0,0,127}));
  connect(watLevMinCon.y, lesEqu.u2)
    annotation (Line(points={{-59,50},{-40,50},{-40,12},{-22,12}},
      color={0,0,127}));
  connect(lesEqu.y, lat.u)
    annotation (Line(points={{1,20},{20,20},{20,0},{39,0}},
        color={255,0,255}));
  connect(greEqu.y, lat.u0)
    annotation (Line(points={{1,-20},{20,-20},{20,-6},{39,-6}},
      color={255,0,255}));
  connect(lat.y, yMakUp)
    annotation (Line(points={{61,0},{110,0}}, color={255,0,255}));

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
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="watLev"),
        Text(
          extent={{58,8},{98,-4}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yMakUp"),
        Text(
          extent={{-120,146},{100,108}},
          lineColor={0,0,255},
          textString="%name")}),
Documentation(info="<html>
<p>
Block that output <code>yMakUp</code> to control cooling tower make-up water
valve.
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
end TowerWaterLevel;
