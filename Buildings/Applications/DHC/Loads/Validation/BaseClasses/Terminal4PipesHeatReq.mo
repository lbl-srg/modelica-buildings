within Buildings.Applications.DHC.Loads.Validation.BaseClasses;
model Terminal4PipesHeatReq
  extends Buildings.Applications.DHC.Loads.BaseClasses.PartialTerminalUnit(
    redeclare package Medium1 = Buildings.Media.Water,
    redeclare package Medium2 = Buildings.Media.Air,
    final have_watHea=true,
    final have_watCoo=true,
    final have_QReq_flow=true,
    final hexConHea=Buildings.Fluid.Types.HeatExchangerConfiguration.ConstantTemperaturePhaseChange,
    final hexConCoo=Buildings.Fluid.Types.HeatExchangerConfiguration.ConstantTemperaturePhaseChange,
    final mHeaWat_flow_nominal=abs(QHea_flow_nominal/cpHeaWat_nominal/(
      T_aHeaWat_nominal - T_bHeaWat_nominal)),
    final mChiWat_flow_nominal=abs(QCoo_flow_nominal/cpChiWat_nominal/(
      T_aChiWat_nominal - T_bChiWat_nominal)));

  parameter Integer nFun = 2
    "Number of HVAC functions: 2 for heating and cooling, 1 for heating only";
  // TODO: assign HX flow regime based on HX configuration.
  parameter Buildings.Fluid.Types.HeatExchangerFlowRegime hexReg[nFun]=
    fill(Buildings.Fluid.Types.HeatExchangerFlowRegime.ConstantTemperaturePhaseChange,
      nFun);
  parameter Real ratUAIntToUAExt[nFun](each min=1) = fill(2, nFun)
    "Ratio of UA internal to UA external values at nominal conditions"
    annotation(Dialog(tab="Advanced", group="Nominal condition"));
  parameter Real expUA[nFun] = fill(4/5, nFun)
    "Exponent of Reynolds number in the flow correlation used for computing UA internal value"
    annotation(Dialog(tab="Advanced"));
  // TODO: Update for all HX configurations.
  final parameter Modelica.SIunits.ThermalConductance CMin_nominal[nFun]=
    {mHeaWat_flow_nominal,mChiWat_flow_nominal} .* {cpHeaWat_nominal,cpChiWat_nominal}
    "Minimum capacity flow rate at nominal conditions";
  final parameter Modelica.SIunits.ThermalConductance CMax_nominal[nFun]=
    fill(Modelica.Constants.inf, nFun)
    "Maximum capacity flow rate at nominal conditions";
  final parameter Real Z = 0
    "Ratio of capacity flow rates (CMin/CMax) at nominal conditions";
  final parameter Modelica.SIunits.ThermalConductance UA_nominal[nFun]=
    Buildings.Fluid.HeatExchangers.BaseClasses.ntu_epsilonZ(
      eps=abs({QHea_flow_nominal, QCoo_flow_nominal}) ./ abs(CMin_nominal .*
        ({T_aHeaWat_nominal, T_aChiWat_nominal} .-
        {T_aLoaHea_nominal, T_aLoaCoo_nominal})),
      Z=0,
      flowRegime=Integer(hexReg)) .* CMin_nominal
    "Thermal conductance at nominal conditions";
  final parameter Modelica.SIunits.ThermalConductance UAExt_nominal[nFun]=
    (1 .+ ratUAIntToUAExt) ./ ratUAIntToUAExt .* UA_nominal
    "External thermal conductance at nominal conditions";
  final parameter Modelica.SIunits.ThermalConductance UAInt_nominal[nFun]=
    ratUAIntToUAExt .* UAExt_nominal
    "Internal thermal conductance at nominal conditions";
  Buildings.Controls.OBC.CDL.Continuous.LimPID conQ_flowReq[nFun](
    each yMax=1,
    each controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    reverseAction={false,true},
    each yMin=0) "PI controller tracking the required heat flow rate"
    annotation (Placement(transformation(extent={{10,210},{30,230}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gaiFloNom[nFun](
    k={mHeaWat_flow_nominal,mChiWat_flow_nominal})
    annotation (Placement(transformation(extent={{60,210},{80,230}})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFlo[nFun](
    redeclare each final package Medium=Medium1)
    annotation (Placement(transformation(extent={{-150,-210},{-130,-190}})));
  Buildings.Fluid.HeatExchangers.HeaterCooler_u heaCoo[nFun](
    redeclare each final package Medium = Medium1,
    final m_flow_nominal={mHeaWat_flow_nominal,mChiWat_flow_nominal},
    each final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    each final dp_nominal=0,
    each final Q_flow_nominal=-1) "Heat exchange with water stream"
    annotation (Placement(transformation(extent={{60,-210},{80,-190}})));
  Buildings.Applications.DHC.Loads.BaseClasses.FirstOrderODE TLoaODE[nFun](
    each TOutHea_nominal=273.15 - 5,
    TIndHea_nominal={T_aLoaHea_nominal, T_aLoaCoo_nominal},
    each QHea_flow_nominal=QHea_flow_nominal,
    Q_flow_nominal={QHea_flow_nominal, QCoo_flow_nominal})
    annotation (Placement(transformation(extent={{-90,170},{-70,190}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TChiWatInl(
    redeclare final package Medium = Medium1,
    final m_flow_nominal=mChiWat_flow_nominal,
    final tau=0,
    final allowFlowReversal=allowFlowReversal)
    "Chilled water inlet temperature (sensed, steady-state)"
    annotation (Placement(transformation(extent={{-190,-190},{-170,-170}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort THeaWatInl(
    redeclare final package Medium = Medium1,
    final m_flow_nominal=mHeaWat_flow_nominal,
    final tau=0,
    final allowFlowReversal=allowFlowReversal)
    "Heating water inlet temperature (sensed, steady-state)"
    annotation (Placement(transformation(extent={{-190,-230},{-170,-210}})));
  Buildings.Applications.DHC.Loads.BaseClasses.HeatFlowEffectivenessNTU
    heaFloEff[nFun](
    redeclare each final package Medium1 = Medium1,
    redeclare each final package Medium2 = Medium2,
    each configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.ConstantTemperaturePhaseChange,
    each use_Q_flow_nominal=true,
    final Q_flow_nominal={QHea_flow_nominal,QCoo_flow_nominal},
    final T_a1_nominal={T_aHeaWat_nominal, T_aChiWat_nominal},
    final T_a2_nominal={T_aLoaHea_nominal, T_aLoaCoo_nominal},
    final m1_flow_nominal={mHeaWat_flow_nominal, mChiWat_flow_nominal},
    final m2_flow_nominal={mLoaHea_flow_nominal, mLoaCoo_flow_nominal})
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Fluid.HeatExchangers.BaseClasses.HADryCoil hA[nFun](
    UA_nominal=heaFloEff.UA_nominal,
    m_flow_nominal_w={mHeaWat_flow_nominal,mChiWat_flow_nominal},
    m_flow_nominal_a={mLoaHea_flow_nominal,mLoaCoo_flow_nominal},
    each waterSideFlowDependent=true,
    each airSideFlowDependent=false,
    each waterSideTemperatureDependent=true,
    each airSideTemperatureDependent=true)
    annotation (Placement(transformation(extent={{-40,-8},{-20,12}})));
  Modelica.Blocks.Sources.RealExpression UA[nFun](y=1 ./ (1 ./ hA.hA_1 .+ 1 ./
        hA.hA_2)) "Thermal conductance"
    annotation (Placement(transformation(extent={{-20,14},{0,34}})));
  Modelica.Blocks.Sources.RealExpression mLoa_flow[nFun](
    y={mLoaHea_flow_nominal, mLoaCoo_flow_nominal})
    "Load side mass flow rate"
    annotation (Placement(transformation(extent={{-140,-50},{-120,-30}})));
  Modelica.Blocks.Sources.RealExpression cp2[nFun](y={cpLoaHea_nominal,
        cpLoaCoo_nominal}) "Load side fluid specific heat capacity"
    annotation (Placement(transformation(extent={{-20,-46},{0,-26}})));
  Modelica.Blocks.Sources.RealExpression cp1[nFun](y={cpHeaWat_nominal,
        cpChiWat_nominal})
                          "Source side fluid specific heat capacity"
    annotation (Placement(transformation(extent={{-20,-28},{0,-8}})));
equation
  connect(conQ_flowReq.y, gaiFloNom.u) annotation (Line(points={{32,220},{58,220}},
                             color={0,0,127}));
  connect(heaCoo[1].port_b, port_bHeaWat) annotation (Line(points={{80,-200},{140,
          -200},{140,-220},{200,-220}}, color={0,127,255}));
  connect(heaCoo[2].port_b, port_bChiWat) annotation (Line(points={{80,-200},{140,
          -200},{140,-180},{200,-180}}, color={0,127,255}));
  connect(TSetHea, TLoaODE[1].TSet) annotation (Line(points={{-220,220},{-180,220},
          {-180,188},{-92,188}}, color={0,0,127}));
  connect(TSetCoo, TLoaODE[2].TSet) annotation (Line(points={{-220,180},{-180,180},
          {-180,188},{-92,188}}, color={0,0,127}));
  connect(port_aChiWat, TChiWatInl.port_a)
    annotation (Line(points={{-200,-180},{-190,-180}}, color={0,127,255}));
  connect(port_aHeaWat, THeaWatInl.port_a)
    annotation (Line(points={{-200,-220},{-190,-220}}, color={0,127,255}));
  connect(TChiWatInl.port_b, senMasFlo[2].port_a) annotation (Line(points={{-170,-180},
          {-160,-180},{-160,-200},{-150,-200}}, color={0,127,255}));
  connect(THeaWatInl.port_b, senMasFlo[1].port_a) annotation (Line(points={{-170,-220},
          {-160,-220},{-160,-200},{-150,-200}}, color={0,127,255}));
  connect(gaiFloNom[1].y,scaMasFloReqHeaWat.u)  annotation (Line(points={{82,
          220},{120,220},{120,100},{158,100}}, color={0,0,127}));
  connect(gaiFloNom[2].y, scaMasFloReqChiWat.u) annotation (Line(points={{82,
          220},{120,220},{120,80},{158,80}}, color={0,0,127}));
  connect(scaQReqHea_flow.y, TLoaODE[1].QReq_flow) annotation (Line(points={{-158,
          140},{-100,140},{-100,180},{-92,180}},      color={0,0,127}));
  connect(scaQReqCoo_flow.y, TLoaODE[2].QReq_flow) annotation (Line(points={{-158,
          100},{-100,100},{-100,180},{-92,180}},      color={0,0,127}));
  connect(scaQReqHea_flow.y, conQ_flowReq[1].u_s) annotation (Line(points={{
          -158,140},{-120,140},{-120,220},{8,220}}, color={0,0,127}));
  connect(scaQReqCoo_flow.y, conQ_flowReq[2].u_s) annotation (Line(points={{
          -158,100},{-120,100},{-120,220},{8,220}}, color={0,0,127}));
  connect(senMasFlo.port_b, heaCoo.port_a)
    annotation (Line(points={{-130,-200},{60,-200}}, color={0,127,255}));
  connect(THeaWatInl.T, hA[1].T_1) annotation (Line(points={{-180,-209},{-112,-209},
          {-112,5},{-41,5}}, color={0,0,127}));
  connect(TChiWatInl.T, hA[2].T_1) annotation (Line(points={{-180,-169},{-110,-169},
          {-110,5},{-41,5}}, color={0,0,127}));
  connect(senMasFlo.m_flow, hA.m1_flow) annotation (Line(points={{-140,-189},{-92,
          -189},{-92,9},{-41,9}}, color={0,0,127}));
  connect(senMasFlo.m_flow, heaFloEff.m1_flow) annotation (Line(points={{-140,-189},
          {-62,-189},{-62,8},{18,8}}, color={0,0,127}));
  connect(heaFloEff.Q2_flow, heaCoo.u) annotation (Line(points={{42,-6},{50,-6},
          {50,-194},{58,-194}}, color={0,0,127}));
  connect(TLoaODE.TInd, hA.T_2) annotation (Line(points={{-68,180},{-54,180},{-54,
          -1},{-41,-1}}, color={0,0,127}));
  connect(mLoa_flow.y, hA.m2_flow) annotation (Line(points={{-119,-40},{-54,-40},
          {-54,-5},{-41,-5}}, color={0,0,127}));
  connect(TLoaODE.TInd, heaFloEff.T_in2) annotation (Line(points={{-68,180},{-26,
          180},{-26,2},{18,2}}, color={0,0,127}));
  connect(mLoa_flow.y, heaFloEff.m2_flow) annotation (Line(points={{-119,-40},{
          -22,-40},{-22,4},{18,4}},
                                color={0,0,127}));
  connect(THeaWatInl.T, heaFloEff[1].T_in1) annotation (Line(points={{-180,-209},
          {-80,-209},{-80,6},{18,6}}, color={0,0,127}));
  connect(TChiWatInl.T, heaFloEff[2].T_in1) annotation (Line(points={{-180,-169},
          {-82,-169},{-82,6},{18,6}}, color={0,0,127}));
  connect(cp1.y, heaFloEff.cp1) annotation (Line(points={{1,-18},{10,-18},{10,-4},
          {18,-4}}, color={0,0,127}));
  connect(cp2.y, heaFloEff.cp2) annotation (Line(points={{1,-36},{10,-36},{10,-6},
          {18,-6}}, color={0,0,127}));
  connect(heaFloEff.Q2_flow, conQ_flowReq.u_m) annotation (Line(points={{42,-6},
          {50,-6},{50,200},{20,200},{20,208}}, color={0,0,127}));
  connect(heaFloEff[1].Q2_flow, scaQActHea_flow.u) annotation (Line(points={{42,
          -6},{62,-6},{62,68},{158,68},{158,220}}, color={0,0,127}));
  connect(heaFloEff[2].Q2_flow, scaQActCoo_flow.u) annotation (Line(points={{42,
          -6},{102,-6},{102,200},{158,200}}, color={0,0,127}));
  connect(heaFloEff.Q2_flow, TLoaODE.QAct_flow) annotation (Line(points={{42,-6},
          {-14,-6},{-14,152},{-96,152},{-96,172},{-92,172}}, color={0,0,127}));
  connect(UA.y, heaFloEff.UA) annotation (Line(points={{1,24},{10,24},{10,-2},{18,
          -2}}, color={0,0,127}));
end Terminal4PipesHeatReq;
