within Buildings.Fluid.CHPs.DistrictCHP.Examples;
model CombinedCycleCHP
  extends Modelica.Icons.Example;
  package MediumSte = Buildings.Media.Steam
    "Steam medium - Medium model for port_b (outlet)";
  package MediumWat =
      Buildings.Media.Specialized.Water.TemperatureDependentDensity
    "Water medium - Medium model for port_a (inlet)";

  Combined combinedCyclePowerPlant(botCycExp(steBoi(fixed_p_start=false)))
    annotation (Placement(transformation(extent={{-20,-20},{20,20}})));
  Modelica.Blocks.Sources.CombiTimeTable LoadProfile(table=[0,1.0; 14400,1.0;
        28800,1.0; 43200,1.0; 57600,0.8; 72000,0.5; 86400,0.5])
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Modelica.Blocks.Sources.CombiTimeTable AmbientTemperature(table=[0.0,25;
        14400,25; 28800,25; 43200,23; 57600,22; 72000,23; 86400,25])
    annotation (Placement(transformation(extent={{-80,-2},{-60,18}})));
  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = MediumWat,
    use_p_in=false,
    p=30000,
    T=504.475,
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
  connect(combinedCyclePowerPlant.port_b, bou.ports[1]) annotation (Line(points={{20,0},{
          40,0},{40,-50},{60,-50}},         color={0,127,255}));
  connect(LoadProfile.y[1], combinedCyclePowerPlant.y) annotation (Line(points={{-59,70},
          {-40,70},{-40,16},{-24,16}},                      color={0,0,127}));
  connect(AmbientTemperature.y[1], combinedCyclePowerPlant.TAmb)
    annotation (Line(points={{-59,8},{-24,8}},                       color=
          {0,0,127}));
  connect(combinedCyclePowerPlant.PEle, GTG_Ele.u) annotation (Line(points={{24,18},
          {40,18},{40,70},{58,70}},               color={0,0,127}));
  connect(combinedCyclePowerPlant.PEle_ST, STG_Ele.u) annotation (Line(points={{24,6},{
          52,6},{52,-10},{58,-10}},                    color={0,0,127}));
  connect(combinedCyclePowerPlant.mFue, mFuel.u) annotation (Line(points={{24,12},
          {52,12},{52,30},{58,30}},   color={0,0,127}));
  connect(combinedCyclePowerPlant.port_a, sou.ports[1]) annotation (Line(points={{-20,0},
          {-40,0},{-40,-50},{-60,-50}},                   color={0,127,255}));
  annotation (
    Icon(
      coordinateSystem(preserveAspectRatio=false)),
    Diagram(
      coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=86400,Tolerance=1E-6),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/CHPs/DistrictCHP/Examples/CombinedCycleCHP.mos"
  "Simulate and plot"),
    Documentation(info="<html>
  <p>
    This example model demonstrates the combined cycle CHP model <a href=\"Modelica://Buildings.Fluid.CHPs.DistrictCHP.Combined\">Buildings.Fluid.CHPs.DistrictCHP.Combined</a> can produce electricity from both gas turbine and steam turbine based on the gas turbine part load and the ambient temperature.
  </p>
</html>", revisions="<html>
<ul>
<li>
October 1, 2024, by Zhanwei He:<br/>
First implementation.
</li>
</ul>
</html>"));
end CombinedCycleCHP;
