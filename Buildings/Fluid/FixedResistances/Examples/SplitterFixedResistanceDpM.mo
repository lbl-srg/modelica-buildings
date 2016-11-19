within Buildings.Fluid.FixedResistances.Examples;
model SplitterFixedResistanceDpM
  "Test model for the three way splitter/mixer model"
  extends Modelica.Icons.Example;

 package Medium = Buildings.Media.Air;

  Buildings.Fluid.FixedResistances.SplitterFixedResistanceDpM spl(
    m_flow_nominal={1,2,3},
    dh={1,2,3},
    redeclare package Medium = Medium,
    dp_nominal(each displayUnit="Pa") = {5,10,15},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial) "Splitter"
    annotation (Placement(transformation(extent={{-16,-10},{4,10}})));
  Buildings.Fluid.Sources.Boundary_pT bou1(
    redeclare package Medium = Medium,
    T=273.15 + 10,
    use_p_in=true,
    nPorts=1)
     annotation (Placement(transformation(extent={{-58,-10},{-38,10}})));
  Buildings.Fluid.Sources.Boundary_pT bou2(
    redeclare package Medium = Medium,
    T=273.15 + 20,
    use_p_in=true,
    nPorts=1)
    annotation (Placement(transformation(
          extent={{52,-10},{32,10}})));
  Buildings.Fluid.Sources.Boundary_pT bou3(
    redeclare package Medium = Medium,
    T=273.15 + 30,
    use_p_in=true,
    nPorts=1)
    annotation (Placement(transformation(
          extent={{-58,-66},{-38,-46}})));
    Modelica.Blocks.Sources.Constant P2(k=101325)
      annotation (Placement(transformation(extent={{40,54},{60,74}})));
    Modelica.Blocks.Sources.Ramp P1(
    offset=101320,
    height=10,
    duration=0.5)
    annotation (Placement(transformation(extent={{-100,-4},{-80,16}})));
    Modelica.Blocks.Sources.Ramp P3(
      offset=101320,
      height=10,
    duration=0.5,
    startTime=0.5)
    annotation (Placement(transformation(extent={{-100,-60},{-80,-40}})));
equation
  connect(P1.y, bou1.p_in)
    annotation (Line(points={{-79,6},{-74.25,6},{-69.5,6},{-69.5,8},{-60,8}},
                    color={0,0,127}));
  connect(P2.y, bou2.p_in) annotation (Line(points={{61,64},{74,64},{74,8},{54,
          8}}, color={0,0,127}));
  connect(bou3.p_in, P3.y)
    annotation (Line(points={{-60,-48},{-69.5,-48},{-69.5,-50},{-79,-50}},
                                                   color={0,0,127}));
  connect(bou1.ports[1], spl.port_1) annotation (Line(
      points={{-38,0},{-16,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(bou3.ports[1], spl.port_3) annotation (Line(
      points={{-38,-56},{-6,-56},{-6,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(spl.port_2, bou2.ports[1]) annotation (Line(
      points={{4,0},{32,0}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (experiment(StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/FixedResistances/Examples/SplitterFixedResistanceDpM.mos"
        "Simulate and plot"));
end SplitterFixedResistanceDpM;
