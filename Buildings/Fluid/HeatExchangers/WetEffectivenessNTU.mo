within Buildings.Fluid.HeatExchangers;
model WetEffectivenessNTU
  "Heat exchanger with effectiveness - NTU relation including moisture condensation"
  extends Buildings.Fluid.Interfaces.PartialFourPortInterface(
    redeclare replaceable package Medium2 = Buildings.Media.Air);
  extends Buildings.Fluid.Interfaces.FourPortFlowResistanceParameters(
    final computeFlowResistance1=true,
    final computeFlowResistance2=true);

  import con = Buildings.Fluid.Types.HeatExchangerConfiguration;
  import flo = Buildings.Fluid.Types.HeatExchangerFlowRegime;

  parameter Modelica.SIunits.ThermalConductance UA_nominal(min=0)
    "Thermal conductance at nominal flow, used to compute heat capacity"
    annotation(Dialog(tab="General", group="Nominal condition"));
  parameter Real r_nominal=2/3
    "Ratio between air-side and water-side convective heat transfer coefficient"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Temperature TWatOut_init=
    Modelica.SIunits.Conversions.from_degF(42)
    "Guess value for the water outlet temperature which is an iteration variable"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Temperature T_a1_nominal
    "Nominal temperature at water-side, port a1"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Temperature T_a2_nominal
    "Nominal temperature at water-side, port a2"
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
  parameter Buildings.Fluid.Types.HeatExchangerConfiguration configuration=
    con.CounterFlow
    "Heat exchanger configuration";
  // Dynamics
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=
    Modelica.Fluid.Types.Dynamics.SteadyState
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));
  parameter Modelica.Fluid.Types.Dynamics massDynamics=energyDynamics
    "Type of mass balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));

  Modelica.SIunits.HeatFlowRate Q1_flow = -dryWetCalcs.QTot_flow
    "Heat input into water stream (positive if air is cooled)";
  Modelica.SIunits.HeatFlowRate Q2_flow = dryWetCalcs.QTot_flow
    "Total heat input into air stream (negative if air is cooled)";
  Modelica.SIunits.HeatFlowRate QSen2_flow = dryWetCalcs.QSen_flow
    "Sensible heat input into air stream (negative if air is cooled)";
  Modelica.SIunits.HeatFlowRate QLat2_flow=
    Buildings.Utilities.Psychrometrics.Constants.h_fg * mWat_flow
    "Latent heat input into air (negative if air is dehumidified)";
  Real SHR(
    min=0,
    max=1,
    unit="1") = QSen2_flow /
      noEvent(if (Q2_flow > 1E-6 or Q2_flow < -1E-6) then Q2_flow else 1)
    "Sensible to total heat ratio";
  Modelica.SIunits.MassFlowRate mWat_flow = dryWetCalcs.mCon_flow
    "Water flow rate of condensate removed from the air stream";

protected
  Buildings.Fluid.HeatExchangers.HeaterCooler_u heaCoo(
    redeclare package Medium = Medium1,
    dp_nominal = dp1_nominal,
    m_flow_nominal = m1_flow_nominal,
    energyDynamics = energyDynamics,
    massDynamics = massDynamics,
    Q_flow_nominal=-1)
    "Heat exchange with water stream"
    annotation (Placement(transformation(extent={{60,50},{80,70}})));
  MassExchangers.Humidifier_u heaCooHum_u(
    redeclare package Medium = Medium2,
    mWat_flow_nominal = 1,
    dp_nominal = dp2_nominal,
    m_flow_nominal = m2_flow_nominal,
    energyDynamics = energyDynamics,
    massDynamics = massDynamics)
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
  Buildings.Fluid.HeatExchangers.BaseClasses.DryWetCalcs dryWetCalcs(
    redeclare final package Medium1 = Medium1,
    redeclare final package Medium2 = Medium2,
    final TWatOut_init = TWatOut_init,
    final cfg = flowRegime)
    "Dry/wet calculations block"
    annotation (Placement(transformation(extent={{-20,-40},{60,40}})));
  Modelica.Blocks.Sources.RealExpression cp_a1Exp(
    final y = if allowFlowReversal1
    then
      fra_a1 * Medium1.specificHeatCapacityCp(state_a1_inflow)
      + fra_b1 * Medium1.specificHeatCapacityCp(state_b1_inflow)
    else
      Medium1.specificHeatCapacityCp(state_a1_inflow))
    "Expression for cp of air"
    annotation (Placement(transformation(extent={{-40,18},{-26,30}})));
  Modelica.Blocks.Sources.RealExpression XWat_a2Exp(
    final y = if allowFlowReversal2
    then
      fra_a2 * state_a2_inflow.X[nWat] + fra_b2 * state_b2_inflow.X[nWat]
    else
      state_a2_inflow.X[nWat])
    "Expression for XWat"
    annotation (Placement(transformation(extent={{-40,-2},{-26,10}})));
  Modelica.Blocks.Sources.RealExpression p_a2Exp(
    final y = port_a2.p)
    "Pressure at port a2"
    annotation (Placement(transformation(extent={{-40,-10},{-26,2}})));
  Modelica.Blocks.Sources.RealExpression h_a2Exp(
    final y = if allowFlowReversal2
    then
      fra_a2 * Medium2.specificEnthalpy(state_a2_inflow)
      + fra_b2 * Medium2.specificEnthalpy(state_b2_inflow)
    else
      Medium2.specificEnthalpy(state_a2_inflow))
    "Specific enthalpy at port a2"
    annotation (Placement(transformation(extent={{-40,-18},{-26,-6}})));
  Modelica.Blocks.Sources.RealExpression cp_a2Exp(
    final y = if allowFlowReversal2
    then
      fra_a2 * Medium2.specificHeatCapacityCp(state_a2_inflow)
      + fra_b2 * Medium2.specificHeatCapacityCp(state_b2_inflow)
    else
      Medium2.specificHeatCapacityCp(state_a2_inflow))
    "Specific heat capacity at port a2"
    annotation (Placement(transformation(extent={{-40,-30},{-26,-18}})));
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
    final y = abs(port_a1.m_flow))
    "Absolute value of mass flow rate on water side"
    annotation (Placement(transformation(extent={{-98,30},{-84,42}})));
  Modelica.Blocks.Sources.RealExpression m_flow_a2Exp(
    final y = abs(port_a2.m_flow))
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

  Buildings.HeatTransfer.Sources.PrescribedHeatFlow preHea
    "Prescribed heat flow"
    annotation (Placement(transformation(extent={{20,-90},{0,-70}})));
  Real fra_a1(min=0, max=1)
    "Fraction of incoming state taken from port a2
    (used to avoid excessive calls to regStep)";
  Real fra_b1(min=0, max=1)
    "Fraction of incoming state taken from port b2
    (used to avoid excessive calls to regStep)";
  Real fra_a2(min=0, max=1)
    "Fraction of incoming state taken from port a2
    (used to avoid excessive calls to regStep)";
  Real fra_b2(min=0, max=1)
    "Fraction of incoming state taken from port b2
    (used to avoid excessive calls to regStep)";

  Modelica.SIunits.ThermalConductance C1_flow
    "Heat capacity flow rate medium 1";
  Modelica.SIunits.ThermalConductance C2_flow
    "Heat capacity flow rate medium 2";
  parameter Modelica.SIunits.SpecificHeatCapacity cp1_nominal(fixed=false)
    "Specific heat capacity of medium 1 at nominal condition";
  parameter Modelica.SIunits.SpecificHeatCapacity cp2_nominal(fixed=false)
    "Specific heat capacity of medium 2 at nominal condition";
  parameter Modelica.SIunits.ThermalConductance C1_flow_nominal(fixed=false)
    "Nominal capacity flow rate of Medium 1";
  parameter Modelica.SIunits.ThermalConductance C2_flow_nominal(fixed=false)
    "Nominal capacity flow rate of Medium 2";
  final parameter Medium1.ThermodynamicState sta1_default = Medium1.setState_pTX(
     T=T_a1_nominal,
     p=Medium1.p_default,
     X=Medium1.X_default[1:Medium1.nXi]) "Default state for medium 1";
  final parameter Medium2.ThermodynamicState sta2_default = Medium2.setState_pTX(
     T=T_a2_nominal,
     p=Medium2.p_default,
     X=Medium2.X_default[1:Medium2.nXi]) "Default state for medium 2";

