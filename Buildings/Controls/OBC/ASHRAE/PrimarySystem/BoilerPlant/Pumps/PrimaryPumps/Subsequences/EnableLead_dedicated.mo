within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.PrimaryPumps.Subsequences;
block EnableLead_dedicated
    "Sequence to enable or disable the lead pump of plants with dedicated primary hot water pumps"

  parameter Real offTimThr(
    final unit="s",
    displayUnit="s",
    final quantity="time") = 180
    "Threshold to check lead boiler off time";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uPlaEna
    "Plant enabling status"
    annotation (Placement(transformation(extent={{-140,30},{-100,70}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uLeaBoiSta
    "Lead boiler status"
    annotation (Placement(transformation(extent={{-140,-70},{-100,-30}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yLea
    "Lead pump status"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Latch leaPumSta
    "Lead pump status"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));

  Buildings.Controls.OBC.CDL.Logical.Not not2
    "Logical not"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));

  Buildings.Controls.OBC.CDL.Logical.Timer tim(
    final t=offTimThr)
    "Check if boiler disable time is greater than threshold"
    annotation (Placement(transformation(extent={{0,-60},{20,-40}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg
    "Detect plant being disabled"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));

  Buildings.Controls.OBC.CDL.Logical.And and2
    "Logical And"
    annotation (Placement(transformation(extent={{-30,-60},{-10,-40}})));

  Buildings.Controls.OBC.CDL.Logical.Latch lat
    "Boolean latch"
    annotation (Placement(transformation(extent={{-50,-20},{-30,0}})));

equation
  connect(uPlaEna, leaPumSta.u)
    annotation (Line(points={{-120,50},{50,50},{50,0},{58,0}},
                                                 color={255,0,255}));

  connect(leaPumSta.y, yLea)
    annotation (Line(points={{82,0},{120,0}},   color={255,0,255}));

  connect(uLeaBoiSta, not2.u)
    annotation (Line(points={{-120,-50},{-82,-50}},
                                                color={255,0,255}));

  connect(tim.passed, leaPumSta.clr) annotation (Line(points={{22,-58},{50,-58},
          {50,-6},{58,-6}}, color={255,0,255}));
  connect(uPlaEna, falEdg.u) annotation (Line(points={{-120,50},{-90,50},{-90,
          -10},{-82,-10}}, color={255,0,255}));
  connect(and2.y, tim.u)
    annotation (Line(points={{-8,-50},{-2,-50}}, color={255,0,255}));
  connect(not2.y, and2.u2) annotation (Line(points={{-58,-50},{-50,-50},{-50,
          -58},{-32,-58}}, color={255,0,255}));
  connect(falEdg.y, lat.u)
    annotation (Line(points={{-58,-10},{-52,-10}}, color={255,0,255}));
  connect(uPlaEna, lat.clr) annotation (Line(points={{-120,50},{-56,50},{-56,
          -16},{-52,-16}}, color={255,0,255}));
  connect(lat.y, and2.u1) annotation (Line(points={{-28,-10},{-20,-10},{-20,-30},
          {-40,-30},{-40,-50},{-32,-50}}, color={255,0,255}));
annotation (
  defaultComponentName="enaLeaPriPum_dedicated",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,150},{100,110}},
          textColor={0,0,255},
          textString="%name")}),
  Diagram(coordinateSystem(preserveAspectRatio=false)),
  Documentation(info="<html>
<p>
Block that enable and disable leading primary hot water pump, for plants
with dedicated primary hot water pumps, according to ASHRAE RP-1711, March 2020 draft, 
section 5.3.6.3.
</p>
<p>
The lead primary hot water pump status <code>yLea</code> should be enabled when
boiler plant is enabled (<code>uPlaEna</code> = true). It should be disabled when
the lead boiler is disabled and has been proven off (<code>uLeaBoiSta</code> 
= false) for time <code>offTimThr</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
July 30, 2020, by Karthik Devaprasad:<br/>
First implementation.
</li>
</ul>
</html>"));
end EnableLead_dedicated;
