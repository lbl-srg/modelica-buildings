within ;
model FlowCircuit
  //package Medium = Buildings.Media.IdealGases.SimpleAir;
  //package Medium = Buildings.Media.ConstantPropertyLiquidWater;
  //package Medium = Buildings.Media.GasesConstantDensity.SimpleAir;
 package Medium = Modelica.Media.Water.WaterIF97OnePhase_ph;
  Buildings.Fluid.Movers.SpeedControlled_y fan(
    dynamicBalance=false,
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    redeclare function flowCharacteristic =
        Buildings.Fluid.Movers.BaseClasses.Characteristics.linearFlow (
          data(V_flow_nominal={2e6,0}, dp_nominal={0,20000})))
    annotation (Placement(transformation(extent={{-20,10},{0,30}})));
  Buildings.Fluid.FixedResistances.PressureDrop res(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    dp_nominal=1000)
    annotation (Placement(transformation(extent={{20,10},{40,30}})));
  Buildings.Fluid.MixingVolumes.MixingVolume vol(nPorts=2,
    redeclare package Medium = Medium,
    m_flow_nominal=0.1,
    V=1)
    annotation (Placement(transformation(extent={{0,62},{20,82}})));
  Modelica.Blocks.Sources.Constant const(k=1)
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
equation
  connect(fan.port_b, res.port_a) annotation (Line(
      points={{5.55112e-16,20},{20,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(res.port_b, vol.ports[1]) annotation (Line(
      points={{40,20},{50,20},{50,56},{12,56},{12,62},{8,62}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(vol.ports[2], fan.port_a) annotation (Line(
      points={{12,62},{12,56},{-60,56},{-60,20},{-20,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(const.y, fan.y) annotation (Line(
      points={{-19,40},{-10,40},{-10,30}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (uses(Buildings(version="0.13"), Modelica(version="3.2")));
end FlowCircuit;