initial equation
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
  if allowFlowReversal1 then
    fra_a1 = Modelica.Fluid.Utilities.regStep(
      m1_flow,
      1,
      0,
      m1_flow_small);
    fra_b1 = 1-fra_a1;
  else
    fra_a1 = 1;
    fra_b1 = 0;
  end if;
  if allowFlowReversal2 then
    fra_a2 = Modelica.Fluid.Utilities.regStep(
      m2_flow,
      1,
      0,
      m2_flow_small);
    fra_b2 = 1-fra_a2;
  else
    fra_a2 = 1;
    fra_b2 = 0;
  end if;
  // Assign the flow regime for the given heat exchanger configuration and
  // mass flow rates
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
  C1_flow = abs(m1_flow)*
    ( if allowFlowReversal1 then
           fra_a1 * Medium1.specificHeatCapacityCp(state_a1_inflow) +
           fra_b1 * Medium1.specificHeatCapacityCp(state_b1_inflow) else
        Medium1.specificHeatCapacityCp(state_a1_inflow));
  C2_flow = abs(m2_flow)*
    ( if allowFlowReversal2 then
           fra_a2 * Medium2.specificHeatCapacityCp(state_a2_inflow) +
           fra_b2 * Medium2.specificHeatCapacityCp(state_b2_inflow) else
        Medium2.specificHeatCapacityCp(state_a2_inflow));

  connect(heaCoo.port_b, port_b1) annotation (Line(points={{80,60},{80,60},{100,60}},color={0,127,255},
      thickness=1));
  connect(heaCooHum_u.port_b, port_b2) annotation (Line(
      points={{-80,-60},{-90,-60},{-100,-60}},
      color={0,127,255},
      thickness=1));
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
  connect(m_flow_a1Exp.y, dryWetCalcs.mWat_flow) annotation (Line(points={{-83.3,
          36},{-50,36},{-50,30},{-17.1429,30}},       color={0,0,127}));
  connect(port_a1, heaCoo.port_a) annotation (Line(
      points={{-100,60},{-20,60},{60,60}},
      color={0,127,255},
      thickness=1));
  connect(m_flow_a2Exp.y, hA.m2_flow) annotation (Line(points={{-83.3,-30},{-80,
          -30},{-80,-9.7},{-68.9,-9.7}},
                                       color={0,0,127}));
  connect(m_flow_a2Exp.y, dryWetCalcs.mAir_flow) annotation (Line(points={{-83.3,
          -30},{-17.1429,-30}},                      color={0,0,127}));
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
          -33.3333},{70,-33.3333},{70,-54},{-58,-54}}, color={0,0,127}));
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
          fillPattern=FillPattern.Solid)}),
        Diagram(graphics={Text(
          extent={{44,84},{86,76}},
          lineColor={28,108,200},
          textString="Water Side",
          textStyle={TextStyle.Italic},
          horizontalAlignment=TextAlignment.Left),
        Text(
          extent={{-42,-80},{0,-88}},
          lineColor={28,108,200},
          textStyle={TextStyle.Italic},
          horizontalAlignment=TextAlignment.Left,
          textString="Air Side")}),
    Documentation(info="<html>
<p>
This model represents a cooling and/or heating coil that is capable of
simulating the partially wet or fully wet regime in addition to 100% dry
conditions.  The coil is  based primarily on the work of Braun (1988), Mitchell
and Braun (2012a and b) which is essentially an effectiveness-NTU approach of
the work of Elmahdy and Mitalas (1977).
</p>

<p>
The wet coil model is fundamentally a heat exchanger across two different
fluids: medium 1 and medium 2. However, in this discussion, we will assume that
medium 1 is \"water\" and medium 2 is \"air\". Due to the use of psychrometric
functions, medium 2 must be a \"air\" with water vapor.
</p>

<p>
The model itself represents steady-state physics: for a given set of inlet
conditions, the outlet conditions and heat transfer are immediately determined.
The heat transfer, and potential dehumidification for the air side, are
applied to the two streams.
</p>

<h4>Main equations</h4>

<p>
The model operates in three different regimes:
</p>

<ul>
<li>100% dry coil equations</li>
<li>100% wet coil equations</li>
<li>partially wet / partially dry equations</li>
</ul>

<p>
Below we will discuss the three regimes as well as how to determine which
regime we are operating in.
</p>

<h5>Determination of regime</h5>

<p>
The inlet air dry bulb temperature, inlet water temperature, and inlet air dew
point temperature are used to determine which regime the model is in.
Specifically, if the coil is in heating mode, then we assume no condensation
will take place. We define being in heating mode by checking the inlet
conditions of the two fluids to the coil:
</p>

<p align=\"center\" style=\"font-style:italic;\">
heating = T<sub>Wat,In</sub> &ge; T<sub>Air,In</sub>
</p>

<p>
Otherwise, if we are not in heating mode, we need to check how the inlet air
dew point temperature compares with two \"boundary temperatures\" which separate
the 100% dry, partially wet, and 100% wet regimes. The determination of these
boundary dew point temperatures is based on the 1-dimensional heat balance
between the two fluids. We assume that the heat transfer coefficient and
relevant area of heat transfer from the bulk water stream temperature to the
surface temperature of the air-side of the coil is known and equal to
<i>UA<sub>Wat</sub></i>. We also assume that the heat transfer coefficient from
the bulk air stream temperature to the coil surface is known as
<i>UA<sub>Air</sub></i>.
</p>

<p>
Balancing these two conditions, we can see that:
</p>

<p align=\"center\" style=\"font-style:italic;\">
Q<sub>Air&rarr;Water,X</sub> = UA<sub>Air</sub> &middot; (T<sub>Air,X</sub> -
  T<sub>Surf,X</sub>)
</p>

<p>
and
</p>

<p align=\"center\" style=\"font-style:italic;\">
Q<sub>Air&rarr;Water,X</sub> = UA<sub>Water</sub> &middot;
  (T<sub>Surface,X</sub> - T<sub>Water,X</sub>)
</p>

<p>
We can equate these two heat transfers and make the following observations:
</p>

<ul>
<li>The coil surface temperature will be at the dew point when condensation
  begins</li>
<li>and, when cooling, the coil will first begin to condense at its coldest
  point: the air stream outlet.</li>
</ul>

<p>
Updating the equations above under these assumptions yields the following
relationship for the case where condensation just begins to occur on an
otherwise dry coil:
</p>

<p align=\"center\" style=\"font-style:italic;\">
(T<sub>Air Out</sub> - T<sub>Dew Point, A</sub>) &middot; UA<sub>Air</sub> =
  (T<sub>Dew Point A</sub> - T<sub>Water In</sub>) &middot; UA<sub>Water</sub>
</p>

<p>
In the equation above, <i>T<sub>Dew Point, A</sub></i>, is the boundary to the dry
region of the coil. If the inlet air dew point is less than or equal to
<i>T<sub>Dew Point, A</sub></i>, we know we have a 100% dry coil.
</p>

<p>
Similarly, we can observe that a 100% wet coil will reach total coverage when
the surface temperature at the air inlet is equal to the inlet air dew
point temperature:
</p>

<p align=\"center\" style=\"font-style:italic;\">
(T<sub>Air Out</sub> - T<sub>Dew Point, B</sub>) &middot; UA<sub>Air</sub> =
  (T<sub>Dew Point B</sub> - T<sub>Water In</sub>) &middot; UA<sub>Water</sub>
</p>

<p>
The equations in this section have been written for a \"counter-flow\"
configuration in which the water stream's outlet is in thermal contact (via the
coil structure) with the air stream's inlet.
</p>

