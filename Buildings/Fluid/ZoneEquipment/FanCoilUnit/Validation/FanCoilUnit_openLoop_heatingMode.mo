within Buildings.Fluid.ZoneEquipment.FanCoilUnit.Validation;
model FanCoilUnit_openLoop_heatingMode

  extends Modelica.Icons.Example;

  replaceable package MediumA = Buildings.Media.Air
    constrainedby Modelica.Media.Interfaces.PartialCondensingGases "Medium model for air";

  replaceable package MediumW = Buildings.Media.Water "Medium model for water";

  Fluid.Sources.Boundary_pT sinCoo(
    redeclare package Medium = MediumW,
    T=279.15,
    nPorts=1) "Sink for chilled water"
                                      annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={40,-80})));

  Fluid.Sources.Boundary_pT sinHea(
    redeclare package Medium = MediumW,
    T=318.15,
    nPorts=1) "Sink for heating hot water"
                                      annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-40,-80})));

  Buildings.Fluid.ZoneEquipment.FanCoilUnit.FanCoilUnit fanCoiUni(
    heatingCoilType=Buildings.Fluid.ZoneEquipment.FanCoilUnit.Types.heatingCoil.heatingHotWater,
    capacityControlMethod=Buildings.Fluid.ZoneEquipment.FanCoilUnit.Types.capacityControl.multispeedCyclingFanConstantWater,
    dpAirTot_nominal(displayUnit="Pa") = 100,
    mAirOut_flow_nominal=fCUSizing.mAirOut_flow_nominal,
    redeclare package MediumA = MediumA,
    redeclare package MediumW = MediumW,
    mAir_flow_nominal=fCUSizing.mAir_flow_nominal,
    QHeaCoi_flow_nominal=13866,
    mHotWat_flow_nominal=fCUSizing.mHotWat_flow_nominal,
    UAHeaCoi_nominal=fCUSizing.UAHeaCoi_nominal,
    mChiWat_flow_nominal=fCUSizing.mChiWat_flow_nominal,
    UACooCoi_nominal=fCUSizing.UACooCoiTot_nominal,
    redeclare Data.customFCUFan fanPer)
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));

  Buildings.Fluid.Sources.MassFlowSource_T       souCoo(
    redeclare package Medium = MediumW,
    use_m_flow_in=true,
    use_T_in=true,
    nPorts=1) "Source for chilled water"     annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={70,-80})));

  Buildings.Fluid.Sources.MassFlowSource_T       souHea(
    redeclare package Medium = MediumW,
    use_m_flow_in=true,
    use_T_in=true,
    nPorts=1) "Source for heating hot water"
                                        annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={10,-90})));

  Buildings.Fluid.ZoneEquipment.FanCoilUnit.Validation.Data.FCUSizing fCUSizing
    "Sizing parameters for fan coil unit"
    annotation (Placement(transformation(extent={{-140,60},{-120,80}})));

  Modelica.Blocks.Sources.CombiTimeTable datRea(
    tableOnFile=true,
    fileName=ModelicaServices.ExternalReferences.loadResource(
        "./Buildings/Resources/Data/Fluid/ZoneEquipment/FanCoilAutoSize_ConstantFlowVariableFan.dat"),
    columns=2:19,
    tableName="EnergyPlus",
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments)
    "Reader for \"IndirectAbsorptionChiller.idf\" EnergyPlus example results"
    annotation (Placement(transformation(extent={{-140,-10},{-120,10}})));

  Sources.Boundary_pT souAir(
    redeclare package Medium = MediumA,
    use_Xi_in=true,
    use_T_in=true,
    T=279.15,
    nPorts=1) "Source for zone air"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));

  Sources.Boundary_pT sinAir(
    redeclare package Medium = MediumA,
    T=279.15,
    nPorts=1) "Sink for zone air"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(k=0.2)
    "Constant real signal of 0.2 for the outdoor air economizer"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));

  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar[3](p=fill(273.15, 3))
    "Add 273.15 to temperature values from EPlus to convert it to Kelvin from Celsius"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));

  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        ModelicaServices.ExternalReferences.loadResource(
        "./Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    "Outdoor weather data"
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
    PFan=fanCoiUni.fan.P + 0,
    PHea=fanCoiUni.heaCoiHHW.Q2_flow,
    PCooSen=fanCoiUni.cooCoiCHW.QSen2_flow,
    PCooLat=fanCoiUni.cooCoiCHW.QLat2_flow) "Results of the simulation";

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
  Modelica.Blocks.Sources.RealExpression PModCoo(y=-fanCoiUni.cooCoiCHW.Q2_flow)
    "Cooling power consumption in Modelica model"
    annotation (Placement(transformation(extent={{80,20},{100,40}})));
  Modelica.Blocks.Sources.RealExpression PModCooSen(y=-fanCoiUni.cooCoiCHW.QSen2_flow)
    "Sensible cooling power consumption in Modelica model"
    annotation (Placement(transformation(extent={{120,20},{140,40}})));
  Modelica.Blocks.Sources.RealExpression PModCooLat(y=-fanCoiUni.cooCoiCHW.QLat2_flow)
    "Latent cooling power consumption in Modelica model"
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));
  Modelica.Blocks.Sources.RealExpression PModCooCal(y=-1000*4200*fanCoiUni.VChiWat_flow.V_flow
        *(fanCoiUni.TChiWatSupSen.T - fanCoiUni.TChiWatRetSen.T))
    "Calculated cooling power consumption in Modelica model"
    annotation (Placement(transformation(extent={{80,-30},{100,-10}})));
  Modelica.Blocks.Sources.RealExpression PCooSen(y=datRea.y[15])
    "Sensible cooling power"
    annotation (Placement(transformation(extent={{-140,30},{-120,50}})));
  .Buildings.Controls.OBC.CDL.Continuous.Divide div
    "Calculate mass fractions of constituents"
    annotation (Placement(transformation(extent={{-60,-130},{-40,-110}})));
  .Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar1(p=1)
    "Add 1 to humidity ratio value to find total mass of moist air"
    annotation (Placement(transformation(extent={{-120,-150},{-100,-130}})));
  .Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con1(k=1)
    "Constant real signal of 1 for holding the hot water and chilled water control valves fully open"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  Modelica.Blocks.Sources.RealExpression dPFanOut(y=datRea.y[18])
    "Measured fan outlet pressure"
    annotation (Placement(transformation(extent={{100,90},{120,110}})));
  Modelica.Blocks.Sources.RealExpression dPFanIn(y=datRea.y[17])
    "Measured fan inlet pressure"
    annotation (Placement(transformation(extent={{100,120},{120,140}})));
