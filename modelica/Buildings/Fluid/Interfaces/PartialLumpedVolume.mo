within Buildings.Fluid.Interfaces;
partial model PartialLumpedVolume "Lumped volume with mass and energy balance"
  import Modelica.Fluid.Types;
  import Modelica.Fluid.Types.Dynamics;

  outer Modelica.Fluid.System system "System properties";
  replaceable package Medium =
    Modelica.Media.Interfaces.PartialMedium "Medium in the component"
      annotation (choicesAllMatching = true);

  // Inputs provided to the volume model
  input Modelica.SIunits.Volume fluidVolume "Volume";

  // Assumptions
  parameter Types.Dynamics energyDynamics=system.energyDynamics
    "Formulation of energy balance"
    annotation(Evaluate=true, Dialog(tab = "Assumptions", group="Dynamics"));
  parameter Types.Dynamics massDynamics=system.massDynamics
    "Formulation of mass balance"
    annotation(Evaluate=true, Dialog(tab = "Assumptions", group="Dynamics"));
  parameter Types.Dynamics substanceDynamics=energyDynamics
    "Formulation of substance balance"
    annotation(Evaluate=true, Dialog(tab = "Assumptions", group="Dynamics"));
  parameter Types.Dynamics traceDynamics=energyDynamics
    "Formulation of trace substance balance"
    annotation(Evaluate=true, Dialog(tab = "Assumptions", group="Dynamics"));

  // Initialization
  parameter Medium.AbsolutePressure p_start = Medium.p_default
    "Start value of pressure"
    annotation(Dialog(tab = "Initialization"));
  parameter Boolean use_T_start = true "= true, use T_start, otherwise h_start"
    annotation(Dialog(tab = "Initialization"), Evaluate=true);
  parameter Medium.Temperature T_start=
    if use_T_start then system.T_start else Medium.temperature_phX(p_start,h_start,X_start)
    "Start value of temperature"
    annotation(Dialog(tab = "Initialization", enable = use_T_start));
  parameter Medium.SpecificEnthalpy h_start=
    if use_T_start then Medium.specificEnthalpy_pTX(p_start, T_start, X_start) else Medium.h_default
    "Start value of specific enthalpy"
    annotation(Dialog(tab = "Initialization", enable = not use_T_start));
  parameter Medium.MassFraction X_start[Medium.nX] = Medium.X_default
    "Start value of mass fractions m_i/m"
    annotation (Dialog(tab="Initialization", enable=Medium.nXi > 0));
  parameter Medium.ExtraProperty C_start[Medium.nC](
       quantity=Medium.extraPropertiesNames)=fill(0, Medium.nC)
    "Start value of trace substances"
    annotation (Dialog(tab="Initialization", enable=Medium.nC > 0));
  parameter Medium.ExtraProperty C_nominal[Medium.nC](
       quantity=Medium.extraPropertiesNames) = fill(1E-6, Medium.nC)
    "Nominal value of trace substances. (Set to typical order of magnitude.)"
   annotation (Dialog(tab="Initialization", enable=Medium.nC > 0));
  Medium.BaseProperties medium(
    preferredMediumStates=true,
    p(start=p_start),
    h(start=h_start),
    T(start=T_start),
    Xi(start=X_start[1:Medium.nXi],
       nominal=Medium.X_default));
  //  X(start=X_start[1:Medium.nX]),
  Modelica.SIunits.Energy U "Internal energy of fluid";
  Modelica.SIunits.Mass m "Mass of fluid";
  Modelica.SIunits.Mass[Medium.nXi] mXi
    "Masses of independent components in the fluid";
  Modelica.SIunits.Mass[Medium.nC] mC "Masses of trace substances in the fluid";
  // C need to be added here because unlike for Xi, which has medium.Xi,
  // there is no variable medium.C
  Medium.ExtraProperty C[Medium.nC](nominal=C_nominal)
    "Trace substance mixture content";

  // variables that need to be defined by an extending class
  Modelica.SIunits.MassFlowRate mb_flow "Mass flows across boundaries";
  Modelica.SIunits.MassFlowRate[Medium.nXi] mbXi_flow
    "Substance mass flows across boundaries";
  Medium.ExtraPropertyFlowRate[Medium.nC] mbC_flow
    "Trace substance mass flows across boundaries";
  Modelica.SIunits.EnthalpyFlowRate Hb_flow
    "Enthalpy flow across boundaries or energy source/sink";
  Modelica.SIunits.HeatFlowRate Qb_flow
    "Heat flow across boundaries or energy source/sink";
protected
  parameter Boolean initialize_p = not Medium.singleState
    "= true to set up initial equations for pressure";
