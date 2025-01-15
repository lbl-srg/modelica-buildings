within Buildings.Fluid.HeatExchangers;
model WetCoilEffectivenessNTU
  "Heat exchanger with effectiveness - NTU relation and with moisture condensation"
  extends Buildings.Fluid.Interfaces.PartialFourPortInterface(
    redeclare replaceable package Medium2 = Buildings.Media.Air);
  extends Buildings.Fluid.Interfaces.FourPortFlowResistanceParameters(
    final computeFlowResistance1=true,
    final computeFlowResistance2=true);

  import con = Buildings.Fluid.Types.HeatExchangerConfiguration;
  import flo = Buildings.Fluid.Types.HeatExchangerFlowRegime;

  constant Boolean use_dynamicFlowRegime = false
    "If true, flow regime is determined using actual flow rates";
  // This switch is declared as a constant instead of a parameter
  //   as users typically need not to change this setting,
  //   and setting it true may generate events.
  //   See discussions in https://github.com/ibpsa/modelica-ibpsa/pull/1683

  parameter Buildings.Fluid.Types.HeatExchangerConfiguration configuration=
    con.CounterFlow
    "Heat exchanger configuration";
  parameter Real r_nominal=2/3
    "Ratio between air-side and water-side convective heat transfer coefficient";

  parameter Boolean use_Q_flow_nominal = false
    "Set to true to specify Q_flow_nominal and inlet conditions, or to false to specify UA_nominal"
    annotation (
      Evaluate=true,
      Dialog(group="Nominal thermal performance"));

  parameter Modelica.Units.SI.HeatFlowRate Q_flow_nominal(fixed=
        use_Q_flow_nominal)
    "Nominal heat flow rate (positive for heat transfer from 1 to 2)"
    annotation (Dialog(group="Nominal thermal performance", enable=
          use_Q_flow_nominal));
  parameter Modelica.Units.SI.Temperature T_a1_nominal(fixed=use_Q_flow_nominal)
    "Water inlet temperature at a rated condition" annotation (Dialog(group=
          "Nominal thermal performance", enable=use_Q_flow_nominal));
  parameter Modelica.Units.SI.Temperature T_a2_nominal(fixed=use_Q_flow_nominal)
    "Air inlet temperature at a rated condition" annotation (Dialog(group=
          "Nominal thermal performance", enable=use_Q_flow_nominal));
  parameter Modelica.Units.SI.MassFraction w_a2_nominal(start=0.01, fixed=
        use_Q_flow_nominal)
    "Humidity ratio of inlet air at a rated condition (in kg/kg dry air)"
    annotation (Dialog(group="Nominal thermal performance", enable=
          use_Q_flow_nominal));

  parameter Modelica.Units.SI.ThermalConductance UA_nominal(
    fixed=not use_Q_flow_nominal,
    min=0,
    start=1/(1/10 + 1/20))
    "Thermal conductance at nominal flow, used to compute heat capacity"
    annotation (Dialog(group="Nominal thermal performance", enable=not
          use_Q_flow_nominal));

  // Dynamics
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=
    Modelica.Fluid.Types.Dynamics.SteadyState
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Conservation equations"));

  Modelica.Units.SI.HeatFlowRate Q1_flow=-dryWetCalcs.QTot_flow
    "Heat input into water stream (positive if air is cooled)";
  Modelica.Units.SI.HeatFlowRate Q2_flow=dryWetCalcs.QTot_flow
    "Total heat input into air stream (negative if air is cooled)";
  Modelica.Units.SI.HeatFlowRate QSen2_flow=dryWetCalcs.QSen_flow
    "Sensible heat input into air stream (negative if air is cooled)";
  Modelica.Units.SI.HeatFlowRate QLat2_flow=Buildings.Utilities.Psychrometrics.Constants.h_fg
      *mWat_flow "Latent heat input into air (negative if air is dehumidified)";
  Real SHR(
    min=0,
    max=1,
    unit="1") = QSen2_flow /
      noEvent(if (Q2_flow > 1E-6 or Q2_flow < -1E-6) then Q2_flow else 1)
    "Sensible to total heat ratio";
  Modelica.Units.SI.MassFlowRate mWat_flow=dryWetCalcs.mCon_flow
    "Water flow rate of condensate removed from the air stream";

  Real dryFra(final unit="1", min=0, max=1) = dryWetCalcs.dryFra
    "Dry fraction, 0.3 means condensation occurs at 30% heat exchange length from air inlet";

