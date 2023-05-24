within Buildings.Templates.AirHandlersFans.Components.OutdoorSection;
model DedicatedDampersPressure
  "Separate dampers for ventilation and economizer, with differential pressure sensor"
  extends
    Buildings.Templates.AirHandlersFans.Components.Interfaces.PartialOutdoorSection(
    final typ=Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersPressure,
    final typDamOut=damOut.typ,
    final typDamOutMin=damOutMin.typ);

  Buildings.Templates.Components.Dampers.Modulating damOut(
    redeclare final package Medium = MediumAir,
    use_inputFilter=energyDynamics<>Modelica.Fluid.Types.Dynamics.SteadyState,
    final allowFlowReversal=allowFlowReversal,
    final dat=dat.damOut)
    "Economizer outdoor air damper"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={0,0})));
  Buildings.Templates.Components.Dampers.TwoPosition damOutMin(
    redeclare final package Medium = MediumAir,
    use_inputFilter=energyDynamics<>Modelica.Fluid.Types.Dynamics.SteadyState,
    final allowFlowReversal=allowFlowReversal,
    final dat=dat.damOutMin)
    "Minimum outdoor air damper"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={0,60})));

  Buildings.Templates.Components.Sensors.Temperature TOut(
    redeclare final package Medium = MediumAir,
    final allowFlowReversal=allowFlowReversal,
    final have_sen=true,
    final m_flow_nominal=mOutMin_flow_nominal)
    "Outdoor air temperature sensor"
    annotation (Placement(transformation(extent={{70,50},{90,70}})));
  Buildings.Templates.Components.Sensors.DifferentialPressure dpAirOutMin(
    redeclare final package Medium = MediumAir,
    final have_sen=true)
    "Minimum outdoor air damper differential pressure sensor"
    annotation (Placement(transformation(extent={{-10,90},{10,110}})));
  Buildings.Templates.Components.Sensors.SpecificEnthalpy hAirOut(
    redeclare final package Medium = MediumAir,
    final allowFlowReversal=allowFlowReversal,
    final have_sen=
      typCtlEco==Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.FixedEnthalpyWithFixedDryBulb or
      typCtlEco==Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.DifferentialEnthalpyWithFixedDryBulb,
    final m_flow_nominal=mOutMin_flow_nominal)
    "Outdoor air enthalpy sensor"
    annotation (Placement(transformation(extent={{30,50},{50,70}})));
equation
  /* Control point connection - start */
  connect(damOut.bus, bus.damOut);
  connect(damOutMin.bus, bus.damOutMin);
  connect(TOut.y, bus.TOut);
  connect(hAirOut.y, bus.hAirOut);
  connect(dpAirOutMin.y, bus.dpAirOutMin);
  /* Control point connection - end */
  connect(TOut.port_b, port_b) annotation (Line(points={{90,60},{160,60},{160,0},
          {180,0}}, color={0,127,255}));
  connect(damOut.port_b, port_b)
    annotation (Line(points={{10,0},{180,0}}, color={0,127,255}));

  connect(damOutMin.port_a, dpAirOutMin.port_a) annotation (Line(points={{-10,60},
          {-20,60},{-20,100},{-10,100}},
                                   color={0,127,255}));
  connect(damOutMin.port_b, dpAirOutMin.port_b) annotation (Line(points={{10,60},{
          20,60},{20,100},{10,100}},
                                   color={0,127,255}));
  connect(damOutMin.port_b, hAirOut.port_a)
    annotation (Line(points={{10,60},{30,60}}, color={0,127,255}));
  connect(hAirOut.port_b, TOut.port_a)
    annotation (Line(points={{50,60},{70,60}},   color={0,127,255}));
  connect(port_a, damOut.port_a)
    annotation (Line(points={{-180,0},{-10,0}}, color={0,127,255}));
  connect(damOut.port_a, damOutMin.port_a) annotation (Line(points={{-10,0},{
          -20,0},{-20,60},{-10,60}}, color={0,127,255}));
  annotation (Documentation(info="<html>
<p>
This model represents a configuration with an air economizer and
minimum OA control with a separate minimum OA damper and differential
pressure control.
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
end DedicatedDampersPressure;
