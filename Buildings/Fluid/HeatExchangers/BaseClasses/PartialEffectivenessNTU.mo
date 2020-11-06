within Buildings.Fluid.HeatExchangers.BaseClasses;
model PartialEffectivenessNTU
  "Partial model for heat exchanger with effectiveness - NTU relation and no moisture condensation"
  extends Buildings.Fluid.HeatExchangers.BaseClasses.PartialEffectiveness(
      sensibleOnly1=true,
      sensibleOnly2=true,
      Q1_flow = eps*QMax_flow,
      Q2_flow = -Q1_flow,
      mWat1_flow = if sensibleOnly1 then 0 else Q1_flow*(cp1Wet-Medium1.specificHeatCapacityCp(state_a1_inflow))/cp1Wet/h_fg,
      mWat2_flow = if sensibleOnly2 then 0 else Q2_flow*(cp2Wet-Medium2.specificHeatCapacityCp(state_a2_inflow))/cp2Wet/h_fg,
      C1_flow=abs(m1_flow)*cp1Wet,
      C2_flow=abs(m2_flow)*cp2Wet);
  import con = Buildings.Fluid.Types.HeatExchangerConfiguration;
  import flo = Buildings.Fluid.Types.HeatExchangerFlowRegime;

  parameter con configuration "Heat exchanger configuration"
    annotation (Evaluate=true);

  parameter Boolean use_Q_flow_nominal = true
    "Set to true to specify Q_flow_nominal and temperatures, or to false to specify effectiveness"
    annotation (Evaluate=true,
                Dialog(group="Nominal thermal performance"));

  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal(fixed=use_Q_flow_nominal)
    "Nominal heat transfer"
    annotation (Dialog(group="Nominal thermal performance",
                       enable=use_Q_flow_nominal));

  parameter Modelica.SIunits.Temperature T_a1_nominal(fixed=use_Q_flow_nominal)
    "Nominal temperature at port a1"
    annotation (Dialog(group="Nominal thermal performance",
                       enable=use_Q_flow_nominal));
  parameter Modelica.SIunits.MassFraction X_w1_nominal(min=0,start=0)
    "Absolute humidity of inlet at nominal condition"
    annotation (Dialog(group="Nominal thermal performance",
                       enable=not sensibleOnly1));
  parameter Modelica.SIunits.Temperature T_a2_nominal(fixed=use_Q_flow_nominal)
    "Nominal temperature at port a2"
    annotation (Dialog(group="Nominal thermal performance",
                       enable=use_Q_flow_nominal));
  parameter Modelica.SIunits.MassFraction X_w2_nominal(min=0,start=0)
    "Absolute humidity of inlet at nominal condition"
    annotation (Dialog(group="Nominal thermal performance",
                       enable=not sensibleOnly2));

  parameter Real eps_nominal(fixed=not use_Q_flow_nominal)
    "Nominal heat transfer effectiveness"
    annotation (Dialog(group="Nominal thermal performance",
                       enable=not use_Q_flow_nominal));

  input Modelica.SIunits.ThermalConductance UA "UA value";

  Real eps(min=0, max=1) "Heat exchanger effectiveness";

  // NTU has been removed as NTU goes to infinity as CMin goes to zero.
  // This quantity is not good for modeling.
  //  Real NTU(min=0) "Number of transfer units";
  final parameter Modelica.SIunits.ThermalConductance UA_nominal(fixed=false)
    "Nominal UA value";
  final parameter Real NTU_nominal(min=0, fixed=false)
    "Nominal number of transfer units";

