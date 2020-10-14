within Buildings.Controls.OBC.FDE.DOAS;
block EconMode
  "This block calculates when economizer mode is active."

  parameter Real econCooAdj(
   final unit="K",
   final displayUnit="degC",
   final quantity="ThermodynamicTemperature")=2
   "Value subtracted from supply air temperature cooling set point.";

    // ---inputs---
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput supFanProof
    "True when supply fan is proven on"
      annotation (Placement(transformation(extent={{-142,42},{-102,82}}),
        iconTransformation(extent={{-142,50},{-102,90}})));

   Buildings.Controls.OBC.CDL.Interfaces.RealInput oaT
    "Outside air temperature"
      annotation (Placement(transformation(extent={{-142,6},{-102,46}}),
        iconTransformation(extent={{-142,-20},{-102,20}})));

    // ---outputs---
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput ecoMode
    "True when economizer mode is active."
      annotation (Placement(transformation(extent={{104,-20},{144,20}}),
        iconTransformation(extent={{102,-20},{142,20}})));


  Buildings.Controls.OBC.CDL.Continuous.Add add2(
    final k2=-1)
    "Subtract econCooAdj value from supCooSP."
      annotation (Placement(transformation(extent={{-52,-26},{-32,-6}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput supCooSP
    "Supply air temperature cooling set point."
      annotation (Placement(transformation(extent={{-142,-30},{-102,10}}),
        iconTransformation(extent={{-142,-90},{-102,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(
    k=econCooAdj)
      "Value subtracted from supply air temperature cooling set point."
        annotation (Placement(transformation(extent={{-86,-36},{-66,-16}})));
  Buildings.Controls.OBC.CDL.Continuous.Greater gre
    "True if OAT > supCooSP."
    annotation (Placement(transformation(extent={{-20,-46},{0,-26}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat
    "Latches true when OAT < (supCooSP-econCooAdj); resets when OAT > supCooSP."
    annotation (Placement(transformation(extent={{42,-18},{62,2}})));
  Buildings.Controls.OBC.CDL.Logical.And and2
    "Logical AND; true when fan is proven on and 
      temperature set point conditions are met."
    annotation (Placement(transformation(extent={{74,-10},{94,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Less les
    "True if OAT< (supCooSP-econCooAdj)."
    annotation (Placement(transformation(extent={{-20,-18},{0,2}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(
    final delayTime=10,
    final delayOnInit=true)
    "Delay added to compensate for CDL not processing latch correctly."
    annotation (Placement(transformation(extent={{10,-18},{30,2}})));
equation
  connect(and2.u1, supFanProof)
    annotation (Line(points={{72,0},{66,0},{66,62},{-122,62}},
      color={255,0,255}));
  connect(les.u1, oaT)
    annotation (Line(points={{-22,-8},{-26,-8},{-26,26},{-122,26}},
      color={0,0,127}));
  connect(add2.y, les.u2)
    annotation (Line(points={{-30,-16},{-22,-16}}, color={0,0,127}));
  connect(add2.u1, supCooSP)
    annotation (Line(points={{-54,-10},{-122,-10}}, color={0,0,127}));
  connect(con.y, add2.u2)
    annotation (Line(points={{-64,-26},{-60,-26},{-60,-22},{-54,-22}},
      color={0,0,127}));
  connect(oaT, gre.u1)
    annotation (Line(points={{-122,26},{-26,26},{-26,-36},{-22,-36}},
      color={0,0,127}));
  connect(supCooSP, gre.u2)
    annotation (Line(points={{-122,-10},{-92,-10},{-92,-44},{-22,-44}},
      color={0,0,127}));
  connect(gre.y, lat.clr)
    annotation (Line(points={{2,-36},{34,-36},{34,-14},{40,-14}},
      color={255,0,255}));
  connect(lat.y, and2.u2)
    annotation (Line(points={{64,-8},{72,-8}}, color={255,0,255}));
  connect(and2.y, ecoMode)
    annotation (Line(points={{96,0},{124,0}}, color={255,0,255}));
  connect(les.y, truDel.u)
    annotation (Line(points={{2,-8},{8,-8}}, color={255,0,255}));
  connect(truDel.y, lat.u)
    annotation (Line(points={{32,-8},{40,-8}}, color={255,0,255}));
  annotation (defaultComponentName="EconMod",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
            Rectangle(extent={{-102,100},{98,-100}},
            lineColor={0,0,0},
            radius=10,
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
           Text(
            extent={{-90,180},{90,76}},
            lineColor={28,108,200},
            textStyle={TextStyle.Bold},
            textString="%name"),
        Text(
          extent={{-96,78},{-52,64}},
          lineColor={28,108,200},
          textString="supFanProof"),
        Text(
          extent={{-108,8},{-64,-6}},
          lineColor={28,108,200},
          textString="oaT"),
        Text(
          extent={{-96,-64},{-56,-76}},
          lineColor={28,108,200},
          textString="supCooSP"),
        Text(
          extent={{58,6},{96,-6}},
          lineColor={28,108,200},
          textString="ecoMode"),
        Rectangle(
          extent={{18,-2},{22,-64}},
          lineColor={28,108,200},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{16,-32},{54,-44}},
          lineColor={28,108,200},
          textString="On"),
        Text(
          extent={{14,38},{52,26}},
          lineColor={28,108,200},
          textString="Off"),
        Rectangle(
          extent={{18,60},{22,-2}},
          lineColor={244,125,35},
          fillColor={244,125,35},
          fillPattern=FillPattern.Solid),
        Line(points={{-38,46},{6,46}}, color={0,0,0}),
        Line(points={{-38,18},{6,18}}, color={0,0,0}),
        Ellipse(
          extent={{-18,34},{-14,30}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(points={{-16,34},{-16,46}}, color={0,0,0}),
        Line(points={{-16,18},{-16,30}}, color={0,0,0}),
        Line(points={{-36,-24},{8,-24}}, color={0,0,0}),
        Line(points={{-12,-38},{2,-38}}, color={0,0,0}),
        Ellipse(
          extent={{-16,-36},{-12,-40}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(points={{-36,-52},{8,-52}}, color={0,0,0}),
        Line(points={{-30,-38},{-16,-38}}, color={0,0,0}),
        Text(
          extent={{-32,4},{6,-8}},
          lineColor={28,108,200},
          textString="%add2.y")}),                           Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<h4>Economizer Mode</h4>
<p>This block enables economizer mode
(<code>ecoMode</code>) when the supply air fan is proven
(<code>supFanProof</code>) and outside air temperature
(<code>oaT</code>) is below the supply air temperature cooling set point 
(<code>supCooSP</code>) minus an offset (<code>econCooAdj</code>).
Economizer mode is disabled when outside air temperature 
rises above the supply air temperature cooling set point.</p> 
</html>", revisions="<html>
<ul>
<li>
September 15, 2020, by Henry Nickels:</br>
First implementation.</li>
</ul>
</html>"));
end EconMode;
