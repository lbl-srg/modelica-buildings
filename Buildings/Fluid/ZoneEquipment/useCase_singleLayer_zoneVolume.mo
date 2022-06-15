within Buildings.Fluid.ZoneEquipment;
block useCase_singleLayer_zoneVolume

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
        origin={40,-110})));

  Fluid.Sources.Boundary_pT sinHea(
    redeclare package Medium = MediumW,
    p=300000,
    T=318.15,
    nPorts=1) "Sink for heating coil" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-40,-110})));

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
    use_T_in=false,
    T=280.37,
    nPorts=1) "Source for cooling coil loop" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={70,-110})));

  Sources.Boundary_pT       souHea(
    redeclare package Medium = MediumW,
    p(displayUnit="Pa") = 300000 + 500,
    use_T_in=false,
    T=355.15,
    nPorts=1) "Source for heating coil" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={10,-110})));

  Data.FCUSizing fCUSizing
    annotation (Placement(transformation(extent={{-140,40},{-120,60}})));

  Modelica.Blocks.Sources.CombiTimeTable datRea(
    tableOnFile=true,
    fileName=ModelicaServices.ExternalReferences.loadResource("./Buildings/Resources/Data/Fluid/ZoneEquipment/FanCoilAutoSize_ConstantFlowVariableFan.dat"),
    columns=2:15,
    tableName="EnergyPlus",
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments)
    "Reader for \"IndirectAbsorptionChiller.idf\" EnergyPlus example results"
    annotation (Placement(transformation(extent={{-140,-10},{-120,10}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(k=0)
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));

  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai(k=1/fCUSizing.mAir_flow_nominal)
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));

  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai1(k=1/fCUSizing.mChiWat_flow_nominal)
    annotation (Placement(transformation(extent={{-100,-50},{-80,-30}})));

  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai2(k=1/fCUSizing.mHotWat_flow_nominal)
    annotation (Placement(transformation(extent={{-100,-90},{-80,-70}})));

  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar[3](p=fill(273.15, 3))
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));

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
    annotation (Placement(transformation(extent={{100,120},{120,140}})));
  ThermalZones.EnergyPlus_9_6_0.ThermalZone zon(
    zoneName="West Zone",
    redeclare package Medium = MediumA,
    nPorts=2) annotation (Placement(transformation(extent={{60,-10},{100,30}})));
  inner ThermalZones.EnergyPlus_9_6_0.Building building(
    idfName=Modelica.Utilities.Files.loadResource("./Buildings/Resources/Data/Fluid/ZoneEquipment/FanCoilAutoSize_ConstantFlowVariableFan.idf"),
    epwName=Modelica.Utilities.Files.loadResource("./Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.epw"),
    weaName=Modelica.Utilities.Files.loadResource("./Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));

  Controls.OBC.CDL.Continuous.Sources.Constant con1[3](k=fill(0, 3))
    annotation (Placement(transformation(extent={{20,30},{40,50}})));
  FCUControls.Controller_VariableFan_ConstantWaterFlowrate
    controller_VariableFan_ConstantWaterFlowrate
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  Controls.OBC.CDL.Conversions.BooleanToReal booToRea
    annotation (Placement(transformation(extent={{-70,-70},{-50,-50}})));
  Controls.OBC.CDL.Continuous.Multiply mul
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  Modelica.Blocks.Sources.RealExpression TZon(y=datRea.y[14])
    "Zone air temperature"
    annotation (Placement(transformation(extent={{-10,120},{10,140}})));
  Modelica.Blocks.Sources.RealExpression PHea(y=datRea.y[1]) "Heating power"
    annotation (Placement(transformation(extent={{-120,130},{-100,150}})));
  Modelica.Blocks.Sources.RealExpression PCoo(y=datRea.y[2]) "Cooling power"
    annotation (Placement(transformation(extent={{-120,110},{-100,130}})));
  Modelica.Blocks.Sources.RealExpression PFan(y=datRea.y[3]) "Fan power"
    annotation (Placement(transformation(extent={{-120,90},{-100,110}})));
  Controls.OBC.CDL.Continuous.Sources.Constant con2[3](k=fill(0, 3))
    "Zero source"
    annotation (Placement(transformation(extent={{-150,120},{-130,140}})));
  Controls.OBC.CDL.Logical.Sources.Constant con3[3](k=fill(false, 3))
    "Constant False source"
    annotation (Placement(transformation(extent={{-150,80},{-130,100}})));
  Controls.OBC.CDL.Continuous.Switch swi
    annotation (Placement(transformation(extent={{-30,100},{-10,120}})));
  Controls.OBC.CDL.Continuous.Greater gre
    annotation (Placement(transformation(extent={{-70,100},{-50,120}})));
  Controls.OBC.CDL.Continuous.AddParameter addPar1(p=4)
    annotation (Placement(transformation(extent={{-60,130},{-40,150}})));

  Results res(
    final A=ATot,
    PFan=fanSup.P + 0,
    PPum=pumHeaCoi.P + pumCooCoi.P,
    PHea=heaCoi.Q2_flow + sum(VAVBox.terHea.Q2_flow),
    PCooSen=cooCoi.QSen2_flow,
    PCooLat=cooCoi.QLat2_flow) "Results of the simulation";

  model Results "Model to store the results of the simulation"
    parameter Modelica.Units.SI.Area A "Floor area";
    input Modelica.Units.SI.Power PFan "Fan energy";
    input Modelica.Units.SI.Power PPum "Pump energy";
    input Modelica.Units.SI.Power PHea "Heating energy";
    input Modelica.Units.SI.Power PCooSen "Sensible cooling energy";
    input Modelica.Units.SI.Power PCooLat "Latent cooling energy";

    Real EFan(
      unit="J/m2",
      start=0,
      nominal=1E5,
      fixed=true) "Fan energy";
    Real EPum(
      unit="J/m2",
      start=0,
      nominal=1E5,
      fixed=true) "Pump energy";
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
    A*der(EPum) = PPum;
    A*der(EHea) = PHea;
    A*der(ECooSen) = PCooSen;
    A*der(ECooLat) = PCooLat;
    ECoo = ECooSen + ECooLat;

  end Results;
  MixingVolumes.MixingVolume vol
    annotation (Placement(transformation(extent={{100,-60},{120,-40}})));
equation

  connect(fCU_singleLayer.port_CCW_outlet, sinCoo.ports[1]) annotation (Line(
        points={{2,-10},{2,-80},{40,-80},{40,-100}},
                                                  color={0,127,255}));

  connect(fCU_singleLayer.port_HHW_outlet, sinHea.ports[1]) annotation (Line(
        points={{-6,-10},{-6,-90},{-40,-90},{-40,-100}},     color={0,127,255}));

  connect(souCoo.ports[1], fCU_singleLayer.port_CCW_inlet) annotation (Line(
        points={{70,-100},{70,-70},{6,-70},{6,-10}},color={0,127,255}));

  connect(souHea.ports[1], fCU_singleLayer.port_HHW_inlet)
    annotation (Line(points={{10,-100},{10,-90},{-2,-90},{-2,-10}},
                                                           color={0,127,255}));

  connect(con.y, fCU_singleLayer.uOA) annotation (Line(points={{-78,30},{-20,30},
          {-20,6},{-12,6}}, color={0,0,127}));

  connect(datRea.y[6], gai.u)
    annotation (Line(points={{-119,0},{-102,0}}, color={0,0,127}));

  connect(datRea.y[8], gai1.u) annotation (Line(points={{-119,0},{-110,0},{-110,
          -40},{-102,-40}}, color={0,0,127}));

  connect(datRea.y[10], gai2.u) annotation (Line(points={{-119,0},{-110,0},{
          -110,-80},{-102,-80}}, color={0,0,127}));

  connect(fCU_singleLayer.port_return, zon.ports[1]) annotation (Line(points={{10,0},{
          40,0},{40,-20},{78,-20},{78,-9.1}},         color={0,127,255}));
  connect(fCU_singleLayer.port_supply, zon.ports[2]) annotation (Line(points={{10,-4},
          {20,-4},{20,-28},{82,-28},{82,-9.1}},         color={0,127,255}));
  connect(con1.y, zon.qGai_flow) annotation (Line(points={{42,40},{50,40},{50,
          20},{58,20}}, color={0,0,127}));
  connect(building.weaBus, fCU_singleLayer.weaBus) annotation (Line(
      points={{-20,50},{-8,50},{-8,8}},
      color={255,204,51},
      thickness=0.5));
  connect(datRea.y[12], addPar[1].u) annotation (Line(points={{-119,0},{-110,0},
          {-110,70},{-102,70}}, color={0,0,127}));
  connect(datRea.y[13], addPar[2].u) annotation (Line(points={{-119,0},{-110,0},
          {-110,70},{-102,70}}, color={0,0,127}));
  connect(datRea.y[14], addPar[3].u) annotation (Line(points={{-119,0},{-110,0},
          {-110,70},{-102,70}}, color={0,0,127}));
  connect(addPar[1].y, controller_VariableFan_ConstantWaterFlowrate.THeaSet)
    annotation (Line(points={{-78,70},{-70,70},{-70,-14},{-62,-14}}, color={0,0,
          127}));
  connect(controller_VariableFan_ConstantWaterFlowrate.yCoo, fCU_singleLayer.uCoo)
    annotation (Line(points={{-38,-4},{-20,-4},{-20,-2},{-12,-2}}, color={0,0,127}));
  connect(controller_VariableFan_ConstantWaterFlowrate.yHea, fCU_singleLayer.uHea)
    annotation (Line(points={{-38,-8},{-20,-8},{-20,-6},{-12,-6}}, color={0,0,127}));
  connect(booToRea.y, mul.u2) annotation (Line(points={{-48,-60},{-46,-60},{-46,
          -46},{-42,-46}}, color={0,0,127}));
  connect(controller_VariableFan_ConstantWaterFlowrate.yFan, booToRea.u)
    annotation (Line(points={{-38,-16},{-36,-16},{-36,-24},{-76,-24},{-76,-60},{
          -72,-60}}, color={255,0,255}));
  connect(controller_VariableFan_ConstantWaterFlowrate.yFanSpe, mul.u1)
    annotation (Line(points={{-38,-12},{-32,-12},{-32,-28},{-50,-28},{-50,-34},{
          -42,-34}}, color={0,0,127}));
  connect(mul.y, fCU_singleLayer.uFan) annotation (Line(points={{-18,-40},{-16,-40},
          {-16,2},{-12,2}}, color={0,0,127}));
  connect(swi.u2, gre.y)
    annotation (Line(points={{-32,110},{-48,110}}, color={255,0,255}));
  connect(addPar[2].y, gre.u1) annotation (Line(points={{-78,70},{-74,70},{-74,110},
          {-72,110}}, color={0,0,127}));
  connect(addPar[1].y, gre.u2) annotation (Line(points={{-78,70},{-74,70},{-74,102},
          {-72,102}}, color={0,0,127}));
  connect(addPar[2].y, swi.u1) annotation (Line(points={{-78,70},{-74,70},{-74,118},
          {-32,118}}, color={0,0,127}));
  connect(swi.y, controller_VariableFan_ConstantWaterFlowrate.TCooSet)
    annotation (Line(points={{-8,110},{0,110},{0,80},{-66,80},{-66,-10},{-62,-10}},
        color={0,0,127}));
  connect(addPar[1].y, addPar1.u) annotation (Line(points={{-78,70},{-74,70},{-74,
          140},{-62,140}}, color={0,0,127}));
  connect(addPar1.y, swi.u3) annotation (Line(points={{-38,140},{-34,140},{-34,102},
          {-32,102}}, color={0,0,127}));
  connect(zon.TAir, controller_VariableFan_ConstantWaterFlowrate.TZon)
    annotation (Line(points={{101,28},{108,28},{108,86},{-64,86},{-64,-6},{-62,-6}},
        color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-160,
            -160},{160,160}})),                                  Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-160,-160},{160,
            160}})),
    experiment(
      StopTime=86400,
      Interval=60,
      __Dymola_Algorithm="Dassl"),
    __Dymola_Commands(file= "modelica://Buildings/Resources/Scripts/Dymola/Fluid/ZoneEquipment/FanCoilUsecaseThermalZone.mos"
      "Simulate and plot"));
end useCase_singleLayer_zoneVolume;
