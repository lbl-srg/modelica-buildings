within Buildings.Fluid.HeatExchangers;
model WetEffectivenessNTU_Fuzzy
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
  parameter Modelica.SIunits.Temperature TWatOut_init=283.15
    "Guess value for the water outlet temperature that is used to initialize the iterations"
    annotation (Dialog(group="Advanced"));
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
  Buildings.Fluid.Humidifiers.Humidifier_u heaCooHum_u(
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
  BaseClasses.DryWetCalcsFuzzy_V2_0                           dryWetCalcs(
    redeclare final package Medium2 = Medium2,
    final TWatOut_init = TWatOut_init,
    final cfg = flowRegime,
    final mWat_flow_nominal=m1_flow_nominal,
    final mAir_flow_nominal=m2_flow_nominal)
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
  Modelica.Blocks.Sources.RealExpression cp_a2Exp(
    final y = if allowFlowReversal2
    then
      fra_a2 * Medium2.specificHeatCapacityCp(state_a2_inflow)
      + fra_b2 * Medium2.specificHeatCapacityCp(state_b2_inflow)
    else
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
  Modelica.Blocks.Sources.RealExpression m_flow_a1Exp(final y=abs(port_a1.m_flow))
    "Absolute value of mass flow rate on water side"
    annotation (Placement(transformation(extent={{-98,30},{-84,42}})));
  Modelica.Blocks.Sources.RealExpression m_flow_a2Exp(final y=abs(port_a2.m_flow))
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

  Modelica.SIunits.ThermalConductance C1_flow = abs(m1_flow)*
    ( if allowFlowReversal1 then
           fra_a1 * Medium1.specificHeatCapacityCp(state_a1_inflow) +
           fra_b1 * Medium1.specificHeatCapacityCp(state_b1_inflow) else
        Medium1.specificHeatCapacityCp(state_a1_inflow))
    "Heat capacity flow rate medium 1";
  Modelica.SIunits.ThermalConductance C2_flow = abs(m2_flow)*
    ( if allowFlowReversal2 then
           fra_a2 * Medium2.specificHeatCapacityCp(state_a2_inflow) +
           fra_b2 * Medium2.specificHeatCapacityCp(state_b2_inflow) else
        Medium2.specificHeatCapacityCp(state_a2_inflow))
    "Heat capacity flow rate medium 2";
  parameter Modelica.SIunits.SpecificHeatCapacity cp1_nominal(fixed=false)
    "Specific heat capacity of medium 1 at nominal condition";
  parameter Modelica.SIunits.SpecificHeatCapacity cp2_nominal(fixed=false)
    "Specific heat capacity of medium 2 at nominal condition";
  parameter Modelica.SIunits.ThermalConductance C1_flow_nominal(fixed=false)
    "Nominal capacity flow rate of Medium 1";
  parameter Modelica.SIunits.ThermalConductance C2_flow_nominal(fixed=false)
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
  connect(XWat_a2Exp.y, dryWetCalcs.wAirIn) annotation (Line(points={{-29.3,4},
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
This model represents a cooling or heating coil that is capable of
simulating the partially wet or fully wet regime in addition to 100% dry
conditions.  The coil is  based primarily on the work of Braun (1988) and of Mitchell
and Braun (2012a and b), which is essentially an &epsilon;-NTU approach of
the work of Elmahdy and Mitalas (1977).
</p>

<p>
The wet coil model is a heat exchanger across two different
fluids: medium 1 and medium 2. However, in this discussion, we will assume that
medium 1 is water and medium 2 is air. Due to the use of psychrometric
functions, medium 2 must be a air with water vapor,
but any other fluid, such as glycol or air that is colder than medium 2 and
hence will be heated, can be used for medium 1.
</p>

<p>
The model represents steady-state physics: for a given set of inlet
conditions, the outlet conditions change instantaneously.
</p>

<h4>Main equations</h4>

<p>
The model operates in three different regimes:
</p>

<ul>
<li>100% dry coil</li>
<li>100% wet coil, and</li>
<li>partially wet/dry.</li>
</ul>

<p>
Below we will discuss the three regimes as well as how to determine which
regime the coil is operating in.
</p>

<h5>Determination of regime</h5>

<p>
The inlet air dry bulb temperature, inlet water temperature, and inlet air dew
point temperature are used to determine which regime the model is operating in.
Specifically, if the coil is in heating mode, then we assume no condensation
will take place. We define being in heating mode if the inlet water temperature
is higher than the inlet air temperature,
</p>

<p align=\"center\" style=\"font-style:italic;\">
T<sub>wat,in</sub> &ge; T<sub>air,in</sub>.
</p>

<p>
If we are not in heating mode, we check how the inlet air
dew point temperature compares with two \"boundary temperatures\" which separate
the 100% dry, partially wet, and 100% wet regimes. The determination of these
boundary temperatures is based on the 1-dimensional heat balance
between the two fluids. We assume that the heat transfer coefficient and
relevant area of heat transfer from the bulk water stream temperature to the
surface temperature of the air-side of the coil is known and equal to
<i>hA<sub>wat</sub></i>. We also assume that the heat transfer coefficient from
the bulk air stream temperature to the coil surface is known as
<i>hA<sub>air</sub></i>.
</p>

<p>
Balancing these two conditions yields
</p>

<p align=\"center\" style=\"font-style:italic;\">
Q<sub>air&rarr;wat,X</sub> = hA<sub>air</sub>  (T<sub>air,X</sub> -
  T<sub>surf,X</sub>)
</p>

<p>
and
</p>

<p align=\"center\" style=\"font-style:italic;\">
Q<sub>air&rarr;wat,X</sub> = hA<sub>wat</sub>
  (T<sub>surf,X</sub> - T<sub>wat,X</sub>).
</p>

<p>
We can equate these two heat transfers and make the following observations:
</p>

<ul>
<li>The coil surface temperature will be at the dew point when condensation
  begins, and</li>
<li>the coil will first begin to condense at its coldest
  point: the air stream outlet.</li>
</ul>

<p>
Updating the equations above under these assumptions yields the following
relationship for the case where condensation just begins to occur on an
otherwise dry coil,
</p>

<p align=\"center\" style=\"font-style:italic;\">
(T<sub>air,out</sub> - T<sub>Dew Point, A</sub>)  hA<sub>air</sub> =
  (T<sub>Dew Point A</sub> - T<sub>wat,in</sub>)  hA<sub>wat</sub>,
</p>
<p>
where <i>T<sub>Dew Point, A</sub></i>, is the boundary to the dry
region of the coil. If the inlet air dew point is less than or equal to
<i>T<sub>Dew Point, A</sub></i>, we have a 100% dry coil.
</p>

<p>
Similarly, we can observe that a 100% wet coil will reach total coverage when
the surface temperature at the air inlet is equal to the inlet air dew
point temperature, i.e.,
</p>

<p align=\"center\" style=\"font-style:italic;\">
(T<sub>air,out</sub> - T<sub>Dew Point, B</sub>)  hA<sub>air</sub> =
  (T<sub>Dew Point B</sub> - T<sub>wat,in</sub>)  hA<sub>wat</sub>.
</p>
<p><b>fixme: Explain what is meant by A and B. These are used below in \"region = ...\"
but it is not clear what the difference between
<i>T<sub>Dew Point, A</sub></i> and <i>T<sub>Dew Point, B</sub></i> is.
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
region = if (T<sub>wat,in</sub> &ge; T<sub>air,in</sub> or
             T<sub>Dry Bulb,in</sub> &le; T<sub>Dry Bulb, A</sub>)
         then I
         elseif (T<sub>Dry Bulb, B</sub> &le; T<sub>Dry Bulb,in</sub>)
         then III
         else II.
</p>

<p>
If we determine we're in region <i>I</i>, we only need to use the 100% dry
equations. If we determine we're in region <i>III</i>, we need only use the
100% wet equations. If we're in region two, however, we must iterate to
determine the dry fraction <i>f<sub>dry</sub></i> of the coil.
This iteration requires iterating over both the wet and dry relations.
</p>

<h5>The 100% dry regime</h5>

<p>
The 100% dry regime is a traditional <i>&epsilon;</i>-NTU methodology.
</p>

<p>
First, the capacitance rates for the water and air side are determined as
</p>

<p align=\"center\" style=\"font-style:italic;\">
C<sub>wat</sub> = m&#775;<sub>wat</sub>  c<sub>p,wat</sub>
</p>

<p align=\"center\" style=\"font-style:italic;\">
C<sub>air</sub> = m&#775;<sub>air</sub>  c<sub>p,Air</sub>
</p>

<p align=\"center\" style=\"font-style:italic;\">
C<sub>min</sub> = min(C<sub>air</sub>, C<sub>wat</sub>)
</p>

<p align=\"center\" style=\"font-style:italic;\">
C<sub>max</sub> = max(C<sub>air</sub>, C<sub>wat</sub>),
</p>
<p>
where
<i>m&#775;</i> is the mass flow rate and
<i>c<sub>p</sub></i> is the specific heat capacity.
</p>

<p>
Now, the capacity rate ratio <i>Z</i> can be expressed as
</p>

<p align=\"center\" style=\"font-style:italic;\">
Z = C<sub>min</sub> / C<sub>max</sub>.
</p>

<p>
The overall heat transfer coefficient times area for the coil can be
determined as
</p>

<p align=\"center\" style=\"font-style:italic;\">
UA = 1 / ((1 / hA<sub>air</sub>) + (1 / hA<sub>wat</sub>))
</p>
<p>
Next, we can determine the number of transfer units:
</p>
<p align=\"center\" style=\"font-style:italic;\">
NTU = UA / C<sub>min</sub>
</p>

<p>
The effectiveness <i>&epsilon;</i> is determined using the function
<a href=\"modelica://Buildings.Fluid.HeatExchangers.BaseClasses.epsilon_ntuZ\">
Buildings.Fluid.HeatExchangers.BaseClasses.epsilon_ntuZ</a> which calculates
the effectiveness for a given capacity rate ratio <i>Z</i>,
number of transfer units <i>NTU</i>, and configuration of the cooling coil (e.g.,
cross-flow, counter-flow, etc.). Available configurations are
listed as part of the <a
href=\"modelica://Buildings.Fluid.Types.HeatExchangerConfiguration\">
Buildings.Fluid.Types.HeatExchangerConfiguration</a> type; however, be advised
that the current model is only set up for the \"counter-flow\"
types: <code>CounterFlow</code> and <code>CrossFlow*</code>.
If <code>ParallelFlow</code> is used, the model stops with an error.
</p>

<p>
The overall heat transfered from the air to the water is
</p>

<p align=\"center\" style=\"font-style:italic;\">
Q<sub>tot, dry</sub> = &epsilon;  C<sub>min</sub>
  (T<sub>wat,in</sub> - T<sub>air,in</sub>)
</p>

<p>
From this, we can determine the outlet conditions as
</p>
<p>
<b>fixme: This is not true if water has the smaller
capacity flow rate, e.g., if the water flow is throttled by a valve.</b>
</p>
<p align=\"center\" style=\"font-style:italic;\">
T<sub>air,out</sub> = T<sub>air,in</sub> - &epsilon;
  (T<sub>air,in</sub> - T<sub>wat,in</sub>),
</p>
and
<p align=\"center\" style=\"font-style:italic;\">
T<sub>wat,out</sub> = T<sub>wat,in</sub>
  + Z  (T<sub>air,in</sub> - T<sub>air,out</sub>).
</p>

<p>
We can also calculate the coil surface's air outlet temperature which is useful
for determining <i>f<sub>dry</sub></i> in the partially wet region.
</p>

<p align=\"center\" style=\"font-style:italic;\">
T<sub>surf,out</sub> = T<sub>wat,in</sub>
  + ((Z  NTU<sub>dry</sub>
     (T<sub>air,out</sub> - T<sub>wat,in</sub>))
      / NTU<sub>wat</sub>),
</p>
<p>
where
</p>

<p align=\"center\" style=\"font-style:italic;\">
NTU<sub>air</sub> =
  hA<sub>air</sub> / (m&#775;<sub>air</sub>  c<sub>p,air</sub>),
</p>

<p align=\"center\" style=\"font-style:italic;\">
NTU<sub>wat</sub> =
  hA<sub>wat</sub> / (m&#775;<sub>wat</sub>  c<sub>p,wat</sub>)
</p>

<p>
and
</p>

<p align=\"center\" style=\"font-style:italic;\">
NTU<sub>dry</sub> =
  NTU<sub>air</sub> / (1 + Z  (NTU<sub>air</sub> / NTU<sub>wat</sub>))
</p>

<h5>The 100% wet regime</h5>

<p>
The 100% wet regime is based on an analogy to the &epsilon;-NTU
method as discussed in section 13.6 \"Cooling Coil Performance Using a Heat
Transfer Analogy\" of Mitchell and Braun (2012a). The heat transfer analogy
is an acknowledgement of the similarities between the case for a wet coil
and the case for a dry coil and allows us to reuse the &epsilon;-NTU
approach.
</p>

<p>
In this analysis, the water stream is replaced by an equivalent air stream that
is saturated at the temperatures of the water stream, as this allows to
combine enthalpy differences directly. Further discussion of the analogy itself
is given in the above mentioned reference. We start by determining the equivalent
air stream at the saturated coil surface, which is
</p>

<p align=\"center\" style=\"font-style:italic;\">
h<sub>sat,surf,in</sub> =
h<sub>air</sub>(p=p<sub>air</sub>, T=T<sub>wat,in</sub>, w=w<sub>sat,air,in</sub>),
</p>
<p>
where <i>w<sub>sat,air,in</sub></i> is the humidity ratio of the air stream at the <emph>water</emph>
inlet temperature. Similarly, we can determine the outlet saturated surface
conditions as
</p>

<p align=\"center\" style=\"font-style:italic;\">
h<sub>sat,surf,out</sub> =
  h<sub>air</sub>(p=p<sub>air</sub>, T=T<sub>wat,out</sub>, w=w<sub>sat,air,out</sub>)
</p>

<p>
The effective surface specific heat <i>c<sub>p,eff</sub></i> is
then estimated as
</p>

<p align=\"center\" style=\"font-style:italic;\">
c<sub>p,eff</sub> = (h<sub>sat,surf,out</sub> - h<sub>sat,surf,in</sub>)
  &frasl; (T<sub>wat,out</sub> - T<sub>wat,in</sub>)
</p>

<p>
Unfortunately, we require using the <i>c<sub>p,eff</sub></i> value to determine
the water outlet temperature. Since <i>c<sub>p,eff</sub></i> depends on the
outlet water temperature, evaluation of the wet regime requires
an iterative solution.
Braun (1988) states that the
process converges very quickly, typically within two iterations,
provided that a reasonable initial estimate is used.
</p>

<p>
We next must determine the mass transfer capacitance rate ratio
<i>m<sup>*</sup></i>. This is analogous to the <i>Z</i> value used
in the 100% dry analysis and is defines as
</p>

<p align=\"center\" style=\"font-style:italic;\">
m<sup>*</sup> = (m&#775;<sub>air</sub>  c<sub>p,eff</sub>)
  &frasl; (m&#775;<sub>wat</sub>  c<sub>p,wat</sub>)
</p>

<p>
Next, a mass transfer conductance <i>UA<sup>*</sup></i> is defined, which
is analogous to the <i>UA</i> used in the 100% dry analysis, i.e.,
</p>

<p align=\"center\" style=\"font-style:italic;\">
UA<sup>*</sup> = (hA<sub>air</sub> / c<sub>p,air</sub>)
  / (1 + (c<sub>p,eff</sub>  hA<sub>air</sub>)
    / (c<sub>p,air</sub>  hA<sub>wat</sub>)).
</p>

<p>
This allows us to define an analogous mass transfer number of transfer units as
</p>

<p align=\"center\" style=\"font-style:italic;\">
NTU<sup>*</sup> = UA<sup>*</sup> / m&#775;<sub>air</sub>.
</p>

<p>
The total heat transfer is then
</p>

<p align=\"center\" style=\"font-style:italic;\">
Q<sub>tot</sub> = &epsilon;<sup>*</sup>
  m&#775;<sub>air</sub>
  (h<sub>air,in</sub> - h<sub>sat,surf,in</sub>)
</p>

<p>
From the total heat transfer, we can then calculate the outlet properties
of the coil by determining an effective enthalpy and the corresponding
effective temperature:
</p>

<p align=\"center\" style=\"font-style:italic;\">
h<sub>air,out</sub> = h<sub>air,in</sub>
  - (Q<sub>tot</sub> / m&#775;<sub>air</sub>)
</p>
and
<p align=\"center\" style=\"font-style:italic;\">
h<sub>surf,eff</sub> = h<sub>air,in</sub>
  + (h<sub>air,out</sub> - h<sub>air,in</sub>)
    / (1 - exp(-NTU<sup>*</sup><sub>air</sub>)),
</p>

<p>
where <i>NTU<sup>*</sup><sub>air</sub></i> is
</p>

<p align=\"center\" style=\"font-style:italic;\">
NTU<sup>*</sup><sub>air</sub> =
  hA<sub>air</sub> / (m&#775;<sub>air</sub>  c<sub>p,air</sub>)
</p>

<p align=\"center\" style=\"font-style:italic;\">
T<sub>surf,eff</sub> =
  T(p=p<sub>air</sub>, h=h<sub>surf,eff</sub>, phi=1)
</p>
and
<p align=\"center\" style=\"font-style:italic;\">
T<sub>air,out</sub> =
  T<sub>surf,eff</sub> + (T<sub>air,in</sub> - T<sub>surf. Eff.</sub>)
     exp(-NTU<sup>*</sup><sub>air</sub>)
</p>

<p>
The output humidity ratio, which is critical for determining the mass flow
of condensate removed from the air stream, is
</p>

<p align=\"center\" style=\"font-style:italic;\">
w<sub>out</sub> = w(
  p=p<sub>air</sub>, T=T<sub>air,out</sub>, phi=1)
</p>

<p>
In the above analysis, the functions <code>w()</code>,
<code>T()</code>, and <code>h()</code> are carried out by models
and functions from the <a
href=\"modelica://Buildings.Utilities.Psychrometrics\">Buildings.Utilities.Psychrometrics</a>
package.
</p>

<p>
The mass flow of condensate is then
</p>

<p align=\"center\" style=\"font-style:italic;\">
m&#775;<sub>con</sub> =
  m&#775;<sub>air</sub>  (w<sub>in</sub> - w<sub>out</sub>),
</p>

<p>
and we assume that the condensate temperature is that of the effective surface
temperature <i>T<sub>surf,eff</sub></i>.
</p>

<h5>The partially wet regime</h5>

<p>
As mentioned earlier, this regime uses both the dry and wet regimes along with
a parameter, <i>f<sub>dry</sub> &isin; [0, 1]</i>, which is defined as the fraction of the coil
that is dry.
</p>

<p>
The equations in this section are based primarily on Mitchell and Braun
(2012b). The only thing new is that both the dry and wet coil analysis must be
coupled. We scale the hA values for air and water for the dry section by
<i>f<sub>dry</sub></i> and the hA values for air and water for the wet section
by <i>(1 - f<sub>dry</sub>)</i>.
</p>

<p>We assume the properties at the dry/wet interface to be:</p>

<ul>
  <li><i>T<sub>wat,X</sub></i> for the water stream bulk temperature</li>
  <li><i>T<sub>air,X</sub></i> for the air stream bulk temperature</li>
  <li><i>T<sub>surf,X</sub></i> for the coil surface temperature (on the air
    side)</li>
</ul>

<p>
This is where an assumption that the coil flows \"counter-flow\" (i.e., that
generally speaking, the inlet water is in closest thermal contact to the outlet
air and vice versa) is made: we assume that the <i>T<sub>air,out</sub></i> of
the dry coil is equal to <i>T<sub>air,in</sub></i> for the wet coil and we call
that point <i>T<sub>air,X</sub></i>. Similarly, we assume
<i>T<sub>wat,out</sub></i> from the wet coil is equal to <i>T<sub>wat,in</sub></i> for
the dry coil calculations and we call that point <i>T<sub>wat,X</sub></i>.
The coil surface temperature at that point is then <i>T<sub>surf,X</sub></i>.
</p>

<p>
This region of the analysis introduces one additional unknown,
<i>f<sub>dry</sub></i>. Therefore,
we need one additional relationship which is based on the following: the coil
surface temperature (on the air side) is equal to the incoming air's dew point
temperature at the dry/wet transition. This relationship can be written as
</p>

<p align=\"center\" style=\"font-style:italic;\">
(T<sub>air,X</sub> - T<sub>surf,X</sub>)  hA<sub>air</sub>
  = (T<sub>surf,X</sub> - T<sub>wat,X</sub>)  hA<sub>wat</sub>
</p>

<p>
Thus, this regime links together a dry and wet analysis through the above
equation with <i>T<sub>surf,X</sub> = T<sub>Dew Point,in</sub></i>, and
through the values of <i>T<sub>wat,X</sub></i> and <i>T<sub>air,X</sub></i>.
By solving for <i>f<sub>dry</sub></i> (which attenuates the <i>A</i> part of
the <i>hA</i> values) we can get the corresponding \"partially wet\" heat
transfer and conditions.
</p>

<h4>Assumptions and limitations</h4>

<p>
This model contains the following assumptions and limitations:
</p>

<p>
Medium 2 must be air due to the use of various Psychrometric functions that
depend on that assumption.
</p>

<p>
The model uses steady state physics, no time derivatives are present.
</p>

<p>
The Lewis number, which relates the mass transfer coefficient to the heat
transfer coefficient, is assumed to be <i>1</i>.
</p>

<p>
The model only truly supports \"counter-flow\" configurations.
These would be configurations that generally assume that inlet air
is in \"thermal contact\" with outlet water and vice versa. This would
include
<a href=\"modelica://Buildings.Fluid.Types.HeatExchangerConfiguration\">
Buildings.Fluid.Types.HeatExchangerConfiguration</a>
values such as <code>CounterFlow</code> and any of the
<code>CrossFlow*</code> types. However, <code>ParallelFlow</code> would
not be appropriate, and the model stops with an error if this value is
selected. As shown by Elmahdy and Mitalas (1977), a counter
flow configuration is a good assumption for cross-flow configurations
containing multiple passes. Braun (1988) further observed that as the
number of passes increases beyond about four, the performance of a
crossflow heat exchanger approaches that of a counterflow.
</p>

<p>
This model does not explicitly deal with fin efficiencies. We assume that the
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
However, for situations where no condensation can occur, such as
a heating coil, the model
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DryEffectivenessNTU\">
Buildings.Fluid.HeatExchangers.DryEffectivenessNTU</a>
is computationally more efficient.
</p>

<h4>Options</h4>

<p>
Typical parameters that a user would specify include: <code>UA_nominal</code>,
nominal mass and pressure drops.
</p>

<h4>Dynamics</h4>

<p>
This model does not itself contain any dynamics. However, the calculations
presented above are fed to a
<a href=\"modelica://Buildings.Fluid.HeatExchangers.HeaterCooler_u\">
Buildings.Fluid.HeatExchangers.HeaterCooler_u</a> model and a
<a href=\"modelica://Buildings.Fluid.Humidifiers.Humidifier_u\">
Buildings.Fluid.Humidifiers.Humidifier_u</a> model.
The dynamics on these blocks can be set
from the top level of the current block if desired.
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
Validation results can be found in
<a href=\"modelica://Buildings.Fluid.HeatExchangers.BaseClasses.Examples.DryWetCalcsSweep\">
Buildings.Fluid.HeatExchangers.BaseClasses.Examples.DryWetCalcsSweep</a>
which recreates the figure found in example 13.2 of
Mitchell and Braun (2012a). Furthermore, the 100% dry, 100% wet, and partially
wet regions have been validated versus the conditions found in Example 2-1 from
Mitchell and Braun (2012b).
</p>

<p>
Similarly, each of the models used to build this model contains one or more
examples which confirm that the models run and exercise their inputs.
Examples that reproduce the examples from the literature are:
</p>
<ul>
<li>
<a href=\"modelica://Buildings.Fluid.HeatExchangers.Examples.WetCoilEffNtu\">
Buildings.Fluid.HeatExchangers.Examples.WetCoilEffNtu</a>:
a model that exercises this top-level model versus the
Example 2-1 from Mitchell and Braun (2012b)
</li>

<li>
<a href=\"modelica://Buildings.Fluid.HeatExchangers.BaseClasses.Examples.DryWetCalcs\">
DryWetCalcs</a>: an example that verifies the dry/wet calculations versus Example 2-1 from
Mitchell and Braun (2012b) using the
<a href=\"modelica://Buildings.Fluid.HeatExchangers.BaseClasses.DryWetCalcs\">
Buildings.Fluid.HeatExchangers.BaseClasses.DryWetCalcs</a>
model.
</li>

<li>
<a href=\"modelica://Buildings.Fluid.HeatExchangers.BaseClasses.Examples.DryWetCalcsSweep\">
Buildings.Fluid.HeatExchangers.BaseClasses.Examples.DryWetCalcsSweep</a>:
an example that verifies the plot of total heat transfer
and dry fraction versus the figure from example 13.2 of Mitchell and Braun
(2012a) using the <a href=\"modelica://Buildings.Fluid.HeatExchangers.BaseClasses.DryWetCalcs\">
Buildings.Fluid.HeatExchangers.BaseClasses.DryWetCalcs</a> model.
</li>

</ul>

<h4>Implementation</h4>

<p>
The coil model is implemented using three main pieces:
</p>

<ul>
<li>
A <a href=\"modelica://Buildings.Fluid.HeatExchangers.HeaterCooler_u\">
Buildings.Fluid.HeatExchangers.HeaterCooler_u</a>
model to add (or remove) heat to the water stream.
</li>

<li>
A
<a href=\"modelica://Buildings.Fluid.Humidifiers.Humidifier_u\">
Buildings.Fluid.Humidifiers.Humidifier_u</a>
model to remove (or add) heat and (possibly) remove moisture from the
air stream.
</li>

<li>
A
<a href=\"modelica://Buildings.Fluid.HeatExchangers.BaseClasses.DryWetCalcs\">
Buildings.Fluid.HeatExchangers.BaseClasses.DryWetCalcs</a>
block to use the equations mentioned above to calculate the total and sensible
heat transfer rates as well as mass flow rate of condensate.
</li>
</ul>

<p>
Two psychrometric functions were created to assist with the running of this
model:
<a href=\"modelica://Buildings.Utilities.Psychrometrics.TDewPoi_pX\">
Buildings.Utilities.Psychrometrics.TDewPoi_pX</a> and
<a href=\"modelica://Buildings.Utilities.Psychrometrics.Function.TSat_ph\">
Buildings.Utilities.Psychrometrics.Function.TSat_ph</a>.
The first is used to determine the dew point temperature from ambient fluid
bulk pressure and the mass fraction of water.
</p>

<p>
Finally, the effectiveness calculations by configuration are done in
<a href=\"modelica://Buildings.Fluid.HeatExchangers.BaseClasses.epsilon_ntuZ\">
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
</html>"),
    __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Fluid/HeatExchangers/Examples/WetCoilEffNtuMassFlowFuzzy.mos"));
end WetEffectivenessNTU_Fuzzy;
