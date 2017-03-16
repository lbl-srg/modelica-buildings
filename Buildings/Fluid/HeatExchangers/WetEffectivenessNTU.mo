within Buildings.Fluid.HeatExchangers;
model WetEffectivenessNTU
  "Heat exchanger with effectiveness - NTU relation including moisture condensation"
  extends Buildings.Fluid.Interfaces.PartialFourPortInterface(
    redeclare replaceable package Medium2 = Buildings.Media.Air);
  extends Buildings.Fluid.Interfaces.FourPortFlowResistanceParameters(
    final computeFlowResistance1=true,
    final computeFlowResistance2=true);

  // PARAMETERS
  parameter Modelica.SIunits.ThermalConductance UA_nominal(min=0)
    "Thermal conductance at nominal flow, used to compute heat capacity"
          annotation(Dialog(tab="General", group="Nominal condition"));
  parameter Real r_nominal=2/3
    "Ratio between air-side and water-side convective heat transfer coefficient"
    annotation (Dialog(group="Nominal condition"));
  parameter Boolean waterSideFlowDependent=true
    "Set to false to make water-side hA independent of mass flow rate"
    annotation (Dialog(tab="Heat transfer"));
  parameter Boolean airSideFlowDependent=true
    "Set to false to make air-side hA independent of mass flow rate"
    annotation (Dialog(tab="Heat transfer"));
  parameter Boolean waterSideTemperatureDependent=false
    "Set to false to make water-side hA independent of temperature"
    annotation (Dialog(tab="Heat transfer"));
  parameter Boolean airSideTemperatureDependent=false
    "Set to false to make air-side hA independent of temperature"
    annotation (Dialog(tab="Heat transfer"));
  parameter Buildings.Fluid.Types.HeatExchangerConfiguration cfg=
    Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow;

  // COMPONENTS
  // Q_flow_nominal below is the "gain" for heat flow. By setting the basis
  // to 1.0, we can allow the value coming in via the control signal, u, to
  // be the Q_flow added to medium 1 (the "water")
  Buildings.Fluid.HeatExchangers.HeaterCooler_u heaCoo(
    redeclare package Medium = Medium1,
    Q_flow_nominal = 1,
    dp_nominal = dp1_nominal,
    m_flow_nominal = m1_flow_nominal,
    energyDynamics = Modelica.Fluid.Types.Dynamics.SteadyState,
    massDynamics = Modelica.Fluid.Types.Dynamics.SteadyState)
    "Heater/cooler for water stream"
    annotation (Placement(transformation(extent={{60,50},{80,70}})));
  Buildings.Fluid.HeatExchangers.HeaterCoolerHumidifier_u heaCooHum_u(
    redeclare package Medium = Medium2,
    use_T_in = true,
    mWat_flow_nominal = 1,
    Q_flow_nominal = 1,
    dp_nominal = dp2_nominal,
    m_flow_nominal = m2_flow_nominal,
    energyDynamics = Modelica.Fluid.Types.Dynamics.SteadyState,
    massDynamics = Modelica.Fluid.Types.Dynamics.SteadyState)
    "Heater/cooler + (de-)humidifier for air stream"
    annotation (Placement(transformation(extent={{-60,-70},{-80,-50}})));
  Buildings.Fluid.HeatExchangers.BaseClasses.HADryCoil hA(
    final UA_nominal = UA_nominal,
    final m_flow_nominal_a = m2_flow_nominal,
    final m_flow_nominal_w = m1_flow_nominal,
    final waterSideTemperatureDependent = waterSideTemperatureDependent,
    final waterSideFlowDependent = waterSideFlowDependent,
    final airSideTemperatureDependent = airSideTemperatureDependent,
    final airSideFlowDependent = airSideFlowDependent,
    r_nominal = r_nominal)
    "Model for convective heat transfer coefficient"
    annotation (Placement(transformation(extent={{-68,-13},{-50,9}})));
  Buildings.Fluid.HeatExchangers.BaseClasses.DryWetCalcs dryWetCalcs(
    redeclare package Medium1 = Medium1,
    redeclare package Medium2 = Medium2,
    cfg=cfg)
    annotation (Placement(transformation(extent={{-20,-40},{60,40}})));
  Modelica.Blocks.Sources.RealExpression cp_a1Exp(
    y=Medium1.specificHeatCapacityCp(state_a1_inflow))
    annotation (Placement(transformation(extent={{-40,18},{-26,30}})));
  Modelica.Blocks.Sources.RealExpression XWat_a2Exp(
    y=state_a2_inflow.X[nWat])
    annotation (Placement(transformation(extent={{-40,-2},{-26,10}})));
  Modelica.Blocks.Sources.RealExpression p_a2Exp(
    y=Medium2.pressure(state_a2_inflow))
    annotation (Placement(transformation(extent={{-40,-10},{-26,2}})));
  Modelica.Blocks.Sources.RealExpression h_a2Exp(
    y=Medium2.specificEnthalpy(state_a2_inflow))
    annotation (Placement(transformation(extent={{-40,-18},{-26,-6}})));
  Modelica.Blocks.Sources.RealExpression cp_a2Exp(
    y=Medium2.specificHeatCapacityCp(state_a2_inflow))
    annotation (Placement(transformation(extent={{-40,-30},{-26,-18}})));
  Modelica.Blocks.Sources.RealExpression TIn_a1Exp(y=Medium1.temperature(
        state_a1_inflow))
    annotation (Placement(transformation(extent={{-98,16},{-84,28}})));
  Modelica.Blocks.Sources.RealExpression TIn_a2Exp(y=Medium2.temperature(
        state_a2_inflow))
    annotation (Placement(transformation(extent={{-98,-8},{-84,4}})));
  Modelica.Blocks.Sources.RealExpression m_flow_a1Exp(y=port_a1.m_flow)
    annotation (Placement(transformation(extent={{-98,30},{-84,42}})));
  Modelica.Blocks.Sources.RealExpression m_flow_a2Exp(y=port_a2.m_flow)
    annotation (Placement(transformation(extent={{-98,-36},{-84,-24}})));

