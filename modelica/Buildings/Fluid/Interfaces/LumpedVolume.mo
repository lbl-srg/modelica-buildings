within Buildings.Fluid.Interfaces;
model LumpedVolume "Lumped volume with mass and energy balance"

//  outer Modelica.Fluid.System system "System properties";
  extends Buildings.Fluid.Interfaces.LumpedVolumeDeclarations;
  // Port definitions
  parameter Integer nPorts=0 "Number of ports"
    annotation(Evaluate=true, Dialog(connectorSizing=true, tab="General",group="Ports"));
  Modelica.Fluid.Vessels.BaseClasses.VesselFluidPorts_b ports[nPorts](
      redeclare each package Medium = Medium) "Fluid inlets and outlets"
    annotation (Placement(transformation(extent={{-40,-10},{40,10}},
      origin={0,-100})));

  // Set nominal attributes where literal values can be used.
  Medium.BaseProperties medium(
    preferredMediumStates= not (energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState),
    p(start=p_start,
      nominal=Medium.p_default,
      stateSelect=if not (massDynamics == Modelica.Fluid.Types.Dynamics.SteadyState)
                     then StateSelect.prefer else StateSelect.default),
    h(start=Medium.specificEnthalpy_pTX(p_start, T_start, X_start)),
    T(start=T_start,
      nominal=Medium.T_default,
      stateSelect=if (not (energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState))
                     then StateSelect.prefer else StateSelect.default),
    Xi(start=X_start[1:Medium.nXi],
       nominal=Medium.X_default[1:Medium.nXi],
       stateSelect=if (not (substanceDynamics == Modelica.Fluid.Types.Dynamics.SteadyState))
                     then StateSelect.prefer else StateSelect.default),
    d(start=rho_nominal)) "Medium properties";

  Modelica.SIunits.Energy U "Internal energy of fluid";
  Modelica.SIunits.Mass m "Mass of fluid";
  Modelica.SIunits.Mass[Medium.nXi] mXi
    "Masses of independent components in the fluid";
  Modelica.SIunits.Mass[Medium.nC] mC "Masses of trace substances in the fluid";
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

  // Inputs that need to be defined by an extending class
  input Modelica.SIunits.Volume fluidVolume "Volume";
  input Modelica.SIunits.HeatFlowRate Q_flow
    "Net heat input into component other than through the fluid ports";
  input Modelica.SIunits.MassFlowRate[Medium.nXi] mXi_flow
    "Net substance mass flow rate into the component other than through the fluid ports";

  // Outputs that are needed in models that extend this model
  Modelica.Blocks.Interfaces.RealOutput hOut(unit="J/kg")
    "Leaving temperature of the component";
  Modelica.Blocks.Interfaces.RealOutput XiOut[Medium.nXi](unit="1")
    "Leaving species concentration of the component";
  Modelica.Blocks.Interfaces.RealOutput COut[Medium.nC](unit="1")
    "Leaving trace substances of the component";
protected
  parameter Boolean initialize_p = not Medium.singleState
    "= true to set up initial equations for pressure";

  Medium.EnthalpyFlowRate ports_H_flow[nPorts];
  Medium.MassFlowRate ports_mXi_flow[nPorts,Medium.nXi];
  Medium.ExtraPropertyFlowRate ports_mC_flow[nPorts,Medium.nC];

  parameter Modelica.SIunits.Density rho_nominal=Medium.density(
   Medium.setState_pTX(
     T=T_start,
     p=p_start,
     X=X_start[1:Medium.nXi])) "Density, used to compute fluid mass"
  annotation (Evaluate=true);

