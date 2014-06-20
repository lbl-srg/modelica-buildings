within Buildings.Fluid.HeatExchangers.BaseClasses.Examples;
model Manifold "Test model for coil manifold"
 package Medium = Buildings.Media.ConstantPropertyLiquidWater;
  extends Modelica.Icons.Example;
 parameter Integer nPipPar = 3 "Number of parallel pipes";
 parameter Integer nPipSeg = 4 "Number of pipe segments";
    Modelica.Blocks.Sources.Constant POut(k=101325)
      annotation (Placement(transformation(extent={{60,72},{80,92}}, rotation=0)));
  Buildings.Fluid.Sources.Boundary_pT sin_1(                       redeclare
      package Medium = Medium,
    use_p_in=true,
    T=283.15,
    nPorts=2)             annotation (Placement(transformation(extent={{172,22},
            {152,42}}, rotation=0)));
  Buildings.Fluid.Sources.Boundary_pT sou_1(
    redeclare package Medium = Medium,
    use_p_in=true,
    use_T_in=true,
    p=101335,
    T=293.15,
    nPorts=2)             annotation (Placement(transformation(extent={{-60,22},
            {-40,42}}, rotation=0)));
    Fluid.FixedResistances.FixedResistanceDpM res_1(
    m_flow_nominal=5,
    redeclare package Medium = Medium,
    dp_nominal=10,
    use_dh=true,
    from_dp=false)
             annotation (Placement(transformation(extent={{120,24},{140,44}},
          rotation=0)));
  Buildings.Fluid.Sensors.MassFlowRate[nPipPar] mfr_1(redeclare each package
      Medium = Medium)
    annotation (Placement(transformation(extent={{30,24},{50,44}}, rotation=0)));
  Modelica.Blocks.Sources.Ramp TDb(
    height=1,
    duration=1,
    offset=293.15) annotation (Placement(transformation(extent={{-100,20},{-80,
            40}}, rotation=0)));
  Modelica.Blocks.Sources.Ramp P(
    duration=1,
    height=40,
    offset=101305) annotation (Placement(transformation(extent={{-100,60},{-80,
            80}}, rotation=0)));
  Buildings.Fluid.HeatExchangers.BaseClasses.PipeManifoldFixedResistance
    pipFixRes_1(
    redeclare package Medium = Medium,
    nPipPar=nPipPar,
    m_flow_nominal=5,
    dp_nominal=10,
    linearized=false,
    mStart_flow_a=5)
            annotation (Placement(transformation(extent={{-30,24},{-10,44}},
          rotation=0)));
  Buildings.Fluid.HeatExchangers.BaseClasses.PipeManifoldNoResistance
    pipNoRes_1(
      redeclare package Medium = Medium, nPipPar=nPipPar,
    mStart_flow_a=5)
    annotation (Placement(transformation(extent={{114,24},{94,44}}, rotation=0)));
    Fluid.FixedResistances.FixedResistanceDpM res_2(
    m_flow_nominal=5,
    redeclare package Medium = Medium,
    dp_nominal=10,
    use_dh=true,
    from_dp=false)
             annotation (Placement(transformation(extent={{122,-76},{142,-56}},
          rotation=0)));
  Buildings.Fluid.Sensors.MassFlowRate[nPipPar, nPipSeg] mfr_2(redeclare each
      package Medium =
               Medium)
    annotation (Placement(transformation(extent={{30,-76},{50,-56}}, rotation=0)));
  Buildings.Fluid.HeatExchangers.BaseClasses.DuctManifoldFixedResistance
    ducFixRes_2(
    redeclare package Medium = Medium,
    nPipPar=nPipPar,
    nPipSeg=nPipSeg,
    m_flow_nominal=5,
    linearized=false,
    mStart_flow_a=5,
    dp_nominal=10,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
            annotation (Placement(transformation(extent={{-32,-76},{-12,-56}},
          rotation=0)));
  Buildings.Fluid.HeatExchangers.BaseClasses.DuctManifoldNoResistance
    ducNoRes_2(
      redeclare package Medium = Medium,
      nPipPar=nPipPar,
      nPipSeg=nPipSeg,
    mStart_flow_a=5)
    annotation (Placement(transformation(extent={{116,-76},{96,-56}}, rotation=
            0)));
  Buildings.Fluid.HeatExchangers.BaseClasses.CoilHeader hea1(
      redeclare package Medium = Medium,
      nPipPar=nPipPar,
    mStart_flow_a=5) "Header for water-side heat exchanger register"
    annotation (Placement(transformation(extent={{0,24},{20,44}}, rotation=0)));
  Buildings.Fluid.HeatExchangers.BaseClasses.CoilHeader hea2(
      redeclare package Medium = Medium,
      nPipPar=nPipPar,
    mStart_flow_a=5) "Header for water-side heat exchanger register"
    annotation (Placement(transformation(extent={{60,24},{80,44}}, rotation=0)));
  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
equation
  connect(POut.y, sin_1.p_in) annotation (Line(
      points={{81,82},{178,82},{178,40},{174,40}},
      color={0,0,127},
      pattern=LinePattern.None));
  connect(TDb.y, sou_1.T_in) annotation (Line(points={{-79,30},{-72,30},{-72,36},
          {-62,36}}, color={0,0,127}));
  connect(P.y, sou_1.p_in) annotation (Line(points={{-79,70},{-72,70},{-72,40},
          {-62,40}}, color={0,0,127}));
  connect(res_1.port_a, pipNoRes_1.port_a)
    annotation (Line(points={{120,34},{114,34}}, color={0,127,255}));
  connect(res_2.port_a,ducNoRes_2. port_a)
    annotation (Line(points={{122,-66},{116,-66}}, color={0,127,255}));
  connect(pipFixRes_1.port_b, hea1.port_a) annotation (Line(points={{-10,34},{0,
          34}},               color={0,127,255}));
  connect(hea1.port_b, mfr_1.port_a)
    annotation (Line(points={{20,34},{30,34}}, color={0,127,255}));
  connect(mfr_1.port_b, hea2.port_a)
    annotation (Line(points={{50,34},{60,34}}, color={0,127,255}));
  connect(hea2.port_b, pipNoRes_1.port_b)
    annotation (Line(points={{80,34},{94,34}}, color={0,127,255}));
  connect(ducFixRes_2.port_b, mfr_2.port_a) annotation (Line(points={{-12,-66},
          {30,-66}}, color={0,127,255}));
  connect(mfr_2.port_b, ducNoRes_2.port_b) annotation (Line(points={{50,-66},{
          96,-66}}, color={0,127,255}));
  connect(sou_1.ports[1], pipFixRes_1.port_a) annotation (Line(
      points={{-40,34},{-30,34}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou_1.ports[2], ducFixRes_2.port_a) annotation (Line(
      points={{-40,30},{-38,30},{-38,-66},{-32,-66}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sin_1.ports[1], res_1.port_b) annotation (Line(
      points={{152,34},{140,34}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sin_1.ports[2], res_2.port_b) annotation (Line(
      points={{152,30},{148,30},{148,-66},{142,-66}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation(Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,
            -100},{180,100}})),
experiment(StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/BaseClasses/Examples/Manifold.mos"
        "Simulate and plot"));
end Manifold;
