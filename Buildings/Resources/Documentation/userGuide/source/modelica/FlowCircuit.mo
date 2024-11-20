within ;
model FlowCircuit
  //package Medium = Buildings.Media.IdealGases.SimpleAir;
  //package Medium = Buildings.Media.ConstantPropertyLiquidWater;
  //package Medium = Buildings.Media.GasesConstantDensity.SimpleAir;
 package Medium = Modelica.Media.Water.WaterIF97OnePhase_ph;
  Buildings.Fluid.Movers.SpeedControlled_y pump(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    use_strokeTime=false,
    m_flow_nominal=1)
    annotation (Placement(transformation(extent={{-20,10},{0,30}})));
  Buildings.Fluid.FixedResistances.PressureDrop res(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    dp_nominal=1000)
    annotation (Placement(transformation(extent={{20,10},{40,30}})));
  Buildings.Fluid.MixingVolumes.MixingVolume vol(nPorts=3,
    redeclare package Medium = Medium,
    m_flow_nominal=0.1,
    V=1)
    annotation (Placement(transformation(extent={{0,62},{20,82}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con(k=1)
    annotation (Placement(transformation(extent={{-50,30},{-30,50}})));
  Buildings.Fluid.Sources.Boundary_pT bou(nPorts=1)
    annotation (Placement(transformation(extent={{80,48},{60,68}})));
equation
  connect(pump.port_b, res.port_a) annotation (Line(
      points={{5.55112e-16,20},{20,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(con.y, pump.y)
    annotation (Line(points={{-28,40},{-10,40},{-10,32}}, color={0,0,127}));
  connect(pump.port_a, vol.ports[1]) annotation (Line(points={{-20,20},{-60,20},
          {-60,56},{7.33333,56},{7.33333,62}}, color={0,127,255}));
  connect(vol.ports[2], res.port_b) annotation (Line(points={{10,62},{10,56},{
          50,56},{50,20},{40,20}}, color={0,127,255}));
  connect(bou.ports[1], vol.ports[3]) annotation (Line(points={{60,58},{12.6667,
          58},{12.6667,62}}, color={0,127,255}));
  annotation (uses(Modelica(version="3.2.3"), Buildings(version="8.0.0")),
    version="1",
    conversion(noneFromVersion=""));
end FlowCircuit;