<p>
To summarize, expressing the regions as <i>I</i> for 100% dry, <i>II</i> for
partially wet, and <i>III</i> for 100% wet, we can say the following:
</p>

<p align=\"center\" style=\"font-style:italic;\">
region = if (T<sub>Water In</sub> &ge; T<sub>Air In</sub> or T<sub>Dry Bulb In</sub> &le; T<sub>Dry Bulb, A</sub>)
         then I
         elseif (T<sub>Dry Bulb, B</sub> &le; T<sub>Dry Bulb In</sub>)
         then III
         else II
</p>

<p>
If we determine we're in region <i>I</i>, we only need to use the 100% dry
equations. If we determine we're in region <i>III</i>, we need only use the
100% wet equations. If we're in region two, however, we must iterate to
determine <i>f<sub>dry</sub></i>, or <i>dry fraction</i>, of the coil &mdash;
this involves iterating over both the wet and dry relations.
</p>

<h5>The 100% dry regime</h5>

<p>
The 100% dry regime is a traditional <i>effectiveness</i>-NTU methodology.
</p>

<p>
First, the capacitance rates for the water and air side are determined:
</p>

<p align=\"center\" style=\"font-style:italic;\">
C<sub>Water</sub> = massFlow<sub>Water</sub> &middot; cp<sub>Water</sub>
</p>

