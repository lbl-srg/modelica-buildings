within Buildings.Controls.OBC.ASHRAE.G36.VentilationZones.Title24.SetPoints;
block ZoneAbsoluteMinimumOutdoorAirflow
  "Zone absolute outdoor airflow setpoint"

  parameter Boolean have_winSwi = false "The zone has a window switch";

  parameter Boolean have_occSen = false  "The zone has occupancy sensor";

  parameter Boolean have_CO2Sen = false "The zone has CO2 sensor";

  parameter Real FraVAreMin = 0.25
    "Fraction of zone minimum oudoor airflow"
    annotation(Dialog(enable=have_occSen));

  parameter Real VAreMin_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Zone minimum outdoor airflow for building area, per California Title 24 prescribed airflow-per-area requirements"
    annotation(Dialog(enable=have_occSen));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWin if have_winSwi
    "Window status, true if open, false if closed"
    annotation (Placement(transformation(extent={{-180,30},{-140,70}}),
        iconTransformation(extent={{-140,0},{-100,40}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uOcc if have_occSen
    "True if the zone is populated, that is the occupancy sensor senses the presence of people"
    annotation (Placement(transformation(extent={{-180,-20},{-140,20}}),
        iconTransformation(extent={{-140,60},{-100,100}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VOutMinZonDes_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate") if not (have_winSwi or have_occSen or have_CO2Sen)
    "Outdoor air volume flow setpoint used in AHU sequeces"
    annotation (Placement(transformation(extent={{-180,-90},{-140,-50}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VOutMinZonAbs_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Outdoor air volume flow setpoint used in terminal-unit sequeces"
    annotation (Placement(transformation(extent={{140,-20},{180,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));

  CDL.Continuous.Sources.Constant zero(
    final k=0) "Zero flow"
    annotation (Placement(transformation(extent={{0,100},{20,120}})));

  CDL.Continuous.Sources.Constant VAreMin(
    final k=VAreMin_flow)
    "Zone minimum outdoor airflow for building area, per California Title 24 prescribed airflow-per-area requirements"
    annotation (Placement(transformation(extent={{-120,60},{-100,80}})));

  CDL.Logical.Switch swi
    annotation (Placement(transformation(extent={{40,40},{60,60}})));

  CDL.Logical.Switch swi1
    "Switch "
    annotation (Placement(transformation(extent={{40,-50},{60,-30}})));

  CDL.Continuous.Gain gai(
    final k=FraVAreMin)
    "Zone minimum outdoor airflow for building area gain"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));

  CDL.Logical.Sources.Constant tru(
    final k=true) if not have_occSen
    "True signal"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));

  CDL.Logical.Sources.Constant fal(
    final k=false) if not have_winSwi
    "False signal"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));

  CDL.Logical.Switch swi2
    "Switch"
    annotation (Placement(transformation(extent={{0,-100},{20,-80}})));

  CDL.Logical.Sources.Constant fal1(
    final k=have_CO2Sen) "Boolean signal"
    annotation (Placement(transformation(extent={{-60,-130},{-40,-110}})));

  CDL.Continuous.Sources.Constant zero1(
    final k=0) if have_CO2Sen
    "Substitute signal that never gets used"
    annotation (Placement(transformation(extent={{-100,-130},{-80,-110}})));

equation

  connect(zero.y,swi. u1) annotation (Line(points={{22,110},{30,110},{30,58},{38,
          58}},
        color={0,0,127}));
  connect(uWin,swi. u2) annotation (Line(points={{-160,50},{38,50}},
        color={255,0,255}));
  connect(uOcc,swi1. u2)
    annotation (Line(points={{-160,0},{-100,0},{-100,-20},{10,-20},{10,-40},{38,
          -40}},                                   color={255,0,255}));
  connect(VAreMin.y,gai. u) annotation (Line(points={{-98,70},{-80,70},{-80,0},
          {-42,0}},   color={0,0,127}));
  connect(gai.y,swi1. u3) annotation (Line(points={{-18,0},{0,0},{0,-48},{38,-48}},
                 color={0,0,127}));
  connect(swi1.y,swi. u3) annotation (Line(points={{62,-40},{70,-40},{70,10},{30,
          10},{30,42},{38,42}}, color={0,0,127}));
  connect(fal.y,swi. u2) annotation (Line(points={{-18,30},{0,30},{0,50},{38,50}},
        color={255,0,255}));
  connect(tru.y,swi1. u2) annotation (Line(points={{-18,-40},{38,-40}},
                     color={255,0,255}));
  connect(swi2.y, swi1.u1) annotation (Line(points={{22,-90},{30,-90},{30,-32},{
          38,-32}}, color={0,0,127}));
  connect(VAreMin.y, swi2.u1) annotation (Line(points={{-98,70},{-80,70},{-80,
          -82},{-2,-82}},     color={0,0,127}));
  connect(fal1.y, swi2.u2) annotation (Line(points={{-38,-120},{-20,-120},{-20,-90},
          {-2,-90}}, color={255,0,255}));
  connect(swi.y, VOutMinZonAbs_flow) annotation (Line(points={{62,50},{100,50},{
          100,0},{160,0}}, color={0,0,127}));
  connect(VOutMinZonDes_flow, swi2.u3) annotation (Line(points={{-160,-70},{-100,
          -70},{-100,-98},{-2,-98}}, color={0,0,127}));
  connect(zero1.y, swi2.u3) annotation (Line(points={{-78,-120},{-68,-120},{-68,
          -98},{-2,-98}}, color={0,0,127}));
annotation (
  defaultComponentName = "VOutMinZonAbs",
  Icon(graphics={Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,140},{100,100}},
          lineColor={0,0,255},
          textString="%name")}),
   Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-140},{140,
            140}})),
 Documentation(info="<html>
<p>
fixme
</p>

<p align=\"center\">
<img alt=\"Image of the exhaust damper control chart for single zone AHU\"
src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/G36_PR1/AHUs/SingleZone/VAV/SetPoints/ExhaustDamper.png\"/>
</p>
</html>", revisions="<html>
<ul>
<li>
Jun 20, 2020, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end ZoneAbsoluteMinimumOutdoorAirflow;
