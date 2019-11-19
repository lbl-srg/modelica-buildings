within Buildings.Applications.DHC.Loads.BaseClasses;
model HeatFlowWetCoil "Model computing the heat flow rate based on the effectiveness method"
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(
    final m_flow_nominal=m_flow1_nominal,
    port_a(h_outflow(start=h_outflow_start)),
    port_b(h_outflow(start=h_outflow_start)));
  parameter Buildings.Fluid.Types.HeatExchangerFlowRegime flowRegime
    "Heat exchanger flow regime, see  Buildings.Fluid.Types.HeatExchangerFlowRegime";
  parameter Modelica.SIunits.MassFlowRate m_flow1_nominal(min=0)
    "Source side mass flow rate at nominal conditions"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate m_flow2_nominal(min=0)
    "Load side mass flow rate at nominal conditions"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.SpecificHeatCapacity cp1_nominal
    "Source side specific heat capacity at nominal conditions"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.SpecificHeatCapacity cp2_nominal
    "Load side specific heat capacity at nominal conditions"
    annotation(Dialog(group = "Nominal condition"));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput T1Inl(
    quantity="ThermodynamicTemperature", displayUnit="degC")
    "Source side temperature at inlet"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,120}),iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,0})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput m_flow1(
    quantity="MassFlowRate")
    "Source side mass flow rate"
    annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,160}),iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,40})));
  Modelica.SIunits.Efficiency eps
    "Heat exchanger effectiveness";
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput Q_flowSen(quantity="HeatFlowRate")
    "Sensible heat flow rate transferred to the load" annotation (Placement(transformation(extent={{100,40},{140,80}}),
        iconTransformation(extent={{104,-60},{124,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput Q_flowTot(quantity="HeatFlowRate")
    "Total heat flow rate transferred to the load" annotation (Placement(transformation(extent={{100,140},{140,180}}),
        iconTransformation(extent={{104,-60},{124,-40}})));
  Fluid.Sensors.TemperatureTwoPort senTem annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));
  Fluid.Sensors.Pressure senPre annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  Fluid.Sensors.MassFlowRate senMasFlo annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Fluid.Sensors.SpecificEnthalpyTwoPort senSpeEnt annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Modelica.Blocks.Routing.RealPassThrough realPassThrough
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={66,34})));
  Fluid.Sensors.MassFractionTwoPort senMasFra annotation (Placement(transformation(extent={{-66,-10},{-46,10}})));
  Modelica.Blocks.Routing.RealPassThrough realPassThrough1 annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-58,80})));
protected
  parameter Real deltaCMin = 1E-4 * CMin_flow_nominal
    "Regularization term for smoothing CMin_flow";
  parameter Modelica.SIunits.ThermalConductance CMin_flow_nominal = min(
    m_flow1_nominal * cp1_nominal, m_flow2_nominal * cp2_nominal);
  parameter Modelica.SIunits.ThermalConductance CMax_flow_nominal = max(
    m_flow1_nominal * cp1_nominal, m_flow2_nominal * cp2_nominal);
  final parameter Real deltaReg = m_flow1_nominal * 1E-7
    "Smoothing region for inverseXRegularized";
  final parameter Real deltaInvReg = 1/deltaReg
    "Inverse value of delta for inverseXRegularized";
  final parameter Real aReg = -15*deltaInvReg
    "Polynomial coefficient for inverseXRegularized";
  final parameter Real bReg = 119*deltaInvReg^2
    "Polynomial coefficient for inverseXRegularized";
  final parameter Real cReg = -361*deltaInvReg^3
    "Polynomial coefficient for inverseXRegularized";
  final parameter Real dReg = 534*deltaInvReg^4
    "Polynomial coefficient for inverseXRegularized";
  final parameter Real eReg = -380*deltaInvReg^5
    "Polynomial coefficient for inverseXRegularized";
  final parameter Real fReg = 104*deltaInvReg^6
    "Polynomial coefficient for inverseXRegularized";
  Real m_flow1_inv(unit="s/kg") "Regularization of 1/m_flow";
  Fluid.HeatExchangers.BaseClasses.HADryCoil           hA(
    final UA_nominal=UA_nominal,
    final m_flow_nominal_a=m2_flow_nominal,
    final m_flow_nominal_w=m1_flow_nominal,
    final waterSideTemperatureDependent=waterSideTemperatureDependent,
    final waterSideFlowDependent=waterSideFlowDependent,
    final airSideTemperatureDependent=airSideTemperatureDependent,
    final airSideFlowDependent=airSideFlowDependent,
    r_nominal=r_nominal)
    "Model for convective heat transfer coefficient"
    annotation (Placement(transformation(extent={{-70,125},{-52,147}})));
  Fluid.HeatExchangers.BaseClasses.DryWetCalcsFuzzy_V2_0      dryWetCalcs(
    redeclare final package Medium2 = Medium2,
    final TWatOut_init=TWatOut_init,
    final cfg=flowRegime,
    final mWat_flow_nominal=m1_flow_nominal,
    final mAir_flow_nominal=m2_flow_nominal)
    "Dry/wet calculations block"
    annotation (Placement(transformation(extent={{-14,90},{66,170}})));
  Modelica.Blocks.Sources.RealExpression cp_a1Exp(final y=if allowFlowReversal1 then fra_a1*
        Medium1.specificHeatCapacityCp(state_a1_inflow) + fra_b1*Medium1.specificHeatCapacityCp(state_b1_inflow) else
        Medium1.specificHeatCapacityCp(state_a1_inflow))
    "Expression for cp of air"
    annotation (Placement(transformation(extent={{-62,196},{-48,208}})));
  Modelica.Blocks.Sources.RealExpression cp_a2Exp(final y=if allowFlowReversal2 then fra_a2*
        Medium2.specificHeatCapacityCp(state_a2_inflow) + fra_b2*Medium2.specificHeatCapacityCp(state_b2_inflow) else
        Medium2.specificHeatCapacityCp(state_a2_inflow))
    "Specific heat capacity at port a2"
    annotation (Placement(transformation(extent={{-38,100},{-24,112}})));
  HeatTransfer.Sources.PrescribedHeatFlow           preHea
    "Prescribed heat flow"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={34,34})));
  Fluid.Humidifiers.Humidifier_u           heaCooHum_u(
    redeclare package Medium = Medium2,
    mWat_flow_nominal=1,
    dp_nominal=dp2_nominal,
    m_flow_nominal=m2_flow_nominal,
    energyDynamics=energyDynamics,
    massDynamics=massDynamics)
    "Heat and moisture exchange with air stream"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
