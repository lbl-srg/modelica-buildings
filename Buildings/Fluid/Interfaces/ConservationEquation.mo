within Buildings.Fluid.Interfaces;
model ConservationEquation "Lumped volume with mass and energy balance"

  extends Buildings.Fluid.Interfaces.LumpedVolumeDeclarations;

  // Constants
  parameter Boolean initialize_p = not Medium.singleState
    "= true to set up initial equations for pressure"
    annotation(HideResult=true, Evaluate=true, Dialog(tab="Advanced"));

  constant Boolean simplify_mWat_flow = true
    "Set to true to cause port_a.m_flow + port_b.m_flow = 0 even if mWat_flow is non-zero. Used only if Medium.nX > 1";

  // Port definitions
  parameter Integer nPorts=0 "Number of ports"
    annotation(Evaluate=true, Dialog(connectorSizing=true, tab="General",group="Ports"));

  parameter Boolean use_mWat_flow = false
    "Set to true to enable input connector for moisture mass flow rate"
    annotation(Evaluate=true, Dialog(tab="Advanced"));
  parameter Boolean use_C_flow = false
    "Set to true to enable input connector for trace substance"
    annotation(Evaluate=true, Dialog(tab="Advanced"));

  Modelica.Blocks.Interfaces.RealInput Q_flow(unit="W")
    "Sensible plus latent heat flow rate transferred into the medium"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.RealInput mWat_flow(final quantity="MassFlowRate",
                                                 unit="kg/s") if
       use_mWat_flow "Moisture mass flow rate added to the medium"
    annotation (Placement(transformation(extent={{-140,0},{-100,40}})));
  Modelica.Blocks.Interfaces.RealInput[Medium.nC] C_flow if
       use_C_flow "Trace substance mass flow rate added to the medium"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));

  // Outputs that are needed in models that use this model
  Modelica.Blocks.Interfaces.RealOutput hOut(unit="J/kg",
                                             start=hStart)
    "Leaving specific enthalpy of the component"
     annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-50,110})));
  Modelica.Blocks.Interfaces.RealOutput XiOut[Medium.nXi](each unit="1",
                                                          each min=0,
                                                          each max=1)
    "Leaving species concentration of the component"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,110})));
  Modelica.Blocks.Interfaces.RealOutput COut[Medium.nC](each min=0)
    "Leaving trace substances of the component"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={50,110})));
  Modelica.Blocks.Interfaces.RealOutput UOut(unit="J")
    "Internal energy of the component" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        origin={110,20})));
  Modelica.Blocks.Interfaces.RealOutput mXiOut[Medium.nXi](each min=0, each unit=
       "kg") "Species mass of the component"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        origin={110,-20})));
  Modelica.Blocks.Interfaces.RealOutput mOut(min=0, unit="kg")
    "Mass of the component" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        origin={110,60})));
  Modelica.Blocks.Interfaces.RealOutput mCOut[Medium.nC](each min=0, each unit="kg")
    "Trace substance mass of the component"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        origin={110,-60})));

  Modelica.Fluid.Vessels.BaseClasses.VesselFluidPorts_b ports[nPorts](
      redeclare each final package Medium = Medium) "Fluid inlets and outlets"
    annotation (Placement(transformation(extent={{-40,-10},{40,10}},
      origin={0,-100})));

  // Set nominal attributes where literal values can be used.
  Medium.BaseProperties medium(
    p(start=p_start),
    h(start=hStart),
    T(start=T_start),
    Xi(start=X_start[1:Medium.nXi]),
    X(start=X_start),
    d(start=rho_start)) "Medium properties";

  Modelica.SIunits.Energy U(start=fluidVolume*rho_start*
    Medium.specificInternalEnergy(Medium.setState_pTX(
     T=T_start,
     p=p_start,
     X=X_start[1:Medium.nXi])) +
    (T_start - Medium.reference_T)*CSen,
    nominal = 1E5) "Internal energy of fluid";

  Modelica.SIunits.Mass m(
    start=fluidVolume*rho_start,
    stateSelect=if massDynamics == Modelica.Fluid.Types.Dynamics.SteadyState
    then StateSelect.default else StateSelect.prefer)
    "Mass of fluid";

  Modelica.SIunits.Mass[Medium.nXi] mXi(
    start=fluidVolume*rho_start*X_start[1:Medium.nXi])
    "Masses of independent components in the fluid";
  Modelica.SIunits.Mass[Medium.nC] mC(
    start=fluidVolume*rho_start*C_start)
    "Masses of trace substances in the fluid";
  // C need to be added here because unlike for Xi, which has medium.Xi,
  // there is no variable medium.C
  Medium.ExtraProperty C[Medium.nC](nominal=C_nominal)
    "Trace substance mixture content";

  Modelica.SIunits.MassFlowRate mb_flow "Mass flows across boundaries";
  Modelica.SIunits.MassFlowRate[Medium.nXi] mbXi_flow
    "Substance mass flows across boundaries";
  Medium.ExtraPropertyFlowRate[Medium.nC] mbC_flow
    "Trace substance mass flows across boundaries";
  Modelica.SIunits.EnthalpyFlowRate Hb_flow
    "Enthalpy flow across boundaries or energy source/sink";

  // Parameters that need to be defined by an extending class
  parameter Modelica.SIunits.Volume fluidVolume "Volume";
  final parameter Modelica.SIunits.HeatCapacity CSen=
    (mSenFac - 1)*rho_default*cp_default*fluidVolume
    "Aditional heat capacity for implementing mFactor";