equation

  connect(fanCoiUni.port_CCW_outlet, sinCoo.ports[1])
    annotation (Line(points={{12,-10},{12,-70},{40,-70}},
                                                        color={0,127,255}));

  connect(fanCoiUni.port_HHW_outlet, sinHea.ports[1]) annotation (Line(points={{4,-10},
          {4,-60},{-40,-60},{-40,-70}},           color={0,127,255}));

  connect(souCoo.ports[1], fanCoiUni.port_CCW_inlet) annotation (Line(points={{70,-70},
          {70,-60},{16,-60},{16,-10}},       color={0,127,255}));

  connect(souHea.ports[1], fanCoiUni.port_HHW_inlet) annotation (Line(points={{10,-80},
          {10,-10},{8,-10}},                   color={0,127,255}));

  connect(souAir.ports[1], fanCoiUni.port_return) annotation (Line(points={{40,30},
          {50,30},{50,0},{20,0}},     color={0,127,255}));

  connect(sinAir.ports[1], fanCoiUni.port_supply) annotation (Line(points={{40,-30},
          {50,-30},{50,-4},{20,-4}},      color={0,127,255}));

  connect(con.y, fanCoiUni.uOA) annotation (Line(points={{-58,30},{-20,30},
          {-20,6},{-2,6}},
                       color={0,0,127}));

  connect(addPar[1].y, souAir.T_in) annotation (Line(points={{-58,70},{-16,
          70},{-16,34},{18,34}},
                             color={0,0,127}));

  connect(addPar[2].y, souHea.T_in) annotation (Line(points={{-58,70},{-16,70},{
          -16,-120},{6,-120},{6,-102}},
                               color={0,0,127}));

  connect(addPar[3].y, souCoo.T_in) annotation (Line(points={{-58,70},{-16,70},{
          -16,-120},{66,-120},{66,-92}},  color={0,0,127}));

  connect(weaDat.weaBus, fanCoiUni.weaBus) annotation (Line(
      points={{-60,110},{-10,110},{-10,8},{2,8}},
      color={255,204,51},
      thickness=0.5));

  connect(datRea.y[5], addPar[1].u) annotation (Line(points={{-119,0},{-110,0},{
          -110,70},{-82,70}}, color={0,0,127}));
  connect(datRea.y[7], addPar[3].u) annotation (Line(points={{-119,0},{-110,0},{
          -110,70},{-82,70}}, color={0,0,127}));
  connect(datRea.y[9], addPar[2].u) annotation (Line(points={{-119,0},{-110,0},{
          -110,70},{-82,70}}, color={0,0,127}));
  connect(datRea.y[6], fanCoiUni.uFan) annotation (Line(points={{-119,0},{
          -40,0},{-40,2},{-2,2}},                 color={0,0,127}));
  connect(datRea.y[16], addPar1.u) annotation (Line(points={{-119,0},{-110,0},{-110,
          -120},{-130,-120},{-130,-140},{-122,-140}}, color={0,0,127}));
  connect(datRea.y[16], div.u1) annotation (Line(points={{-119,0},{-110,0},{-110,
          -120},{-100,-120},{-100,-114},{-62,-114}}, color={0,0,127}));
  connect(addPar1.y, div.u2) annotation (Line(points={{-98,-140},{-70,-140},{-70,
          -126},{-62,-126}}, color={0,0,127}));
  connect(div.y, souAir.Xi_in[1]) annotation (Line(points={{-38,-120},{-26,
          -120},{-26,26},{18,26}},
                             color={0,0,127}));
  connect(con1.y, fanCoiUni.uCoo) annotation (Line(points={{-58,-20},{-30,
          -20},{-30,-2},{-2,-2}},
                              color={0,0,127}));
  connect(con1.y, fanCoiUni.uHea) annotation (Line(points={{-58,-20},{-30,
          -20},{-30,-6},{-2,-6}},
                              color={0,0,127}));
  connect(datRea.y[10], souHea.m_flow_in) annotation (Line(points={{-119,0},{-110,
          0},{-110,-100},{-20,-100},{-20,-112},{2,-112},{2,-102}},      color={
          0,0,127}));
  connect(datRea.y[8], souCoo.m_flow_in) annotation (Line(points={{-119,0},{
          -110,0},{-110,-100},{-20,-100},{-20,-112},{62,-112},{62,-92}}, color=
          {0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}})),                                        Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-160,-160},{160,160}})),
    experiment(
      StopTime=86400,
      Interval=60,
      __Dymola_Algorithm="Dassl"),
    __Dymola_Commands(file= "modelica://Buildings/Resources/Scripts/Dymola/Fluid/ZoneEquipment/FanCoilUnit/Validation/FanCoilUnit_openLoop_heatingMode.mos"
      "Simulate and plot"));
end FanCoilUnit_openLoop_heatingMode;
