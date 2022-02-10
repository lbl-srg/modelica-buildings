within Buildings.Templates.AirHandlersFans.Components.OutdoorSection;
model SingleDamper "Single common OA damper and OA measurement by AFMS"
  extends
    Buildings.Templates.AirHandlersFans.Components.OutdoorSection.Interfaces.PartialOutdoorSection(
    final typ=Buildings.Templates.AirHandlersFans.Types.OutdoorSection.SingleDamper,
    final typDamOut=damOut.typ,
    final typDamOutMin=Buildings.Templates.Components.Types.Damper.None);

  Buildings.Templates.Components.Dampers.Modulating damOut(
    redeclare final package Medium = MediumAir,
    final datRec=datRec.damOut)
    "Outdoor air damper"
    annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={0,0})));

  Buildings.Templates.Components.Sensors.VolumeFlowRate VAirOut_flow(
    redeclare final package Medium = MediumAir,
    final have_sen=true,
    final m_flow_nominal=m_flow_nominal,
    final typ=Buildings.Templates.Components.Types.SensorVolumeFlowRate.AFMS)
    "Outdoor air volume flow rate sensor"
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));
  Buildings.Templates.Components.Sensors.Temperature TAirOut(
    redeclare final package Medium = MediumAir,
    final have_sen=true,
    final m_flow_nominal=m_flow_nominal) "Outdoor air temperature sensor"
    annotation (Placement(transformation(extent={{50,-10},{70,10}})));
  Buildings.Templates.Components.Sensors.SpecificEnthalpy hAirOut(
    redeclare final package Medium = MediumAir,
    final have_sen=typCtrEco == Buildings.Templates.AirHandlersFans.Types.ControlEconomizer.FixedEnthalpyWithFixedDryBulb
         or typCtrEco == Buildings.Templates.AirHandlersFans.Types.ControlEconomizer.DifferentialEnthalpyWithFixedDryBulb,
    final m_flow_nominal=m_flow_nominal) "Outdoor air enthalpy sensor"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));

equation
  /* Control point connection - start */
  connect(damOut.bus, bus.damOut);
  connect(TAirOut.y, bus.TAirOut);
  connect(hAirOut.y, bus.hAirOut);
  connect(VAirOut_flow.y, bus.VAirOut_flow);
  /* Control point connection - end */
  connect(TAirOut.port_b, VAirOut_flow.port_a)
    annotation (Line(points={{70,0},{80,0}}, color={0,127,255}));
  connect(VAirOut_flow.port_b, port_b)
    annotation (Line(points={{100,0},{180,0}}, color={0,127,255}));

  connect(damOut.port_b, hAirOut.port_a)
    annotation (Line(points={{10,0},{20,0}}, color={0,127,255}));
  connect(hAirOut.port_b, TAirOut.port_a)
    annotation (Line(points={{40,0},{50,0}}, color={0,127,255}));
  connect(port_a, damOut.port_a)
    annotation (Line(points={{-180,0},{-10,0}}, color={0,127,255}));
  annotation (Icon(graphics={
              Line(
          points={{0,140},{0,0}},
          color={28,108,200},
          thickness=1),
              Line(
          points={{-180,0},{180,0}},
          color={28,108,200},
          thickness=1)}));
end SingleDamper;
