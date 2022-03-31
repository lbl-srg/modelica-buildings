within Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.ASHRAE62_1;
block SumZone "Calculate the sum of zone level setpoints"

  parameter Integer nZon
    "Total number of serving zones";
  parameter Integer nZonGro
    "Total number of zone group";
  parameter Integer zonGroMat[nZonGro, nZon]
    "Zone matrix with zone group as row index and zone as column index. It falgs which zone is grouped in which zone group";
  parameter Integer zonGroMatTra[nZon, nZonGro]
    "Transpose of the zone matrix";

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uOpeMod[nZonGro]
    "AHU operation mode status signal"
    annotation (Placement(transformation(extent={{-260,160},{-220,200}}),
        iconTransformation(extent={{-140,70},{-100,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VAdjPopBreZon_flow[nZon](
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Adjusted population component breathing zone flow rate"
    annotation (Placement(transformation(extent={{-260,80},{-220,120}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VAdjAreBreZon_flow[nZon](
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Adjusted area component breathing zone flow rate"
    annotation (Placement(transformation(extent={{-260,20},{-220,60}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VZonPri_flow[nZon](
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate") "Measured zone primary airflow rates"
    annotation (Placement(transformation(extent={{-260,-60},{-220,-20}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VMinOA_flow[nZon](
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate") "Minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{-260,-134},{-220,-94}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VSumAdjPopBreZon_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Sum of the adjusted population component breathing zone flow rate"
    annotation (Placement(transformation(extent={{220,100},{260,140}}),
        iconTransformation(extent={{100,50},{140,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VSumAdjAreBreZon_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Sum of the adjusted area component breathing zone flow rate"
    annotation (Placement(transformation(extent={{220,40},{260,80}}),
        iconTransformation(extent={{100,10},{140,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VSumZonPri_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Sum of the zone primary airflow rates for all zones in all zone groups that are in occupied mode"
    annotation (Placement(transformation(extent={{220,-40},{260,0}}),
        iconTransformation(extent={{100,-50},{140,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput uOutAirFra_max(
    final min=0,
    final unit="1")
    "Maximum zone outdoor air fraction"
    annotation (Placement(transformation(extent={{220,-120},{260,-80}}),
        iconTransformation(extent={{100,-90},{140,-50}})));

  Buildings.Controls.OBC.CDL.Continuous.MatrixGain groFlo(
    final K=zonGroMat)
    "Vector of total zone flow of each group"
    annotation (Placement(transformation(extent={{-140,90},{-120,110}})));
  Buildings.Controls.OBC.CDL.Continuous.MatrixGain groFlo1(
    final K=zonGroMat)
    "Vector of total zone flow of each group"
    annotation (Placement(transformation(extent={{-140,30},{-120,50}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea[nZonGro]
    "Convert boolean to real"
    annotation (Placement(transformation(extent={{-40,170},{-20,190}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply mul[nZonGro]
    "Find the total flow of zone group"
    annotation (Placement(transformation(extent={{20,110},{40,130}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply mul1[nZonGro]
    "Find the total flow of zone group"
    annotation (Placement(transformation(extent={{20,50},{40,70}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum(
    final nin=nZonGro)
    "Sum of the adjusted population component breathing zone flow rate"
    annotation (Placement(transformation(extent={{80,110},{100,130}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum1(
    final nin=nZonGro)
    "Sum of the adjusted area component breathing zone flow rate"
    annotation (Placement(transformation(extent={{80,50},{100,70}})));
  Buildings.Controls.OBC.CDL.Continuous.MatrixGain groFlo2(
    final K=zonGroMat)
    "Vector of total zone flow of each group"
    annotation (Placement(transformation(extent={{-140,-50},{-120,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply mul2[nZonGro]
    "Find the total flow of zone group"
    annotation (Placement(transformation(extent={{20,-30},{40,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum2(
    final nin=nZonGro)
    "Sum of the zone primary airflow rates for all zones in all zone groups that are in occupied mode"
    annotation (Placement(transformation(extent={{80,-30},{100,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Divide div1[nZon]
    "Zone outdoor air fraction"
    annotation (Placement(transformation(extent={{-60,-130},{-40,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold lesThr[nZon](
    final t=1e-3,
    final h=0.5e-3)
    "Check if the flow rate is zero"
    annotation (Placement(transformation(extent={{-180,-202},{-160,-182}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi[nZon]
    "Ensure non zero value being divided"
    annotation (Placement(transformation(extent={{-120,-170},{-100,-150}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con[nZon](
    final k=1e5) "Large value"
    annotation (Placement(transformation(extent={{-180,-150},{-160,-130}})));
  Buildings.Controls.OBC.CDL.Continuous.MatrixGain groFlo3(
    final K=zonGroMatTra)
    "Vector of zones in occupied mode"
    annotation (Placement(transformation(extent={{20,-90},{40,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply mul3[nZon]
    "Vector of zone outdoor air fraction"
    annotation (Placement(transformation(extent={{80,-110},{100,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMax mulMax(
    final nin=nZon)
    "Maximum zone outdoor air fraction"
    annotation (Placement(transformation(extent={{140,-110},{160,-90}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant occMod[nZonGro](
    final k=fill(Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.occupied,nZonGro))
    "Occupied mode index"
    annotation (Placement(transformation(extent={{-180,130},{-160,150}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu1[nZonGro]
    "Check if operation mode is occupied"
    annotation (Placement(transformation(extent={{-100,170},{-80,190}})));
equation
  connect(uOpeMod, intEqu1.u1)
    annotation (Line(points={{-240,180},{-102,180}}, color={255,127,0}));
  connect(occMod.y, intEqu1.u2) annotation (Line(points={{-158,140},{-140,140},{
          -140,172},{-102,172}}, color={255,127,0}));
  connect(VAdjPopBreZon_flow, groFlo.u)
    annotation (Line(points={{-240,100},{-142,100}}, color={0,0,127}));
  connect(VAdjAreBreZon_flow, groFlo1.u)
    annotation (Line(points={{-240,40},{-142,40}},   color={0,0,127}));
  connect(intEqu1.y, booToRea.u)
    annotation (Line(points={{-78,180},{-42,180}}, color={255,0,255}));
  connect(groFlo.y, mul.u2) annotation (Line(points={{-118,100},{-100,100},{-100,
          114},{18,114}}, color={0,0,127}));
  connect(booToRea.y, mul.u1) annotation (Line(points={{-18,180},{0,180},{0,126},
          {18,126}}, color={0,0,127}));
  connect(booToRea.y, mul1.u1) annotation (Line(points={{-18,180},{0,180},{0,66},
          {18,66}},  color={0,0,127}));
  connect(groFlo1.y, mul1.u2) annotation (Line(points={{-118,40},{-100,40},{-100,
          54},{18,54}},   color={0,0,127}));
  connect(mul.y, mulSum.u)
    annotation (Line(points={{42,120},{78,120}}, color={0,0,127}));
  connect(mul1.y, mulSum1.u)
    annotation (Line(points={{42,60},{78,60}},   color={0,0,127}));
  connect(mulSum1.y, VSumAdjAreBreZon_flow)
    annotation (Line(points={{102,60},{240,60}},   color={0,0,127}));
  connect(mulSum.y, VSumAdjPopBreZon_flow)
    annotation (Line(points={{102,120},{240,120}}, color={0,0,127}));
  connect(VZonPri_flow, groFlo2.u)
    annotation (Line(points={{-240,-40},{-142,-40}}, color={0,0,127}));
  connect(groFlo2.y, mul2.u2) annotation (Line(points={{-118,-40},{-100,-40},{-100,
          -26},{18,-26}}, color={0,0,127}));
  connect(booToRea.y, mul2.u1) annotation (Line(points={{-18,180},{0,180},{0,-14},
          {18,-14}},color={0,0,127}));
  connect(mul2.y, mulSum2.u)
    annotation (Line(points={{42,-20},{78,-20}}, color={0,0,127}));
  connect(mulSum2.y, VSumZonPri_flow)
    annotation (Line(points={{102,-20},{240,-20}},  color={0,0,127}));
  connect(VMinOA_flow, div1.u1)
    annotation (Line(points={{-240,-114},{-62,-114}}, color={0,0,127}));
  connect(swi.y, div1.u2) annotation (Line(points={{-98,-160},{-80,-160},{-80,-126},
          {-62,-126}},color={0,0,127}));
  connect(VZonPri_flow, lesThr.u) annotation (Line(points={{-240,-40},{-200,-40},
          {-200,-192},{-182,-192}},color={0,0,127}));
  connect(lesThr.y, swi.u2) annotation (Line(points={{-158,-192},{-140,-192},{-140,
          -160},{-122,-160}}, color={255,0,255}));
  connect(VZonPri_flow, swi.u3) annotation (Line(points={{-240,-40},{-200,-40},{
          -200,-168},{-122,-168}}, color={0,0,127}));
  connect(con.y, swi.u1) annotation (Line(points={{-158,-140},{-140,-140},{-140,
          -152},{-122,-152}}, color={0,0,127}));
  connect(booToRea.y, groFlo3.u) annotation (Line(points={{-18,180},{0,180},{0,-80},
          {18,-80}}, color={0,0,127}));
  connect(div1.y, mul3.u2) annotation (Line(points={{-38,-120},{40,-120},{40,-106},
          {78,-106}},color={0,0,127}));
  connect(groFlo3.y, mul3.u1) annotation (Line(points={{42,-80},{60,-80},{60,-94},
          {78,-94}}, color={0,0,127}));
  connect(mul3.y, mulMax.u)
    annotation (Line(points={{102,-100},{138,-100}}, color={0,0,127}));
  connect(mulMax.y, uOutAirFra_max)
    annotation (Line(points={{162,-100},{240,-100}}, color={0,0,127}));
annotation (
  defaultComponentName="sumZon",
  Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
       graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,140},{100,100}},
          lineColor={0,0,255},
          textString="%name"),
        Text(
          extent={{10,80},{96,64}},
          lineColor={0,0,0},
          textString="VSumAdjPopBreZon_flow"),
        Text(
          extent={{10,38},{96,22}},
          lineColor={0,0,0},
          textString="VSumAdjAreBreZon_flow"),
        Text(
          extent={{-96,-32},{-42,-46}},
          lineColor={0,0,0},
          textString="VZonPri_flow"),
        Text(
          extent={{40,-60},{98,-76}},
          lineColor={0,0,0},
          textString="uOutAirFra_max"),
        Text(
          extent={{-98,8},{-20,-8}},
          lineColor={0,0,0},
          textString="VAdjAreBreZon_flow"),
        Text(
          extent={{40,-20},{98,-36}},
          lineColor={0,0,0},
          textString="VSumZonPri_flow"),
        Text(
          extent={{-98,48},{-20,32}},
          lineColor={0,0,0},
          textString="VAdjPopBreZon_flow"),
        Text(
          extent={{-96,-74},{-42,-88}},
          lineColor={0,0,0},
          textString="VMinOA_flow"),
        Text(
          extent={{-96,96},{-52,82}},
          lineColor={255,127,0},
          textString="uOpeMod")}),
Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-220,-220},{220,200}})),
Documentation(info="<html>
<p>
This sequence sums up zone level minimum outdoor airflow setpoints and find the maximum
outdoor air fraction. It is implemented according to Section 5.16.3.1 of ASHRAE
Guideline G36, May 2020.
</p>
<p>
It calculates following values:
</p>
<ol>
<li>
Sum of the adjusted population component breathing zone flow rate <code>VAdjPopBreZon_flow</code>
for all zones that are in
all zone groups in occupied mode, <code>VSumAdjPopBreZon_flow</code>.
</li>
<li>
Sum of the adjusted area component breathing zone flow rate <code>VAdjAreBreZon_flow</code>
for all zones that are in
all zone groups in occupied mode, <code>VSumAdjAreBreZon_flow</code>.
</li>
<li>
Sum of the zone primary airflow rates <code>VZonPri_flow</code>
for all zones in all zone groups that are in occupied mode,<code>VSumZonPri_flow</code>.
</li>
<li>
Maximum zone outdoor air fraction for all zones in all zone groups that are
in occupied mode, <code>uOutAirFra_max</code>.
</li>
</ol>
<p>
See <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.VentilationZones.ASHRAE62_1.Setpoints\">
Buildings.Controls.OBC.ASHRAE.G36.VentilationZones.ASHRAE62_1.Setpoints</a> for the detailed
description of the inputs <code>VAdjPopBreZon_flow</code>, <code>VAdjAreBreZon_flow</code>
and <code>VMinOA_flow</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
March 12, 2022, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end SumZone;
