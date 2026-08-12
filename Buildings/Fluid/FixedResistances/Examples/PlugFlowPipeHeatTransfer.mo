within Buildings.Fluid.FixedResistances.Examples;
model PlugFlowPipeHeatTransfer
  "Example model for plug flow pipe with selectable heat-transfer calculation"
  extends Modelica.Icons.Example;

  replaceable package Medium =
    Buildings.Media.Antifreeze.PropyleneGlycolWater(
      property_T=293.15,
      X_a=0.40)
    "Medium in the pipe"
    annotation (choicesAllMatching=true);

  final parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=0.2
    "Nominal mass flow rate";

  final parameter Modelica.Units.SI.Length length=100
    "Pipe length";

  final parameter Modelica.Units.SI.Length dh=0.027
    "Actual inner pipe diameter";

  final parameter Modelica.Units.SI.Length thickness=0.0032
    "Pipe wall thickness";

  final parameter Modelica.Units.SI.Length dIns=0.05
    "Insulation thickness";

  final parameter Modelica.Units.SI.ThermalConductivity kIns=0.028
    "Insulation thermal conductivity";

  final parameter Modelica.Units.SI.ThermalConductivity kPip=15
    "Pipe wall thermal conductivity";

  final parameter Modelica.Units.SI.Height roughness=2.5e-5
    "Pipe wall roughness";

  Modelica.Blocks.Sources.Ramp mFlo(
    duration=600,
    height=0.16,
    offset=0.04)
    "Ramp mass flow rate"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));

  Buildings.Fluid.Sources.MassFlowSource_T souEqu(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    T=313.15,
    nPorts=1)
    "Mass flow source for pipe with equivalent diameter heat transfer"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));

  Buildings.Fluid.Sources.MassFlowSource_T souGeoNoWal(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    T=313.15,
    nPorts=1)
    "Mass flow source for pipe with geometry-based heat transfer without pipe wall resistance"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));

  Buildings.Fluid.Sources.MassFlowSource_T souGeoWal(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    T=313.15,
    nPorts=1)
    "Mass flow source for pipe with geometry-based heat transfer including pipe wall resistance"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));

  Buildings.Fluid.Sources.MassFlowSource_T souGeoWalTDep(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    T=313.15,
    nPorts=1)
    "Mass flow source for pipe with geometry-based temperature-dependent heat transfer"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));

  Buildings.Fluid.Sources.Boundary_pT sinEqu(
    redeclare package Medium = Medium,
    T=293.15,
    p(displayUnit="Pa")=300000,
    nPorts=1)
    "Pressure boundary condition"
    annotation (Placement(transformation(extent={{120,70},{100,90}})));

  Buildings.Fluid.Sources.Boundary_pT sinGeoNoWal(
    redeclare package Medium = Medium,
    T=293.15,
    p(displayUnit="Pa")=300000,
    nPorts=1)
    "Pressure boundary condition"
    annotation (Placement(transformation(extent={{120,20},{100,40}})));

  Buildings.Fluid.Sources.Boundary_pT sinGeoWal(
    redeclare package Medium = Medium,
    T=293.15,
    p(displayUnit="Pa")=300000,
    nPorts=1)
    "Pressure boundary condition"
    annotation (Placement(transformation(extent={{120,-30},{100,-10}})));

  Buildings.Fluid.Sources.Boundary_pT sinGeoWalTDep(
    redeclare package Medium = Medium,
    T=293.15,
    p(displayUnit="Pa")=300000,
    nPorts=1)
    "Pressure boundary condition"
    annotation (Placement(transformation(extent={{120,-80},{100,-60}})));

  Buildings.HeatTransfer.Sources.FixedTemperature bou[4](
    each T=283.15)
    "Boundary temperature representing ambient or ground coupling"
    annotation (Placement(transformation(extent={{-44.0,100.0},{-24.0,120.0}},rotation = 0.0,origin = {0.0,0.0})));

  Buildings.Fluid.FixedResistances.PlugFlowPipe pipEqu(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    v_nominal=1.5,
    length=length,
    dIns=dIns,
    kIns=kIns,
    cPip=500,
    thickness=thickness,
    rhoPip=8000,
    have_pipCap=false,
    T_start_in=313.15,
    T_start_out=313.15,
    disableComputeFlowResistance=true,
    use_detailedPressureDrop=false,
    use_detailedHeatTransfer=false)
    "Legacy heat-transfer calculation using equivalent diameter from nominal conditions"
    annotation (Placement(transformation(extent={{-20,70},{0,90}})));

  Buildings.Fluid.FixedResistances.PlugFlowPipe pipGeoNoWal(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dh=dh,
    length=length,
    dIns=dIns,
    kIns=kIns,
    cPip=500,
    thickness=thickness,
    rhoPip=8000,
    have_pipCap=false,
    T_start_in=313.15,
    T_start_out=313.15,
    disableComputeFlowResistance=true,
    use_detailedPressureDrop=false,
    use_detailedHeatTransfer=true,
    use_TDepRConv=false,
    includePipeWallResistance=false,
    kPip=kPip,
    roughness=roughness)
    "Geometry-based heat transfer without pipe wall resistance and without temperature-dependent convection"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));

  Buildings.Fluid.FixedResistances.PlugFlowPipe pipGeoWal(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dh=dh,
    length=length,
    dIns=dIns,
    kIns=kIns,
    cPip=500,
    thickness=thickness,
    rhoPip=8000,
    have_pipCap=false,
    T_start_in=313.15,
    T_start_out=313.15,
    disableComputeFlowResistance=true,
    use_detailedPressureDrop=false,
    use_detailedHeatTransfer=true,
    use_TDepRConv=false,
    includePipeWallResistance=true,
    kPip=kPip,
    roughness=roughness)
    "Geometry-based heat transfer with pipe wall resistance and without temperature-dependent convection"
    annotation (Placement(transformation(extent={{-20,-30},{0,-10}})));

  Buildings.Fluid.FixedResistances.PlugFlowPipe pipGeoWalTDep(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dh=dh,
    length=length,
    dIns=dIns,
    kIns=kIns,
    cPip=500,
    thickness=thickness,
    rhoPip=8000,
    have_pipCap=false,
    T_start_in=313.15,
    T_start_out=313.15,
    disableComputeFlowResistance=true,
    use_detailedPressureDrop=false,
    use_detailedHeatTransfer=true,
    use_TDepRConv=true,
    includePipeWallResistance=true,
    kPip=kPip,
    roughness=roughness)
    "Geometry-based heat transfer with pipe wall resistance and temperature-dependent convection"
    annotation (Placement(transformation(extent={{-20,-80},{0,-60}})));

