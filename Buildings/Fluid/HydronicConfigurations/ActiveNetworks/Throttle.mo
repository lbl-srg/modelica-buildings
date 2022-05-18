within Buildings.Fluid.HydronicConfigurations.ActiveNetworks;
model Throttle "Throttle circuit"
  extends
    Buildings.Fluid.HydronicConfigurations.Interfaces.PartialHydronicConfiguration(
      dpValve_nominal=dpSec_nominal);

  replaceable Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage val
    constrainedby Buildings.Fluid.Actuators.BaseClasses.PartialTwoWayValve(
      redeclare final package Medium=Medium,
      use_inputFilter=energyDynamics<>Modelica.Fluid.Types.Dynamics.SteadyState,
      final allowFlowReversal=allowFlowReversal,
      final m_flow_nominal=m_flow_nominal,
      final dpValve_nominal=dpValve_nominal,
      final dpFixed_nominal=dpBal1_nominal +
        (if use_lumFloRes then dpSec_nominal else 0))
    "Control valve"
    annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={60,0})));
  Buildings.Fluid.FixedResistances.PressureDrop bal1(
    redeclare final package Medium=Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m_flow_nominal,
    final dp_nominal=dpBal1_nominal)
    "Primary balancing valve"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={60,-50})));
equation
  connect(bal1.port_b, port_b1)
    annotation (Line(points={{60,-60},{60,-100}}, color={0,127,255}));
  connect(port_b2, port_a1)
    annotation (Line(points={{-60,100},{-60,-100}}, color={0,127,255}));
  connect(y, val.y)
    annotation (Line(points={{-120,0},{48,0}}, color={0,0,127}));

  connect(val.port_b, bal1.port_a)
    annotation (Line(points={{60,-10},{60,-40}}, color={0,127,255}));
  connect(val.port_a, port_a2)
    annotation (Line(points={{60,10},{60,100},{60,100}}, color={0,127,255}));
  annotation (
    defaultComponentName="con",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
      Bitmap(
      extent={{-100,-100},{100,100}},
      fileName="modelica://Buildings/Resources/Images/Fluid/HydronicConfigurations/ActiveNetworks/Throttle.svg")}),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>

</p>
</html>"));
end Throttle;
