within Buildings.Applications.DHC.Loads.Examples.BaseClasses;
model Terminal4PipesHeatReq
  extends Buildings.Applications.DHC.Loads.BaseClasses.PartialTerminalUnit(
    final nPorts1=2,
    final haveQ_flowReq=true,
    final haveHeaPor=false,
    final haveFluPor=false,
    final haveFanPum=false,
    final haveEleHeaCoo=false,
    final hexCon=fill(
      Buildings.Fluid.Types.HeatExchangerConfiguration.ConstantTemperaturePhaseChange,
      2),
    final m_flow1_nominal=abs(Q_flow_nominal ./ cp1_nominal ./ (T_a1_nominal - T_b1_nominal)));
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
    m_flow1_nominal .* cp1_nominal
    "Minimum capacity flow rate at nominal conditions";
    // min(m_flow1_nominal * cp1_nominal, m_flow2_nominal * cp2_nominal)
  final parameter Modelica.SIunits.ThermalConductance CMax_nominal[nPorts1]=
    fill(Modelica.Constants.inf, nPorts1)
    "Maximum capacity flow rate at nominal conditions";
  final parameter Real Z = 0
    "Ratio of capacity flow rates (CMin/CMax) at nominal conditions";
    // CMin_nominal / CMax_nominal
  final parameter Modelica.SIunits.ThermalConductance UA_nominal[nPorts1]=
    Buildings.Fluid.HeatExchangers.BaseClasses.ntu_epsilonZ(
      eps=Q_flow_nominal ./ abs(CMin_nominal .* (T_a1_nominal .- T_a2_nominal)),
      Z=0,
      flowRegime=Integer(hexCon)) .* CMin_nominal
    "Thermal conductance at nominal conditions";
  final parameter Modelica.SIunits.ThermalConductance UAExt_nominal[nPorts1]=
    (1 .+ ratUAIntToUAExt) ./ ratUAIntToUAExt .* UA_nominal
    "External thermal conductance at nominal conditions";
  final parameter Modelica.SIunits.ThermalConductance UAInt_nominal[nPorts1]=
    ratUAIntToUAExt .* UAExt_nominal
    "Internal thermal conductance at nominal conditions";
  Buildings.Controls.OBC.CDL.Continuous.LimPID conQ_flowReq[nPorts1](
    each Ti=120,
    each yMax=1,
    each controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    reverseAction={false,true},
    each yMin=0) "PI controller tracking the required heat flow rate"
    annotation (Placement(transformation(extent={{-10,210},{10,230}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gaiFloNom1[nPorts1](
    k=m_flow1_nominal)
    annotation (Placement(transformation(extent={{160,210},{180,230}})));
  Buildings.Applications.DHC.Loads.BaseClasses.HeatFlowEffectiveness hexHeaCoo[nPorts1](
    final flowRegime=hexReg,
    final m_flow1_nominal=m_flow1_nominal,
    final m_flow2_nominal=fill(0, nPorts1),
    final cp1_nominal=cp1_nominal,
    final cp2_nominal=cp2_nominal)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.RealExpression UAAct[nPorts1](y=1 ./ (1 ./ (
        UAInt_nominal .* Buildings.Utilities.Math.Functions.regNonZeroPower(
        senMasFlo.m_flow ./ m_flow1_nominal, expUA)) .+ 1 ./ UAExt_nominal))
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFlo[nPorts1](
    redeclare package Medium=Medium1)
    annotation (Placement(transformation(extent={{-150,-210},{-130,-190}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort T1InlMes[nPorts1](redeclare final
      package Medium =
               Medium1, final m_flow_nominal=m_flow1_nominal)
    annotation (Placement(transformation(extent={{-110,-210},{-90,-190}})));
  Modelica.Blocks.Sources.RealExpression m_flow2Act[nPorts1](y=fill(0, nPorts1))
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  Buildings.Fluid.HeatExchangers.HeaterCooler_u heaCoo[nPorts1](
    redeclare each final package Medium = Medium1,
    final dp_nominal=dp1_nominal,
    final m_flow_nominal=m_flow1_nominal,
    each final Q_flow_nominal=-1) "Heat exchange with water stream"
    annotation (Placement(transformation(extent={{60,-210},{80,-190}})));
  Buildings.Applications.DHC.Loads.BaseClasses.FirstOrderODE TLoaODE[nPorts1](
    each TOutHea_nominal=268.15,
    TIndHea_nominal={293.15,297.15},
    each Q_flowHea_nominal=500,
    Q_flow_nominal={500,-2000})
    annotation (Placement(transformation(extent={{-60,170},{-40,190}})));
equation
  connect(hexHeaCoo.UA, UAAct.y) annotation (Line(points={{-12,8},{-26,8},{-26,20},
          {-39,20}}, color={0,0,127}));
  connect(ports_a1, senMasFlo.port_a)
    annotation (Line(points={{-200,-200},{-150,-200}}, color={0,127,255}));
  connect(senMasFlo.m_flow, hexHeaCoo.m_flow1)
    annotation (Line(points={{-140,-189},{-140,4},{-12,4}}, color={0,0,127}));
  connect(senMasFlo.port_b, T1InlMes.port_a)
    annotation (Line(points={{-130,-200},{-110,-200}}, color={0,127,255}));
  connect(T1InlMes.T, hexHeaCoo.T1Inl)
    annotation (Line(points={{-100,-189},{-100,0},{-12,0}}, color={0,0,127}));
  connect(m_flow2Act.y, hexHeaCoo.m_flow2) annotation (Line(points={{-39,-20},{-26,
          -20},{-26,-4},{-12,-4}}, color={0,0,127}));
  connect(T1InlMes.port_b, heaCoo.port_a)
    annotation (Line(points={{-90,-200},{60,-200}}, color={0,127,255}));
  connect(heaCoo.port_b, ports_b1)
    annotation (Line(points={{80,-200},{200,-200}}, color={0,127,255}));
  connect(hexHeaCoo.Q_flow, heaCoo.u) annotation (Line(points={{12,0},{20,0},{
          20,-194},{58,-194}},
                            color={0,0,127}));
  connect(conQ_flowReq.y, gaiFloNom1.u)
    annotation (Line(points={{12,220},{158,220}}, color={0,0,127}));
  connect(uSet, TLoaODE.TSet) annotation (Line(points={{-220,220},{-100,220},{-100,
          188},{-62,188}}, color={0,0,127}));
  connect(Q_flow2Req, TLoaODE.Q_flowReq)
    annotation (Line(points={{-220,180},{-62,180}}, color={0,0,127}));
  connect(TLoaODE.TInd, hexHeaCoo.T2Inl) annotation (Line(points={{-38,180},{-20,
          180},{-20,-8},{-12,-8}}, color={0,0,127}));
  connect(Q_flow2Req, conQ_flowReq.u_s) annotation (Line(points={{-220,180},{-80,
          180},{-80,220},{-12,220}}, color={0,0,127}));
  connect(hexHeaCoo.Q_flow, Q_flow2Act) annotation (Line(points={{12,0},{20,0},
          {20,180},{220,180}}, color={0,0,127}));
  connect(hexHeaCoo.Q_flow, TLoaODE.Q_flowAct) annotation (Line(points={{12,0},
          {20,0},{20,160},{-80,160},{-80,172},{-62,172}}, color={0,0,127}));
  connect(gaiFloNom1.y, m_flow1Req)
    annotation (Line(points={{182,220},{220,220}}, color={0,0,127}));
  connect(hexHeaCoo.Q_flow, conQ_flowReq.u_m) annotation (Line(points={{12,0},{
          20,0},{20,180},{0,180},{0,208}}, color={0,0,127}));
end Terminal4PipesHeatReq;
