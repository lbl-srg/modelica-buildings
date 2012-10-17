within Buildings.Examples.ChillerPlant;
model PrimaryOnlyWithEconomizer
  "Primary only chiller plant system with water-side economizer"
  extends Modelica.Icons.Example;
  package MediumAir = Buildings.Media.GasesPTDecoupled.SimpleAir "Medium model";
  package MediumCHW = Buildings.Media.ConstantPropertyLiquidWater
    "Medium model";
  package MediumCW = Buildings.Media.ConstantPropertyLiquidWater "Medium model";
  parameter Modelica.SIunits.MassFlowRate mAir_flow_nominal=roo.QRoo_flow/(1005
      *15) "Nominal mass flow rate at fan";
  parameter Modelica.SIunits.Power P_nominal=80E3
    "Nominal compressor power (at y=1)";
  parameter Modelica.SIunits.TemperatureDifference dTEva_nominal=10
    "Temperature difference evaporator inlet-outlet";
  parameter Modelica.SIunits.TemperatureDifference dTCon_nominal=10
    "Temperature difference condenser outlet-inlet";
  parameter Real COPc_nominal=3 "Chiller COP";
  parameter Modelica.SIunits.MassFlowRate mCHW_flow_nominal=2*roo.QRoo_flow/(
      4200*20) "Nominal mass flow rate at chilled water";

  parameter Modelica.SIunits.MassFlowRate mCW_flow_nominal=2*roo.QRoo_flow/(
      4200*6) "Nominal mass flow rate at condenser water";

  parameter Modelica.SIunits.Pressure dp_nominal=500
    "Nominal pressure difference";
  Buildings.Fluid.Movers.FlowMachine_m_flow fan(
    redeclare package Medium = MediumAir,
    m_flow_nominal=mAir_flow_nominal,
    dp(start=249),
    m_flow(start=mAir_flow_nominal),
    T_start=293.15,
    filteredSpeed=false)
    annotation (Placement(transformation(extent={{290,-235},{270,-215}})));
  Buildings.Fluid.HeatExchangers.DryCoilCounterFlow cooCoi(
    redeclare package Medium1 = MediumCHW,
    redeclare package Medium2 = MediumAir,
    m2_flow_nominal=mAir_flow_nominal,
    m1_flow_nominal=mCHW_flow_nominal,
    UA_nominal=1e6,
    m1_flow(start=mCHW_flow_nominal),
    m2_flow(start=mAir_flow_nominal),
    dp1_nominal(displayUnit="Pa") = 1000,
    dp2_nominal=249*3) "Cooling coil"
    annotation (Placement(transformation(extent={{240,-185},{220,-165}})));
  Modelica.Blocks.Sources.Constant mFanFlo(k=mAir_flow_nominal)
    "Mass flow rate of fan" annotation (Placement(transformation(extent={{240,-210},
            {260,-190}}, rotation=0)));
  BaseClasses.SimplifiedRoom roo(
    redeclare package Medium = MediumAir,
    nPorts=2,
    rooLen=50,
    rooWid=30,
    rooHei=3,
    m_flow_nominal=mAir_flow_nominal,
    QRoo_flow=500000) "Room model" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={190,-238})));
  inner Modelica.Fluid.System system(T_ambient=283.15)
    annotation (Placement(transformation(extent={{-322,-151},{-302,-131}})));
  Fluid.Movers.FlowMachine_dp pumCHW(
    redeclare package Medium = MediumCHW,
    m_flow_nominal=mCHW_flow_nominal,
    m_flow(start=mCHW_flow_nominal),
    dp(start=325474),
    filteredSpeed=false) "Chilled water pump" annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=270,
        origin={160,-120})));
  Buildings.Fluid.Storage.ExpansionVessel expVesCHW(redeclare package Medium =
        MediumCHW, VTot=1) "Expansion vessel"
    annotation (Placement(transformation(extent={{190,-147},{210,-127}})));
  Buildings.Fluid.HeatExchangers.CoolingTowers.YorkCalc cooTow(
    redeclare package Medium = MediumCW,
    m_flow_nominal=mCW_flow_nominal,
    PFan_nominal=6000,
    TAirInWB_nominal(displayUnit="degC") = 283.15,
    TApp_nominal=6,
    dp_nominal=14930 + 14930 + 74650) "Cooling tower" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={211,239})));
  Buildings.Fluid.Movers.FlowMachine_m_flow pumCW(
    redeclare package Medium = MediumCW,
    m_flow_nominal=mCW_flow_nominal,
    dp(start=214992),
    filteredSpeed=false) "Condenser water pump" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={300,200})));
  Modelica.Blocks.Sources.Constant mCWFlo(k=mCW_flow_nominal)
    "Flow rate of condenser water side" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={250,200})));
  Buildings.Fluid.HeatExchangers.ConstantEffectiveness wse(
    redeclare package Medium1 = MediumCW,
    redeclare package Medium2 = MediumCHW,
    m1_flow_nominal=mCW_flow_nominal,
    m2_flow_nominal=mCHW_flow_nominal,
    eps=0.8,
    dp2_nominal=0,
    dp1_nominal=0) "Water side economizer (Heat exchanger)"
    annotation (Placement(transformation(extent={{68,83},{48,103}})));
  Fluid.Actuators.Valves.TwoWayLinear val5(
    redeclare package Medium = MediumCW,
    m_flow_nominal=mCW_flow_nominal,
    dpValve_nominal=20902,
    dpFixed_nominal=89580) "Control valve for condenser water loop of chiller"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={160,180})));
  Fluid.Actuators.Valves.TwoWayLinear val1(
    redeclare package Medium = MediumCHW,
    m_flow_nominal=mCHW_flow_nominal,
    dpValve_nominal=20902)
    "Bypass control valve for economizer. 1: disable economizer, 0: enable economoizer"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={160,-40})));
  Buildings.Fluid.Storage.ExpansionVessel expVesChi(redeclare package Medium =
        MediumCW, VTot=1)
    annotation (Placement(transformation(extent={{178,143},{198,163}})));
  Buildings.Examples.ChillerPlant.BaseClasses.Controls.WSEControl wseCon
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-150,-29})));
  Modelica.Blocks.Sources.RealExpression expTowTApp(y=cooTow.TApp_nominal)
    "Cooling tower approach" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-210,-60})));
  Fluid.Chillers.ElectricEIR chi(
    redeclare package Medium1 = MediumCW,
    redeclare package Medium2 = MediumCHW,
    m1_flow_nominal=mCW_flow_nominal,
    m2_flow_nominal=mCHW_flow_nominal,
    dp2_nominal=0,
    dp1_nominal=0,
    per=Buildings.Fluid.Chillers.Data.ElectricEIR.ElectricEIRChiller_Carrier_19XR_742kW_5_42COP_VSD())
    annotation (Placement(transformation(extent={{216,83},{196,103}})));
  Fluid.Actuators.Valves.TwoWayLinear val6(
    redeclare package Medium = MediumCHW,
    m_flow_nominal=mCHW_flow_nominal,
    dpValve_nominal=20902,
    dpFixed_nominal=14930 + 89580)
    "Control valve for chilled water leaving from chiller" annotation (
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={300,40})));
  Buildings.Examples.ChillerPlant.BaseClasses.Controls.ChillerSwitch chiSwi(
      deaBan(displayUnit="K") = 2.2)
    "Control unit switching chiller on or off "
    annotation (Placement(transformation(extent={{-226,83},{-206,103}})));
  Buildings.Examples.ChillerPlant.BaseClasses.Controls.TrimAndRespond triAndRes(
    yMax=1,
    yMin=0,
    nActDec=0,
    nActInc=1,
    n=1,
    yEqu0=0,
    tSam=120,
    uTri=0,
    yDec=-0.03,
    yInc=0.03) "Trim and respond logic"
    annotation (Placement(transformation(extent={{-160,190},{-140,210}})));
  Buildings.Examples.ChillerPlant.BaseClasses.Controls.LinearPiecewiseTwo
    linPieTwo(
    x0=0,
    x2=1,
    x1=0.5,
    y11=1,
    y21=273.15 + 5.56,
    y10=0.2,
    y20=273.15 + 22) "Translate the control signal for chiller setpoint reset"
    annotation (Placement(transformation(extent={{-120,190},{-100,210}})));
  Modelica.Blocks.Sources.Constant TAirSet(k=273.15 + 27)
    "Set temperature for air supply to the room" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-230,170})));
  Modelica.Blocks.Math.BooleanToReal chiCon "Contorl signal for chiller"
    annotation (Placement(transformation(extent={{-160,40},{-140,60}})));
  Fluid.Actuators.Valves.TwoWayLinear val4(
    redeclare package Medium = MediumCW,
    m_flow_nominal=mCW_flow_nominal,
    dpValve_nominal=20902,
    dpFixed_nominal=59720)
    "Control valve for condenser water loop of economizer" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={40,180})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TAirSup(redeclare package Medium
      = MediumAir, m_flow_nominal=mAir_flow_nominal)
    "Supply air temperature to data center" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={230,-225})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TCHWEntChi(redeclare package
      Medium = MediumCHW, m_flow_nominal=mCHW_flow_nominal)
    "Temperature of chilled water entering chiller" annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=270,
        origin={160,0})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TCWLeaTow(redeclare package Medium
      = MediumCW, m_flow_nominal=mCW_flow_nominal)
    "Temperature of condenser water leaving the cooling tower"      annotation (
     Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={272,119})));
  Modelica.Blocks.Sources.Constant cooTowFanCon(k=1)
    "Control singal for cooling tower fan" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={172,271})));
  Fluid.Actuators.Valves.TwoWayEqualPercentage valByp(
    redeclare package Medium = MediumCHW,
    m_flow_nominal=mCHW_flow_nominal,
    dpValve_nominal=20902,
    dpFixed_nominal=14930) "Bypass valve for chiller."
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={230,20})));
  Buildings.Examples.ChillerPlant.BaseClasses.Controls.KMinusU KMinusU(k=1)
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  Fluid.Actuators.Valves.TwoWayLinear val3(
    redeclare package Medium = MediumCHW,
    m_flow_nominal=mCHW_flow_nominal,
    dpValve_nominal=20902,
    dpFixed_nominal=59720 + 1000)
    "Control valve for economizer. 0: disable economizer, 1: enable economoizer"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={60,-60})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TCHWLeaCoi(redeclare package
      Medium = MediumCHW, m_flow_nominal=mCHW_flow_nominal)
    "Temperature of chilled water leaving the cooling coil"
                                                     annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=270,
        origin={160,-80})));
  BaseClasses.WeatherData weaData(filNam=
        "Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos")
    annotation (Placement(transformation(extent={{-360,-100},{-340,-80}})));
  BoundaryConditions.WeatherData.Bus weaBus
    annotation (Placement(transformation(extent={{-332,-98},{-312,-78}})));
  Fluid.FixedResistances.FixedResistanceDpM res(
    redeclare package Medium = MediumCHW,
    m_flow_nominal=mCHW_flow_nominal,
    dp_nominal=89580)
    annotation (Placement(transformation(extent={{270,-170},{290,-150}})));
  Modelica.Blocks.Math.Gain gain(k=20*6485)
    annotation (Placement(transformation(extent={{-60,90},{-40,110}})));
  Modelica.Blocks.Math.Feedback feedback
    annotation (Placement(transformation(extent={{-210,190},{-190,210}})));
