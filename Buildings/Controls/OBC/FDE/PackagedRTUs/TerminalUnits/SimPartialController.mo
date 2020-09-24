within Buildings.Controls.OBC.FDE.PackagedRTUs.TerminalUnits;
block SimPartialController
  "Partial terminal unit controller simulates requests for packaged RTU example."

  parameter Real coolTStpt(
   final unit="K",
   final displayUnit="degC",
   final quantity="ThermodynamicTemperature")=297.15
   "Zone cooling temperature set point."
   annotation (Dialog(group="Temperature set points"));

  parameter Real heatTStpt(
   final unit="K",
   final displayUnit="degC",
   final quantity="ThermodynamicTemperature")=293.15
   "Zone heating temperature set point."
   annotation (Dialog(group="Temperature set points"));

  parameter Real coolMinDelay(
    final unit="s",
    final quantity="Time")=5
    "Minimum delay before issuing cool request after trigger"
    annotation (Dialog(group="Trigger delay times"));

  parameter Real heatMinDelay(
    final unit="s",
    final quantity="Time")=5
    "Minimum delay before issuing heat request after trigger"
    annotation (Dialog(group="Trigger delay times"));

   parameter Real occMinDelay(
    final unit="1",
    final quantity="Time")=5
    "Minimum delay before issuing occupancy request after trigger"
    annotation (Dialog(group="Trigger delay times"));

  parameter Real coolDStpt(
    final unit="1")=0.85
    "Trigger cool request when cooling PID exceeds this value"
    annotation (Dialog(group="PID trigger set points"));

  parameter Real heatDStpt(
    final unit="1")=0.85
    "Trigger heat request when cooling PID exceeds this value"
    annotation (Dialog(group="PID trigger set points"));

  parameter Integer coolReqG(
     min=1) = 1
     "Cooling request gain"
    annotation (Dialog(group="Request gain parameters"));

  parameter Integer heatReqG(
     min=1) = 1
     "Heating request gain"
    annotation (Dialog(group="Request gain parameters"));

  parameter Integer occReqG(
     min=1) = 1
     "Occupancy request gain"
    annotation (Dialog(group="Request gain parameters"));

 // ---inputs---
   Buildings.Controls.OBC.CDL.Interfaces.RealInput ZoneT
  "Zone temperature"
  annotation (Placement(
    transformation(extent={{-142,36},{-102,76}}),
    iconTransformation(extent={{-140,16},{-100,56}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput OccOvrd
  "Occupancy override"
  annotation (Placement(
    transformation(extent={{-142,-76},{-102,-36}}),
    iconTransformation(extent={{-140,-52},{-100,-12}})));

  // ---outputs---
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput termCoolReq
    "Terminal unit cooling requests."
    annotation (Placement(transformation(extent={{144,48},{184,88}}),
        iconTransformation(extent={{102,42},{142,82}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput termSBC
    "Terminal setback cooling request"
    annotation (Placement(transformation(extent={{144,18},{184,58}}),
        iconTransformation(extent={{102,14},{142,54}})));

   Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput termHeatReq
    "Terminal unit heating requests."
    annotation (Placement(transformation(extent={{144,-18},{184,22}}),
        iconTransformation(extent={{102,-20},{142,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput termSBH
    "Terminal setback heating request"
    annotation (Placement(transformation(extent={{144,-46},{184,-6}}),
        iconTransformation(extent={{102,-50},{142,-10}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput termOccReq
    "Terminal unit occupancy requests"
    annotation (Placement(transformation(extent={{144,-82},{184,-42}}),
        iconTransformation(extent={{102,-82},{142,-42}})));


  Buildings.Controls.OBC.CDL.Continuous.LimPID conPIDcooling(
  reverseAction=true)
  "Zone cooling PI calculation."
    annotation (Placement(
      transformation(extent={{-64,64},{-44,84}})));
  Buildings.Controls.OBC.CDL.Continuous.LimPID conPIDheating
    "Zone heating PI calculation."
    annotation (Placement(
      transformation(extent={{-64,-2},{-44,18}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant coolSetpoint(
  final k=coolTStpt)
  "Zone temperature cooling set point."
    annotation (Placement(
      transformation(extent={{-94,64},{-74,84}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant heatSetpoint(
  final k=heatTStpt)
  "Zone temperature heating set point."
    annotation (Placement(
      transformation(extent={{-94,-2},{-74,18}})));
  Buildings.Controls.OBC.CDL.Continuous.Greater coolDemGreSetpt
    "True when cooling demand greater than demand set point."
    annotation (Placement(
      transformation(extent={{-36,64},{-16,84}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay coolReqDel(
  delayTime=coolMinDelay,
  delayOnInit=true)
    "Cooling request delay."
    annotation (Placement(
      transformation(extent={{-10,64},{10,84}})));
  Buildings.Controls.OBC.CDL.Continuous.Greater heatDemGreSetpt
    "True when heatling demand greater than demand set point."
    annotation (Placement(
      transformation(extent={{-36,-2},{-16,18}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay heatReqDel(
  delayTime=heatMinDelay,
  delayOnInit=true)
    "Heating request delay."
    annotation (Placement(
      transformation(extent={{-10,-2},{10,18}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay occReqDel(
  delayTime=occMinDelay,
  delayOnInit=true)
    "Occupancy override request delay."
    annotation (Placement(
      transformation(extent={{-10,-66},{10,-46}})));
  Buildings.Controls.OBC.CDL.Integers.Product proInt
  "Product of two Integers."
    annotation (Placement(transformation(extent={{52,58},{72,78}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant coolReqGain(
    k=coolReqG)
    "Cooling request gain."
    annotation (Placement(transformation(extent={{22,38},{42,58}})));
  Buildings.Controls.OBC.CDL.Integers.Product proInt1
    "Product of two Integers."
    annotation (Placement(transformation(extent={{52,-8},{72,12}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant heatlReqGain(
    k=heatReqG)
    "Heating request gain."
    annotation (Placement(transformation(extent={{22,-28},{42,-8}})));
  Buildings.Controls.OBC.CDL.Integers.Product proInt2
    "Product of two Integers."
    annotation (Placement(transformation(extent={{52,-72},{72,-52}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant occlReqGain(
    k=occReqG)
    "Occupancy request gain."
    annotation (Placement(transformation(extent={{22,-92},{42,-72}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant coolTrigSet(
    k=coolDStpt)
    "Trigger cool request when cooling PID exceeds this value."
    annotation (Placement(transformation(extent={{-64,30},{-44,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant heatTrigSet(
    k=heatDStpt)
    "Trigger heat request when heating PID exceeds this value."
    annotation (Placement(transformation(extent={{-64,-36},{-44,-16}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant con1(
    final k=1)
    "Constant Integer 1."
    annotation (Placement(transformation(extent={{-10,32},{10,52}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant con0(
    final k=0)
    "Constant Integer 0."
    annotation (Placement(transformation(extent={{-10,-34},{10,-14}})));
  Buildings.Controls.OBC.CDL.Logical.IntegerSwitch intSwi
    "Integer value Logical switch."
    annotation (Placement(transformation(extent={{22,64},{42,84}})));
  Buildings.Controls.OBC.CDL.Logical.IntegerSwitch intSwi1
    "Integer value Logical switch."
    annotation (Placement(transformation(extent={{22,-2},{42,18}})));
  Buildings.Controls.OBC.CDL.Logical.IntegerSwitch intSwi2
    "Integer value Logical switch."
    annotation (Placement(transformation(extent={{22,-66},{42,-46}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
  "Logical NOT."
    annotation (Placement(transformation(extent={{54,-98},{74,-78}})));
  Buildings.Controls.OBC.CDL.Logical.And and2
  "Logical AND."
    annotation (Placement(transformation(extent={{78,22},{98,42}})));
  Buildings.Controls.OBC.CDL.Logical.And and1
  "Logical AND."
    annotation (Placement(transformation(extent={{78,-44},{98,-24}})));
  Buildings.Controls.OBC.CDL.Logical.IntegerSwitch intSwi3
    "Integer value Logical switch."
    annotation (Placement(transformation(extent={{108,22},{128,42}})));
  Buildings.Controls.OBC.CDL.Logical.IntegerSwitch intSwi4
    "Integer value Logical switch."
    annotation (Placement(transformation(extent={{108,-44},{128,-24}})));

equation
  connect(conPIDcooling.u_m, ZoneT)
    annotation (Line(
      points={{-54,62},{-54,56},{-122,56}},
      color={0,0,127}));
  connect(conPIDheating.u_m, ZoneT)
    annotation (Line(
      points={{-54,-4},{-54,-10},{-98,-10},{-98,56},{-122,56}},
      color={0,0,127}));
  connect(conPIDheating.u_s, heatSetpoint.y)
    annotation (Line(points={{-66,8},{-72,8}},    color={0,0,127}));
  connect(heatDemGreSetpt.y, heatReqDel.u)
    annotation (Line(points={{-14,8},{-12,8}}, color={255,0,255}));
  connect(conPIDheating.y, heatDemGreSetpt.u1)
    annotation (Line(points={{-42,8},{-38,8}},  color={0,0,127}));
  connect(occReqDel.u, OccOvrd)
    annotation (Line(points={{-12,-56},{-122,-56}},color={255,0,255}));
  connect(coolReqGain.y, proInt.u2) annotation (Line(points={{44,48},{46,48},{46,
          62},{50,62}}, color={255,127,0}));
  connect(heatlReqGain.y, proInt1.u2) annotation (Line(points={{44,-18},{46,-18},
          {46,-4},{50,-4}}, color={255,127,0}));
  connect(proInt1.y, termHeatReq)
    annotation (Line(points={{74,2},{164,2}}, color={255,127,0}));
  connect(occlReqGain.y, proInt2.u2) annotation (Line(points={{44,-82},{46,-82},
          {46,-68},{50,-68}}, color={255,127,0}));
  connect(proInt2.y, termOccReq)
    annotation (Line(points={{74,-62},{164,-62}}, color={255,127,0}));
  connect(proInt.y, termCoolReq)
    annotation (Line(points={{74,68},{164,68}}, color={255,127,0}));
  connect(coolSetpoint.y, conPIDcooling.u_s)
    annotation (Line(points={{-72,74},{-66,74}}, color={0,0,127}));
  connect(conPIDcooling.y, coolDemGreSetpt.u1)
    annotation (Line(points={{-42,74},{-38,74}}, color={0,0,127}));
  connect(coolDemGreSetpt.y, coolReqDel.u)
    annotation (Line(points={{-14,74},{-12,74}},color={255,0,255}));
  connect(coolReqDel.y, intSwi.u2)
    annotation (Line(points={{12,74},{20,74}}, color={255,0,255}));
  connect(intSwi.y, proInt.u1)
    annotation (Line(points={{44,74},{50,74}}, color={255,127,0}));
  connect(heatReqDel.y, intSwi1.u2)
    annotation (Line(points={{12,8},{20,8}}, color={255,0,255}));
  connect(intSwi1.y, proInt1.u1)
    annotation (Line(points={{44,8},{50,8}}, color={255,127,0}));
  connect(occReqDel.y, intSwi2.u2)
    annotation (Line(points={{12,-56},{20,-56}}, color={255,0,255}));
  connect(intSwi2.y, proInt2.u1)
    annotation (Line(points={{44,-56},{50,-56}}, color={255,127,0}));
  connect(con1.y, intSwi.u1) annotation (Line(points={{12,42},{14,42},{14,82},{20,
          82}}, color={255,127,0}));
  connect(con1.y, intSwi1.u1) annotation (Line(points={{12,42},{14,42},{14,16},{
          20,16}}, color={255,127,0}));
  connect(con1.y, intSwi2.u1) annotation (Line(points={{12,42},{14,42},{14,-48},
          {20,-48}}, color={255,127,0}));
  connect(con0.y, intSwi.u3) annotation (Line(points={{12,-24},{16,-24},{16,66},
          {20,66}}, color={255,127,0}));
  connect(con0.y, intSwi1.u3) annotation (Line(points={{12,-24},{16,-24},{16,0},
          {20,0}}, color={255,127,0}));
  connect(con0.y, intSwi2.u3) annotation (Line(points={{12,-24},{16,-24},{16,-64},
          {20,-64}}, color={255,127,0}));
  connect(coolTrigSet.y, coolDemGreSetpt.u2) annotation (Line(points={{-42,40},{
          -40,40},{-40,66},{-38,66}}, color={0,0,127}));
  connect(heatTrigSet.y, heatDemGreSetpt.u2) annotation (Line(points={{-42,-26},
          {-40,-26},{-40,0},{-38,0}}, color={0,0,127}));
  connect(occReqDel.y, not1.u) annotation (Line(points={{12,-56},{14,-56},{14,-98},
          {52,-98},{52,-88}}, color={255,0,255}));
  connect(not1.y, and1.u2)
    annotation (Line(points={{76,-88},{76,-42}},          color={255,0,255}));
  connect(not1.y, and2.u2)
    annotation (Line(points={{76,-88},{76,24}}, color={255,0,255}));
  connect(heatReqDel.y, and1.u1) annotation (Line(points={{12,8},{18,8},{18,-34},
          {76,-34}}, color={255,0,255}));
  connect(coolReqDel.y, and2.u1) annotation (Line(points={{12,74},{18,74},{18,32},
          {76,32}}, color={255,0,255}));
  connect(and2.y, intSwi3.u2)
    annotation (Line(points={{100,32},{106,32}}, color={255,0,255}));
  connect(con1.y, intSwi3.u1) annotation (Line(points={{12,42},{66,42},{66,48},{
          106,48},{106,40}}, color={255,127,0}));
  connect(and1.y, intSwi4.u2)
    annotation (Line(points={{100,-34},{106,-34}}, color={255,0,255}));
  connect(con1.y, intSwi4.u1) annotation (Line(points={{12,42},{102,42},{102,-26},
          {106,-26}}, color={255,127,0}));
  connect(con0.y, intSwi3.u3) annotation (Line(points={{12,-24},{100,-24},{100,24},
          {106,24}}, color={255,127,0}));
  connect(con0.y, intSwi4.u3) annotation (Line(points={{12,-24},{100,-24},{100,-42},
          {106,-42}}, color={255,127,0}));
  connect(intSwi3.y, termSBC) annotation (Line(points={{130,32},{134,32},{134,38},
          {164,38}}, color={255,127,0}));
  connect(intSwi4.y, termSBH) annotation (Line(points={{130,-34},{136,-34},{136,
          -26},{164,-26}}, color={255,127,0}));
  annotation (defaultComponentName="SimPartCon",
  Icon(coordinateSystem(preserveAspectRatio=false),
  graphics={Rectangle(extent={{-100,100},{100,-100}},
            lineColor={179,151,128},
            radius=10,
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
           Text(
            extent={{-90,180},{90,76}},
            lineColor={28,108,200},
            textStyle={TextStyle.Bold},
            textString="%name"),
        Line(points={{-90,36},{82,36}}, color={0,0,255}),
        Line(points={{-86,-32},{82,-32}}, color={238,46,47}),
        Line(points={{-88,0},{-78,20},{-72,28},{-62,42},{-54,50},{-44,56},{-32,58},
              {-22,56},{-12,52},{-6,46},{2,36},{10,16},{12,8},{14,-2},{18,-14},{
              22,-28},{30,-42},{38,-50},{48,-56},{56,-56},{64,-50},{70,-42},{74,
              -36},{78,-28},{80,-20}}, color={0,140,72}),
        Text(
          extent={{-50,86},{-18,60}},
          lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="1"),
        Text(
          extent={{36,-62},{68,-88}},
          lineColor={238,46,47},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="1"),
        Text(
          extent={{-18,14},{14,-12}},
          lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="0"),
        Text(
          extent={{14,14},{46,-12}},
          lineColor={238,46,47},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="0")}),
           Diagram(coordinateSystem(
             preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>September 4, 2020, by Henry Nickels:<br/>
First implementation. 
</li>
<li>September 9, 2020, by Henry Nickels:<br/>
Convert logical outputs to integer with gain.
</li>
</ul>
</html>", info="<html>
<p>When the zone temperature <span style=\"font-family: Courier New;\">ZoneT</span> is above the zone cooling set point <span style=\"font-family: Courier New;\">coolTStpt</span> the cooling PID output will increase. When the cooling PID output exceeds the cooling demand set point (<span style=\"font-family: Courier New;\">coolDStpt</span>) for a minimum time period (<span style=\"font-family: Courier New;\">coolMinDelay</span>) a cooling request ( <span style=\"font-family: Courier New;\">termCoolReq</span>) is generated. A gain can be applied to this request to reflect the importance of the terminal unit. </p>
<p>When the zone temperature <span style=\"font-family: Courier New;\">ZoneT</span> is below the zone heating set point <span style=\"font-family: Courier New;\">heatTStpt</span> the heating PID output will increase. When the heating PID output exceeds the heating demand set point (<span style=\"font-family: Courier New;\">heatDStpt</span>) for a minimum time period (<span style=\"font-family: Courier New;\">heatMinDelay</span>) a heating request ( <span style=\"font-family: Courier New;\">termHeatReq</span>) is generated.  A gain can be applied to this request to reflect the importance of the terminal unit. </p>
<p>When occupancy override <span style=\"font-family: Courier New;\">OccOvrd</span> is active for the minimum delay <span style=\"font-family: Courier New;\">occReqDel</span> period an occupancy request will be generated.  A gain can be applied to this request to reflect the importance of the terminal unit.</p>
</html>"));
end SimPartialController;