<p align=\"center\" style=\"font-style:italic;\">
C<sub>Air</sub> = massFlow<sub>Air</sub> &middot; cp<sub>Air</sub>
</p>

<p align=\"center\" style=\"font-style:italic;\">
C<sub>Min</sub> = min(C<sub>Air</sub>, C<sub>Water</sub>)
</p>

<p align=\"center\" style=\"font-style:italic;\">
C<sub>Max</sub> = max(C<sub>Air</sub>, C<sub>Water</sub>)
</p>

<p>
Using the above, the capacity rate ratio, <i>C<sup>*</sup></i> can be
determined:
</p>

<p align=\"center\" style=\"font-style:italic;\">
C<sup>*</sup> = C<sub>Min</sub> / C<sub>Max</sub>
</p>

<p>
The overall heat transfer coefficient times area for the coil can be
determined as:
</p>

<p align=\"center\" style=\"font-style:italic;\">
UA = 1 / ((1 / UA<sub>Air</sub>) + (1 / UA<sub>Water</sub>))
</p>

Next, we can determine the number of transfer units:

<p align=\"center\" style=\"font-style:italic;\">
Ntu = UA / CMin
</p>

<p>
The effectiveness is determined using the function
<a href=\"modelica://Buildings.Fluid.HeatExchangers.BaseClasses.epsilon_ntuZ\">
effCalc</a> which calculates effectiveness
given the capacity rate ratio, <i>C<sup>*</sup></i>,
<i>NTU</i>, and the configuration of the cooling coil (e.g.,
cross-flow, counter-flow, etc.). Available configurations are
listed as part of the <a
href=\"modelica://Buildings.Fluid.Types.HeatExchangerConfiguration\">
HeatExchangerConfiguration</a> type; however, be advised
that the current model is only set up for the \"counter-flow\"
types: <code>CounterFlow</code> and <code>CrossFlow*</code>.
In particular, <code>ParallelFlow</code> should not be used.
</p>

<p align=\"center\" style=\"font-style:italic;\">
eff = effCalc(C<sup>*</sup>, Ntu, Configuration)
</p>

<p>
The overall heat transfered from the air to the water is then:
</p>

<p align=\"center\" style=\"font-style:italic;\">
Q<sub>Total, Dry</sub> = eff &middot; C<sub>Min</sub> &middot;
  (T<sub>Water In</sub> - T<sub>Air In</sub>)
</p>

<p>
From this, we can determine the outlet conditions:
</p>

<p align=\"center\" style=\"font-style:italic;\">
T<sub>Air Out</sub> = T<sub>Air In</sub> - eff &middot;
  (T<sub>Air In</sub> - T<sub>Wat In</sub>)
</p>

<p align=\"center\" style=\"font-style:italic;\">
T<sub>Water Out</sub> = T<sub>Water In</sub>
  + C<sup>*</sup> &middot; (T<sub>Air In</sub> - T<sub>Air Out</sub>)
</p>

<p>
We can also calculate the coil surface's air outlet temperature which is useful
for determining <i>f<sub>dry</sub></i> in the partially wet region.
</p>

<p align=\"center\" style=\"font-style:italic;\">
T<sub>Surface Out</sub> = T<sub>Water In</sub>
  + ((C<sup>*</sup> &middot; Ntu<sub>Dry</sub>
    &middot; (T<sub>Air Out</sub> - T<sub>Water In</sub>))
      / Ntu<sub>Water</sub>)
</p>

<p>
where in the above:
</p>

<p align=\"center\" style=\"font-style:italic;\">
Ntu<sub>Air</sub> =
  UA<sub>Air</sub> / (massFlow<sub>Air</sub> &middot; cp<sub>Air</sub>)
</p>

<p align=\"center\" style=\"font-style:italic;\">
Ntu<sub>Water</sub> =
  UA<sub>Water</sub> / (massFlow<sub>Water</sub> &middot; cp<sub>Water</sub>)
</p>

<p>
and
</p>

<p align=\"center\" style=\"font-style:italic;\">
Ntu<sub>Dry</sub> =
  Ntu<sub>Air</sub> / (1 + C<sup>*</sup> &middot; (Ntu<sub>Air</sub> / Ntu<sub>Water</sub>))
</p>

<h5>The 100% wet regime</h5>

<p>
The 100% wet regime is based on an analogy to the <i>effectiveness</i>-NTU
method as discussed in section 13.6 \"Cooling Coil Performance Using a Heat
Transfer Analogy\" of Mitchell and Braun (2012a). The \"heat transfer analogy\"
is an acknowledgement of the similarities between the case for a wet coil
and the case for a dry coil and allows us to reuse the effectiveness-NTU
approach.
</p>

<p>
In this analysis, the water stream is replaced by an equivalent air stream that
is saturated at the temperatures of the water stream &mdash; this allows us to
combine enthalpy differences directly. Further discussion of the analogy itself
is given in the above mentioned reference. We start by determining the equivalent
air stream at the saturated coil surface:
</p>

<p align=\"center\" style=\"font-style:italic;\">
h<sub>Sat. Surface, In</sub> =
enthalpy(\"MoistAir\",
  p=p<sub>Air</sub>, T=T<sub>Water In</sub>, w=w<sub>Sat. Air In</sub>)
