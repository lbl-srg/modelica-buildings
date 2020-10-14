within Buildings.Controls.OBC.FDE.DOAS;
block SupplyFanController
  "This block manages start, stop, status, and speed of the supply fan."

 parameter Real minDDSPset(
   min=0,
   final unit="Pa",
   final quantity="PressureDifference")=125
    "Minimum down duct static pressure reset value"
      annotation (Dialog(group="DDSP range"));

 parameter Real maxDDSPset(
   min=0,
   final unit="Pa",
   final quantity="PressureDifference")=500
    "Maximum down duct static pressure reset value"
      annotation (Dialog(group="DDSP range"));

  parameter Real cvDDSPset(
   min=0,
   final unit="Pa",
   final quantity="PressureDifference")=250
    "Constant volume down duct static pressure set point";

 parameter Real damSet(
   min=0,
   max=1,
   final unit="1")=0.9
   "DDSP terminal damper percent open set point";

 parameter Boolean vvUnit = true
   "Set true when unit serves variable volume system.";

  // ---inputs---
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput occ
    "True when occupied mode is active"
    annotation (Placement(transformation(extent={{-142,60},{-102,100}}),
       iconTransformation(extent={{-140,50},{-100,90}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput mostOpenDam if vvUnit
    "Most open damper position from all terminal units served."
      annotation (Placement(transformation(extent={{-142,-24},{-102,16}}),
        iconTransformation(extent={{-140,14},{-100,54}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput supFanStatus
    "True when supply fan is proven on."
      annotation (Placement(transformation(extent={{-142,22},{-102,62}}),
        iconTransformation(extent={{-140,-56},{-100,-16}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput DDSP
    "Down duct static pressure measurement."
      annotation (Placement(transformation(extent={{-142,-106},{-102,-66}}),
        iconTransformation(extent={{-140,-92},{-100,-52}})));

  // ---outputs---
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput supFanStart
   "Command supply fan to start when true."
     annotation (Placement(transformation(extent={{102,60},{142,100}}),
       iconTransformation(extent={{100,32},{140,72}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput supFanProof
    "True when supply fan is proven on"
      annotation (Placement(transformation(extent={{102,22},{142,62}}),
        iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput supFanSpeed
    "Supply fan speed command"
      annotation (Placement(transformation(extent={{102,-50},{142,-10}}),
        iconTransformation(extent={{100,-64},{140,-24}})));


  Buildings.Controls.OBC.CDL.Continuous.LimPID DDSPreset(
    k=0.0000001,
    Ti=0.00025,
    yMax=maxDDSPset,
    yMin=minDDSPset,
    reverseAction=true) if vvUnit
    "Calculates DDSP reset value for VV units."
      annotation (Placement(transformation(extent={{-72,4},{-52,24}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant dampSet(
    final k=damSet) if vvUnit
    "Most open damper position set point."
      annotation (Placement(transformation(extent={{-98,4},{-78,24}})));
  Buildings.Controls.OBC.CDL.Continuous.LimPID conPID(k=0.0000001, Ti=0.00025)
    "PI calculation for fan speed."
      annotation (Placement(transformation(extent={{48,-40},{68,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant conVVunit(
    final k=vvUnit)
      "True when unit serves variable volume system."
        annotation (Placement(transformation(extent={{-72,-32},{-52,-12}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant cvDDSPsetpt(
    final k=cvDDSPset) if not vvUnit
      "DDSP set point for constant volume systems."
        annotation (Placement(transformation(extent={{-72,-64},{-52,-44}})));
  CDL.Logical.Switch swi
    "Swtich passes fan speed set point when true; 0 when false."
    annotation (Placement(transformation(extent={{14,-40},{34,-20}})));
  CDL.Continuous.Sources.Constant con0(
    final k=0)
    "Real constant 0"
    annotation (Placement(transformation(extent={{-26,-64},{-6,-44}})));
equation
  connect(supFanStart, occ)
    annotation (Line(points={{122,80},{-122,80}}, color={255,0,255}));
  connect(DDSPreset.u_s, dampSet.y)
    annotation (Line(points={{-74,14},{-76,14}}, color={0,0,127}));
  connect(DDSPreset.u_m, mostOpenDam)
    annotation (Line(points={{-62,2},{-62,-4},{-122,-4}},  color={0,0,127}));
  connect(supFanStatus, supFanProof)
    annotation (Line(points={{-122,42},{122,42}},   color={255,0,255}));
  connect(conPID.u_m, DDSP)
    annotation (Line(points={{58,-42},{58,-86},{-122,-86}}, color={0,0,127}));
  connect(con0.y, swi.u3)
    annotation (Line(points={{-4,-54},{4,-54},{4,-38},{12,-38}},
      color={0,0,127}));
  connect(conPID.y, supFanSpeed)
    annotation (Line(points={{70,-30},{122,-30}}, color={0,0,127}));
  connect(swi.y, conPID.u_s)
    annotation (Line(points={{36,-30},{46,-30}}, color={0,0,127}));
  connect(supFanStatus, swi.u2)
    annotation (Line(points={{-122,42},{0,42},{0,-30},{12,-30}},
      color={255,0,255}));
  connect(DDSPreset.y, swi.u1) annotation (Line(points={{-50,14},{-34,14},{-34,
          -22},{12,-22}}, color={0,0,127}));
  connect(cvDDSPsetpt.y, swi.u1) annotation (Line(points={{-50,-54},{-34,-54},{
          -34,-22},{12,-22}}, color={0,0,127}));
  annotation (defaultComponentName="SFcon",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
            Rectangle(extent={{-100,100},{100,-100}},
            lineColor={179,151,128},
            radius=10,
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-8,40},{54,-14}},
          lineColor={162,29,33},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
           Text(
            extent={{-90,180},{90,76}},
            lineColor={28,108,200},
            textStyle={TextStyle.Bold},
            textString="%name"),
        Ellipse(
          extent={{-54,40},{28,-42}},
          lineColor={162,29,33},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-24,12},{0,-12}},
          lineColor={162,29,33},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-108,78},{-64,62}},
          lineColor={28,108,200},
          textString="occ"),
        Text(
          extent={{-100,-30},{-58,-44}},
          lineColor={28,108,200},
          textString="Status"),
        Text(
          extent={{62,60},{106,44}},
          lineColor={28,108,200},
          textString="Start"),
        Text(
          extent={{56,8},{106,-8}},
          lineColor={28,108,200},
          textString="Proof"),
        Text(
          extent={{-102,-66},{-60,-78}},
          lineColor={28,108,200},
          textString="DDSP"),
        Text(
          extent={{56,-36},{106,-52}},
          lineColor={28,108,200},
          textString="Speed"),
        Line(
          points={{-54,54},{-10,52},{-50,52}},
          color={0,127,0},
          pattern=LinePattern.None),
        Line(
          points={{-52,50},{-2,48},{30,54},{-26,68},{134,70},{148,22},{152,42}},
          color={0,127,0},
          pattern=LinePattern.None),
        Line(
          points={{-68,72},{6,72}},
          color={0,127,0},
          pattern=LinePattern.None),
        Line(
          points={{-52,70},{6,66},{-28,66}},
          color={0,127,0},
          pattern=LinePattern.None),
        Line(
          points={{42,60},{36,54},{28,70},{42,62}},
          color={0,127,0},
          pattern=LinePattern.None),
        Text(
          extent={{-96,44},{-52,28}},
          lineColor={28,108,200},
          textString="openDam")}),          Diagram(coordinateSystem(
          preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>
September 11, 2020, by Henry Nickels:</br>
First implementation.</li>
</ul>
</html>", info="<html>
<h4>Supply Fan Start/Stop.</h4>
<p>This block commands the supply fan to start 
(<code>supFanStart</code>) when the unit enters occupied
(<code>occ</code>) mode. When supply fan status
(<code>SupFanStatus</code>) is proven, fan speed control
(<code>SupFanSpeed</code>) is enabled and the
supply fan proof (<code>supFanProof</code>) is turned on.</p>
<h4>Down Duct Static Pressure Control</h4>
<p>The supply fan speed 
(<code>supFanSpeed</code>) is modulated to  maintain
the down duct static pressure (<code>DDSP</code>) at
set point. The down duct set point is reset between minimum 
(<code>minDDSPset</code>) and maximum 
(<code>maxDDSPset</code>) values determined by TAB. The reset is
based on the most open damper
(<code>mostOpenDam</code>) remaining at a specific position
(<code>damSet</code>) (i.e. The terminal unit air flow set point is satisfied
 with its primary air damper 90% open).</p>
<p>There is also an option for a fixed down duct static pressure set point
(<code>cvDDSPset</code>) when the variable volume parameter
<code>vvUnit</code> is false.
</p>
</html>"));
end SupplyFanController;
