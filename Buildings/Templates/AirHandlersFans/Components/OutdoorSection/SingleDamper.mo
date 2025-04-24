within Buildings.Templates.AirHandlersFans.Components.OutdoorSection;
model SingleDamper
  "Single damper for ventilation and economizer, with airflow measurement station"
  extends
    Buildings.Templates.AirHandlersFans.Components.Interfaces.PartialOutdoorSection(
    final typ=Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.SingleDamper);

  Buildings.Templates.Components.Actuators.Damper damOut(
    redeclare final package Medium = MediumAir,
    final typ=typDamOut,
    use_strokeTime=energyDynamics<>Modelica.Fluid.Types.Dynamics.SteadyState,
    final allowFlowReversal=allowFlowReversal,
    final dat=dat.damOut)
    "Outdoor air damper"
    annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={0,0})));

  Buildings.Templates.Components.Sensors.VolumeFlowRate VOut_flow(
    redeclare final package Medium = MediumAir,
    final allowFlowReversal=allowFlowReversal,
    final have_sen=true,
    final m_flow_nominal=m_flow_nominal,
    final typ=Buildings.Templates.Components.Types.SensorVolumeFlowRate.AFMS)
    "Outdoor air volume flow rate sensor"
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));
  Buildings.Templates.Components.Sensors.Temperature TOut(
    redeclare final package Medium = MediumAir,
    final allowFlowReversal=allowFlowReversal,
    final have_sen=true,
    final m_flow_nominal=m_flow_nominal)
    "Outdoor air temperature sensor"
    annotation (Placement(transformation(extent={{50,-10},{70,10}})));
  Buildings.Templates.Components.Sensors.SpecificEnthalpy hAirOut(
    redeclare final package Medium = MediumAir,
    final allowFlowReversal=allowFlowReversal,
    final have_sen=typCtlEco == Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.FixedEnthalpyWithFixedDryBulb
      or typCtlEco == Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.DifferentialEnthalpyWithFixedDryBulb,
    final m_flow_nominal=m_flow_nominal) "Outdoor air enthalpy sensor"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));

equation
  /* Control point connection - start */
  connect(damOut.bus, bus.damOut);
  connect(TOut.y, bus.TOut);
  connect(hAirOut.y, bus.hAirOut);
  connect(VOut_flow.y, bus.VOut_flow);
  /* Control point connection - end */
  connect(TOut.port_b, VOut_flow.port_a)
    annotation (Line(points={{70,0},{80,0}}, color={0,127,255}));
  connect(VOut_flow.port_b, port_b)
    annotation (Line(points={{100,0},{180,0}}, color={0,127,255}));

  connect(damOut.port_b, hAirOut.port_a)
    annotation (Line(points={{10,0},{20,0}}, color={0,127,255}));
  connect(hAirOut.port_b, TOut.port_a)
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
          thickness=1)}), Documentation(info="<html>
<p>
This model represents a configuration with an air economizer
and minimum OA control with a single common damper
and airflow measurement
</p>
</html>"));
end SingleDamper;