protected
  final parameter Modelica.Units.SI.MassFraction X_w_a2_nominal=w_a2_nominal/(1
       + w_a2_nominal)
    "Water mass fraction of inlet air at a rated condition (in kg/kg total air)";

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

  Real delta=1E-2
    "Parameter for normalization";
  Real delta1=1E-1
    "Parameter for normalization";
  Real fac1 = Buildings.Utilities.Math.Functions.smoothMin(
    (1/delta * m1_flow/m1_flow_nominal)^2,1,delta1);
  Real fac2 = Buildings.Utilities.Math.Functions.smoothMin(
    (1/delta * m2_flow/m2_flow_nominal)^2,1,delta1);
  Real Qfac = fac1*fac2;

  Buildings.Fluid.HeatExchangers.BaseClasses.WetCoilUARated UAFroRated(
    final use_Q_flow_nominal=use_Q_flow_nominal,
    final QTot_flow=Q_flow_nominal,
    final UA=UA_nominal,
    final r_nominal=r_nominal,
    final TAirIn=T_a2_nominal,
    final X_wAirIn=X_w_a2_nominal,
    final TWatIn=T_a1_nominal,
    final mAir_flow=m2_flow_nominal,
    final mWat_flow=m1_flow_nominal)
    "Model that computes UA_nominal";

  Buildings.Fluid.HeatExchangers.HeaterCooler_u heaCoo(
    redeclare final package Medium = Medium1,
    final dp_nominal = dp1_nominal,
    final m_flow_nominal = m1_flow_nominal,
    final energyDynamics = energyDynamics,
    final Q_flow_nominal=-1,
    u(final unit="W"))
    "Heat exchange with water stream"
    annotation (Placement(transformation(extent={{60,50},{80,70}})));

  Buildings.Fluid.Humidifiers.Humidifier_u heaCooHum_u(
    redeclare final package Medium = Medium2,
    final mWat_flow_nominal = 1,
    final dp_nominal = dp2_nominal,
    final m_flow_nominal = m2_flow_nominal,
    final energyDynamics = energyDynamics,
    u(final unit="kg/s"))
    "Heat and moisture exchange with air stream"
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
  Buildings.Fluid.HeatExchangers.BaseClasses.WetCoilDryWetRegime dryWetCalcs(
    fullyWet(hAirOut(start=Medium2.h_default)),
    final cfg=flowRegime,
    final mWat_flow_nominal=m1_flow_nominal,
    final mAir_flow_nominal=m2_flow_nominal,
    final Qfac=Qfac)
    "Dry/wet calculations block"
    annotation (Placement(transformation(extent={{-20,-40},{60,40}})));

  Modelica.Blocks.Sources.RealExpression cp_a1Exp(
    final y=Medium1.specificHeatCapacityCp(state_a1_inflow))
    "Expression for cp of air"
    annotation (Placement(transformation(extent={{-44,18},{-30,30}})));
  Modelica.Blocks.Sources.RealExpression XWat_a2Exp(
    final y = if allowFlowReversal2
    then
      fra_a2 * state_a2_inflow.X[nWat] + fra_b2 * state_b2_inflow.X[nWat]
    else
      state_a2_inflow.X[nWat])
    "Expression for XWat"
    annotation (Placement(transformation(extent={{-44,-2},{-30,10}})));
  Modelica.Blocks.Sources.RealExpression p_a2Exp(
    final y = port_a2.p)
    "Pressure at port a2"
    annotation (Placement(transformation(extent={{-44,-10},{-30,2}})));
  Modelica.Blocks.Sources.RealExpression h_a2Exp(
    final y = if allowFlowReversal2
    then
      fra_a2 * Medium2.specificEnthalpy(state_a2_inflow)
      + fra_b2 * Medium2.specificEnthalpy(state_b2_inflow)
    else
      Medium2.specificEnthalpy(state_a2_inflow))
    "Specific enthalpy at port a2"
    annotation (Placement(transformation(extent={{-44,-18},{-30,-6}})));
  Modelica.Blocks.Sources.RealExpression cp_a2Exp(final y=
        Medium2.specificHeatCapacityCp(state_a2_inflow))
    "Specific heat capacity at port a2"
    annotation (Placement(transformation(extent={{-44,-30},{-30,-18}})));
  Modelica.Blocks.Sources.RealExpression TIn_a1Exp(
    final y = if allowFlowReversal1
    then
      fra_a1 * Medium1.temperature(state_a1_inflow)
      + fra_b1 * Medium1.temperature(state_b1_inflow)
    else
      Medium1.temperature(state_a1_inflow))
    "Temperature at port a1"
    annotation (Placement(transformation(extent={{-98,16},{-84,28}})));
  Modelica.Blocks.Sources.RealExpression TIn_a2Exp(
    final y = if allowFlowReversal2
    then
      fra_a2 * Medium2.temperature(state_a2_inflow)
      + fra_b2 * Medium2.temperature(state_b2_inflow)
    else
      Medium2.temperature(state_a2_inflow))
    "Temperature at port a2"
    annotation (Placement(transformation(extent={{-98,-8},{-84,4}})));
  Modelica.Blocks.Sources.RealExpression m_flow_a1Exp(
    final y=Buildings.Utilities.Math.Functions.regNonZeroPower(
      x=port_a1.m_flow,n=1,delta=delta*m1_flow_nominal))
    "Absolute value of mass flow rate on water side"
    annotation (Placement(transformation(extent={{-98,30},{-84,42}})));
  Modelica.Blocks.Sources.RealExpression m_flow_a2Exp(
    final y=Buildings.Utilities.Math.Functions.regNonZeroPower(
      x=port_a2.m_flow,n=1,delta=delta*m2_flow_nominal))
    "Absolute value of mass flow rate on air side"
    annotation (Placement(transformation(extent={{-98,-36},{-84,-24}})));
  final parameter Integer nWat=
    Buildings.Fluid.HeatExchangers.BaseClasses.determineWaterIndex(
      Medium2.substanceNames)
    "Index of water";
  parameter flo flowRegime_nominal(fixed=false)
    "Heat exchanger flow regime at nominal flow rates";
  flo flowRegime(fixed=false, start=flowRegime_nominal)
    "Heat exchanger flow regime";

  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow preHea
    "Prescribed heat flow"
    annotation (Placement(transformation(extent={{20,-90},{0,-70}})));
  Real fra_a1(min=0, max=1) = if allowFlowReversal1
    then Modelica.Fluid.Utilities.regStep(
      m1_flow,
      1,
      0,
      m1_flow_small)
    else 1
    "Fraction of incoming state taken from port a2
    (used to avoid excessive calls to regStep)";
  Real fra_b1(min=0, max=1) = if allowFlowReversal1
    then 1-fra_a1
    else 0
    "Fraction of incoming state taken from port b2
    (used to avoid excessive calls to regStep)";
  Real fra_a2(min=0, max=1) = if allowFlowReversal2
    then Modelica.Fluid.Utilities.regStep(
      m2_flow,
      1,
      0,
      m2_flow_small)
    else 1
    "Fraction of incoming state taken from port a2
    (used to avoid excessive calls to regStep)";
  Real fra_b2(min=0, max=1) = if allowFlowReversal2
    then 1-fra_a2
    else 0
    "Fraction of incoming state taken from port b2
    (used to avoid excessive calls to regStep)";

  Modelica.Units.SI.ThermalConductance C1_flow=abs(m1_flow)*(if
      allowFlowReversal1 then fra_a1*Medium1.specificHeatCapacityCp(
      state_a1_inflow) + fra_b1*Medium1.specificHeatCapacityCp(state_b1_inflow)
       else Medium1.specificHeatCapacityCp(state_a1_inflow))
    "Heat capacity flow rate medium 1";
  Modelica.Units.SI.ThermalConductance C2_flow=abs(m2_flow)*(if
      allowFlowReversal2 then fra_a2*Medium2.specificHeatCapacityCp(
      state_a2_inflow) + fra_b2*Medium2.specificHeatCapacityCp(state_b2_inflow)
       else Medium2.specificHeatCapacityCp(state_a2_inflow))
    "Heat capacity flow rate medium 2";
  parameter Modelica.Units.SI.SpecificHeatCapacity cp1_nominal(fixed=false)
    "Specific heat capacity of medium 1 at nominal condition";
  parameter Modelica.Units.SI.SpecificHeatCapacity cp2_nominal(fixed=false)
    "Specific heat capacity of medium 2 at nominal condition";
  parameter Modelica.Units.SI.ThermalConductance C1_flow_nominal(fixed=false)
    "Nominal capacity flow rate of Medium 1";
  parameter Modelica.Units.SI.ThermalConductance C2_flow_nominal(fixed=false)
    "Nominal capacity flow rate of Medium 2";
  final parameter Medium1.ThermodynamicState sta1_default = Medium1.setState_phX(
     h=Medium1.h_default,
     p=Medium1.p_default,
     X=Medium1.X_default[1:Medium1.nXi]) "Default state for medium 1";
  final parameter Medium2.ThermodynamicState sta2_default = Medium2.setState_phX(
     h=Medium2.h_default,
     p=Medium2.p_default,
     X=Medium2.X_default[1:Medium2.nXi]) "Default state for medium 2";

