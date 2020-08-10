within Buildings.Controls.OBC.ASHRAE.G36.VentilationZones.Title24.SetPoints;
block ZoneDesignMinimumOutdoorAirflow
  "Zone design outdoor airflow setpoint"

  parameter Boolean have_winSwi = false "The zone has a window switch";

  parameter Boolean have_occSen = true "The zone has occupancy sensor";

  parameter Real FraVAreMin = 0.25
    "Fraction of zone minimum oudoor airflow"
    annotation(Dialog(enable=have_occSen));

  parameter Real VAreMin_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Zone minimum outdoor airflow for building area, per California Title 24 prescribed airflow-per-area requirements";

  parameter Real VOccMin_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Zone minimum outdoor airflow for occupants, per California Title 24 prescribed airflow-per-occupant requirements";

  CDL.Interfaces.BooleanInput uWin if have_winSwi
    "Window status, true if open, false if closed"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-240,-120},{-200,-80}})));

  CDL.Interfaces.BooleanInput uOcc if have_occSen
    "True if the zone is populated, that is the occupancy sensor senses the presence of people"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
        iconTransformation(extent={{-240,80},{-200,120}})));

  CDL.Interfaces.RealOutput VOutMinZonDes_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Outdoor air volume flow setpoint used in AHU sequeces"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));

  CDL.Continuous.Sources.Constant zero(
    final k=0) if have_winSwi "Zero flow"
    annotation (Placement(transformation(extent={{0,60},{20,80}})));

  CDL.Continuous.Sources.Constant VAreMin(
    final k=VAreMin_flow) if not (have_winSwi or have_occSen)
    "Zone minimum outdoor airflow for building area, per California Title 24 prescribed airflow-per-area requirements"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));

  CDL.Continuous.Sources.Constant VOccMin(
    final k=VOccMin_flow) if not (have_winSwi or have_occSen)
    "Zone minimum outdoor airflow for occupants, per California Title 24 prescribed airflow-per-occupant requirements"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));

  CDL.Logical.Switch swi
    annotation (Placement(transformation(extent={{40,20},{60,40}})));

  CDL.Logical.Switch swi1
    "Switch "
    annotation (Placement(transformation(extent={{40,-70},{60,-50}})));

  CDL.Continuous.Max max1
    "Maximum"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));

  CDL.Continuous.Gain gai(k=FraVAreMin) if have_occSen
    "Zone minimum outdoor airflow for building area gain"
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));

  CDL.Logical.Sources.Constant con(
    final k=true) if not (have_winSwi or have_occSen)
    "True signal"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));

  CDL.Logical.Not not1 if not (have_winSwi or have_occSen)
    "Logical not"
    annotation (Placement(transformation(extent={{-40,-90},{-20,-70}})));

equation

  connect(VAreMin.y, max1.u2) annotation (Line(points={{-58,40},{-50,40},{-50,54},
          {-42,54}}, color={0,0,127}));
  connect(VOccMin.y, max1.u1) annotation (Line(points={{-58,80},{-50,80},{-50,66},
          {-42,66}}, color={0,0,127}));
  connect(swi.y, VOutMinZonDes_flow) annotation (Line(points={{62,30},{80,30},{80,
          0},{120,0}}, color={0,0,127}));
  connect(zero.y, swi.u1) annotation (Line(points={{22,70},{30,70},{30,38},{38,38}},
        color={0,0,127}));
  connect(uWin, swi.u2) annotation (Line(points={{-120,0},{-40,0},{-40,30},{38,30}},
        color={255,0,255}));
  connect(max1.y, swi.u3) annotation (Line(points={{-18,60},{-10,60},{-10,22},{38,
          22}}, color={0,0,127}));
  connect(uOcc, swi1.u2)
    annotation (Line(points={{-120,-60},{38,-60}}, color={255,0,255}));
  connect(VAreMin.y, gai.u) annotation (Line(points={{-58,40},{-50,40},{-50,-20},
          {-42,-20}}, color={0,0,127}));
  connect(gai.y, swi1.u3) annotation (Line(points={{-18,-20},{0,-20},{0,-68},{38,
          -68}}, color={0,0,127}));
  connect(max1.y, swi1.u1) annotation (Line(points={{-18,60},{-10,60},{-10,0},{20,
          0},{20,-52},{38,-52}}, color={0,0,127}));
  connect(swi1.y, VOutMinZonDes_flow) annotation (Line(points={{62,-60},{80,-60},
          {80,0},{120,0}}, color={0,0,127}));
  connect(con.y, swi1.u2) annotation (Line(points={{-58,-80},{-50,-80},{-50,-60},
          {38,-60}}, color={255,0,255}));
  connect(con.y, not1.u)
    annotation (Line(points={{-58,-80},{-42,-80}}, color={255,0,255}));
  connect(not1.y, swi.u2) annotation (Line(points={{-18,-80},{10,-80},{10,30},{38,
          30}}, color={255,0,255}));
annotation (
  defaultComponentName = "VOutMinZonDes",
  Icon(graphics={Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,140},{100,100}},
          lineColor={0,0,255},
          textString="%name")}),
   Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})),
 Documentation(info="<html>
<p>
Per section 5.2.1.4.b.2. zone design minimum outdoor airflow <code>VOutMinZonDes_flow</code> equals the following:  
</p>
<ul>
<li>
Zero, if the zone has a window switch as indicated by <code>have_winSwi</code> parameter and the window is open, 
that is the <code>uWin</code> input is <code>true</code>
</li>
<li>
<code>FraVAreMin</code> fraction of zone minimum outdoor airflow for building area <code>VAreMin_flow</code> if the zone has an 
occupancy sensor as indicated by <code>have_occSen</code> parameter and is unpopulated, 
that is the <code>uOcc</code> input is <code>false</code>
</li>
<li>
The larger of <code>VAreMin_flow</code> and <code>VOccMin_flow</code> otherwise. 
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
August 10, 2020, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end ZoneDesignMinimumOutdoorAirflow;
