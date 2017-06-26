within Buildings.ChillerWSE.Examples.BaseClasses;
model PartialChillerWSE
  "Partial examples for chillers and WSE configurations"
  extends Modelica.Icons.Example;


  Fluid.Sources.FixedBoundary           sin1(
    redeclare package Medium = Medium1,
    nPorts=1)                           annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        origin={90,-4})));
  Fluid.Sources.MassFlowSource_T           sou1(
    redeclare package Medium = Medium1,
    use_T_in=true,
    nPorts=1,
    m_flow=m1_flow_nominal,
    T=298.15)
    annotation (Placement(transformation(extent={{-60,-14},{-40,6}})));
  Modelica.Blocks.Sources.Ramp TCon_in(
    height=10,
    offset=273.15 + 20,
    duration=3600,
    startTime=2*3600) "Condenser inlet temperature"
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));
  Fluid.Sources.FixedBoundary           sin2(
    redeclare package Medium = Medium2,
    nPorts=1)                           annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        origin={-90,-70})));
  Fluid.Sources.Boundary_pT                sou2(
    redeclare package Medium = Medium2,
    use_T_in=true,
    nPorts=1,
    T=291.15)
    annotation (Placement(transformation(extent={{58,-84},{38,-64}})));
  Modelica.Blocks.Sources.Ramp TEva_in(
    offset=273.15 + 15,
    height=5,
    startTime=3600,
    duration=3600) "Evaporator inlet temperature"
    annotation (Placement(transformation(extent={{100,-80},{80,-60}})));
equation
  connect(TCon_in.y,sou1. T_in)
    annotation (Line(points={{-79,-10},{-72,-10},{-72,0},{-62,0}},
                                                   color={0,0,127}));
  connect(sou2.T_in, TEva_in.y)
    annotation (Line(points={{60,-70},{79,-70},{79,-70}}, color={0,0,127}));
end PartialChillerWSE;
