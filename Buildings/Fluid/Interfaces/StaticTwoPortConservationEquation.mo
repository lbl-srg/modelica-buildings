within Buildings.Fluid.Interfaces;
model StaticTwoPortConservationEquation
  "Partial model for static energy and mass conservation equations"
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface;

  constant Boolean simplify_mWat_flow = true
    "Set to true to cause port_a.m_flow + port_b.m_flow = 0 even if mWat_flow is non-zero";

  constant Boolean prescribedHeatFlowRate = false
    "Set to true if the heat flow rate is not a function of a temperature difference to the fluid temperature";

  parameter Boolean use_mWat_flow = false
    "Set to true to enable input connector for moisture mass flow rate"
    annotation(Evaluate=true, Dialog(tab="Advanced"));

  parameter Boolean use_C_flow = false
    "Set to true to enable input connector for trace substance"
    annotation(Evaluate=true, Dialog(tab="Advanced"));

  Modelica.Blocks.Interfaces.RealInput Q_flow(unit="W")
    "Sensible plus latent heat flow rate transferred into the medium"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  Modelica.Blocks.Interfaces.RealInput mWat_flow(final quantity="MassFlowRate",
                                                 unit="kg/s")
    if use_mWat_flow "Moisture mass flow rate added to the medium"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
  Modelica.Blocks.Interfaces.RealInput[Medium.nC] C_flow
    if use_C_flow "Trace substance mass flow rate added to the medium"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));

  // Outputs that are needed in models that extend this model
  Modelica.Blocks.Interfaces.RealOutput hOut(final unit="J/kg")
    "Leaving specific enthalpy of the component"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-50,110}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-50,110})));

  Modelica.Blocks.Interfaces.RealOutput XiOut[Medium.nXi](each unit="1",
                                                          each min=0,
                                                          each max=1,
                                                          nominal=0.01*ones(Medium.nXi))
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
  final parameter Boolean use_m_flowInv=
    (prescribedHeatFlowRate or use_mWat_flow or use_C_flow)
    "Flag, true if m_flowInv is used in the model"
    annotation (Evaluate=true);
  final parameter Real s[Medium.nXi] = {if Modelica.Utilities.Strings.isEqual(string1=Medium.substanceNames[i],
                                            string2="Water",
                                            caseSensitive=false)
                                            then 1 else 0 for i in 1:Medium.nXi}
    "Vector with zero everywhere except where species is";

  Real m_flowInv(unit="s/kg") "Regularization of 1/m_flow of port_a";

  Modelica.Units.SI.MassFlowRate mXi_flow[Medium.nXi]
    "Mass flow rates of independent substances added to the medium";

  // Parameters for inverseXRegularized.
  // These are assigned here for efficiency reason.
  // Otherwise, they would need to be computed each time
  // the function is invocated.
  final parameter Real deltaReg = m_flow_small/1E3
    "Smoothing region for inverseXRegularized";

  final parameter Real deltaInvReg = 1/deltaReg
    "Inverse value of delta for inverseXRegularized";

  final parameter Real aReg = -15*deltaInvReg
    "Polynomial coefficient for inverseXRegularized";
  final parameter Real bReg = 119*deltaInvReg^2
    "Polynomial coefficient for inverseXRegularized";
  final parameter Real cReg = -361*deltaInvReg^3
    "Polynomial coefficient for inverseXRegularized";
  final parameter Real dReg = 534*deltaInvReg^4
    "Polynomial coefficient for inverseXRegularized";
  final parameter Real eReg = -380*deltaInvReg^5
    "Polynomial coefficient for inverseXRegularized";
  final parameter Real fReg = 104*deltaInvReg^6
    "Polynomial coefficient for inverseXRegularized";

  final parameter Medium.ThermodynamicState state_default = Medium.setState_pTX(
      T=Medium.T_default,
      p=Medium.p_default,
      X=Medium.X_default[1:Medium.nXi]) "Medium state at default values";
  // Density at medium default values, used to compute the size of control volumes
  final parameter Modelica.Units.SI.SpecificHeatCapacity cp_default=
      Medium.specificHeatCapacityCp(state=state_default)
    "Specific heat capacity, used to verify energy conservation";
  constant Modelica.Units.SI.TemperatureDifference dTMax(min=1) = 200
    "Maximum temperature difference across the StaticTwoPortConservationEquation";
  // Conditional connectors
  Modelica.Blocks.Interfaces.RealInput mWat_flow_internal(unit="kg/s")
    "Needed to connect to conditional connector";
  Modelica.Blocks.Interfaces.RealInput C_flow_internal[Medium.nC]
    "Needed to connect to conditional connector";
