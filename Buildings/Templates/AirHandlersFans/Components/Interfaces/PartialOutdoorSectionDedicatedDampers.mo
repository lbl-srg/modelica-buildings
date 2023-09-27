within Buildings.Templates.AirHandlersFans.Components.Interfaces;
partial model PartialOutdoorSectionDedicatedDampers
  "Base class for modeling separate dampers for ventilation and economizer"
  extends
    Buildings.Templates.AirHandlersFans.Components.Interfaces.PartialOutdoorSection(
    final typDamOut=damOut.typ,
    final typDamOutMin=damOutMin.typ);

  Buildings.Templates.Components.Actuators.Damper damOut(
    redeclare final package Medium = MediumAir,
    final typ=Buildings.Templates.Components.Types.Damper.Modulating,
    use_inputFilter=energyDynamics<>Modelica.Fluid.Types.Dynamics.SteadyState,
    final allowFlowReversal=allowFlowReversal,
    final dat=dat.damOut)
    "Economizer outdoor air damper"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={0,0})));
  Buildings.Templates.Components.Actuators.Damper damOutMin(
    redeclare final package Medium = MediumAir,
    final typ=if typ==Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersAirflow
      then Buildings.Templates.Components.Types.Damper.Modulating
      elseif typ==Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersPressure
        then Buildings.Templates.Components.Types.Damper.TwoPosition
      else Buildings.Templates.Components.Types.Damper.None,
    use_inputFilter=energyDynamics<>Modelica.Fluid.Types.Dynamics.SteadyState,
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
    final have_sen=typ==Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersAirflow,
    final m_flow_nominal=mOutMin_flow_nominal,
    final typ=Buildings.Templates.Components.Types.SensorVolumeFlowRate.AFMS)
    "Minimum outdoor air volume flow rate sensor"
    annotation (Placement(transformation(extent={{110,50},{130,70}})));
  Buildings.Templates.Components.Sensors.SpecificEnthalpy hAirOut(
    redeclare final package Medium = MediumAir,
    final allowFlowReversal=allowFlowReversal,
    final have_sen=
      typCtlEco==Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.FixedEnthalpyWithFixedDryBulb or
      typCtlEco==Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.DifferentialEnthalpyWithFixedDryBulb,
    final m_flow_nominal=mOutMin_flow_nominal)
    "Outdoor air enthalpy sensor"
    annotation (Placement(transformation(extent={{30,50},{50,70}})));
  Buildings.Templates.Components.Sensors.DifferentialPressure dpAirOutMin(
    redeclare final package Medium = MediumAir,
    final have_sen=typ==Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersPressure)
    "Minimum outdoor air damper differential pressure sensor"
    annotation (Placement(transformation(extent={{-10,90},{10,110}})));
  Buildings.Fluid.FixedResistances.Junction junInl(
    redeclare final package Medium = MediumAir,
    final m_flow_nominal=m_flow_nominal*{1,-1,-1},
    dp_nominal=fill(0,3),
    final energyDynamics=energyDynamics) "Inlet fluid junction"
    annotation (Placement(transformation(extent={{-50,10},{-30,-10}})));
  Fluid.FixedResistances.Junction junOut(
    redeclare final package Medium = MediumAir,
    final m_flow_nominal=m_flow_nominal*{1,-1,1},
    dp_nominal=fill(0, 3),
    final energyDynamics=energyDynamics) "Outlet fluid junction"
    annotation (Placement(transformation(extent={{150,10},{170,-10}})));
equation
  /* Control point connection - start */
  connect(damOut.bus, bus.damOut);
  connect(damOutMin.bus, bus.damOutMin);
  connect(TOut.y, bus.TOut);
  connect(hAirOut.y, bus.hAirOut);
  connect(VOutMin_flow.y, bus.VOutMin_flow);
  connect(dpAirOutMin.y, bus.dpAirOutMin);
  /* Control point connection - end */
  connect(TOut.port_b, VOutMin_flow.port_a)
    annotation (Line(points={{90,60},{110,60}},color={0,127,255}));
  connect(damOutMin.port_b, hAirOut.port_a)
    annotation (Line(points={{10,60},{30,60}}, color={0,127,255}));
  connect(hAirOut.port_b, TOut.port_a)
    annotation (Line(points={{50,60},{70,60}}, color={0,127,255}));
  connect(damOutMin.port_a, dpAirOutMin.port_a) annotation (Line(points={{-10,60},
          {-20,60},{-20,100},{-10,100}}, color={0,127,255}));
  connect(dpAirOutMin.port_b, damOutMin.port_b) annotation (Line(points={{10,100},
          {20,100},{20,60},{10,60}}, color={0,127,255}));
  connect(damOut.port_a, junInl.port_2)
    annotation (Line(points={{-10,0},{-30,0}}, color={0,127,255}));
  connect(port_a, junInl.port_1)
    annotation (Line(points={{-180,0},{-50,0}}, color={0,127,255}));
  connect(junInl.port_3, damOutMin.port_a)
    annotation (Line(points={{-40,10},{-40,60},{-10,60}}, color={0,127,255}));
  connect(port_b, junOut.port_2)
    annotation (Line(points={{180,0},{170,0}}, color={0,127,255}));
  connect(damOut.port_b, junOut.port_1)
    annotation (Line(points={{10,0},{150,0}}, color={0,127,255}));
  connect(VOutMin_flow.port_b, junOut.port_3)
    annotation (Line(points={{130,60},{160,60},{160,10}}, color={0,127,255}));
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
end PartialOutdoorSectionDedicatedDampers;