equation
  if flowRegime == Buildings.Fluid.Types.HeatExchangerFlowRegime.ConstantTemperaturePhaseChange then
    // By convention, a zero value for m_flow2 is associated with that flow regime which requires
    // specific equations.
    eps = Buildings.Fluid.HeatExchangers.BaseClasses.epsilon_ntuZ(
      NTU=UA / cp1_nominal * m_flow1_inv,
      Z=0,
      flowRegime=Integer(Buildings.Fluid.Types.HeatExchangerFlowRegime.ConstantTemperaturePhaseChange));
    m_flow1_inv = Buildings.Utilities.Math.Functions.inverseXRegularized(
      x=m_flow1, delta=deltaReg, deltaInv=deltaInvReg, a=aReg, b=bReg, c=cReg, d=dReg, e=eReg, f=fReg);
  else
    eps = Buildings.Fluid.HeatExchangers.BaseClasses.epsilon_C(
      UA=UA,
      C1_flow=m_flow1 * cp1_nominal,
      C2_flow=m_flow2 * cp2_nominal,
      flowRegime=Integer(flowRegime),
      CMin_flow_nominal=CMin_flow_nominal,
      CMax_flow_nominal=CMax_flow_nominal);
    m_flow1_inv = 0;
  end if;
  // Equation for CMin_flow is inlined to optimize scaling and improve convergence of Newton solver.
  Q_flowTot = (if flowRegime == Buildings.Fluid.Types.HeatExchangerFlowRegime.ConstantTemperaturePhaseChange then
    m_flow1*cp1_nominal else Buildings.Utilities.Math.Functions.smoothMin(
    m_flow1*cp1_nominal,
    m_flow2*cp2_nominal,
    deltaCMin))*eps*(T1Inl - T2Inl);
  connect(hA.hA_1,dryWetCalcs. UAWat) annotation (Line(points={{-51.1,143.7},{-40,143.7},{-40,166.667},{-16.8571,
          166.667}},                               color={0,0,127}));
  connect(hA.hA_2,dryWetCalcs. UAAir) annotation (Line(points={{-51.1,128.3},{-40,128.3},{-40,93.3333},{-16.8571,
          93.3333}},                                 color={0,0,127}));
  connect(cp_a2Exp.y,dryWetCalcs. cpAir) annotation (Line(points={{-23.3,106},{-16.8571,106},{-16.8571,106.667}},
                                     color={0,0,127}));
  connect(m_flow1, dryWetCalcs.mWat_flow) annotation (Line(points={{-120,160},{-16.8571,160}},
                                                                                             color={0,0,127}));
  connect(m_flow1, hA.m1_flow) annotation (Line(points={{-120,160},{-92,160},{-92,143.7},{-70.9,143.7}},
                                                                                                     color={0,0,127}));
  connect(T1Inl, hA.T_1) annotation (Line(points={{-120,120},{-80,120},{-80,139.3},{-70.9,139.3}},
                                                                                               color={0,0,127}));
  connect(T1Inl, dryWetCalcs.TWatIn)
    annotation (Line(points={{-120,120},{-80,120},{-80,146.667},{-16.8571,146.667}},
                                                                                   color={0,0,127}));
  connect(dryWetCalcs.QSen_flow, Q_flowSen)
    annotation (Line(points={{68.8571,110},{84,110},{84,60},{120,60}},
                                                                     color={0,0,127}));
  connect(dryWetCalcs.QTot_flow, Q_flowTot)
    annotation (Line(points={{68.8571,123.333},{84,123.333},{84,160},{120,160}},
                                                                               color={0,0,127}));
  connect(port_a, senPre.port) annotation (Line(points={{-100,0},{-100,20},{-90,20}}, color={0,127,255}));
  connect(senPre.p, dryWetCalcs.pAir)
    annotation (Line(points={{-79,30},{-46,30},{-46,126.667},{-16.8571,126.667}}, color={0,0,127}));
  connect(senTem.T, hA.T_2) annotation (Line(points={{-80,11},{-80,132.7},{-70.9,132.7}}, color={0,0,127}));
  connect(senMasFlo.m_flow, hA.m2_flow)
    annotation (Line(points={{-30,11},{-66,11},{-66,128.3},{-70.9,128.3}}, color={0,0,127}));
  connect(senMasFlo.port_b, senSpeEnt.port_a) annotation (Line(points={{-20,0},{0,0}}, color={0,127,255}));
  connect(senSpeEnt.h_out, dryWetCalcs.hAirIn)
    annotation (Line(points={{10,11},{-24,11},{-24,120},{-16.8571,120}}, color={0,0,127}));
  connect(senSpeEnt.port_b, heaCooHum_u.port_a) annotation (Line(points={{20,0},{60,0}}, color={0,127,255}));
  connect(heaCooHum_u.port_b, port_b) annotation (Line(points={{80,0},{100,0}}, color={0,127,255}));
  connect(preHea.port, heaCooHum_u.heatPort) annotation (Line(points={{34,24},{34,-6},{60,-6}}, color={191,0,0}));
  connect(dryWetCalcs.QTot_flow, preHea.Q_flow)
    annotation (Line(points={{68.8571,123.333},{68.8571,83.6665},{34,83.6665},{34,44}}, color={0,0,127}));
  connect(dryWetCalcs.mCon_flow, realPassThrough.u)
    annotation (Line(points={{68.8571,96.6667},{68.8571,68.3333},{66,68.3333},{66,46}}, color={0,0,127}));
  connect(realPassThrough.y, heaCooHum_u.u) annotation (Line(points={{66,23},{56,23},{56,6},{59,6}}, color={0,0,127}));
  connect(cp_a1Exp.y, dryWetCalcs.cpWat)
    annotation (Line(points={{-47.3,202},{-34,202},{-34,153.333},{-16.8571,153.333}}, color={0,0,127}));
  connect(port_a, senTem.port_a) annotation (Line(points={{-100,0},{-90,0}}, color={0,127,255}));
  connect(senMasFlo.port_a, senMasFra.port_b) annotation (Line(points={{-40,0},{-46,0}}, color={0,127,255}));
  connect(senTem.port_b, senMasFra.port_a) annotation (Line(points={{-70,0},{-66,0}}, color={0,127,255}));
  connect(senMasFra.X, realPassThrough1.u) annotation (Line(points={{-56,11},{-58,11},{-58,68}}, color={0,0,127}));
  connect(realPassThrough1.y, dryWetCalcs.wAirIn)
    annotation (Line(points={{-58,91},{-50,91},{-50,133.333},{-16.8571,133.333}}, color={0,0,127}));
