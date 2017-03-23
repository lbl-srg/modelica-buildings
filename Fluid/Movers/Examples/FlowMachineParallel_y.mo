within Buildings.Fluid.Movers.Examples;
model FlowMachineParallel_y "Test model for two flow machines in parallel"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.ConstantPropertyLiquidWater;

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=
     1 "Nominal mass flow rate";

  Buildings.Fluid.FixedResistances.FixedResistanceDpM dpIn1(
    redeclare package Medium = Medium,
    dp_nominal=1000,
    m_flow_nominal=0.5*m_flow_nominal) "Pressure drop"
    annotation (Placement(transformation(extent={{-20,100},{0,120}})));
  Buildings.Fluid.Movers.FlowMachine_y floMac1(
    redeclare package Medium = Medium,
    pressure(V_flow={0, m_flow_nominal/1000}, dp={2*4*1000, 0}),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Model of a flow machine"
    annotation (Placement(transformation(extent={{20,100},{40,120}})));

  Buildings.Fluid.FixedResistances.FixedResistanceDpM dpOut1(
    redeclare package Medium = Medium,
    dp_nominal=1000,
    m_flow_nominal=0.5*m_flow_nominal) "Pressure drop"
    annotation (Placement(transformation(extent={{58,100},{78,120}})));
  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    use_p_in=false,
    nPorts=2,
    T=293.15) annotation (Placement(transformation(extent={{-92,48},{-72,68}},
          rotation=0)));

  Buildings.Fluid.FixedResistances.FixedResistanceDpM dpIn(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=1000) "Pressure drop"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  Buildings.Fluid.FixedResistances.FixedResistanceDpM dpOut3(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=1000) "Pressure drop"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));
  Modelica.Blocks.Sources.Constant const2(k=1)
    annotation (Placement(transformation(extent={{0,30},{20,50}})));

  parameter Medium.ThermodynamicState state_start = Medium.setState_pTX(
      T=Medium.T_default,
      p=Medium.p_default,
      X=Medium.X_default) "Start state";
  parameter Modelica.SIunits.Density rho_nominal=Medium.density(
     state_start) "Density, used to compute fluid mass"
                                           annotation (Evaluate=true);
  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{120,-80},{140,-60}})));
  Buildings.Fluid.FixedResistances.FixedResistanceDpM dpIn2(
    redeclare package Medium = Medium,
    dp_nominal=1000,
    m_flow_nominal=0.5*m_flow_nominal) "Pressure drop"
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
  Buildings.Fluid.Movers.FlowMachine_y floMac2(
    redeclare package Medium = Medium,
    pressure(V_flow={0, m_flow_nominal/1000}, dp={2*4*1000, 0}),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Model of a flow machine"
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
  Buildings.Fluid.FixedResistances.FixedResistanceDpM dpOut2(
    redeclare package Medium = Medium,
    dp_nominal=1000,
    m_flow_nominal=0.5*m_flow_nominal) "Pressure drop"
    annotation (Placement(transformation(extent={{58,0},{78,20}})));
  Modelica.Blocks.Sources.Step     const1(
    height=-1,
    offset=1,
    startTime=150)
    annotation (Placement(transformation(extent={{0,130},{20,150}})));
equation
  connect(dpIn1.port_b, floMac1.port_a) annotation (Line(
      points={{5.55112e-16,110},{20,110}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(floMac1.port_b, dpOut1.port_a) annotation (Line(
      points={{40,110},{58,110}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou.ports[1], dpIn.port_a) annotation (Line(
      points={{-72,60},{-60,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(dpIn.port_b, dpIn1.port_a) annotation (Line(
      points={{-40,60},{-30,60},{-30,110},{-20,110}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(dpOut1.port_b, dpOut3.port_a) annotation (Line(
      points={{78,110},{90,110},{90,60},{100,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(dpOut3.port_b, sou.ports[2]) annotation (Line(
      points={{120,60},{140,60},{140,-20},{-66,-20},{-66,56},{-72,56}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(dpIn2.port_b,floMac2. port_a) annotation (Line(
      points={{5.55112e-16,10},{20,10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(floMac2.port_b,dpOut2. port_a) annotation (Line(
      points={{40,10},{58,10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(const2.y, floMac2.y)
                              annotation (Line(
      points={{21,40},{30,40},{30,22}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dpIn.port_b, dpIn2.port_a) annotation (Line(
      points={{-40,60},{-30,60},{-30,10},{-20,10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(dpOut2.port_b, dpOut3.port_a) annotation (Line(
      points={{78,10},{90,10},{90,60},{100,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(const1.y, floMac1.y) annotation (Line(
      points={{21,140},{30,140},{30,122}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{160,
            160}})),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Movers/Examples/FlowMachineParallel_y.mos"
        "Simulate and plot"),
    Documentation(info="<html>
This example tests the configuration of two flow machines that are installed in parallel.
Both flow machines start with full speed. 
At <i>t=150</i> second, the speed of the flow machine on the top is reduced to zero.
As its speed is reduced, the mass flow rate changes its direction in such a way that the flow machine
at the top has reverse flow.
</html>", revisions="<html>
<ul>
<li>
February 14, 2012, by Michael Wetter:<br/>
Added filter for start-up and shut-down transient.
</li>
<li>
March 24 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    experiment(
      StopTime=300,
      Tolerance=1e-06));
end FlowMachineParallel_y;
