within Buildings.Fluid.Interfaces;
model StaticTwoPortConservationEquation
  "Partial model for static energy and mass conservation equations"
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(
  showDesignFlowDirection = false);

  constant Boolean sensibleOnly "Set to true if sensible exchange only";

  parameter Boolean prescribedHeatFlowRate
    "Set to true if the heat flow rate is not a function of a temperature difference to the fluid temperature."
       annotation(Evaluate=true,
     Dialog(tab="Assumptions",
      group="Heat transfer"));

  Modelica.Blocks.Interfaces.RealInput Q_flow(unit="W")
    "Sensible plus latent heat flow rate transferred into the medium"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  Modelica.Blocks.Interfaces.RealInput mWat_flow(unit="kg/s")
    "Moisture mass flow rate added to the medium"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));

  // Outputs that are needed in models that extend this model
  Modelica.Blocks.Interfaces.RealOutput hOut(unit="J/kg",
                                             start=Medium.specificEnthalpy_pTX(
                                                     p=Medium.p_default,
                                                     T=Medium.T_default,
                                                     X=Medium.X_default))
    "Leaving specific enthalpy of the component"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-50,110}), iconTransformation(
        extent={{-10,-10},{10,10}},
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

  // Parameters that is used to construct the vector mXi_flow
protected
  final parameter Real s[Medium.nXi] = {if Modelica.Utilities.Strings.isEqual(string1=Medium.substanceNames[i],
                                            string2="Water",
                                            caseSensitive=false)
                                            then 1 else 0 for i in 1:Medium.nXi}
    "Vector with zero everywhere except where species is";

  Real m_flowInv(unit="s/kg") "Regularization of 1/m_flow";

  Modelica.SIunits.MassFlowRate mXi_flow[Medium.nXi]
    "Mass flow rates of independent substances added to the medium";

initial equation
  // Assert that the substance with name 'water' has been found.
  assert(Medium.nXi == 0 or abs(sum(s)-1) < 1e-5,
      "If Medium.nXi > 1, then substance 'water' must be present for one component.'"
         + Medium.mediumName + "'.\n"
         + "Check medium model.");

equation
 // Species flow rate from connector mWat_flow
 mXi_flow = mWat_flow * s;
  // Regularization of m_flow around the origin to avoid a division by zero

 // m_flowInv is only used if prescribedHeatFlowRate == true
 m_flowInv = if prescribedHeatFlowRate
             then Buildings.Utilities.Math.Functions.inverseXRegularized(x=port_a.m_flow, delta=m_flow_small/1E3)
             else 0;

 if allowFlowReversal then
   // Formulate hOut using spliceFunction. This avoids an event iteration.
   // The introduced error is small because deltax=m_flow_small/1e3
   hOut = Buildings.Utilities.Math.Functions.spliceFunction(pos=port_b.h_outflow,
                                                            neg=port_a.h_outflow,
                                                            x=port_a.m_flow,
                                                            deltax=m_flow_small/1E3);
   XiOut = Buildings.Utilities.Math.Functions.spliceFunction(pos=port_b.Xi_outflow,
                                                            neg=port_a.Xi_outflow,
                                                            x=port_a.m_flow,
                                                            deltax=m_flow_small/1E3);
   COut = Buildings.Utilities.Math.Functions.spliceFunction(pos=port_b.C_outflow,
                                                            neg=port_a.C_outflow,
                                                            x=port_a.m_flow,
                                                            deltax=m_flow_small/1E3);
 else
   hOut =  port_b.h_outflow;
   XiOut = port_b.Xi_outflow;
   COut =  port_b.C_outflow;
 end if;

  //////////////////////////////////////////////////////////////////////////////////////////
  // Energy balance and mass balance
  if sensibleOnly then
    //////////////////////////////////////////////////////////////////////////
    // Case with sensible heat exchange only

    // Mass balance
    port_a.m_flow = -port_b.m_flow;
    // Energy balance
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
      port_a.m_flow * (inStream(port_a.h_outflow) - port_b.h_outflow) = -Q_flow;
      if allowFlowReversal then
        port_a.m_flow * (inStream(port_b.h_outflow) - port_a.h_outflow) = +Q_flow;
      else
        // If allowFlowReversal == false, the downstream enthalpy does not matter.
        // Therefore a dummy value is used to avoid the creating of algebraic loops.
        // See https://github.com/iea-annex60/modelica-annex60/issues/281
        port_a.h_outflow = Medium.h_default;
      end if;
    end if;
    // Transport of species and trace substances
    port_b.Xi_outflow = inStream(port_a.Xi_outflow);
    port_b.C_outflow = inStream(port_a.C_outflow);
    if allowFlowReversal then
      port_a.Xi_outflow = inStream(port_b.Xi_outflow);
      port_a.C_outflow = inStream(port_b.C_outflow);
    else
      port_a.Xi_outflow = Medium.X_default[1:Medium.nXi];
      port_a.C_outflow =  zeros(Medium.nC);
    end if;
  else
    //////////////////////////////////////////////////////////////////////////
    // Case with latent heat exchange

    // Mass balance (no storage)
    port_a.m_flow + port_b.m_flow = -mWat_flow;
    // Energy balance.
    // This equation is approximate since m_flow = port_a.m_flow is used for the mass flow rate
    // at both ports. Since mWat_flow << m_flow, the error is small.
    if prescribedHeatFlowRate then
      port_b.h_outflow = inStream(port_a.h_outflow) + Q_flow * m_flowInv;
      port_b.Xi_outflow = inStream(port_a.Xi_outflow) + mXi_flow * m_flowInv;
      if allowFlowReversal then
        port_a.h_outflow = inStream(port_b.h_outflow) - Q_flow * m_flowInv;
        port_a.Xi_outflow = inStream(port_b.Xi_outflow) - mXi_flow * m_flowInv;
      else
        port_a.Xi_outflow = Medium.X_default[1:Medium.nXi];
        port_a.C_outflow =  zeros(Medium.nC);
      end if;
    else
      // Case with prescribedHeatFlowRate == false.
      // port_b.h_outflow is known and the equation needs to be solved for Q_flow.
      // Hence, we cannot use m_flowInv as for m_flow=0, any Q_flow would satisfiy
      // Q_flow * m_flowInv = 0.
      // The same applies for port_b.Xi_outflow and mXi_flow.
      port_a.m_flow * (inStream(port_a.h_outflow)  - port_b.h_outflow)  = -Q_flow;
      port_a.m_flow * (inStream(port_b.Xi_outflow) - port_a.Xi_outflow) = +mXi_flow;
      if allowFlowReversal then
        port_a.m_flow * (inStream(port_b.h_outflow)  - port_a.h_outflow)  = +Q_flow;
        port_a.m_flow * (inStream(port_a.Xi_outflow) - port_b.Xi_outflow) = -mXi_flow;
      else
        //When allowFlowReversal = false the downstream enthalpy should not matter
        //therefore a dummy value is used to avoid the creating of algebraic loops
        port_a.h_outflow = Medium.h_default;
        port_a.Xi_outflow = Medium.X_default[1:Medium.nXi];
      end if;
    end if;

    // Transport of trace substances
    port_b.m_flow*port_b.C_outflow = -port_a.m_flow*inStream(port_a.C_outflow);
    if allowFlowReversal then
      port_a.m_flow*port_a.C_outflow = -port_b.m_flow*inStream(port_b.C_outflow);
    else
      port_a.C_outflow = zeros(Medium.nC);
    end if;
  end if; // sensibleOnly

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
<h4>Implementation</h4>
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
The model can only be used as a steady-state model with two fluid ports.
For a model with a dynamic balance, and more fluid ports, use
<a href=\"modelica://Buildings.Fluid.Interfaces.ConservationEquation\">
Buildings.Fluid.Interfaces.ConservationEquation</a>.
</p>
<p>
Set the constant <code>sensibleOnly=true</code> if the model that extends
or instantiates this model sets <code>mWat_flow = 0</code>.
</p>
<p>
To increase the numerical robustness of the model, the parameter
<code>prescribedHeatFlowRate</code> must be set.
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
</html>",
revisions="<html>
<ul>
<li>
July 2, 2015 by Michael Wetter:<br/>
Revised implementation of conservation equations,
added default values for outlet quantities at <code>port_a</code>
if <code>allowFlowReversal=false</code> and
updated documentation.
See
<a href=\"https://github.com/iea-annex60/modelica-annex60/issues/281\">
issue 281</a> for a discussion.
</li>
<li>
July 1, 2015, by Filip Jorissen:<br/>
Revised implementation so that equations are always consistent
and do not lead to division by zero,
also when connecting a <code>prescribedHeatFlowRate</code>
to <code>MixingVolume</code> instances.
Renamed <code>use_safeDivision</code> into <code>prescribedHeatFlowRate</code>.
See <a href=\"https://github.com/iea-annex60/modelica-annex60/issues/282\">#282</a>
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
<code>smooth(0, if (port_a.m_flow >= 0) then ...</code> declaration,
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
          lineColor={0,0,127},
          textString="Q_flow"),
        Text(
          extent={{-93,37},{-58,54}},
          lineColor={0,0,127},
          textString="mWat_flow"),
        Text(
          extent={{-41,103},{-10,117}},
          lineColor={0,0,127},
          textString="hOut"),
        Text(
          extent={{10,103},{41,117}},
          lineColor={0,0,127},
          textString="XiOut"),
        Text(
          extent={{61,103},{92,117}},
          lineColor={0,0,127},
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