initial equation
  assert(m1_flow_nominal > Modelica.Constants.eps,
    "m1_flow_nominal must be positive, m1_flow_nominal = " + String(
    m1_flow_nominal));
  assert(m2_flow_nominal > Modelica.Constants.eps,
    "m2_flow_nominal must be positive, m2_flow_nominal = " + String(
    m2_flow_nominal));

  cp1_nominal = Medium1.specificHeatCapacityCp(sta1_default);
  cp2_nominal = Medium2.specificHeatCapacityCp(sta2_default);
  C1_flow_nominal = m1_flow_nominal*cp1_nominal;
  C2_flow_nominal = m2_flow_nominal*cp2_nominal;
  if (configuration == con.CrossFlowStream1MixedStream2Unmixed) then
    flowRegime_nominal = if (C1_flow_nominal < C2_flow_nominal)
      then
        flo.CrossFlowCMinMixedCMaxUnmixed
      else
        flo.CrossFlowCMinUnmixedCMaxMixed;
  elseif (configuration == con.CrossFlowStream1UnmixedStream2Mixed) then
    flowRegime_nominal = if (C1_flow_nominal < C2_flow_nominal)
      then
        flo.CrossFlowCMinUnmixedCMaxMixed
      else
        flo.CrossFlowCMinMixedCMaxUnmixed;
  elseif (configuration == con.ParallelFlow) then
    flowRegime_nominal = flo.ParallelFlow;
  elseif (configuration == con.CounterFlow) then
    flowRegime_nominal = flo.CounterFlow;
  elseif (configuration == con.CrossFlowUnmixed) then
    flowRegime_nominal = flo.CrossFlowUnmixed;
  else
    // Invalid flow regime. Assign a value to flowRegime_nominal, and stop with an assert
    flowRegime_nominal = flo.CrossFlowUnmixed;
    assert(configuration >= con.ParallelFlow and
      configuration <= con.CrossFlowStream1UnmixedStream2Mixed,
      "Invalid heat exchanger configuration.");
  end if;