</p>

<p>
where in the above, <i>w<sub>Sat. Air In</sub></i> is the humidity ratio (given
as mass of water per mass of moist air) of the air stream at the water inlet
temperature. Similarly, we can determine the outlet saturated surface
conditions:
</p>

<p align=\"center\" style=\"font-style:italic;\">
h<sub>Sat. Surface, Out</sub> =
  enthalpy(\"MoistAir\",
    p=p<sub>Air</sub>, T=T<sub>Water Out</sub>, w=w<sub>Sat. Air Out</sub>)
</p>

<p>
An \"effective\" surface specific heat can then be estimated using the
two coefficients:
</p>

<p align=\"center\" style=\"font-style:italic;\">
cp<sub>Eff</sub> = (h<sub>Sat. Surf. Out</sub> - h<sub>Sat. Surf. In</sub>)
  / (T<sub>Water Out</sub> - T<sub>Water In</sub>)
</p>

<p>
Unfortunately, we require using the <i>cp<sub>Eff</sub></i> value to determine
the water outlet temperature. Since <i>cp<sub>Eff</sub></i> depends on the
outlet water temperature, evaluation of the wet regime requires some amount of
iteration on water outlet temperature. Braun (1988) assures us that the
\"process converges very quickly, typically within two iterations\",
provided that a reasonable initial estimate is used.
</p>

<p>
We next must determine the \"mass transfer capacitance rate ratio\" or
<i>m<sup>*</sup></i>. This is analogous to the <i>C<sup>*</sup></i> value used
in the 100% dry analysis and is defines as:
</p>

<p align=\"center\" style=\"font-style:italic;\">
m<sup>*</sup> = (massFlow<sub>Air</sub> &middot; cp<sub>Eff</sub>)
  / (massFlow<sub>Water</sub> &middot; cp<sub>Water</sub>)
</p>

<p>
Next, a \"mass transfer conductance\", <i>UA<sup>*</sup></i>, is defined, which
is analogous to the <i>UA</i> used in the 100% dry analysis:
</p>

<p align=\"center\" style=\"font-style:italic;\">
UA<sup>*</sup> = (UA<sub>Air</sub> / cpAir)
  / (1 + (cp<sub>Eff</sub> &middot; UA<sub>Air</sub>)
    / (cpAir &middot; UA<sub>Wat</sub>))
</p>

<p>
This allows us to define an analogous mass transfer number of transfer units:
</p>

<p align=\"center\" style=\"font-style:italic;\">
Ntu<sup>*</sup> = UA<sup>*</sup> / massFlow<sub>air</sub>
</p>

<p>
The total heat transfer is then:
</p>

<p align=\"center\" style=\"font-style:italic;\">
Q<sub>Total</sub> = &epsilon;<sup>*</sup> &middot;
  massFlow<sub>Air</sub> &middot;
  (h<sub>Air In</sub> - h<sub>Sat. Surf. In</sub>)
</p>

<p>
From the total heat transfer, we can then calculate the outlet properties
of the coil by determining an \"effective\" enthalpy and the corresponding
\"effective\" temperature:
</p>

<p align=\"center\" style=\"font-style:italic;\">
h<sub>Air Out</sub> = h<sub>Air In</sub>
  - (Q<sub>Total</sub> / massFlow<sub>Air</sub>)
</p>

<p align=\"center\" style=\"font-style:italic;\">
h<sub>Surf. Eff.</sub> = h<sub>Air In</sub>
  + (h<sub>Air Out</sub> - h<sub>Air In</sub>)
    / (1 - exp(-Ntu<sup>*</sup><sub>Air</sub>))
</p>

<p>
where <i>NTU<sup>*</sup><sub>Air</sub></i> is:
</p>

<p align=\"center\" style=\"font-style:italic;\">
Ntu<sup>*</sup><sub>Air</sub> =
  UA<sub>Air</sub> / (massFlow<sub>Air</sub> &middot; cp<sub>Air</sub>)
</p>

<p align=\"center\" style=\"font-style:italic;\">
T<sub>Surf. Eff.</sub> =
  temperature(p=p<sub>Air</sub>, h=h<sub>Surf. Eff.</sub>, phi=1)
</p>

<p align=\"center\" style=\"font-style:italic;\">
T<sub>Air Out</sub> =
  T<sub>Surf. Eff.</sub> + (T<sub>Air In</sub> - T<sub>Surf. Eff.</sub>)
    &middot; exp(-Ntu<sup>*</sup><sub>Air</sub>)
</p>

<p>
The output humidity ratio, which is critical for determining the mass flow
of condensate removed from the air stream, is:
</p>

<p align=\"center\" style=\"font-style:italic;\">
w<sub>Out</sub> = humidityRatio(
  p=p<sub>Air</sub>, T=T<sub>Air Out</sub>, phi=1)
</p>

<p>
In the above analysis, the functions <code>humidityRatio</code>,
<code>temperature</code>, and <code>enthalpy</code> are carried out by models
and functions from the <a
href=\"modelica://Buildings.Utilities.Psychrometrics\">Psychrometrics</a>
package.
</p>

<p>
The mass flow of condensate is then:
</p>

<p align=\"center\" style=\"font-style:italic;\">
massFlow<sub>Condensate</sub> =
  massFlow<sub>Air</sub> &middot; (w<sub>In</sub> - w<sub>Out</sub>)
</p>

<p>
and we assume that the condensate temperature is that of the effective surface
temperature, <i>T<sub>Surf. Eff.</sub></i>.
</p>

<h5>The partially wet regime</h5>

