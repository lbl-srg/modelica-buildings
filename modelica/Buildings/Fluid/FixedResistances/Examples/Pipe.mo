within Buildings.Fluid.FixedResistances.Examples;
model Pipe "Test of a pipe with multiple segments"
  import Buildings;
  extends Modelica.Icons.Example;

  replaceable package Medium = Buildings.Media.ConstantPropertyLiquidWater;

  Modelica.Blocks.Sources.Constant PAtm(k=101325) annotation (Placement(
        transformation(extent={{40,60},{60,80}}, rotation=0)));

  Modelica.Blocks.Sources.Ramp P(
    duration=1,
    height=2*pip.dp_nominal,
    offset=101325 - pip.dp_nominal) annotation (Placement(transformation(extent={{-80,
            60},{-60,80}}, rotation=0)));
  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    use_p_in=true,
    T=273.15 + 50,
    nPorts=1) annotation (Placement(transformation(extent={{-40,20},{-20,40}},
          rotation=0)));
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    T=273.15 + 10,
    use_p_in=true,
    nPorts=1) annotation (Placement(transformation(extent={{56,20},{36,40}},
          rotation=0)));

  inner Modelica.Fluid.System system(p_ambient=101325) annotation (Placement(
        transformation(extent={{-80,-80},{-60,-60}}, rotation=0)));
  HeatTransfer.Sources.FixedTemperature TEnv(T=263.15)
    annotation (Placement(transformation(extent={{-20,60},{0,80}})));
  Buildings.Fluid.FixedResistances.Pipe pip(
    thicknessIns=0.01,
    lambdaIns=0.01,
    m_flow_nominal=10,
    redeclare package Medium = Medium,
    length=10)
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
equation

  connect(PAtm.y, sin.p_in) annotation (Line(points={{61,70},{70,70},{70,38},{
          58,38}}, color={0,0,127}));
  connect(P.y, sou.p_in) annotation (Line(points={{-59,70},{-52,70},{-52,38},{-42,
          38}}, color={0,0,127}));
  connect(sou.ports[1], pip.port_a) annotation (Line(
      points={{-20,30},{-5.55112e-16,30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pip.port_b, sin.ports[1]) annotation (Line(
      points={{20,30},{36,30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TEnv.port, pip.singleHeatPort) annotation (Line(
      points={{5.55112e-16,70},{10,70},{10,36}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/FixedResistances/Examples/Pipe.mos"
        "Simulate and plot"),
    Diagram(Text(
        extent=[-20, 58; 30, 44],
        style(color=3, rgbcolor={0,0,255}),
        string="nRes resistances  in series")));
end Pipe;
