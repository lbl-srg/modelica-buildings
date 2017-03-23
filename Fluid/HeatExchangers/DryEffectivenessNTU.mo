within Buildings.Fluid.HeatExchangers;
model DryEffectivenessNTU
  "Heat exchanger with effectiveness - NTU relation and no moisture condensation"
  extends Buildings.Fluid.HeatExchangers.BaseClasses.PartialEffectiveness(
      sensibleOnly1=true, sensibleOnly2=true,
      Q1_flow = eps*QMax_flow,
      Q2_flow = -Q1_flow,
      mWat1_flow = 0,
      mWat2_flow = 0);
  import con = Buildings.Fluid.Types.HeatExchangerConfiguration;
  import flo = Buildings.Fluid.Types.HeatExchangerFlowRegime;
  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal
    "Nominal heat transfer" annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Temperature T_a1_nominal
    "Nominal temperature at port a1"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Temperature T_a2_nominal
    "Nominal temperature at port a2"
    annotation (Dialog(group="Nominal condition"));
  parameter con configuration "Heat exchanger configuration"
    annotation (Evaluate=true);
  parameter Real r_nominal(
    min=0,
    max=1) = 2/3
    "Ratio between air-side and water-side convective heat transfer (hA-value) at nominal condition";
  Buildings.Fluid.HeatExchangers.BaseClasses.HADryCoil hA(
    final r_nominal=r_nominal,
    final UA_nominal=UA_nominal,
    final m_flow_nominal_w=m1_flow_nominal,
    final m_flow_nominal_a=m2_flow_nominal,
    waterSideTemperatureDependent=false,
    airSideTemperatureDependent=false)
    "Model for convective heat transfer coefficient";
  Modelica.SIunits.ThermalConductance UA "UA value";
  Real eps(min=0, max=1) "Heat exchanger effectiveness";
  Real Z(min=0, max=1) "Ratio of capacity flow rate (CMin/CMax)";
  // NTU has been removed as NTU goes to infinity as CMin goes to zero.
  // This quantity is not good for modeling.
  //  Real NTU(min=0) "Number of transfer units";
  final parameter Modelica.SIunits.ThermalConductance UA_nominal(fixed=false)
    "Nominal UA value";
  final parameter Real NTU_nominal(min=0, fixed=false)
    "Nominal number of transfer units";
  final parameter Real eps_nominal(fixed=false)
    "Nominal heat transfer effectiveness";
protected
  parameter Modelica.SIunits.SpecificHeatCapacity cp1_nominal(fixed=false)
    "Specific heat capacity of medium 1 at nominal condition";
  parameter Modelica.SIunits.SpecificHeatCapacity cp2_nominal(fixed=false)
    "Specific heat capacity of medium 2 at nominal condition";
  parameter Modelica.SIunits.ThermalConductance C1_flow_nominal(fixed=false)
    "Nominal capacity flow rate of Medium 1";
  parameter Modelica.SIunits.ThermalConductance C2_flow_nominal(fixed=false)
    "Nominal capacity flow rate of Medium 2";
  parameter Modelica.SIunits.ThermalConductance CMin_flow_nominal(fixed=false)
    "Minimal capacity flow rate at nominal condition";
  parameter Modelica.SIunits.ThermalConductance CMax_flow_nominal(fixed=false)
    "Maximum capacity flow rate at nominal condition";
  parameter Real Z_nominal(
    min=0,
    max=1,
    fixed=false) "Ratio of capacity flow rate at nominal condition";
  parameter Modelica.SIunits.Temperature T_b1_nominal(fixed=false)
    "Nominal temperature at port b1";
  parameter Modelica.SIunits.Temperature T_b2_nominal(fixed=false)
    "Nominal temperature at port b2";
  parameter flo flowRegime_nominal(fixed=false)
    "Heat exchanger flow regime at nominal flow rates";
  flo flowRegime(fixed=false, start=flowRegime_nominal)
    "Heat exchanger flow regime";