protected
  parameter Integer nWat=
    Buildings.Fluid.HeatExchangers.BaseClasses.determineWaterIndex(
      Medium2.substanceNames);

equation
  connect(heaCoo.port_b, port_b1) annotation (Line(points={{80,60},{80,60},{100,60}},color={0,127,255},
      thickness=1));
  connect(heaCooHum_u.port_b, port_b2) annotation (Line(
      points={{-80,-60},{-90,-60},{-100,-60}},
      color={0,127,255},
      thickness=1));
  connect(dryWetCalcs.QTot, heaCoo.u) annotation (Line(points={{37.1429,36.6667},
          {37.1429,66},{58,66}}, color={0,0,127}));
  connect(dryWetCalcs.masFloCon, heaCooHum_u.u) annotation (Line(points={{25.7143,
          -36.6667},{25.7143,-54},{-58,-54}}, color={0,0,127}));
  connect(dryWetCalcs.TCon, heaCooHum_u.T_in) annotation (Line(points={{37.1429,
          -36.6667},{37.1429,-66},{-58,-66}}, color={0,0,127}));
  connect(dryWetCalcs.QSen, heaCooHum_u.u1) annotation (Line(points={{48.5714,
          -36.6667},{48.5714,-69},{-58,-69}}, color={0,0,127}));
  connect(hA.hA_1, dryWetCalcs.UAWat) annotation (Line(points={{-49.1,5.7},{-44,
          5.7},{-44,36.6667},{-17.1429,36.6667}},  color={0,0,127}));
  connect(hA.hA_2, dryWetCalcs.UAAir) annotation (Line(points={{-49.1,-9.7},{
          -44,-9.7},{-44,-36.6667},{-17.1429,-36.6667}},
                                                     color={0,0,127}));
  connect(cp_a1Exp.y, dryWetCalcs.cpWat) annotation (Line(points={{-25.3,24},{
          -17.1429,24},{-17.1429,23.3333}},
                                   color={0,0,127}));
  connect(XWat_a2Exp.y, dryWetCalcs.wAirIn) annotation (Line(points={{-25.3,4},
          {-17.1429,4},{-17.1429,3.33333}},  color={0,0,127}));
  connect(p_a2Exp.y, dryWetCalcs.pAir) annotation (Line(points={{-25.3,-4},{
          -17.1429,-4},{-17.1429,-3.33333}},
                                  color={0,0,127}));
  connect(h_a2Exp.y, dryWetCalcs.hAirIn) annotation (Line(points={{-25.3,-12},{
          -22,-12},{-22,-10},{-17.1429,-10}},
                                    color={0,0,127}));
  connect(cp_a2Exp.y, dryWetCalcs.cpAir) annotation (Line(points={{-25.3,-24},{
          -17.1429,-24},{-17.1429,-23.3333}},
                                     color={0,0,127}));
  connect(TIn_a1Exp.y, hA.T_1) annotation (Line(points={{-83.3,22},{-80,22},{-80,
          1.3},{-68.9,1.3}},       color={0,0,127}));
  connect(TIn_a1Exp.y, dryWetCalcs.TWatIn) annotation (Line(points={{-83.3,22},
          {-50,22},{-50,16.6667},{-17.1429,16.6667}}, color={0,0,127}));
  connect(TIn_a2Exp.y, hA.T_2) annotation (Line(points={{-83.3,-2},{-76,-2},{-76,
          -5.3},{-68.9,-5.3}},   color={0,0,127}));
  connect(TIn_a2Exp.y, dryWetCalcs.TAirIn) annotation (Line(points={{-83.3,-2},
          {-76,-2},{-76,-16.6667},{-17.1429,-16.6667}}, color={0,0,127}));
  connect(m_flow_a1Exp.y, hA.m1_flow) annotation (Line(points={{-83.3,36},{-76,36},
          {-76,5.7},{-68.9,5.7}},       color={0,0,127}));
  connect(m_flow_a1Exp.y, dryWetCalcs.masFloWat) annotation (Line(points={{-83.3,
          36},{-50,36},{-50,30},{-17.1429,30}},       color={0,0,127}));
  connect(port_a1, heaCoo.port_a) annotation (Line(
      points={{-100,60},{-20,60},{60,60}},
      color={0,127,255},
      thickness=1));
  connect(m_flow_a2Exp.y, hA.m2_flow) annotation (Line(points={{-83.3,-30},{-80,
          -30},{-80,-9.7},{-68.9,-9.7}},
                                       color={0,0,127}));
  connect(m_flow_a2Exp.y, dryWetCalcs.masFloAir) annotation (Line(points={{-83.3,
          -30},{-17.1429,-30}},                      color={0,0,127}));
  connect(port_a2, heaCooHum_u.port_a) annotation (Line(
      points={{100,-60},{20,-60},{-60,-60}},
      color={0,127,255},
      thickness=1));
    annotation (Placement(transformation(extent={{60,50},{80,70}})),
              Icon(graphics={
        Rectangle(
          extent={{-70,80},{70,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{36,80},{40,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-40,80},{-36,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-2,80},{2,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,-55},{101,-65}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,127,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-98,65},{103,55}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-70,80},{70,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{36,80},{40,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-40,80},{-36,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-2,80},{2,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,-55},{101,-65}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,127,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-98,65},{103,55}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid)}), Diagram(graphics={Text(
          extent={{44,84},{86,76}},
          lineColor={28,108,200},
          textString="Water Side",
          textStyle={TextStyle.Italic},
          horizontalAlignment=TextAlignment.Left), Text(
          extent={{-42,-80},{0,-88}},
          lineColor={28,108,200},
          textStyle={TextStyle.Italic},
          horizontalAlignment=TextAlignment.Left,
          textString="Air Side")}));
end WetEffectivenessNTU;