<p>
As mentioned earlier, this regime uses both the dry and wet regimes along with
a parameter, <i>f<sub>dry</sub></i>, which determines the fraction of the coil
that is dry. The parameter <i>f<sub>dry</sub></i> can range from 0 to 1
inclusive.
</p>

<p>
The equations in this section are based primarily on Mitchell and Braun
(2012b). The only thing new is that both the dry and wet coil analysis must be
\"coupled\". We scale the UA values for air and water for the dry section by
<i>f<sub>dry</sub></i> and the UA values for air and water for the wet section
by <i>(1 - f<sub>dry</sub>)</i>.
</p>

<p>We assume the properties at the dry/wet interface to be:</p>

<ul>
  <li><i>T<sub>Water X</sub></i> for the water stream bulk temperature</li>
  <li><i>T<sub>Air X</sub></i> for the air stream bulk temperature</li>
  <li><i>T<sub>Surf X</sub></i> for the coil surface temperature (on the air
    side)</li>
</ul>

<p>
This is where an assumption that the coil flows \"counter-flow\" (i.e., that
generally speaking, the inlet water is in closest thermal contact to the outlet
air and vice versa) is made: we assume that the <i>T<sub>Air Out</sub></i> of
the dry coil is equal to <i>T<sub>Air In</sub></i> for the wet coil and we call
that point <i>T<sub>Air X</sub></i>. Similarly, we assume <i>T<sub>Water
 Out</sub></i> from the wet coil is equal to <i>T<sub>Water In</sub></i> for
the dry coil calculations and we call that point <i>T<sub>Water X</sub></i>.
The coil surface temperature at that point is then <i>T<sub>Surf. X</sub></i>.
</p>

<p>
This region of the analysis introduces one additional unknown,
<i>f<sub>dry</sub></i>, (called <code>dryFra</code> in the model). Therefore,
we need one additional relationship which is based on the following: the coil
surface temperature (on the air side) is equal to the incoming air's dew point
temperature at the dry/wet transition. This relationship can be written as
follows:
</p>

<p align=\"center\" style=\"font-style:italic;\">
(T<sub>Air X</sub> - T<sub>Surf. X</sub>) &middot; UA<sub>Air</sub>
  = (T<sub>Surf. X</sub> - T<sub>Water X</sub>) &middot; UA<sub>Water</sub>
</p>

<p>
Thus, this regime links together a dry and wet analysis through the above
equation with <i>T<sub>Surf. X</sub> = T<sub>Dew Point In</sub></i>, and
through the values of <i>T<sub>Water X</sub></i> and <i>T<sub>Air X</sub></i>.
By solving for <i>f<sub>dry</sub></i> (which attenuates the <i>A</i> part of
the <i>UA</i> values) we can get the corresponding \"partially wet\" heat
transfer and conditions.
</p>

<h4>Assumptions and limitations</h4>

<p>This model contains the following assumptions and limitations:</p>

<p>
Medium 2 must be air due to the use of various Psychrometric functions that
depend on that assumption.
</p>

<p>
The model uses steady state physics &mdash; no time derivatives are present.
</p>

<p>
The Lewis number, which relates the mass transfer coefficient to the heat
transfer coefficient, is assumed to be 1.
</p>

<p>
The model only truly supports \"counter-flow\" configurations at this
time. These would be configurations that generally assume that inlet air
is in \"thermal contact\" with outlet water and vice versa. This would
include
<a href=\"modelica://Buildings.Fluid.Types.HeatExchangerConfiguration\">
  HeatExchangerConfiguration</a>
values such as <code>CounterFlow</code> and any of the
<code>CrossFlow*</code> types. However, <code>ParallelFlow</code> would
not be appropriate. As shown by Elmahdy and Mitalas (1977), a counter
flow configuration is a good assumption for cross-flow configurations
containing multiple passes. Braun (1988) further observed that \"as the
number of passes increases beyond about four, the performance of a
crossflow heat exchanger approaches that of a counterflow\".
</p>

<p>
This model does not explicitly deal with fin efficiencies: we assume that the
entire overall heat transfer coefficient for the air side and water side
incorporate all necessary adjustments for fin efficiency.
</p>

<p>
Furthermore, the model presented by Braun (1988) and Mitchell and Braun (2012a
and b) incorporate a correction factor, <i>&eta;<sup>*</sup><sub>o</sub></i>,
which is termed an \"overall mass transfer efficiency\" which is \"close in value
to that for heat transfer\". In the example used to validate this model, this
term is neglected and we have neglected it at this time as well. Future
versions of the model could incorporate this correction.
</p>

<h4>Typical use and important parameters</h4>

<p>
This model can be used anywhere a coil heat exchanger can be used.
</p>

<h4>Options</h4>

<p>
Typical parameters that a user would specify include: <code>UA_nominal</code>,
nominal mass and pressure drop terms, <code>r_nominal</code>, and
<code>TWatOut_init</code> &mdash; an estimate for the coil outlet water
temperature. The nominal outlet temperature or inlet temperature can be used
for good effect.
</p>

<h4>Dynamics</h4>

<p>
This model does not itself contain any dynamics. However, the calculations
presented above are fed to a
<a href=\"modelica://Buildings.Fluid.HeatExchangers.HeaterCooler_u\">
HeaterCooler_u</a> block and a
<a href=\"modelica://Buildings.Fluid.HeatExchangers.HeaterCoolerHumidifier_u\">
HeaterCoolerHumidifier_u</a> block. The dynamics on these blocks can be set
from the top level of the current block should you desire.
</p>

<h4>Validation</h4>

