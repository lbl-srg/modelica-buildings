within Buildings.Fluid.Movers.Examples;
model PumpsParallel "Two flow machines in parallel"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Water "Medium model";

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=1
    "Nominal mass flow rate";

  parameter Modelica.Units.SI.Density rho_nominal=1000
    "Density, used to compute fluid mass";

  Buildings.Fluid.FixedResistances.PressureDrop dpIn1(
    redeclare package Medium = Medium,
    dp_nominal=1000,
    m_flow_nominal=0.5*m_flow_nominal) "Pressure drop"
    annotation (Placement(transformation(extent={{-20,100},{0,120}})));
  Buildings.Fluid.Movers.SpeedControlled_y floMac1(
    redeclare package Medium = Medium,
    per(pressure(V_flow={0, m_flow_nominal/rho_nominal}, dp={2*4*1000, 0})),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Model of a flow machine"
    annotation (Placement(transformation(extent={{20,100},{40,120}})));

  Buildings.Fluid.FixedResistances.PressureDrop dpOut1(
    redeclare package Medium = Medium,
    dp_nominal=1000,
    m_flow_nominal=0.5*m_flow_nominal) "Pressure drop"
    annotation (Placement(transformation(extent={{58,100},{78,120}})));
  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    use_p_in=false,
    nPorts=2,
    T=293.15) annotation (Placement(transformation(extent={{-92,48},{-72,68}})));

  Buildings.Fluid.FixedResistances.PressureDrop dpIn(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=1000) "Pressure drop"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  Buildings.Fluid.FixedResistances.PressureDrop dpOut3(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=1000) "Pressure drop"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));

  Buildings.Fluid.FixedResistances.PressureDrop dpIn2(
    redeclare package Medium = Medium,
    dp_nominal=1000,
    m_flow_nominal=0.5*m_flow_nominal) "Pressure drop"
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
  Buildings.Fluid.Movers.SpeedControlled_y floMac2(
    redeclare package Medium = Medium,
    per(pressure(V_flow={0, m_flow_nominal/rho_nominal}, dp={2*4*1000, 0})),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    inputType=Buildings.Fluid.Types.InputType.Constant) "Model of a flow machine"
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
  Buildings.Fluid.FixedResistances.PressureDrop dpOut2(
    redeclare package Medium = Medium,
    dp_nominal=1000,
    m_flow_nominal=0.5*m_flow_nominal) "Pressure drop"
    annotation (Placement(transformation(extent={{58,0},{78,20}})));
  Modelica.Blocks.Sources.Step const1(
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
  connect(dpIn.port_b, dpIn2.port_a) annotation (Line(
      points={{-40,60},{-30,60},{-30,10},{-20,10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(dpOut2.port_b, dpOut3.port_a) annotation (Line(
      points={{78,10},{90,10},{90,60},{100,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(const1.y, floMac1.y) annotation (Line(
      points={{21,140},{29.8,140},{29.8,122}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{160,
            160}}), graphics),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Movers/Examples/PumpsParallel.mos"
        "Simulate and plot"),
    Documentation(info="<html>
This example tests the configuration of two flow machines that are installed in parallel.
Both flow machines start with full speed.
At <i>t=150</i> second, the speed of the flow machine on the top is reduced to zero.
As its speed is reduced, the mass flow rate changes its direction in such a way that the flow machine
at the top has reverse flow.
</html>", revisions="<html>
<ul>
<li>February 20, 2016, by Ruben Baetens:<br/>
Removal of <code>dynamicBalance</code> as parameter for <code>massDynamics</code> and <code>energyDynamics</code>.
</li>
<li>
April 2, 2015, by Filip Jorissen:<br/>
Set constant speed for pump using a <code>parameter</code>
instead of a <code>realInput</code>.
</li>
<li>
May 29, 2014, by Michael Wetter:<br/>
Removed undesirable annotation <code>Evaluate=true</code>,
and set <code>rho_nominal</code> to a constant to avoid a non-literal
nominal value for <code>V_flow_max</code> and <code>VMachine_flow</code>.
</li>
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
end PumpsParallel;
