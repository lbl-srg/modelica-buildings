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
        origin={10,-90})));

  Buildings.Fluid.ZoneEquipment.Data.FCUSizing2 fCUSizing
    annotation (Placement(transformation(extent={{-140,60},{-120,80}})));

  Modelica.Blocks.Sources.CombiTimeTable datRea(
    tableOnFile=true,
    fileName=ModelicaServices.ExternalReferences.loadResource("./Buildings/Resources/Data/Fluid/ZoneEquipment/FanCoilAutoSize_ConstantFlowVariableFan.dat"),
    columns=2:15,
    tableName="EnergyPlus",
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments)
    "Reader for \"IndirectAbsorptionChiller.idf\" EnergyPlus example results"
    annotation (Placement(transformation(extent={{-140,-10},{-120,10}})));

  Sources.Boundary_pT souAir(
    redeclare package Medium = MediumA,
    use_Xi_in=false,
    p(displayUnit="Pa") = 101325 + 100,
    use_T_in=true,
    T=279.15,
    nPorts=1) "Source for air"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));

  Sources.Boundary_pT sinAir(
    redeclare package Medium = MediumA,
    p(displayUnit="Pa") = 101325 + 100,
    use_T_in=false,
    T=279.15,
    nPorts=1) "Sink for air"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(k=0.2)
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));

  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai(k=1/fCUSizing.mAir_flow_nominal)
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));

  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai1(k=1/fCUSizing.mChiWat_flow_nominal)
    annotation (Placement(transformation(extent={{-100,-50},{-80,-30}})));

  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai2(k=1/fCUSizing.mHotWat_flow_nominal)
    annotation (Placement(transformation(extent={{-100,-90},{-80,-70}})));

  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar[3](p=fill(273.15, 3))
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));

  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        ModelicaServices.ExternalReferences.loadResource(
        "./Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    annotation (Placement(transformation(extent={{-80,100},{-60,120}})));

  Modelica.Blocks.Sources.RealExpression TSupAir(y=datRea.y[4])
    "Supply air temperature"
    annotation (Placement(transformation(extent={{20,120},{40,140}})));
  Modelica.Blocks.Sources.RealExpression mSupAir_flow(y=datRea.y[11])
    "Supply air mass flowrate"
    annotation (Placement(transformation(extent={{60,120},{80,140}})));
  Modelica.Blocks.Sources.RealExpression TRetAir(y=datRea.y[5])
    "Return air temperature"
    annotation (Placement(transformation(extent={{20,90},{40,110}})));
  Modelica.Blocks.Sources.RealExpression mRetAir_flow(y=datRea.y[6])
    "Return air mass flowrate"
    annotation (Placement(transformation(extent={{60,90},{80,110}})));
  Modelica.Blocks.Sources.RealExpression uFan(y=datRea.y[6]/fCUSizing.mAir_flow_nominal)
    "Fan control signal"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));
  Modelica.Blocks.Sources.RealExpression uCoo(y=datRea.y[8]/fCUSizing.mChiWat_flow_nominal)
    "Cooling control signal"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
  Modelica.Blocks.Sources.RealExpression uHea(y=datRea.y[10]/fCUSizing.mHotWat_flow_nominal)
    "Heating control signal"
    annotation (Placement(transformation(extent={{100,60},{120,80}})));

  parameter Real ATot = 37.16
    "Area of zone";

  Results res(
    final A=ATot,
    PFan=fCU_singleLayer.fan.P + 0,
    PHea=fCU_singleLayer.heaCoiHHW.Q2_flow,
    PCooSen=fCU_singleLayer.cooCoiCHW.QSen2_flow,
    PCooLat=fCU_singleLayer.cooCoiCHW.QLat2_flow) "Results of the simulation";

  Results res_EPlus(
    final A=ATot,
    PFan=PFan.y,
    PHea=PHea.y,
    PCooSen=-PCoo.y,
    PCooLat=0);

  model Results "Model to store the results of the simulation"
    parameter Modelica.Units.SI.Area A "Floor area";
    input Modelica.Units.SI.Power PFan "Fan energy";
    input Modelica.Units.SI.Power PHea "Heating energy";
    input Modelica.Units.SI.Power PCooSen "Sensible cooling energy";
    input Modelica.Units.SI.Power PCooLat "Latent cooling energy";

    Real EFan(
      unit="J/m2",
      start=0,
      nominal=1E5,
      fixed=true) "Fan energy";
    Real EHea(
      unit="J/m2",
      start=0,
      nominal=1E5,
      fixed=true) "Heating energy";
    Real ECooSen(
      unit="J/m2",
      start=0,
      nominal=1E5,
      fixed=true) "Sensible cooling energy";
    Real ECooLat(
      unit="J/m2",
      start=0,
      nominal=1E5,
      fixed=true) "Latent cooling energy";
    Real ECoo(unit="J/m2") "Total cooling energy";
  equation

    A*der(EFan) = PFan;
    A*der(EHea) = PHea;
    A*der(ECooSen) = -PCooSen;
    A*der(ECooLat) = -PCooLat;
    ECoo = ECooSen + ECooLat;

  end Results;
  Modelica.Blocks.Sources.RealExpression PHea(y=datRea.y[1]) "Heating power"
    annotation (Placement(transformation(extent={{-140,130},{-120,150}})));
  Modelica.Blocks.Sources.RealExpression PCoo(y=datRea.y[2]) "Cooling power"
    annotation (Placement(transformation(extent={{-140,110},{-120,130}})));
  Modelica.Blocks.Sources.RealExpression PFan(y=datRea.y[3]) "Fan power"
    annotation (Placement(transformation(extent={{-140,90},{-120,110}})));
