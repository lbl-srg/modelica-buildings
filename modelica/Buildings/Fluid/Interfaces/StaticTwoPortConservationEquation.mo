within Buildings.Fluid.Interfaces;
model StaticTwoPortConservationEquation
  "Partial model for static energy and mass conservation equations"
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(
  showDesignFlowDirection = false);
//  import Modelica.Constants;
  Modelica.Blocks.Interfaces.RealInput Q_flow(unit="W")
    "Heat transfered into the medium"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  Modelica.Blocks.Interfaces.RealInput mXi_flow[Medium.nXi](unit="kg/s")
    "Mass flow rates of independent substances added to the medium"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
  constant Boolean sensibleOnly "Set to true if sensible exchange only";
  // Outputs that are needed in models that extend this model
  Modelica.Blocks.Interfaces.RealOutput hOut(unit="J/kg")
    "Leaving temperature of the component"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-50,110}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-50,110})));
  Modelica.Blocks.Interfaces.RealOutput XiOut[Medium.nXi](unit="1")
    "Leaving species concentration of the component"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,110})));
  Modelica.Blocks.Interfaces.RealOutput COut[Medium.nC](unit="1")
    "Leaving trace substances of the component"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={50,110})));
  constant Boolean use_safeDivision=true
    "Set to true to improve numerical robustness";
protected
  Real m_flowInv(unit="s/kg") "Regularization of 1/m_flow";
equation
  // Regularization of m_flow around the origin to avoid a division by zero
 if use_safeDivision then
    m_flowInv = Buildings.Utilities.Math.Functions.inverseXRegularized(x=port_a.m_flow, delta=m_flow_small/1E3);
 else
     m_flowInv = 1/port_a.m_flow;
 end if;
 if allowFlowReversal then
// This formulation fails to simulate in Buildings.Fluid.MixingVolumes.Examples.MixingVolumePrescribedHeatFlowRate
// with Dymola 2012. See also Dynasim ticket 13596.
// It works with Dymola 2012 FD01.
   if (port_a.m_flow >= 0) then
     hOut =  port_b.h_outflow;
     XiOut = port_b.Xi_outflow;
     COut =  port_b.C_outflow;
    else
     hOut =  port_a.h_outflow;
     XiOut = port_a.Xi_outflow;
     COut =  port_a.C_outflow;
    end if;
 else
   hOut =  port_b.h_outflow;
   XiOut = port_b.Xi_outflow;
   COut =  port_b.C_outflow;
 end if;
  //////////////////////////////////////////////////////////////////////////////////////////
  // Energy balance and mass balance
  if sensibleOnly then
    // Mass balance
    port_a.m_flow = -port_b.m_flow;
    // Energy balance
    port_b.h_outflow = inStream(port_a.h_outflow) + Q_flow * m_flowInv;
    port_a.h_outflow = inStream(port_b.h_outflow) - Q_flow * m_flowInv;
    // Transport of species
    port_a.Xi_outflow = inStream(port_b.Xi_outflow);
    port_b.Xi_outflow = inStream(port_a.Xi_outflow);
    // Transport of trace substances
    port_a.C_outflow = inStream(port_b.C_outflow);
    port_b.C_outflow = inStream(port_a.C_outflow);
  else
    // Mass balance (no storage)
    port_a.m_flow + port_b.m_flow = -sum(mXi_flow);
    // Energy balance.
    // This equation is approximate since m_flow = port_a.m_flow is used for the mass flow rate
    // at both ports. Since mXi_flow << m_flow, the error is small.
    port_b.h_outflow = inStream(port_a.h_outflow) + Q_flow * m_flowInv;
    port_a.h_outflow = inStream(port_b.h_outflow) - Q_flow * m_flowInv;
    // Transport of species
    for i in 1:Medium.nXi loop
      port_b.Xi_outflow[i] = inStream(port_a.Xi_outflow[i]) + mXi_flow[i] * m_flowInv;
      port_a.Xi_outflow[i] = inStream(port_b.Xi_outflow[i]) - mXi_flow[i] * m_flowInv;
    end for;
    // Transport of trace substances
    for i in 1:Medium.nC loop
      port_a.m_flow*port_a.C_outflow[i] = -port_b.m_flow*inStream(port_b.C_outflow[i]);
      port_b.m_flow*port_b.C_outflow[i] = -port_a.m_flow*inStream(port_a.C_outflow[i]);
    end for;
  end if; // sensibleOnly
  //////////////////////////////////////////////////////////////////////////////////////////
  // No pressure drop in this model
  port_a.p = port_b.p;
  annotation (
    preferedView="info",
    Diagram(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}},
        grid={1,1}), graphics),
    Documentation(info="<html>
<p>
This model transports fluid between its two ports, without storing mass or energy. 
It implements a steady-state conservation equation for energy and mass fractions.
The model has zero pressure drop between its ports.
</p>
<h4>Implementation</h4>
<p>
Input connectors of the model are
<ul>
<li>
<code>Q_flow</code>, which is the sensible plus latent heat flow rate added to the medium, and
</li>
<li>
<code>mXi_flow</code>, which is the species mass flow rate added to the medium.
</li>
</ul>
</p>
<p>
The model can only be used as a steady-state model with two fluid ports.
For a model with a dynamic balance, and more fluid ports, use
<a href=\"modelica://Buildings.Fluid.Interfaces.ConservationEquation\">
Buildings.Fluid.Interfaces.ConservationEquation</a>.
</p>
<p>
Set the constant <code>sensibleOnly=true</code> if the model that extends
or instantiates this model sets <code>mXi_flow = zeros(Medium.nXi)</code>.
</p>
</html>",
revisions="<html>
<ul>
<li>
February 7, 2012 by Michael Wetter:<br>
Revised base classes for conservation equations in <code>Buildings.Fluid.Interfaces</code>.
</li>
<li>
December 14, 2011 by Michael Wetter:<br>
Changed assignment of <code>hOut</code>, <code>XiOut</code> and
<code>COut</code> to no longer declare that it is continuous. 
The declaration of continuity, i.e, the 
<code>smooth(0, if (port_a.m_flow >= 0) then ...</code> declaration,
was required for Dymola 2012 to simulate, but it is no longer needed 
for Dymola 2012 FD01.
</li>
<li>
August 19, 2011, by Michael Wetter:<br>
Changed assignment of <code>hOut</code>, <code>XiOut</code> and
<code>COut</code> to declare that it is not differentiable.
</li>
<li>
August 4, 2011, by Michael Wetter:<br>
Moved linearized pressure drop equation from the function body to the equation
section. With the previous implementation, 
the symbolic processor may not rearrange the equations, which can lead 
to coupled equations instead of an explicit solution.
</li>
<li>
March 29, 2011, by Michael Wetter:<br>
Changed energy and mass balance to avoid a division by zero if <code>m_flow=0</code>.
</li>
<li>
March 27, 2011, by Michael Wetter:<br>
Added <code>homotopy</code> operator.
</li>
<li>
August 19, 2010, by Michael Wetter:<br>
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
March 22, 2010, by Michael Wetter:<br>
Added constant <code>sensibleOnly</code> to 
simplify species balance equation.
</li>
<li>
April 10, 2009, by Michael Wetter:<br>
Added model to compute flow friction.
</li>
<li>
April 22, 2008, by Michael Wetter:<br>
Revised to add mass balance.
</li>
<li>
March 17, 2008, by Michael Wetter:<br>
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
          textString="mXi_flow"),
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
