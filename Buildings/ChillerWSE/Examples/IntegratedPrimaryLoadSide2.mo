within Buildings.ChillerWSE.Examples;
model IntegratedPrimaryLoadSide2
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
    annotation (Placement(transformation(extent={{64,22},{84,42}})));
  Buildings.Fluid.Storage.ExpansionVessel expVesChi(redeclare package Medium =
        MediumW, V_start=1)
    annotation (Placement(transformation(extent={{210,99},{230,119}})));
  Fluid.HeatExchangers.CoolingTowers.YorkCalc cooTow[nChi](
    redeclare package Medium = MediumW,
    PFan_nominal=6000,
    TAirInWB_nominal(displayUnit="degC") = 283.15,
    TApp_nominal=6,
    dp_nominal=14930 + 14930 + 74650,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
    m_flow_nominal=mChiller1_flow_nominal) "Cooling tower" annotation (
      Placement(transformation(extent={{10,-10},{-10,10}}, origin={99,131})));
  Fluid.Sources.FixedBoundary           sin2(
    nPorts=1, redeclare package Medium = MediumW)   "Sink on medium 2 side"
                                        annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        origin={-206,-96})));
  Fluid.Sensors.TemperatureTwoPort TSup(redeclare package Medium = MediumW,
      m_flow_nominal=nChi*mChiller2_flow_nominal)
    annotation (Placement(transformation(extent={{-140,-80},{-160,-60}})));
  redeclare replaceable Fluid.Sources.Boundary_pT                sou2(
    nPorts=1,
    redeclare package Medium = MediumW,
    T=291.15)
  constrainedby Fluid.Sources.Boundary_pT(
    use_T_in=true,
    redeclare package Medium = MediumCHW,
    T=291.15) "Source on medium 2 side"
    annotation (Placement(transformation(extent={{132,-84},{112,-64}})));
  Modelica.Blocks.Sources.Constant
                               TEva_in(k=273.15 + 25.28)
                   "Evaporator inlet temperature"
    annotation (Placement(transformation(extent={{236,-80},{216,-60}})));
  Modelica.Blocks.Sources.Constant TSet(k(unit="K",displayUnit="degC")=273.15+15.56)
    "Leaving chilled water temperature setpoint"
    annotation (Placement(transformation(extent={{-200,140},{-180,160}})));
  Modelica.Blocks.Sources.Constant yVal7(k=0) "Conrol signal for valve 7"
    annotation (Placement(transformation(extent={{42,-22},{62,-2}})));
  Modelica.Blocks.Sources.Constant yPum[nChi](k=1) "Conrol signal for pumps"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  Modelica.Blocks.Sources.Constant yFanCT(k=1) "Conrol signal for pumps"
    annotation (Placement(transformation(extent={{200,178},{180,198}})));
  BoundaryConditions.WeatherData.ReaderTMY3           weaData(filNam=
        "modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos")
    annotation (Placement(transformation(extent={{-200,168},{-180,188}})));
  BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
    annotation (Placement(transformation(extent={{-170,160},{-150,180}})));
  Fluid.Sensors.TemperatureTwoPort TSupCW(redeclare package Medium = MediumW,
      m_flow_nominal=nChi*mChiller1_flow_nominal)
    annotation (Placement(transformation(extent={{12,78},{-8,98}})));
  Fluid.Sensors.TemperatureTwoPort TRetCW(redeclare package Medium = MediumW,
      m_flow_nominal=nChi*mChiller1_flow_nominal)
    annotation (Placement(transformation(extent={{180,28},{200,48}})));
  Fluid.Movers.FlowControlled_m_flow pumCW[2](
    redeclare package Medium = MediumW,
    addPowerToMedium=false,
    m_flow_nominal=mChiller1_flow_nominal) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={-34,60})));
  Modelica.Blocks.Sources.Constant mPumCW[nChi](k=mChiller1_flow_nominal)
    "Conrol signal for pumps"
    annotation (Placement(transformation(extent={{-126,50},{-106,70}})));
  BaseClasses.CoolingModeControl cooModCon(
    tWai=1200,
    deaBan1=1,
    deaBan2=1) "Cooling mode controller"
    annotation (Placement(transformation(extent={{-140,120},{-120,140}})));
  Modelica.Blocks.Sources.RealExpression towTApp(y=max(cooTow[1:nChi].TAppAct))
    "Cooling tower approach temperature"
    annotation (Placement(transformation(extent={{-200,106},{-180,126}})));
  BaseClasses.ChillerStageControl chiStaCon(tWai=1200, QEva_nominal=-300*3517)
                                            "Chiller staging control"
    annotation (Placement(transformation(extent={{-80,140},{-60,160}})));
  Modelica.Blocks.Sources.RealExpression cooLoaChi(y=intWSEPri.port_a2.m_flow*
        4180*(intWSEPri.wseCHWST - TSet.y))
                                      "Cooling load in chillers"
    annotation (Placement(transformation(extent={{-120,178},{-100,198}})));
  Modelica.Blocks.Math.RealToBoolean chiOn[nChi](threshold=0.5)
    "Real value to boolean value"
    annotation (Placement(transformation(extent={{-40,140},{-20,160}})));
  Modelica.Blocks.Math.RealToBoolean reaToBoo(threshold=1.5)
    "Inverse on/off signal for the WSE"
    annotation (Placement(transformation(extent={{-80,110},{-60,130}})));
  Modelica.Blocks.Logical.Not wseOn "True: WSE is on; False: WSE is off "
    annotation (Placement(transformation(extent={{-40,110},{-20,130}})));
  Modelica.Blocks.Sources.RealExpression yVal5(y=if (chiOn[1].y or chiOn[2].y)
         and not wseOn.y then 1 else 0)
                        "On/off signal for valve 5"
    annotation (Placement(transformation(extent={{-80,18},{-60,38}})));
  Modelica.Blocks.Sources.RealExpression yVal6(y=if not (chiOn[1].y and chiOn[2].y)
         and wseOn.y then 1 else 0)
                        "On/off signal for valve 6"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
