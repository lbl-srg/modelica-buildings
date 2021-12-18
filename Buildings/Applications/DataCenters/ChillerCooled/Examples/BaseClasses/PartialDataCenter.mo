within Buildings.Applications.DataCenters.ChillerCooled.Examples.BaseClasses;
partial model PartialDataCenter
  "Partial model that impliments cooling system for data centers"
  replaceable package MediumA = Buildings.Media.Air "Medium model";
  replaceable package MediumW = Buildings.Media.Water "Medium model";

  // Chiller parameters
  parameter Integer numChi=2 "Number of chillers";
  parameter Modelica.Units.SI.MassFlowRate m1_flow_chi_nominal=34.7
    "Nominal mass flow rate at condenser water in the chillers";
  parameter Modelica.Units.SI.MassFlowRate m2_flow_chi_nominal=18.3
    "Nominal mass flow rate at evaporator water in the chillers";
  parameter Modelica.Units.SI.PressureDifference dp1_chi_nominal=46.2*1000
    "Nominal pressure";
  parameter Modelica.Units.SI.PressureDifference dp2_chi_nominal=44.8*1000
    "Nominal pressure";
  parameter Modelica.Units.SI.Power QEva_nominal=m2_flow_chi_nominal*4200*(6.67
       - 18.56) "Nominal cooling capaciaty(Negative means cooling)";
 // WSE parameters
  parameter Modelica.Units.SI.MassFlowRate m1_flow_wse_nominal=34.7
    "Nominal mass flow rate at condenser water in the chillers";
  parameter Modelica.Units.SI.MassFlowRate m2_flow_wse_nominal=35.3
    "Nominal mass flow rate at condenser water in the chillers";
  parameter Modelica.Units.SI.PressureDifference dp1_wse_nominal=33.1*1000
    "Nominal pressure";
  parameter Modelica.Units.SI.PressureDifference dp2_wse_nominal=34.5*1000
    "Nominal pressure";

  parameter Buildings.Fluid.Movers.Data.Generic[numChi] perPumCW(
    each pressure=
          Buildings.Fluid.Movers.BaseClasses.Characteristics.flowParameters(
          V_flow=m1_flow_chi_nominal/1000*{0.2,0.6,1.0,1.2},
          dp=(dp1_chi_nominal+60000+6000)*{1.2,1.1,1.0,0.6}))
    "Performance data for condenser water pumps";
  parameter Modelica.Units.SI.Time tWai=1200 "Waiting time";

  // AHU
  parameter Modelica.Units.SI.ThermalConductance UA_nominal=numChi*QEva_nominal
      /Buildings.Fluid.HeatExchangers.BaseClasses.lmtd(
      6.67,
      11.56,
      12,
      25)
    "Thermal conductance at nominal flow for sensible heat, used to compute time constant";
  parameter Modelica.Units.SI.MassFlowRate mAir_flow_nominal=161.35
    "Nominal air mass flowrate";
  parameter Real yValMinAHU(min=0,max=1,unit="1")=0.1
    "Minimum valve openning position";
  // Set point
  parameter Modelica.Units.SI.Temperature TCHWSet=273.15 + 8
    "Chilled water temperature setpoint";
  parameter Modelica.Units.SI.Temperature TSupAirSet=TCHWSet + 10
    "Supply air temperature setpoint";
  parameter Modelica.Units.SI.Temperature TRetAirSet=273.15 + 25
    "Supply air temperature setpoint";
  parameter Modelica.Units.SI.Pressure dpSetPoi=80000
    "Differential pressure setpoint";

  replaceable Buildings.Applications.DataCenters.ChillerCooled.Equipment.BaseClasses.PartialChillerWSE chiWSE(
    redeclare replaceable package Medium1 = MediumW,
    redeclare replaceable package Medium2 = MediumW,
    numChi=numChi,
    m1_flow_chi_nominal=m1_flow_chi_nominal,
    m2_flow_chi_nominal=m2_flow_chi_nominal,
    m1_flow_wse_nominal=m1_flow_wse_nominal,
    m2_flow_wse_nominal=m2_flow_wse_nominal,
    dp1_chi_nominal=dp1_chi_nominal,
    dp1_wse_nominal=dp1_wse_nominal,
    dp2_chi_nominal=dp2_chi_nominal,
    dp2_wse_nominal=dp2_wse_nominal,
    redeclare each
      Buildings.Fluid.Chillers.Data.ElectricEIR.ElectricEIRChiller_York_YT_1055kW_5_96COP_Vanes
      perChi,
    use_inputFilter=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    use_controller=false)
    "Chillers and waterside economizer"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Buildings.Fluid.Sources.Boundary_pT expVesCW(
    redeclare replaceable package Medium = MediumW,
    nPorts=1)
    "Expansion tank"
    annotation (Placement(transformation(extent={{-9,-9.5},{9,9.5}},
        rotation=180,
        origin={131,140.5})));
  Buildings.Fluid.HeatExchangers.CoolingTowers.YorkCalc cooTow[numChi](
    redeclare each replaceable package Medium = MediumW,
    each TAirInWB_nominal(displayUnit="degC") = 283.15,
    each TApp_nominal=6,
    each energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
    each dp_nominal=30000,
    each m_flow_nominal=0.785*m1_flow_chi_nominal,
    each PFan_nominal=18000)
    "Cooling tower"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
      origin={10,140})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TCHWSup(
    redeclare replaceable package Medium = MediumW,
    m_flow_nominal=numChi*m2_flow_chi_nominal)
    "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{-16,-10},{-36,10}})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3  weaData(filNam=
    Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos"))
    annotation (Placement(transformation(extent={{-360,-80},{-340,-60}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
    annotation (Placement(transformation(extent={{-338,-30},{-318,-10}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TCWSup(
    redeclare replaceable package Medium = MediumW,
    m_flow_nominal=numChi*m1_flow_chi_nominal)
    "Condenser water supply temperature"
    annotation (Placement(transformation(extent={{-22,130},{-42,150}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TCWRet(
    redeclare replaceable package Medium = MediumW,
    m_flow_nominal=numChi*m1_flow_chi_nominal)
    "Condenser water return temperature"
    annotation (Placement(transformation(extent={{82,50},{102,70}})));
  Buildings.Fluid.Movers.FlowControlled_m_flow pumCW[numChi](
    redeclare each replaceable package Medium = MediumW,
    each m_flow_nominal=m1_flow_chi_nominal,
    each addPowerToMedium=false,
    per=perPumCW,
    each energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    each use_inputFilter=false)
    "Condenser water pump"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={-50,100})));

  Buildings.Applications.DataCenters.ChillerCooled.Equipment.CoolingCoilHumidifyingHeating ahu(
    redeclare replaceable package Medium1 = MediumW,
    redeclare replaceable package Medium2 = MediumA,
    m1_flow_nominal=numChi*m2_flow_chi_nominal,
    m2_flow_nominal=mAir_flow_nominal,
    dpValve_nominal=6000,
    dp2_nominal=600,
    mWatMax_flow=0.01,
    UA_nominal=UA_nominal,
    addPowerToMedium=false,
    perFan(
      pressure(dp=800*{1.2,1.12,1},
         V_flow=mAir_flow_nominal/1.29*{0,0.5,1}),
         motorCooledByFluid=false),
    yValSwi=yValMinAHU + 0.1,
    yValDeaBan=0.05,
    QHeaMax_flow=30000,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    dp1_nominal=30000)
    "Air handling unit"
    annotation (Placement(transformation(extent={{0,-130},{20,-110}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TCHWRet(
    redeclare replaceable package Medium = MediumW,
    m_flow_nominal=numChi*m2_flow_chi_nominal)
    "Chilled water return temperature"
    annotation (Placement(transformation(extent={{100,-10},{80,10}})));
  Buildings.Fluid.Sources.Boundary_pT expVesChi(
    redeclare replaceable package Medium = MediumW,
    nPorts=1)
    "Expansion tank"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={132,-113})));
  Buildings.Fluid.Sensors.RelativePressure senRelPre(
    redeclare replaceable package Medium =MediumW)
    "Differential pressure"
    annotation (Placement(transformation(extent={{-2,-86},{18,-106}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TAirSup(
    redeclare replaceable package Medium = MediumA,
    m_flow_nominal=mAir_flow_nominal)
    "Supply air temperature"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-50,-150})));
  Buildings.Examples.ChillerPlant.BaseClasses.SimplifiedRoom roo(
    redeclare replaceable package Medium = MediumA,
    rooLen=50,
    rooWid=30,
    rooHei=3,
    m_flow_nominal=mAir_flow_nominal,
    QRoo_flow=500000,
    nPorts=2)
    "Room model"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        origin={4,-180})));
  Buildings.Fluid.Actuators.Valves.TwoWayLinear val[numChi](
    redeclare each package Medium = MediumW,
    each m_flow_nominal=m1_flow_chi_nominal,
    each dpValve_nominal=6000,
    each use_inputFilter=false)
    "Shutoff valves"
    annotation (Placement(transformation(extent={{70,130},{50,150}})));

  Modelica.Blocks.Sources.Constant TCHWSupSet(k=TCHWSet)
    "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-260,150},{-240,170}})));
  Buildings.Applications.DataCenters.ChillerCooled.Controls.ChillerStage chiStaCon(
    QEva_nominal=QEva_nominal, tWai=0,
    criPoiTem=TCHWSet + 1.5)
    "Chiller staging control"
    annotation (Placement(transformation(extent={{-170,130},{-150,150}})));
  Modelica.Blocks.Math.RealToBoolean chiOn[numChi]
    "Real value to boolean value"
    annotation (Placement(transformation(extent={{-130,130},{-110,150}})));
  Modelica.Blocks.Math.IntegerToBoolean intToBoo(
    threshold=Integer(Buildings.Applications.DataCenters.Types.CoolingModes.FullMechanical))
    "Inverse on/off signal for the WSE"
    annotation (Placement(transformation(extent={{-170,100},{-150,120}})));
  Modelica.Blocks.Logical.Not wseOn
    "True: WSE is on; False: WSE is off "
    annotation (Placement(transformation(extent={{-130,100},{-110,120}})));
  Buildings.Applications.DataCenters.ChillerCooled.Controls.ConstantSpeedPumpStage CWPumCon(
    tWai=0)
    "Condenser water pump controller"
    annotation (Placement(transformation(extent={{-172,60},{-152,80}})));
  Modelica.Blocks.Sources.IntegerExpression chiNumOn(
    y=integer(sum(chiStaCon.y)))
    "The number of running chillers"
    annotation (Placement(transformation(extent={{-260,54},{-238,76}})));
  Modelica.Blocks.Math.Gain gai[numChi](
    each k=m1_flow_chi_nominal) "Gain effect"
    annotation (Placement(transformation(extent={{-130,60},{-110,80}})));
  Buildings.Applications.DataCenters.ChillerCooled.Controls.CoolingTowerSpeed cooTowSpeCon(
    yMin=0,
    Ti=60,
    k=0.1)
    "Cooling tower speed control"
    annotation (Placement(transformation(extent={{-170,170},{-150,186}})));
  Modelica.Blocks.Sources.RealExpression TCWSupSet(
    y=min(29.44 + 273.15, max(273.15 + 15.56, cooTow[1].TAir + 3)))
    "Condenser water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-260,176},{-240,196}})));

  Modelica.Blocks.Sources.Constant TAirSupSet(k=TSupAirSet)
    "Supply air temperature setpoint"
    annotation (Placement(transformation(extent={{-140,-90},{-120,-70}})));
  Buildings.Applications.BaseClasses.Controls.VariableSpeedPumpStage varSpeCon(
    tWai=tWai,
    m_flow_nominal=m2_flow_chi_nominal,
    deaBanSpe=0.45)
    "Speed controller"
    annotation (Placement(transformation(extent={{-168,-14},{-148,6}})));
  Modelica.Blocks.Sources.RealExpression mPum_flow(
    y=chiWSE.port_b2.m_flow)
    "Mass flowrate of variable speed pumps"
    annotation (Placement(transformation(extent={{-220,-6},{-200,14}})));
  Buildings.Controls.Continuous.LimPID pumSpe(
    Ti=40,
    yMin=0.2,
    k=0.1)
    "Pump speed controller"
    annotation (Placement(transformation(extent={{-246,-30},{-226,-10}})));
  Modelica.Blocks.Sources.Constant dpSetSca(k=1)
    "Scaled differential pressure setpoint"
    annotation (Placement(transformation(extent={{-280,-30},{-260,-10}})));
  Modelica.Blocks.Math.Product pumSpeSig[numChi]
    "Pump speed signal"
    annotation (Placement(transformation(extent={{-120,-20},{-100,0}})));
  Buildings.Controls.Continuous.LimPID ahuValSig(
        Ti=40,
    reverseActing=false,
    yMin=yValMinAHU,
    k=0.01)          "Valve position signal for the AHU"
    annotation (Placement(transformation(extent={{-82,-90},{-62,-70}})));
  Modelica.Blocks.Math.Product cooTowSpe[numChi]
    "Cooling tower speed"
    annotation (Placement(transformation(extent={{-60,166},{-44,182}})));

  Buildings.Controls.Continuous.LimPID ahuFanSpeCon(
        k=0.1,
    reverseActing=false,
    yMin=0.2,
    Ti=240)   "Fan speed controller "
    annotation (Placement(transformation(extent={{-120,-170},{-100,-150}})));
  Modelica.Blocks.Sources.Constant TAirRetSet(k=TRetAirSet)
    "Return air temperature setpoint"
    annotation (Placement(transformation(extent={{-180,-170},{-160,-150}})));
  Utilities.Psychrometrics.X_pTphi XAirSupSet(use_p_in=false)
    "Mass fraction setpoint of supply air "
    annotation (Placement(transformation(extent={{-140,-100},{-120,-120}})));
  Modelica.Blocks.Sources.Constant phiAirRetSet(k=0.5)
    "Return air relative humidity setpoint"
    annotation (Placement(transformation(extent={{-180,-100},{-160,-80}})));
  Modelica.Blocks.Math.Gain gai1(k=1/dpSetPoi) "Gain effect"
    annotation (Placement(transformation(extent={{-200,-70},{-220,-50}})));
equation
  connect(chiWSE.port_b2, TCHWSup.port_a)
    annotation (Line(
      points={{0,24},{-8,24},{-8,0},{-16,0}},
      color={0,127,255},
      thickness=0.5));
  connect(chiWSE.port_b1, TCWRet.port_a)
    annotation (Line(
      points={{20,36},{40,36},{40,60},{82,60}},
      color={0,127,255},
      thickness=0.5));
  for i in 1:numChi loop
    connect(TCWSup.port_a, cooTow[i].port_b)
      annotation (Line(
        points={{-22,140},{0,140}},
        color={0,127,255},
        thickness=0.5));
    connect(pumCW[i].port_a, TCWSup.port_b)
      annotation (Line(
        points={{-50,110},{-50,140},{-42,140}},
        color={0,127,255},
        thickness=0.5));
    connect(TCWRet.port_b, val[i].port_a) annotation (Line(points={{102,60},{110,
            60},{110,140},{70,140}},
            color={0,127,255},
            thickness=0.5));
  connect(weaBus.TWetBul, cooTow[i].TAir) annotation (Line(
      points={{-328,-20},{-340,-20},{-340,200},{32,200},{32,144},{22,144}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  end for;
  connect(senRelPre.port_b, ahu.port_b1)
    annotation (Line(points={{18,-96},{30,-96},{30,-114},{20,-114}},
                color={0,127,255},thickness=0.5));
  connect(cooTow.port_a, val.port_b)
    annotation (Line(points={{20,140},{50,140}},
      color={0,127,255},
      thickness=0.5));

  connect(TCWRet.port_b, expVesCW.ports[1])
    annotation (Line(points={{102,60},{110,60},{110,140.5},{122,140.5}},
    color={0,127,255},
    thickness=0.5));
  connect(ahu.port_b1, expVesChi.ports[1])
    annotation (Line(
      points={{20,-114},{122,-114},{122,-113}},
      color={0,127,255},
      thickness=0.5));

  connect(chiWSE.port_b2, TCHWSup.port_a)
    annotation (Line(
      points={{0,24},{-8,24},{-8,0},{-16,0}},
      color={0,127,255},
      thickness=0.5));
  connect(chiWSE.port_b1, TCWRet.port_a)
    annotation (Line(
      points={{20,36},{40,36},{40,60},{82,60}},
      color={0,127,255},
      thickness=0.5));
   for i in 1:numChi loop
    connect(TCWSup.port_a, cooTow[i].port_b)
      annotation (Line(
        points={{-22,140},{0,140}},
        color={0,127,255},
        thickness=0.5));
    connect(pumCW[i].port_b, chiWSE.port_a1)
      annotation (Line(
        points={{-50,90},{-50,64},{-12,64},{-12,36},{0,36}},
        color={0,127,255},
        thickness=0.5));
    connect(chiOn[i].y, chiWSE.on[i])
      annotation (Line(
        points={{-109,140},{-80,140},{-80,37.6},{-1.6,37.6}},
        color={255,0,255}));
   connect(cooTowSpeCon.y, cooTowSpe[i].u1)
     annotation (Line(
       points={{-149,178.889},{-84,178.889},{-84,178.8},{-61.6,178.8}},
       color={0,0,127}));
   end for;
  connect(chiStaCon.y, chiOn.u)
    annotation (Line(
      points={{-149,140},{-132,140}},
      color={0,0,127}));
  connect(intToBoo.y, wseOn.u)
    annotation (Line(
      points={{-149,110},{-132,110}},
      color={255,0,255}));
  connect(wseOn.y, chiWSE.on[numChi + 1])
    annotation (Line(
      points={{-109,110},{-80,110},{-80,37.6},{-1.6,37.6}},
      color={255,0,255}));
  connect(CWPumCon.y, gai.u)
    annotation (Line(
      points={{-151,70},{-132,70}},
      color={0,0,127}));
  connect(gai.y, pumCW.m_flow_in)
    annotation (Line(
      points={{-109,70},{-68,70},{-68,100},{-62,100}},
      color={0,0,127}));
  connect(TCWSupSet.y, cooTowSpeCon.TCWSupSet)
    annotation (Line(
      points={{-239,186},{-172,186}},
      color={0,0,127}));
  connect(TCHWSupSet.y, cooTowSpeCon.TCHWSupSet)
    annotation (Line(
      points={{-239,160},{-184,160},{-184,178.889},{-172,178.889}},
      color={0,0,127}));
  connect(TCWSup.T, cooTowSpeCon.TCWSup)
    annotation (Line(
      points={{-32,151},{-32,160},{-182,160},{-182,175.333},{-172,175.333}},
      color={0,0,127}));
  connect(TCHWSup.T, cooTowSpeCon.TCHWSup)
    annotation (Line(
      points={{-26,11},{-26,18},{-180,18},{-180,171.778},{-172,171.778}},
      color={0,0,127}));
  connect(chiWSE.TSet, TCHWSupSet.y)
    annotation (Line(
      points={{-1.6,40.8},{-20,40.8},{-20,52},{-230,52},{-230,160},{-239,160}},
      color={0,0,127}));
  connect(mPum_flow.y, varSpeCon.masFloPum)
    annotation (Line(
      points={{-199,4},{-170,4}},
      color={0,0,127}));
  connect(senRelPre.port_a, ahu.port_a1)
    annotation (Line(
      points={{-2,-96},{-14,-96},{-14,-114},{0,-114}},
      color={0,127,255},
      thickness=0.5));
  connect(pumSpe.y, varSpeCon.speSig)
    annotation (Line(
      points={{-225,-20},{-196,-20},{-196,0},{-170,0}},
      color={0,0,127}));
  connect(dpSetSca.y, pumSpe.u_s)
    annotation (Line(points={{-259,-20},{-248,-20}}, color={0,0,127}));
  connect(pumSpe.y, pumSpeSig[1].u2)
    annotation (Line(
      points={{-225,-20},{-196,-20},{-196,-36},{-136,-36},{-136,-16},{-122,-16}},
      color={0,0,127}));
  connect(pumSpe.y, pumSpeSig[2].u2)
    annotation (Line(
      points={{-225,-20},{-196,-20},{-196,-36},{-136,-36},{-136,-16},{-122,-16}},
      color={0,0,127}));
  connect(varSpeCon.y, pumSpeSig.u1)
    annotation (Line(
      points={{-147,-4},{-122,-4}},
      color={0,0,127}));
  connect(TAirSupSet.y, ahuValSig.u_s)
    annotation (Line(
      points={{-119,-80},{-84,-80}},
      color={0,0,127}));
  connect(TAirSup.port_a, ahu.port_b2)
    annotation (Line(
      points={{-50,-140},{-50,-126},{0,-126}},
      color={0,127,255},
      thickness=0.5));
  connect(TAirSup.T, ahuValSig.u_m)
    annotation (Line(
      points={{-61,-150},{-72,-150},{-72,-92}},
      color={0,0,127}));
  connect(ahuValSig.y, ahu.uVal)
    annotation (Line(
      points={{-61,-80},{-52,-80},{-52,-116},{-1,-116}},
      color={0,0,127}));
  connect(TAirSupSet.y, ahu.TSet)
    annotation (Line(
      points={{-119,-80},{-100,-80},{-100,-121},{-1,-121}},
      color={0,0,127}));
  connect(CWPumCon.y, val.y)
    annotation (Line(
      points={{-151,70},{-142,70},{-142,94},{-72,94},{-72,194},{60,194},{60,152}},
      color={0,0,127}));
  connect(CWPumCon.y, cooTowSpe.u2)
    annotation (Line(
      points={{-151,70},{-142,70},{-142,94},{-72,94},{-72,169.2},{-61.6,169.2}},
      color={0,0,127}));
  connect(cooTowSpe.y, cooTow.y)
    annotation (Line(
      points={{-43.2,174},{40,174},{40,148},{22,148}},
      color={0,0,127}));
  connect(TCHWRet.port_a, ahu.port_b1)
    annotation (Line(
      points={{100,0},{110,0},{110,-114},{20,-114}},
      color={0,127,255},
      thickness=0.5));
  connect(chiNumOn.y, CWPumCon.numOnChi)
    annotation (Line(
      points={{-236.9,65},{-174,65}},
      color={255,127,0}));
  connect(ahu.port_a2, roo.airPorts[1])
    annotation (Line(
      points={{20,-126},{32,-126},{32,-196},{1.525,-196},{1.525,-188.7}},
      color={0,127,255},
      thickness=0.5));

  connect(roo.airPorts[2], TAirSup.port_b)
    annotation (Line(
      points={{5.575,-188.7},{5.575,-196},{-50,-196},{-50,-160}},
      color={0,127,255},
      thickness=0.5));
  connect(roo.TRooAir, ahuFanSpeCon.u_m)
    annotation (Line(
      points={{-7,-180},{-110,-180},{-110,-172}},
      color={0,0,127}));
  connect(TAirRetSet.y, ahuFanSpeCon.u_s)
    annotation (Line(
      points={{-159,-160},{-122,-160}},
      color={0,0,127}));
  connect(phiAirRetSet.y, XAirSupSet.phi)
    annotation (Line(
      points={{-159,-90},{-150,-90},{-150,-104},{-142,-104}},
      color={0,0,127}));
  connect(XAirSupSet.X[1], ahu.XSet_w)
    annotation (Line(
      points={{-119,-110},{-60,-110},{-60,-119},{-1,-119}},
      color={0,0,127}));
  connect(TAirRetSet.y, XAirSupSet.T)
    annotation (Line(
      points={{-159,-160},{-150,-160},{-150,-110},{-142,-110}},
      color={0,0,127}));
  connect(ahuFanSpeCon.y, ahu.uFan)
    annotation (Line(
      points={{-99,-160},{-80,-160},{-80,-124},{-1,-124}},
      color={0,0,127}));
  connect(gai1.y, pumSpe.u_m) annotation (Line(points={{-221,-60},{-236,-60},{
          -236,-32}}, color={0,0,127}));
  connect(gai1.u, senRelPre.p_rel)
    annotation (Line(points={{-198,-60},{8,-60},{8,-87}}, color={0,0,127}));
  connect(weaData.weaBus, weaBus) annotation (Line(
      points={{-340,-70},{-328,-70},{-328,-20}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false,
    extent={{-360,-200},{160,220}})),
    Documentation(info="<html>
<p>
This is a partial model that describes the chilled water cooling system in a data center. The sizing data
are collected from the reference.
</p>
<h4>Reference </h4>
<ul>
<li>
Taylor, S. T. (2014). How to design &amp; control waterside economizers. ASHRAE Journal, 56(6), 30-36.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
November 1, 2021, by Michael Wetter:<br/>
Corrected weather data bus connection which was structurally incorrect
and did not parse in OpenModelica.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2706\">issue 2706</a>.
</li>
<li>
October 6, 2020, by Michael Wetter:<br/>
Set <code>val.use_inputFilter=false</code> because pump worked against closed valve at <i>t=60</i> seconds,
leading to negative pressure at pump inlet (because pump forces the mass flow rate).
</li>
<li>
January 12, 2019, by Michael Wetter:<br/>
Removed wrong <code>each</code>.
</li>
<li>
December 1, 2017, by Yangyang Fu:<br/>
Used scaled differential pressure to control the speed of pumps. This can avoid retuning gains
in PID when changing the differential pressure setpoint.
</li>
<li>
September 2, 2017, by Michael Wetter:<br/>
Changed expansion vessel to use the more efficient implementation.
</li>
<li>
July 30, 2017, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialDataCenter;
