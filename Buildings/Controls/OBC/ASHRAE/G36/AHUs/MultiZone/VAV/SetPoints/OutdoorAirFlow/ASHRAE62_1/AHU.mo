within Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.ASHRAE62_1;
block AHU "Outdoor airflow related calculations at the AHU level"

  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection minOADes
    "Type of outdoor air section"
    annotation (Dialog(group="Economizer design"));
  parameter Real VUncDesOutAir_flow(unit="m3/s")
    "Uncorrected design outdoor airflow rate, including diversity where applicable. It can be determined using the 62MZCalc spreadsheet from ASHRAE 62.1 User's Manual"
    annotation(Dialog(group="Nominal condition"));
  parameter Real VDesTotOutAir_flow(unit="m3/s")
    "Design total outdoor airflow rate. It can be determined using the 62MZCalc spreadsheet from ASHRAE 62.1 User's Manual"
    annotation(Dialog(group="Nominal condition"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VSumAdjPopBreZon_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Sum of the adjusted population component breathing zone flow rate"
    annotation (Placement(transformation(extent={{-260,70},{-220,110}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VSumAdjAreBreZon_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Sum of the adjusted area component breathing zone flow rate"
    annotation (Placement(transformation(extent={{-260,40},{-220,80}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VSumZonPri_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Sum of the zone primary airflow rates for all zones in all zone groups that are in occupied mode"
    annotation (Placement(transformation(extent={{-260,-60},{-220,-20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uOutAirFra_max(
    final min=0,
    final unit="1") "Maximum zone outdoor air fraction"
    annotation (Placement(transformation(extent={{-260,-90},{-220,-50}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VAirOut_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    if (minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersAirflow
     or minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.SingleDamper)
    "Measured outdoor air volumetric flow rate"
    annotation (Placement(transformation(extent={{-260,-130},{-220,-90}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VUncOutAir_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate") "Uncorrected minimum outdoor airflow rate"
    annotation (Placement(transformation(extent={{220,70},{260,110}}),
        iconTransformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VEffAirOut_flow_min(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Effective minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{220,10},{260,50}}),
        iconTransformation(extent={{100,10},{140,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput effOutAir_normalized(
    final unit="1")
    "Effective minimum outdoor airflow setpoint, normalized by the design total outdoor airflow rate "
    annotation (Placement(transformation(extent={{220,-80},{260,-40}}),
        iconTransformation(extent={{100,-50},{140,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput outAir_normalized(
    final unit="1")
    if (minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersAirflow
     or minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.SingleDamper)
    "Normalized outdoor airflow rate"
    annotation (Placement(transformation(extent={{220,-120},{260,-80}}),
        iconTransformation(extent={{100,-100},{140,-60}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant uncDesOutAir(
    final k=VUncDesOutAir_flow)
    "Uncorrected design outdoor airflow rate, including diversity where applicable"
    annotation (Placement(transformation(extent={{-180,0},{-160,20}})));
  Buildings.Controls.OBC.CDL.Reals.Add add2
    "Sum of the breathing zone outdoor airflow"
    annotation (Placement(transformation(extent={{-180,70},{-160,90}})));
  Buildings.Controls.OBC.CDL.Reals.Min min1
    "Uncorrected minimum outdoor airflow rate"
    annotation (Placement(transformation(extent={{-100,50},{-80,70}})));
  Buildings.Controls.OBC.CDL.Reals.Divide div1
    "First input divided by second input"
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter addPar(
    final p=1) "Add parameter"
    annotation (Placement(transformation(extent={{0,-30},{20,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sysVenEff
    "Current system ventilation efficiency"
    annotation (Placement(transformation(extent={{40,-50},{60,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Max max1
    "Avoid devide by zero"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant desOutAir(
    final k=VDesTotOutAir_flow)
    "Design total outdoor airflow rate "
    annotation (Placement(transformation(extent={{120,50},{140,70}})));
  Buildings.Controls.OBC.CDL.Reals.Divide div2 "Division"
    annotation (Placement(transformation(extent={{120,-10},{140,10}})));
  Buildings.Controls.OBC.CDL.Reals.Min min2
    "Uncorrected minimum outdoor airflow rate"
    annotation (Placement(transformation(extent={{180,20},{200,40}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gaiDivZer(
    final k=1E-3)
    "Gain, used to avoid division by zero if the flow rate is smaller than 0.1%"
    annotation (Placement(transformation(extent={{-120,-30},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Divide norVOutMin
    "Normalization for minimum outdoor air flow rate"
    annotation (Placement(transformation(extent={{160,-70},{180,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Divide norVOut
    if (minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersAirflow
     or minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.SingleDamper)
    "Normalization for outdoor air flow rate"
    annotation (Placement(transformation(extent={{160,-110},{180,-90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant neaZer(
    final k=1E-4)
    "Near zero value"
    annotation (Placement(transformation(extent={{0,-80},{20,-60}})));
  Buildings.Controls.OBC.CDL.Reals.Max max2
    "Avoid devide by zero"
    annotation (Placement(transformation(extent={{80,-50},{100,-30}})));

equation
  connect(VSumAdjPopBreZon_flow, add2.u1) annotation (Line(points={{-240,90},{-200,
          90},{-200,86},{-182,86}}, color={0,0,127}));
  connect(VSumAdjAreBreZon_flow, add2.u2) annotation (Line(points={{-240,60},{-200,
          60},{-200,74},{-182,74}}, color={0,0,127}));
  connect(add2.y, min1.u1) annotation (Line(points={{-158,80},{-120,80},{-120,66},
          {-102,66}}, color={0,0,127}));
  connect(uncDesOutAir.y, min1.u2) annotation (Line(points={{-158,10},{-120,10},
          {-120,54},{-102,54}}, color={0,0,127}));
  connect(min1.y, VUncOutAir_flow) annotation (Line(points={{-78,60},{-50,60},{-50,
          90},{240,90}}, color={0,0,127}));
  connect(min1.y, div1.u1) annotation (Line(points={{-78,60},{-50,60},{-50,-14},
          {-42,-14}}, color={0,0,127}));
  connect(div1.y, addPar.u)
    annotation (Line(points={{-18,-20},{-2,-20}}, color={0,0,127}));
  connect(uOutAirFra_max, sysVenEff.u2) annotation (Line(points={{-240,-70},{-20,
          -70},{-20,-46},{38,-46}},  color={0,0,127}));
  connect(addPar.y, sysVenEff.u1) annotation (Line(points={{22,-20},{30,-20},{30,
          -34},{38,-34}}, color={0,0,127}));
  connect(uncDesOutAir.y, gaiDivZer.u) annotation (Line(points={{-158,10},{-140,
          10},{-140,-20},{-122,-20}}, color={0,0,127}));
  connect(gaiDivZer.y, max1.u1) annotation (Line(points={{-98,-20},{-90,-20},{-90,
          -34},{-82,-34}}, color={0,0,127}));
  connect(VSumZonPri_flow, max1.u2) annotation (Line(points={{-240,-40},{-160,-40},
          {-160,-46},{-82,-46}}, color={0,0,127}));
  connect(max1.y, div1.u2) annotation (Line(points={{-58,-40},{-50,-40},{-50,-26},
          {-42,-26}}, color={0,0,127}));
  connect(min1.y, div2.u1) annotation (Line(points={{-78,60},{-50,60},{-50,6},{118,
          6}}, color={0,0,127}));
  connect(desOutAir.y, min2.u1) annotation (Line(points={{142,60},{150,60},{150,
          36},{178,36}}, color={0,0,127}));
  connect(div2.y, min2.u2) annotation (Line(points={{142,0},{160,0},{160,24},{178,
          24}}, color={0,0,127}));
  connect(min2.y, VEffAirOut_flow_min)
    annotation (Line(points={{202,30},{240,30}}, color={0,0,127}));
  connect(min2.y, norVOutMin.u1) annotation (Line(points={{202,30},{210,30},{210,
          -20},{120,-20},{120,-54},{158,-54}}, color={0,0,127}));
  connect(desOutAir.y, norVOutMin.u2) annotation (Line(points={{142,60},{150,60},
          {150,-66},{158,-66}}, color={0,0,127}));
  connect(norVOutMin.y, effOutAir_normalized)
    annotation (Line(points={{182,-60},{240,-60}}, color={0,0,127}));
  connect(norVOut.y, outAir_normalized)
    annotation (Line(points={{182,-100},{240,-100}}, color={0,0,127}));
  connect(VAirOut_flow, norVOut.u1) annotation (Line(points={{-240,-110},{-160,
          -110},{-160,-94},{158,-94}}, color={0,0,127}));
  connect(desOutAir.y, norVOut.u2) annotation (Line(points={{142,60},{150,60},{150,
          -106},{158,-106}}, color={0,0,127}));
  connect(sysVenEff.y, max2.u1) annotation (Line(points={{62,-40},{70,-40},{70,-34},
          {78,-34}}, color={0,0,127}));
  connect(neaZer.y, max2.u2) annotation (Line(points={{22,-70},{70,-70},{70,-46},
          {78,-46}}, color={0,0,127}));
  connect(max2.y, div2.u2) annotation (Line(points={{102,-40},{110,-40},{110,-6},
          {118,-6}}, color={0,0,127}));
annotation (
  defaultComponentName="ahuOutAirSet",
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
          extent={{-98,88},{-12,72}},
          textColor={0,0,0},
          textString="VSumAdjPopBreZon_flow"),
        Text(
          extent={{-96,48},{-10,32}},
          textColor={0,0,0},
          textString="VSumAdjAreBreZon_flow"),
        Text(
          extent={{-96,8},{-32,-8}},
          textColor={0,0,0},
          textString="VSumZonPri_flow"),
        Text(
          extent={{-96,-32},{-32,-48}},
          textColor={0,0,0},
          textString="uOutAirFra_max"),
        Text(
          extent={{38,84},{96,72}},
          textColor={0,0,0},
          textString="VUncOutAir_flow"),
        Text(
          extent={{26,40},{98,24}},
          textColor={0,0,0},
          textString="VEffAirOut_flow_min"),
        Text(
          extent={{18,-20},{96,-38}},
          textColor={0,0,0},
          textString="effOutAir_normalized"),
        Text(
          extent={{-96,-72},{-50,-88}},
          textColor={0,0,0},
          visible=(minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersAirflow
               or minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.SingleDamper),
          textString="VAirOut_flow"),
        Text(
          extent={{30,-70},{98,-86}},
          textColor={0,0,0},
          textString="outAir_normalized",
          visible=(minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersAirflow
               or minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.SingleDamper))}),
Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-220,-120},{220,120}})),
Documentation(info="<html>
<p>
This sequence outputs AHU level uncorrected minimum outdoor airflow rate
<code>VUncOutAir_flow</code> and effective minimum outdoor airflow rate
<code>VEffOutAir_flow</code> when complying with ASHRAE Standard 62.1 ventilation requirements.
It is implemented according to Section 5.16.3.1 of ASHRAE
Guideline G36, May 2020.
</p>
<p>
It requires following inputs which are sum or maximum of the outputs from
the zone level calculation. See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.ASHRAE62_1.SumZone\">
Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.ASHRAE62_1.SumZone</a>
for these inputs.
</p>
<ol>
<li>
Sum of the adjusted population component breathing zone flow rate for all zones that are in
all zone groups in occupied mode, <code>VSumAdjPopBreZon_flow</code>.
</li>
<li>
Sum of the adjusted area component breathing zone flow rate for all zones that are in
all zone groups in occupied mode, <code>VSumAdjAreBreZon_flow</code>.
</li>
<li>
Sum of the zone primary airflow rates for all zones in all zone groups that are
in occupied mode,<code>VSumZonPri_flow</code>.
</li>
<li>
Maximum zone outdoor air fraction for all zones in all zone groups that are
in occupied mode, <code>uOutAirFra_max</code>.
</li>
</ol>
<p>
The calculation is done using the steps below.
</p>
<ol>
<li>
See Section 3.1.4.2.a of Guideline 36 for setpoints <code>VUncDesOutAir_flow</code>
and <code>VDesTotOutAir_flow</code>.
</li>
<li>
The uncorrected outdoor airflow rate setpoint <code>VUncOutAir_flow</code> is recalculated
continuously based on the adjusted population and area component breathing zone flow rate
of the zones being served determined in accordance with Section 5.2.1.3. See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.VentilationZones.ASHRAE62_1.Setpoints\">
Buildings.Controls.OBC.ASHRAE.G36.VentilationZones.ASHRAE62_1.Setpoints</a>.
<pre>
    VUncOutAir_flow = min(VUncDesOutAir_flow, (VSumAdjPopBreZon_flow + VSumAdjAreBreZon_flow))
</pre>
</li>
<li>
Calculate the current system ventilation efficiency as
<pre>
    sysVenEff = 1 + (VUncOutAir_flow/VSumZonPri_flow) - uOutAirFra_max
</pre> 
</li>
<li>
Calculate the effective minimum outdoor air setpoint <code>VEffOutAir_flow</code> as
the uncorrected outdoor air intake divided by the system ventilation efficiency,
but no larger than the design total outdoor airflow rate <code>VDesTotOutAir_flow</code>:
<pre>
    VEffOutAir_flow = min(VUncOutAir_flow/sysVenEff, VDesTotOutAir_flow)
</pre>
</li>
</ol>
</html>", revisions="<html>
<ul>
<li>
April 6, 2024, by Michael Wetter:<br/>
Corrected wrong annotation.
</li>
<li>
March 12, 2022, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end AHU;
