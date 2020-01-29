within Buildings.Examples.DistrictReservoirNetworks.Examples;
model Reservoir3Variable_StepCompare
  "Reservoir network with optimized controller"
  extends Modelica.Icons.Example;
  extends
    Buildings.Examples.DistrictReservoirNetworks.Examples.BaseClasses.RN_BaseModel_StepCompare(
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
equation
  connect(Tml5.T, conMaiPum.TMix[1]) annotation (Line(points={{86.6,-100},{28,
          -100},{28,-182},{-36,-182},{-36,-225.333},{-22,-225.333}}, color={0,0,
          127}));
  connect(Tml4.T, conMaiPum.TMix[2]) annotation (Line(points={{86.6,118},{26,118},
          {26,-180},{-30,-180},{-30,-224},{-22,-224}},      color={0,0,127}));
  connect(Tml3.T, conMaiPum.TMix[3]) annotation (Line(points={{-4.44089e-16,
          244.6},{-4.44089e-16,-38},{-32,-38},{-32,-222},{-28,-222},{-28,
          -222.667},{-22,-222.667}}, color={0,0,127}));
  connect(Tml5.T, conMaiPum.TSouIn[1]) annotation (Line(points={{86.6,-100},{28,
          -100},{28,-182},{-36,-182},{-36,-231},{-22,-231}}, color={0,0,127}));
  connect(Tml1.T, conMaiPum.TSouOut[1]) annotation (Line(points={{-86.6,-300},{-38,
          -300},{-38,-237},{-22,-237}},     color={0,0,127}));
  connect(Tml1.T, conMaiPum.TSouIn[2]) annotation (Line(points={{-86.6,-300},{-38,
          -300},{-38,-229},{-22,-229}},     color={0,0,127}));
  connect(conMaiPum.TSouOut[2], Tml2.T) annotation (Line(points={{-22,-235},{-60,
          -235},{-60,-94},{-86.6,-94}},     color={0,0,127}));
  connect(conMaiPum.y, gaiConMaiPum.u)
    annotation (Line(points={{2,-230},{16,-230}}, color={0,0,127}));
  connect(pumpMainRLTN.m_flow_in, gaiConMaiPum.y) annotation (Line(points={{68,-370},
          {50,-370},{50,-230},{40,-230}},       color={0,0,127}));
  connect(pumpBHS.m_flow_in, gaiConMaiPum.y)
    annotation (Line(points={{50,-428},{50,-230},{40,-230}}, color={0,0,127}));
  annotation (
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-320,-480},{380,360}})),
          __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Examples/DistrictReservoirNetworks/Examples/Reservoir3Variable_StepCompare.mos"
        "Simulate and plot"),
    experiment(
      StopTime=31536000,
      __Dymola_NumberOfIntervals=8760,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"));
end Reservoir3Variable_StepCompare;
