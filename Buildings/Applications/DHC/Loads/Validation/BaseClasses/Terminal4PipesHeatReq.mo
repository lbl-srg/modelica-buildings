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
  Buildings.Applications.DHC.Loads.BaseClasses.HeatFlowEffectivenessNTU hexHeaCoo[nFun](
    final flowRegime=hexReg,
    final m1_flow_nominal={mHeaWat_flow_nominal,mChiWat_flow_nominal},
    final m2_flow_nominal=fill(0, nFun),
    final cp1_nominal={cpHeaWat_nominal,cpChiWat_nominal},
    final cp2_nominal={cpLoaHea_nominal,cpLoaCoo_nominal})
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.RealExpression UAAct[nFun](y=1 ./ (1 ./ (
    UAInt_nominal .* Buildings.Utilities.Math.Functions.regNonZeroPower(
    senMasFlo.m_flow ./ {mHeaWat_flow_nominal,mChiWat_flow_nominal}, expUA)) .+ 1 ./ UAExt_nominal))
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFlo[nFun](
    redeclare each final package Medium=Medium1)
    annotation (Placement(transformation(extent={{-150,-210},{-130,-190}})));
  Modelica.Blocks.Sources.RealExpression m2Act_flow[nFun](y=fill(0, nFun))
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
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
    annotation (Placement(transformation(extent={{-60,170},{-40,190}})));
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
equation
  connect(hexHeaCoo.UA, UAAct.y) annotation (Line(points={{-12,8},{-26,8},{-26,20},
          {-39,20}}, color={0,0,127}));
  connect(senMasFlo.m_flow, hexHeaCoo.m1_flow)
    annotation (Line(points={{-140,-189},{-140,4},{-12,4}}, color={0,0,127}));
  connect(m2Act_flow.y, hexHeaCoo.m2_flow) annotation (Line(points={{-39,-20},{-26,
          -20},{-26,-4},{-12,-4}}, color={0,0,127}));
  connect(hexHeaCoo.Q_flow, heaCoo.u) annotation (Line(points={{12,0},{20,0},{
          20,-194},{58,-194}},
                            color={0,0,127}));
  connect(conQ_flowReq.y, gaiFloNom.u) annotation (Line(points={{32,220},{58,220}},
                             color={0,0,127}));
  connect(TLoaODE.TInd, hexHeaCoo.T2Inl) annotation (Line(points={{-38,180},{-20,
          180},{-20,-8},{-12,-8}}, color={0,0,127}));
  connect(hexHeaCoo.Q_flow, TLoaODE.QAct_flow) annotation (Line(points={{12,0},{
          20,0},{20,160},{-80,160},{-80,172},{-62,172}},  color={0,0,127}));
  connect(hexHeaCoo.Q_flow, conQ_flowReq.u_m) annotation (Line(points={{12,0},{20,
          0},{20,208}},                    color={0,0,127}));
  connect(heaCoo[1].port_b, port_bHeaWat) annotation (Line(points={{80,-200},{140,
          -200},{140,-220},{200,-220}}, color={0,127,255}));
  connect(heaCoo[2].port_b, port_bChiWat) annotation (Line(points={{80,-200},{140,
          -200},{140,-180},{200,-180}}, color={0,127,255}));
  connect(senMasFlo.port_b, heaCoo.port_a)
    annotation (Line(points={{-130,-200},{60,-200}}, color={0,127,255}));
  connect(TSetHea, TLoaODE[1].TSet) annotation (Line(points={{-220,220},{-180,220},
          {-180,188},{-62,188}}, color={0,0,127}));
  connect(TSetCoo, TLoaODE[2].TSet) annotation (Line(points={{-220,180},{-180,180},
          {-180,188},{-62,188}}, color={0,0,127}));
  connect(port_aChiWat, TChiWatInl.port_a)
    annotation (Line(points={{-200,-180},{-190,-180}}, color={0,127,255}));
  connect(port_aHeaWat, THeaWatInl.port_a)
    annotation (Line(points={{-200,-220},{-190,-220}}, color={0,127,255}));
  connect(TChiWatInl.port_b, senMasFlo[2].port_a) annotation (Line(points={{-170,-180},
          {-160,-180},{-160,-200},{-150,-200}}, color={0,127,255}));
  connect(THeaWatInl.port_b, senMasFlo[1].port_a) annotation (Line(points={{-170,-220},
          {-160,-220},{-160,-200},{-150,-200}}, color={0,127,255}));
  connect(THeaWatInl.T, hexHeaCoo[1].T1Inl)
    annotation (Line(points={{-180,-209},{-180,-200},{-170,-200},{-170,0},{-12,
          0}},                                              color={0,0,127}));
  connect(TChiWatInl.T, hexHeaCoo[2].T1Inl)
    annotation (Line(points={{-180,-169},{-180,0},{-12,0}}, color={0,0,127}));
  connect(gaiFloNom[1].y,scaMasFloReqHeaWat.u)  annotation (Line(points={{82,
          220},{120,220},{120,100},{158,100}}, color={0,0,127}));
  connect(gaiFloNom[2].y, scaMasFloReqChiWat.u) annotation (Line(points={{82,
          220},{120,220},{120,80},{158,80}}, color={0,0,127}));
  connect(scaQReqHea_flow.y, TLoaODE[1].QReq_flow) annotation (Line(points={{-158,
          140},{-100,140},{-100,180},{-62,180}},      color={0,0,127}));
  connect(scaQReqCoo_flow.y, TLoaODE[2].QReq_flow) annotation (Line(points={{-158,
          100},{-100,100},{-100,180},{-62,180}},      color={0,0,127}));
  connect(scaQReqHea_flow.y, conQ_flowReq[1].u_s) annotation (Line(points={{
          -158,140},{-120,140},{-120,220},{8,220}}, color={0,0,127}));
  connect(scaQReqCoo_flow.y, conQ_flowReq[2].u_s) annotation (Line(points={{
          -158,100},{-120,100},{-120,220},{8,220}}, color={0,0,127}));
  connect(hexHeaCoo[1].Q_flow, scaQActHea_flow.u) annotation (Line(points={{12,
          0},{140,0},{140,220},{158,220}}, color={0,0,127}));
  connect(hexHeaCoo[2].Q_flow, scaQActCoo_flow.u) annotation (Line(points={{12,
          0},{144,0},{144,200},{158,200}}, color={0,0,127}));
end Terminal4PipesHeatReq;
