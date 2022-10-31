within Buildings.Examples.DistrictReservoirNetworks.Examples;
model Reservoir3Variable_TOUGHCheckGround
  "Reservoir network with optimized controller"
  extends Modelica.Icons.Example;
  extends
    Buildings.Examples.DistrictReservoirNetworks.Examples.BaseClasses.RN_BaseModel_TOUGHCheckGround(
  datDes(
      mDisPip_flow_nominal=69.5,
      RDisPip=250,
      epsPla=0.91),
      pumpBHS(m_flow_nominal=0.5*datDes.mSto_flow_nominal));
  Networks.Controls.MainPump conMaiPum(
    nMix=3,
    nSou=2,
    TMin=279.15,
    TMax=290.15,
    use_temperatureShift=false)
    annotation (Placement(transformation(extent={{-20,-240},{0,-220}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gaiConMaiPum(
    final k=1.4*datDes.mDisPip_flow_nominal)
    "Gain for mass flow rate"
    annotation (Placement(transformation(extent={{18,-240},{38,-220}})));
  Modelica.Blocks.Sources.Constant massFlowMainPump(k(final unit="kg/s") = 0.5*
      datDes.mDisPip_flow_nominal)                    "Pump mass flow rate"
    annotation (Placement(transformation(extent={{0,-400},{20,-380}})));
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/Data/Examples/DistrictReservoirNetworks/Examples/CHE_Geneva.067000_IWEC.mos"))
    annotation (Placement(transformation(extent={{-250,-480},{-230,-460}})));
  BoundaryConditions.WeatherData.Bus weaBus "Weather Data Bus"
    annotation (Placement(transformation(extent={{-210,-480},{-190,-460}}),
        iconTransformation(extent={{-360,170},{-340,190}})));
  Modelica.Blocks.Routing.RealPassThrough TOut(y(
      final quantity="ThermodynamicTemperature",
      final unit="K",
      displayUnit="degC",
      min=0))
    annotation (Placement(transformation(extent={{-160,-480},{-140,-460}})));
  Controls.OBC.CDL.Continuous.Sources.Sine           sin1(
    amplitude=5,
    freqHz=1/(8760*3600),
    phase=0,
    offset=273.15 + 10,
    startTime=-270*24*3600)
                  "Sine source block"
    annotation (Placement(transformation(extent={{-160,-440},{-140,-420}})));
equation
  connect(Tml5.T, conMaiPum.TMix[1]) annotation (Line(points={{86.6,-100},{28,
          -100},{28,-182},{-36,-182},{-36,-224.667},{-22,-224.667}}, color={0,0,127},
      pattern=LinePattern.Dash));

  connect(Tml4.T, conMaiPum.TMix[2]) annotation (Line(points={{86.6,118},{26,118},
          {26,-180},{-30,-180},{-30,-224},{-22,-224}},      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(Tml3.T, conMaiPum.TMix[3]) annotation (Line(points={{-4.44089e-16,
          244.6},{-4.44089e-16,-38},{-32,-38},{-32,-222},{-28,-222},{-28,
          -223.333},{-22,-223.333}}, color={0,0,127},
      pattern=LinePattern.Dash));
  connect(Tml5.T, conMaiPum.TSouIn[1]) annotation (Line(points={{86.6,-100},{28,
          -100},{28,-182},{-36,-182},{-36,-230.5},{-22,-230.5}},
                                                             color={0,0,127},
      pattern=LinePattern.Dash));
  connect(Tml1.T, conMaiPum.TSouOut[1]) annotation (Line(points={{-86.6,-300},{
          -38,-300},{-38,-236.5},{-22,-236.5}},
                                            color={0,0,127},
      pattern=LinePattern.Dash));
  connect(Tml1.T, conMaiPum.TSouIn[2]) annotation (Line(points={{-86.6,-300},{
          -38,-300},{-38,-229.5},{-22,-229.5}},
                                            color={0,0,127},
      pattern=LinePattern.Dash));
  connect(conMaiPum.TSouOut[2], Tml2.T) annotation (Line(points={{-22,-235.5},{
          -60,-235.5},{-60,-94},{-86.6,-94}},
                                            color={0,0,127},
      pattern=LinePattern.Dash));
  connect(conMaiPum.y, gaiConMaiPum.u)
    annotation (Line(points={{2,-230},{16,-230}}, color={0,0,127},
      pattern=LinePattern.Dash));
  connect(pumpMainRLTN.m_flow_in, gaiConMaiPum.y) annotation (Line(points={{68,-370},
          {50,-370},{50,-230},{40,-230}},       color={0,0,127},
      pattern=LinePattern.Dash));
  connect(pumpBHS.m_flow_in, gaiConMaiPum.y)
    annotation (Line(points={{50,-428},{50,-230},{40,-230}}, color={0,0,127},
      pattern=LinePattern.Dash));
  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{-230,-470},{-200,-470}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(weaBus.TDryBul, TOut.u) annotation (Line(
      points={{-200,-470},{-162,-470}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(sin1.y, borFie.TOut) annotation (Line(points={{-138,-430},{-120,-430},
          {-120,-470},{20,-470},{20,-448},{10,-448}}, color={0,0,127}));
  annotation (
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-320,-480},{380,360}})),
          __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Examples/DistrictReservoirNetworks/Examples/Reservoir3Variable_TOUGH.mos"
        "Simulate and plot"),
    experiment(
      StopTime=31536000,
      __Dymola_NumberOfIntervals=8760,
      Tolerance=1e-06,
      __Dymola_Algorithm="Radau"));
end Reservoir3Variable_TOUGHCheckGround;
