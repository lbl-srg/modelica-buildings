within Buildings.Fluid.Geothermal.ZonedBorefields.Examples;
model ParallelZonesWithHorizontalPipes
  "Parallel zoned borefield with horizontal plug-flow pipes and imbalanced zone loads"
  extends Modelica.Icons.Example;

  package Medium =
    Buildings.Media.Antifreeze.PropyleneGlycolWater(
      property_T=293.15,
      X_a=0.30)
    "Medium in the loop";

  parameter Buildings.Fluid.Geothermal.ZonedBorefields.Data.Configuration.Rectangle3Zones10Boreholes
    conDat
    "Borefield configuration data"
    annotation (Placement(transformation(extent={{74,68},{94,88}})));

  parameter Buildings.Fluid.Geothermal.ZonedBorefields.Data.Filling.Bentonite
    filDat
    "Borehole filling data"
    annotation (Placement(transformation(extent={{96,68},{116,88}})));

  parameter Buildings.Fluid.Geothermal.ZonedBorefields.Data.Soil.SandStone
    soiDat
    "Soil data"
    annotation (Placement(transformation(extent={{118,68},{138,88}})));

  parameter Buildings.Fluid.Geothermal.ZonedBorefields.Data.Borefield.Template
    borFieDat(
      filDat=filDat,
      soiDat=soiDat,
      conDat=conDat)
    "Borefield data"
    annotation (Placement(transformation(extent={{96,42},{116,62}})));

  final parameter Integer nZon=3
    "Number of zones";

  parameter Integer nSegBor(min=1)=8
    "Number of vertical segments in the boreholes";

  parameter Integer nSegPip(min=1)=4
    "Number of axial segments in each horizontal pipe";

  parameter Modelica.Units.SI.Temperature T_start=283.15
    "Initial temperature";

  parameter Modelica.Units.SI.MassFlowRate mZon_flow_nominal[nZon]=fill(2.5, nZon)
    "Nominal mass flow rate of each zone";

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=sum(mZon_flow_nominal)
    "Total nominal loop mass flow rate";

  parameter Modelica.Units.SI.HeatFlowRate qBor_flow_nominal=800
    "Nominal heat flow rate per borehole";

  parameter Modelica.Units.SI.HeatFlowRate QZon_flow_nominal[nZon]=fill(10*qBor_flow_nominal, nZon)
    "Nominal load per zone";

  parameter Modelica.Units.SI.Length lSupPip[nZon]={30,30,30}
    "Horizontal supply pipe length for each zone";

  parameter Modelica.Units.SI.Length lRetPip[nZon]={30,30,30}
    "Horizontal return pipe length for each zone";

  parameter Modelica.Units.SI.Length dhPip=0.05
    "Hydraulic diameter of horizontal pipes";

  parameter Modelica.Units.SI.Length dIns=0.05
    "Insulation thickness of horizontal pipes";

  parameter Modelica.Units.SI.ThermalConductivity kIns=0.028
    "Insulation thermal conductivity of horizontal pipes";

  parameter Modelica.Units.SI.Length thickness=0.0032
    "Horizontal pipe wall thickness";

  parameter Modelica.Units.SI.ThermalConductivity kPip=0.4
    "Horizontal pipe wall thermal conductivity";

  parameter Modelica.Units.SI.Density rhoPip=930
    "Horizontal pipe wall density";

  parameter Modelica.Units.SI.SpecificHeatCapacity cPip=2300
    "Horizontal pipe wall specific heat capacity";

  parameter Modelica.Units.SI.Length roughnessPip=0.001e-3
    "Horizontal pipe wall roughness";

  Buildings.Fluid.Geothermal.ZonedBorefields.OneUTube borFie(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    borFieDat=borFieDat,
    nSeg=nSegBor,
    TExt0_start=T_start,
    dT_dz=0,
    allowFlowReversal=false,
    computePressureDrop=true,
    use_detailedPressureDrop=true,
    fluidProperties=Buildings.Fluid.Types.FluidProperties.ActualTemperature,
    use_TDepRConv=true)
    "Zoned borefield with three parallel zones"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));

  Buildings.Fluid.Movers.Preconfigured.FlowControlled_m_flow pum(
    redeclare package Medium = Medium,
    T_start=T_start,
    allowFlowReversal=false,
    addPowerToMedium=false,
    use_riseTime=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=120000)
    "Circulation pump with positive flow direction only"
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));

  Modelica.Blocks.Sources.Constant mPum_flow(k=m_flow_nominal)
    "Pump mass flow rate"
    annotation (Placement(transformation(extent={{-120,20},{-100,40}})));

  Buildings.Fluid.HeatExchangers.HeaterCooler_u loa[nZon](
    redeclare each package Medium = Medium,
    each allowFlowReversal=false,
    each show_T=true,
    each energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    each T_start=T_start,
    m_flow_nominal=mZon_flow_nominal,
    m_flow(start=mZon_flow_nominal),
    each p_start=300000,
    Q_flow_nominal=QZon_flow_nominal,
    each dp_nominal=5000)
    "Imbalanced thermal loads, one per zone"
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));

  Buildings.Fluid.FixedResistances.PlugFlowPipeDiscretized supPip[nZon](
    redeclare each package Medium = Medium,
    each nSeg=nSegPip,
    final m_flow_nominal=mZon_flow_nominal,
    each dh=dhPip,
    final totLen=lSupPip,
    each dIns=dIns,
    each kIns=kIns,
    each thickness=thickness,
    each cPip=cPip,
    each rhoPip=rhoPip,
    each roughness=roughnessPip,
    each have_pipCap=true,
    each have_symmetry=true,
    each allowFlowReversal=false,
    each T_start_in=fill(T_start, nSegPip),
    each T_start_out=fill(T_start, nSegPip),
    each disableComputeFlowResistance=false,
    each use_detailedPressureDrop=true,
    each fluidProperties=Buildings.Fluid.Types.FluidProperties.ActualTemperature,
    each use_detailedHeatTransfer=true,
    each use_TDepRConv=true,
    each includePipeWallResistance=true,
    each kPip=kPip)
    "Horizontal supply pipes, one per zone"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort TZoneIn[nZon](
    redeclare each package Medium = Medium,
    each allowFlowReversal=false,
    m_flow_nominal=mZon_flow_nominal,
    each T_start=T_start,
    each tau=0)
    "Zone inlet temperatures"
    annotation (Placement(transformation(extent={{16,-10},{36,10}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort TZoneOut[nZon](
    redeclare each package Medium = Medium,
    each allowFlowReversal=false,
    m_flow_nominal=mZon_flow_nominal,
    each T_start=T_start,
    each tau=0)
    "Zone outlet temperatures"
    annotation (Placement(transformation(extent={{64,-10},{84,10}})));

  Buildings.Fluid.FixedResistances.PlugFlowPipeDiscretized retPip[nZon](
    redeclare each package Medium = Medium,
    each nSeg=nSegPip,
    final m_flow_nominal=mZon_flow_nominal,
    each dh=dhPip,
    final totLen=lRetPip,
    each dIns=dIns,
    each kIns=kIns,
    each thickness=thickness,
    each cPip=cPip,
    each rhoPip=rhoPip,
    each roughness=roughnessPip,
    each have_pipCap=true,
    each have_symmetry=true,
    each allowFlowReversal=false,
    each T_start_in=fill(T_start, nSegPip),
    each T_start_out=fill(T_start, nSegPip),
    each disableComputeFlowResistance=false,
    each use_detailedPressureDrop=true,
    each fluidProperties=Buildings.Fluid.Types.FluidProperties.ActualTemperature,
    each use_detailedHeatTransfer=true,
    each use_TDepRConv=true,
    each includePipeWallResistance=true,
    each kPip=kPip)
    "Horizontal return pipes, one per zone"
    annotation (Placement(transformation(extent={{94,-10},{114,10}})));

  Buildings.Fluid.Sources.Boundary_pT exp(
    redeclare package Medium = Medium,
    p=300000,
    T=T_start,
    nPorts=1)
    "Expansion vessel / pressure reference for the closed loop"
    annotation (Placement(transformation(extent={{-108,-50},{-88,-30}})));

  Buildings.HeatTransfer.Sources.FixedTemperature groSup[nZon,nSegPip](
    each T=T_start)
    "Ground temperature boundary for supply pipes"
    annotation (Placement(transformation(extent={{-26,40},{-6,60}})));

  Buildings.HeatTransfer.Sources.FixedTemperature groRet[nZon,nSegPip](
    each T=T_start)
    "Ground temperature boundary for return pipes"
    annotation (Placement(transformation(extent={{40.0,40.0},{60.0,60.0}},rotation = 0.0,origin = {0.0,0.0})));

  Modelica.Blocks.Sources.Sine sea(
    amplitude=1,
    f=1/(365*24*3600),
    offset=0)
    "Seasonal balanced load signal"
    annotation (Placement(transformation(extent={{-120,70},{-100,90}})));

  Modelica.Blocks.Sources.RealExpression uLoa1(y=sea.y)
    "Balanced seasonal load for zone 1"
    annotation (Placement(transformation(extent={{-90,70},{-70,90}})));

  Modelica.Blocks.Sources.RealExpression uLoa2(y=sea.y)
    "Imbalanced seasonal load for middle zone with less regeneration"
    annotation (Placement(transformation(extent={{-90,56},{-70,76}})));

  Modelica.Blocks.Sources.RealExpression uLoa3(y=sea.y)
    "Balanced seasonal load for zone 3"
    annotation (Placement(transformation(extent={{-90,42},{-70,62}})));

equation
  connect(mPum_flow.y, pum.m_flow_in)
    annotation (Line(points={{-99,30},{-80,30},{-80,12}}, color={0,0,127}));

  for i in 1:nZon loop
    connect(pum.port_b, loa[i].port_a)
      annotation (Line(points={{-70,0},{-50,0}}, color={0,127,255}));

    connect(loa[i].port_b, supPip[i].port_a)
      annotation (Line(points={{-30,0},{-10,0}}, color={0,127,255}));

    connect(supPip[i].port_b, TZoneIn[i].port_a)
      annotation (Line(points={{10,0},{16,0}}, color={0,127,255}));

    connect(TZoneIn[i].port_b, borFie.port_a[i])
      annotation (Line(points={{36,0},{40,0}}, color={0,127,255}));

    connect(borFie.port_b[i], TZoneOut[i].port_a)
      annotation (Line(points={{60,0},{64,0}}, color={0,127,255}));

    connect(TZoneOut[i].port_b, retPip[i].port_a)
      annotation (Line(points={{84,0},{94,0}}, color={0,127,255}));

    connect(retPip[i].port_b, pum.port_a)
      annotation (Line(points={{114,0},{130,0},{130,-60},{-110,-60},{-110,0},{-90,0}}, color={0,127,255}));
  end for;

  for i in 1:nZon loop
    for j in 1:nSegPip loop
      connect(groSup[i,j].port, supPip[i].heatPorts[j])
        annotation (Line(points={{-6,50},{0,50},{0,10}}, color={191,0,0}));

      connect(groRet[i,j].port, retPip[i].heatPorts[j])
        annotation (Line(points={{60,50},{86,50},{86,10},{104,10}}, color={191,0,0}));
    end for;
  end for;

  connect(exp.ports[1], pum.port_a)
    annotation (Line(points={{-88,-40},{-98,-40},{-98,0},{-90,0}}, color={0,127,255}));

  connect(uLoa1.y, loa[1].u)
    annotation (Line(points={{-69,80},{-60,80},{-60,6},{-52,6}}, color={0,0,127}));

  connect(uLoa2.y, loa[2].u)
    annotation (Line(points={{-69,66},{-60,66},{-60,6},{-52,6}}, color={0,0,127}));

  connect(uLoa3.y, loa[3].u)
    annotation (Line(points={{-69,52},{-60,52},{-60,6},{-52,6}}, color={0,0,127}));

  annotation (
    Diagram(coordinateSystem(extent={{-140,-100},{140,100}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})),
    experiment(StopTime=31536000, Tolerance=1e-6),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Geothermal/ZonedBorefields/Examples/ParallelZonesWithHorizontalPipes.mos"
      "Simulate and plot"),
    Documentation(info="<html>
<p>
This example combines a three-zone zoned borefield with horizontal distribution
pipes modeled using
<a href=\"modelica://Buildings.Fluid.FixedResistances.PlugFlowPipeDiscretized\">
Buildings.Fluid.FixedResistances.PlugFlowPipeDiscretized</a>.
</p>
<p>
The borefield consists of three parallel zones with ten boreholes per zone.
Each zone has its own horizontal supply and return pipe. The horizontal pipes
use the detailed pressure-drop and detailed heat-transfer options.
</p>
<p>
The loop is closed and driven by a flow-controlled pump with positive flow only.
The three zones are hydraulically connected in parallel through ideal common
supply and return headers.
</p>
<p>
The middle zone has an imbalanced seasonal load:
</p>
<pre>
uLoa2 = 0.6*uLoa1 - 0.25
</pre>
<p>
This gives the middle zone less regeneration and a larger net extraction over
the simulated year. As a result, the middle zone should show faster thermal
depletion than the two outer zones.
</p>
</html>", revisions="<html>
<ul>
<li>
August 2026, by Lone Meertens:<br/>
First implementation for testing zoned borefields with horizontal plug-flow
pipe connections, detailed pipe pressure drop, and detailed pipe heat transfer.
</li>
</ul>
</html>"));
end ParallelZonesWithHorizontalPipes;
