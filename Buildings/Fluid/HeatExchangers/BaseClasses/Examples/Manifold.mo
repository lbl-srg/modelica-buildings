within Buildings.Fluid.HeatExchangers.BaseClasses.Examples;
model Manifold "Test model for coil manifold"
 package Medium1 = Buildings.Media.Water "Water";
 package Medium2 = Buildings.Media.Air "Air";
  extends Modelica.Icons.Example;
 parameter Integer nPipPar = 3 "Number of parallel pipes";
 parameter Integer nPipSeg = 4 "Number of pipe segments";
  Buildings.Fluid.Sources.Boundary_pT sin_1(
    nPorts=1,
    T=283.15,
    redeclare package Medium = Medium1)
                          annotation (Placement(transformation(extent={{170,24},
            {150,44}})));
  Buildings.Fluid.Sources.Boundary_pT sou_1(
    use_p_in=true,
    use_T_in=true,
    p=101335,
    T=293.15,
    nPorts=1,
    redeclare package Medium = Medium1)
                          annotation (Placement(transformation(extent={{-60,24},
            {-40,44}})));
    Fluid.FixedResistances.FixedResistanceDpM res_1(
    m_flow_nominal=5,
    use_dh=true,
    from_dp=false,
    dp_nominal=3000,
    redeclare package Medium = Medium1)
             annotation (Placement(transformation(extent={{120,24},{140,44}})));
  Buildings.Fluid.Sensors.MassFlowRate[nPipPar] mfr_1(redeclare package Medium
      = Medium1)
    annotation (Placement(transformation(extent={{30,24},{50,44}})));
  Modelica.Blocks.Sources.Ramp TDb(
    height=1,
    duration=1,
    offset=293.15) annotation (Placement(transformation(extent={{-100,26},{-80,
            46}})));
  Modelica.Blocks.Sources.Ramp P(
    duration=1,
    height=12E3,
    offset=3E5 - 6E3)
                   annotation (Placement(transformation(extent={{-100,60},{-80,
            80}})));
  Buildings.Fluid.HeatExchangers.BaseClasses.PipeManifoldFixedResistance
    pipFixRes_1(
    nPipPar=nPipPar,
    m_flow_nominal=5,
    linearized=false,
    mStart_flow_a=5,
    dp_nominal(displayUnit="Pa") = 3000,
    redeclare package Medium = Medium1)
            annotation (Placement(transformation(extent={{-30,24},{-10,44}})));
  Buildings.Fluid.HeatExchangers.BaseClasses.PipeManifoldNoResistance
    pipNoRes_1(                          nPipPar=nPipPar,
    mStart_flow_a=5,
    redeclare package Medium = Medium1)
    annotation (Placement(transformation(extent={{114,24},{94,44}})));
    Fluid.FixedResistances.FixedResistanceDpM res_2(
    m_flow_nominal=5,
    dp_nominal=10,
    use_dh=true,
    from_dp=false,
    redeclare package Medium = Medium2)
             annotation (Placement(transformation(extent={{120,-40},{140,-20}})));
  Buildings.Fluid.Sensors.MassFlowRate[nPipPar, nPipSeg] mfr_2(redeclare
      package Medium = Medium2)
    annotation (Placement(transformation(extent={{30,-40},{50,-20}})));
  Buildings.Fluid.HeatExchangers.BaseClasses.DuctManifoldFixedResistance
    ducFixRes_2(
    nPipPar=nPipPar,
    nPipSeg=nPipSeg,
    m_flow_nominal=5,
    linearized=false,
    mStart_flow_a=5,
    dp_nominal=10,
    redeclare package Medium = Medium2)
            annotation (Placement(transformation(extent={{-30,-40},{-10,-20}})));
  Buildings.Fluid.HeatExchangers.BaseClasses.DuctManifoldNoResistance
    ducNoRes_2(
      nPipPar=nPipPar,
      nPipSeg=nPipSeg,
    mStart_flow_a=5,
    redeclare package Medium = Medium2)
    annotation (Placement(transformation(extent={{114,-40},{94,-20}})));
  Buildings.Fluid.HeatExchangers.BaseClasses.CoilHeader hea1(
      nPipPar=nPipPar,
    mStart_flow_a=5,
    redeclare package Medium = Medium1)
    "Header for water-side heat exchanger register"
    annotation (Placement(transformation(extent={{0,24},{20,44}})));
  Buildings.Fluid.HeatExchangers.BaseClasses.CoilHeader hea2(
      nPipPar=nPipPar,
    mStart_flow_a=5,
    redeclare package Medium = Medium1)
    "Header for water-side heat exchanger register"
    annotation (Placement(transformation(extent={{60,24},{80,44}})));
  Buildings.Fluid.Sources.Boundary_pT sou_2(
    use_p_in=true,
    use_T_in=true,
    p=101335,
    T=293.15,
    nPorts=1,
    redeclare package Medium = Medium2)
                          annotation (Placement(transformation(extent={{-62,-40},
            {-42,-20}})));
  Buildings.Fluid.Sources.Boundary_pT sin_2(
    nPorts=1,
    T=283.15,
    redeclare package Medium = Medium2)
                          annotation (Placement(transformation(extent={{168,-40},
            {148,-20}})));
  Modelica.Blocks.Sources.Ramp P1(
    duration=1,
    height=40,
    offset=101305) annotation (Placement(transformation(extent={{-100,-32},{-80,
            -12}})));
