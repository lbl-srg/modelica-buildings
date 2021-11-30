within Buildings.Templates.AirHandlersFans.Components.OutdoorSection;
model DedicatedDamperAirflow
  "Dedicated minimum OA damper (modulated) with AFMS"
  extends Buildings.Templates.AirHandlersFans.Components.OutdoorSection.Interfaces.PartialOutdoorSection(
    final typ=Buildings.Templates.AirHandlersFans.Types.OutdoorSection.DedicatedDamperAirflow,
    final typDamOut=damOut.typ,
    final typDamOutMin=damOutMin.typ);

  Buildings.Templates.Components.Dampers.Modulated damOut(
    redeclare final package Medium = MediumAir,
    final m_flow_nominal=m_flow_nominal,
    final dpDamper_nominal=dpDamOut_nominal)
    "Economizer outdoor air damper"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={0,0})));
  Buildings.Templates.Components.Dampers.Modulated damOutMin(
    redeclare final package Medium = MediumAir,
    final m_flow_nominal=m_flow_nominal,
    final dpDamper_nominal=dpDamOutMin_nominal)
    "Minimum outdoor air damper"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={0,60})));

  Buildings.Templates.Components.Sensors.Temperature TOut(
    redeclare final package  Medium = MediumAir,
    final have_sen=true,
    final m_flow_nominal=m_flow_nominal)
    "Outdoor air temperature sensor"
    annotation (Placement(transformation(extent={{50,50},{70,70}})));
  Buildings.Templates.Components.Sensors.VolumeFlowRate VOutMin_flow(
    redeclare final package Medium = MediumAir,
    final have_sen=true,
    final m_flow_nominal=m_flow_nominal,
    final typ=Buildings.Templates.Components.Types.SensorVolumeFlowRate.AFMS)
    "Minimum outdoor air volume flow rate sensor"
    annotation (Placement(transformation(extent={{80,50},{100,70}})));
  Buildings.Templates.Components.Sensors.SpecificEnthalpy hOut(
    redeclare final package Medium = MediumAir,
    final have_sen=
      typCtrEco==Buildings.Templates.AirHandlersFans.Types.ControlEconomizer.FixedEnthalpyWithFixedDryBulb or
      typCtrEco==Buildings.Templates.AirHandlersFans.Types.ControlEconomizer.DifferentialEnthalpyWithFixedDryBulb,
    final m_flow_nominal=m_flow_nominal)
    "Outdoor air enthalpy sensor"
    annotation (Placement(transformation(extent={{20,50},{40,70}})));
equation
  /* Control point connection - start */
  connect(damOut.bus, bus.damOut);
  connect(damOutMin.bus, bus.damOutMin);
  connect(TOut.y, bus.TOut);
  connect(hOut.y, bus.hOut);
  connect(VOutMin_flow.y, bus.VOutMin_flow);
  /* Control point connection - end */
  connect(port_aIns, damOut.port_a)
    annotation (Line(points={{-40,0},{-10,0}}, color={0,127,255}));
  connect(damOut.port_b, port_b)
    annotation (Line(points={{10,0},{180,0}}, color={0,127,255}));
  connect(port_a, pas.port_a)
    annotation (Line(points={{-180,0},{-70,0}},  color={0,127,255}));
  connect(TOut.port_b, VOutMin_flow.port_a)
    annotation (Line(points={{70,60},{80,60}}, color={0,127,255}));
  connect(VOutMin_flow.port_b, port_b) annotation (Line(points={{100,60},{120,60},
          {120,0},{180,0}}, color={0,127,255}));
  connect(port_aIns, damOutMin.port_a) annotation (Line(points={{-40,0},{-16,0},
          {-16,60},{-10,60}},color={0,127,255}));
  connect(damOutMin.port_b, hOut.port_a)
    annotation (Line(points={{10,60},{20,60}}, color={0,127,255}));
  connect(hOut.port_b, TOut.port_a)
    annotation (Line(points={{40,60},{50,60}}, color={0,127,255}));
  annotation (Documentation(info="<html>
<p>
Two classes are used depending on the type of sensor used to control the
OA flow rate because the type of sensor conditions the type of
damper: two-position in case of differential pressure, modulated in case
of AFMS.
</p>
</html>"), Icon(graphics={
              Line(
          points={{0,140},{0,0}},
          color={28,108,200},
          thickness=1),
              Line(
          points={{-180,0},{180,0}},
          color={28,108,200},
          thickness=1),
              Line(
          points={{-180,60},{0,60}},
          color={28,108,200},
          thickness=1)}));
end DedicatedDamperAirflow;
