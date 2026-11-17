within Buildings.Fluid.FixedResistances.Examples;
model PlugFlowPipePressureDrop
  "Example model for plug flow pipe with selectable pressure drop calculation"
  extends Modelica.Icons.Example;

  replaceable package Medium = Buildings.Media.Water
    "Medium in the pipe"
    annotation (choicesAllMatching=true);

  final parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=0.2
    "Nominal mass flow rate";

  Modelica.Blocks.Sources.Ramp mFlo(
    duration=1,
    height=0.18,
    offset=0.02)
    "Ramp mass flow rate"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));

  Buildings.Fluid.Sources.MassFlowSource_T souLos(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    T=293.15,
    nPorts=1)
    "Mass flow source for lossless pipe"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));

  Buildings.Fluid.Sources.MassFlowSource_T souNom(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    T=293.15,
    nPorts=1)
    "Mass flow source for nominal pressure drop pipe"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));

  Buildings.Fluid.Sources.MassFlowSource_T souDet(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    T=293.15,
    nPorts=1)
    "Mass flow source for detailed pressure drop pipe"
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));

  Buildings.Fluid.Sources.Boundary_pT sinLos(
    redeclare package Medium = Medium,
    T=293.15,
    p(displayUnit="Pa") = 300000,
    nPorts=1)
    "Pressure boundary condition for lossless pipe"
    annotation (Placement(transformation(extent={{100,50},{80,70}})));

  Buildings.Fluid.Sources.Boundary_pT sinNom(
    redeclare package Medium = Medium,
    T=293.15,
    p(displayUnit="Pa") = 300000,
    nPorts=1)
    "Pressure boundary condition for nominal pressure drop pipe"
    annotation (Placement(transformation(extent={{100,-10},{80,10}})));

  Buildings.Fluid.Sources.Boundary_pT sinDet(
    redeclare package Medium = Medium,
    T=293.15,
    p(displayUnit="Pa") = 300000,
    nPorts=1)
    "Pressure boundary condition for detailed pressure drop pipe"
    annotation (Placement(transformation(extent={{100,-70},{80,-50}})));

  Buildings.HeatTransfer.Sources.FixedTemperature bou[3](
    each T=293.15)
    "Boundary temperature"
    annotation (Placement(transformation(extent={{-10,80},{10,100}})));

  Buildings.Fluid.FixedResistances.PlugFlowPipe pipLos(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dh=0.027,
    length=1,
    dIns=0.05,
    kIns=0.028,
    cPip=500,
    thickness=0.0032,
    rhoPip=8000,
    have_pipCap=false,
    T_start_in=293.15,
    T_start_out=293.15,
    disableComputeFlowResistance=true,
    use_detailedPressureDrop=false,
    dp_nominal=0,
    kMinor=0,
    fluidProperties=Buildings.Fluid.Types.FluidProperties.DefaultTemperature,
    T_ref=293.15)
    "Plug flow pipe with lossless pressure drop option"
    annotation (Placement(transformation(extent={{10,50},{30,70}})));

  Buildings.Fluid.FixedResistances.PlugFlowPipe pipNom(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dh=0.027,
    length=1,
    dIns=0.05,
    kIns=0.028,
    cPip=500,
    thickness=0.0032,
    rhoPip=8000,
    have_pipCap=false,
    T_start_in=293.15,
    T_start_out=293.15,
    disableComputeFlowResistance=false,
    use_detailedPressureDrop=false,
    dp_nominal=50,
    n=2,
    from_dp=false,
    linearized=false,
    kMinor=0,
    fluidProperties=Buildings.Fluid.Types.FluidProperties.DefaultTemperature,
    T_ref=293.15)
    "Plug flow pipe with nominal pressure drop option"
    annotation (Placement(transformation(extent={{10.0,-10.0},{30.0,10.0}},rotation = 0.0,origin = {0.0,0.0})));

  Buildings.Fluid.FixedResistances.PlugFlowPipe pipDet(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dh=0.027,
    length=1,
    dIns=0.05,
    kIns=0.028,
    cPip=500,
    thickness=0.0032,
    rhoPip=8000,
    have_pipCap=false,
    T_start_in=293.15,
    T_start_out=293.15,
    disableComputeFlowResistance=false,
    use_detailedPressureDrop=true,
    kMinor=0,
    fluidProperties=Buildings.Fluid.Types.FluidProperties.DefaultTemperature,
    T_ref=293.15)
    "Plug flow pipe with detailed Darcy-Weisbach pressure drop option"
    annotation (Placement(transformation(extent={{10,-70},{30,-50}})));

