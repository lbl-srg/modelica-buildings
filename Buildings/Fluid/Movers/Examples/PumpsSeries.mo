within Buildings.Fluid.Movers.Examples;
model PumpsSeries "Two flow machines in series"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Water;

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=1
    "Nominal mass flow rate";

  Buildings.Fluid.Movers.SpeedControlled_y floMac1(
    redeclare package Medium = Medium,
    per(pressure(V_flow={0, m_flow_nominal/1000}, dp={2*4*1000, 0})),
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    "Model of a flow machine"
    annotation (Placement(transformation(extent={{-20,50},{0,70}})));

  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    use_p_in=false,
    p(displayUnit="Pa") = 300000,
    T=293.15,
    nPorts=1) annotation (Placement(transformation(extent={{-92,50},{-72,70}})));

  parameter Medium.ThermodynamicState state_start = Medium.setState_pTX(
      T=Medium.T_default,
      p=Medium.p_default,
      X=Medium.X_default) "Start state";
  parameter Modelica.Units.SI.Density rho_nominal=Medium.density(state_start)
    "Density, used to compute fluid mass";

  Buildings.Fluid.Movers.SpeedControlled_y floMac2(
    redeclare package Medium = Medium,
    per(pressure(V_flow={0, m_flow_nominal/1000}, dp={2*4*1000, 0})),
    inputType=Buildings.Fluid.Types.InputType.Constant,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    "Model of a flow machine"
    annotation (Placement(transformation(extent={{60,50},{80,70}})));
  Modelica.Blocks.Sources.Step const1(
    height=-1,
    offset=1,
    startTime=150)
    annotation (Placement(transformation(extent={{-40,80},{-20,100}})));
  Buildings.Fluid.Sources.Boundary_pT sou1(
    redeclare package Medium = Medium,
    use_p_in=false,
    p(displayUnit="Pa") = 300000 + 4000,
    T=293.15,
    nPorts=1) annotation (Placement(transformation(extent={{156,50},{136,70}})));
equation
  connect(const1.y, floMac1.y) annotation (Line(
      points={{-19,90},{-10.2,90},{-10.2,72}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(floMac1.port_b, floMac2.port_a) annotation (Line(
      points={{5.55112e-16,60},{60,60}},
      color={0,127,255}));
  connect(sou.ports[1], floMac1.port_a) annotation (Line(
      points={{-72,60},{-20,60}},
      color={0,127,255}));
  connect(floMac2.port_b, sou1.ports[1]) annotation (Line(
      points={{80,60},{136,60}},
      color={0,127,255}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{160,
            160}})),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Movers/Examples/PumpsSeries.mos"
        "Simulate and plot"),
    Documentation(info="<html>
This example tests the configuration of two flow machines that are installed in series.
Both flow machines start with full speed.
At <i>t=150</i> seconds, the speed of the flow machine on the left is reduced to zero.
As its speed is reduced, the mass flow rate is reduced. Note that even at zero input, the mass flow rate is non-zero,
but the pressure drop of the pump <code>floMac1.dp</code> is positive, which means that this pump has a flow resistance.
However, <code>flowMac2.dp</code> is always negative, as this pump has a constant control input of 1.
</html>", revisions="<html>
<ul>
<li>
April 2, 2015, by Filip Jorissen:<br/>
Set constant speed for pump using a <code>parameter</code>
instead of a <code>realInput</code>.
</li>
<li>
May 29, 2014, by Michael Wetter:<br/>
Removed undesirable annotation <code>Evaluate=true</code>.
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
end PumpsSeries;
