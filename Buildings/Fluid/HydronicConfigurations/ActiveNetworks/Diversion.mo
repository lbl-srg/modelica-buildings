within Buildings.Fluid.HydronicConfigurations.ActiveNetworks;
model Diversion "Diversion circuit"
  extends
    Buildings.Fluid.HydronicConfigurations.Interfaces.PartialHydronicConfiguration(
      dpValve_nominal=dpSec_nominal);

  replaceable Buildings.Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear val(fraK=1)
    constrainedby Buildings.Fluid.Actuators.BaseClasses.PartialThreeWayValve(
      redeclare final package Medium=Medium,
      final energyDynamics=energyDynamics,
      use_inputFilter=energyDynamics<>Modelica.Fluid.Types.Dynamics.SteadyState,
      final portFlowDirection_1=if allowFlowReversal then
        Modelica.Fluid.Types.PortFlowDirection.Bidirectional else
        Modelica.Fluid.Types.PortFlowDirection.Entering,
      final portFlowDirection_2=if allowFlowReversal then
        Modelica.Fluid.Types.PortFlowDirection.Bidirectional else
        Modelica.Fluid.Types.PortFlowDirection.Leaving,
      final portFlowDirection_3=if allowFlowReversal then
        Modelica.Fluid.Types.PortFlowDirection.Bidirectional else
        Modelica.Fluid.Types.PortFlowDirection.Entering,
      final m_flow_nominal=m_flow_nominal,
      final dpValve_nominal=dpValve_nominal,
      final dpFixed_nominal={dpSec_nominal, dpBal2_nominal} .*
        (if use_lumFloRes then {1, 1} else {0, 1}))
    "Control valve"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={60,0})));
  Buildings.Fluid.FixedResistances.Junction jun(
    redeclare final package Medium=Medium,
    final energyDynamics=energyDynamics,
    final portFlowDirection_1=if allowFlowReversal then
      Modelica.Fluid.Types.PortFlowDirection.Bidirectional else
      Modelica.Fluid.Types.PortFlowDirection.Entering,
    final portFlowDirection_2=if allowFlowReversal then
      Modelica.Fluid.Types.PortFlowDirection.Bidirectional else
      Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final portFlowDirection_3=if allowFlowReversal then
      Modelica.Fluid.Types.PortFlowDirection.Bidirectional else
      Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final m_flow_nominal=m_flow_nominal .* {1,-1,-1},
    final dp_nominal=fill(0, 3))
    "Junction"
     annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-60,0})));
  Buildings.Fluid.FixedResistances.PressureDrop bal1(
    redeclare final package Medium=Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m_flow_nominal,
    final dp_nominal=dpBal1_nominal)
    "Primary balancing valve" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={60,-50})));
equation
  connect(port_a2, val.port_1)
    annotation (Line(points={{60,100},{60,10}}, color={0,127,255}));
  connect(val.port_2, bal1.port_a)
    annotation (Line(points={{60,-10},{60,-40}}, color={0,127,255}));
  connect(bal1.port_b, port_b1)
    annotation (Line(points={{60,-60},{60,-100}}, color={0,127,255}));
  connect(jun.port_1, port_a1) annotation (Line(points={{-60,-10},{-60,-100},{-60,
          -100}}, color={0,127,255}));
  connect(jun.port_3, val.port_3)
    annotation (Line(points={{-50,0},{50,0}}, color={0,127,255}));
  connect(jun.port_2, port_b2)
    annotation (Line(points={{-60,10},{-60,100}}, color={0,127,255}));
  connect(bus.yVal, val.y) annotation (Line(
      points={{-100,0},{-80,0},{-80,20},{80,20},{80,0},{72,0}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  annotation (
    defaultComponentName="con",
    Icon(
    graphics={
    Bitmap(
      extent={{-100,-100},{100,100}},
      fileName="modelica://Buildings/Resources/Images/Fluid/HydronicConfigurations/ActiveNetworks/Diversion.svg")}),                                                                                                       Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>

</p>
</html>"));
end Diversion;
