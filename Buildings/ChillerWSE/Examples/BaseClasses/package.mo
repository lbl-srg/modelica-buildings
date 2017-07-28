within Buildings.ChillerWSE.Examples;
package BaseClasses "Base classes for examples"
  extends Modelica.Icons.BasesPackage;

  partial model DataCenter
    "Example that show how to use Buildings.ChillerWSE.IntegratedPrimaryLoadSide"
    import Buildings;

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

    replaceable Buildings.ChillerWSE.BaseClasses.PartialChillerWSE chiWSE(
      redeclare replaceable package Medium1 = MediumW,
      redeclare replaceable package Medium2 = MediumW,
      nChi=nChi,
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
        perChi,
      use_inputFilter=false) "Chillers and waterside economizer"
      annotation (Placement(transformation(extent={{126,22},{146,42}})));
    Buildings.Fluid.Storage.ExpansionVessel expVesChi(redeclare replaceable
      package                                                                       Medium =
          MediumW, V_start=1)
      annotation (Placement(transformation(extent={{230,125},{250,145}})));
    Buildings.Fluid.HeatExchangers.CoolingTowers.YorkCalc cooTow[nChi](
      redeclare each replaceable package Medium = MediumW,
      each m_flow_nominal=mChiller1_flow_nominal,
      each dp_nominal=14930 + 14930 + 74650,
      each TAirInWB_nominal(displayUnit="degC") = 283.15,
      each TApp_nominal=6,
      each PFan_nominal=6000,
      each energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial)
                                             "Cooling tower" annotation (
        Placement(transformation(extent={{10,-10},{-10,10}}, origin={141,141})));
    Buildings.Fluid.Sensors.TemperatureTwoPort CHWST(redeclare replaceable
      package                                                                      Medium = MediumW,
        m_flow_nominal=nChi*mChiller2_flow_nominal)
      "Chilled water supply temperature"
      annotation (Placement(transformation(extent={{104,-10},{84,10}})));
    Modelica.Blocks.Sources.Constant CHWSTSet(k(
        unit="K",
        displayUnit="degC") = 273.15 + 6.56)
      "Chilled water supply temperature setpoint"
      annotation (Placement(transformation(extent={{-190,150},{-170,170}})));
    Buildings.BoundaryConditions.WeatherData.ReaderTMY3           weaData(filNam=
          "modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos")
      annotation (Placement(transformation(extent={{-220,-78},{-200,-58}})));
    Buildings.BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
      annotation (Placement(transformation(extent={{-210,-38},{-190,-18}})));
    Buildings.Fluid.Sensors.TemperatureTwoPort CWST(redeclare replaceable
      package                                                                     Medium = MediumW,
        m_flow_nominal=nChi*mChiller1_flow_nominal)
      "Condenser water supply temperature"
      annotation (Placement(transformation(extent={{120,132},{100,152}})));
    Buildings.Fluid.Sensors.TemperatureTwoPort CWRT(redeclare replaceable
      package                                                                     Medium = MediumW,
        m_flow_nominal=nChi*mChiller1_flow_nominal)
      "Condenser water return temperature"
      annotation (Placement(transformation(extent={{202,50},{222,70}})));
    Buildings.Fluid.Movers.FlowControlled_m_flow pumCW[2](
      redeclare each replaceable package Medium = MediumW,
      each m_flow_nominal=mChiller1_flow_nominal,
      each addPowerToMedium=false)           annotation (Placement(transformation(
          extent={{-10,10},{10,-10}},
          rotation=-90,
          origin={70,100})));
    Buildings.ChillerWSE.Examples.BaseClasses.Controls.CoolingModeControl
      cooModCon(
      deaBan1=1,
      deaBan2=1,
      tWai=tWai) "Cooling mode controller"
      annotation (Placement(transformation(extent={{-130,100},{-110,120}})));
    Modelica.Blocks.Sources.RealExpression towTApp(y=max(cooTow[1:nChi].TAppAct))
      "Cooling tower approach temperature"
      annotation (Placement(transformation(extent={{-190,100},{-170,120}})));
    Buildings.ChillerWSE.Examples.BaseClasses.Controls.ChillerStageControl
      chiStaCon(QEva_nominal=-300*3517, tWai=0) "Chiller staging control"
      annotation (Placement(transformation(extent={{-50,130},{-30,150}})));
    Modelica.Blocks.Math.RealToBoolean chiOn[nChi](each threshold=0.5)
      "Real value to boolean value"
      annotation (Placement(transformation(extent={{-10,130},{10,150}})));
    Modelica.Blocks.Math.RealToBoolean reaToBoo(threshold=1.5)
      "Inverse on/off signal for the WSE"
      annotation (Placement(transformation(extent={{-50,100},{-30,120}})));
    Modelica.Blocks.Logical.Not wseOn "True: WSE is on; False: WSE is off "
      annotation (Placement(transformation(extent={{-10,100},{10,120}})));
    Buildings.ChillerWSE.Examples.BaseClasses.Controls.ConstantSpeedPumpStageControl
      CWPumCon(tWai=0) "Condenser water pump controller"
      annotation (Placement(transformation(extent={{-52,60},{-32,80}})));
    Modelica.Blocks.Sources.RealExpression chiNumOn(y=sum(chiStaCon.y))
      "The number of running chillers"
      annotation (Placement(transformation(extent={{-130,64},{-110,84}})));
    Modelica.Blocks.Math.Gain gai[nChi](each k=mChiller1_flow_nominal)
                                                                  "Gain effect"
      annotation (Placement(transformation(extent={{-10,60},{10,80}})));
    Buildings.ChillerWSE.Examples.BaseClasses.Controls.CoolingTowerSpeedControl
      cooTowSpeCon(controllerType=Modelica.Blocks.Types.SimpleController.PI,
        reset=Buildings.Types.Reset.Disabled) "Cooling tower speed control"
      annotation (Placement(transformation(extent={{-50,170},{-30,186}})));
    Modelica.Blocks.Sources.Constant CWSTSet(k(
        unit="K",
        displayUnit="degC") = 273.15 + 20)
      "Condenser water supply temperature setpoint"
      annotation (Placement(transformation(extent={{-130,170},{-110,190}})));

    Buildings.Fluid.Air.AirHandlingUnit ahu(
      redeclare replaceable package Medium1 = MediumW,
      redeclare replaceable package Medium2 = MediumA,
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
      annotation (Placement(transformation(extent={{152,-102},{172,-82}})));
    Buildings.Fluid.Sensors.TemperatureTwoPort CHWRT(redeclare replaceable
      package                                                                      Medium = MediumW,
        m_flow_nominal=nChi*mChiller2_flow_nominal)
      "Chilled water return temperature"
      annotation (Placement(transformation(extent={{224,-10},{204,10}})));
    Buildings.Fluid.Storage.ExpansionVessel expVesChi1(
          redeclare replaceable package Medium = MediumW, V_start=1)
      annotation (Placement(transformation(extent={{240,-39},{260,-19}})));
    Modelica.Blocks.Sources.Constant SATSet(k(
        unit="K",
        displayUnit="degC") = 273.15 + 16) "Supply air temperature setpoint"
      annotation (Placement(transformation(extent={{-80,-98},{-60,-78}})));
    Modelica.Blocks.Sources.Constant SAXSet(k=MediumA.X_default[1])
      "Supply air mass fraction setpoint"
      annotation (Placement(transformation(extent={{-12,-136},{8,-116}})));
    Modelica.Blocks.Sources.Constant uFan(k = 1)
      "Chilled water supply temperature setpoint"
      annotation (Placement(transformation(extent={{-12,-176},{8,-156}})));
    Buildings.ChillerWSE.Examples.BaseClasses.Controls.VariableSpeedPumpStageControl
      varSpeCon(tWai=tWai, m_flow_nominal=mChiller2_flow_nominal)
      "Speed controller"
      annotation (Placement(transformation(extent={{-48,-14},{-28,6}})));
    Modelica.Blocks.Sources.RealExpression mPum_flow(y=chiWSE.port_b2.m_flow)
      "Mass flowrate of variable speed pumps"
      annotation (Placement(transformation(extent={{-126,-6},{-106,14}})));
    Buildings.Fluid.Sensors.RelativePressure senRelPre(redeclare replaceable
      package                                                                        Medium = MediumW)
      annotation (Placement(transformation(extent={{150,-50},{170,-70}})));
    Buildings.Controls.Continuous.LimPID pumSpe(
      controllerType=Modelica.Blocks.Types.SimpleController.PI,
      k=0.1,
      Ti=40,
      yMin=0.2) "Pump speed controller"
      annotation (Placement(transformation(extent={{-126,-30},{-106,-10}})));
    Modelica.Blocks.Sources.Constant dpSet(k=0.3*dpChiller2_nominal)
      "Differential pressure setpoint"
      annotation (Placement(transformation(extent={{-176,-30},{-156,-10}})));
    Modelica.Blocks.Math.Product pumSpeSig[nChi] "Pump speed signal"
      annotation (Placement(transformation(extent={{-4,-22},{12,-6}})));
    Buildings.Controls.Continuous.LimPID ahuValSig(
      controllerType=Modelica.Blocks.Types.SimpleController.PI,
      k=0.1,
      Ti=40,
      yMin=0.2,
      reverseAction=true) "Valve position signal for the AHU"
      annotation (Placement(transformation(extent={{-12,-98},{8,-78}})));
    Buildings.Fluid.Sensors.TemperatureTwoPort SAT(redeclare replaceable
      package                                                                    Medium = MediumA,
        m_flow_nominal=mAir_flow_nominal) "Supply air temperature"
      annotation (Placement(transformation(extent={{112,-130},{92,-110}})));
    Buildings.Examples.ChillerPlant.BaseClasses.SimplifiedRoom roo(
      redeclare replaceable package Medium = MediumA,
      nPorts=2,
      rooLen=50,
      rooWid=30,
      rooHei=3,
      m_flow_nominal=mAir_flow_nominal,
      QRoo_flow=500000) "Room model" annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          origin={166,-168})));
  equation
    connect(chiWSE.port_b2, CHWST.port_a) annotation (Line(
        points={{126,26},{112,26},{112,0},{104,0}},
        color={0,127,255},
        thickness=0.5));
    connect(weaData.weaBus, weaBus.TWetBul) annotation (Line(
        points={{-200,-68},{-200,-28}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}}));
    connect(chiWSE.port_b1, CWRT.port_a) annotation (Line(
        points={{146,38},{160,38},{160,60},{202,60}},
        color={0,127,255},
        thickness=0.5));
    connect(CWRT.port_b, expVesChi.port_a)
      annotation (Line(points={{222,60},{240,60},{240,125}},color={0,127,255},
        thickness=0.5));

     for i in 1:nChi loop
       connect(cooTow[i].TAir, weaBus.TWetBul.TWetBul) annotation (Line(points={{153,145},
              {153,145},{160,145},{160,200},{-216,200},{-216,-28},{-200,-28}},
                                         color={0,0,127}));

       connect(cooTow[i].port_a, expVesChi.port_a)
         annotation (Line(points={{151,141},{200,141},{200,138},{200,118},{240,118},
              {240,125}},                                   color={0,127,255},
          thickness=0.5));
      connect(CWST.port_a, cooTow[i].port_b) annotation (Line(points={{120,142},{132,
              142},{132,141},{131,141}},     color={0,127,255},
          thickness=0.5));
      connect(pumCW[i].port_b, chiWSE.port_a1) annotation (Line(
          points={{70,90},{70,58},{110,58},{110,38},{126,38}},
          color={0,127,255},
          thickness=0.5));

      connect(pumCW[i].port_a, CWST.port_b) annotation (Line(points={{70,110},{70,
              142},{100,142}},     color={0,127,255},
          thickness=0.5));
      connect(chiOn[i].y, chiWSE.on[i]) annotation (Line(points={{11,140},{40,140},
              {40,39.6},{124.4,39.6}}, color={255,0,255}));
     end for;
    connect(CHWSTSet.y, cooModCon.CHWSTSet) annotation (Line(points={{-169,160},{-150,
            160},{-150,118},{-132,118}}, color={0,0,127}));
    connect(towTApp.y, cooModCon.towTApp) annotation (Line(points={{-169,110},{-170,
            110},{-170,110},{-168,110},{-132,110},{-132,110}},
                                                         color={0,0,127}));
    connect(weaBus.TWetBul.TWetBul, cooModCon.TWetBul) annotation (Line(
        points={{-200,-28},{-216,-28},{-216,200},{-150,200},{-150,114},{-132,114}},
        color={255,204,51},
        thickness=0.5));
    connect(cooModCon.cooMod, chiStaCon.cooMod) annotation (Line(points={{-109,110},
            {-70,110},{-70,148},{-52,148}},   color={0,0,127}));
    connect(chiStaCon.y, chiOn.u) annotation (Line(points={{-29,140},{-20.5,140},{
            -12,140}},  color={0,0,127}));
    connect(cooModCon.cooMod,reaToBoo. u) annotation (Line(points={{-109,110},{-94,
            110},{-52,110}},            color={0,0,127}));
    connect(reaToBoo.y, wseOn.u) annotation (Line(points={{-29,110},{-20.5,110},{-12,
            110}},     color={255,0,255}));
    connect(wseOn.y, chiWSE.on[nChi + 1]) annotation (Line(points={{11,110},{40,110},
            {40,39.6},{124.4,39.6}}, color={255,0,255}));
    connect(cooModCon.cooMod, CWPumCon.cooMod) annotation (Line(points={{-109,110},
            {-70,110},{-70,78},{-54,78}}, color={0,0,127}));
    connect(chiNumOn.y, CWPumCon.chiNumOn)
      annotation (Line(points={{-109,74},{-109,74},{-54,74}},
                                                            color={0,0,127}));
    connect(CWPumCon.y, gai.u)
      annotation (Line(points={{-31,70},{-12,70}},       color={0,0,127}));
    connect(gai.y, pumCW.m_flow_in) annotation (Line(points={{11,70},{40,70},{40,100},
            {58,100}}, color={0,0,127}));
    connect(CWSTSet.y, cooTowSpeCon.CWST_set) annotation (Line(points={{-109,180},
            {-70,180},{-70,186},{-52,186}}, color={0,0,127}));
    connect(cooModCon.cooMod, cooTowSpeCon.cooMod) annotation (Line(points={{-109,
          110},{-70,110},{-70,182.444},{-52,182.444}},
                                                 color={0,0,127}));
    connect(CHWSTSet.y, cooTowSpeCon.CHWST_set) annotation (Line(points={{-169,
          160},{-150,160},{-150,200},{-70,200},{-70,178.889},{-52,178.889}},
                                                                       color={0,0,
            127}));
    connect(CWST.T, cooTowSpeCon.CWST) annotation (Line(points={{110,153},{110,
          160},{122,160},{122,200},{-70,200},{-70,175.333},{-52,175.333}},
                                                                     color={0,0,
            127}));
    connect(CHWST.T, cooTowSpeCon.CHWST) annotation (Line(points={{94,11},{94,
          36},{40,36},{40,200},{-70,200},{-70,171.778},{-52,171.778}},
                                                 color={0,0,127}));
    connect(cooTowSpeCon.y, cooTow[1].y) annotation (Line(points={{-29,178.889},
          {-20,178.889},{-20,200},{160,200},{160,149},{153,149}},
                                           color={0,0,127}));
    connect(cooTowSpeCon.y, cooTow[2].y) annotation (Line(points={{-29,178.889},
          {-20,178.889},{-20,200},{160,200},{160,149},{153,149}},
                                           color={0,0,127}));
    connect(chiWSE.TSet, CHWSTSet.y) annotation (Line(points={{124.4,42.8},{40,42.8},
            {40,200},{-150,200},{-150,160},{-169,160}}, color={0,0,127}));
    connect(CHWRT.port_b, chiWSE.port_a2) annotation (Line(
        points={{204,0},{160,0},{160,26},{146,26}},
        color={0,127,255},
        thickness=0.5));
    connect(cooModCon.wseCHWRT, CHWRT.T) annotation (Line(points={{-132,102},{-150,
            102},{-150,200},{260,200},{260,20},{214,20},{214,12},{214,11}}, color=
           {0,0,127}));
    connect(SAXSet.y, ahu.XSet_w) annotation (Line(points={{9,-126},{60,-126},{60,
            -91},{151,-91}}, color={0,0,127}));
    connect(uFan.y, ahu.uFan) annotation (Line(points={{9,-166},{60,-166},{60,-96},
            {151,-96}}, color={0,0,127}));
    connect(expVesChi1.port_a, ahu.port_b1) annotation (Line(points={{250,-39},{250,
            -39},{250,-86},{172,-86}},               color={0,127,255},
        thickness=0.5));
    connect(mPum_flow.y, varSpeCon.masFloPum) annotation (Line(points={{-105,4},{-50,
            4}},                       color={0,0,127}));
    connect(senRelPre.port_a, ahu.port_a1) annotation (Line(points={{150,-60},{72,
            -60},{72,-86},{152,-86}},      color={0,127,255},
        thickness=0.5));
    connect(senRelPre.port_b, ahu.port_b1) annotation (Line(points={{170,-60},{232,
            -60},{232,-86},{172,-86}},     color={0,127,255},
        thickness=0.5));
    connect(pumSpe.y, varSpeCon.speSig) annotation (Line(points={{-105,-20},{-76,-20},
            {-76,0},{-50,0}},        color={0,0,127}));
    connect(senRelPre.p_rel, pumSpe.u_m) annotation (Line(points={{160,-51},{160,-51},
            {160,-40},{-116,-40},{-116,-32}},                          color={0,0,
            127}));
    connect(dpSet.y, pumSpe.u_s) annotation (Line(points={{-155,-20},{-128,-20}},
                                   color={0,0,127}));
    connect(pumSpe.y, pumSpeSig[1].u2) annotation (Line(points={{-105,-20},{-76,-20},
            {-76,-34},{-16,-34},{-16,-18.8},{-5.6,-18.8}},   color={0,0,127}));
    connect(pumSpe.y, pumSpeSig[2].u2) annotation (Line(points={{-105,-20},{-105,-20},
            {-76,-20},{-76,-34},{-16,-34},{-16,-18.8},{-5.6,-18.8}},   color={0,0,
            127}));
    connect(varSpeCon.y, pumSpeSig.u1) annotation (Line(points={{-27,-4},{-27,-4},
            {-16,-4},{-16,-9.2},{-5.6,-9.2}},    color={0,0,127}));
    connect(SATSet.y, ahuValSig.u_s)
      annotation (Line(points={{-59,-88},{-48,-88},{-14,-88}}, color={0,0,127}));
    connect(SAT.port_a, ahu.port_b2) annotation (Line(points={{112,-120},{140,-120},
            {140,-98},{152,-98}},
                                color={0,127,255},
        thickness=0.5));
    connect(SAT.T, ahuValSig.u_m) annotation (Line(points={{102,-109},{102,-109},{
            102,-104},{-2,-104},{-2,-100}},
                                          color={0,0,127}));
    connect(ahu.port_a2, roo.airPorts[1]) annotation (Line(points={{172,-98},{172,
            -98},{184,-98},{184,-120},{232,-120},{232,-158},{167.85,-158}},
                                                                    color={0,127,255},
        thickness=0.5));

    connect(SAT.port_b, roo.airPorts[2]) annotation (Line(points={{92,-120},{92,-120},
            {74,-120},{74,-158},{164.15,-158}},          color={0,127,255},
        thickness=0.5));
    connect(ahuValSig.y, ahu.uWatVal)
      annotation (Line(points={{9,-88},{60,-88},{151,-88}}, color={0,0,127}));
    connect(SATSet.y, ahu.TSet) annotation (Line(points={{-59,-88},{-40,-88},{-40,
            -60},{60,-60},{60,-93},{151,-93}}, color={0,0,127}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}})),                                  Diagram(
          coordinateSystem(preserveAspectRatio=false, extent={{-220,-180},{280,
              200}})),
      __Dymola_Commands(file=
            "Resources/Scripts/Dymola/ChillerWSE/Examples/IntegratedPrimaryLoadSide.mos"
          "Simulate and Plot"));
  end DataCenter;
end BaseClasses;
