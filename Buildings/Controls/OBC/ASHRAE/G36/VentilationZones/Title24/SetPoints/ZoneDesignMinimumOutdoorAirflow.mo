within Buildings.Controls.OBC.ASHRAE.G36.VentilationZones.Title24.SetPoints;
block ZoneDesignMinimumOutdoorAirflow
  "Zone design outdoor airflow setpoint"

  parameter Boolean have_winSwi = true "The zone has a window switch";

  parameter Boolean have_occSen = false "The zone has occupancy sensor";

  parameter Real FraVAreMin = 0.25
    "Fraction of zone minimum oudoor airflow"
    annotation(Dialog(enable=have_occSen));

  parameter Real VAreMin_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate") = 0.2
    "Zone minimum outdoor airflow for building area, per California Title 24 prescribed airflow-per-area requirements";

  parameter Real VOccMin_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate") = 0.25
    "Zone minimum outdoor airflow for occupants, per California Title 24 prescribed airflow-per-occupant requirements";

  CDL.Interfaces.BooleanInput uWin if have_winSwi
    "Window status, true if open, false if closed"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,50},{-100,90}})));

  CDL.Interfaces.BooleanInput uOcc if have_occSen
    "True if the zone is populated, that is the occupancy sensor senses the presence of people"
    annotation (Placement(transformation(extent={{-140,-70},{-100,-30}}),
        iconTransformation(extent={{-140,-90},{-100,-50}})));

  CDL.Interfaces.RealOutput VOutMinZonDes_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Outdoor air volume flow setpoint used in AHU sequeces"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));

  CDL.Continuous.Sources.Constant zero(
    final k=0) "Zero flow"
    annotation (Placement(transformation(extent={{0,70},{20,90}})));

  CDL.Continuous.Sources.Constant VAreMin(
    final k=VAreMin_flow)
    "Zone minimum outdoor airflow for building area, per California Title 24 prescribed airflow-per-area requirements"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));

  CDL.Continuous.Sources.Constant VOccMin(
    final k=VOccMin_flow)
    "Zone minimum outdoor airflow for occupants, per California Title 24 prescribed airflow-per-occupant requirements"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));

  CDL.Logical.Switch swi
    annotation (Placement(transformation(extent={{40,10},{60,30}})));

  CDL.Logical.Switch swi1
    "Switch "
    annotation (Placement(transformation(extent={{40,-80},{60,-60}})));

  CDL.Continuous.Max max1
    "Maximum"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));

  CDL.Continuous.Gain gai(
    final k=FraVAreMin)
    "Zone minimum outdoor airflow for building area gain"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));

  CDL.Logical.Sources.Constant tru(final k=true) if not have_occSen
    "True signal"
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));

  CDL.Logical.Sources.Constant fal(final k=false) if not have_winSwi
    "True signal"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));

equation

  connect(VAreMin.y, max1.u2) annotation (Line(points={{-58,40},{-50,40},{-50,44},
          {-42,44}}, color={0,0,127}));
  connect(VOccMin.y, max1.u1) annotation (Line(points={{-58,80},{-50,80},{-50,56},
          {-42,56}}, color={0,0,127}));
  connect(swi.y, VOutMinZonDes_flow) annotation (Line(points={{62,20},{70,20},{70,
          0},{120,0}}, color={0,0,127}));
  connect(zero.y, swi.u1) annotation (Line(points={{22,80},{30,80},{30,28},{38,28}},
        color={0,0,127}));
  connect(uWin, swi.u2) annotation (Line(points={{-120,0},{-60,0},{-60,20},{38,20}},
        color={255,0,255}));
  connect(uOcc, swi1.u2)
    annotation (Line(points={{-120,-50},{10,-50},{10,-70},{38,-70}},
                                                   color={255,0,255}));
  connect(VAreMin.y, gai.u) annotation (Line(points={{-58,40},{-50,40},{-50,-30},
          {-42,-30}}, color={0,0,127}));
  connect(gai.y, swi1.u3) annotation (Line(points={{-18,-30},{0,-30},{0,-78},{38,
          -78}}, color={0,0,127}));
  connect(max1.y, swi1.u1) annotation (Line(points={{-18,50},{20,50},{20,-62},{38,
          -62}},                 color={0,0,127}));
  connect(swi1.y, swi.u3) annotation (Line(points={{62,-70},{70,-70},{70,-20},{30,
          -20},{30,12},{38,12}},color={0,0,127}));
  connect(fal.y, swi.u2) annotation (Line(points={{-18,0},{0,0},{0,20},{38,20}},
        color={255,0,255}));
  connect(tru.y, swi1.u2) annotation (Line(points={{-18,-70},{38,-70}},
                     color={255,0,255}));
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
<code>VOutMinZonDes_flow</code> is used in air handler sequences. 
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
