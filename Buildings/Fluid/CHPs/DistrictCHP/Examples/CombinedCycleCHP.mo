within Buildings.Fluid.CHPs.DistrictCHP.Examples;
model CombinedCycleCHP
  extends Modelica.Icons.Example;
  package MediumSte = Buildings.Media.Steam
    "Steam medium - Medium model for port_b (outlet)";
  package MediumWat =
      Buildings.Media.Specialized.Water.TemperatureDependentDensity
    "Water medium - Medium model for port_a (inlet)";

  Combined combinedCyclePowerPlant
    annotation (Placement(transformation(extent={{-20,-24},{20,24}})));
  Modelica.Blocks.Sources.CombiTimeTable LoadProfile(table=[0,1.0; 14400,1.0;
        28800,1.0; 43200,1.0; 57600,0.8; 72000,0.5; 86400,0.5])
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Modelica.Blocks.Sources.CombiTimeTable AmbientTemperature(table=[0.0,25;
        14400,25; 28800,25; 43200,23; 57600,22; 72000,23; 86400,25])
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = MediumWat,
    use_p_in=false,
    p=1100000,
    T=333.15,
    nPorts=1)
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Modelica.Fluid.Sources.FixedBoundary bou(
    redeclare package Medium = MediumSte,
    p=1000000,
    T=523.15,
    nPorts=1) "Boundary condition"
    annotation (Placement(transformation(extent={{80,-60},{60,-40}})));
  Modelica.Blocks.Continuous.Integrator mFuel(y(unit="kg/s"))
    "Mass flow of fuel consumption "
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
  Modelica.Blocks.Continuous.Integrator STG_Ele(y(unit="W"))
    "Steam turbine electrical energy generated"
    annotation (Placement(transformation(extent={{60,-20},{80,0}})));
  Modelica.Blocks.Continuous.Integrator GTG_Ele(y(unit="W"))
    "Gas turbine electrical energy generated"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
equation
  connect(combinedCyclePowerPlant.port_b, bou.ports[1]) annotation (Line(points=
         {{20,0},{40,0},{40,-50},{60,-50}}, color={0,127,255}));
  connect(LoadProfile.y[1], combinedCyclePowerPlant.y) annotation (Line(points=
          {{-59,70},{-40,70},{-40,20},{-24,20},{-24,19.2}}, color={0,0,127}));
  connect(AmbientTemperature.y[1], combinedCyclePowerPlant.TAmb)
    annotation (Line(points={{-59,10},{-60,10},{-60,9.6},{-24,9.6}}, color=
          {0,0,127}));
  connect(combinedCyclePowerPlant.PEle, GTG_Ele.u) annotation (Line(points={{22,
          18.24},{22,20},{40,20},{40,70},{58,70}},color={0,0,127}));
  connect(combinedCyclePowerPlant.PEle_ST, STG_Ele.u) annotation (Line(points={{22,9.6},
          {22,10},{52,10},{52,-10},{58,-10}},          color={0,0,127}));
  connect(combinedCyclePowerPlant.mFue, mFuel.u) annotation (Line(points={{22.4,
          15.36},{52,15.36},{52,30},{58,30}},
                                      color={0,0,127}));
  connect(combinedCyclePowerPlant.port_a, sou.ports[1]) annotation (Line(points=
         {{-20,0},{-38,0},{-38,-50},{-60,-50},{-60,-50}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end CombinedCycleCHP;
