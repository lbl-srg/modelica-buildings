within Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow;
block Zone
  "Output outdoor airflow related calculations at the zone level"

  parameter Real VOutPerAre_flow(
    final unit = "m3/(s.m2)")=3e-4
    "Outdoor air rate per unit area"
    annotation(Dialog(group="Nominal condition"));

  parameter Real VOutPerPer_flow(unit="m3/s")=2.5e-3
    "Outdoor air rate per person"
    annotation(Dialog(group="Nominal condition"));

  parameter Real AFlo(unit="m2")
    "Floor area of each zone"
    annotation(Dialog(group="Nominal condition"));

  parameter Boolean have_occSen=true
    "Set to true if zones have occupancy sensor";

  parameter Boolean have_winSen=true
    "Set to true if zones have window status sensor";

  parameter Real occDen(final unit = "1/m2") = 0.05
    "Default number of person in unit area";

  parameter Real zonDisEffHea(final unit = "1") = 0.8
    "Zone air distribution effectiveness during heating";

  parameter Real zonDisEffCoo(final unit = "1") = 1.0
    "Zone air distribution effectiveness during cooling";

  parameter Real desZonDisEff(final unit = "1") = 1.0
    "Design zone air distribution effectiveness"
    annotation(Dialog(group="Nominal condition"));

  parameter Real desZonPop(
    final min=occDen*AFlo,
    final unit = "1")
    "Design zone population during peak occupancy"
    annotation(Dialog(group="Nominal condition"));

  parameter Real uLow(
    final unit="K",
    final displayUnit="K",
    final quantity="ThermodynamicTemperature") = -0.5
    "If zone space temperature minus supply air temperature is less than uLow,
     then it should use heating supply air distribution effectiveness"
    annotation (Dialog(tab="Advanced"));

  parameter Real uHig(
    final unit="K",
    final displayUnit="K",
    final quantity="ThermodynamicTemperature") = 0.5
    "If zone space temperature minus supply air temperature is more than uHig,
     then it should use cooling supply air distribution effectiveness"
    annotation (Dialog(tab="Advanced"));

  parameter Real minZonPriFlo(unit="m3/s")
    "Minimum expected zone primary flow rate"
    annotation(Dialog(group="Nominal condition"));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput nOcc if have_occSen
    "Number of occupants"
    annotation (Placement(transformation(extent={{-200,20},{-160,60}}),
        iconTransformation(extent={{-140,70},{-100,110}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWin if have_winSen
    "Window status, true if open, false if closed"
    annotation (Placement(transformation(extent={{-200,-70},{-160,-30}}),
      iconTransformation(extent={{-140,40},{-100,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uReqOutAir
    "True if the AHU supply fan is on and the zone is in occupied mode"
    annotation (Placement(transformation(extent={{-200,-110},{-160,-70}}),
        iconTransformation(extent={{-140,10},{-100,50}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature") "Measured zone air temperature"
    annotation (Placement(transformation(extent={{-200,-150},{-160,-110}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TDis(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature") "Measured discharge air temperature"
    annotation (Placement(transformation(extent={{-200,-190},{-160,-150}}),
      iconTransformation(extent={{-140,-50},{-100,-10}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VDis_flow(
    final unit = "m3/s",
    final quantity = "VolumeFlowRate")
    "Primary airflow rate to the ventilation zone from the air handler, including outdoor air and recirculated air"
    annotation (Placement(transformation(extent={{-200,-230},{-160,-190}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VUncOut_flow_nominal(
    final min=0,
    final unit = "m3/s",
    final quantity = "VolumeFlowRate")
    "AHU level design uncorrected minimum outdoor airflow rate"
    annotation (Placement(transformation(extent={{-200,-270},{-160,-230}}),
      iconTransformation(extent={{-140,-110},{-100,-70}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yDesZonPeaOcc(
    final min=0,
    final unit="1")
    "Design zone peak occupancy"
    annotation (Placement(transformation(extent={{180,220},{220,260}}),
      iconTransformation(extent={{100,70},{140,110}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VDesPopBreZon_flow(
    final min=0,
    final unit = "m3/s",
    final quantity = "VolumeFlowRate")
    "Population component breathing zone design outdoor airflow"
    annotation (Placement(transformation(extent={{180,180},{220,220}}),
      iconTransformation(extent={{100,40},{140,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VDesAreBreZon_flow(
    final min=0,
    final unit = "m3/s",
    final quantity = "VolumeFlowRate")
    "Area component breathing zone outdoor airflow"
    annotation (Placement(transformation(extent={{180,120},{220,160}}),
      iconTransformation(extent={{100,10},{140,50}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yDesPriOutAirFra(
    final min=0,
    final unit="1")
    "Design zone primary outdoor air fraction"
    annotation (Placement(transformation(extent={{180,50},{220,90}}),
      iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VUncOutAir_flow(
    final min=0,
    final unit = "m3/s",
    final quantity = "VolumeFlowRate")
    "Uncorrected outdoor airflow rate"
    annotation (Placement(transformation(extent={{180,-110},{220,-70}}),
      iconTransformation(extent={{100,-50},{140,-10}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yPriOutAirFra(
    final min=0,
    final unit="1") "Primary outdoor air fraction"
    annotation (Placement(transformation(extent={{180,-180},{220,-140}}),
      iconTransformation(extent={{100,-80},{140,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VPriAir_flow(
    final min=0,
    final unit = "m3/s",
    final quantity = "VolumeFlowRate")
    "Primary airflow rate"
    annotation (Placement(transformation(extent={{180,-240},{220,-200}}),
      iconTransformation(extent={{100,-110},{140,-70}})));

protected
  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea if have_occSen
    "Type converter"
    annotation (Placement(transformation(extent={{-140,30},{-120,50}})));

  Buildings.Controls.OBC.CDL.Continuous.Add breZon "Breathing zone airflow"
    annotation (Placement(transformation(extent={{20,40},{40,60}})));

  Buildings.Controls.OBC.CDL.Continuous.Gain gai(
    final k = VOutPerPer_flow) if have_occSen
    "Outdoor air per person"
    annotation (Placement(transformation(extent={{-100,30},{-80,50}})));

  Buildings.Controls.OBC.CDL.Logical.Switch swi
    "If there is occupancy sensor, then using the real time occupancy; otherwise, using the default occupancy"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));

  Buildings.Controls.OBC.CDL.Logical.Switch swi1
    "Switch between cooling or heating distribution effectiveness"
    annotation (Placement(transformation(extent={{-20,-160},{0,-140}})));

  Buildings.Controls.OBC.CDL.Continuous.Division zonOutAirRate
    "Required zone outdoor airflow rate"
    annotation (Placement(transformation(extent={{80,10},{100,30}})));

  Buildings.Controls.OBC.CDL.Continuous.Division priOutAirFra
    "Primary outdoor air fraction"
    annotation (Placement(transformation(extent={{120,-170},{140,-150}})));

  Buildings.Controls.OBC.CDL.Continuous.Add desBreZon "Breathing zone design airflow"
    annotation (Placement(transformation(extent={{20,190},{40,210}})));

  Buildings.Controls.OBC.CDL.Continuous.Division desZonOutAirRate
    "Required design zone outdoor airflow rate"
    annotation (Placement(transformation(extent={{80,170},{100,190}})));

  Buildings.Controls.OBC.CDL.Continuous.Division desZonPriOutAirRate
    "Design zone primary outdoor air fraction"
    annotation (Placement(transformation(extent={{140,60},{160,80}})));

  Buildings.Controls.OBC.CDL.Continuous.Add add2(
    final k2=-1)
    "Zone space temperature minus supply air temperature"
    annotation (Placement(transformation(extent={{-120,-160},{-100,-140}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys(
    final uLow=uLow,
    final uHigh=uHig,
    final pre_y_start=true)
    "Check if cooling or heating air distribution effectiveness should be applied, with 1 degC deadband"
    annotation (Placement(transformation(extent={{-80,-160},{-60,-140}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant occSen(
    final k=have_occSen)
    "Boolean constant to indicate if there is occupancy sensor"
    annotation (Placement(transformation(extent={{-140,-10},{-120,10}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant desDisEff(
    final k = desZonDisEff)
    "Design zone air distribution effectiveness"
    annotation (Placement(transformation(extent={{20,150},{40,170}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minZonFlo(
    final k = minZonPriFlo)
    "Minimum expected zone primary flow rate"
    annotation (Placement(transformation(extent={{80,60},{100,80}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant disEffHea(
    final k = zonDisEffHea)
    "Zone distribution effectiveness for heating"
    annotation (Placement(transformation(extent={{-80,-200},{-60,-180}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant disEffCoo(
    final k = zonDisEffCoo)
    "Zone distribution effectiveness fo cooling"
    annotation (Placement(transformation(extent={{-80,-120},{-60,-100}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zerOutAir(
    final k=0)
    "Zero required outdoor airflow rate when window is open or when zone is not in occupied mode"
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zerOcc(
    final k=0) if not have_occSen
    "Zero occupant when there is no occupancy sensor"
    annotation (Placement(transformation(extent={{-140,70},{-120,90}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant cloWin(
    final k=false) if not have_winSen
    "Closed window status when there is no window sensor"
    annotation (Placement(transformation(extent={{-100,-80},{-80,-60}})));

  Buildings.Controls.OBC.CDL.Logical.Switch swi4
    "If window is open, the required outdoor airflow rate should be zero"
    annotation (Placement(transformation(extent={{60,-60},{80,-40}})));

  Buildings.Controls.OBC.CDL.Logical.Switch swi5
    "If supply fan is off or it is not in occupied mode, then outdoor airflow rate should be zero"
    annotation (Placement(transformation(extent={{120,-100},{140,-80}})));

  Buildings.Controls.OBC.CDL.Continuous.Max max
    "If supply fan is off, giving a small primary airflow rate to avoid division by zero"
    annotation (Placement(transformation(extent={{-20,-230},{0,-210}})));

  Buildings.Controls.OBC.CDL.Continuous.Product breZonAre
    "Area component of the breathing zone outdoor airflow"
    annotation (Placement(transformation(extent={{-80,130},{-60,150}})));

  Buildings.Controls.OBC.CDL.Continuous.Product pro
    "Product of flow rate per person and floor area"
    annotation (Placement(transformation(extent={{-80,170},{-60,190}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant floPerAre(
    final k=VOutPerAre_flow)
    "Flow rate per unit area"
    annotation (Placement(transformation(extent={{-140,110},{-120,130}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant floAre(
    final k=AFlo) "Floor area"
    annotation (Placement(transformation(extent={{-140,150},{-120,170}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant floPerPer(
    final k=VOutPerPer_flow) "Flow rate per person"
    annotation (Placement(transformation(extent={{-140,190},{-120,210}})));

  Buildings.Controls.OBC.CDL.Continuous.Gain breZonPop(
    final k=occDen)
    "Default population component of the breathing zone outdoor airflow"
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));

  Buildings.Controls.OBC.CDL.Continuous.Gain gaiDivZer(
    final k=1E-3)
    "Gain, used to avoid division by zero if the flow rate is smaller than 0.1%"
    annotation (Placement(transformation(extent={{-80,-250},{-60,-230}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant desPeaOcc(
    final k=desZonPop)
    "Design zone population during peak occupancy"
    annotation (Placement(transformation(extent={{-140,230},{-120,250}})));

  Buildings.Controls.OBC.CDL.Continuous.Product desBreZonPer
    "Population component of the breathing zone design outdoor airflow"
    annotation (Placement(transformation(extent={{-80,210},{-60,230}})));

equation
  connect(gai.y, swi.u1)
    annotation (Line(points={{-78,40},{-60,40},{-60,8},{-42,8}},
      color={0,0,127}));
 connect(swi.y, breZon.u2)
    annotation (Line(points={{-18,0},{0,0},{0,44},{18,44}},
      color={0,0,127}));
  connect(disEffCoo.y, swi1.u1)
    annotation (Line(points={{-58,-110},{-40,-110},{-40,-142},{-22,-142}},
      color={0,0,127}));
  connect(disEffHea.y, swi1.u3)
    annotation (Line(points={{-58,-190},{-40,-190},{-40,-158},{-22,-158}},
      color={0,0,127}));
  connect(breZon.y, zonOutAirRate.u1)
    annotation (Line(points={{42,50},{60,50},{60,26},{78,26}},
      color={0,0,127}));
  connect(swi1.y, zonOutAirRate.u2)
    annotation (Line(points={{2,-150},{20,-150},{20,14},{78,14}},
      color={0,0,127}));
  connect(desDisEff.y, desZonOutAirRate.u2)
    annotation (Line(points={{42,160},{60,160},{60,174},{78,174}},
      color={0,0,127}));
  connect(desBreZon.y, desZonOutAirRate.u1)
    annotation (Line(points={{42,200},{60,200},{60,186},{78,186}},
      color={0,0,127}));
  connect(desZonOutAirRate.y, desZonPriOutAirRate.u1)
    annotation (Line(points={{102,180},{120,180},{120,76},{138,76}},
      color={0,0,127}));
  connect(minZonFlo.y, desZonPriOutAirRate.u2)
    annotation (Line(points={{102,70},{120,70},{120,64},{138,64}},
      color={0,0,127}));
  connect(swi.u2, occSen.y)
    annotation (Line(points={{-42,0},{-118,0}},
      color={255,0,255}));
  connect(TDis, add2.u2)
    annotation (Line(points={{-180,-170},{-140,-170},{-140,-156},{-122,-156}},
      color={0,0,127}));
  connect(TZon, add2.u1)
    annotation (Line(points={{-180,-130},{-140,-130},{-140,-144},{-122,-144}},
      color={0,0,127}));
  connect(add2.y, hys.u)
    annotation (Line(points={{-98,-150},{-82,-150}},
      color={0,0,127}));
  connect(hys.y, swi1.u2)
    annotation (Line(points={{-58,-150},{-22,-150}}, color={255,0,255}));
  connect(zerOcc.y, swi.u1)
    annotation (Line(points={{-118,80},{-60,80},{-60,8},{-42,8}},
      color={0,0,127}));
  connect(intToRea.y, gai.u)
    annotation (Line(points={{-118,40},{-102,40}}, color={0,0,127}));
  connect(nOcc, intToRea.u)
    annotation (Line(points={{-180,40},{-142,40}}, color={255,127,0}));
  connect(desZonPriOutAirRate.y, yDesPriOutAirFra)
    annotation (Line(points={{162,70},{200,70}}, color={0,0,127}));
  connect(priOutAirFra.y, yPriOutAirFra)
    annotation (Line(points={{142,-160},{200,-160}}, color={0,0,127}));
  connect(zerOutAir.y, swi4.u1) annotation (Line(points={{-18,-70},{0,-70},{0,-42},
          {58,-42}}, color={0,0,127}));
  connect(zonOutAirRate.y, swi4.u3) annotation (Line(points={{102,20},{120,20},{
          120,-20},{40,-20},{40,-58},{58,-58}},  color={0,0,127}));
  connect(swi5.y, VUncOutAir_flow)
    annotation (Line(points={{142,-90},{200,-90}}, color={0,0,127}));
  connect(swi5.y, priOutAirFra.u1) annotation (Line(points={{142,-90},{160,-90},
          {160,-120},{100,-120},{100,-154},{118,-154}}, color={0,0,127}));
  connect(uWin, swi4.u2) annotation (Line(points={{-180,-50},{58,-50}},
          color={255,0,255}));
  connect(cloWin.y, swi4.u2) annotation (Line(points={{-78,-70},{-60,-70},{-60,-50},
          {58,-50}},color={255,0,255}));
  connect(uReqOutAir, swi5.u2)
    annotation (Line(points={{-180,-90},{118,-90}}, color={255,0,255}));
  connect(VDis_flow, max.u1) annotation (Line(points={{-180,-210},{-40,-210},{-40,
          -214},{-22,-214}}, color={0,0,127}));
  connect(max.y, priOutAirFra.u2) annotation (Line(points={{2,-220},{100,-220},{
          100,-166},{118,-166}}, color={0,0,127}));
  connect(max.y, VPriAir_flow)
    annotation (Line(points={{2,-220},{200,-220}}, color={0,0,127}));
  connect(floAre.y, breZonAre.u1) annotation (Line(points={{-118,160},{-100,160},
          {-100,146},{-82,146}}, color={0,0,127}));
  connect(floPerAre.y, breZonAre.u2) annotation (Line(points={{-118,120},{-100,120},
          {-100,134},{-82,134}},color={0,0,127}));
  connect(breZonAre.y, desBreZon.u2) annotation (Line(points={{-58,140},{0,140},
          {0,194},{18,194}}, color={0,0,127}));
  connect(breZonAre.y, breZon.u1) annotation (Line(points={{-58,140},{0,140},{0,
          56},{18,56}},   color={0,0,127}));
  connect(floPerPer.y, pro.u1) annotation (Line(points={{-118,200},{-100,200},{-100,
          186},{-82,186}}, color={0,0,127}));
  connect(floAre.y, pro.u2) annotation (Line(points={{-118,160},{-100,160},{-100,
          174},{-82,174}}, color={0,0,127}));
  connect(breZonPop.y, swi.u3) annotation (Line(points={{-78,-30},{-60,-30},{-60,
          -8},{-42,-8}}, color={0,0,127}));
  connect(pro.y, breZonPop.u) annotation (Line(points={{-58,180},{-40,180},{-40,
          100},{-110,100},{-110,-30},{-102,-30}}, color={0,0,127}));
  connect(VUncOut_flow_nominal, gaiDivZer.u)
    annotation (Line(points={{-180,-250},{-100,-250},{-100,-240},{-82,-240}},
      color={0,0,127}));
  connect(gaiDivZer.y, max.u2)
    annotation (Line(points={{-58,-240},{-40,-240},{-40,-226},{-22,-226}},
      color={0,0,127}));
  connect(floPerPer.y, desBreZonPer.u2) annotation (Line(points={{-118,200},{-100,
          200},{-100,214},{-82,214}}, color={0,0,127}));
  connect(desPeaOcc.y, desBreZonPer.u1) annotation (Line(points={{-118,240},{-100,
          240},{-100,226},{-82,226}}, color={0,0,127}));
  connect(desBreZonPer.y, desBreZon.u1) annotation (Line(points={{-58,220},{0,220},
          {0,206},{18,206}}, color={0,0,127}));
  connect(desPeaOcc.y, yDesZonPeaOcc)
    annotation (Line(points={{-118,240},{200,240}}, color={0,0,127}));
  connect(desBreZonPer.y, VDesPopBreZon_flow) annotation (Line(points={{-58,220},
          {120,220},{120,200},{200,200}}, color={0,0,127}));
  connect(breZonAre.y, VDesAreBreZon_flow)
    annotation (Line(points={{-58,140},{200,140}}, color={0,0,127}));
  connect(zerOutAir.y, swi5.u3) annotation (Line(points={{-18,-70},{0,-70},{0,-98},
          {118,-98}}, color={0,0,127}));
  connect(swi4.y, swi5.u1) annotation (Line(points={{82,-50},{100,-50},{100,-82},
          {118,-82}}, color={0,0,127}));

annotation (
  defaultComponentName="zonOutAirSet",
  Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
       graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-98,-82},{-14,-98}},
          lineColor={0,0,0},
          textString="VUncOut_flow_nominal"),
        Text(
          extent={{-100,158},{100,118}},
          lineColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-100,-54},{-58,-64}},
          lineColor={0,0,0},
          textString="VDis_flow"),
        Text(
          extent={{-100,-24},{-72,-36}},
          lineColor={0,0,0},
          textString="TDis"),
        Text(
          extent={{-100,8},{-70,-4}},
          lineColor={0,0,0},
          textString="TZon"),
        Text(
          extent={{-100,36},{-40,24}},
          lineColor={255,0,255},
          textString="uReqOutAir"),
        Text(
          visible=have_winSen,
          extent={{-100,68},{-72,56}},
          lineColor={255,0,255},
          textString="uWin"),
        Text(
          visible=have_occSen,
          extent={{-100,98},{-70,86}},
          lineColor={255,127,0},
          textString="nOcc"),
        Text(
          extent={{28,98},{98,82}},
          lineColor={0,0,0},
          textString="yDesZonPeaOcc"),
        Text(
          extent={{12,70},{96,54}},
          lineColor={0,0,0},
          textString="VDesPopBreZon_flow"),
        Text(
          extent={{14,38},{98,22}},
          lineColor={0,0,0},
          textString="VDesAreBreZon_flow"),
        Text(
          extent={{28,10},{98,-8}},
          lineColor={0,0,0},
          textString="yDesPriOutAirFra"),
        Text(
          extent={{28,-20},{98,-36}},
          lineColor={0,0,0},
          textString="VUncOutAir_flow"),
        Text(
          extent={{40,-50},{96,-66}},
          lineColor={0,0,0},
          textString="yPriOutAirFra"),
        Text(
          extent={{48,-82},{98,-96}},
          lineColor={0,0,0},
          textString="VPriAir_flow")}),
Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-160,-260},{180,260}})),
Documentation(info="<html>
<p>
This sequence conducts calculations of the minimum outdoor airflow rate at the zone
level. It gives outputs below.
</p>
<ol>
<li>
The population component of the breathing zone outdoor airflow, <code>VDesPopBreZon_flow</code>.
</li>
<li>
The area component of the breathing zone outdoor airflow, <code>VDesAreBreZon_flow</code>.
</li>
<li>
Design zone primary outdoor air fraction, <code>yDesPriOutAirFra</code>.
</li>
<li>
Uncorrected outdoor airflow rate, <code>VUncOutAir_flow</code>. This flow rate
is calculated based on: occupancy (if there is occupancy sensor) or design
occupancy (if there is no occupancy sensor), and air distribution effectiveness
(warm or cool air).
</li>
<li>
Primary outdoor air fraction, <code>yPriOutAirFra</code>.
</li>
<li>
Primary airflow rate, <code>VPriAir_flow</code>.
</li>
</ol>
<p>
The calculation is done using the steps below.
</p>
<ol>
<li>
<p>
Compute the required breathing zone outdoor airflow using the following components.
</p>
<ul>
<li>The area component of the breathing zone outdoor airflow, <code>VDesAreBreZon_flow</code>.
</li>
<li>The population component of the breathing zone outdoor airflow, <code>VDesPopBreZon_flow</code>.
</li>
</ul>
<p>
The number of occupant in the zone can be retrieved directly from occupancy sensor
(<code>nOcc</code>) if the sensor exists, or using the default occupant density
(<code>occDen</code>) and multiplying it with zone area (<code>AFlo</code>).
The occupant density can be found from Table 6.2.2.1 in ASHRAE Standard
62.1-2013. For design purpose, use the design zone population (<code>desZonPop</code>)
to determine the minimum requirement at the ventilation-design condition.
</p>
</li>
<li>
<p>
Compute the zone air-distribution effectiveness.
Table 6.2.2.2 in ASHRAE 62.1-2013 lists some typical values for setting the
effectiveness. Depending on difference between zone space temperature
<code>TZon</code> and discharge air temperature (after the reheat coil) <code>TDis</code>, Warm-air
effectiveness <code>zonDisEffHea</code> or Cool-air effectiveness
<code>zonDisEffCoo</code> should be applied.
</p>
</li>
<li>
<p>
Compute the required zone outdoor airflow <code>zonOutAirRate</code>.
If the zone is in any mode other than occupied mode (<code>uReqOutAir=false</code>)
or if the zone has window switches and the window is open (<code>uWin=true</code>),
set <code>zonOutAirRate = 0</code>.
Otherwise, the required zone outdoor airflow <code>zonOutAirRate</code>
shall be calculated as follows:
</p>
<ul>
<li>
If the zone is populated (<code>nOcc</code> &gt; 0), or if there is no occupancy sensor
(<code>have_occSen = false</code>):
<ul>
<li>
If the discharge air temperature at the terminal unit is less than or equal to
the zone space temperature, set <code>zonOutAirRate = (breZonAre+breZonPop)/disEffCoo</code>.
</li>
<li>
If the discharge air temperature at the terminal unit is greater than zone space
temperature, set <code>zonOutAirRate = (breZonAre+breZonPop)/disEffHea</code>.
</li>
</ul>
</li>
<li>
If the zone has an occupancy sensor and is unpopulated (<code>nOcc=0</code>):
<ul>
<li>
If the discharge air temperature at the terminal unit is less than or equal to
the zone space temperature, set <code>zonOutAirRate = breZonAre/disEffCoo</code>.
</li>
<li>
If the discharge air temperature at the terminal unit is greater than zone
space temperature, set <code>zonOutAirRate = breZonAre/disEffHea</code>.
</li>
</ul>
</li>
</ul>
</li>
<li>
<p>
Compute the outdoor air fraction for the zone <code>yPriOutAirFra</code> as follows.
Set the zone outdoor air fraction to
</p>
<pre>
    yPriOutAirFra = zonOutAirRate/VPriAir_flow
</pre>
<p>
where, <code>VPriAir_flow</code> is the maximum between the measured discharge air
flow rate from the zone VAV box <code>VDis_flow</code> and 0.1% of AHU level
design uncorrected minimum outdoor airflow rate <code>VUncOut_flow_nominal</code>.
For design purpose, the design zone outdoor air fraction <code>yDesPriOutAirFra</code>
is
</p>
<pre>
    yDesPriOutAirFra = desZonOutAirRate/minZonPriFlo
</pre>
<p>
where <code>minZonPriFlo</code> is the minimum expected zone primary flow rate and
<code>desZonOutAirRate</code> is the required design zone outdoor airflow rate.
</p>
</li>
</ol>
<h4>References</h4>
<p>
ANSI/ASHRAE Standard 62.1-2013,
<i>Ventilation for Acceptable Indoor Air Quality.</i>
</p>
<p>
Stanke, D., 2010. <i>Dynamic Reset for Multiple-Zone Systems.</i> ASHRAE Journal, March
2010.
</p>
</html>", revisions="<html>
<ul>
<li>
March 13, 2020, by Jianjun Hu:<br/>
Separated from original sequence of finding the system minimum outdoor air setpoint.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1829\">#1829</a>.
</li>
<li>
February 27, 2020, by Jianjun Hu:<br/>
Applied hysteresis for checking ventilation efficiency.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1787\">#1787</a>.
</li>
<li>
January 30, 2020, by Michael Wetter:<br/>
Removed the use of <code>fill</code> when assigning the <code>unit</code> attribute.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1728\">#1728</a>.
</li>
<li>
January 12, 2019, by Michael Wetter:<br/>
Added missing <code>each</code>.
</li>
<li>
October 28, 2017, by Michael Wetter:<br/>
Corrected bug in guarding against division by zero.
</li>
<li>
September 27, 2017, by Michael Wetter:<br/>
Changed handling of guard against zero division, as the flow rate
can be zero at the instant when the fan switches on.
</li>
<li>
July 6, 2017, by Jianjun Hu:<br/>
Replaced <code>cooCtrlSig</code> input with <code>TZon</code> and <code>TDis</code>
inputs to check if cool or warm air distribution effectiveness should be applied.
Applied hysteresis to avoid rapid change.
</li>
<li>
July 5, 2017, by Michael Wetter:<br/>
Revised implementation.
</li>
<li>
May 12, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end Zone;