protected
  Medium.EnthalpyFlowRate ports_H_flow[nPorts];
  Modelica.SIunits.MassFlowRate ports_mXi_flow[nPorts,Medium.nXi];
  Medium.ExtraPropertyFlowRate ports_mC_flow[nPorts,Medium.nC];
  parameter Modelica.SIunits.SpecificHeatCapacity cp_default=
  Medium.specificHeatCapacityCp(state=state_default)
    "Heat capacity, to compute additional dry mass";
  parameter Modelica.SIunits.Density rho_start=Medium.density(
   Medium.setState_pTX(
     T=T_start,
     p=p_start,
     X=X_start[1:Medium.nXi])) "Density, used to compute fluid mass";

  // Parameter for avoiding extra overhead calculations when CSen==0
  final parameter Boolean computeCSen = abs(mSenFac-1) > Modelica.Constants.eps
    annotation(Evaluate=true);
  final parameter Medium.ThermodynamicState state_default = Medium.setState_pTX(
      T=Medium.T_default,
      p=Medium.p_default,
      X=Medium.X_default[1:Medium.nXi]) "Medium state at default values";
  // Density at medium default values, used to compute the size of control volumes
  final parameter Modelica.SIunits.Density rho_default=Medium.density(
    state=state_default) "Density, used to compute fluid mass";
  // Parameter that is used to construct the vector mXi_flow
  final parameter Real s[Medium.nXi] = {if Modelica.Utilities.Strings.isEqual(
                                            string1=Medium.substanceNames[i],
                                            string2="Water",
                                            caseSensitive=false)
                                            then 1 else 0 for i in 1:Medium.nXi}
    "Vector with zero everywhere except where species is";
  parameter Modelica.SIunits.SpecificEnthalpy hStart=
    Medium.specificEnthalpy_pTX(p_start, T_start, X_start)
    "Start value for specific enthalpy";

  // Set _simplify_mWat_flow == false for Glycol47; otherwise Dymola 2018FD01
  // cannot differentiate the equations.
  constant Boolean _simplify_mWat_flow = simplify_mWat_flow and Medium.nX > 1
   "If true, then port_a.m_flow + port_b.m_flow = 0 even if mWat_flow is non-zero, and equations are simplified";

  // Conditional connectors
  Modelica.Blocks.Interfaces.RealInput mWat_flow_internal(unit="kg/s")
    "Needed to connect to conditional connector";
  Modelica.Blocks.Interfaces.RealInput C_flow_internal[Medium.nC]
    "Needed to connect to conditional connector";

