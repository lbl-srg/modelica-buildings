within Buildings.Fluid.Movers.Examples.BaseClasses;
partial model FlowMachine_ZeroFlow
  "Base class to test flow machines with zero flow rate"

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
    dp_nominal=dp_nominal/2) "Pressure drop"
    annotation (Placement(transformation(extent={{58,50},{78,70}})));
  replaceable Buildings.Fluid.Movers.BaseClasses.PartialFlowMachine floMacSta
                      constrainedby
    Buildings.Fluid.Movers.BaseClasses.PartialFlowMachine(
      redeclare package Medium = Medium,
      energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
      dynamicBalance=false) "Static model of a flow machine"
    annotation (Placement(transformation(extent={{20,50},{40,70}})));
  replaceable Buildings.Fluid.Movers.BaseClasses.PartialFlowMachine floMacDyn
    constrainedby Buildings.Fluid.Movers.BaseClasses.PartialFlowMachine(
      redeclare package Medium = Medium,
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Dynamic model of a flow machine"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Buildings.Fluid.FixedResistances.FixedResistanceDpM dpDyn(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=dp_nominal/2) "Pressure drop"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Modelica.Blocks.Math.Gain gain "Gain for input signal"
    annotation (Placement(transformation(extent={{-20,90},{0,110}})));
  Buildings.Fluid.FixedResistances.FixedResistanceDpM dpSta1(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=dp_nominal/2) "Pressure drop"
    annotation (Placement(transformation(extent={{-20,50},{0,70}})));
  Buildings.Fluid.FixedResistances.FixedResistanceDpM dpDyn1(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=dp_nominal/2) "Pressure drop"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Modelica.Blocks.Nonlinear.Limiter limiter(
    uMax=1E100,
    uMin=0,
    strict=true)
    "Limiter to avoid input signal to be slightly below 0 due to numerical error"
    annotation (Placement(transformation(extent={{-54,90},{-34,110}})));
equation
  connect(floMacSta.port_b, dpSta.port_a)
                                   annotation (Line(
      points={{40,60},{58,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(floMacDyn.port_b, dpDyn.port_a) annotation (Line(
      points={{40,6.10623e-16},{50,-3.36456e-22},{50,6.10623e-16},{60,
          6.10623e-16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(dpSta1.port_b, floMacSta.port_a) annotation (Line(
      points={{5.55112e-16,60},{20,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(dpDyn1.port_b, floMacDyn.port_a) annotation (Line(
      points={{5.55112e-16,6.10623e-16},{10,-3.36456e-22},{10,6.10623e-16},{20,
          6.10623e-16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(dpSta1.port_a, sou.ports[1]) annotation (Line(
      points={{-20,60},{-60,60},{-60,-33},{-68,-33}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(dpDyn1.port_a, sou.ports[2]) annotation (Line(
      points={{-20,6.10623e-16},{-52,6.10623e-16},{-52,-35},{-68,-35}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(dpDyn.port_b, sou.ports[3]) annotation (Line(
      points={{80,6.10623e-16},{96,6.10623e-16},{96,-37},{-68,-37}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(dpSta.port_b, sou.ports[4]) annotation (Line(
      points={{78,60},{100,60},{100,-39},{-68,-39}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(y.y, limiter.u) annotation (Line(
      points={{-69,100},{-56,100}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(limiter.y, gain.u) annotation (Line(
      points={{-33,100},{-22,100}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{160,
            160}}), graphics),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{160,
            160}})),
    Documentation(info="<html>
This example demonstrates the use of a flow machine whose flow rate transitions to zero.
</html>",
revisions="<html>
<ul>
<li>
October 1, 2014, by Michael Wetter:<br/>
Added limiter to avoid that the control signal is slighty below
zero due to numerical error. Without this limiter, OpenModelica stops
when running <code>Examples.FlowMachine_dp</code> with
an assert because <code>floMacDyn.dp_in</code> is <i>-1.7E-7</i> which
is below the minimum value for this variable.
</li>
<li>
March 24 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end FlowMachine_ZeroFlow;