equation
  // Assign the flow regime for the given heat exchanger configuration and
  // mass flow rates
  if use_dynamicFlowRegime then
    if (configuration == con.ParallelFlow) then
      flowRegime = if (C1_flow*C2_flow >= 0)
        then
          flo.ParallelFlow
        else
          flo.CounterFlow;
    elseif (configuration == con.CounterFlow) then
      flowRegime = if (C1_flow*C2_flow >= 0)
        then
          flo.CounterFlow
        else
          flo.ParallelFlow;
    elseif (configuration == con.CrossFlowUnmixed) then
      flowRegime = flo.CrossFlowUnmixed;
    elseif (configuration == con.CrossFlowStream1MixedStream2Unmixed) then
      flowRegime = if (C1_flow < C2_flow)
        then
          flo.CrossFlowCMinMixedCMaxUnmixed
        else
          flo.CrossFlowCMinUnmixedCMaxMixed;
    else
      // have ( configuration == con.CrossFlowStream1UnmixedStream2Mixed)
      flowRegime = if (C1_flow < C2_flow)
        then
          flo.CrossFlowCMinUnmixedCMaxMixed
        else
          flo.CrossFlowCMinMixedCMaxUnmixed;
    end if;
  else
    flowRegime = flowRegime_nominal;
    assert(noEvent(m1_flow > -0.1 * m1_flow_nominal)
       and noEvent(m2_flow > -0.1 * m2_flow_nominal),
"*** Warning in " + getInstanceName() +
      ": The flow direction reversed.
      However, because the constant use_dynamicFlowRegime is set to false,
      the model does not change equations based on the actual flow regime.
      To switch equations based on the actual flow regime during the simulation,
      set the constant use_dynamicFlowRegime=true.
      Note that this can lead to slow simulation because of events.",
      level = AssertionLevel.warning);
  end if;

  connect(heaCoo.port_b, port_b1) annotation (Line(points={{80,60},{80,60},{100,60}},color={0,127,255},
      thickness=1));
  connect(heaCooHum_u.port_b, port_b2) annotation (Line(
      points={{-80,-60},{-90,-60},{-100,-60}},
      color={0,127,255},
      thickness=1));
  connect(hA.hA_1, dryWetCalcs.UAWat) annotation (Line(points={{-49.1,5.7},{-46,
          5.7},{-46,36.6667},{-22.8571,36.6667}},  color={0,0,127}));
  connect(hA.hA_2, dryWetCalcs.UAAir) annotation (Line(points={{-49.1,-9.7},{
          -46,-9.7},{-46,-36},{-46,-36.6667},{-22.8571,-36.6667}},
                                                     color={0,0,127}));
  connect(cp_a1Exp.y, dryWetCalcs.cpWat) annotation (Line(points={{-29.3,24},{
          -22.8571,24},{-22.8571,23.3333}},
                                   color={0,0,127}));
  connect(XWat_a2Exp.y, dryWetCalcs.X_wAirIn) annotation (Line(points={{-29.3,4},
          {-22.8571,4},{-22.8571,3.33333}},  color={0,0,127}));
  connect(p_a2Exp.y, dryWetCalcs.pAir) annotation (Line(points={{-29.3,-4},{
          -22.8571,-4},{-22.8571,-3.33333}},
                                  color={0,0,127}));
  connect(h_a2Exp.y, dryWetCalcs.hAirIn) annotation (Line(points={{-29.3,-12},{
          -22,-12},{-22,-10},{-22.8571,-10}},
                                    color={0,0,127}));
  connect(cp_a2Exp.y, dryWetCalcs.cpAir) annotation (Line(points={{-29.3,-24},{
          -22.8571,-24},{-22.8571,-23.3333}},
                                     color={0,0,127}));
  connect(TIn_a1Exp.y, hA.T_1) annotation (Line(points={{-83.3,22},{-80,22},{-80,
          1.3},{-68.9,1.3}},       color={0,0,127}));
  connect(TIn_a1Exp.y, dryWetCalcs.TWatIn) annotation (Line(points={{-83.3,22},
          {-50,22},{-50,16.6667},{-22.8571,16.6667}}, color={0,0,127}));
  connect(TIn_a2Exp.y, hA.T_2) annotation (Line(points={{-83.3,-2},{-76,-2},{-76,
          -5.3},{-68.9,-5.3}},   color={0,0,127}));
  connect(TIn_a2Exp.y, dryWetCalcs.TAirIn) annotation (Line(points={{-83.3,-2},
          {-76,-2},{-76,-16.6667},{-22.8571,-16.6667}}, color={0,0,127}));
  connect(m_flow_a1Exp.y, hA.m1_flow) annotation (Line(points={{-83.3,36},{-76,36},
          {-76,5.7},{-68.9,5.7}},       color={0,0,127}));
  connect(m_flow_a1Exp.y, dryWetCalcs.mWat_flow) annotation (Line(points={{-83.3,
          36},{-50,36},{-50,30},{-22.8571,30}},       color={0,0,127}));
  connect(port_a1, heaCoo.port_a) annotation (Line(
      points={{-100,60},{-20,60},{60,60}},
      color={0,127,255},
      thickness=1));
  connect(m_flow_a2Exp.y, hA.m2_flow) annotation (Line(points={{-83.3,-30},{-80,
          -30},{-80,-9.7},{-68.9,-9.7}},
                                       color={0,0,127}));
  connect(m_flow_a2Exp.y, dryWetCalcs.mAir_flow) annotation (Line(points={{-83.3,
          -30},{-22.8571,-30}},                      color={0,0,127}));
  connect(port_a2, heaCooHum_u.port_a) annotation (Line(
      points={{100,-60},{20,-60},{-60,-60}},
      color={0,127,255},
      thickness=1));
  connect(preHea.port, heaCooHum_u.heatPort) annotation (Line(points={{0,-80},{-40,
          -80},{-40,-66},{-60,-66}}, color={191,0,0}));
  connect(dryWetCalcs.QTot_flow, heaCoo.u) annotation (Line(points={{62.8571,
          -6.66667},{80,-6.66667},{80,44},{40,44},{40,66},{58,66}},
                                                          color={0,0,127}));
  connect(dryWetCalcs.mCon_flow, heaCooHum_u.u) annotation (Line(points={{62.8571,
          -33.3333},{70,-33.3333},{70,-54},{-59,-54}}, color={0,0,127}));
  connect(preHea.Q_flow, dryWetCalcs.QTot_flow) annotation (Line(points={{20,-80},
          {44,-80},{80,-80},{80,-6.66667},{62.8571,-6.66667}},
                                                           color={0,0,127}));
  annotation (
    defaultComponentName="hexWetNtu",
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
        Polygon(
          points={{46,-62},{44,-72},{50,-76},{58,-72},{56,-62},{50,-50},{46,-62}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          smooth=Smooth.Bezier),
        Polygon(
          points={{24,-52},{22,-62},{28,-66},{36,-62},{34,-52},{28,-40},{24,-52}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          smooth=Smooth.Bezier),
        Polygon(
          points={{0,-48},{-2,-58},{4,-62},{12,-58},{10,-48},{4,-36},{0,-48}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          smooth=Smooth.Bezier),
        Polygon(
          points={{-18,-64},{-20,-74},{-14,-78},{-6,-74},{-8,-64},{-14,-52},{
              -18,-64}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          smooth=Smooth.Bezier),
        Polygon(
          points={{-40,-50},{-42,-60},{-36,-64},{-28,-60},{-30,-50},{-36,-38},{
              -40,-50}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          smooth=Smooth.Bezier),
        Polygon(
          points={{-58,-62},{-60,-72},{-54,-76},{-46,-72},{-48,-62},{-54,-50},{
              -58,-62}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          smooth=Smooth.Bezier)}),
        Diagram(graphics={Text(
          extent={{44,84},{86,76}},
          textColor={28,108,200},
          textString="Water Side",
          textStyle={TextStyle.Italic},
          horizontalAlignment=TextAlignment.Left),
        Text(
          extent={{-42,-80},{0,-88}},
          textColor={28,108,200},
          textStyle={TextStyle.Italic},
          horizontalAlignment=TextAlignment.Left,
          textString="Air Side")}),
    Documentation(info="<html>
<p>
This model describes a cooling coil applicable for fully-dry,
partially-wet, and fully-wet regimes.
The model is developed for counter flow heat exchangers but is also applicable
for the cross-flow configuration, although in the latter case it is recommended
to have more than four tube rows (Elmahdy and Mitalas, 1977 and Braun, 1988).
The model can also be used for a heat exchanger which acts as both heating coil
(for some period of time) and cooling coil (for the others).
However, it is not recommended to use this model for heating coil only or for
cooling coil with no water condensation because for these situations,
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DryCoilEffectivenessNTU\">
Buildings.Fluid.HeatExchangers.DryCoilEffectivenessNTU</a>
computes faster.
</p>
<h4>Main equations</h4>
<p>
The coil model consists of two-equation sets, one for the fully-dry mode and
the other for the fully-wet mode. For the fully-dry mode, the <i>&epsilon;-NTU</i>
approach (Elmahdy and Mitalas, 1977) is used.
For the fully-wet mode, equations from Braun (1988) and Mitchell and Braun (2012a and b),
which are essentially the extension of the <i>&epsilon;-NTU</i> approach to simultaneous sensible
and latent heat transfer, are utilized.
The equation sets are switched depending on the switching criteria described below
that determines the right mode based on a coil surface temperature and dew-point
temperature for the air at the inlet of the coil.
The transition regime between the two modes, which represents the partially-wet and
partially-dry coil, is approximated by employing a fuzzy modeling approach,
so-called Takagi-Sugeno fuzzy modeling (Takagi and Sugeno, 1985), which provides a
continuously differentiable model that can cover all fully-dry, partially-wet,
and fully-wet regimes.
</p>
<p>The switching rules are:</p>
<ul>
<li>R1: If the coil surface temperature at the air inlet is lower than the
dew-point temperature of air at inlet, then the cooling coil surface is fully-wet.
</li>
<li>
R2: If the coil surface temperature at the air outlet is higher than the
dew-point temperature of air at inlet, then the cooling coil surface is fully-dry.
</li>
<li>
R3: If any of the conditions in R1 or R2 is not satisfied, then the cooling coil
surface is partially wet.
</li>
</ul>
<p>
For more detailed descriptions of the fully-wet coil model and the fuzzy modeling approach,
see
<a href=\"modelica://Buildings.Fluid.HeatExchangers.BaseClasses.WetCoilWetRegime\">
Buildings.Fluid.HeatExchangers.BaseClasses.WetCoilWetRegime</a>.
and
<a href=\"modelica://Buildings.Fluid.HeatExchangers.BaseClasses.WetCoilDryWetRegime\">
Buildings.Fluid.HeatExchangers.BaseClasses.WetCoilDryWetRegime</a>.
</p>
<h4>Assumptions and limitations</h4>
<p>This model contains the following assumptions and limitations:</p>
<p>Medium 2 must be air due to the use of various psychrometric functions.</p>
<p>
When parameterizing this model with rated conditions (with the parameter
<code>use_UA_nominal</code> set to <code>false</code>), those should
correspond to a fully-dry or a fully-wet coil regime, because
the model uncertainty yielded by partially-wet rated conditions
has not been assessed yet.
</p>
<p>The model uses steady-state physics. That is, no dynamics associated
with water and coil materials are considered.</p>
<p>The Lewis number, which relates the mass transfer coefficient to the heat transfer
coefficient, is assumed to be <i>1</i>.</p>
<p>The model is not suitable for a cross-flow heat exchanger of which the number
of passes is less than four.</p>
<p>
By default, the flow regime, such as counter flow or parallel flow,
is kept constant based on the parameter value <code>configuration</code>.
If a flow reverses direction, it is not changed, e.g.,
a heat exchanger does not change from counter flow to parallel flow
if one flow changes direction.
To dynamically change the flow regime,
set the constant <code>use_dynamicFlowRegime</code> to
<code>true</code>.
However, <code>use_dynamicFlowRegime=true</code>
can cause slower simulation due to events.
</p>
<h4>Validation</h4>
<p>Validation results can be found in
<a href=\"modelica://Buildings.Fluid.HeatExchangers.Validation.WetCoilEffectivenessNTU\">
Buildings.Fluid.HeatExchangers.Validation.WetCoilEffectivenessNTU</a>.
<h4>References</h4>
<p>Braun, James E. 1988.
&quot;Methodologies for the Design and Control of
Central Cooling Plants&quot;.
PhD Thesis. University of Wisconsin - Madison.
Available
<a href=\"https://minds.wisconsin.edu/handle/1793/46694\">
online</a>.
</p>
<p>Mitchell, John W., and James E. Braun. 2012a.
Principles of heating, ventilation, and air conditioning in buildings.
Hoboken, N.J.: Wiley.</p>
<p>Mitchell, John W., and James E. Braun. 2012b.
&quot;Supplementary Material Chapter 2: Heat Exchangers for Cooling Applications&quot;.
Excerpt from Principles of heating, ventilation, and air conditioning in buildings.
Hoboken, N.J.: Wiley.
Available
<a href=\"http://bcs.wiley.com/he-bcs/Books?action=index&amp;itemId=0470624574&amp;bcsId=7185\">
online</a>.
</p>
<p>Elmahdy, A.H. and Mitalas, G.P. 1977.
&quot;A Simple Model for Cooling and Dehumidifying Coils for Use
In Calculating Energy Requirements for Buildings&quot;.
ASHRAE Transactions. Vol.83. Part 2. pp. 103-117.</p>
<p>Takagi, T. and Sugeno, M., 1985.
Fuzzy identification of systems and its applications to modeling and control.
&nbsp;IEEE transactions on systems, man, and cybernetics, (1), pp.116-132.</p>
</html>",                    revisions="<html>
<ul>
<li>
February 3, 2023, by Jianjun Hu:<br/>
Added <code>noEvent()</code> in the assertion function to avoid Optimica to not converge.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1690\">issue 1690</a>.
</li>
<li>
January 24, 2023, by Hongxiang Fu:<br/>
Set <code>flowRegime</code> to be equal to <code>flowRegime_nominal</code>
by default. Added an assertion warning to inform the user about how to change
this behaviour if the flow direction does need to change.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1682\">issue 1682</a>.
</li>
<li>
March 3, 2022, by Michael Wetter:<br/>
Removed <code>massDynamics</code>.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1542\">issue 1542</a>.
</li>
<li>
November 2, 2021, by Michael Wetter:<br/>
Corrected unit assignment during the model instantiation.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2710\">issue 2710</a>.
</li>
<li>
Jan 21, 2021, by Donghun Kim:<br/>
First implementation.
</li>
</ul>
</html>"));
end WetCoilEffectivenessNTU;
