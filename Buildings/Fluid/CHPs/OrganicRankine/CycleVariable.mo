within Buildings.Fluid.CHPs.OrganicRankine;
model CycleVariable

  extends Buildings.Fluid.Interfaces.FourPortHeatMassExchanger(
    final m1_flow_nominal = mEva_flow_nominal,
    final dp1_nominal = dpEva_nominal,
    final m2_flow_nominal = mCon_flow_nominal,
    final dp2_nominal = dpCon_nominal,
    T1_start = 273.15+25,
    T2_start = 273.15+5,
    redeclare final Buildings.Fluid.MixingVolumes.MixingVolume vol2(
      V=m2_flow_nominal*tau2/rho2_nominal,
      nPorts=2,
      final prescribedHeatFlowRate=true),
    final vol1(
      final prescribedHeatFlowRate=true));

  Buildings.Fluid.CHPs.OrganicRankine.BaseClasses.EquationsVariable equ(
    redeclare parameter
      Buildings.Fluid.CHPs.OrganicRankine.Data.WorkingFluids.Toluene pro,
    etaExp=0.7)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  replaceable parameter Buildings.Fluid.CHPs.OrganicRankine.Data.Generic pro
    constrainedby Buildings.Fluid.CHPs.OrganicRankine.Data.Generic
    "Property records of the working fluid"
    annotation(choicesAllMatching = true);
  parameter Modelica.Units.SI.ThermalConductance UAEva = 1000
    "Thermal conductance of the evaporator"
    annotation(Dialog(group="Evaporator"));
  parameter Modelica.Units.SI.MassFlowRate mEva_flow_nominal = 1
    "Nominal mass flow rate of the evaporator fluid"
    annotation(Dialog(group="Evaporator"));
  parameter Modelica.Units.SI.PressureDifference dpEva_nominal = 0
    "Nominal pressure drop of the evaporator"
    annotation(Dialog(group="Evaporator"));
  parameter Modelica.Units.SI.ThermalConductance UACon = 1000
    "Thermal conductance of the condenser"
    annotation(Dialog(group="Condenser"));
  parameter Modelica.Units.SI.MassFlowRate mCon_flow_nominal = 1
    "Nominal mass flow rate of the condenser fluid"
    annotation(Dialog(group="Condenser"));
  parameter Modelica.Units.SI.PressureDifference dpCon_nominal = 0
    "Nominal pressure drop of the condenser"
    annotation(Dialog(group="Condenser"));

  Modelica.Blocks.Sources.RealExpression expTEva(y=TEva)
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Modelica.Blocks.Sources.RealExpression expTCon(y=TCon)
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  Modelica.Blocks.Sources.RealExpression expQEva_flow(y=QEva_flow)
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Modelica.Blocks.Sources.RealExpression expQCon_flow(y=QCon_flow)
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Sensors.Temperature senTemEvaIn(redeclare package Medium = Medium1,
      warnAboutOnePortConnection=false) "fixme: to be replaced"
    annotation (Placement(transformation(extent={{-58,50},{-38,70}})));
  Sensors.Temperature senTemConIn(redeclare package Medium = Medium2,
      warnAboutOnePortConnection=false) "fixme: to be replaced"
    annotation (Placement(transformation(extent={{60,-60},{80,-40}})));
protected
  Buildings.HeatTransfer.Sources.PrescribedHeatFlow preHeaFloEva
    "Prescribed heat flow rate"
    annotation (Placement(transformation(extent={{-39,20},{-19,40}})));
  Buildings.HeatTransfer.Sources.PrescribedHeatFlow preHeaFloCon
    "Prescribed heat flow rate"
    annotation (Placement(transformation(extent={{-39,-40},{-19,-20}})));

public
  Real CpEva, TEva, TEvaIn, QEva_flow, TEvaOut, QEva_flow_max, epsEva;
  Real CpCon, TCon( start = 300), TConIn, QCon_flow, TConOut, QCon_flow_max, epsCon;

equation
  // Evaporator
  //m1_flow = 1;
  CpEva = 4200;
  TEvaIn = senTemEvaIn.T;

  QEva_flow = m1_flow * CpEva * (TEvaIn - TEvaOut);
  QEva_flow = QEva_flow_max * epsEva;
  QEva_flow_max = m1_flow * CpEva * (TEvaIn - TEva);
  epsEva = 1 - exp(UAEva/(- m1_flow * CpEva));

  // Condenser
  //m2_flow = 2;
  CpCon = 4200;
  TConIn = senTemConIn.T;

  QCon_flow = m2_flow * CpCon * (TConOut - TConIn);
  QCon_flow = QCon_flow_max * epsCon;
  QCon_flow_max = m2_flow * CpCon * (TCon - TConIn);
  epsCon = 1 - exp(UACon/(- m2_flow * CpCon));

  // Cycle
  QEva_flow * equ.etaThe = QEva_flow - QCon_flow;

  // Control input
  TEva = 450;



  connect(expTEva.y, equ.TEva) annotation (Line(points={{-39,10},{-20,10},{-20,4},
          {-12,4}}, color={0,0,127}));
  connect(expTCon.y, equ.TCon) annotation (Line(points={{-39,-10},{-20,-10},{-20,
          -4},{-12,-4}}, color={0,0,127}));
  connect(preHeaFloEva.port, vol1.heatPort) annotation (Line(points={{-19,30},{-16,
          30},{-16,60},{-10,60}}, color={191,0,0}));
  connect(expQEva_flow.y, preHeaFloEva.Q_flow)
    annotation (Line(points={{-59,30},{-39,30}}, color={0,0,127}));
  connect(expQCon_flow.y, preHeaFloCon.Q_flow)
    annotation (Line(points={{-59,-30},{-39,-30}}, color={0,0,127}));
  connect(preHeaFloCon.port, vol2.heatPort) annotation (Line(points={{-19,-30},{
          18,-30},{18,-60},{12,-60}}, color={191,0,0}));
  connect(senTemEvaIn.port, port_a1) annotation (Line(points={{-48,50},{-90,50},
          {-90,60},{-100,60}}, color={0,127,255}));
  connect(senTemConIn.port, port_a2)
    annotation (Line(points={{70,-60},{100,-60}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end CycleVariable;