<p>
This model has been compared against a textbook problem from Mitchell and Braun
(2012b), Example SM2-1 and found to give consistent answers. The slight
deviations we find are believed due to differences in the tolerance of the
solver algorithms employed as well as differences in media property
calculations for air and water.
</p>

<p>
Validation results can be found in the
<a href=\"modelica://Buildings.Fluid.HeatExchangers.BaseClasses.DryWetCalcsSweep\">
DryWetCalcsSweep</a> class which recreates the figure found in example 13.2 of
Mitchell and Braun (2012a). Furthermore, the 100% dry, 100% wet, and partially
wet regions have been validated versus the conditions found in Example 2-1 from
Mitchell and Braun (2012b).
</p>

<p>
Similarly, each of the models used to build this model contains one or more
examples which confirm that the models run and exercise their inputs. The
relevant examples models are:
</p>

<ul>
<li>
<a href=\"modelica://Buildings.Fluid.HeatExchangers.Examples.WetCoilEffNtu\">
WetCoilEffNtu</a>: a model that exercises this top-level model versus the
Example 2-1 from Mitchell and Braun (2012b)
</li>

<li>
<a href=\"modelica://Buildings.Fluid.HeatExchangers.Examples.WetCoilEffNtuMassFlow\">
WetCoilEffNtuMassFlow</a>: an example of this model as a replacement for
<a href=\"modelica://Buildings.Fluid.HeatExchangers.WetCoilCounterFlow\">
WetCoilCounterFlow</a> in the
<a href=\"modelica://Buildings.Fluid.HeatExchangers.Examples.WetCoilCounterFlowMassFlow\">
WetCoilCounterFlowMassFlow</a> example.
</li>

<li>
<a href=\"modelica://Buildings.Fluid.HeatExchangers.Examples.HeaterCoolerHumidifier_u\">
HeaterCoolerHumidifier_u</a>: an example that exercises the
<a href=\"modelica://Buildings.Fluid.HeatExchangers.HeaterCoolerHumidifier_u\">
HeaterCoolerHumidifier_u</a> model.
</li>

<li>
<a href=\"modelica://Buildings.Fluid.HeatExchangers.BaseClasses.Examples.DryWetCalcs\">
DryWetCalcs</a>: an example that verifies the dry/wet calculations versus Example 2-1 from
Mitchell and Braun (2012b) using the
<a href=\"modelica://Buildings.Fluid.HeatExchangers.BaseClasses.DryWetCalcs\">DryWetCalcs</a>
model.
</li>

<li>
<a href=\"modelica://Buildings.Fluid.HeatExchangers.BaseClasses.Examples.DryWetCalcsSweep\">
DryWetCalcsSweep</a>: an example that verifies the plot of total heat transfer
and dry fraction versus the figure from example 13.2 of Mitchell and Braun
(2012a) using the <a href=\"modelica://Buildings.Fluid.HeatExchangers.BaseClasses.DryWetCalcs\">
DryWetCalcs</a> model.
</li>

<li>
<a href=\"modelica://Buildings.Fluid.HeatExchangers.BaseClasses.Examples.TestDryCoilFun\">
TestDryCoilFun</a>: an example that verifies the dry coil calculations versus
Mitchell and Braun (2012b) using the
<a href=\"modelica://Buildings.Fluid.HeatExchangers.BaseClasses.dryCoil\">
dryCoil</a> function.
</li>

<li>
<a href=\"modelica://Buildings.Fluid.HeatExchangers.BaseClasses.Examples.TestWetCoilFun\">
TestWetCoilFun</a>: an example that verifies the wet coil calculations versus
Mitchell and Braun (2012b) using the <a
href=\"modelica://Buildings.Fluid.HeatExchangers.BaseClasses.wetCoil\">wetCoil</a>
function.
</li>

<li>
<a href=\"modelica://Buildings.Fluid.HeatExchangers.BaseClasses.Examples.TestEffCalc\">
TestEffCalc</a>: an example that verifies the effectiveness calculation versus
Table 13.1 of Mitchell and Braun (2012a) using the <a
href=\"modelica://Buildings.Fluid.HeatExchangers.BaseClasses.epsilon_ntuZ\">
Buildings.Fluid.HeatExchangers.BaseClasses.epsilon_ntuZ</a>
function.
</li>

<li>
<a href=\"modelica://Buildings.Utilities.Psychrometrics.Examples.TDewPoi_pX\">
TDewPoi_pX</a>: an example that  tests the utility block
<a href=\"modelica://Buildings.Utilities.Psychrometrics.TDewPoi_pX\">
TDewPoi_pX</a> model for calculating the dew point temperature from pressure
and mass fraction of water.
</li>

<li>
<a href=\"modelica://Buildings.Utilities.Psychrometrics.Functions.Examples.Test_TSat_ph\">
Test_TSat_ph</a>: an example that tests calculating the saturation temperature
based on pressure and specific enthalpy using the
<a href=\"modelica://Buildings.Utilities.Psychrometrics.Function.TSat_ph\">
TSat_ph</a> function.
</li>
</ul>

<h4>Implementation</h4>

<p>
The coil model is implemented using three main pieces:
</p>

<ul>
<li>
A <a href=\"modelica://Buildings.Fluid.HeatExchangers.HeaterCooler_u\">
HeaterCooler_u</a> block to add (or remove) heat to the water stream.
</li>

<li>
A
<a href=\"modelica://Buildings.Fluid.HeatExchangers.HeaterCoolerHumidifier_u\">
HeaterCoolerHumidifier_u</a>
block to remove (or add) heat and (possibly) remove moisture from the
air stream.
</li>