equation
/* statement from original model  
   assert(not (energyDynamics<>Dynamics.SteadyState and massDynamics==Dynamics.SteadyState) or Medium.singleState,
    "Bad combination of dynamics options and Medium not conserving mass if fluidVolume is fixed.");
*/

  // Total quantities
  m = fluidVolume*medium.d;
  mXi = m*medium.Xi;
  U = m*medium.u;
  mC = m*C;

  // Energy and mass balances
  if energyDynamics == Dynamics.SteadyState then
    0 = Hb_flow + Qb_flow;
  else
    der(U) = Hb_flow + Qb_flow;
  end if;

  if massDynamics == Dynamics.SteadyState then
    0 = mb_flow;
  else
    der(m) = mb_flow;
  end if;

  if substanceDynamics == Dynamics.SteadyState then
    zeros(Medium.nXi) = mbXi_flow;
  else
    der(mXi) = mbXi_flow;
  end if;

  if traceDynamics == Dynamics.SteadyState then
    zeros(Medium.nC)  = mbC_flow;
  else
    der(mC)  = mbC_flow;
  end if;

initial equation
  // initialization of balances
  if energyDynamics == Dynamics.FixedInitial then
    if use_T_start then
      medium.T = T_start;
    else
      medium.h = h_start;
    end if;
  elseif energyDynamics == Dynamics.SteadyStateInitial then
    if use_T_start then
      der(medium.T) = 0;
    else
      der(medium.h) = 0;
    end if;
  end if;

  if massDynamics == Dynamics.FixedInitial then
    if initialize_p then
      medium.p = p_start;
    end if;
  elseif massDynamics == Dynamics.SteadyStateInitial then
    if initialize_p then
      der(medium.p) = 0;
    end if;
  end if;

  if substanceDynamics == Dynamics.FixedInitial then
    medium.Xi = X_start[1:Medium.nXi];
  elseif substanceDynamics == Dynamics.SteadyStateInitial then
    der(medium.Xi) = zeros(Medium.nXi);
  end if;

  if traceDynamics == Dynamics.FixedInitial then
    C = C_start[1:Medium.nC];
  elseif traceDynamics == Dynamics.SteadyStateInitial then
    der(C) = zeros(Medium.nC);
  end if;

  annotation (
    Documentation(info="<html>
<p>Interface and base class for an ideally mixed fluid volume with the ability to store mass and energy. 
An extending class must specify an equation for
<b>Qb_flow</b>, e.g. convective or latent heat flow rate across the boundary.
</p>
The component volume <b>fluidVolume</b> is an input that needs to be set in the extending class to complete the model. </pre>
<p>Further source terms must be defined by an extending class for fluid flow across the segment boundary: </p>
<p><ul>
<li><pre><b>Hb_flow</b></pre>, enthalpy flow,</li>
<li><pre><b>mb_flow</b></pre>, mass flow,</li>
<li><pre><b>mbXi_flow</b></pre>, substance mass flow, and</li>
<li><pre><b>mbC_flow</b></pre>, trace substance mass flow.</li>
</ul></p>
<p>
<b>Note:</b> This model is similar to 
<a href=\"modelica://Modelica.Fluid.Interfaces.PartialLumpedVolume\">
Modelica.Fluid.Interfaces.PartialLumpedVolume</a>, except for 
<ul>
<li>the assert statement, which 
has been removed in this model
<li>the <code>final</code> keyword for
the declaration of the the substance and trace substance balance.
</ul>
These modifications have been made to allow modeling the air humidity using
a differential equation, while modeling the total mass balance as a steady-state
equation.
</html>", revisions="<html>
<ul>
<li>
July 30, 2010 by Michael Wetter:<br>
Added parameter <code>C_nominal</code> which is used as the nominal attribute for <code>C</code>.
Without this value, the ODE solver gives wrong results for concentrations around 1E-7.
</li>
<li>
March 21, 2010 by Michael Wetter:<br>
Changed pressure start value from <code>system.p_start</code>
to <code>Medium.p_default</code> since HVAC models may have water and 
air, which are typically at different pressures.
</li>
<li><i>February 6, 2010</i> by Michael Wetter:<br>
Added to <code>Medium.BaseProperties</code> the initialization 
<code>X(start=X_start[1:Medium.nX])</code>. Previously, the initialization
was only done for <code>Xi</code> but not for <code>X</code>, which caused the
medium to be initialized to <code>reference_X</code>, ignoring the value of <code>X_start</code>.
</li>
<li><i>October 12, 2009</i> by Michael Wetter:<br>
Implemented first version in <code>Buildings</code> library, based on model from
<code>Modelica.Fluid 1.0</code>.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{
            100,100}}),
            graphics));
end PartialLumpedVolume;