equation
  connect(mFlo.y, souEqu.m_flow_in)
    annotation (Line(points={{-99,0},{-90,0},{-90,88},{-82,88}},
      color={0,0,127}));

  connect(mFlo.y, souGeoNoWal.m_flow_in)
    annotation (Line(points={{-99,0},{-90,0},{-90,38},{-82,38}},
      color={0,0,127}));

  connect(mFlo.y, souGeoWal.m_flow_in)
    annotation (Line(points={{-99,0},{-90,0},{-90,-12},{-82,-12}},
      color={0,0,127}));

  connect(mFlo.y, souGeoWalTDep.m_flow_in)
    annotation (Line(points={{-99,0},{-90,0},{-90,-62},{-82,-62}},
      color={0,0,127}));

  connect(souEqu.ports[1], pipEqu.port_a)
    annotation (Line(points={{-60,80},{-20,80}}, color={0,127,255}));

  connect(pipEqu.port_b, sinEqu.ports[1])
    annotation (Line(points={{0,80},{100,80}}, color={0,127,255}));

  connect(souGeoNoWal.ports[1], pipGeoNoWal.port_a)
    annotation (Line(points={{-60,30},{-20,30}}, color={0,127,255}));

  connect(pipGeoNoWal.port_b, sinGeoNoWal.ports[1])
    annotation (Line(points={{0,30},{100,30}}, color={0,127,255}));

  connect(souGeoWal.ports[1], pipGeoWal.port_a)
    annotation (Line(points={{-60,-20},{-20,-20}}, color={0,127,255}));

  connect(pipGeoWal.port_b, sinGeoWal.ports[1])
    annotation (Line(points={{0,-20},{100,-20}}, color={0,127,255}));

  connect(souGeoWalTDep.ports[1], pipGeoWalTDep.port_a)
    annotation (Line(points={{-60,-70},{-20,-70}}, color={0,127,255}));

  connect(pipGeoWalTDep.port_b, sinGeoWalTDep.ports[1])
    annotation (Line(points={{0,-70},{100,-70}}, color={0,127,255}));

  connect(bou[1].port, pipEqu.heatPort)
    annotation (Line(points={{-24,110},{-10,110},{-10,90}}, color={191,0,0}));

  connect(bou[2].port, pipGeoNoWal.heatPort)
    annotation (Line(points={{-24,110},{20,110},{20,50},{-10,50},{-10,40}},
      color={191,0,0}));

  connect(bou[3].port, pipGeoWal.heatPort)
    annotation (Line(points={{-24,110},{20,110},{20,0},{-10,0},{-10,-10}},
      color={191,0,0}));

  connect(bou[4].port, pipGeoWalTDep.heatPort)
    annotation (Line(points={{-24,110},{20,110},{20,-50},{-10,-50},{-10,-60}},
      color={191,0,0}));

  annotation (
    experiment(StopTime=3600, Tolerance=1e-6),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/FixedResistances/Examples/PlugFlowPipeHeatTransfer.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Example model for
<a href=\"modelica://Buildings.Fluid.FixedResistances.PlugFlowPipe\">
Buildings.Fluid.FixedResistances.PlugFlowPipe</a>
with selectable heat-transfer calculation.
</p>
<p>
The example compares four configurations:
</p>
<ul>
<li>
<code>pipEqu</code> uses the legacy heat-transfer resistance based on the
equivalent hydraulic diameter computed from nominal mass flow rate and nominal
velocity.
</li>
<li>
<code>pipGeoNoWal</code> computes the heat-transfer resistance from pipe
geometry, including internal convection and insulation resistance, but without
pipe wall resistance and without temperature-dependent convection properties.
</li>
<li>
<code>pipGeoWal</code> computes the heat-transfer resistance from pipe geometry,
including internal convection, pipe wall resistance and insulation resistance,
but without temperature-dependent convection properties.
</li>
<li>
<code>pipGeoWalTDep</code> computes the heat-transfer resistance from pipe
geometry, including internal convection, pipe wall resistance and insulation
resistance, with temperature-dependent fluid properties for the internal
convection resistance.
</li>
</ul>
<p>
The external thermal boundary is represented by a fixed temperature connected to
the pipe heat port. More detailed buried-pipe or ground-coupling models can be
connected to the same heat port.
</p>
</html>", revisions="<html>
<ul>
<li>
August 2026, by Lone Meertens:<br/>
First implementation for validating the selectable detailed heat-transfer
options in plug-flow pipe models.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4687\">Buildings, #4687</a>.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-140,-110},{140,130}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end PlugFlowPipeHeatTransfer;