equation
  // Total quantities
  m = fluidVolume*medium.d;
  mXi = m*medium.Xi;
  U = m*medium.u;
  mC = m*C;

  hOut = medium.h;
  XiOut = medium.Xi;
  COut = C;

  for i in 1:nPorts loop
    ports_H_flow[i]     = ports[i].m_flow * actualStream(ports[i].h_outflow)
      "Enthalpy flow";
    ports_mXi_flow[i,:] = ports[i].m_flow * actualStream(ports[i].Xi_outflow)
      "Component mass flow";
    ports_mC_flow[i,:]  = ports[i].m_flow * actualStream(ports[i].C_outflow)
      "Trace substance mass flow";
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
    0 = mb_flow + sum(mXi_flow);
  else
    der(m) = mb_flow + sum(mXi_flow);
  end if;

  if substanceDynamics == Modelica.Fluid.Types.Dynamics.SteadyState then
    zeros(Medium.nXi) = mbXi_flow + mXi_flow;
  else
    der(mXi) = mbXi_flow + mXi_flow;
  end if;

  if traceDynamics == Modelica.Fluid.Types.Dynamics.SteadyState then
    zeros(Medium.nC)  = mbC_flow;
  else
    der(mC)  = mbC_flow;
  end if;

  // Properties of outgoing flows
  for i in 1:nPorts loop
      ports[i].p          = medium.p;
      ports[i].h_outflow  = medium.h;
      ports[i].Xi_outflow = medium.Xi;
      ports[i].C_outflow  = C;
  end for;
initial equation
  // Make sure that if energyDynamics is SteadyState, then
  // massDynamics is also SteadyState.
  // Otherwise, the system of ordinary differential equations may be inconsistent.
  if energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState then
    assert(massDynamics == energyDynamics, "
         If 'massDynamics == Modelica.Fluid.Types.Dynamics.SteadyState', then it is 
         required that 'energyDynamics==Modelica.Fluid.Types.Dynamics.SteadyState'.
         Otherwise, the system of equations may not be consistent.
         You need to select other parameter values.");
  end if;

  // initialization of balances
  if energyDynamics == Modelica.Fluid.Types.Dynamics.FixedInitial then
//    if use_T_start then
      medium.T = T_start;
//    else
//      medium.h = h_start;
//    end if;
  else
    if energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyStateInitial then
//      if use_T_start then
        der(medium.T) = 0;
//      else
//        der(medium.h) = 0;
//      end if;
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

  annotation (
    Documentation(info="<html>
<p>
Basic model for an ideally mixed fluid volume with the ability to store mass and energy.
</p>
<h4>Implementation</h4>
<p>
When extending or instantiating this model, the following inputs need to be assigned:
<ul>
<li>
<code>fluidVolume</code>, which is the actual volume occupied by the fluid.
For most components, this can be set to a parameter. However, for components such as 
expansion vessels, the fluid volume can change in time.
</li>
<li>
<code>Q_flow</code>, which is the sensible plus latent heat flow rate added to the medium.
</li>
<li>
<code>mXi_flow</code>, which is the species mass flow rate added to the medium.
</li>
</ul>
</p>
<p>
The model can be used as a dynamic model or as a steady-state model.
However, for a steady-state model with exactly two fluid ports connected, 
the model
<a href=\"modelica://Buildings.Fluid.Interfaces.StaticTwoPortHeatMassExchanger\">
Buildings.Fluid.Interfaces.StaticTwoPortHeatMassExchanger</a>
provides a more efficient implementation.
</p>
<p>
For models that instantiates this model, see
<a href=\"modelica://Buildings.Fluid.MixingVolumes.MixingVolume\">
Buildings.Fluid.MixingVolumes.MixingVolume</a> and
<a href=\"modelica://Buildings.Fluid.Storage.ExpansionVessel\">
Buildings.Fluid.Storage.ExpansionVessel</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
July 31, 2011 by Michael Wetter:<br>
Added test to stop model translation if the setting for
<code>energyBalance</code> and <code>massBalance</code>
can lead to inconsistent equations.
</li>
<li>
July 26, 2011 by Michael Wetter:<br>
Removed the option to use <code>h_start</code>, as this
is not needed for building simulation. 
Also removed the reference to <code>Modelica.Fluid.System</code>.
Moved parameters and medium to 
<a href=\"Buildings.Fluid.Interfaces.LumpedVolumeDeclarations\">
Buildings.Fluid.Interfaces.LumpedVolumeDeclarations</a>.
<li>
July 14, 2011 by Michael Wetter:<br>
Added start value for medium density.
</li>
<li>
March 29, 2011 by Michael Wetter:<br>
Changed default value for <code>substanceDynamics</code> and
<code>traceDynamics</code> from <code>energyDynamics</code>
to <code>massDynamics</code>.
</li>
<li>
September 28, 2010 by Michael Wetter:<br>
Changed array index for nominal value of <code>Xi</code>.
<li>
September 13, 2010 by Michael Wetter:<br>
Set nominal attributes for medium based on default medium values.
</li>
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
end LumpedVolume;
