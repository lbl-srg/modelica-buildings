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

  Modelica.Blocks.Sources.RealExpression expTConWor(y=TConWor)
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  Modelica.Blocks.Sources.RealExpression expQEva_flow(y=QEva_flow_internal)
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Modelica.Blocks.Sources.RealExpression expQCon_flow(y=QCon_flow_internal)
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Sensors.Temperature senTem1(redeclare package Medium = Medium1,
      warnAboutOnePortConnection=false) "fixme: to be replaced"
    annotation (Placement(transformation(extent={{-58,50},{-38,70}})));
  Sensors.Temperature senTem2(redeclare package Medium = Medium2,
      warnAboutOnePortConnection=false) "fixme: to be replaced"
    annotation (Placement(transformation(extent={{60,-60},{80,-40}})));

  Modelica.Blocks.Interfaces.RealInput TEvaWor(unit="K")
    "Set point for working fluid evaporating temperature" annotation (Placement(
        transformation(
        origin={-110,10},
        extent={{10,-10},{-10,10}},
        rotation=180), iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-110,20})));
  Modelica.Units.SI.ThermodynamicTemperature TConWor(
    start=300)
    "Working fluid condenser temperature";

  // Evaporator
protected
  parameter Modelica.Units.SI.SpecificHeatCapacity cpEva_default =
    Medium1.specificHeatCapacityCp(sta1_nominal)
    "Constant specific heat capacity";
  Buildings.HeatTransfer.Sources.PrescribedHeatFlow preHeaFloEva
    "Prescribed heat flow rate"
    annotation (Placement(transformation(extent={{-39,20},{-19,40}})));
  Modelica.Units.SI.ThermodynamicTemperature TEvaIn=senTem1.T
    "Fluid temperature into the evaporator";
  Modelica.Units.SI.ThermodynamicTemperature TEvaOut_internal
    "Fluid temperature out of the evaporator, intermediate variable";
  Modelica.Units.SI.HeatFlowRate QEva_flow_internal
    "Evaporator heat flow rate, intermediate variable";
  Modelica.Units.SI.HeatFlowRate QEva_flow_max
    "Maximum evaporator heat flow rate";
  Modelica.Units.SI.Efficiency NTUEva=UAEva/(Buildings.Utilities.Math.Functions.smoothMax(
      abs(m1_flow),
      m1_flow_small,
      m1_flow_small)*cpEva_default) "Number of transfer units of heat exchanger";
  Modelica.Units.SI.Efficiency epsEva=Buildings.Utilities.Math.Functions.smoothMin(
      Buildings.Fluid.HeatExchangers.BaseClasses.epsilon_ntuZ(
        NTUEva,
        0,
        Integer(Buildings.Fluid.Types.HeatExchangerFlowRegime.ConstantTemperaturePhaseChange)),
      0.999,
      1.0e-4) "Effectiveness of heat exchanger";

  // Condenser
  parameter Modelica.Units.SI.SpecificHeatCapacity cpCon_default =
    Medium2.specificHeatCapacityCp(sta2_nominal)
    "Constant specific heat capacity";
  Buildings.HeatTransfer.Sources.PrescribedHeatFlow preHeaFloCon
    "Prescribed heat flow rate"
    annotation (Placement(transformation(extent={{-39,-40},{-19,-20}})));
  Modelica.Units.SI.ThermodynamicTemperature TConIn = senTem2.T
    "Fluid temperature into the condenser";
  Modelica.Units.SI.ThermodynamicTemperature TConOut_internal
    "Fluid temperature out of the condenser, intermediate variable";
  Modelica.Units.SI.HeatFlowRate QCon_flow_internal
    "Condenser heat flow rate, intermediate variable";
  Modelica.Units.SI.HeatFlowRate QCon_flow_max
    "Maximum condenser heat flow rate";
  Modelica.Units.SI.Efficiency NTUCon=UACon/(Buildings.Utilities.Math.Functions.smoothMax(
      abs(m2_flow),
      m2_flow_small,
      m2_flow_small)*cpCon_default) "Number of transfer units of heat exchanger";
  Modelica.Units.SI.Efficiency epsCon=Buildings.Utilities.Math.Functions.smoothMin(
      Buildings.Fluid.HeatExchangers.BaseClasses.epsilon_ntuZ(
        NTUCon,
        0,
        Integer(Buildings.Fluid.Types.HeatExchangerFlowRegime.ConstantTemperaturePhaseChange)),
      0.999,
      1.0e-4) "Effectiveness of heat exchanger";

equation
  // Evaporator
  QEva_flow_internal = m1_flow * cpEva_default * (TEvaIn - TEvaOut_internal);
  QEva_flow_internal = QEva_flow_max * epsEva;
  QEva_flow_max =m1_flow*cpEva_default*(TEvaIn - TEvaWor);

  // Condenser
  QCon_flow_internal = m2_flow * cpCon_default * (TConOut_internal - TConIn);
  QCon_flow_internal = QCon_flow_max * epsCon;
  QCon_flow_max = m2_flow * cpCon_default * (TConWor - TConIn);

  // Cycle
  QEva_flow_internal * equ.etaThe = QEva_flow_internal - QCon_flow_internal;

  connect(expTConWor.y, equ.TCon) annotation (Line(points={{-59,-10},{-20,-10},{
          -20,-4},{-12,-4}}, color={0,0,127}));
  connect(preHeaFloEva.port, vol1.heatPort) annotation (Line(points={{-19,30},{-16,
          30},{-16,60},{-10,60}}, color={191,0,0}));
  connect(expQEva_flow.y, preHeaFloEva.Q_flow)
    annotation (Line(points={{-59,30},{-39,30}}, color={0,0,127}));
  connect(expQCon_flow.y, preHeaFloCon.Q_flow)
    annotation (Line(points={{-59,-30},{-39,-30}}, color={0,0,127}));
  connect(preHeaFloCon.port, vol2.heatPort) annotation (Line(points={{-19,-30},{
          18,-30},{18,-60},{12,-60}}, color={191,0,0}));
  connect(senTem1.port, port_a1) annotation (Line(points={{-48,50},{-90,50},{-90,
          60},{-100,60}}, color={0,127,255}));
  connect(senTem2.port, port_a2)
    annotation (Line(points={{70,-60},{100,-60}}, color={0,127,255}));
  connect(equ.TEva, TEvaWor) annotation (Line(points={{-12,4},{-20,4},{-20,10},{
          -110,10}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end CycleVariable;