annotation (
  defaultComponentName="heaFloEff",
  Documentation(info="
  <html>
  <p>
  This model computes the heat flow rate transferred to a load at uniform temperature, based on the
  effectiveness method:
  </p>
  <p align=\"center\" style=\"font-style:italic;\">
  Q&#775; = &epsilon; * C<sub>min</sub> * (T<sub>inl</sub> - T<sub>load</sub>)
  </p>
  <p>
  where
  <i>&epsilon;</i> is the effectiveness,
  <i>C<sub>min</sub></i> is the minimum capacity rate,
  <i>T<sub>inl</sub></i> is the fluid inlet temperature and
  <i>T<sub>load</sub></i> is the temperature of the load.
  </p>
  <p>
  Under the assumption of a uniform load temperature, the effective capacity rate on the load side is infinite
  so <i>C<sub>min</sub></i> corresponds to the capacity rate of the circulating fluid and the expression of
  the effectiveness comes down to:
  </p>
  <p align=\"center\" style=\"font-style:italic;\">
  &epsilon; = 1 - exp(-UA / C<sub>min</sub>)
  </p>
  <p>
  where <i>UA</i> is the overall uniform thermal conductance.
  </p>
  </p>
  </html>"),
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-40},{100,180}})),
                                                     Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -40},{100,180}})));
end HeatFlowWetCoil;