equation
  connect(TDb.y, sou_1.T_in) annotation (Line(points={{-79,36},{-62,36},{-62,38}},
                     color={0,0,127}));
  connect(P.y, sou_1.p_in) annotation (Line(points={{-79,70},{-74,70},{-74,42},
          {-62,42}}, color={0,0,127}));
  connect(res_1.port_a, pipNoRes_1.port_a)
    annotation (Line(points={{120,34},{114,34}}, color={0,127,255}));
  connect(res_2.port_a,ducNoRes_2. port_a)
    annotation (Line(points={{120,-30},{114,-30}}, color={0,127,255}));
  connect(pipFixRes_1.port_b, hea1.port_a) annotation (Line(points={{-10,34},{0,
          34}},               color={0,127,255}));
  connect(hea1.port_b, mfr_1.port_a)
    annotation (Line(points={{20,34},{30,34}}, color={0,127,255}));
  connect(mfr_1.port_b, hea2.port_a)
    annotation (Line(points={{50,34},{60,34}}, color={0,127,255}));
  connect(hea2.port_b, pipNoRes_1.port_b)
    annotation (Line(points={{80,34},{94,34}}, color={0,127,255}));
  connect(ducFixRes_2.port_b, mfr_2.port_a) annotation (Line(points={{-10,-30},
          {30,-30}}, color={0,127,255}));
  connect(mfr_2.port_b, ducNoRes_2.port_b) annotation (Line(points={{50,-30},{
          94,-30}}, color={0,127,255}));
  connect(sou_1.ports[1], pipFixRes_1.port_a) annotation (Line(
      points={{-40,34},{-30,34}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sin_1.ports[1], res_1.port_b) annotation (Line(
      points={{150,34},{140,34}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TDb.y,sou_2. T_in) annotation (Line(points={{-79,36},{-76,36},{-76,
          -26},{-64,-26}},
                     color={0,0,127}));
  connect(sin_2.ports[1], res_2.port_b) annotation (Line(
      points={{148,-30},{140,-30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(P1.y, sou_2.p_in) annotation (Line(
      points={{-79,-22},{-64,-22}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sou_2.ports[1], ducFixRes_2.port_a) annotation (Line(
      points={{-42,-30},{-30,-30}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation(Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{180,100}}), graphics),
experiment(StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/BaseClasses/Examples/Manifold.mos"
        "Simulate and plot"));
end Manifold;
