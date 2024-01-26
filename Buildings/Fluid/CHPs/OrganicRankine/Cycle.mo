within Buildings.Fluid.CHPs.OrganicRankine;
model Cycle

  extends Buildings.Fluid.Interfaces.FourPortHeatMassExchanger(
    final m1_flow_nominal = mEva_flow_nominal,
    final dp1_nominal = dpEva_nominal,
    final m2_flow_nominal = mCon_flow_nominal,
    final dp2_nominal = dpCon_nominal,
    T1_start = (max(pro.T) + min(pro.T))/2,
    T2_start = 300,
    redeclare final Buildings.Fluid.MixingVolumes.MixingVolume vol2(
      V=m2_flow_nominal*tau2/rho2_nominal,
      nPorts=2,
      final prescribedHeatFlowRate=true),
    final vol1(
      final prescribedHeatFlowRate=true));

  Buildings.Fluid.CHPs.OrganicRankine.BaseClasses.ComputeCycle intSta(
    final pro=pro,
    final mWor_flow_max=mWor_flow_max,
    final mWor_flow_min=mWor_flow_min,
    final TEvaWor=TEvaWor,
    final dTEvaPin_set=dTEvaPin_set,
    final dTConPin_set=dTConPin_set,
    final cpEva=Medium1.specificHeatCapacityCp(sta1_nominal),
    final cpCon=Medium2.specificHeatCapacityCp(sta2_nominal),
    etaExp=0.7) "Interpolate working fluid states"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  replaceable parameter Buildings.Fluid.CHPs.OrganicRankine.Data.Generic pro
    constrainedby Buildings.Fluid.CHPs.OrganicRankine.Data.Generic
    "Property records of the working fluid"
    annotation(choicesAllMatching = true);
  parameter Modelica.Units.SI.HeatFlowRate QEva_flow_nominal
    "Nominal heat flow rate of the evaporator"
    annotation(Dialog(group="Evaporator"));
  parameter Modelica.Units.SI.MassFlowRate mEva_flow_nominal
    "Nominal mass flow rate of the evaporator fluid"
    annotation(Dialog(group="Evaporator"));
  parameter Modelica.Units.SI.PressureDifference dpEva_nominal = 0
    "Nominal pressure drop of the evaporator"
    annotation(Dialog(group="Evaporator"));
  parameter Modelica.Units.SI.TemperatureDifference dTEvaPin_set(
    final min = 0) = 5
    "Set evaporator pinch point temperature differential"
    annotation(Dialog(group="Evaporator"));
  parameter Modelica.Units.SI.ThermodynamicTemperature TEvaWor
    "Evaporating temperature of the working fluid"
    annotation(Dialog(group="Evaporator"));
  parameter Modelica.Units.SI.MassFlowRate mCon_flow_nominal
    "Nominal mass flow rate of the condenser fluid"
    annotation(Dialog(group="Condenser"));
  parameter Modelica.Units.SI.PressureDifference dpCon_nominal = 0
    "Nominal pressure drop of the condenser"
    annotation(Dialog(group="Condenser"));
  parameter Modelica.Units.SI.TemperatureDifference dTConPin_set(
    final min = 0) = 10
    "Set condenser pinch point temperature differential"
    annotation(Dialog(group="Condenser"));
  parameter Modelica.Units.SI.MassFlowRate mWor_flow_max(
    final min = 0)
    = QEva_flow_nominal / (
        Buildings.Utilities.Math.Functions.smoothInterpolation(
          x = TEvaWor,
          xSup = pro.T,
          ySup = pro.hSatVap) -
        Buildings.Utilities.Math.Functions.smoothInterpolation(
          x = 310,
          xSup = pro.T,
          ySup = pro.hSatLiq))
    "Upper bound of working fluid flow rate";
  parameter Modelica.Units.SI.MassFlowRate mWor_flow_min(
    final min = 0)
    = mWor_flow_max / 10
    "Lower bound of working fluid flow rate";

  Modelica.Blocks.Sources.RealExpression expTEvaIn(y=Medium1.temperature(
        state=Medium1.setState_phX(
          p=port_a1.p,
          h=inStream(port_a1.h_outflow),
          X=inStream(port_a1.Xi_outflow))))
    "Expression for evaporator hot fluid incoming temperature"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Modelica.Blocks.Sources.RealExpression expMEva_flow(y=m1_flow)
    "Expression for evaporator hot fluid flow rate"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Modelica.Blocks.Sources.RealExpression expTConIn(y=Medium2.temperature(
        state=Medium2.setState_phX(
          p=port_a2.p,
          h=inStream(port_a2.h_outflow),
          X=inStream(port_a2.Xi_outflow))))
    "Expression for condenser cold fluid incoming temperature"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  Modelica.Blocks.Sources.RealExpression expMCon_flow(y=m2_flow)
    "Expression for condenser cold fluid flow rate"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));

protected
  Buildings.HeatTransfer.Sources.PrescribedHeatFlow preHeaFloEva
    "Prescribed heat flow rate"
    annotation (Placement(transformation(extent={{39,30},{19,50}})));
  Buildings.HeatTransfer.Sources.PrescribedHeatFlow preHeaFloCon
    "Prescribed heat flow rate"
    annotation (Placement(transformation(extent={{41,-70},{21,-50}})));
equation
  connect(preHeaFloEva.port, vol1.heatPort) annotation (Line(points={{19,40},{-16,
          40},{-16,60},{-10,60}}, color={191,0,0}));
  connect(preHeaFloCon.port, vol2.heatPort) annotation (Line(points={{21,-60},{12,
          -60}},                      color={191,0,0}));
  connect(intSta.QCon_flow, preHeaFloCon.Q_flow) annotation (Line(points={{12,-6},
          {50,-6},{50,-60},{41,-60}}, color={0,0,127}));
  connect(expTEvaIn.y, intSta.TEvaIn) annotation (Line(points={{-39,30},{-20,30},
          {-20,8},{-12,8}}, color={0,0,127}));
  connect(expMEva_flow.y, intSta.mEva_flow) annotation (Line(points={{-39,10},{-30,
          10},{-30,4},{-12,4}}, color={0,0,127}));
  connect(expTConIn.y, intSta.TConIn) annotation (Line(points={{-39,-10},{-30,-10},
          {-30,-4},{-12,-4}}, color={0,0,127}));
  connect(expMCon_flow.y, intSta.mCon_flow) annotation (Line(points={{-39,-30},{
          -20,-30},{-20,-8},{-12,-8}}, color={0,0,127}));
  connect(intSta.QEva_flow, preHeaFloEva.Q_flow)
    annotation (Line(points={{12,6},{50,6},{50,40},{39,40}}, color={0,0,127}));
  annotation (defaultComponentName = "ORC",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Line(
          points={{-60,-60},{-28,-20},{16,32},{40,60},{52,60},{54,30},{48,2},{
              52,-38},{58,-58}},
          color={255,255,255},
          smooth=Smooth.Bezier,
          thickness=0.5),
        Line(
          points={{6,20},{52,20},{66,-6},{50,-18},{-26,-18}},
          color={255,255,255},
          thickness=0.5,
          pattern=LinePattern.Dash)}),               Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Cycle;