initial equation
  assert(m1_flow_nominal > 0,
    "m1_flow_nominal must be positive, m1_flow_nominal = " + String(
    m1_flow_nominal));
  assert(m2_flow_nominal > 0,
    "m2_flow_nominal must be positive, m2_flow_nominal = " + String(
    m2_flow_nominal));
  cp1_nominal = Medium1.specificHeatCapacityCp(Medium1.setState_pTX(
    Medium1.p_default,
    T_a1_nominal,
    Medium1.X_default));
  cp2_nominal = Medium2.specificHeatCapacityCp(Medium2.setState_pTX(
    Medium2.p_default,
    T_a2_nominal,
    Medium2.X_default));
  // heat transfered from fluid 1 to 2 at nominal condition
  Q_flow_nominal = m1_flow_nominal*cp1_nominal*(T_a1_nominal - T_b1_nominal);
  Q_flow_nominal = -m2_flow_nominal*cp2_nominal*(T_a2_nominal - T_b2_nominal);
  C1_flow_nominal = m1_flow_nominal*cp1_nominal;
  C2_flow_nominal = m2_flow_nominal*cp2_nominal;
  CMin_flow_nominal = min(C1_flow_nominal, C2_flow_nominal);
  CMax_flow_nominal = max(C1_flow_nominal, C2_flow_nominal);
  Z_nominal = CMin_flow_nominal/CMax_flow_nominal;
  eps_nominal = abs(Q_flow_nominal/((T_a1_nominal - T_a2_nominal)*
    CMin_flow_nominal));
  assert(eps_nominal > 0 and eps_nominal < 1,
    "eps_nominal out of bounds, eps_nominal = " + String(eps_nominal) +
    "\n  To achieve the required heat transfer rate at epsilon=0.8, set |T_a1_nominal-T_a2_nominal| = "
     + String(abs(Q_flow_nominal/0.8*CMin_flow_nominal)) +
    "\n  or increase flow rates. The current parameters result in " +
    "\n  CMin_flow_nominal = " + String(CMin_flow_nominal) +
    "\n  CMax_flow_nominal = " + String(CMax_flow_nominal));
  // Assign the flow regime for the given heat exchanger configuration and capacity flow rates
  if (configuration == con.CrossFlowStream1MixedStream2Unmixed) then
    flowRegime_nominal = if (C1_flow_nominal < C2_flow_nominal) then flo.CrossFlowCMinMixedCMaxUnmixed
       else flo.CrossFlowCMinUnmixedCMaxMixed;
  elseif (configuration == con.CrossFlowStream1UnmixedStream2Mixed) then
    flowRegime_nominal = if (C1_flow_nominal < C2_flow_nominal) then flo.CrossFlowCMinUnmixedCMaxMixed
       else flo.CrossFlowCMinMixedCMaxUnmixed;
  elseif (configuration == con.ParallelFlow) then
    flowRegime_nominal = flo.ParallelFlow;
  elseif (configuration == con.CounterFlow) then
    flowRegime_nominal = flo.CounterFlow;
  elseif (configuration == con.CrossFlowUnmixed) then
    flowRegime_nominal = flo.CrossFlowUnmixed;
  else
    flowRegime_nominal = 0;
    assert(configuration > 0 and configuration < 6,
      "Invalid heat exchanger configuration.");
  end if;
  // The equation sorter of Dymola 7.3 does not guarantee that the above assert is tested prior to the
  // function call on the next line. Thus, we add the test on eps_nominal to avoid an error in ntu_epsilonZ
  // for invalid input arguments
  NTU_nominal = if (eps_nominal > 0 and eps_nominal < 1) then
    Buildings.Fluid.HeatExchangers.BaseClasses.ntu_epsilonZ(
    eps=eps_nominal,
    Z=Z_nominal,
    flowRegime=flowRegime_nominal) else 0;
  UA_nominal = NTU_nominal*CMin_flow_nominal;
equation
  // Assign the flow regime for the given heat exchanger configuration and capacity flow rates
  if (configuration == con.ParallelFlow) then
    flowRegime = if (C1_flow*C2_flow >= 0) then flo.ParallelFlow else flo.CounterFlow;
  elseif (configuration == con.CounterFlow) then
    flowRegime = if (C1_flow*C2_flow >= 0) then flo.CounterFlow else flo.ParallelFlow;
  elseif (configuration == con.CrossFlowUnmixed) then
    flowRegime = flo.CrossFlowUnmixed;
  elseif (configuration == con.CrossFlowStream1MixedStream2Unmixed) then
    flowRegime = if (C1_flow < C2_flow) then flo.CrossFlowCMinMixedCMaxUnmixed
       else flo.CrossFlowCMinUnmixedCMaxMixed;
  else
    // have ( configuration == con.CrossFlowStream1UnmixedStream2Mixed)
    flowRegime = if (C1_flow < C2_flow) then flo.CrossFlowCMinUnmixedCMaxMixed
       else flo.CrossFlowCMinMixedCMaxUnmixed;
  end if;
  // Convective heat transfer coefficient
  hA.m1_flow = m1_flow;
  hA.m2_flow = m2_flow;
  hA.T_1 = T_in1;
  hA.T_2 = T_in2;
  UA = 1/(1/hA.hA_1 + 1/hA.hA_2);
  // effectiveness
  (eps,Z) = Buildings.Fluid.HeatExchangers.BaseClasses.epsilon_C(
    UA=UA,
    C1_flow=C1_flow,
    C2_flow=C2_flow,
    flowRegime=flowRegime,
    CMin_flow_nominal=CMin_flow_nominal,
    CMax_flow_nominal=CMax_flow_nominal,
    delta=delta);
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics={Rectangle(
          extent={{-70,78},{70,-82}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid)}),
    preferredView="info",
defaultComponentName="hex",
    Documentation(info="<html>
<p>
Model of a heat exchanger without humidity condensation. 
This model transfers heat in the amount of 
</p>
<p align=\"center\" style=\"font-style:italic;\">
  Q = Q<sub>max</sub>  &epsilon;<br/>
  &epsilon; = f(NTU, Z, flowRegime),
</p>
<p>
where
<i>Q<sub>max</sub></i> is the maximum heat that can be transferred,
<i>&epsilon;</i> is the heat transfer effectiveness, 
<i>NTU</i> is the Number of Transfer Units,
<i>Z</i> is the ratio of minimum to maximum capacity flow rate and
<i>flowRegime</i> is the heat exchanger flow regime.
such as
parallel flow, cross flow or counter flow.
</p>
<p>
The flow regimes depend on the heat exchanger configuration. All configurations
defined in
<a href=\"modelica://Buildings.Fluid.Types.HeatExchangerConfiguration\">
Buildings.Fluid.Types.HeatExchangerConfiguration</a>
are supported.
</p>
<p>
For a heat and moisture exchanger, use
<a href=\"modelica://Buildings.Fluid.MassExchangers.ConstantEffectiveness\">
Buildings.Fluid.MassExchangers.ConstantEffectiveness</a>
instead of this model.
</p>
</html>", revisions="<html>
<ul>
<li>
July 30, 2013 by Michael Wetter:<br/>
Updated model to use new variable <code>mWat_flow</code>
in the base class.
</li>
<li>
February 12, 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}})));
end DryEffectivenessNTU;