protected
  final parameter Modelica.SIunits.SpecificEnthalpy h_fg=
    Buildings.Utilities.Psychrometrics.Constants.h_fg
    "Heat of evaporation of water";
  final parameter Medium1.ThermodynamicState sta1_nominal = Medium1.setState_pTX(
     T=T_a1_nominal,
     p=Medium1.p_default,
     X={X_w1_nominal, 1-X_w1_nominal}) "Default state for medium 1";
  final parameter Medium2.ThermodynamicState sta2_nominal = Medium2.setState_pTX(
     T=T_a2_nominal,
     p=Medium2.p_default,
     X={X_w2_nominal, 1-X_w2_nominal}) "Default state for medium 2";

  final parameter Medium1.ThermodynamicState sta1_default = Medium1.setState_pTX(
     T=Medium1.T_default,
     p=Medium1.p_default,
     X=Medium1.X_default[1:Medium1.nXi]) "Default state for medium 1";
  final parameter Medium2.ThermodynamicState sta2_default = Medium2.setState_pTX(
     T=Medium1.T_default,
     p=Medium2.p_default,
     X=Medium2.X_default[1:Medium2.nXi]) "Default state for medium 2";

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
  parameter Modelica.SIunits.MassFraction xSat1_nominal=
    Buildings.Utilities.Psychrometrics.Functions.X_pTphi(p=Medium1.p_default, T=T_a2_nominal, phi = 1)
    "Absolute humidity of outlet at saturation condition";
  parameter Modelica.SIunits.MassFraction xSat2_nominal=
    Buildings.Utilities.Psychrometrics.Functions.X_pTphi(p=Medium2.p_default, T=T_a1_nominal, phi = 1)
    "Absolute humidity of outlet at saturation condition";
  parameter flo flowRegime_nominal(fixed=false)
    "Heat exchanger flow regime at nominal flow rates";

  parameter Modelica.SIunits.SpecificEnthalpy h_b1_max_nominal=
    if sensibleOnly1
    then 0
    else
      Buildings.Media.Air.specificEnthalpy_pTX(
      T= T_a2_nominal,
      p=Medium1.p_default,
      X={min(xSat1_nominal,X_w1_nominal)})
      "Outlet air enthalpy of Medium1";
  parameter Modelica.SIunits.SpecificEnthalpy h_b2_max_nominal=
    if sensibleOnly2
    then 0
    else
      Buildings.Media.Air.specificEnthalpy_pTX(
      T= T_a1_nominal,
      p=Medium2.p_default,
      X={min(xSat2_nominal,X_w2_nominal)})
      "Outlet air enthalpy of Medium2";

  flo flowRegime(fixed=false, start=flowRegime_nominal)
    "Heat exchanger flow regime";

  // todo: bidirectional flow
  Modelica.SIunits.SpecificHeatCapacity cp1Wet=
    if sensibleOnly1
    then cp1_nominal
    else max((inStream(port_a1.h_outflow) - h_b1_max) * Buildings.Utilities.Math.Functions.inverseXRegularized(T_in1 - T_in2, delta=1e-2),
      Medium1.specificHeatCapacityCp(state_a1_inflow))
      "Heat capacity used in the ficticious fluid when condensation occurs in Medium1, according to Braun-Lebrun model";
  Modelica.SIunits.SpecificHeatCapacity cp2Wet=
    if sensibleOnly2
    then cp2_nominal
    else max((inStream(port_a2.h_outflow) - h_b2_max) *Buildings.Utilities.Math.Functions.inverseXRegularized(T_in2 - T_in1, delta=1e-2),
      Medium2.specificHeatCapacityCp(state_a2_inflow))
      "Heat capacity used in the ficticious fluid when condensation occurs in Medium2, according to Braun-Lebrun model";

  Modelica.SIunits.SpecificEnthalpy h_b1_max=
    if sensibleOnly1
    then 0
    else Buildings.Media.Air.specificEnthalpy_pTX(
      T= T_in2,
      p=port_b1.p,
      X={min(xSat1, inStream(port_a1.Xi_outflow[1]))})
      "Outlet air enthalpy of Medium1 for perfect heat exchange";
  Modelica.SIunits.SpecificEnthalpy h_b2_max=
    if sensibleOnly2
    then 0
    else Buildings.Media.Air.specificEnthalpy_pTX(
      T= T_in1,
      p=port_b2.p,
      X={min(xSat2, inStream(port_a2.Xi_outflow[1]))})
      "Outlet air enthalpy of Medium2 for perfect heat exchange";

  Modelica.SIunits.MassFraction xSat1=
    if sensibleOnly1
    then 0
    else Buildings.Utilities.Psychrometrics.Functions.X_pTphi(p=port_b1.p, T=T_in2, phi = 1)
      "Absolute humidity assuming saturated outlet condition for medium 1";
  Modelica.SIunits.MassFraction xSat2=
    if sensibleOnly2
    then 0
    else Buildings.Utilities.Psychrometrics.Functions.X_pTphi(p=port_b2.p, T=T_in1, phi = 1)
      "Absolute humidity assuming saturated outlet condition for medium 2";

  Real QLat1 = mWat1_flow*h_fg "Latent heat extracted from medium 1";
