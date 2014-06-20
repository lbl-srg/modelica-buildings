within Buildings.Fluid.Interfaces;
model ConservationEquation "Lumped volume with mass and energy balance"

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
    h(start=hStart),
    T(start=T_start,
      nominal=Medium.T_default,
      stateSelect=if (not (energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState))
                     then StateSelect.prefer else StateSelect.default),
    Xi(start=X_start[1:Medium.nXi],
       nominal=Medium.X_default[1:Medium.nXi],
       each stateSelect=if (not (substanceDynamics == Modelica.Fluid.Types.Dynamics.SteadyState))
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

  Modelica.Blocks.Interfaces.RealInput Q_flow(unit="W")
    "Sensible plus latent heat flow rate transfered into the medium"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.RealInput mWat_flow(unit="kg/s")
    "Moisture mass flow rate added to the medium"
    annotation (Placement(transformation(extent={{-140,0},{-100,40}})));

  // Outputs that are needed in models that extend this model
  Modelica.Blocks.Interfaces.RealOutput hOut(unit="J/kg",
                                             start=hStart)
    "Leaving enthalpy of the component"
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
protected
  parameter Boolean initialize_p = not Medium.singleState
    "= true to set up initial equations for pressure";

  Medium.EnthalpyFlowRate ports_H_flow[nPorts];
  Modelica.SIunits.MassFlowRate ports_mXi_flow[nPorts,Medium.nXi];
  Medium.ExtraPropertyFlowRate ports_mC_flow[nPorts,Medium.nC];

  parameter Modelica.SIunits.Density rho_nominal=Medium.density(
   Medium.setState_pTX(
     T=T_start,
     p=p_start,
     X=X_start[1:Medium.nXi])) "Density, used to compute fluid mass";

  // Parameter that is used to construct the vector mXi_flow
  final parameter Real s[Medium.nXi] = {if Modelica.Utilities.Strings.isEqual(string1=Medium.substanceNames[i],
                                            string2="Water",
                                            caseSensitive=false)
                                            then 1 else 0 for i in 1:Medium.nXi}
    "Vector with zero everywhere except where species is";
  parameter Modelica.SIunits.SpecificEnthalpy hStart=
    Medium.specificEnthalpy_pTX(p_start, T_start, X_start)
    "Start value for specific enthalpy";
initial equation
  // Assert that the substance with name 'water' has been found.
  assert(Medium.nXi == 0 or abs(sum(s)-1) < 1e-5,
      "If Medium.nXi > 1, then substance 'water' must be present for one component.'"
         + Medium.mediumName + "'.\n"
         + "Check medium model.");

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
    0 = mb_flow + mWat_flow;
  else
    der(m) = mb_flow + mWat_flow;
  end if;

  if substanceDynamics == Modelica.Fluid.Types.Dynamics.SteadyState then
    zeros(Medium.nXi) = mbXi_flow + mWat_flow * s;
  else
    der(mXi) = mbXi_flow + mWat_flow * s;
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

  annotation (
    Documentation(info="<html>
<p>
Basic model for an ideally mixed fluid volume with the ability to store mass and energy.
It implements a dynamic or a steady-state conservation equation for energy and mass fractions.
The model has zero pressure drop between its ports.
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
<code>Q_flow</code>, which is the sensible plus latent heat flow rate added to the medium, and
</li>
<li>
<code>mWat_flow</code>, which is the moisture mass flow rate added to the medium.
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
<li>September 10, 2013 by Michael Wetter:<br/>
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
    Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{
            100,100}}),
            graphics),
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