initial equation
  // Assert that the substance with name 'water' has been found.
  assert(Medium.nXi == 0 or abs(sum(s)-1) < 1e-5,
      "In " + getInstanceName() + ":
         If Medium.nXi > 1, then substance 'water' must be present for one component of '"
         + Medium.mediumName + "'.
         Check medium model.");

  // Make sure that if energyDynamics is SteadyState, then
  // massDynamics is also SteadyState.
  // Otherwise, the system of ordinary differential equations may be inconsistent.
  if energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState then
    assert(massDynamics == energyDynamics, "In " + getInstanceName() + ":
         If 'massDynamics == Modelica.Fluid.Types.Dynamics.SteadyState', then it is
         required that 'energyDynamics==Modelica.Fluid.Types.Dynamics.SteadyState'.
         Otherwise, the system of equations may not be consistent.
         You need to select other parameter values.");
  end if;

  // initialization of balances
  if energyDynamics == Modelica.Fluid.Types.Dynamics.FixedInitial then
      medium.T = T_start;
  else
    if energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyStateInitial then
        der(medium.T) = 0;
    end if;
  end if;

  if massDynamics == Modelica.Fluid.Types.Dynamics.FixedInitial then
    if initialize_p then
      medium.p = p_start;
    end if;
  else
    if massDynamics == Modelica.Fluid.Types.Dynamics.SteadyStateInitial then
      if initialize_p then
        der(medium.p) = 0;
      end if;
    end if;
  end if;

  if substanceDynamics == Modelica.Fluid.Types.Dynamics.FixedInitial then
    medium.Xi = X_start[1:Medium.nXi];
  else
    if substanceDynamics == Modelica.Fluid.Types.Dynamics.SteadyStateInitial then
      der(medium.Xi) = zeros(Medium.nXi);
    end if;
  end if;

  if traceDynamics == Modelica.Fluid.Types.Dynamics.FixedInitial then
    C = C_start[1:Medium.nC];
  else
    if traceDynamics == Modelica.Fluid.Types.Dynamics.SteadyStateInitial then
      der(C) = zeros(Medium.nC);
    end if;
  end if;

equation
  // Conditional connectors
  connect(mWat_flow, mWat_flow_internal);
  if not use_mWat_flow then
    mWat_flow_internal = 0;
  end if;

  connect(C_flow, C_flow_internal);
  if not use_C_flow then
    C_flow_internal = zeros(Medium.nC);
  end if;

  // Total quantities
  if massDynamics == Modelica.Fluid.Types.Dynamics.SteadyState then
    m = fluidVolume*rho_start;
  else
    if _simplify_mWat_flow then
      // If moisture is neglected in mass balance, assume for computation
      // of the mass of air that the air is at Medium.X_default.
      m = fluidVolume*Medium.density(Medium.setState_phX(
        p = medium.p,
        h = hOut,
        X = Medium.X_default));
    else
      // Use actual density
      m = fluidVolume*medium.d;
    end if;
  end if;
  mXi = m*medium.Xi;
  if computeCSen then
    U = m*medium.u + CSen*(medium.T-Medium.reference_T);
  else
    U = m*medium.u;
  end if;
  mC = m*C;

  hOut = medium.h;
  XiOut = medium.Xi;
  COut = C;

  for i in 1:nPorts loop
    //The semiLinear function should be used for the equations below
    //for allowing min/max simplifications.
    //See https://github.com/ibpsa/modelica-ibpsa/issues/216 for a discussion and motivation
    ports_H_flow[i]     = semiLinear(ports[i].m_flow, inStream(ports[i].h_outflow), ports[i].h_outflow)
      "Enthalpy flow";
    for j in 1:Medium.nXi loop
      ports_mXi_flow[i,j] = semiLinear(ports[i].m_flow, inStream(ports[i].Xi_outflow[j]), ports[i].Xi_outflow[j])
        "Component mass flow";
    end for;
    for j in 1:Medium.nC loop
      ports_mC_flow[i,j]  = semiLinear(ports[i].m_flow, inStream(ports[i].C_outflow[j]),  ports[i].C_outflow[j])
        "Trace substance mass flow";
    end for;
  end for;

  for i in 1:Medium.nXi loop
    mbXi_flow[i] = sum(ports_mXi_flow[:,i]);
  end for;

  for i in 1:Medium.nC loop
    mbC_flow[i]  = sum(ports_mC_flow[:,i]);
  end for;

  mb_flow = sum(ports.m_flow);
  Hb_flow = sum(ports_H_flow);

  // Energy and mass balances
  if energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState then
    0 = Hb_flow + Q_flow;
  else
    der(U) = Hb_flow + Q_flow;
  end if;

  if massDynamics == Modelica.Fluid.Types.Dynamics.SteadyState then
    0 = mb_flow + (if simplify_mWat_flow then 0 else mWat_flow_internal);
  else
    der(m) = mb_flow + (if simplify_mWat_flow then 0 else mWat_flow_internal);
  end if;

  if substanceDynamics == Modelica.Fluid.Types.Dynamics.SteadyState then
    zeros(Medium.nXi) = mbXi_flow + mWat_flow_internal * s;
  else
    der(mXi) = mbXi_flow + mWat_flow_internal * s;
  end if;

  if traceDynamics == Modelica.Fluid.Types.Dynamics.SteadyState then
    zeros(Medium.nC)  = mbC_flow + C_flow_internal;
  else
    der(mC)  = mbC_flow + C_flow_internal;
  end if;

  // Properties of outgoing flows
  for i in 1:nPorts loop
      ports[i].p          = medium.p;
      ports[i].h_outflow  = medium.h;
      ports[i].Xi_outflow = medium.Xi;
      ports[i].C_outflow  = C;
  end for;
  UOut=U;
  mXiOut=mXi;
  mOut=m;
  mCOut=mC;
  annotation (
    Documentation(info="<html>
<p>
Basic model for an ideally mixed fluid volume with the ability to store mass and energy.
It implements a dynamic or a steady-state conservation equation for energy and mass fractions.
The model has zero pressure drop between its ports.
</p>
<p>
If the constant <code>simplify_mWat_flow = true</code> then adding
moisture does not increase the mass of the volume or the leaving mass flow rate.
It does however change the mass fraction <code>medium.Xi</code>.
This allows to decouple the moisture balance from the pressure drop equations.
If <code>simplify_mWat_flow = false</code>, then
the outlet mass flow rate is
<i>m<sub>out</sub> = m<sub>in</sub>  (1 + &Delta; X<sub>w</sub>)</i>,
where
<i>&Delta; X<sub>w</sub></i> is the change in water vapor mass
fraction across the component. In this case,
this component couples
the energy calculation to the
pressure drop versus mass flow rate calculations.
However, in typical building HVAC systems,
<i>&Delta; X<sub>w</sub></i> &lt; <i>0.005</i> kg/kg.
Hence, by tolerating a relative error of <i>0.005</i> in the mass balance,
one can decouple these equations.
Decoupling these equations avoids having
to compute the energy balance of the humidifier
and its upstream components when solving for the
pressure drop of downstream components.
Therefore, the default value is <code>simplify_mWat_flow = true</code>.
</p>
<h4>Typical use and important parameters</h4>
<p>
Set the parameter <code>use_mWat_flow_in=true</code> to enable an
input connector for <code>mWat_flow</code>.
Otherwise, the model uses <code>mWat_flow = 0</code>.
</p>
<p>
If the constant <code>simplify_mWat_flow = true</code>, which is its default value,
then the equation
</p>
<pre>
  port_a.m_flow + port_b.m_flow = - mWat_flow;
</pre>
<p>
is simplified as
</p>
<pre>
  port_a.m_flow + port_b.m_flow = 0;
</pre>
<p>
This causes an error in the mass balance of about <i>0.5%</i>, but generally leads to
simpler equations because the pressure drop equations are then decoupled from the
mass exchange in this component.
The model
<a href=\"modelica://Buildings.Fluid.MixingVolumes.Validation.MixingVolumeAdiabaticCooling\">
Buildings.Fluid.MixingVolumes.Validation.MixingVolumeAdiabaticCooling</a>
shows that the relative error on the temperature difference between these
two options of <code>simplify_mWat_flow</code> is less than
<i>0.1%</i>.
</p>

<h4>Implementation</h4>
<p>
When extending or instantiating this model, the input
<code>fluidVolume</code>, which is the actual volume occupied by the fluid,
needs to be assigned.
For most components, this can be set to a parameter.
</p>
Input connectors of the model are
<ul>
<li>
<code>Q_flow</code>, which is the sensible plus latent heat flow rate added to the medium,
</li>
<li>
<code>mWat_flow</code>, which is the moisture mass flow rate added to the medium, and
</li>
<li>
<code>C_flow</code>, which is the trace substance mass flow rate added to the medium.
</li>
</ul>

<p>
The model can be used as a dynamic model or as a steady-state model.
However, for a steady-state model with exactly two fluid ports connected,
the model
<a href=\"modelica://Buildings.Fluid.Interfaces.StaticTwoPortConservationEquation\">
Buildings.Fluid.Interfaces.StaticTwoPortConservationEquation</a>
provides a more efficient implementation.
</p>
<p>
For a model that instantiates this model, see
<a href=\"modelica://Buildings.Fluid.MixingVolumes.MixingVolume\">
Buildings.Fluid.MixingVolumes.MixingVolume</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
April 26, 2019, by Filip Jorissen:<br/>
Returning <code>getInstanceName()</code> in asserts.
This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1133\">1133</a>.
</li>
<li>
April 16, 2019, by Michael Wetter:<br/>
Changed computation of <code>computeCSen</code> to avoid the volume to become
a structural parameter.<br/>
This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1122\">Buildings, issue 1122</a>.
</li>
<li>
April 16, 2018, by Michael Wetter:<br/>
Reformulated mass calculation so that Dymola can differentiate the equations.<br/>
This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/910\">Buildings, issue 910</a>.
</li>
<li>
November 3, 2017, by Michael Wetter:<br/>
Set <code>start</code> attributes.<br/>
This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/727\">727</a>.
</li>
<li>
October 19, 2017, by Michael Wetter:<br/>
Changed initialization of pressure from a <code>constant</code> to a <code>parameter</code>.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1013\">Buildings, issue 1013</a>.
</li>
<li>
January 27, 2017, by Michael Wetter:<br/>
Added <code>stateSelect</code> for mass <code>m</code>.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/642\">
Buildings, #642</a>.
</li>
<li>
December 22, 2016, by Michael Wetter:<br/>
Set nominal value for <code>U</code>.<br/>
This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/637\">637</a>.
</li>
<li>
February 19, 2016 by Filip Jorissen:<br/>
Added outputs UOut, mOut, mXiOut, mCOut for being able to
check conservation of quantities.
This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/247\">
issue 247</a>.
</li>
<li>
January 17, 2016, by Michael Wetter:<br/>
Added parameter <code>use_C_flow</code> and converted <code>C_flow</code>
to a conditionally removed connector.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/372\">#372</a>.
</li>
<li>
December 16, 2015, by Michael Wetter:<br/>
Added <code>C_flow</code> to the steady-state trace substance balance,
and removed the units of <code>C_flow</code> to allow for PPM.
</li>
<li>
December 2, 2015, by Filip Jorissen:<br/>
Added input <code>C_flow</code> and code for handling trace substance insertions.
</li>
<li>
September 3, 2015, by Filip Jorissen and Michael Wetter:<br/>
Revised implementation for allowing moisture mass flow rate
to be approximated using parameter <code>simplify_mWat_flow</code>.
This may lead to smaller algebraic loops.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/247\">#247</a>.
</li>
<li>
July 17, 2015, by Michael Wetter:<br/>
Added constant <code>simplify_mWat_flow</code> to remove dependencies of the pressure drop
calculation on the moisture balance.
</li>
<li>
June 5, 2015 by Michael Wetter:<br/>
Removed <code>preferredMediumStates= false</code> in
the instance <code>medium</code> as the default
is already <code>false</code>.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/260\">#260</a>.
</li>
<li>
June 5, 2015 by Filip Jorissen:<br/>
Removed <pre>
Xi(start=X_start[1:Medium.nXi],
       each stateSelect=if (not (substanceDynamics == Modelica.Fluid.Types.Dynamics.SteadyState))
       then StateSelect.prefer else StateSelect.default),
</pre>
and set
<code>preferredMediumStates = false</code>
because the previous declaration led to more equations and
translation problems in large models.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/260\">#260</a>.
</li>
<li>
June 5, 2015, by Michael Wetter:<br/>
Moved assignment of <code>dynBal.U.start</code>
from instance <code>dynBal</code> of <code>PartialMixingVolume</code>
to this model implementation.
This is required for a pedantic model check in Dymola 2016.
It addresses
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/266\">
issue 266</a>.
This revison also renames the protected variable
<code>rho_nominal</code> to <code>rho_start</code>
as it depends on the start values and not the nominal values.
</li>
<li>
May 22, 2015 by Michael Wetter:<br/>
Removed <pre>
p(stateSelect=if not (massDynamics == Modelica.Fluid.Types.Dynamics.SteadyState)
then StateSelect.prefer else StateSelect.default)
</pre>
because the previous declaration led to the translation error
<pre>
The model requires derivatives of some inputs as listed below:
1 inlet.m_flow
1 inlet.p
</pre>
when translating
<code>Buildings.Fluid.FMI.ExportContainers.Examples.FMUs.HeaterCooler_u</code>
with a dynamic energy balance.
</li>
<li>
May 6, 2015, by Michael Wetter:<br/>
Corrected documentation.
</li>
<li>
April 13, 2015, by Filip Jorissen:<br/>
Now using <code>semiLinear()</code> function for calculation of
<code>ports_H_flow</code>. This enables Dymola to simplify based on
the <code>min</code> and <code>max</code> attribute of the mass flow rate.
</li>
<li>
February 16, 2015, by Filip Jorissen:<br/>
Fixed SteadyState massDynamics implementation for compressible media.
Mass <code>m</code> is now constant.
</li>
<li>
February 5, 2015, by Michael Wetter:<br/>
Changed <code>initalize_p</code> from a <code>parameter</code> to a
<code>constant</code>. This is only required in finite volume models
of heat exchangers (to avoid consistent but redundant initial conditions)
and hence it should be set as a <code>constant</code>.
</li>
<li>
February 3, 2015, by Michael Wetter:<br/>
Removed <code>stateSelect.prefer</code> for temperature.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/160\">#160</a>.
</li>
<li>
October 21, 2014, by Filip Jorissen:<br/>
Added parameter <code>mFactor</code> to increase the thermal capacity.
</li>
<li>
October 6, 2014, by Michael Wetter:<br/>
Changed medium declaration in ports to be final.
</li>
<li>
October 6, 2014, by Michael Wetter:<br/>
Set start attributes in <code>medium</code> to avoid in OpenModelica the warning
alias set with several free start values.
</li>
<li>
October 3, 2014, by Michael Wetter:<br/>
Changed assignment of nominal value to avoid in OpenModelica the warning
alias set with different nominal values.
</li>
<li>
July 3, 2014, by Michael Wetter:<br/>
Added parameter <code>initialize_p</code>. This is required
to enable the coil models to initialize the pressure in the first
volume, but not in the downstream volumes. Otherwise,
the initial equations will be overdetermined, but consistent.
This change was done to avoid a long information message that appears
when translating models.
</li>
<li>
May 29, 2014, by Michael Wetter:<br/>
Removed undesirable annotation <code>Evaluate=true</code>.
</li>
<li>
February 11, 2014 by Michael Wetter:<br/>
Improved documentation for <code>Q_flow</code> input.
</li>
<li>
September 17, 2013 by Michael Wetter:<br/>
Added start value for <code>hOut</code>.
</li>
<li>
September 10, 2013 by Michael Wetter:<br/>
Removed unrequired parameter <code>i_w</code>.<br/>
Corrected the syntax error
<code>Medium.ExtraProperty C[Medium.nC](each nominal=C_nominal)</code>
to
<code>Medium.ExtraProperty C[Medium.nC](nominal=C_nominal)</code>
because <code>C_nominal</code> is a vector.
This syntax error caused a compilation error in OpenModelica.
</li>
<li>
July 30, 2013 by Michael Wetter:<br/>
Changed connector <code>mXi_flow[Medium.nXi]</code>
to a scalar input connector <code>mWat_flow</code>.
The reason is that <code>mXi_flow</code> does not allow
to compute the other components in <code>mX_flow</code> and
therefore leads to an ambiguous use of the model.
By only requesting <code>mWat_flow</code>, the mass balance
and species balance can be implemented correctly.
</li>
<li>
March 27, 2013 by Michael Wetter:<br/>
Removed wrong unit attribute of <code>COut</code>,
and added min and max attributes for <code>XiOut</code>.
</li>
<li>
July 31, 2011 by Michael Wetter:<br/>
Added test to stop model translation if the setting for
<code>energyBalance</code> and <code>massBalance</code>
can lead to inconsistent equations.
</li>
<li>
July 26, 2011 by Michael Wetter:<br/>
Removed the option to use <code>h_start</code>, as this
is not needed for building simulation.
Also removed the reference to <code>Modelica.Fluid.System</code>.
Moved parameters and medium to
<a href=\"Buildings.Fluid.Interfaces.LumpedVolumeDeclarations\">
Buildings.Fluid.Interfaces.LumpedVolumeDeclarations</a>.
</li>
<li>
July 14, 2011 by Michael Wetter:<br/>
Added start value for medium density.
</li>
<li>
March 29, 2011 by Michael Wetter:<br/>
Changed default value for <code>substanceDynamics</code> and
<code>traceDynamics</code> from <code>energyDynamics</code>
to <code>massDynamics</code>.
</li>
<li>
September 28, 2010 by Michael Wetter:<br/>
Changed array index for nominal value of <code>Xi</code>.
</li>
<li>
September 13, 2010 by Michael Wetter:<br/>
Set nominal attributes for medium based on default medium values.
</li>
<li>
July 30, 2010 by Michael Wetter:<br/>
Added parameter <code>C_nominal</code> which is used as the nominal attribute for <code>C</code>.
Without this value, the ODE solver gives wrong results for concentrations around 1E-7.
</li>
<li>
March 21, 2010 by Michael Wetter:<br/>
Changed pressure start value from <code>system.p_start</code>
to <code>Medium.p_default</code> since HVAC models may have water and
air, which are typically at different pressures.
</li>
<li><i>February 6, 2010</i> by Michael Wetter:<br/>
Added to <code>Medium.BaseProperties</code> the initialization
<code>X(start=X_start[1:Medium.nX])</code>. Previously, the initialization
was only done for <code>Xi</code> but not for <code>X</code>, which caused the
medium to be initialized to <code>reference_X</code>, ignoring the value of <code>X_start</code>.
</li>
<li><i>October 12, 2009</i> by Michael Wetter:<br/>
Implemented first version in <code>Buildings</code> library, based on model from
<code>Modelica.Fluid 1.0</code>.
</li>
</ul>
</html>"),
    Icon(graphics={            Rectangle(
          extent={{-100,100},{100,-100}},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-89,17},{-54,34}},
          lineColor={0,0,127},
          textString="mWat_flow"),
        Text(
          extent={{-89,52},{-54,69}},
          lineColor={0,0,127},
          textString="Q_flow"),
        Line(points={{-56,-73},{81,-73}}, color={255,255,255}),
        Line(points={{-42,55},{-42,-84}}, color={255,255,255}),
        Polygon(
          points={{-42,67},{-50,45},{-34,45},{-42,67}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{87,-73},{65,-65},{65,-81},{87,-73}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-42,-28},{-6,-28},{18,4},{40,12},{66,14}},
          color={255,255,255},
          smooth=Smooth.Bezier),
        Text(
          extent={{-155,-120},{145,-160}},
          lineColor={0,0,255},
          textString="%name")}));
end ConservationEquation;