equation
  connect(mFlo.y, souLos.m_flow_in)
    annotation (Line(points={{-79,0},{-70,0},{-70,68},{-62,68}},
                    color={0,0,127}));

  connect(mFlo.y, souNom.m_flow_in)
    annotation (Line(points={{-79,0},{-70,0},{-70,8},{-62,8}},
                    color={0,0,127}));

  connect(mFlo.y, souDet.m_flow_in)
    annotation (Line(points={{-79,0},{-70,0},{-70,-52},{-62,-52}},
                    color={0,0,127}));

  connect(souLos.ports[1], pipLos.port_a)
    annotation (Line(points={{-40,60},{10,60}},
                    color={0,127,255}));

  connect(pipLos.port_b, sinLos.ports[1])
    annotation (Line(points={{30,60},{80,60}},
                    color={0,127,255}));

  connect(souNom.ports[1], pipNom.port_a)
    annotation (Line(points={{-40,0},{10,0}},
                    color={0,127,255}));

  connect(pipNom.port_b, sinNom.ports[1])
    annotation (Line(points={{30,0},{80,0}},
                    color={0,127,255}));

  connect(souDet.ports[1], pipDet.port_a)
    annotation (Line(points={{-40,-60},{10,-60}},
                    color={0,127,255}));

  connect(pipDet.port_b, sinDet.ports[1])
    annotation (Line(points={{30,-60},{80,-60}},
                    color={0,127,255}));

  connect(bou[1].port, pipLos.heatPort)
    annotation (Line(points={{10,90},{20,90},{20,70}},
                    color={191,0,0}));

  connect(bou[2].port, pipNom.heatPort)
    annotation (Line(points={{10,90},{40,90},{40,20},{20,20},{20,10}},
                    color={191,0,0}));

  connect(bou[3].port, pipDet.heatPort)
    annotation (Line(points={{10,90},{40,90},{40,-40},{20,-40},{20,-50}},
                    color={191,0,0}));

  annotation (
    experiment(StopTime=1.0, Tolerance=1e-6),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/FixedResistances/Examples/PlugFlowPipePressureDrop.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Example model for
<a href=\"modelica://Buildings.Fluid.FixedResistances.PlugFlowPipe\">
Buildings.Fluid.FixedResistances.PlugFlowPipe</a>
with the selectable pressure drop implementation.
</p>
<p>
The example compares three configurations:
</p>
<ul>
<li>
<code>pipLos</code> disables pressure drop computation by setting
<code>disableComputeFlowResistance=true</code>.
</li>
<li>
<code>pipNom</code> uses the nominal pressure drop option by setting
<code>use_detailedPressureDrop=false</code> and specifying
<code>dp_nominal</code>.
</li>
<li>
<code>pipDet</code> uses the detailed Darcy-Weisbach option by setting
<code>use_detailedPressureDrop=true</code>.
</li>
</ul>
<p>
All three pipes have the same geometry and are driven by the same prescribed
mass flow rate. This allows direct comparison of the resulting pressure drops.
</p>
</html>", revisions="<html>
<ul>
<li>
August 7, 2026, by Lone Meertens:<br/>
First implementation for validating the selectable pressure drop options in
<a href=\"modelica://Buildings.Fluid.FixedResistances.PlugFlowPipe\">
Buildings.Fluid.FixedResistances.PlugFlowPipe</a>.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4687\">Buildings, #4687</a>.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-120,-100},{120,110}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end PlugFlowPipePressureDrop;