equation
  connect(expVesCHW.port_a, cooCoi.port_b1) annotation (Line(
      points={{200,-147},{200,-169},{220,-169}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(expTowTApp.y, wseCon.towTApp) annotation (Line(
      points={{-199,-60},{-178,-60},{-178,-36.6},{-160.8,-36.6}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(chiSwi.y, chiCon.u) annotation (Line(
      points={{-205,92.4},{-196,92.4},{-196,50},{-162,50}},
      color={255,0,255},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(cooTow.port_b, pumCW.port_a) annotation (Line(
      points={{221,239},{300,239},{300,210}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(pumCW.m_flow_in, mCWFlo.y) annotation (Line(
      points={{288,200.2},{261,200.2},{261,200}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(val5.port_a, chi.port_b1) annotation (Line(
      points={{160,170},{160,99},{196,99}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(expVesChi.port_a, chi.port_b1) annotation (Line(
      points={{188,143},{188,99},{196,99}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(val4.port_a, wse.port_b1) annotation (Line(
      points={{40,170},{40,99},{48,99}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(chiSwi.y, chi.on) annotation (Line(
      points={{-205,92.4},{-170,92.4},{-170,129},{234,129},{234,96},{218,96}},
      color={255,0,255},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(linPieTwo.y[2], chi.TSet) annotation (Line(
      points={{-99,200.3},{-64,200.3},{-64,125},{226,125},{226,90},{218,90}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(chiCon.y, val5.y) annotation (Line(
      points={{-139,50},{-80,50},{-80,40},{140,40},{140,180},{148,180}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(linPieTwo.y[2], chiSwi.TSet) annotation (Line(
      points={{-99,200.3},{-64,200.3},{-64,249},{-274,249},{-274,88},{-227,88}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));

  connect(cooTowFanCon.y, cooTow.y) annotation (Line(
      points={{183,271},{192,271},{192,247},{199,247}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(cooCoi.port_b2, fan.port_a) annotation (Line(
      points={{240,-181},{301,-181},{301,-225},{290,-225}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(mFanFlo.y, fan.m_flow_in) annotation (Line(
      points={{261,-200},{280.2,-200},{280.2,-213}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));

  connect(wse.port_a2, val3.port_b) annotation (Line(
      points={{48,87},{40,87},{40,-60},{50,-60}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(wseCon.y2, val1.y) annotation (Line(
      points={{-139.6,-35.24},{134,-35.24},{134,-40},{148,-40}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(wseCon.y1, val3.y) annotation (Line(
      points={{-139.6,-24.6},{0,-24.6},{0,-40},{60,-40},{60,-48}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(wseCon.y1, val4.y) annotation (Line(
      points={{-139.6,-24.6},{0,-24.6},{0,180},{28,180}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(TAirSup.port_a, fan.port_b) annotation (Line(
      points={{240,-225},{270,-225}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(roo.airPorts[1],TAirSup. port_b) annotation (Line(
      points={{188.15,-228},{188.15,-225},{220,-225}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(roo.airPorts[2], cooCoi.port_a2) annotation (Line(
      points={{191.85,-228},{191.85,-225},{160,-225},{160,-181},{220,-181}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(TCHWLeaCoi.port_a, pumCHW.port_b)
                                           annotation (Line(
      points={{160,-90},{160,-110}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(TCHWEntChi.port_b, valByp.port_a)
                                         annotation (Line(
      points={{160,10},{160,20},{220,20}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(TCHWEntChi.port_a, val1.port_b)
                                         annotation (Line(
      points={{160,-10},{160,-30}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(val1.port_a, TCHWLeaCoi.port_b)
                                         annotation (Line(
      points={{160,-50},{160,-70}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(val3.port_a, TCHWLeaCoi.port_b)
                                         annotation (Line(
      points={{70,-60},{160,-60},{160,-70}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(TCWLeaTow.port_b, chi.port_a1)
                                        annotation (Line(
      points={{262,119},{242,119},{242,99},{216,99}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(TCWLeaTow.port_b, wse.port_a1)
                                        annotation (Line(
      points={{262,119},{80,119},{80,99},{68,99}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(TCHWEntChi.T, chiSwi.chiCHWST)
                                        annotation (Line(
      points={{149,1.40998e-15},{-244,1.40998e-15},{-244,100},{-227,100}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(wseCon.wseCWST, TCWLeaTow.T)
                                      annotation (Line(
      points={{-160.8,-21.4},{-296,-21.4},{-296,289},{328,289},{328,133},{272,
          133},{272,130}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(wseCon.wseCHWST, TCHWLeaCoi.T)
                                        annotation (Line(
      points={{-160.8,-27},{-234,-27},{-234,-80},{149,-80}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(weaData.weaBus, weaBus) annotation (Line(
      points={{-340,-90},{-331,-90},{-331,-88},{-322,-88}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(wseCon.TWetBul, weaBus.TWetBul) annotation (Line(
      points={{-160.8,-32.6},{-322,-32.6},{-322,-88}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(cooTow.TAir, weaBus.TWetBul) annotation (Line(
      points={{199,243},{24,243},{24,268},{-322,268},{-322,-88}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(TCHWEntChi.port_a, wse.port_b2)
                                         annotation (Line(
      points={{160,-10},{160,-20},{80,-20},{80,87},{68,87}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(valByp.port_b, val6.port_b)
                                    annotation (Line(
      points={{240,20},{300,20},{300,30}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(TCHWEntChi.port_b, chi.port_a2)
                                         annotation (Line(
      points={{160,10},{160,88},{196,88},{196,87}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(val5.port_b, cooTow.port_a) annotation (Line(
      points={{160,190},{160,239},{201,239}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(val4.port_b, cooTow.port_a) annotation (Line(
      points={{40,190},{40,239},{201,239}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(pumCW.port_b, TCWLeaTow.port_a)
                                         annotation (Line(
      points={{300,190},{300,119},{282,119}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));

  connect(cooCoi.port_a1, res.port_a) annotation (Line(
      points={{240,-169},{260,-169},{260,-160},{270,-160}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(chiCon.y, KMinusU.u) annotation (Line(
      points={{-139,50},{-80,50},{-80,60},{-61.8,60}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(KMinusU.y, valByp.y)
                             annotation (Line(
      points={{-39,60},{230,60},{230,32}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(chiCon.y, val6.y) annotation (Line(
      points={{-139,50},{-80,50},{-80,40},{288,40}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(linPieTwo.y[1], gain.u) annotation (Line(
      points={{-99,199.3},{-80,199.3},{-80,100},{-62,100}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(gain.y, pumCHW.dp_in) annotation (Line(
      points={{-39,100},{20,100},{20,-120.2},{148,-120.2}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));

  connect(triAndRes.y, linPieTwo.u) annotation (Line(
      points={{-139.333,200},{-122,200}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(feedback.y, triAndRes.u[1]) annotation (Line(
      points={{-191,200},{-161.333,200}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(TAirSet.y, feedback.u2) annotation (Line(
      points={{-219,170},{-200,170},{-200,192}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(TAirSup.T, feedback.u1) annotation (Line(
      points={{230,-214},{230,-190},{-258,-190},{-258,200},{-208,200}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(chi.port_b2, val6.port_a) annotation (Line(
      points={{216,87},{300,87},{300,50}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(res.port_b, val6.port_b) annotation (Line(
      points={{290,-160},{300,-160},{300,30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pumCHW.port_a, cooCoi.port_b1) annotation (Line(
      points={{160,-130},{160,-160},{200,-160},{200,-169},{220,-169}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-400,-300},{400,
            300}}), graphics),
    Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Examples/ChillerPlant/PrimaryOnlyWithEconomizer.mos"
        "Simulate and plot"),
    Icon(graphics),
    Documentation(info="<HTML>
<h4>System Configuration</h4>
<p>This example demonstrates the implementation of a chiller plant with water-side economizer (WSE) to cool a data center.
The system schematics is as shown below.
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Examples/ChillerPlant/chillerSchematics.png\" border=\"1\">
</p>
<p>
The system is a primary-only chiller plant with integrated WSE.
The objective was to improve the energy efficiency of the chilled water plant by optimizing the control setpoints. 
The room of the data center was modeled using a mixed air volume with a heat source. 
Heat conduction and air infiltration through the building envelope were neglected since the heat exchange between the room and the ambient environment was small compared to the heat released by the computers.
</p>
<p>
The control objective was to maintain the temperature of the supply air to the room, while reducing energy consumption of the chilled water plant.
The control was based on the control sequence proposed by Stein (2009). 
To simplify the implementation, we only applied the controls for the differential pressure of the chilled water loop, the setpoint temperature of the chilled water leaving the chiller, and the chiller and WSE on/off control.
</p>
<h4>Enabling/Disabling the WSE</h4>
<p>
The WSE is enabled when
<ol>
<li>The WSE has been disabled for at least 20 minutes, and</li>
<li align=\"left\" style=\"font-style:italic;\">
  T<sub>ws</sub> &gt; 0.9 T<sub>wet</sub> + &Delta;T<sub>t</sub> + &Delta;T<sub>w</sub> </li>
</ol>
where <i>T<sub>ws</sub></i> is the temperature of chilled water leaving the cooling coil, 
<i>T<sub>wet</sub></i> is the wet bulb temperature, 
<i>&Delta;T<sub>t</sub></i> is the temperature difference between the water leaving the cooling tower and the air entering the cooling tower, 
<i>&Delta;T<sub>w</sub></i> is the temperature difference between the chilled water leaving the WSE and the condenser water entering the WSE.
<br/>
<br/>
The WSE is disabled when
<ol>
<li>The WSE has been enabled for at least 20 minutes, and</li>
<li align=\"left\" style=\"font-style:italic;\">
  T<sub>ws</sub> &lt; T<sub>wc</sub> + &Delta;T<sub>wse,off</sub> </li>
</li>
</ol>
where <i>T<sub>wc</sub></i> is the temperature of condenser water leaving the cooling tower,  <i>&Delta;T<sub>wse,off</sub> = 0.6 K</i> is the offset temperature.
</p> 

<h4>Enabling/Disabling the Chiller</h4>
<p>
The control strategy is as follows:<ul>
<li>The chiller is enabled when 
<i>
  T<sub>chw,ent</sub> &gt; T<sub>chi,set</sub> + &Delta;T<sub>chi,ban</sub> </i>
<li>The chiller is disabled when 
<i>
  T<sub>chw,ent</sub> &le; T<sub>chi,set</sub></i>
</li>
</ul>
where <i>T<sub>chw,ent</sub></i> is the tempearture of chilled water entering the chiller, <i>T<sub>chi,set</sub></i> is the setpoint temperature of the chilled water leaving the chiller, and <i>&Delta;T<sub>chi,ban</sub></i> is the dead-band to prevent short cycling. 
</p>
<h4>Setpoint Reset</h4>
<p>
The setpoint reset strategy is to first increase the different pressure, <i>&Delta;p</i>, of the chilled water loop to increase the mass flow rate. 
If <i>&Delta;p</i> reaches the maximum value and further cooling is still needed, the chiller remperature setpoint, <i>T<sub>chi,set</sub></i>, is reduced.
If there is too much cooling, the <i>T<sub>chi,set</sub></i> and <i>&Delta;p</i>  will be changed in the reverse direction.
This strategy is realized by using a trim and respond logic as follows:
<ul>
<li>A cooling request is triggered if the input signal, <i>y</i>, is larger than 0. 
<i>y</i> is the difference between the actual and set temperature of the suppuly air to the data center room.</li>
<li>The request is sampled every 2 minutes. If there is a cooling request, the control signal <i>u</i> is increased by <i>0.03</i>, where <i>0 &le; u &le; 1</i>. 
If there is no cooling request,  <i>u</i> is decreased by <i>0.03</i>. </li>
</ul>
<br/>
The control singal <i>u</i> is converted to setpoints for <i>&Delta;p</i> and <i>T<sub>chi,set</sub></i> as follows:
<ul>
<li>
If <i>u &isin; [0, x]</i> then <i>&Delta;p = &Delta;p<sub>min</sub> + u &nbsp;(&Delta;p<sub>max</sub>-&Delta;p<sub>min</sub>)/x</i>
and <i>T = T<sub>max</sub></i></li>
<li>
If <i>u &isin; (x, 1]</i> then <i>&Delta;p = &Delta;p<sub>max</sub></i>
and
<i>T = T<sub>max</sub> - (u-x)&nbsp;(T<sub>max</sub>-T<sub>min</sub>)/(1-x)
</i></li>
</ul>
where <i>&Delta;p<sub>min</sub></i> and <i>&Delta;p<sub>max</sub></i> are minimum and maximum values for <i>&Delta;p</i>,
and <i>T<sub>min</sub></i> and <i>T<sub>max</sub></i> are the minimum and maximum values for <i>T<sub>chi,set</sub></i>.

</p>
<h4>Reference</h4>
Stein, J. (2009). Waterside Economizing in Data Centers: Design and Control Considerations. ASHRAE Transactions, 115(2), 192-200.<br>
Taylor, S.T. (2007). Increasing Efficiency with VAV System Static Pressure Setpoint Reset. ASHRAE Journal, June, 24-32.
</HTML>
", revisions="<html>
<ul>
<li>
October 16, 2012, by Wangda Zuo:<br>
Reimplemented the controls.
</li>
<li>
July 20, 2011, by Wangda Zuo:<br>
Added comments and merge to library.
</li>
<li>
January 18, 2011, by Wangda Zuo:<br>
First implementation.
</li>
</ul></HTML>"),
    __Dymola_experimentSetupOutput,
    experiment);
end PrimaryOnlyWithEconomizer;
