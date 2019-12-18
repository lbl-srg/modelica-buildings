within Buildings.Applications.DHC.Loads.Examples.BaseClasses;
model Terminal4PipesHeatReq
  extends Buildings.Applications.DHC.Loads.BaseClasses.PartialTerminalUnit(
    final heaFunSpe=Buildings.Applications.DHC.Loads.Types.TerminalFunctionSpec.Water,
    final cooFunSpe=Buildings.Applications.DHC.Loads.Types.TerminalFunctionSpec.Water,
    final haveQReq_flow=true,
    final haveHeaPor=false,
    final haveFluPor=false,
    final haveWeaBus=false,
    final haveFan=false,
    final havePum=false,
    final show_TSou=true,
    final hexConHea=Buildings.Fluid.Types.HeatExchangerConfiguration.ConstantTemperaturePhaseChange,
    final hexConCoo=Buildings.Fluid.Types.HeatExchangerConfiguration.ConstantTemperaturePhaseChange,
    final m1Hea_flow_nominal=abs(QHea_flow_nominal / cp1Hea_nominal / (T_a1Hea_nominal - T_b1Hea_nominal)),
    final m1Coo_flow_nominal=abs(QCoo_flow_nominal / cp1Coo_nominal / (T_a1Coo_nominal - T_b1Coo_nominal)));
  parameter Integer nPorts1 = 2
    "Number of inlet (or outlet) fluid ports on the source side";
  // TODO: assign HX flow regime based on HX configuration.
  parameter Buildings.Fluid.Types.HeatExchangerFlowRegime hexReg[nPorts1]=
    fill(Buildings.Fluid.Types.HeatExchangerFlowRegime.ConstantTemperaturePhaseChange,
      nPorts1);
  parameter Real ratUAIntToUAExt[nPorts1](each min=1) = fill(2, nPorts1)
    "Ratio of UA internal to UA external values at nominal conditions"
    annotation(Dialog(tab="Advanced", group="Nominal condition"));
  parameter Real expUA[nPorts1] = fill(4/5, nPorts1)
    "Exponent of Reynolds number in the flow correlation used for computing UA internal value"
    annotation(Dialog(tab="Advanced"));
  // TODO: Update for all HX configurations.
  final parameter Modelica.SIunits.ThermalConductance CMin_nominal[nPorts1]=
    {m1Hea_flow_nominal,m1Coo_flow_nominal} .* {cp1Hea_nominal,cp1Coo_nominal}
    "Minimum capacity flow rate at nominal conditions";
    // min(m1_flow_nominal * cp1_nominal, m2_flow_nominal * cp2_nominal)
  final parameter Modelica.SIunits.ThermalConductance CMax_nominal[nPorts1]=
    fill(Modelica.Constants.inf, nPorts1)
    "Maximum capacity flow rate at nominal conditions";
  final parameter Real Z = 0
    "Ratio of capacity flow rates (CMin/CMax) at nominal conditions";
    // CMin_nominal / CMax_nominal
  final parameter Modelica.SIunits.ThermalConductance UA_nominal[nPorts1]=
    Buildings.Fluid.HeatExchangers.BaseClasses.ntu_epsilonZ(
      eps={QHea_flow_nominal,QCoo_flow_nominal} ./ abs(CMin_nominal .*
        ({T_a1Hea_nominal,T_a1Coo_nominal} .- {T_a2Hea_nominal,T_a2Coo_nominal})),
      Z=0,
      flowRegime=Integer(hexReg)) .* CMin_nominal
    "Thermal conductance at nominal conditions";
  final parameter Modelica.SIunits.ThermalConductance UAExt_nominal[nPorts1]=
    (1 .+ ratUAIntToUAExt) ./ ratUAIntToUAExt .* UA_nominal
    "External thermal conductance at nominal conditions";
  final parameter Modelica.SIunits.ThermalConductance UAInt_nominal[nPorts1]=
    ratUAIntToUAExt .* UAExt_nominal
    "Internal thermal conductance at nominal conditions";
  Buildings.Controls.OBC.CDL.Continuous.LimPID conQ_flowReq[nPorts1](
    each yMax=1,
    each controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    reverseAction={false,true},
    each yMin=0) "PI controller tracking the required heat flow rate"
    annotation (Placement(transformation(extent={{-10,210},{10,230}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gaiFloNom[nPorts1](k={
        m1Hea_flow_nominal,m1Coo_flow_nominal})
    annotation (Placement(transformation(extent={{102,70},{122,90}})));
  Buildings.Applications.DHC.Loads.BaseClasses.HeatFlowEffectiveness hexHeaCoo[nPorts1](
    final flowRegime=hexReg,
    final m1_flow_nominal={m1Hea_flow_nominal,m1Coo_flow_nominal},
    final m2_flow_nominal=fill(0, nPorts1),
    final cp1_nominal={cp1Hea_nominal,cp1Coo_nominal},
    final cp2_nominal={cp2Hea_nominal,cp2Coo_nominal})
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.RealExpression UAAct[nPorts1](y=1 ./ (1 ./ (
        UAInt_nominal .* Buildings.Utilities.Math.Functions.regNonZeroPower(
        senMasFlo.m_flow ./ {m1Hea_flow_nominal,m1Coo_flow_nominal}, expUA)) .+ 1 ./ UAExt_nominal))
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFlo[nPorts1](
    redeclare each final package Medium=Medium1)
    annotation (Placement(transformation(extent={{-150,-210},{-130,-190}})));
  Modelica.Blocks.Sources.RealExpression m2Act_flow[nPorts1](y=fill(0, nPorts1))
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  Buildings.Fluid.HeatExchangers.HeaterCooler_u heaCoo[nPorts1](
    redeclare each final package Medium = Medium1,
    final m_flow_nominal={m1Hea_flow_nominal,m1Coo_flow_nominal},
    each final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    each final dp_nominal=0,
    each final Q_flow_nominal=-1) "Heat exchange with water stream"
    annotation (Placement(transformation(extent={{60,-210},{80,-190}})));
  Buildings.Applications.DHC.Loads.BaseClasses.FirstOrderODE TLoaODE[nPorts1](
    each TOutHea_nominal=268.15,
    TIndHea_nominal={293.15,297.15},
    each QHea_flow_nominal=500,
    Q_flow_nominal={500,-2000})
    annotation (Placement(transformation(extent={{-60,170},{-40,190}})));
  Modelica.Blocks.Sources.RealExpression T_a1Val[nPorts1](y={sta_a1Hea.T,
        sta_a1Coo.T})
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
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
  connect(conQ_flowReq.y, gaiFloNom.u) annotation (Line(points={{12,220},{64,220},
          {64,80},{100,80}}, color={0,0,127}));
  connect(TLoaODE.TInd, hexHeaCoo.T2Inl) annotation (Line(points={{-38,180},{-20,
          180},{-20,-8},{-12,-8}}, color={0,0,127}));
  connect(hexHeaCoo.Q_flow, TLoaODE.QAct_flow) annotation (Line(points={{12,0},
          {20,0},{20,160},{-80,160},{-80,172},{-62,172}}, color={0,0,127}));
  connect(hexHeaCoo.Q_flow, conQ_flowReq.u_m) annotation (Line(points={{12,0},{
          20,0},{20,180},{0,180},{0,208}}, color={0,0,127}));
  connect(port_a1Hea, senMasFlo[1].port_a) annotation (Line(points={{-200,-220},
          {-176,-220},{-176,-200},{-150,-200}}, color={0,127,255}));
  connect(port_a1Coo, senMasFlo[2].port_a) annotation (Line(points={{-200,-180},
          {-176,-180},{-176,-200},{-150,-200}}, color={0,127,255}));
  connect(heaCoo[1].port_b, port_b1Hea) annotation (Line(points={{80,-200},{140,
          -200},{140,-220},{200,-220}}, color={0,127,255}));
  connect(heaCoo[2].port_b, port_b1Coo) annotation (Line(points={{80,-200},{140,
          -200},{140,-180},{200,-180}}, color={0,127,255}));
  connect(senMasFlo.port_b, heaCoo.port_a)
    annotation (Line(points={{-130,-200},{60,-200}}, color={0,127,255}));
  connect(T_a1Val.y, hexHeaCoo.T1Inl)
    annotation (Line(points={{-39,0},{-12,0}}, color={0,0,127}));
  connect(TSetHea, TLoaODE[1].TSet) annotation (Line(points={{-220,220},{-140,220},
          {-140,188},{-62,188}}, color={0,0,127}));
  connect(TSetCoo, TLoaODE[2].TSet) annotation (Line(points={{-220,180},{-140,180},
          {-140,188},{-62,188}}, color={0,0,127}));
  connect(QReqHea_flow, TLoaODE[1].QReq_flow) annotation (Line(points={{-220,140},
          {-120,140},{-120,180},{-62,180}}, color={0,0,127}));
  connect(QReqCoo_flow, TLoaODE[2].QReq_flow) annotation (Line(points={{-220,100},
          {-120,100},{-120,180},{-62,180}}, color={0,0,127}));
  connect(gaiFloNom[1].y, m1ReqHea_flow) annotation (Line(points={{124,80},{180,
          80},{180,100},{220,100}}, color={0,0,127}));
  connect(gaiFloNom[2].y, m1ReqCoo_flow)
    annotation (Line(points={{124,80},{220,80}}, color={0,0,127}));
  connect(QReqHea_flow, conQ_flowReq[1].u_s) annotation (Line(points={{-220,140},
          {-120,140},{-120,220},{-12,220}}, color={0,0,127}));
  connect(QReqCoo_flow, conQ_flowReq[2].u_s) annotation (Line(points={{-220,100},
          {-120,100},{-120,220},{-12,220}}, color={0,0,127}));
  connect(hexHeaCoo[1].Q_flow, QActHea_flow) annotation (Line(points={{12,0},{160,
          0},{160,220},{220,220}}, color={0,0,127}));
  connect(hexHeaCoo[2].Q_flow, QActCoo_flow) annotation (Line(points={{12,0},{160,
          0},{160,200},{220,200}}, color={0,0,127}));
end Terminal4PipesHeatReq;
