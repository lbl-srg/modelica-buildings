within Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.Title24;
block AHU "AHU level setpoint calculation"

  parameter Boolean have_CO2Sen
    "True: there are zones have CO2 sensor";
  parameter Real VAbsOutAir_flow(unit="m3/s")
    "Design outdoor air rate when all zones with CO2 sensors or occupancy sensors are unpopulated"
    annotation(Dialog(group="Nominal condition"));
  parameter Real VDesOutAir_flow(unit="m3/s")
    "Design minimum outdoor airflow with areas served by the system are occupied at their design population, including diversity where applicable"
    annotation(Dialog(group="Nominal condition"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VSumZonAbsMin_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Sum of the zone absolute minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{-140,80},{-100,120}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VSumZonDesMin_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Sum of the zone design minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uMaxCO2(
    final unit="1") if have_CO2Sen
    "Maximum Zone CO2 control loop"
    annotation (Placement(transformation(extent={{-140,-130},{-100,-90}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VEffAbsOutAir_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Effective outdoor air absolute minimum setpoint"
    annotation (Placement(transformation(extent={{100,100},{140,140}}),
        iconTransformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput effAbsOutAir_normalized(
    final unit="1")
    "Effective minimum outdoor airflow setpoint, normalized by the absolute outdoor air rate "
    annotation (Placement(transformation(extent={{100,60},{140,100}}),
        iconTransformation(extent={{100,20},{140,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VEffDesOutAir_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Effective outdoor air design minimum setpoint"
    annotation (Placement(transformation(extent={{100,0},{140,40}}),
        iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput effDesOutAir_normalized(
    final unit="1")
    "Effective minimum outdoor airflow setpoint, normalized by the design outdoor air rate "
    annotation (Placement(transformation(extent={{100,-40},{140,0}}),
        iconTransformation(extent={{100,-60},{140,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput effOutAir_normalized(
    final unit="1")
    "Effective minimum outdoor airflow setpoint, normalized by the design total outdoor air rate "
    annotation (Placement(transformation(extent={{100,-160},{140,-120}}),
        iconTransformation(extent={{100,-100},{140,-60}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant absOutAir(
    final k=VAbsOutAir_flow)
    "Design outdoor air rate when all zones with CO2 sensors or occupancy sensors are unpopulated"
    annotation (Placement(transformation(extent={{-80,130},{-60,150}})));
  Buildings.Controls.OBC.CDL.Continuous.Min min1
    "Effective outdoor air absolute minimum setpoint"
    annotation (Placement(transformation(extent={{0,110},{20,130}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant desOutAir(
    final k=VDesOutAir_flow)
    "Design minimum outdoor airflow with areas served by the system are occupied at their design population, including diversity where applicable"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Min min2 "Effective outdoor air design minimum setpoint"
    annotation (Placement(transformation(extent={{0,10},{20,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Divide norVOutMin
    "Normalization for minimum outdoor air flow rate"
    annotation (Placement(transformation(extent={{0,-30},{20,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Divide norVOutMin1
    "Normalization for minimum outdoor air flow rate"
    annotation (Placement(transformation(extent={{0,70},{20,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(
    final k=0.5) if have_CO2Set
    "Constant value"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con1(
    final k=1) if have_CO2Set
    "Constant value"
    annotation (Placement(transformation(extent={{-80,-150},{-60,-130}})));
  Buildings.Controls.OBC.CDL.Continuous.Line effOutAir(
    final limitBelow=false,
    final limitAbove=true) if have_CO2Set
    "Normalized effective outdoor air setpoint"
    annotation (Placement(transformation(extent={{0,-120},{20,-100}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai(
    final k=1) if not have_CO2Sen
    "When there is no zone has CO2 sensor, design setpoint will be applied"
    annotation (Placement(transformation(extent={{40,-90},{60,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Divide norVOutMin2 if have_CO2Set
    "Normalization for minimum outdoor air flow rate"
    annotation (Placement(transformation(extent={{60,-150},{80,-130}})));
equation
  connect(absOutAir.y, min1.u1) annotation (Line(points={{-58,140},{-20,140},{-20,
          126},{-2,126}}, color={0,0,127}));
  connect(min1.y, VEffAbsOutAir_flow)
    annotation (Line(points={{22,120},{120,120}},color={0,0,127}));
  connect(desOutAir.y, min2.u1) annotation (Line(points={{-58,40},{-20,40},{-20,
          26},{-2,26}},    color={0,0,127}));
  connect(min2.y, VEffDesOutAir_flow)
    annotation (Line(points={{22,20},{120,20}},    color={0,0,127}));
  connect(VSumZonDesMin_flow, min2.u2) annotation (Line(points={{-120,0},{-40,0},
          {-40,14},{-2,14}},        color={0,0,127}));
  connect(VSumZonAbsMin_flow, min1.u2) annotation (Line(points={{-120,100},{-40,
          100},{-40,114},{-2,114}}, color={0,0,127}));
  connect(desOutAir.y, norVOutMin.u2) annotation (Line(points={{-58,40},{-20,40},
          {-20,-26},{-2,-26}}, color={0,0,127}));
  connect(min1.y, norVOutMin1.u1) annotation (Line(points={{22,120},{50,120},{50,
          100},{-10,100},{-10,86},{-2,86}}, color={0,0,127}));
  connect(min2.y, norVOutMin.u1) annotation (Line(points={{22,20},{40,20},{40,0},
          {-10,0},{-10,-14},{-2,-14}},      color={0,0,127}));
  connect(norVOutMin1.y, effAbsOutAir_normalized)
    annotation (Line(points={{22,80},{120,80}}, color={0,0,127}));
  connect(norVOutMin.y, effDesOutAir_normalized) annotation (Line(points={{22,-20},
          {120,-20}}, color={0,0,127}));
  connect(uMaxCO2, effOutAir.u)
    annotation (Line(points={{-120,-110},{-2,-110}}, color={0,0,127}));
  connect(con.y, effOutAir.x1) annotation (Line(points={{-58,-80},{-40,-80},{-40,
          -102},{-2,-102}}, color={0,0,127}));
  connect(con1.y, effOutAir.x2) annotation (Line(points={{-58,-140},{-40,-140},{
          -40,-114},{-2,-114}}, color={0,0,127}));
  connect(gai.y, effOutAir_normalized) annotation (Line(points={{62,-80},{90,-80},
          {90,-140},{120,-140}}, color={0,0,127}));
  connect(absOutAir.y, norVOutMin1.u2) annotation (Line(points={{-58,140},{-20,140},
          {-20,74},{-2,74}}, color={0,0,127}));
  connect(min2.y, effOutAir.f2) annotation (Line(points={{22,20},{40,20},{40,-40},
          {-30,-40},{-30,-118},{-2,-118}}, color={0,0,127}));
  connect(min1.y, effOutAir.f1) annotation (Line(points={{22,120},{50,120},{50,-50},
          {-10,-50},{-10,-106},{-2,-106}}, color={0,0,127}));
  connect(norVOutMin.y, gai.u) annotation (Line(points={{22,-20},{60,-20},{60,-60},
          {30,-60},{30,-80},{38,-80}}, color={0,0,127}));
  connect(effOutAir.y, norVOutMin2.u1) annotation (Line(points={{22,-110},{40,-110},
          {40,-134},{58,-134}}, color={0,0,127}));
  connect(desOutAir.y, norVOutMin2.u2) annotation (Line(points={{-58,40},{-20,40},
          {-20,-146},{58,-146}}, color={0,0,127}));
  connect(norVOutMin2.y, effOutAir_normalized)
    annotation (Line(points={{82,-140},{120,-140}}, color={0,0,127}));
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
          lineColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-98,48},{-26,32}},
          lineColor={0,0,0},
          textString="VSumZonAbsMin_flow"),
        Text(
          extent={{-96,-32},{-26,-48}},
          lineColor={0,0,0},
          textString="VSumZonDesMin_flow"),
        Text(
          extent={{26,88},{98,72}},
          lineColor={0,0,0},
          textString="VEffAbsOutAir_flow"),
        Text(
          extent={{26,10},{98,-6}},
          lineColor={0,0,0},
          textString="VEffDesOutAir_flow"),
        Text(
          extent={{6,52},{96,30}},
          lineColor={0,0,0},
          textString="effAbsOutAir_normalized"),
        Text(
          extent={{6,-28},{96,-50}},
          lineColor={0,0,0},
          textString="effDesOutAir_normalized"),
        Text(
          extent={{-96,-74},{-66,-86}},
          lineColor={0,0,0},
          textString="uMaxCO2",
          visible=have_CO2Sen),
        Text(
          extent={{18,-68},{96,-90}},
          lineColor={0,0,0},
          textString="effOutAir_normalized")}),
Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-160},{100,160}})),
Documentation(info="<html>
<p>
This sequence outputs AHU level effective outdoor air absolute minimum and design
minimum setpoints <code>VEffAbsOutAir_flow</code>, <code>VEffDesOutAir_flow</code> and
the nomalized minimum setpoint <code>effOutAir_normalized</code>
when complying with California Title 24 ventilation requirements.
It is implemented according to Section 5.16.3.2 of ASHRAE
Guideline G36, May 2020.
</p>
<p>
It calculates as below:
</p>
<ol>
<li>
See the sum of zone absolute and design minimum outdoor airflow setpoint
<code>VSumZonAbsMin_flow</code> and <code>VSumZonDesMin_flow</code> from
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.Title24.SumZone\">
Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.Title24.SumZone</a> for the detailed
description.
</li>
<li>
Effective outdoor air absolute minimum and design minimum setpoints
(<code>VEffAbsOutAir_flow</code> and <code>VEffDesOutAir_flow</code>) are recalculated
continuously based on the mode of the zones being served.
<ul>
<li>
Effective outdoor air absolute minimum setpoint <code>VEffAbsOutAir_flow</code> is
the sum of <code>VZonAbsMin_flow</code> for all zones in all zone groups that
are in occupied mode but shall be no larger than the absolute minimum outdoor airflow
<code>VAbsOutAir_flow</code>.
</li>
<li>
Effective outdoor air design minimum setpoint <code>VEffDesOutAir_flow</code> is
the sum of <code>VZonDesMin_flow</code> for all zones in all zone groups that
are in occupied mode but shall be no larger than the absolute minimum outdoor airflow
<code>VDesOutAir_flow</code>.
</li>
</ul>
</li>
<li>
According to section 5.16.4, 5.16.5 and 5.16.6, the effective minimum outdoor airflow
setpoint should be reset based on the highest zone CO2 control- loop signal from
<code>VEffAbsOutAir_flow</code> at 50% signal to <code>VEffDesOutAir_flow</code>
at 100% signal. When there is no CO2 sensor in any zone, the effective minimum
outdoor airflow setpoint should be equal to the <code>VEffDesOutAir_flow</code>.
</li>
</ol>
</html>", revisions="<html>
<ul>
<li>
March 12, 2022, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end AHU;
