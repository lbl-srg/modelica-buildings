within Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.ASHRAE62_1;
block SumZone "Calculate the sum of zone level setpoints"

  parameter Integer nZon
    "Total number of serving zones";
  parameter Integer nGro
    "Total number of groups";
  parameter Integer zonGroMat[nGro, nZon]
    "Zone matrix with zone group as row index and zone as column index. It uses index 1 to flag which zone is in which group";
  parameter Integer zonGroMatTra[nZon, nGro]
    "Transpose of the zone matrix";

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uOpeMod[nGro]
    "Groups operation mode"
    annotation (Placement(transformation(extent={{-260,160},{-220,200}}),
        iconTransformation(extent={{-140,70},{-100,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VAdjPopBreZon_flow[nZon](
    final min=fill(0,nZon),
    final unit=fill("m3/s",nZon),
    final quantity=fill("VolumeFlowRate", nZon))
    "Adjusted population component breathing zone flow rate"
    annotation (Placement(transformation(extent={{-260,80},{-220,120}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VAdjAreBreZon_flow[nZon](
    final min=fill(0,nZon),
    final unit=fill("m3/s",nZon),
    final quantity=fill("VolumeFlowRate", nZon))
    "Adjusted area component breathing zone flow rate"
    annotation (Placement(transformation(extent={{-260,20},{-220,60}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VZonPri_flow[nZon](
    final min=fill(0,nZon),
    final unit=fill("m3/s",nZon),
    final quantity=fill("VolumeFlowRate", nZon))
    "Measured zone primary airflow rates"
    annotation (Placement(transformation(extent={{-260,-40},{-220,0}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VMinOA_flow[nZon](
    final min=fill(0,nZon),
    final unit=fill("m3/s",nZon),
    final quantity=fill("VolumeFlowRate", nZon))
    "Minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{-260,-120},{-220,-80}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VSumAdjPopBreZon_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Sum of the adjusted population component breathing zone flow rate"
    annotation (Placement(transformation(extent={{220,100},{260,140}}),
        iconTransformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VSumAdjAreBreZon_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Sum of the adjusted area component breathing zone flow rate"
    annotation (Placement(transformation(extent={{220,40},{260,80}}),
        iconTransformation(extent={{100,20},{140,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VSumZonPri_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Sum of the zone primary airflow rates for all zones in all zone groups that are in occupied mode"
    annotation (Placement(transformation(extent={{220,-20},{260,20}}),
        iconTransformation(extent={{100,-60},{140,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput uOutAirFra_max(
    final min=0,
    final unit="1")
    "Maximum zone outdoor air fraction"
    annotation (Placement(transformation(extent={{220,-90},{260,-50}}),
        iconTransformation(extent={{100,-100},{140,-60}})));

  Buildings.Controls.OBC.CDL.Continuous.MatrixGain groFlo(
    final K=zonGroMat)
    "Vector of total zone flow of each group"
    annotation (Placement(transformation(extent={{-140,90},{-120,110}})));
  Buildings.Controls.OBC.CDL.Continuous.MatrixGain groFlo1(
    final K=zonGroMat)
    "Vector of total zone flow of each group"
    annotation (Placement(transformation(extent={{-140,30},{-120,50}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea[nGro]
    "Convert boolean to real"
    annotation (Placement(transformation(extent={{-40,170},{-20,190}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply mul[nGro]
    "Find the total flow of zone group"
    annotation (Placement(transformation(extent={{20,110},{40,130}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply mul1[nGro]
    "Find the total flow of zone group"
    annotation (Placement(transformation(extent={{20,50},{40,70}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum(
    final nin=nGro)
    "Sum of the adjusted population component breathing zone flow rate"
    annotation (Placement(transformation(extent={{80,110},{100,130}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum1(
    final nin=nGro)
    "Sum of the adjusted area component breathing zone flow rate"
    annotation (Placement(transformation(extent={{80,50},{100,70}})));
  Buildings.Controls.OBC.CDL.Continuous.MatrixGain groFlo2(
    final K=zonGroMat)
    "Vector of total zone flow of each group"
    annotation (Placement(transformation(extent={{-140,-30},{-120,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply mul2[nGro]
    "Find the total flow of zone group"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum2(
    final nin=nGro)
    "Sum of the zone primary airflow rates for all zones in all zone groups that are in occupied mode"
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Divide div1[nZon]
    "Zone outdoor air fraction"
    annotation (Placement(transformation(extent={{-40,-110},{-20,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.MatrixGain groFlo3(
    final K=zonGroMatTra)
    "Vector of zones in occupied mode"
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply mul3[nZon]
    "Vector of zone outdoor air fraction"
    annotation (Placement(transformation(extent={{80,-80},{100,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMax mulMax(
    final nin=nZon)
    "Maximum zone outdoor air fraction"
    annotation (Placement(transformation(extent={{140,-80},{160,-60}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant occMod[nGro](
    final k=fill(Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.occupied,nGro))
    "Occupied mode index"
    annotation (Placement(transformation(extent={{-180,130},{-160,150}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu1[nGro]
    "Check if operation mode is occupied"
    annotation (Placement(transformation(extent={{-100,170},{-80,190}})));
  Buildings.Controls.OBC.CDL.Continuous.Max max2[nZon] "Avoid devide by zero"
    annotation (Placement(transformation(extent={{-100,-150},{-80,-130}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant neaZer[nZon](
    final k=fill(1E-4, nZon))
    "Near zero value"
    annotation (Placement(transformation(extent={{-160,-180},{-140,-160}})));
  Buildings.Controls.OBC.CDL.Continuous.Min min1[nZon] "Use smaller value"
    annotation (Placement(transformation(extent={{-120,-104},{-100,-84}})));
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
    annotation (Line(points={{-240,-20},{-142,-20}}, color={0,0,127}));
  connect(groFlo2.y, mul2.u2) annotation (Line(points={{-118,-20},{-100,-20},{-100,
          -6},{18,-6}},   color={0,0,127}));
  connect(booToRea.y, mul2.u1) annotation (Line(points={{-18,180},{0,180},{0,6},
          {18,6}},  color={0,0,127}));
  connect(mul2.y, mulSum2.u)
    annotation (Line(points={{42,0},{78,0}},     color={0,0,127}));
  connect(mulSum2.y, VSumZonPri_flow)
    annotation (Line(points={{102,0},{240,0}},      color={0,0,127}));
  connect(booToRea.y, groFlo3.u) annotation (Line(points={{-18,180},{0,180},{0,-50},
          {18,-50}}, color={0,0,127}));
  connect(div1.y, mul3.u2) annotation (Line(points={{-18,-100},{60,-100},{60,-76},
          {78,-76}}, color={0,0,127}));
  connect(groFlo3.y, mul3.u1) annotation (Line(points={{42,-50},{60,-50},{60,-64},
          {78,-64}}, color={0,0,127}));
  connect(mul3.y, mulMax.u)
    annotation (Line(points={{102,-70},{138,-70}},   color={0,0,127}));
  connect(mulMax.y, uOutAirFra_max)
    annotation (Line(points={{162,-70},{240,-70}},   color={0,0,127}));
  connect(neaZer.y, max2.u2) annotation (Line(points={{-138,-170},{-120,-170},{-120,
          -146},{-102,-146}}, color={0,0,127}));
  connect(VZonPri_flow, max2.u1) annotation (Line(points={{-240,-20},{-160,-20},
          {-160,-134},{-102,-134}}, color={0,0,127}));
  connect(max2.y, div1.u2) annotation (Line(points={{-78,-140},{-60,-140},{-60,-106},
          {-42,-106}}, color={0,0,127}));
  connect(min1.y, div1.u1)
    annotation (Line(points={{-98,-94},{-42,-94}}, color={0,0,127}));
  connect(VMinOA_flow, min1.u2)
    annotation (Line(points={{-240,-100},{-122,-100}}, color={0,0,127}));
  connect(VZonPri_flow, min1.u1) annotation (Line(points={{-240,-20},{-160,-20},
          {-160,-88},{-122,-88}}, color={0,0,127}));
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
          textColor={0,0,255},
          textString="%name"),
        Text(
          extent={{10,90},{96,74}},
          textColor={0,0,0},
          textString="VSumAdjPopBreZon_flow"),
        Text(
          extent={{10,48},{96,32}},
          textColor={0,0,0},
          textString="VSumAdjAreBreZon_flow"),
        Text(
          extent={{-96,-32},{-42,-46}},
          textColor={0,0,0},
          textString="VZonPri_flow"),
        Text(
          extent={{40,-70},{98,-86}},
          textColor={0,0,0},
          textString="uOutAirFra_max"),
        Text(
          extent={{-98,8},{-20,-8}},
          textColor={0,0,0},
          textString="VAdjAreBreZon_flow"),
        Text(
          extent={{40,-30},{98,-46}},
          textColor={0,0,0},
          textString="VSumZonPri_flow"),
        Text(
          extent={{-98,48},{-20,32}},
          textColor={0,0,0},
          textString="VAdjPopBreZon_flow"),
        Text(
          extent={{-96,-74},{-42,-88}},
          textColor={0,0,0},
          textString="VMinOA_flow"),
        Text(
          extent={{-96,96},{-52,82}},
          textColor={255,127,0},
          textString="uOpeMod")}),
Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-220,-200},{220,200}})),
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