equation
  connect(sou2.T_in,TEva_in. y)
    annotation (Line(points={{134,-70},{215,-70}},        color={0,0,127}));
  connect(intWSEPri.port_b2, TSup.port_a) annotation (Line(points={{64,26},{38,
          26},{38,-70},{-140,-70}}, color={0,127,255}));
  connect(TSup.port_b, sin2.ports[1]) annotation (Line(points={{-160,-70},{-180,
          -70},{-180,-96},{-196,-96}},
                                color={0,127,255}));
  connect(intWSEPri.port_a2, sou2.ports[1]) annotation (Line(points={{84,26},{
          98,26},{98,-74},{112,-74}},
                                  color={0,127,255}));
  connect(TSet.y, intWSEPri.TSet) annotation (Line(points={{-179,150},{-162,150},
          {-162,42.8},{62.4,42.8}},     color={0,0,127}));
  connect(yVal7.y, intWSEPri.yVal7) annotation (Line(points={{63,-12},{63,-12},{
          70.8,-12},{70.8,20.4}},        color={0,0,127}));
  connect(weaData.weaBus, weaBus.TWetBul) annotation (Line(
      points={{-180,178},{-180,178},{-160,178},{-160,170}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(intWSEPri.port_b1, TRetCW.port_a)
    annotation (Line(points={{84,38},{180,38}},
                                             color={0,127,255}));
  connect(TRetCW.port_b, expVesChi.port_a)
    annotation (Line(points={{200,38},{220,38},{220,99}},
                                                     color={0,127,255}));

   for i in 1:nChi loop
     connect(cooTow[i].TAir, weaBus.TWetBul.TWetBul) annotation (Line(points={{111,135},
            {120,135},{120,170},{-160,170}},
                                       color={0,0,127}));

     connect(cooTow[i].y, yFanCT.y) annotation (Line(points={{111,139},{140,139},
            {140,188},{140,188},{179,188}},
                     color={0,0,127}));
     connect(cooTow[i].port_a, expVesChi.port_a)
       annotation (Line(points={{109,131},{140,131},{140,132},{140,132},{140,80},
            {220,80},{220,99}},                           color={0,127,255}));
     connect(TSupCW.port_a, cooTow[i].port_b) annotation (Line(points={{12,88},
            {40,88},{40,131},{89,131}},
                                 color={0,127,255}));
     connect(pumCW[i].port_b, intWSEPri.port_a1)
      annotation (Line(points={{-34,50},{-34,38},{64,38}},color={0,127,255}));

      connect(pumCW[i].port_a, TSupCW.port_b)
    annotation (Line(points={{-34,70},{-34,88},{-8,88}},  color={0,127,255}));
    connect(chiOn[i].y, intWSEPri.on[i]) annotation (Line(points={{-19,150},{32,
            150},{32,39.6},{62.4,39.6}}, color={255,0,255}));
   end for;
  connect(TSet.y, cooModCon.CHWSTSet) annotation (Line(points={{-179,150},{-162,
          150},{-162,138},{-142,138}}, color={0,0,127}));
  connect(towTApp.y, cooModCon.towTApp) annotation (Line(points={{-179,116},{
          -166,116},{-166,118},{-166,130},{-142,130}}, color={0,0,127}));
  connect(weaBus.TWetBul.TWetBul, cooModCon.TWetBul) annotation (Line(
      points={{-160,170},{-160,170},{-160,168},{-160,154},{-156,154},{-156,134},
          {-142,134}},
      color={255,204,51},
      thickness=0.5));
  connect(intWSEPri.wseCHWST, cooModCon.wseCHWST) annotation (Line(points={{85,36},
          {114,36},{114,106},{-160,106},{-160,126},{-142,126}},
        color={0,0,127}));
  connect(TEva_in.y, cooModCon.wseCHWRT) annotation (Line(points={{215,-70},{
          154,-70},{154,106},{-156,106},{-156,122},{-142,122}}, color={0,0,127}));
  connect(cooModCon.cooMod, chiStaCon.cooMod) annotation (Line(points={{-119,130},
          {-102,130},{-102,158},{-82,158}}, color={0,0,127}));
  connect(mPumCW.y, pumCW.m_flow_in)
    annotation (Line(points={{-105,60},{-46,60},{-46,60.2}}, color={0,0,127}));
  connect(cooLoaChi.y, chiStaCon.QTot) annotation (Line(points={{-99,188},{-94,188},
          {-94,154},{-82,154}}, color={0,0,127}));
  connect(chiStaCon.y, chiOn.u) annotation (Line(points={{-59,150},{-50.5,150},
          {-42,150}}, color={0,0,127}));
  connect(cooModCon.cooMod,reaToBoo. u) annotation (Line(points={{-119,130},{-102,
          130},{-102,120},{-82,120}}, color={0,0,127}));
  connect(reaToBoo.y, wseOn.u) annotation (Line(points={{-59,120},{-50.5,120},{
          -42,120}}, color={255,0,255}));
  connect(wseOn.y, intWSEPri.on[nChi + 1]) annotation (Line(points={{-19,120},{
          -10,120},{32,120},{32,39.6},{62.4,39.6}}, color={255,0,255}));
  connect(yPum.y, intWSEPri.yPum) annotation (Line(points={{-59,-20},{-2,-20},{
          -2,27.6},{62.4,27.6}}, color={0,0,127}));
  connect(yVal5.y, intWSEPri.yVal5) annotation (Line(points={{-59,28},{-38,28},
          {-38,35},{62.4,35}}, color={0,0,127}));
  connect(yVal6.y, intWSEPri.yVal6) annotation (Line(points={{-59,10},{-36,10},
          {-36,31.8},{62.4,31.8}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-220,
            -120},{240,200}})),                                  Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-220,-120},{240,
            200}})),
    __Dymola_Commands(file=
          "Resources/Scripts/Dymola/ChillerWSE/Examples/IntegratedPrimaryLoadSide.mos"
        "Simulate and Plot"));
end IntegratedPrimaryLoadSide2;