equation

  connect(fCU_singleLayer.port_CCW_outlet, sinCoo.ports[1]) annotation (Line(
        points={{2,-10},{2,-70},{40,-70}},        color={0,127,255}));

  connect(fCU_singleLayer.port_HHW_outlet, sinHea.ports[1]) annotation (Line(
        points={{-6,-10},{-6,-60},{-40,-60},{-40,-70}},      color={0,127,255}));

  connect(souCoo.ports[1], fCU_singleLayer.port_CCW_inlet) annotation (Line(
        points={{70,-70},{70,-60},{6,-60},{6,-10}}, color={0,127,255}));

  connect(souHea.ports[1], fCU_singleLayer.port_HHW_inlet)
    annotation (Line(points={{10,-80},{10,-74},{-2,-74},{-2,-10}},
                                                           color={0,127,255}));

  connect(souAir.ports[1], fCU_singleLayer.port_return) annotation (Line(points=
         {{20,30},{50,30},{50,0},{10,0}}, color={0,127,255}));

  connect(sinAir.ports[1], fCU_singleLayer.port_supply) annotation (Line(points=
         {{40,-30},{50,-30},{50,-4},{10,-4}}, color={0,127,255}));

  connect(con.y, fCU_singleLayer.uOA) annotation (Line(points={{-58,30},{-20,30},
          {-20,6},{-12,6}}, color={0,0,127}));

  connect(gai1.y, fCU_singleLayer.uCoo) annotation (Line(points={{-78,-40},{-70,
          -40},{-70,-2},{-12,-2}}, color={0,0,127}));

  connect(gai2.y, fCU_singleLayer.uHea) annotation (Line(points={{-78,-80},{-60,
          -80},{-60,-6},{-12,-6}}, color={0,0,127}));

  connect(addPar[1].y, souAir.T_in) annotation (Line(points={{-58,70},{-16,70},
          {-16,34},{-2,34}}, color={0,0,127}));

  connect(addPar[2].y, souHea.T_in) annotation (Line(points={{-58,70},{-16,70},{
          -16,-102},{6,-102}}, color={0,0,127}));

  connect(addPar[3].y, souCoo.T_in) annotation (Line(points={{-58,70},{-16,70},{
          -16,-120},{66,-120},{66,-92}},  color={0,0,127}));

  connect(weaDat.weaBus, fCU_singleLayer.weaBus) annotation (Line(
      points={{-60,110},{-8,110},{-8,8}},
      color={255,204,51},
      thickness=0.5));

  connect(datRea.y[5], addPar[1].u) annotation (Line(points={{-119,0},{-110,0},{
          -110,70},{-82,70}}, color={0,0,127}));
  connect(datRea.y[7], addPar[3].u) annotation (Line(points={{-119,0},{-110,0},{
          -110,70},{-82,70}}, color={0,0,127}));
  connect(datRea.y[9], addPar[2].u) annotation (Line(points={{-119,0},{-110,0},{
          -110,70},{-82,70}}, color={0,0,127}));
  connect(datRea.y[6], fCU_singleLayer.uFan) annotation (Line(points={{-119,0},{
          -106,0},{-106,18},{-80,18},{-80,2},{-12,2}}, color={0,0,127}));
  connect(datRea.y[8], gai1.u) annotation (Line(points={{-119,0},{-110,0},{-110,
          -40},{-102,-40}}, color={0,0,127}));
  connect(datRea.y[6], gai.u)
    annotation (Line(points={{-119,0},{-102,0}}, color={0,0,127}));
  connect(datRea.y[10], gai2.u) annotation (Line(points={{-119,0},{-110,0},{-110,
          -80},{-102,-80}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-160,
            -160},{160,160}})),                                  Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-160,-160},{160,
            160}})),
    experiment(
      StopTime=86400,
      Interval=60,
      __Dymola_Algorithm="Dassl"),
    __Dymola_Commands(file= "modelica://Buildings/Resources/Scripts/Dymola/Fluid/ZoneEquipment/FanCoilUsecase.mos"
      "Simulate and plot"));
end useCase_singleLayer;
