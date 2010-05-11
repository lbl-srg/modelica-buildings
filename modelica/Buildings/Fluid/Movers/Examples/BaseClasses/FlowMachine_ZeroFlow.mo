within Buildings.Fluid.Movers.Examples.BaseClasses;
partial model FlowMachine_ZeroFlow
  "Base class to test flow machines with zero flow rate"
  import Buildings;

  package Medium = Buildings.Media.GasesPTDecoupled.MoistAirUnsaturated;

  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{120,-80},{140,-60}})));

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal= 1
    "Nominal mass flow rate";
  parameter Modelica.SIunits.Pressure dp_nominal = 500
    "Nominal pressure difference";

  Modelica.Blocks.Sources.Ramp y(
    offset=1,
    duration=0.5,
    startTime=0.25,
    height=-1) "Input signal"
                 annotation (Placement(transformation(extent={{-90,90},{-70,110}},
          rotation=0)));
  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    use_p_in=false,
    p=system.p_ambient,
    T=293.15,
    nPorts=4) annotation (Placement(transformation(extent={{-88,-46},{-68,-26}},
          rotation=0)));
  Buildings.Fluid.FixedResistances.FixedResistanceDpM dpSta(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=dp_nominal) "Pressure drop"
    annotation (Placement(transformation(extent={{58,70},{78,90}})));
  replaceable Buildings.Fluid.Movers.BaseClasses.PartialFlowMachine floMacSta(
    redeclare package Medium = Medium,
    dynamicBalance=false,
    m_flow_nominal=1) constrainedby
    Buildings.Fluid.Movers.BaseClasses.PartialFlowMachine
    "Static model of a flow machine"
    annotation (Placement(transformation(extent={{20,70},{40,90}})));
  replaceable Buildings.Fluid.Movers.BaseClasses.PartialFlowMachine floMacDyn(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    dynamicBalance=true) constrainedby
    Buildings.Fluid.Movers.BaseClasses.PartialFlowMachine
    "Dynamic model of a flow machine"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Buildings.Fluid.FixedResistances.FixedResistanceDpM dpDyn(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=dp_nominal) "Pressure drop"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Modelica.Blocks.Math.Gain gain "Gain for input signal"
    annotation (Placement(transformation(extent={{-46,90},{-26,110}})));
equation
  connect(floMacSta.port_b, dpSta.port_a)
                                   annotation (Line(
      points={{40,80},{58,80}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(y.y, gain.u) annotation (Line(
      points={{-69,100},{-48,100}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sou.ports[1], floMacSta.port_a) annotation (Line(
      points={{-68,-33},{-14,-33},{-14,80},{20,80}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(dpSta.port_b, sou.ports[2]) annotation (Line(
      points={{78,80},{90,80},{90,48},{-10,48},{-10,-35},{-68,-35}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou.ports[3], floMacDyn.port_a) annotation (Line(
      points={{-68,-37},{-4,-37},{-4,6.10623e-16},{20,6.10623e-16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(floMacDyn.port_b, dpDyn.port_a) annotation (Line(
      points={{40,6.10623e-16},{50,-3.36456e-22},{50,6.10623e-16},{60,
          6.10623e-16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(dpDyn.port_b, sou.ports[4]) annotation (Line(
      points={{80,6.10623e-16},{90,6.10623e-16},{90,0},{100,0},{100,-40},{-20,
          -40},{-20,-39},{-68,-39}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{160,
            160}})),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{160,
            160}})),
    Documentation(info="<html>
This example demonstrates the use of a flow machine whose flow rate transitions to zero.
</html>"));
end FlowMachine_ZeroFlow;
