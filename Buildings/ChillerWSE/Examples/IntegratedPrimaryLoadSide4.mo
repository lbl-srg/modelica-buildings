within Buildings.ChillerWSE.Examples;
model IntegratedPrimaryLoadSide4
  "Example that show how to use Buildings.ChillerWSE.IntegratedPrimaryLoadSide"

  replaceable package MediumA = Buildings.Media.Air "Medium model";
  replaceable package MediumW = Buildings.Media.Water "Medium model";

  // chillers parameters
  parameter Integer nChi=2 "Number of chillers";
  parameter Modelica.SIunits.MassFlowRate mChiller1_flow_nominal= 34.7
    "Nominal mass flow rate at condenser water in the chillers";
  parameter Modelica.SIunits.MassFlowRate mChiller2_flow_nominal= 18.3
    "Nominal mass flow rate at condenser water in the chillers";
  parameter Modelica.SIunits.PressureDifference dpChiller1_nominal = 46.2*1000
    "Nominal pressure";
  parameter Modelica.SIunits.PressureDifference dpChiller2_nominal = 44.8*1000
    "Nominal pressure";

 // WSE parameters
  parameter Modelica.SIunits.MassFlowRate mWSE1_flow_nominal= 34.7
    "Nominal mass flow rate at condenser water in the chillers";
  parameter Modelica.SIunits.MassFlowRate mWSE2_flow_nominal= 35.3
    "Nominal mass flow rate at condenser water in the chillers";
  parameter Modelica.SIunits.PressureDifference dpWSE1_nominal = 33.1*1000
    "Nominal pressure";
  parameter Modelica.SIunits.PressureDifference dpWSE2_nominal = 34.5*1000
    "Nominal pressure";

  parameter Buildings.Fluid.Movers.Data.Generic[nChi] perPum(
    each pressure=
          Buildings.Fluid.Movers.BaseClasses.Characteristics.flowParameters(
          V_flow=mChiller2_flow_nominal/1000*{0.2,0.6,1.0,1.2}, dp=dpChiller2_nominal*{1.2,
          1.1,1.0,0.6}));
  parameter Modelica.SIunits.Time tWai=1200 "Waiting time";

  // AHU
  parameter Modelica.SIunits.ThermalConductance UA_nominal=nChi*mChiller2_flow_nominal*4200*(6.67-18.56)/
     Buildings.Fluid.HeatExchangers.BaseClasses.lmtd(
        6.67,
        11.56,
        12,
        25)
    "Thermal conductance at nominal flow for sensible heat, used to compute time constant";
  parameter Modelica.SIunits.MassFlowRate mAir_flow_nominal = 161.35 "Nominal air mass flowrate";

  Buildings.ChillerWSE.IntegratedPrimaryLoadSide intWSEPri(
    redeclare package Medium1 = MediumW,
    redeclare package Medium2 = MediumW,
    nChi=nChi,
    addPowerToMedium=false,
    perPum=perPum,
    mChiller1_flow_nominal=mChiller1_flow_nominal,
    mChiller2_flow_nominal=mChiller2_flow_nominal,
    mWSE1_flow_nominal=mWSE1_flow_nominal,
    mWSE2_flow_nominal=mWSE2_flow_nominal,
    dpChiller1_nominal=dpChiller1_nominal,
    dpWSE1_nominal=dpWSE1_nominal,
    dpChiller2_nominal=dpChiller2_nominal,
    dpWSE2_nominal=dpWSE2_nominal,
    redeclare
      Fluid.Chillers.Data.ElectricEIR.ElectricEIRChiller_York_YT_1055kW_5_96COP_Vanes
      perChi)
    "Integrated waterside economizer on the load side of a primary-only chilled water system"
    annotation (Placement(transformation(extent={{126,22},{146,42}})));
  Buildings.Fluid.Storage.ExpansionVessel expVesChi(redeclare package Medium =
        MediumW, V_start=1)
    annotation (Placement(transformation(extent={{210,99},{230,119}})));
  Fluid.HeatExchangers.CoolingTowers.YorkCalc cooTow[nChi](
    redeclare each package Medium = MediumW,
    each m_flow_nominal=mChiller1_flow_nominal,
    each dp_nominal=14930 + 14930 + 74650,
    each TAirInWB_nominal(displayUnit="degC") = 283.15,
    each TApp_nominal=6,
    each PFan_nominal=6000,
    each energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial)
                                           "Cooling tower" annotation (
      Placement(transformation(extent={{10,-10},{-10,10}}, origin={175,139})));
  Fluid.Sensors.TemperatureTwoPort CHWST(redeclare package Medium = MediumW,
      m_flow_nominal=nChi*mChiller2_flow_nominal)
    "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{96,-14},{76,6}})));
  redeclare replaceable Fluid.Sources.Boundary_pT                sou2(
    nPorts=1,
    redeclare package Medium = MediumA,
    T=291.15)
  constrainedby Fluid.Sources.Boundary_pT(
    use_T_in=true,
    redeclare package Medium = MediumCHW,
    T=291.15) "Source on medium 2 side"
    annotation (Placement(transformation(extent={{238,-82},{218,-62}})));
  Modelica.Blocks.Sources.Constant
                               TEva_in(k=273.15 + 25)
                   "Evaporator inlet temperature"
    annotation (Placement(transformation(extent={{280,-32},{260,-12}})));
  Modelica.Blocks.Sources.Constant CHWSTSet(k(
      unit="K",
      displayUnit="degC") = 273.15 + 6.56)
    "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-160,150},{-140,170}})));
  Modelica.Blocks.Sources.Constant yVal7(k=0) "Conrol signal for valve 7"
    annotation (Placement(transformation(extent={{-120,-60},{-100,-40}})));
  Modelica.Blocks.Sources.Constant yPum[nChi](k=1) "Conrol signal for pumps"
    annotation (Placement(transformation(extent={{-120,-26},{-100,-6}})));
  BoundaryConditions.WeatherData.ReaderTMY3           weaData(filNam=
        "modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos")
    annotation (Placement(transformation(extent={{-220,-78},{-200,-58}})));
  BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
    annotation (Placement(transformation(extent={{-210,-38},{-190,-18}})));
  Fluid.Sensors.TemperatureTwoPort CWST(redeclare package Medium = MediumW,
      m_flow_nominal=nChi*mChiller1_flow_nominal)
    "Condenser water supply temperature"
    annotation (Placement(transformation(extent={{150,130},{130,150}})));
  Fluid.Sensors.TemperatureTwoPort CWRT(redeclare package Medium = MediumW,
      m_flow_nominal=nChi*mChiller1_flow_nominal)
    "Condenser water return temperature"
    annotation (Placement(transformation(extent={{180,28},{200,48}})));
  Fluid.Movers.FlowControlled_m_flow pumCW[2](
    redeclare package Medium = MediumW,
    addPowerToMedium=false,
    m_flow_nominal=mChiller1_flow_nominal) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={112,90})));
  BaseClasses.CoolingModeControl cooModCon(
    deaBan1=1,
    deaBan2=1,
    tWai=tWai) "Cooling mode controller"
    annotation (Placement(transformation(extent={{-100,100},{-80,120}})));
  Modelica.Blocks.Sources.RealExpression towTApp(y=max(cooTow[1:nChi].TAppAct))
    "Cooling tower approach temperature"
    annotation (Placement(transformation(extent={{-160,108},{-140,128}})));
  BaseClasses.ChillerStageControl chiStaCon(           QEva_nominal=-300*3517, tWai=0)
                                            "Chiller staging control"
    annotation (Placement(transformation(extent={{-20,130},{0,150}})));
  Modelica.Blocks.Sources.RealExpression cooLoaChi(y=intWSEPri.port_a2.m_flow*4180
        *(intWSEPri.wseCHWST - CHWSTSet.y)) "Cooling load in chillers"
    annotation (Placement(transformation(extent={{-100,134},{-80,154}})));
  Modelica.Blocks.Math.RealToBoolean chiOn[nChi](threshold=0.5)
    "Real value to boolean value"
    annotation (Placement(transformation(extent={{20,130},{40,150}})));
  Modelica.Blocks.Math.RealToBoolean reaToBoo(threshold=1.5)
    "Inverse on/off signal for the WSE"
    annotation (Placement(transformation(extent={{-20,100},{0,120}})));
  Modelica.Blocks.Logical.Not wseOn "True: WSE is on; False: WSE is off "
    annotation (Placement(transformation(extent={{20,100},{40,120}})));
  Modelica.Blocks.Sources.RealExpression yVal5(y=if cooModCon.cooMod > 1.5
         then 1 else 0) "On/off signal for valve 5"
    annotation (Placement(transformation(extent={{-120,22},{-100,42}})));
  Modelica.Blocks.Sources.RealExpression yVal6(y=if cooModCon.cooMod < 0.5
         then 1 else 0) "On/off signal for valve 6"
    annotation (Placement(transformation(extent={{-120,4},{-100,24}})));
  BaseClasses.ConstantSpeedPumpStageControl CWPumCon(tWai=0)
    "Condenser water pump controller"
    annotation (Placement(transformation(extent={{-22,60},{-2,80}})));
  Modelica.Blocks.Sources.RealExpression chiNumOn(y=sum(chiStaCon.y))
    "The number of running chillers"
    annotation (Placement(transformation(extent={{-100,64},{-80,84}})));
  Modelica.Blocks.Math.Gain gai[nChi](k=mChiller1_flow_nominal) "Gain effect"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));
  BaseClasses.CoolingTowerSpeedControl cooTowSpeCon(controllerType=Modelica.Blocks.Types.SimpleController.PI,
      reset=Buildings.Types.Reset.Disabled)
    "Cooling tower speed control"
    annotation (Placement(transformation(extent={{-20,170},{0,186}})));
  Modelica.Blocks.Sources.Constant CWSTSet(k(
      unit="K",
      displayUnit="degC") = 273.15 + 20)
    "Condenser water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-100,170},{-80,190}})));

  Fluid.Air.AirHandlingUnit ahu(
    redeclare package Medium1 = MediumW,
    redeclare package Medium2 = MediumA,
    m1_flow_nominal=nChi*mChiller2_flow_nominal,
    m2_flow_nominal=mAir_flow_nominal,
    dpValve_nominal=6000,
    dp2_nominal=600,
    QHeaMax_flow=2000,
    mWatMax_flow=0.01,
    UA_nominal=UA_nominal,
    addPowerToMedium=false,
    perFan(pressure(V_flow=mAir_flow_nominal*{0,0.5,1}, dp=800*{1.2,1.12,1})),
    dp1_nominal=6000)
    annotation (Placement(transformation(extent={{130,-76},{150,-56}})));
  Fluid.Sources.FixedBoundary           sin2(
    nPorts=1, redeclare package Medium = MediumA)   "Sink on medium 2 side"
                                        annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        origin={68,-90})));
  Fluid.Sensors.TemperatureTwoPort CHWRT(redeclare package Medium = MediumW,
      m_flow_nominal=nChi*mChiller2_flow_nominal)
    "Chilled water return temperature"
    annotation (Placement(transformation(extent={{192,-14},{172,6}})));
  Buildings.Fluid.Storage.ExpansionVessel expVesChi1(
                                                    redeclare package Medium =
        MediumW, V_start=1)
    annotation (Placement(transformation(extent={{172,-49},{192,-29}})));
  Modelica.Blocks.Sources.Constant TAirSup(k(
      unit="K",
      displayUnit="degC") = 273.15 + 16) "Supply air temperature setpoint"
    annotation (Placement(transformation(extent={{-122,-110},{-102,-90}})));
  Modelica.Blocks.Sources.Constant XAirSup(k=MediumA.X_default[1])
    "Supply air mass fraction setpoint"
    annotation (Placement(transformation(extent={{-60,-112},{-40,-92}})));
  Modelica.Blocks.Sources.Constant uFan(k = 1)
    "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{12,-102},{32,-82}})));
  Modelica.Blocks.Sources.Constant uVal(k=1)
    "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{0,-58},{20,-38}})));
