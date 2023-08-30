within Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.Reheat.Subsequences;
block ActiveAirFlow
  "Output the active airflow setpoint for VAV reheat terminal unit"

  parameter Real VCooMax_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s")
    "Design zone cooling maximum airflow rate";
  parameter Real VHeaMin_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s")
    "Design zone heating minimum airflow rate, for the reheat box with water hot coil, it should be zero";
  parameter Real VHeaMax_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s")
    "Design zone heating maximum airflow rate";

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uOpeMod
    "Zone operation mode"
    annotation (Placement(transformation(extent={{-240,130},{-200,170}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VOccMin_flow(
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Occupied minimum airflow setpoint"
    annotation (Placement(transformation(extent={{-240,20},{-200,60}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VActCooMax_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Active cooling maximum airflow setpoint"
    annotation (Placement(transformation(extent={{200,150},{240,190}}),
        iconTransformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VActCooMin_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Active cooling minimum airflow setpoint"
    annotation (Placement(transformation(extent={{200,100},{240,140}}),
        iconTransformation(extent={{100,20},{140,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VActMin_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Active minimum airflow setpoint"
    annotation (Placement(transformation(extent={{200,60},{240,100}}),
        iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VActHeaMin_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Active heating minimum airflow setpoint"
    annotation (Placement(transformation(extent={{200,0},{240,40}}),
        iconTransformation(extent={{100,-60},{140,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VActHeaMax_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Active heating maximum airflow setpoint"
    annotation (Placement(transformation(extent={{200,-140},{240,-100}}),
        iconTransformation(extent={{100,-100},{140,-60}})));

protected
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant occMod(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.occupied)
    "Occupied mode"
    annotation (Placement(transformation(extent={{-160,180},{-140,200}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant cooDowMod(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.coolDown)
    "Cool down mode"
    annotation (Placement(transformation(extent={{-160,80},{-140,100}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant setUpMod(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.setUp)
    "Setup mode"
    annotation (Placement(transformation(extent={{-160,0},{-140,20}})));
  Buildings.Controls.OBC.CDL.Logical.Or3 or3
    "Check if it is in occupied, cooldown, or setup mode"
    annotation (Placement(transformation(extent={{-20,160},{0,180}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal actCooMax(
    final realTrue=VCooMax_flow)
    "Active cooling maximum flow"
    annotation (Placement(transformation(extent={{140,160},{160,180}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal occModInd(
    final realTrue=1)
    "If in occupied mode, output 1"
    annotation (Placement(transformation(extent={{-20,120},{0,140}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply pro
    "Active cooling minimum, minimum airflow setpoint"
    annotation (Placement(transformation(extent={{140,110},{160,130}})));
  Buildings.Controls.OBC.CDL.Reals.Max max1
    "Maximum of inputs"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal heaMinFlo(
    final realTrue=VHeaMin_flow)
    "Heating minimum flow when input is true"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal heaMaxFlo(
    final realTrue=VHeaMax_flow)
    "Heating maximum flow when input is true"
    annotation (Placement(transformation(extent={{40,-50},{60,-30}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal cooMaxFlo(
    final realTrue=VCooMax_flow)
    "Cooling maximum flow when input is true"
    annotation (Placement(transformation(extent={{40,-150},{60,-130}})));
  Buildings.Controls.OBC.CDL.Reals.Max max2
    "Maximum of inputs"
    annotation (Placement(transformation(extent={{-20,-120},{0,-100}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply pro1
    "Product of inputs"
    annotation (Placement(transformation(extent={{40,60},{60,80}})));
  Buildings.Controls.OBC.CDL.Logical.Or or2
    "Check if it is warm-up or setback"
    annotation (Placement(transformation(extent={{-20,-50},{0,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Add add2
    "Add up inputs"
    annotation (Placement(transformation(extent={{100,-30},{120,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Add add1
    "Active heating minimu flow setpoint"
    annotation (Placement(transformation(extent={{160,10},{180,30}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply pro2
    "Product of inputs"
    annotation (Placement(transformation(extent={{40,-90},{60,-70}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal heaMaxFlo1(
    final realTrue=VHeaMax_flow)
    "Heating maximum flow when input is true"
    annotation (Placement(transformation(extent={{40,-190},{60,-170}})));
  Buildings.Controls.OBC.CDL.Reals.Add add3
    "Add up inputs"
    annotation (Placement(transformation(extent={{100,-170},{120,-150}})));
  Buildings.Controls.OBC.CDL.Reals.Add add4
    "Active heating maximum flow setpoint"
    annotation (Placement(transformation(extent={{160,-130},{180,-110}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant setBacMod(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.setBack)
    "Setback mode"
    annotation (Placement(transformation(extent={{-160,-200},{-140,-180}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant warUpMod(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.warmUp)
    "Warm up mode"
    annotation (Placement(transformation(extent={{-160,-90},{-140,-70}})));
  Buildings.Controls.OBC.CDL.Integers.Equal ifOcc
    "Check if current operation mode is occupied mode"
    annotation (Placement(transformation(extent={{-120,180},{-100,200}})));
  Buildings.Controls.OBC.CDL.Integers.Equal ifCooDow
    "Check if current operation mode is cooldown mode"
    annotation (Placement(transformation(extent={{-120,80},{-100,100}})));
  Buildings.Controls.OBC.CDL.Integers.Equal ifSetUp
    "Check if current operation mode is setup mode"
    annotation (Placement(transformation(extent={{-120,0},{-100,20}})));
  Buildings.Controls.OBC.CDL.Integers.Equal ifWarUp
    "Check if current operation mode is warm-up mode"
    annotation (Placement(transformation(extent={{-120,-90},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Integers.Equal ifSetBac
    "Check if current operation mode is setback mode"
    annotation (Placement(transformation(extent={{-120,-200},{-100,-180}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant heaMaxAir(
    final k=VHeaMax_flow)
    "Heating maximum airflow"
    annotation (Placement(transformation(extent={{-100,-160},{-80,-140}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant heaMinAir(
    final k=VHeaMin_flow)
    "Heating minimum airflow"
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));

equation
  connect(occMod.y, ifOcc.u1)
    annotation (Line(points={{-138,190},{-122,190}}, color={255,127,0}));
  connect(cooDowMod.y, ifCooDow.u1)
    annotation (Line(points={{-138,90},{-122,90}}, color={255,127,0}));
  connect(setUpMod.y, ifSetUp.u1)
    annotation (Line(points={{-138,10},{-122,10}}, color={255,127,0}));
  connect(warUpMod.y, ifWarUp.u1)
    annotation (Line(points={{-138,-80},{-122,-80}}, color={255,127,0}));
  connect(uOpeMod, ifOcc.u2) annotation (Line(points={{-220,150},{-130,150},{-130,
          182},{-122,182}}, color={255,127,0}));
  connect(uOpeMod, ifCooDow.u2) annotation (Line(points={{-220,150},{-130,150},{
          -130,82},{-122,82}}, color={255,127,0}));
  connect(uOpeMod, ifSetUp.u2) annotation (Line(points={{-220,150},{-130,150},{-130,
          2},{-122,2}}, color={255,127,0}));
  connect(uOpeMod, ifWarUp.u2) annotation (Line(points={{-220,150},{-130,150},{-130,
          -88},{-122,-88}}, color={255,127,0}));
  connect(uOpeMod, ifSetBac.u2) annotation (Line(points={{-220,150},{-130,150},{
          -130,-198},{-122,-198}}, color={255,127,0}));
  connect(setBacMod.y, ifSetBac.u1)
    annotation (Line(points={{-138,-190},{-122,-190}}, color={255,127,0}));
  connect(ifOcc.y, or3.u1) annotation (Line(points={{-98,190},{-60,190},{-60,178},
          {-22,178}}, color={255,0,255}));
  connect(ifCooDow.y, or3.u2) annotation (Line(points={{-98,90},{-70,90},{-70,170},
          {-22,170}}, color={255,0,255}));
  connect(ifSetUp.y, or3.u3) annotation (Line(points={{-98,10},{-50,10},{-50,162},
          {-22,162}}, color={255,0,255}));
  connect(or3.y, actCooMax.u)
    annotation (Line(points={{2,170},{138,170}}, color={255,0,255}));
  connect(ifOcc.y, occModInd.u) annotation (Line(points={{-98,190},{-60,190},{-60,
          130},{-22,130}}, color={255,0,255}));
  connect(VOccMin_flow, pro.u2) annotation (Line(points={{-220,40},{-180,40},{-180,
          114},{138,114}}, color={0,0,127}));
  connect(occModInd.y, pro.u1) annotation (Line(points={{2,130},{100,130},{100,126},
          {138,126}}, color={0,0,127}));
  connect(VOccMin_flow, max1.u1) annotation (Line(points={{-220,40},{-180,40},{-180,
          56},{-22,56}}, color={0,0,127}));
  connect(heaMinAir.y, max1.u2) annotation (Line(points={{-78,-30},{-60,-30},{-60,
          44},{-22,44}}, color={0,0,127}));
  connect(VOccMin_flow, max2.u1) annotation (Line(points={{-220,40},{-180,40},{-180,
          -104},{-22,-104}}, color={0,0,127}));
  connect(heaMaxAir.y, max2.u2) annotation (Line(points={{-78,-150},{-60,-150},{
          -60,-116},{-22,-116}}, color={0,0,127}));
  connect(max1.y, pro1.u2) annotation (Line(points={{2,50},{20,50},{20,64},{38,64}},
        color={0,0,127}));
  connect(occModInd.y, pro1.u1) annotation (Line(points={{2,130},{10,130},{10,76},
          {38,76}}, color={0,0,127}));
  connect(ifCooDow.y, heaMinFlo.u) annotation (Line(points={{-98,90},{-70,90},{-70,
          0},{38,0}}, color={255,0,255}));
  connect(ifWarUp.y, or2.u1) annotation (Line(points={{-98,-80},{-50,-80},{-50,-40},
          {-22,-40}}, color={255,0,255}));
  connect(or2.y, heaMaxFlo.u)
    annotation (Line(points={{2,-40},{38,-40}}, color={255,0,255}));
  connect(ifSetBac.y, or2.u2) annotation (Line(points={{-98,-190},{-40,-190},{-40,
          -48},{-22,-48}}, color={255,0,255}));
  connect(heaMinFlo.y, add2.u1) annotation (Line(points={{62,0},{80,0},{80,-14},
          {98,-14}}, color={0,0,127}));
  connect(heaMaxFlo.y, add2.u2) annotation (Line(points={{62,-40},{80,-40},{80,-26},
          {98,-26}}, color={0,0,127}));
  connect(pro1.y, add1.u1) annotation (Line(points={{62,70},{140,70},{140,26},{158,
          26}}, color={0,0,127}));
  connect(add2.y, add1.u2) annotation (Line(points={{122,-20},{140,-20},{140,14},
          {158,14}}, color={0,0,127}));
  connect(max2.y, pro2.u2) annotation (Line(points={{2,-110},{10,-110},{10,-86},
          {38,-86}}, color={0,0,127}));
  connect(occModInd.y, pro2.u1) annotation (Line(points={{2,130},{10,130},{10,-74},
          {38,-74}}, color={0,0,127}));
  connect(or2.y, cooMaxFlo.u) annotation (Line(points={{2,-40},{20,-40},{20,-140},
          {38,-140}}, color={255,0,255}));
  connect(ifCooDow.y, heaMaxFlo1.u) annotation (Line(points={{-98,90},{-70,90},{
          -70,-180},{38,-180}}, color={255,0,255}));
  connect(heaMaxFlo1.y, add3.u2) annotation (Line(points={{62,-180},{80,-180},{80,
          -166},{98,-166}}, color={0,0,127}));
  connect(cooMaxFlo.y, add3.u1) annotation (Line(points={{62,-140},{80,-140},{80,
          -154},{98,-154}}, color={0,0,127}));
  connect(pro2.y, add4.u1) annotation (Line(points={{62,-80},{140,-80},{140,-114},
          {158,-114}}, color={0,0,127}));
  connect(add3.y, add4.u2) annotation (Line(points={{122,-160},{140,-160},{140,-126},
          {158,-126}}, color={0,0,127}));
  connect(actCooMax.y, VActCooMax_flow)
    annotation (Line(points={{162,170},{220,170}}, color={0,0,127}));
  connect(pro.y, VActCooMin_flow)
    annotation (Line(points={{162,120},{220,120}}, color={0,0,127}));
  connect(pro.y, VActMin_flow) annotation (Line(points={{162,120},{180,120},{180,
          80},{220,80}}, color={0,0,127}));
  connect(add1.y, VActHeaMin_flow)
    annotation (Line(points={{182,20},{220,20}}, color={0,0,127}));
  connect(add4.y, VActHeaMax_flow)
    annotation (Line(points={{182,-120},{220,-120}}, color={0,0,127}));

annotation (
  defaultComponentName="actAirSet",
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-200,-220},{200,220}})),
  Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
        graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,140},{100,100}},
          textColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-96,68},{-54,52}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="uOpeMod"),
        Text(
          extent={{34,90},{98,74}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VActCooMax_flow"),
        Text(
          extent={{36,48},{98,34}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VActCooMin_flow"),
        Text(
          extent={{50,6},{98,-4}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VActMin_flow"),
        Text(
          extent={{38,-32},{98,-46}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VActHeaMin_flow"),
        Text(
          extent={{34,-70},{98,-86}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VActHeaMax_flow"),
        Text(
          extent={{-98,-52},{-36,-68}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VOccMin_flow")}),
Documentation(info="<html>
<p>
This sequence sets the active cooling and heating maximum and minimum setpoints
for VAV reheat terminal unit. The implementation is according to the Section 5.6.4
of ASHRAE Guideline 36, May 2020.
</p>
<p>The setpoints shall vary depending on the mode of the zone group.</p>
<table summary=\"summary\" border=\"1\">
<tr><th>Setpoint</th> <th>Occupied</th><th>Cooldown</th>
<th>Setup</th><th>Warm-up</th><th>Setback</th><th>Unoccupied</th></tr>
<tr><td>Cooling maximum (<code>VActCooMax_flow</code>)</td><td><code>VCooMax_flow</code></td>
<td><code>VCooMax_flow</code></td><td><code>VCooMax_flow</code></td>
<td>0</td><td>0</td><td>0</td></tr>
<tr><td>Cooling minimum (<code>VActCooMin_flow</code>)</td><td><code>VOccMin_flow</code></td>
<td>0</td><td>0</td><td>0</td><td>0</td><td>0</td></tr>
<tr><td>Minimum (<code>VActMin_flow</code>)</td><td><code>VOccMin_flow</code></td><td>0</td>
<td>0</td><td>0</td><td>0</td><td>0</td></tr>
<tr><td>Heating minimum (<code>VActHeaMin_flow</code>)</td><td>max(<code>VHeaMin_flow,VOccMin_flow</code>)</td>
<td><code>VHeaMin_flow</code></td><td>0</td><td><code>VHeaMax_flow</code></td><td><code>VHeaMax_flow</code></td>
<td>0</td></tr>
<tr><td>Heating maximum (<code>VActHeaMax_flow</code>)</td><td>max(<code>VHeaMax_flow,VOccMin_flow</code>)</td>
<td><code>VHeaMax_flow</code></td><td>0</td><td><code>VCooMax_flow</code></td><td><code>VCooMax_flow</code></td>
<td>0</td></tr>
</table>
<br/>
</html>", revisions="<html>
<ul>
<li>
August 1, 2020, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end ActiveAirFlow;