<li>
A
<a href=\"modelica://Buildings.Fluid.HeatExchangers.BaseClasses.DryWetCalcs\">
DryWetCalcs</a>
block to use the equations mentioned above to calculate the total and sensible
heat transfer rates as well as mass flow rate of condensate.
</li>
</ul>

<p>
The actual wet coil and dry coil calculations are currently implemented using
the functions
<a href=\"modelica://Buildings.Fluid.HeatExchangers.BaseClasses.dryCoil\">
dryCoil</a> and
<a href=\"modelica://Buildings.Fluid.HeatExchangers.BaseClasses.wetCoil\">
wetCoil</a>.
These functions were originally created in anticipation of implementing more of
the dry/wet analysis into algorithmic code. The functions have been designed to
\"short circuit\" under certain input conditions (such as zero value for either
of the <i>UA</i> parameters) and quickly exit.
</p>

<p>
Two psychrometric functions were created to assist with the running of this
model:
<a href=\"modelica://Buildings.Utilities.Psychrometrics.TDewPoi_pX\">
TDewPoi_pX</a> and
<a href=\"modelica://Buildings.Utilities.Psychrometrics.Function.TSat_ph\">
TSat_ph</a>.
The first is used to determine the dew point temperature from ambient fluid
bulk pressure and the mass fraction of water.
</p>

<p>
Finally, the effectiveness calculations by configuration have been abstracted
into the function <a
href=\"modelica://Buildings.Fluid.HeatExchangers.BaseClasses.epsilon_ntuZ\">
Buildings.Fluid.HeatExchangers.BaseClasses.epsilon_ntuZ</a>.
</p>

<h5>Performance</h5>

<!-- fixme: check if this is still the case after the refactoring of the equations -->
<p>
The current model is experiencing some performance issues and is running about
four times slower than the <a
href=\"modelica://Buildings.Fluid.HeatExchangers.WetCoilCounterFlow\">WetCoilCounterFlow</a>
model it was meant to replace. It is believed the performance problems can be
attributed to:
</p>

<ul>
<li>
Excessive iteration, especially in the wet calculation region. The wet
calculation region is \"heavy\".
</li>

<li>
Use of a numerically derived Jacobian for the
<a href=\"modelica://Buildings.Fluid.HeatExchangers.BaseClasses.wetCoil\">
wetCoil</a> function.
</li>
</ul>

<p>
We plan to switch to a model format (instead of a function) surrounded by an if
block to prevent the wet calculations from running when not needed. We believe
this will allow the Modelica compiler to better optimize the problem.
</p>

<p>
We are also considering eliminating the iteration for dry fraction by using a
better curve fitting mechanism and a utility function such as the
<a href=\"modelica://Buildings.Utilities.Math.Functions.cubicHermiteLinearExtrapolation\">
cubicHermiteLinearExtrapolation</a>
function which requires knowledge of two points and the derivatives at those
points. This may allow for a quick estimate of the heat transfer although it is
unknown if the dehumidification estimate will suffer.
</p>

<h5>Outstanding Issues</h5>

<p>
In addition to the performance issues mentioned above, the following
outstanding issues remain:
</p>

<ul>
<!-- fixme: Is the issue below still present? -->
<li>
The
<a href=\"modelica://Buildings.Fluid.HeatExchangers.HeaterCoolerHumidifier_u\">
HeaterCoolerHumidifier_u</a>
model for heating/cooling and (de-)humidifying the air stream needs to be
further tested. It is unclear at this point if the command to extract moisture
from the air is working correctly. Furthermore, we need to verify that the
sensible heat + dehumidification actually matches with what the
<a href=\"modelica://Buildings.Fluid.HeatExchangers.BaseClasses.DryWetCalcs\">
DryWetCalcs</a> block predicts. We have verified that the total heat transfer
from <code>port_a</code> to <code>port_b</code> matches our predictions but the
change in temperature versus change in mass fraction of water appears
inconsistent and requires additional verification.
</li>
</ul>

<h4>References</h4>

<p>
Braun, James E. 1988. \"Methodologies for the Design and Control of Central
Cooling Plants\". PhD Thesis.  University of Wisconsin - Madison. Available
online: <a
href=\"https://minds.wisconsin.edu/handle/1793/46694\">https://minds.wisconsin.edu/handle/1793/46694</a>
</p>

<p>
Mitchell, John W., and James E. Braun. 2012a. <i>Principles of heating,
  ventilation, and air conditioning in buildings</i>.  Hoboken, N.J.: Wiley.
</p>

<p>
Mitchell, John W., and James E. Braun. 2012b.
\"Supplementary Material Chapter 2: Heat Exchangers for Cooling Applications\".
Excerpt from <i>Principles of heating, ventilation, and air conditioning in buildings</i>.
Hoboken, N.J.: Wiley. Available online:
<a href=\"http://bcs.wiley.com/he-bcs/Books?action=index&amp;itemId=0470624574&amp;bcsId=7185\">
http://bcs.wiley.com/he-bcs/Books?action=index&amp;itemId=0470624574&amp;bcsId=7185</a>
</p>

<p>
Elmahdy, A.H. and Mitalas, G.P. 1977. \"A Simple Model for Cooling and
Dehumidifying Coils for Use In Calculating Energy Requirements for Buildings\".
ASHRAE Transactions. Vol.83. Part 2. pp. 103-117.
</p>
</html>", revisions="<html>
<ul>
<li>
April 14, 2017, by Michael Wetter:<br/>
Added variables for total, sensible and latent heat transfer, and for
sensible heat ratio. Refactored model for new base class.
</li>
<li>
March 17, 2017, by Michael O'Keefe:<br/>
First implementation. See
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/622\">
issue 622</a> for more information.
</li>
</ul>
</html>"));
end WetEffectivenessNTU;
