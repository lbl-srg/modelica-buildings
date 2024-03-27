within Buildings.Fluid.Storage.PCM.Examples;
model test_mix
  MixingVolumes.BaseClasses.MixingVolumeHeatPort vol1(
    redeclare package Medium = Buildings.Media.Water,
    T_start=293.15,
    m_flow_nominal=2,
    V=0.5,
    nPorts=2) annotation (Placement(transformation(extent={{-20,0},{0,20}})));
  Sources.Boundary_pT                 bou(redeclare package Medium =
        Buildings.Media.Water, nPorts=1)
    "Boundary condition"
    annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={30,-30})));
  Sources.MassFlowSource_T                 HPCPum(
    T=293.15,
    redeclare package Medium = Buildings.Media.Water,
    use_m_flow_in=true,
    nPorts=1)           "Flow source"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Modelica.Blocks.Sources.Pulse pulse(amplitude=2, period=100)
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
  HeatTransfer.Sources.PrescribedTemperature           preTem
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));
  Modelica.Blocks.Sources.Constant const(k=25 + 273.15)
    annotation (Placement(transformation(extent={{-140,0},{-120,20}})));
  Modelica.Thermal.HeatTransfer.Components.Convection convection
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Modelica.Blocks.Sources.Constant const1(k=100)
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
equation
  connect(vol1.ports[1], bou.ports[1])
    annotation (Line(points={{-11,0},{-11,-30},{20,-30}}, color={0,127,255}));
  connect(HPCPum.ports[1], vol1.ports[2]) annotation (Line(points={{-40,-30},{
          -12,-30},{-12,0},{-9,0}}, color={0,127,255}));
  connect(pulse.y, HPCPum.m_flow_in) annotation (Line(points={{-79,-30},{-72,
          -30},{-72,-22},{-62,-22}}, color={0,0,127}));
  connect(const.y, preTem.T)
    annotation (Line(points={{-119,10},{-102,10}}, color={0,0,127}));
  connect(preTem.port, convection.solid)
    annotation (Line(points={{-80,10},{-60,10}}, color={191,0,0}));
  connect(convection.fluid, vol1.heatPort)
    annotation (Line(points={{-40,10},{-20,10}}, color={191,0,0}));
  connect(const1.y, convection.Gc)
    annotation (Line(points={{-79,50},{-50,50},{-50,20}}, color={0,0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=2000, __Dymola_Algorithm="Dassl"));
end test_mix;