initial equation
  // Assert that the substance with name 'water' has been found.
  if use_mWat_flow then
    assert(Medium.nXi == 0 or abs(sum(s)-1) < 1e-5,
      "If Medium.nXi > 1, then substance 'water' must be present for one component.'"
         + Medium.mediumName + "'.\n"
         + "Check medium model.");
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

  // Species flow rate from connector mWat_flow
  mXi_flow = mWat_flow_internal * s;

  // Regularization of m_flow around the origin to avoid a division by zero
  // m_flowInv is only used if prescribedHeatFlowRate == true, or
  // if the input connectors mWat_flow or C_flow are enabled.
  if use_m_flowInv then
    m_flowInv = Buildings.Utilities.Math.Functions.inverseXRegularized(
                       x=port_a.m_flow,
                       delta=deltaReg, deltaInv=deltaInvReg,
                       a=aReg, b=bReg, c=cReg, d=dReg, e=eReg, f=fReg);
  else
    // m_flowInv is not used.
    m_flowInv = 0;
  end if;

  if prescribedHeatFlowRate then
    assert(noEvent( abs(Q_flow) < dTMax*cp_default*max(m_flow_small/1E3, abs(m_flow))),
   "In " + getInstanceName() + ":
   The heat flow rate equals " + String(Q_flow) +
   " W and the mass flow rate equals " + String(m_flow) + " kg/s,
   which results in a temperature difference " +
   String(abs(Q_flow)/ (cp_default*max(m_flow_small/1E3, abs(m_flow)))) +
   " K > dTMax=" +String(dTMax) + " K.
   This may indicate that energy is not conserved for small mass flow rates.
   The implementation may require prescribedHeatFlowRate = false.");
  end if;

  if allowFlowReversal then
    // Formulate hOut using spliceFunction. This avoids an event iteration.
    // The introduced error is small because deltax=m_flow_small/1e3
    hOut = Buildings.Utilities.Math.Functions.regStep(y1=port_b.h_outflow,
                                                    y2=port_a.h_outflow,
                                                    x=port_a.m_flow,
                                                    x_small=m_flow_small/1E3);
    XiOut = Buildings.Utilities.Math.Functions.regStep(y1=port_b.Xi_outflow,
                                                     y2=port_a.Xi_outflow,
                                                     x=port_a.m_flow,
                                                     x_small=m_flow_small/1E3);
    COut = Buildings.Utilities.Math.Functions.regStep(y1=port_b.C_outflow,
                                                    y2=port_a.C_outflow,
                                                    x=port_a.m_flow,
                                                    x_small=m_flow_small/1E3);
  else
    hOut =  port_b.h_outflow;
    XiOut = port_b.Xi_outflow;
    COut =  port_b.C_outflow;
  end if;

  //////////////////////////////////////////////////////////////////////////////////////////
  // Energy balance and mass balance

    // Mass balance (no storage)
    port_a.m_flow + port_b.m_flow = if simplify_mWat_flow then 0 else -mWat_flow_internal;

    // Substance balance
    // a) forward flow
    if use_m_flowInv then
      port_b.Xi_outflow = inStream(port_a.Xi_outflow) + mXi_flow * m_flowInv;
    else // no water is added
      assert(use_mWat_flow == false, "In " + getInstanceName() + ": Wrong implementation for forward flow.");
      port_b.Xi_outflow = inStream(port_a.Xi_outflow);
    end if;

    // b) backward flow
    if allowFlowReversal then
      if use_m_flowInv then
        port_a.Xi_outflow = inStream(port_b.Xi_outflow) - mXi_flow * m_flowInv;
      else // no water added
        assert(use_mWat_flow == false, "In " + getInstanceName() + ": Wrong implementation for reverse flow.");
        port_a.Xi_outflow = inStream(port_b.Xi_outflow);
      end if;
    else // no  flow reversal
      port_a.Xi_outflow = Medium.X_default[1:Medium.nXi];
    end if;

    // Energy balance.
    // This equation is approximate since m_flow = port_a.m_flow is used for the mass flow rate
    // at both ports. Since mWat_flow_internal << m_flow, the error is small.
    if prescribedHeatFlowRate then
      port_b.h_outflow = inStream(port_a.h_outflow) + Q_flow * m_flowInv;
      if allowFlowReversal then
        port_a.h_outflow = inStream(port_b.h_outflow) - Q_flow * m_flowInv;
      else
        port_a.h_outflow = Medium.h_default;
      end if;
    else
      // Case with prescribedHeatFlowRate == false.
      // port_b.h_outflow is known and the equation needs to be solved for Q_flow.
      // Hence, we cannot use m_flowInv as for m_flow=0, any Q_flow would satisfiy
      // Q_flow * m_flowInv = 0.
      // The same applies for port_b.Xi_outflow and mXi_flow.
      port_a.m_flow * (inStream(port_a.h_outflow) - port_b.h_outflow)     = -Q_flow;
      if allowFlowReversal then
        port_a.m_flow * (inStream(port_b.h_outflow)  - port_a.h_outflow)  = +Q_flow;
      else
        // When allowFlowReversal = false, the downstream enthalpy does not matter.
        // Therefore a dummy value is used to avoid algebraic loops
        port_a.h_outflow = Medium.h_default;
      end if;
    end if;

  // Transport of trace substances
  if use_m_flowInv and use_C_flow then
    port_b.C_outflow =  inStream(port_a.C_outflow) + C_flow_internal * m_flowInv;
  else // no trace substance added.
    assert(not use_C_flow, "In " + getInstanceName() + ": Wrong implementation of trace substance balance for forward flow.");
    port_b.C_outflow =  inStream(port_a.C_outflow);
  end if;

  if allowFlowReversal then
    if use_C_flow then
      port_a.C_outflow = inStream(port_b.C_outflow) - C_flow_internal * m_flowInv;
    else
      port_a.C_outflow = inStream(port_b.C_outflow);
    end if;
  else
    port_a.C_outflow = zeros(Medium.nC);
  end if;

  ////////////////////////////////////////////////////////////////////////////
  // No pressure drop in this model
  port_a.p = port_b.p;

  annotation (
    preferredView="info",
    Documentation(info="<html>
<p>
This model transports fluid between its two ports, without storing mass or energy.
It implements a steady-state conservation equation for energy and mass fractions.
The model has zero pressure drop between its ports.
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
</p>

<p>
To increase the numerical robustness of the model, the constant
<code>prescribedHeatFlowRate</code> can be set.
Use the following settings:
</p>
<ul>
<li>Set <code>prescribedHeatFlowRate=true</code> if the <i>only</i> means of heat transfer
at the <code>heatPort</code> is a prescribed heat flow rate that
is <i>not</i> a function of the temperature difference
between the medium and an ambient temperature. Examples include an ideal electrical heater,
a pump that rejects heat into the fluid stream, or a chiller that removes heat based on a performance curve.
If the <code>heatPort</code> is not connected, then set <code>prescribedHeatFlowRate=true</code> as
in this case, <code>heatPort.Q_flow=0</code>.
</li>
<li>Set <code>prescribedHeatFlowRate=false</code> if there is heat flow at the <code>heatPort</code>
computed as <i>K * (T-heatPort.T)</i>, for some temperature <i>T</i> and some conductance <i>K</i>,
which may itself be a function of temperature or mass flow rate.<br/>
If there is a combination of <i>K * (T-heatPort.T)</i> and a prescribed heat flow rate,
for example a solar collector that dissipates heat to the ambient and receives heat from
the solar radiation, then set <code>prescribedHeatFlowRate=false</code>.
</li>
</ul>
<p>
If <code>prescribedHeatFlow=true</code>, then energy and mass balance
equations are formulated to guard against numerical problems near
zero flow that can occur if <code>Q_flow</code> or <code>m_flow</code>
are the results of an iterative solver.
</p>
<h4>Implementation</h4>
<p>
Input connectors of the model are
</p>
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
The model can only be used as a steady-state model with two fluid ports.
For a model with a dynamic balance, and more fluid ports, use
<a href=\"modelica://Buildings.Fluid.Interfaces.ConservationEquation\">
Buildings.Fluid.Interfaces.ConservationEquation</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
October 24, 2022, by Michael Wetter:<br/>
Conditionally removed assertion that checks for water content as this is
only required if water is added to the medium.<br/>
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1650\">#1650</a>.
</li>
<li>
September 9, 2022, by Michael Wetter:<br/>
Set nominal attribute for <code>XiOut</code>.<br/>
This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1634\">1634</a>.
</li>
<li>
September 18, 2020, by Michael Wetter:<br/>
Removed start value for <code>hOut</code> as it will be set by
<a href=\"modelica://Buildings.Fluid.MixingVolumes.BaseClasses.PartialMixingVolume\">
Buildings.Fluid.MixingVolumes.BaseClasses.PartialMixingVolume</a>.<br/>
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1397\">#1397</a>.
</li>
<li>
February 12, 2019, by Filip Jorissen:<br/>
Removed obsolete division by <code>TMax</code> in assert.<br/>
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1097\">#1097</a>.
</li>
<li>
June 23, 2018, by Filip Jorissen:<br/>
Added more details to energy conservation assert to facilitate
debugging.<br/>
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/962\">#962</a>.
</li>
<li>
March 30, 2018, by Filip Jorissen:<br/>
Added <code>getInstanceName()</code> in asserts to facilitate
debugging.<br/>
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/901\">#901</a>.
</li>
<li>
April 24, 2017, by Michael Wetter and Filip Jorissen:<br/>
Reimplemented check for energy conversion.<br/>
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/741\">#741</a>.
</li>
<li>
April 24, 2017, by Michael Wetter:<br/>
Reverted change from April 21, 2017.<br/>
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/741\">#741</a>.
</li>
<li>
April 21, 2017, by Filip Jorissen:<br/>
Revised test for energy conservation at small mass flow rates.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/741\">#741</a>.
</li>
<li>
October 23, 2016, by Filip Jorissen:<br/>
Added test for energy conservation at small mass flow rates.
</li>
<li>
March 17, 2016, by Michael Wetter:<br/>
Refactored model and implmented <code>regStep</code> instead of <code>spliceFunction</code>.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/247\">#247</a>
and for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/300\">#300</a>.
</li>
<li>
September 3, 2015, by Filip Jorissen:<br/>
Revised implementation of conservation of vapor mass.
Added new variable <code>mFlow_inv_b</code>.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/247\">#247</a>.
</li>
<li>
January 22, 2016, by Michael Wetter:<br/>
Removed <code>constant sensibleOnly</code> as this is no longer used because
the model uses <code>use_mWat_flow</code>.<br/>
Changed condition that determines whether <code>m_flowInv</code> needs to be
computed because the change from January 20 introduced an error in
<a href=\"modelica://Buildings.Fluid.MassExchangers.Examples.ConstantEffectiveness\">
Buildings.Fluid.MassExchangers.Examples.ConstantEffectiveness</a>.
</li>
<li>
January 20, 2016, by Filip Jorissen:<br/>
Removed if-else block in code for parameter <code>sensibleOnly</code>
since this is no longer needed to simplify the equations.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/372\">#372</a>.
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
Removed the units of <code>C_flow</code> to allow for PPM.
</li>
<li>
December 2, 2015, by Filip Jorissen:<br/>
Added input <code>C_flow</code> and code for handling trace substance insertions.
November 19, 2015, by Michael Wetter:<br/>
Removed assignment of parameter
<code>showDesignFlowDirection</code> in <code>extends</code> statement.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/349\">#349</a>.
</li>
<li>
September 14, 2015, by Filip Jorissen:<br/>
Rewrote some equations for better readability.
</li>
<li>
August 11, 2015, by Michael Wetter:<br/>
Refactored implementation of
<a href=\"modelica://Buildings.Utilities.Math.Functions.inverseXRegularized\">
Buildings.Utilities.Math.Functions.inverseXRegularized</a>
to allow function to be inlined and to factor out the computation
of arguments that only depend on parameters.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/302\">issue 302</a>.
</li>
<li>
July 17, 2015, by Michael Wetter:<br/>
Corrected bug for situation with latent heat exchange and flow reversal not
allowed.
The previous formulation was singular.
This caused some models to not translate.
The error was introduced in
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/282\">#282</a>.
</li>
<li>
July 17, 2015, by Michael Wetter:<br/>
Added constant <code>simplify_mWat_flow</code> to remove dependencies of the pressure drop
calculation on the moisture balance.
</li>
<li>
July 2, 2015 by Michael Wetter:<br/>
Revised implementation of conservation equations,
added default values for outlet quantities at <code>port_a</code>
if <code>allowFlowReversal=false</code> and
updated documentation.
See
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/281\">
issue 281</a> for a discussion.
</li>
<li>
July 1, 2015, by Filip Jorissen:<br/>
Revised implementation so that equations are always consistent
and do not lead to division by zero,
also when connecting a <code>prescribedHeatFlowRate</code>
to <code>MixingVolume</code> instances.
Renamed <code>use_safeDivision</code> into <code>prescribedHeatFlowRate</code>.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/282\">#282</a>
for a discussion.
</li>
<li>
May 6, 2015, by Michael Wetter:<br/>
Corrected documentation.
</li>
<li>
February 11, 2014 by Michael Wetter:<br/>
Improved documentation for <code>Q_flow</code> input.
</li>
<li>
October 21, 2013 by Michael Wetter:<br/>
Corrected sign error in the equation that is used if <code>use_safeDivision=false</code>
and <code>sensibleOnly=true</code>.
This only affects internal numerical tests, but not any examples in the library
as the constant <code>use_safeDivision</code> is set to <code>true</code> by default.
</li>
<li>
September 25, 2013 by Michael Wetter:<br/>
Reformulated computation of outlet properties to avoid an event at zero mass flow rate.
</li>
<li>
September 17, 2013 by Michael Wetter:<br/>
Added start value for <code>hOut</code>.
</li>
<li>September 10, 2013 by Michael Wetter:<br/>
Removed unrequired parameter <code>i_w</code>.
</li>
<li>
May 7, 2013 by Michael Wetter:<br/>
Removed <code>for</code> loops for species balance and trace substance balance,
as they cause the error <code>Error: Operand port_a.Xi_outflow[1] to operator inStream is not a stream variable.</code>
in OpenModelica.
</li>
<li>
March 27, 2013 by Michael Wetter:<br/>
Removed wrong unit attribute of <code>COut</code>,
and added min and max attributes for <code>XiOut</code>.
</li>
<li>
June 22, 2012 by Michael Wetter:<br/>
Reformulated implementation with <code>m_flowInv</code> to use <code>port_a.m_flow * ...</code>
if <code>use_safeDivision=false</code>. This avoids a division by zero if
<code>port_a.m_flow=0</code>.
</li>
<li>
February 7, 2012 by Michael Wetter:<br/>
Revised base classes for conservation equations in <code>Buildings.Fluid.Interfaces</code>.
</li>
<li>
December 14, 2011 by Michael Wetter:<br/>
Changed assignment of <code>hOut</code>, <code>XiOut</code> and
<code>COut</code> to no longer declare that it is continuous.
The declaration of continuity, i.e, the
<code>smooth(0, if (port_a.m_flow >= 0) then ...)</code> declaration,
was required for Dymola 2012 to simulate, but it is no longer needed
for Dymola 2012 FD01.
</li>
<li>
August 19, 2011, by Michael Wetter:<br/>
Changed assignment of <code>hOut</code>, <code>XiOut</code> and
<code>COut</code> to declare that it is not differentiable.
</li>
<li>
August 4, 2011, by Michael Wetter:<br/>
Moved linearized pressure drop equation from the function body to the equation
section. With the previous implementation,
the symbolic processor may not rearrange the equations, which can lead
to coupled equations instead of an explicit solution.
</li>
<li>
March 29, 2011, by Michael Wetter:<br/>
Changed energy and mass balance to avoid a division by zero if <code>m_flow=0</code>.
</li>
<li>
March 27, 2011, by Michael Wetter:<br/>
Added <code>homotopy</code> operator.
</li>
<li>
August 19, 2010, by Michael Wetter:<br/>
Fixed bug in energy and moisture balance that affected results if a component
adds or removes moisture to the air stream.
In the old implementation, the enthalpy and species
outflow at <code>port_b</code> was multiplied with the mass flow rate at
<code>port_a</code>. The old implementation led to small errors that were proportional
to the amount of moisture change. For example, if the moisture added by the component
was <code>0.005 kg/kg</code>, then the error was <code>0.5%</code>.
Also, the results for forward flow and reverse flow differed by this amount.
With the new implementation, the energy and moisture balance is exact.
</li>
<li>
March 22, 2010, by Michael Wetter:<br/>
Added constant <code>sensibleOnly</code> to
simplify species balance equation.
</li>
<li>
April 10, 2009, by Michael Wetter:<br/>
Added model to compute flow friction.
</li>
<li>
April 22, 2008, by Michael Wetter:<br/>
Revised to add mass balance.
</li>
<li>
March 17, 2008, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}},
        grid={1,1}), graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-93,72},{-58,89}},
          textColor={0,0,127},
          textString="Q_flow"),
        Text(
          extent={{-93,37},{-58,54}},
          textColor={0,0,127},
          textString="mWat_flow"),
        Text(
          extent={{-41,103},{-10,117}},
          textColor={0,0,127},
          textString="hOut"),
        Text(
          extent={{10,103},{41,117}},
          textColor={0,0,127},
          textString="XiOut"),
        Text(
          extent={{61,103},{92,117}},
          textColor={0,0,127},
          textString="COut"),
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
        Line(points={{-56,-73},{81,-73}}, color={255,255,255}),
        Line(points={{6,14},{6,-37}},     color={255,255,255}),
        Line(points={{54,14},{6,14}},     color={255,255,255}),
        Line(points={{6,-37},{-42,-37}},  color={255,255,255})}));
end StaticTwoPortConservationEquation;
