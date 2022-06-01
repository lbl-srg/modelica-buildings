within Buildings.Fluid.ZoneEquipment;
block useCase_singleLayer

  replaceable package MediumA = Buildings.Media.Air
    constrainedby Modelica.Media.Interfaces.PartialCondensingGases "Medium model for air";
  replaceable package MediumW = Buildings.Media.Water "Medium model for water";

  Fluid.Sources.Boundary_pT sinCoo(
    redeclare package Medium = MediumW,
    p=300000,
    T=279.15,
    nPorts=1) "Sink for cooling coil" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={40,-80})));
  Fluid.Sources.Boundary_pT sinHea(
    redeclare package Medium = MediumW,
    p=300000,
    T=318.15,
    nPorts=1) "Sink for heating coil" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-40,-80})));

  FCU_singleLayer fCU_singleLayer(
    heatingCoilType=Buildings.Fluid.ZoneEquipment.Types.heatingCoil.heatingHotWater,
    capacityControlMethod=Buildings.Fluid.ZoneEquipment.Types.capacityControl.multispeedCyclingFanConstantWater,
    dpAirTot_nominal(displayUnit="Pa") = 100,
    mAirOut_flow_nominal=fCUSizing.mAirOut_flow_nominal,
    redeclare package MediumA = MediumA,
    redeclare package MediumW = MediumW,
    mAir_flow_nominal=fCUSizing.mAir_flow_nominal,
    QHeaCoi_flow_nominal=13866,
    mHotWat_flow_nominal=fCUSizing.mHotWat_flow_nominal,
    dpHeaCoiAir_nominal=100,
    UAHeaCoi_nominal=fCUSizing.UAHeaCoi_nominal,
    minSpeRatCooCoi=1,
    dpCooCoiAir_nominal=100,
    mChiWat_flow_nominal=fCUSizing.mChiWat_flow_nominal,
    UACooCoi_nominal=fCUSizing.UACooCoiTot_nominal,
    dpCooCoiWat_nominal=100,
    redeclare Fluid.Movers.Data.Pumps.customFCUFan fanPer)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Sources.Boundary_pT       souCoo(
    redeclare package Medium = MediumW,
    p(displayUnit="Pa") = 300000 + 500,
    use_T_in=true,
    T=279.15,
    nPorts=1) "Source for cooling coil loop" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={70,-80})));
  Sources.Boundary_pT       souHea(
    redeclare package Medium = MediumW,
    p(displayUnit="Pa") = 300000 + 500,
    use_T_in=true,
    T=333.15,
    nPorts=1) "Source for heating coil" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-86})));
  Data.FCUSizing fCUSizing
    annotation (Placement(transformation(extent={{-140,60},{-120,80}})));
  Modelica.Blocks.Sources.CombiTimeTable datRea(
    tableOnFile=true,
    fileName=ModelicaServices.ExternalReferences.loadResource(
        "./Buildings/Resources/Data/Fluid/ZoneEquipment/FanCoil.dat"),
    columns=2:11,
    tableName="EnergyPlus",
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments)
    "Reader for \"IndirectAbsorptionChiller.idf\" EnergyPlus example results"
    annotation (Placement(transformation(extent={{-140,-10},{-120,10}})));

  Sources.Boundary_pT souAir(
    redeclare package Medium = MediumA,
    use_Xi_in=false,
    p(displayUnit="Pa") = 100000,
    use_T_in=true,
    T=279.15,
    nPorts=1) "Source for air"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));

  Sources.Boundary_pT sinAir(
    redeclare package Medium = MediumA,
    p(displayUnit="Pa") = 100000,
    use_T_in=false,
    T=279.15,
    nPorts=1) "Sink for air"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
  Controls.OBC.CDL.Continuous.Sources.Constant con(k=0)
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Controls.OBC.CDL.Continuous.Gain gai(k=1/fCUSizing.mAir_flow_nominal)
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Controls.OBC.CDL.Continuous.Gain gai1(k=1/fCUSizing.mChiWat_flow_nominal)
    annotation (Placement(transformation(extent={{-100,-50},{-80,-30}})));
  Controls.OBC.CDL.Continuous.Gain gai2(k=1/fCUSizing.mHotWat_flow_nominal)
    annotation (Placement(transformation(extent={{-100,-90},{-80,-70}})));
  Controls.OBC.CDL.Continuous.AddParameter addPar[3](p=fill(273.15, 3), k=fill(
        1, 3))
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        ModelicaServices.ExternalReferences.loadResource(
        "./Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    annotation (Placement(transformation(extent={{-80,100},{-60,120}})));
equation

  connect(fCU_singleLayer.port_CCW_outlet, sinCoo.ports[1]) annotation (Line(
        points={{2,-10},{2,-70},{40,-70}},        color={0,127,255}));
  connect(fCU_singleLayer.port_HHW_outlet, sinHea.ports[1]) annotation (Line(
        points={{-6,-10},{-6,-60},{-40,-60},{-40,-70}},      color={0,127,255}));
  connect(souCoo.ports[1], fCU_singleLayer.port_CCW_inlet) annotation (Line(
        points={{70,-70},{70,-60},{6,-60},{6,-10}}, color={0,127,255}));
  connect(souHea.ports[1], fCU_singleLayer.port_HHW_inlet)
    annotation (Line(points={{8.88178e-16,-76},{8.88178e-16,-54},{-2,-54},{-2,
          -10}},                                           color={0,127,255}));
  connect(souAir.ports[1], fCU_singleLayer.port_return) annotation (Line(points=
         {{20,30},{50,30},{50,0},{10,0}}, color={0,127,255}));
  connect(sinAir.ports[1], fCU_singleLayer.port_supply) annotation (Line(points=
         {{40,-30},{50,-30},{50,-4},{10,-4}}, color={0,127,255}));
  connect(con.y, fCU_singleLayer.uOA) annotation (Line(points={{-58,30},{-20,30},
          {-20,6},{-12,6}}, color={0,0,127}));
  connect(datRea.y[6], gai.u)
    annotation (Line(points={{-119,0},{-102,0}}, color={0,0,127}));
  connect(gai.y, fCU_singleLayer.uFan) annotation (Line(points={{-78,0},{-20,0},
          {-20,2},{-12,2}}, color={0,0,127}));
  connect(datRea.y[8], gai1.u) annotation (Line(points={{-119,0},{-110,0},{-110,
          -40},{-102,-40}}, color={0,0,127}));
  connect(gai1.y, fCU_singleLayer.uCoo) annotation (Line(points={{-78,-40},{-70,
          -40},{-70,-2},{-12,-2}}, color={0,0,127}));
  connect(datRea.y[10], gai2.u) annotation (Line(points={{-119,0},{-110,0},{
          -110,-80},{-102,-80}}, color={0,0,127}));
  connect(gai2.y, fCU_singleLayer.uHea) annotation (Line(points={{-78,-80},{-60,
          -80},{-60,-6},{-12,-6}}, color={0,0,127}));
  connect(datRea.y[5], addPar[1].u) annotation (Line(points={{-119,0},{-110,0},
          {-110,70},{-82,70}}, color={0,0,127}));
  connect(addPar[1].y, souAir.T_in) annotation (Line(points={{-58,70},{-16,70},
          {-16,34},{-2,34}}, color={0,0,127}));
  connect(datRea.y[9], addPar[2].u) annotation (Line(points={{-119,0},{-110,0},
          {-110,70},{-82,70}}, color={0,0,127}));
  connect(addPar[2].y, souHea.T_in) annotation (Line(points={{-58,70},{-16,70},
          {-16,-98},{-4,-98}}, color={0,0,127}));
  connect(datRea.y[7], addPar[3].u) annotation (Line(points={{-119,0},{-110,0},
          {-110,70},{-82,70}}, color={0,0,127}));
  connect(addPar[3].y, souCoo.T_in) annotation (Line(points={{-58,70},{-16,70},
          {-16,-102},{66,-102},{66,-92}}, color={0,0,127}));
  connect(weaDat.weaBus, fCU_singleLayer.weaBus) annotation (Line(
      points={{-60,110},{-8,110},{-8,8}},
      color={255,204,51},
      thickness=0.5));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-160,
            -160},{160,160}})),                                  Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-160,-160},{160,
            160}})),
    experiment(
      StopTime=86400,
      Interval=60,
      __Dymola_Algorithm="Dassl"));
end useCase_singleLayer;
