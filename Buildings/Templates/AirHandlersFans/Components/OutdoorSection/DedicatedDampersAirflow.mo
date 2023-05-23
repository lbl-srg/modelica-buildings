within Buildings.Templates.AirHandlersFans.Components.OutdoorSection;
model DedicatedDampersAirflow
  "Separate dampers for ventilation and economizer, with airflow measurement station"
  extends
    Buildings.Templates.AirHandlersFans.Components.OutdoorSection.Interfaces.PartialOutdoorSection(
    final typ=Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersAirflow,
    final typDamOut=damOut.typ,
    final typDamOutMin=damOutMin.typ);

  Buildings.Templates.Components.Dampers.Modulating damOut(
    redeclare final package Medium = MediumAir,
    final allowFlowReversal=allowFlowReversal,
    final dat=dat.damOut)
    "Economizer outdoor air damper"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={0,0})));
  Buildings.Templates.Components.Dampers.Modulating damOutMin(
    redeclare final package Medium = MediumAir,
    final allowFlowReversal=allowFlowReversal,
    final dat=dat.damOutMin)
    "Minimum outdoor air damper"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={0,60})));

  Buildings.Templates.Components.Sensors.Temperature TOut(
    redeclare final package Medium =  MediumAir,
    final allowFlowReversal=allowFlowReversal,
    final have_sen=true,
    final m_flow_nominal=mOutMin_flow_nominal)
    "Outdoor air temperature sensor"
    annotation (Placement(transformation(extent={{70,50},{90,70}})));
  Buildings.Templates.Components.Sensors.VolumeFlowRate VOutMin_flow(
    redeclare final package Medium = MediumAir,
    final allowFlowReversal=allowFlowReversal,
    final have_sen=true,
    final m_flow_nominal=mOutMin_flow_nominal,
    final typ=Buildings.Templates.Components.Types.SensorVolumeFlowRate.AFMS)
    "Minimum outdoor air volume flow rate sensor"
    annotation (Placement(transformation(extent={{110,50},{130,70}})));
  Buildings.Templates.Components.Sensors.SpecificEnthalpy hAirOut(
    redeclare final package Medium = MediumAir,
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
  connect(VOutMin_flow.y, bus.VOutMin_flow);
  /* Control point connection - end */
  connect(damOut.port_b, port_b)
    annotation (Line(points={{10,0},{180,0}}, color={0,127,255}));
  connect(TOut.port_b, VOutMin_flow.port_a)
    annotation (Line(points={{90,60},{110,60}},color={0,127,255}));
  connect(VOutMin_flow.port_b, port_b) annotation (Line(points={{130,60},{160,
          60},{160,0},{180,0}},
                            color={0,127,255}));
  connect(damOutMin.port_b, hAirOut.port_a)
    annotation (Line(points={{10,60},{30,60}}, color={0,127,255}));
  connect(hAirOut.port_b, TOut.port_a)
    annotation (Line(points={{50,60},{70,60}}, color={0,127,255}));
  connect(port_a, damOut.port_a)
    annotation (Line(points={{-180,0},{-10,0}}, color={0,127,255}));
  connect(damOutMin.port_a, damOut.port_a) annotation (Line(points={{-10,60},{
          -20,60},{-20,0},{-10,0}}, color={0,127,255}));
  annotation (Documentation(info="<html>
<p>
This model represents a configuration with an air economizer and
minimum OA control with a separate minimum OA damper and airflow measurement.
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
end DedicatedDampersAirflow;
