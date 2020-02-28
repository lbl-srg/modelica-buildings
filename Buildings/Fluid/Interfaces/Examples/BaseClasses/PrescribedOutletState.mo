within Buildings.Fluid.Interfaces.Examples.BaseClasses;
partial model PrescribedOutletState "Test model for prescribed outlet state"

  replaceable package Medium = Buildings.Media.Air
     constrainedby Modelica.Media.Interfaces.PartialMedium  "Medium model";

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=0.1
    "Nominal mass flow rate";

  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    use_T_in=false,
    p(displayUnit="Pa"),
    T=293.15,
    nPorts=4) "Sink"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=180,origin={100,0})));
  Buildings.Fluid.Interfaces.PrescribedOutlet heaHigPow(
    redeclare package Medium = Medium,
    QMax_flow=1.0e10,
    mWatMax_flow = 0.001,
    m_flow_small=1E-4*abs(m_flow_nominal),
    show_T=true,
    m_flow_nominal=m_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Steady-state model of the heater with high capacity"
    annotation (Placement(transformation(extent={{-10,76},{10,96}})));
  Modelica.Blocks.Sources.CombiTimeTable setHeaHigPow(table=[
    0,    20.0, 0.012;
    120,  20.0, 0.012;
    500,  60.0, 0.020;
    800,  10.0, 0.005;
    1200, 30.0, 0.015],
    offset={273.15,0},
    smoothness = Modelica.Blocks.Types.Smoothness.ConstantSegments)
    "Setpoint heating and humidification"
    annotation (Placement(transformation(extent={{-60,110},{-40,130}})));
  Buildings.Fluid.Interfaces.PrescribedOutlet cooLimPow(
    redeclare package Medium = Medium,
    QMin_flow=-1000,
    mWatMin_flow = -0.001,
    m_flow_small=1E-4*abs(m_flow_nominal),
    show_T=true,
    m_flow_nominal=m_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Steady-state model of the cooler with limited capacity"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.CombiTimeTable setCooLimPow(table=[
    0,    20.0, 0.008;
    120,  20.0, 0.008;
    500,  15.0, 0.004;
    800,  60.0, 0.015;
    1200, 10.0, 0.002],
    offset={273.15,0},
    smoothness = Modelica.Blocks.Types.Smoothness.ConstantSegments)
    "Setpoint cooling and dehumidification"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  Buildings.Fluid.Interfaces.PrescribedOutlet heaCooUnl(
    redeclare package Medium = Medium,
    m_flow_small=1E-4*abs(m_flow_nominal),
    show_T=true,
    m_flow_nominal=m_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Steady-state model of the heater or cooler with unlimited capacity"
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
  Buildings.Fluid.Interfaces.PrescribedOutlet steSta(
    redeclare package Medium = Medium,
    m_flow_small=1E-4*abs(m_flow_nominal),
    show_T=true,
    m_flow_nominal=m_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    "Steady-state model of the heater or cooler with unlimited capacity"
    annotation (Placement(transformation(extent={{-10,-100},{10,-80}})));
  Modelica.Blocks.Sources.CombiTimeTable setHeaCooUnl(table=[
    0,    20.0, 0.012;
    120,  20.0, 0.012;
    500,  15.0, 0.008;
    800,  10.0, 0.005;
    1200, 30.0, 0.015],
    offset={273.15,0},
    smoothness = Modelica.Blocks.Types.Smoothness.ConstantSegments)
    "Setpoint cooling, heating, dehumidification and humidification"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Modelica.Blocks.Sources.Ramp m_flow(
    height=-2*m_flow_nominal,
    duration=100,
    offset=m_flow_nominal,
    startTime=1000) "Mass flow rate"
    annotation (Placement(transformation(extent={{-130,-2},{-110,18}})));
  Buildings.Fluid.Sources.MassFlowSource_T sou1(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    T=293.15,
    nPorts=1) "Flow source"
    annotation (Placement(transformation(extent={{-90,76},{-70,96}})));
  Buildings.Fluid.Sources.MassFlowSource_T sou2(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    T=293.15,
    nPorts=1) "Flow source"
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));
  Buildings.Fluid.Sources.MassFlowSource_T sou3(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    T=293.15,
    nPorts=1) "Flow source"
    annotation (Placement(transformation(extent={{-90,-70},{-70,-50}})));
  Buildings.Fluid.Sources.MassFlowSource_T sou4(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    T=293.15,
    nPorts=1) "Flow source"
    annotation (Placement(transformation(extent={{-90,-100},{-70,-80}})));
equation

  connect(m_flow.y, sou1.m_flow_in) annotation (Line(
      points={{-109,8},{-100,8},{-100,94},{-92,94}},
      color={0,0,127}));
  connect(m_flow.y, sou2.m_flow_in) annotation (Line(
      points={{-109,8},{-92,8}},
      color={0,0,127}));
  connect(m_flow.y, sou3.m_flow_in) annotation (Line(
      points={{-109,8},{-100,8},{-100,-52},{-92,-52}},
      color={0,0,127}));
  connect(sou1.ports[1], heaHigPow.port_a) annotation (Line(
      points={{-70,86},{-10,86}},
      color={0,127,255}));
  connect(sou2.ports[1], cooLimPow.port_a) annotation (Line(
      points={{-70,0},{-10,0}},
      color={0,127,255}));
  connect(sou3.ports[1], heaCooUnl.port_a) annotation (Line(
      points={{-70,-60},{-56,-60},{-40,-60},{-10,-60}},
      color={0,127,255}));
  connect(heaCooUnl.port_b, sin.ports[1]) annotation (Line(
      points={{10,-60},{50,-60},{50,-3},{90,-3}},
      color={0,127,255}));
  connect(cooLimPow.port_b, sin.ports[2]) annotation (Line(
      points={{10,0},{52,0},{52,-1},{90,-1}},
      color={0,127,255}));
  connect(heaHigPow.port_b, sin.ports[3]) annotation (Line(
      points={{10,86},{50,86},{50,1},{90,1}},
      color={0,127,255}));
  connect(m_flow.y, sou4.m_flow_in) annotation (Line(points={{-109,8},{-100,8},
          {-100,-82},{-92,-82}},color={0,0,127}));
  connect(sou4.ports[1], steSta.port_a) annotation (Line(points={{-70,-90},{-40,
          -90},{-10,-90}}, color={0,127,255}));
  connect(steSta.port_b, sin.ports[4]) annotation (Line(points={{10,-90},{54,-90},
          {54,3},{90,3}}, color={0,127,255}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,
            -120},{120,160}})),
    Documentation(info="<html>
<p>
Model that is used as the base class for models that
demonstrates the use of an ideal heater and an ideal cooler,
or an ideal humidifier and dehumidifier.
</p>
<p>
The model on the top has almost unlimited positive capacity (<code>Q_flow_nominal = 1.0e10</code> Watts),
and hence its outlet temperature always reaches the set points.
</p>
<p>
The model in the middle has a limited negative capacitiy (<code>Q_flow_nominal = 1000</code> Watts), and hence
its outlet state reaches only a limited value corresponding to its
maximum negative capacity.
</p>
<p>
The model at the bottom has unlimited capacity.
</p>
<p>
At <i>t=1000</i> second, the flow reverses its direction.
</p>
<p>
Each flow leg has the same mass flow rate. There are three mass flow sources
as using one source only would yield a nonlinear system of equations that
needs to be solved to determine the mass flow rate distribution.
</p>
</html>", revisions="<html>
<ul>
<li>
May 3, 2017, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end PrescribedOutletState;