initial equation
  assert(m1_flow_nominal > 0,
    "m1_flow_nominal must be positive, m1_flow_nominal = " + String(
    m1_flow_nominal));
  assert(m2_flow_nominal > 0,
    "m2_flow_nominal must be positive, m2_flow_nominal = " + String(
    m2_flow_nominal));

  // fixme: I don't understand these assignments: state_a1_inflow changes with
  // time, yet it is assigned to cp1_nominal, and evaluated in an 'initial equation' section.
  cp1_nominal = if sensibleOnly1
    then Medium1.specificHeatCapacityCp(sta1_nominal)
    else max((Medium1.specificEnthalpy(state_a1_inflow) - h_b1_max_nominal)
        *Buildings.Utilities.Math.Functions.inverseXRegularized(
          T_a1_nominal - T_a2_nominal, delta=1e-2),
          Medium1.specificHeatCapacityCp(sta1_nominal));
  cp2_nominal = if sensibleOnly2
    then Medium2.specificHeatCapacityCp(sta2_nominal)
    else max((Medium2.specificEnthalpy(state_a2_inflow) - h_b2_max_nominal)
        *Buildings.Utilities.Math.Functions.inverseXRegularized(
          T_a2_nominal - T_a1_nominal, delta=1e-2),
          Medium2.specificHeatCapacityCp(sta2_nominal));

  // Heat transferred from fluid 1 to 2 at nominal condition
  C1_flow_nominal = m1_flow_nominal*cp1_nominal;
  C2_flow_nominal = m2_flow_nominal*cp2_nominal;
  CMin_flow_nominal = min(C1_flow_nominal, C2_flow_nominal);
  CMax_flow_nominal = max(C1_flow_nominal, C2_flow_nominal);
  Z_nominal = CMin_flow_nominal/CMax_flow_nominal;

  Q_flow_nominal = m1_flow_nominal*cp1_nominal*(T_a1_nominal - T_b1_nominal);
  if use_Q_flow_nominal then
    Q_flow_nominal = -m2_flow_nominal*cp2_nominal*(T_a2_nominal - T_b2_nominal);
    eps_nominal = abs(Q_flow_nominal/((T_a1_nominal - T_a2_nominal)*
      CMin_flow_nominal));
  else
    T_a1_nominal = Medium1.T_default;
    T_a2_nominal = Medium2.T_default;
    T_b1_nominal = Medium1.T_default;
    T_b2_nominal = Medium2.T_default;
  end if;
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
    // Invalid flow regime. Assign a value to flowRegime_nominal, and stop with an assert
    flowRegime_nominal = flo.CrossFlowUnmixed;
    assert(configuration >= con.ParallelFlow and configuration <= con.CrossFlowStream1UnmixedStream2Mixed,
      "Invalid heat exchanger configuration.");
  end if;
  // The equation sorter of Dymola 7.3 does not guarantee that the above assert is tested prior to the
  // function call on the next line. Thus, we add the test on eps_nominal to avoid an error in ntu_epsilonZ
  // for invalid input arguments
  NTU_nominal = if (eps_nominal > 0 and eps_nominal < 1) then
    Buildings.Fluid.HeatExchangers.BaseClasses.ntu_epsilonZ(
    eps=eps_nominal,
    Z=Z_nominal,
    flowRegime=Integer(flowRegime_nominal)) else 0;
  UA_nominal = NTU_nominal*CMin_flow_nominal;

  if not sensibleOnly1 then
      assert(Buildings.Utilities.Psychrometrics.Functions.phi_pTX(
        p=Medium1.p_default,
       T=T_a1_nominal,
       X_w=X_w1_nominal) <= 1, "In " + getInstanceName() +
       ": The nominal inlet temperature of " +String(T_a1_nominal) +
       " K and the nominal inlet absolute humidity of " +String(X_w1_nominal) +
       " kg/kg result in a relative humidity of "
          + String(100*Buildings.Utilities.Psychrometrics.Functions.phi_pTX(
       p=Medium1.p_default,
       T=T_a1_nominal,
       X_w=X_w1_nominal))+
    " %, which is larger than 100 %. This is non-physical.");
  end if;

  if not sensibleOnly2 then
    assert(Buildings.Utilities.Psychrometrics.Functions.phi_pTX(
       p=Medium2.p_default,
       T=T_a2_nominal,
       X_w=X_w2_nominal) <= 1, "In " + getInstanceName() +
       ": The nominal inlet temperature of " +String(T_a2_nominal) +
       " K and the nominal inlet absolute humidity of " +String(X_w2_nominal) +
       " kg/kg result in a relative humidity of "
       + String(100*Buildings.Utilities.Psychrometrics.Functions.phi_pTX(
       p=Medium2.p_default,
       T=T_a2_nominal,
       X_w=X_w2_nominal))+
       " %, which is larger than 100 %. This is non-physical.");
  end if;
  // todo: check using substance names
  assert(sensibleOnly1 or Medium1.nXi > 0,
    "In "+getInstanceName() + ": The model computes condensation in air,
    but uses a medium that contains no water. Choose a different medium.");
  assert(sensibleOnly2 or Medium2.nXi > 0,
    "In "+getInstanceName() + ": The model computes condensation in air,
    but uses a medium that contains no water. Choose a different medium.");

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

  // Effectiveness
  eps = Buildings.Fluid.HeatExchangers.BaseClasses.epsilon_C(
    UA=UA,
    C1_flow=C1_flow,
    C2_flow=C2_flow,
    flowRegime=Integer(flowRegime),
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
defaultComponentName="hex",
    Documentation(info="<html>
<p>
Partial model of a heat exchanger without humidity condensation.
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
<a href=\"modelica://IBPSA.Fluid.Types.HeatExchangerConfiguration\">
IBPSA.Fluid.Types.HeatExchangerConfiguration</a>
are supported.
</p>
<p>
Models that extend from this partial model need to provide an assignment
for <code>UA</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
January 10, 2018 by Michael Wetter:<br/>
Removed variable <code>Z</code> that is not used.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1328\">issue 1328</a>.
</li>
<li>
January 10, 2018 by Filip Jorissen:<br/>
Corrected an error where the value of NTU was assigned to Z.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1328\">issue 1328</a>.
</li>
<li>
February 27, 2016 by Michael Wetter:<br/>
Introduced <code>sta1_default</code> and <code>sta2_default</code>
to enable translation under OpenModelica.
Removed <code>max=1</code> attribute for <code>Z</code>. This is needed as near
zero flow, <code>Z</code> can be larger than one due to the regularization.
As <code>Z</code> is not used in this model other than for reporting, this bound
need not be enforced (and the calculation of <code>eps</code> is fine at these small flow rates).
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/490\">issue 490</a>.
</li>
<li>
April 29, 2014 by Michael Wetter:<br/>
Changed <code>assert</code> statement to avoid comparing
enumeration with an integer, which triggers a warning
in Dymola 2015.
</li>
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
</html>"));
end PartialEffectivenessNTU;