equation
  connect(sou2.T_in,TEva_in. y)
    annotation (Line(points={{240,-68},{240,-22},{259,-22}},
                                                          color={0,0,127}));
  connect(intWSEPri.port_b2, CHWST.port_a) annotation (Line(points={{126,26},{112,
          26},{112,-4},{96,-4}},       color={0,127,255}));
  connect(weaData.weaBus, weaBus.TWetBul) annotation (Line(
      points={{-200,-68},{-200,-28}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(intWSEPri.port_b1, CWRT.port_a)
    annotation (Line(points={{146,38},{180,38}}, color={0,127,255}));
  connect(CWRT.port_b, expVesChi.port_a)
    annotation (Line(points={{200,38},{220,38},{220,99}}, color={0,127,255}));

   for i in 1:nChi loop
     connect(cooTow[i].TAir, weaBus.TWetBul.TWetBul) annotation (Line(points={{187,143},
            {214,143},{250,143},{250,214},{-188,214},{-188,-28},{-200,-28}},
                                       color={0,0,127}));

     connect(cooTow[i].port_a, expVesChi.port_a)
       annotation (Line(points={{185,139},{200,139},{200,138},{200,80},{220,80},
            {220,99}},                                    color={0,127,255}));
    connect(CWST.port_a, cooTow[i].port_b) annotation (Line(points={{150,140},{
            164,140},{164,139},{165,139}}, color={0,127,255}));
     connect(pumCW[i].port_b, intWSEPri.port_a1)
      annotation (Line(points={{112,80},{112,38},{126,38}},
                                                          color={0,127,255}));

    connect(pumCW[i].port_a, CWST.port_b) annotation (Line(points={{112,100},{
            112,140},{130,140}}, color={0,127,255}));
    connect(chiOn[i].y, intWSEPri.on[i]) annotation (Line(points={{41,140},{92,140},
            {92,39.6},{124.4,39.6}},     color={255,0,255}));
   end for;
  connect(CHWSTSet.y, cooModCon.CHWSTSet) annotation (Line(points={{-139,160},{-120,
          160},{-120,118},{-102,118}}, color={0,0,127}));
  connect(towTApp.y, cooModCon.towTApp) annotation (Line(points={{-139,118},{-139,
          118},{-102,118},{-102,110}},                 color={0,0,127}));
  connect(weaBus.TWetBul.TWetBul, cooModCon.TWetBul) annotation (Line(
      points={{-200,-28},{-186,-28},{-186,214},{-120,214},{-120,114},{-102,114}},
      color={255,204,51},
      thickness=0.5));
  connect(intWSEPri.wseCHWST, cooModCon.wseCHWST) annotation (Line(points={{147,36},
          {160,36},{160,214},{-120,214},{-120,106},{-102,106}},
        color={0,0,127}));
  connect(cooModCon.cooMod, chiStaCon.cooMod) annotation (Line(points={{-79,110},
          {-40,110},{-40,148},{-22,148}},   color={0,0,127}));
  connect(cooLoaChi.y, chiStaCon.QTot) annotation (Line(points={{-79,144},{-34,144},
          {-22,144}},           color={0,0,127}));
  connect(chiStaCon.y, chiOn.u) annotation (Line(points={{1,140},{9.5,140},{18,140}},
                      color={0,0,127}));
  connect(cooModCon.cooMod,reaToBoo. u) annotation (Line(points={{-79,110},{-64,
          110},{-22,110}},            color={0,0,127}));
  connect(reaToBoo.y, wseOn.u) annotation (Line(points={{1,110},{9.5,110},{18,110}},
                     color={255,0,255}));
  connect(wseOn.y, intWSEPri.on[nChi + 1]) annotation (Line(points={{41,110},{50,
          110},{92,110},{92,39.6},{124.4,39.6}},    color={255,0,255}));
  connect(yPum.y, intWSEPri.yPum) annotation (Line(points={{-99,-16},{-42,-16},{
          -42,27.6},{124.4,27.6}},
                                 color={0,0,127}));
  connect(yVal5.y, intWSEPri.yVal5) annotation (Line(points={{-99,32},{-78,32},{
          -78,35},{124.4,35}}, color={0,0,127}));
  connect(yVal6.y, intWSEPri.yVal6) annotation (Line(points={{-99,14},{-76,14},{
          -76,31.8},{124.4,31.8}}, color={0,0,127}));
  connect(cooModCon.cooMod, CWPumCon.cooMod) annotation (Line(points={{-79,110},
          {-40,110},{-40,78},{-24,78}}, color={0,0,127}));
  connect(chiNumOn.y, CWPumCon.chiNumOn)
    annotation (Line(points={{-79,74},{-79,74},{-24,74}}, color={0,0,127}));
  connect(CWPumCon.y, gai.u)
    annotation (Line(points={{-1,70},{18,70}},         color={0,0,127}));
  connect(gai.y, pumCW.m_flow_in) annotation (Line(points={{41,70},{80,70},{80,90},
          {100,90}}, color={0,0,127}));
  connect(CWSTSet.y, cooTowSpeCon.CWST_set) annotation (Line(points={{-79,180},
          {-40,180},{-40,186},{-22,186}}, color={0,0,127}));
  connect(cooModCon.cooMod, cooTowSpeCon.cooMod) annotation (Line(points={{-79,110},
          {-40,110},{-40,182.444},{-22,182.444}},
                                               color={0,0,127}));
  connect(CHWSTSet.y, cooTowSpeCon.CHWST_set) annotation (Line(points={{-139,
          160},{-120,160},{-120,214},{-40,214},{-40,178.889},{-22,178.889}},
                                                                     color={0,0,
          127}));
  connect(CWST.T, cooTowSpeCon.CWST) annotation (Line(points={{140,151},{140,
          166},{160,166},{160,214},{-40,214},{-40,175.333},{-22,175.333}},
                                                                   color={0,0,
          127}));
  connect(CHWST.T, cooTowSpeCon.CHWST) annotation (Line(points={{86,7},{86,214},
          {-40,214},{-40,171.778},{-22,171.778}},
                                               color={0,0,127}));
  connect(cooTowSpeCon.y, cooTow[1].y) annotation (Line(points={{1,178.889},{
          202,178.889},{202,147},{187,147}},
                                         color={0,0,127}));
  connect(cooTowSpeCon.y, cooTow[2].y) annotation (Line(points={{1,178.889},{
          202,178.889},{202,147},{187,147}},
                                         color={0,0,127}));
  connect(intWSEPri.TSet, CHWSTSet.y) annotation (Line(points={{124.4,42.8},{62,
          42.8},{-120,42.8},{-120,160},{-139,160}}, color={0,0,127}));
  connect(yVal7.y, intWSEPri.yVal7) annotation (Line(points={{-99,-50},{-36,-50},
          {-36,24},{124,24},{124,14},{132.8,14},{132.8,20.4}}, color={0,0,127}));
  connect(CHWST.port_b, ahu.port_a1) annotation (Line(points={{76,-4},{68,-4},{68,
          -6},{68,-60},{130,-60}}, color={0,127,255}));
  connect(ahu.port_a2, sou2.ports[1]) annotation (Line(points={{150,-72},{184,-72},
          {218,-72}}, color={0,127,255}));
  connect(sin2.ports[1], ahu.port_b2) annotation (Line(points={{78,-90},{100,-90},
          {100,-72},{130,-72}}, color={0,127,255}));
  connect(ahu.port_b1, CHWRT.port_a) annotation (Line(points={{150,-60},{200,-60},
          {200,-4},{192,-4}}, color={0,127,255}));
  connect(CHWRT.port_b, intWSEPri.port_a2) annotation (Line(points={{172,-4},{160,
          -4},{160,26},{146,26}}, color={0,127,255}));
  connect(cooModCon.wseCHWRT, CHWRT.T) annotation (Line(points={{-102,102},{-120,
          102},{-120,214},{250,214},{250,214},{250,16},{182,16},{182,7}}, color=
         {0,0,127}));
  connect(ahu.TSet, TAirSup.y) annotation (Line(points={{129,-67},{58,-67},{-80,
          -67},{-80,-100},{-101,-100}}, color={0,0,127}));
  connect(XAirSup.y, ahu.XSet_w) annotation (Line(points={{-39,-102},{0,-102},{0,
          -65},{129,-65}}, color={0,0,127}));
  connect(uVal.y, ahu.uWatVal) annotation (Line(points={{21,-48},{66,-48},{120,-48},
          {120,-62},{129,-62}}, color={0,0,127}));
  connect(uFan.y, ahu.uFan) annotation (Line(points={{33,-92},{46,-92},{46,-70},
          {129,-70}}, color={0,0,127}));
  connect(expVesChi1.port_a, ahu.port_b1) annotation (Line(points={{182,-49},{
          162,-49},{162,-48},{162,-60},{150,-60}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-220,-120},
            {280,200}})),                                        Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-220,-120},{280,200}})),
    __Dymola_Commands(file=
          "Resources/Scripts/Dymola/ChillerWSE/Examples/IntegratedPrimaryLoadSide.mos"
        "Simulate and Plot"));
end IntegratedPrimaryLoadSide4;
