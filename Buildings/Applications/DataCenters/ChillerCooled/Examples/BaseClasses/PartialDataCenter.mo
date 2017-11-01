within Buildings.Applications.DataCenters.ChillerCooled.Examples.BaseClasses;
partial model PartialDataCenter
  "Partial model that impliments cooling system for data centers"
  replaceable package MediumA = Buildings.Media.Air "Medium model";
  replaceable package MediumW = Buildings.Media.Water "Medium model";

  // Chiller parameters
  parameter Integer numChi=2 "Number of chillers";
  parameter Modelica.SIunits.MassFlowRate m1_flow_chi_nominal= 34.7
    "Nominal mass flow rate at condenser water in the chillers";
  parameter Modelica.SIunits.MassFlowRate m2_flow_chi_nominal= 18.3
    "Nominal mass flow rate at evaporator water in the chillers";
  parameter Modelica.SIunits.PressureDifference dp1_chi_nominal = 46.2*1000
    "Nominal pressure";
  parameter Modelica.SIunits.PressureDifference dp2_chi_nominal = 44.8*1000
    "Nominal pressure";
  parameter Modelica.SIunits.Power QEva_nominal = m2_flow_chi_nominal*4200*(6.67-18.56)
    "Nominal cooling capaciaty(Negative means cooling)";
 // WSE parameters
  parameter Modelica.SIunits.MassFlowRate m1_flow_wse_nominal= 34.7
    "Nominal mass flow rate at condenser water in the chillers";
  parameter Modelica.SIunits.MassFlowRate m2_flow_wse_nominal= 35.3
    "Nominal mass flow rate at condenser water in the chillers";
  parameter Modelica.SIunits.PressureDifference dp1_wse_nominal = 33.1*1000
    "Nominal pressure";
  parameter Modelica.SIunits.PressureDifference dp2_wse_nominal = 34.5*1000
    "Nominal pressure";

  parameter Buildings.Fluid.Movers.Data.Generic[numChi] perPumCW(
    each pressure=
          Buildings.Fluid.Movers.BaseClasses.Characteristics.flowParameters(
          V_flow=m1_flow_chi_nominal/1000*{0.2,0.6,1.0,1.2},
          dp=(dp1_chi_nominal+60000+6000)*{1.2,1.1,1.0,0.6}))
    "Performance data for condenser water pumps";
  parameter Modelica.SIunits.Time tWai=1200 "Waiting time";

  // AHU
  parameter Modelica.SIunits.ThermalConductance UA_nominal=numChi*QEva_nominal/
     Buildings.Fluid.HeatExchangers.BaseClasses.lmtd(
        6.67,
        11.56,
        12,
        25)
    "Thermal conductance at nominal flow for sensible heat, used to compute time constant";
  parameter Modelica.SIunits.MassFlowRate mAir_flow_nominal = 161.35
    "Nominal air mass flowrate";
  parameter Real yValMinAHU(min=0,max=1,unit="1")=0.1
    "Minimum valve openning position";
  // Set point
  parameter Modelica.SIunits.Temperature TCHWSet = 273.15 + 6
    "Chilled water temperature setpoint";
  parameter Modelica.SIunits.Temperature TSupAirSet = TCHWSet + 9
    "Supply air temperature setpoint";

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
    redeclare
      Buildings.Fluid.Chillers.Data.ElectricEIR.ElectricEIRChiller_York_YT_1055kW_5_96COP_Vanes
      perChi,
    use_inputFilter=false)
    "Chillers and waterside economizer"
    annotation (Placement(transformation(extent={{120,20},{140,40}})));
  Fluid.Sources.Boundary_pT expVesCW(
    redeclare replaceable package Medium = MediumW,
    nPorts=1)
    "Expansion tank"
    annotation (Placement(transformation(extent={{-9,-9.5},{9,9.5}},
        rotation=180,
        origin={251,140.5})));
  Buildings.Fluid.HeatExchangers.CoolingTowers.YorkCalc cooTow[numChi](
    redeclare each replaceable package Medium = MediumW,
    each m_flow_nominal=m1_flow_chi_nominal,
    each dp_nominal=60000,
    each TAirInWB_nominal(displayUnit="degC") = 283.15,
    each TApp_nominal=6,
    each PFan_nominal=6000,
    each energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial)
    "Cooling tower"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
      origin={130,140})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TCHWSup(redeclare replaceable
      package Medium = MediumW, m_flow_nominal=numChi*m2_flow_chi_nominal)
    "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{104,-10},{84,10}})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3  weaData(filNam=
        "modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos")
    annotation (Placement(transformation(extent={{-230,-80},{-210,-60}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
    annotation (Placement(transformation(extent={{-210,-38},{-190,-18}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TCWSup(redeclare replaceable
      package Medium = MediumW, m_flow_nominal=numChi*m1_flow_chi_nominal)
    "Condenser water supply temperature"
    annotation (Placement(transformation(extent={{98,130},{78,150}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TCWRet(redeclare replaceable
      package Medium = MediumW, m_flow_nominal=numChi*m1_flow_chi_nominal)
    "Condenser water return temperature"
    annotation (Placement(transformation(extent={{202,50},{222,70}})));
  Buildings.Fluid.Movers.FlowControlled_m_flow pumCW[numChi](
    redeclare each replaceable package Medium = MediumW,
    each m_flow_nominal=m1_flow_chi_nominal,
    each addPowerToMedium=false,
    per=perPumCW)
    "Condenser water pump"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={70,100})));

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
    dp1_nominal=6000,
    perFan(
      pressure(dp=800*{1.2,1.12,1},
         V_flow=mAir_flow_nominal/1.29*{0,0.5,1}),
         motorCooledByFluid=false),
    yValSwi=yValMinAHU + 0.1,
    yValDeaBan=0.05,
    QHeaMax_flow=30000)
    "Air handling unit"
    annotation (Placement(transformation(extent={{120,-130},{140,-110}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TCHWRet(
    redeclare replaceable package Medium = MediumW,
    m_flow_nominal=numChi*m2_flow_chi_nominal)
    "Chilled water return temperature"
    annotation (Placement(transformation(extent={{220,-10},{200,10}})));
  Fluid.Sources.Boundary_pT               expVesChi(
    redeclare replaceable package Medium = MediumW, nPorts=1)
    "Expansion tank"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={272,-115})));
  Buildings.Fluid.Sensors.RelativePressure senRelPre(
    redeclare replaceable package Medium =MediumW)
    "Differential pressure"
    annotation (Placement(transformation(extent={{118,-86},{138,-106}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TAirSup(
    redeclare replaceable package Medium = MediumA,
    m_flow_nominal=mAir_flow_nominal)
    "Supply air temperature"
    annotation (Placement(transformation(extent={{80,-190},{100,-170}})));
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
        extent={{-10,-10},{10,10}},
        origin={124,-160})));
  Buildings.Fluid.Actuators.Valves.TwoWayLinear val[numChi](
    redeclare each package Medium = MediumW,
    each m_flow_nominal=m1_flow_chi_nominal,
    each dpValve_nominal=6000)
    "Shutoff valves"
    annotation (Placement(transformation(extent={{190,130},{170,150}})));

  Modelica.Blocks.Sources.Constant TCHWSupSet(k=TCHWSet)
    "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-140,150},{-120,170}})));
  Buildings.Applications.DataCenters.ChillerCooled.Controls.ChillerStage
  chiStaCon(
    QEva_nominal=QEva_nominal, tWai=0,
    criPoiTem=TCHWSet + 1.5)
    "Chiller staging control"
    annotation (Placement(transformation(extent={{-50,130},{-30,150}})));
  Modelica.Blocks.Math.RealToBoolean chiOn[numChi]
    "Real value to boolean value"
    annotation (Placement(transformation(extent={{-10,130},{10,150}})));
  Modelica.Blocks.Math.IntegerToBoolean intToBoo(threshold=Integer(Buildings.Applications.DataCenters.Types.CoolingModes.FullMechanical))
    "Inverse on/off signal for the WSE"
    annotation (Placement(transformation(extent={{-50,100},{-30,120}})));
  Modelica.Blocks.Logical.Not wseOn
    "True: WSE is on; False: WSE is off "
    annotation (Placement(transformation(extent={{-10,100},{10,120}})));
  Buildings.Applications.DataCenters.ChillerCooled.Controls.ConstantSpeedPumpStage
    CWPumCon(tWai=0)
    "Condenser water pump controller"
    annotation (Placement(transformation(extent={{-52,60},{-32,80}})));
  Modelica.Blocks.Sources.IntegerExpression chiNumOn(
    y=integer(sum(chiStaCon.y)))
    "The number of running chillers"
    annotation (Placement(transformation(extent={{-140,54},{-118,76}})));
  Modelica.Blocks.Math.Gain gai[numChi](
    each k=m1_flow_chi_nominal)
    "Gain effect"
    annotation (Placement(transformation(extent={{-10,60},{10,80}})));
  Controls.CoolingTowerSpeed
    cooTowSpeCon(controllerType=Modelica.Blocks.Types.SimpleController.PI,
    Ti=40,
    k=5,
    yMin=0)
    "Cooling tower speed control"
    annotation (Placement(transformation(extent={{-50,170},{-30,186}})));
  Modelica.Blocks.Sources.RealExpression TCWSupSet(
    y=min(29.44 + 273.15, max(273.15 + 15.56, cooTow[1].TAir + 3)))
    "Condenser water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-140,176},{-120,196}})));

  Modelica.Blocks.Sources.Constant TAirSupSet(k=TSupAirSet)
      "Supply air temperature setpoint"
    annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));
  Modelica.Blocks.Sources.Constant XAirSupSet(
    k(final unit="1") = MediumA.X_default[1])
    "Supply air mass fraction setpoint"
    annotation (Placement(transformation(extent={{-80,-130},{-60,-110}})));
  Modelica.Blocks.Sources.Constant uFan(k = 1)
    "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-80,-160},{-60,-140}})));
  Buildings.Applications.DataCenters.ChillerCooled.Controls.VariableSpeedPumpStage
  varSpeCon(
    tWai=tWai,
    m_flow_nominal=m2_flow_chi_nominal,
    deaBanSpe=0.45)
    "Speed controller"
    annotation (Placement(transformation(extent={{-48,-14},{-28,6}})));
  Modelica.Blocks.Sources.RealExpression mPum_flow(
    y=chiWSE.port_b2.m_flow)
    "Mass flowrate of variable speed pumps"
    annotation (Placement(transformation(extent={{-100,-6},{-80,14}})));
  Buildings.Controls.Continuous.LimPID pumSpe(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=0.1,
    Ti=40,
    yMin=0.2)
    "Pump speed controller"
    annotation (Placement(transformation(extent={{-126,-30},{-106,-10}})));
  Modelica.Blocks.Sources.Constant dpSet(
    k=0.3*dp2_chi_nominal)
    "Differential pressure setpoint"
    annotation (Placement(transformation(extent={{-160,-30},{-140,-10}})));
  Modelica.Blocks.Math.Product pumSpeSig[numChi]
    "Pump speed signal"
    annotation (Placement(transformation(extent={{0,-20},{20,0}})));
  Buildings.Controls.Continuous.LimPID ahuValSig(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=0.1,
    Ti=40,
    reverseAction=true,
    yMin=yValMinAHU)
    "Valve position signal for the AHU"
    annotation (Placement(transformation(extent={{-10,-100},{10,-80}})));
  Modelica.Blocks.Math.Product cooTowSpe[numChi]
    "Cooling tower speed"
    annotation (Placement(transformation(extent={{60,166},{76,182}})));

equation
  connect(chiWSE.port_b2, TCHWSup.port_a)
    annotation (Line(
      points={{120,24},{112,24},{112,0},{104,0}},
      color={0,127,255},
      thickness=0.5));
  connect(chiWSE.port_b1, TCWRet.port_a)
    annotation (Line(
      points={{140,36},{160,36},{160,60},{202,60}},
      color={0,127,255},
      thickness=0.5));
  for i in 1:numChi loop
    connect(cooTow[i].TAir, weaBus.TWetBul.TWetBul)
      annotation (Line(points={{142,144},{142,144},{164,144},{164,200},{-216,
            200},{-216,-28},{-200,-28}},
            color={255,204,51},
        thickness=0.5));
    connect(TCWSup.port_a, cooTow[i].port_b)
      annotation (Line(
        points={{98,140},{118,140},{120,140}},
        color={0,127,255},
        thickness=0.5));
    connect(pumCW[i].port_a, TCWSup.port_b)
      annotation (Line(
        points={{70,110},{70,140},{78,140}},
        color={0,127,255},
        thickness=0.5));
    connect(TCWRet.port_b, val[i].port_a) annotation (Line(points={{222,60},{
            230,60},{230,140},{190,140}},
            color={0,127,255},
            thickness=0.5));
  end for;
  connect(senRelPre.port_b, ahu.port_b1)
    annotation (Line(points={{138,-96},{150,-96},{150,-114},{140,-114}},
                                         color={0,127,255},
      thickness=0.5));
  connect(cooTow.port_a, val.port_b)
    annotation (Line(points={{140,140},{170,140}},
      color={0,127,255},
      thickness=0.5));

  connect(TCWRet.port_b, expVesCW.ports[1])
    annotation (Line(points={{222,60},{230,60},{230,140.5},{242,140.5}},
    color={0,127,255},
    thickness=0.5));
  connect(ahu.port_b1, expVesChi.ports[1]) annotation (Line(
      points={{140,-114},{262,-114},{262,-115}},
      color={0,127,255},
      thickness=0.5));

  connect(chiWSE.port_b2, TCHWSup.port_a)
    annotation (Line(
      points={{120,24},{112,24},{112,0},{104,0}},
      color={0,127,255},
      thickness=0.5));
  connect(weaData.weaBus, weaBus.TWetBul)
    annotation (Line(
      points={{-210,-70},{-210,-70},{-204,-70},{-204,-70},{-200,-70},{-200,-28}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(chiWSE.port_b1, TCWRet.port_a)
    annotation (Line(
      points={{140,36},{160,36},{160,60},{202,60}},
      color={0,127,255},
      thickness=0.5));
   for i in 1:numChi loop
    connect(TCWSup.port_a, cooTow[i].port_b)
      annotation (Line(
        points={{98,140},{120,140}},
        color={0,127,255},
        thickness=0.5));
    connect(pumCW[i].port_b, chiWSE.port_a1)
      annotation (Line(
        points={{70,90},{70,64},{108,64},{108,36},{120,36}},
        color={0,127,255},
        thickness=0.5));
    connect(chiOn[i].y, chiWSE.on[i])
      annotation (Line(points={{11,140},{40,140},{40,37.6},{118.4,37.6}},
                                     color={255,0,255}));
   connect(cooTowSpeCon.y, cooTowSpe[i].u1)
     annotation (Line(points={{-29,178.889},{36,178.889},{36,178.8},{58.4,178.8}},
                                                  color={0,0,127}));
   end for;
  connect(chiStaCon.y, chiOn.u)
    annotation (Line(points={{-29,140},{-20.5,140},{
          -12,140}},  color={0,0,127}));
  connect(intToBoo.y, wseOn.u)
    annotation (Line(points={{-29,110},{-20.5,110},{-12,
          110}},color={255,0,255}));
  connect(wseOn.y, chiWSE.on[numChi + 1])
    annotation (Line(points={{11,110},{40,110},{40,38},{40,38},{40,38},{40,38},
          {40,38},{40,37.6},{80,37.6},{118.4,37.6}},
                                   color={255,0,255}));
  connect(CWPumCon.y, gai.u)
    annotation (Line(points={{-31,70},{-12,70}},       color={0,0,127}));
  connect(gai.y, pumCW.m_flow_in)
    annotation (Line(points={{11,70},{52,70},{52,100},{58,100}},
                     color={0,0,127}));
  connect(TCWSupSet.y, cooTowSpeCon.TCWSupSet)
    annotation (Line(points={{-119,186},{-52,186}},
                                          color={0,0,127}));
  connect(TCHWSupSet.y, cooTowSpeCon.TCHWSupSet)
    annotation (Line(points={{-119,160},{-64,160},{-64,178.889},{-52,178.889}},
        color={0,0,127}));
  connect(TCWSup.T, cooTowSpeCon.TCWSup)
    annotation (Line(points={{88,151},{88,160},{88,160},{88,160},{-60,160},{-60,
          175.333},{-52,175.333}},
        color={0,0,127}));
  connect(TCHWSup.T, cooTowSpeCon.TCHWSup)
    annotation (Line(points={{94,11},{94,18},{-62,18},{-62,30},{-62,30},{-62,
          171.778},{-52,171.778}},                                     color={0,
          0,127}));
  connect(chiWSE.TSet, TCHWSupSet.y)
    annotation (Line(points={{118.4,40.8},{116,40.8},{116,48},{-104,48},{-104,
          160},{-119,160}},                           color={0,0,127}));
  connect(XAirSupSet.y, ahu.XSet_w)
    annotation (Line(points={{-59,-120},{40,-120},{40,-119},{119,-119}},
                                 color={0,0,127}));
  connect(uFan.y, ahu.uFan)
    annotation (Line(points={{-59,-150},{66,-150},{66,-124},{119,-124}},
                      color={0,0,127}));
  connect(mPum_flow.y, varSpeCon.masFloPum)
    annotation (Line(points={{-79,4},{-50,4}}, color={0,0,127}));
  connect(senRelPre.port_a, ahu.port_a1)
    annotation (Line(points={{118,-96},{106,-96},{106,-114},{120,-114}},
      color={0,127,255},
      thickness=0.5));
  connect(pumSpe.y, varSpeCon.speSig)
    annotation (Line(points={{-105,-20},{-76,-20},
          {-76,0},{-50,0}}, color={0,0,127}));
  connect(senRelPre.p_rel, pumSpe.u_m)
    annotation (Line(points={{128,-87},{128,-87},{128,-60},{-116,-60},{-116,-32}},
      color={0,0,127}));
  connect(dpSet.y, pumSpe.u_s)
    annotation (Line(points={{-139,-20},{-128,-20}},color={0,0,127}));
  connect(pumSpe.y, pumSpeSig[1].u2)
    annotation (Line(points={{-105,-20},{-76,-20},{-76,-36},{-16,-36},{-16,-16},
          {-2,-16}},
          color={0,0,127}));
  connect(pumSpe.y, pumSpeSig[2].u2)
    annotation (Line(points={{-105,-20},{-76,-20},{-76,-36},{-16,-36},{-16,-16},
          {-2,-16}},
          color={0,0,127}));
  connect(varSpeCon.y, pumSpeSig.u1)
    annotation (Line(points={{-27,-4},{-2,-4}},
                                           color={0,0,127}));
  connect(TAirSupSet.y, ahuValSig.u_s)
    annotation (Line(points={{-59,-90},{-36,-90},{-12,-90}}, color={0,0,127}));
  connect(TAirSup.port_a, ahu.port_b2)
    annotation (Line(
      points={{80,-180},{72,-180},{72,-126},{120,-126}},
      color={0,127,255},
      thickness=0.5));
  connect(TAirSup.T, ahuValSig.u_m)
    annotation (Line(points={{90,-169},{90,-170},{90,-156},{0,-156},{0,-102}},
                                                               color={0,0,127}));
  connect(ahuValSig.y, ahu.uWatVal)
    annotation (Line(points={{11,-90},{68,-90},{68,-116},{119,-116}},
                                                          color={0,0,127}));
  connect(TAirSupSet.y, ahu.TSet)
    annotation (Line(points={{-59,-90},{-40,-90},{-40,-112},{64,-112},{64,-121},
          {119,-121}},                             color={0,0,127}));
  connect(CWPumCon.y, val.y)
    annotation (Line(points={{-31,70},{-22,70},{-22,94},{48,94},{48,194},{180,
          194},{180,152}},                       color={0,0,127}));
  connect(CWPumCon.y, cooTowSpe.u2)
    annotation (Line(points={{-31,70},{-22,70},{-22,94},{48,94},{48,169.2},{
          58.4,169.2}},                             color={0,0,127}));
  connect(cooTowSpe.y, cooTow.y)
    annotation (Line(points={{76.8,174},{102,174},{102,174},{160,174},{160,148},
          {142,148}},                              color={0,0,127}));
  connect(TCHWRet.port_a, ahu.port_b1)
    annotation (Line(
      points={{220,0},{230,0},{230,-114},{140,-114}},
      color={0,127,255},
      thickness=0.5));
  connect(chiNumOn.y, CWPumCon.numOnChi)
    annotation (Line(points={{-116.9,65},{-54,65}},
                                                  color={255,127,0}));


  connect(ahu.port_a2, roo.airPorts[1]) annotation (Line(
      points={{140,-126},{152,-126},{152,-180},{126.475,-180},{126.475,-168.7}},
      color={0,127,255},
      thickness=0.5));

  connect(roo.airPorts[2], TAirSup.port_b) annotation (Line(
      points={{122.425,-168.7},{122.425,-180},{100,-180}},
      color={0,127,255},
      thickness=0.5));
  annotation (            Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-240,
            -200},{300,220}})),
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
