within Buildings.Fluid.Interfaces;
partial model PartialFourPort "Partial model with four ports"

  replaceable package Medium1 =
    Modelica.Media.Interfaces.PartialMedium "Medium 1 in the component"
      annotation (choices(
        choice(redeclare package Medium1 = Buildings.Media.Air "Moist air"),
        choice(redeclare package Medium1 = Buildings.Media.Water "Water"),
        choice(redeclare package Medium1 =
            Buildings.Media.Antifreeze.PropyleneGlycolWater (
          property_T=293.15,
          X_a=0.40)
          "Propylene glycol water, 40% mass fraction")));
  replaceable package Medium2 =
    Modelica.Media.Interfaces.PartialMedium "Medium 2 in the component"
      annotation (choices(
        choice(redeclare package Medium2 = Buildings.Media.Air "Moist air"),
        choice(redeclare package Medium2 = Buildings.Media.Water "Water"),
        choice(redeclare package Medium2 =
            Buildings.Media.Antifreeze.PropyleneGlycolWater (
          property_T=293.15,
          X_a=0.40)
          "Propylene glycol water, 40% mass fraction")));

  parameter Boolean allowFlowReversal1 = true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal for medium 1"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);
  parameter Boolean allowFlowReversal2 = true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal for medium 2"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);

  Modelica.Fluid.Interfaces.FluidPort_a port_a1(
                     redeclare final package Medium = Medium1,
                     m_flow(min=if allowFlowReversal1 then -Modelica.Constants.inf else 0),
                     h_outflow(start = Medium1.h_default, nominal = Medium1.h_default))
    "Fluid connector a1 (positive design flow direction is from port_a1 to port_b1)"
    annotation (Placement(transformation(extent={{-110,50},{-90,70}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b1(
                     redeclare final package Medium = Medium1,
                     m_flow(max=if allowFlowReversal1 then +Modelica.Constants.inf else 0),
                     h_outflow(start = Medium1.h_default, nominal = Medium1.h_default))
    "Fluid connector b1 (positive design flow direction is from port_a1 to port_b1)"
    annotation (Placement(transformation(extent={{110,50},{90,70}})));

  Modelica.Fluid.Interfaces.FluidPort_a port_a2(
                     redeclare final package Medium = Medium2,
                     m_flow(min=if allowFlowReversal2 then -Modelica.Constants.inf else 0),
                     h_outflow(start = Medium2.h_default, nominal = Medium2.h_default))
    "Fluid connector a2 (positive design flow direction is from port_a2 to port_b2)"
    annotation (Placement(transformation(extent={{90,-70},{110,-50}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b2(
                     redeclare final package Medium = Medium2,
                     m_flow(max=if allowFlowReversal2 then +Modelica.Constants.inf else 0),
                     h_outflow(start = Medium2.h_default, nominal = Medium2.h_default))
    "Fluid connector b2 (positive design flow direction is from port_a2 to port_b2)"
    annotation (Placement(transformation(extent={{-90,-70},{-110,-50}})));

  annotation (
    preferredView="info",
    Documentation(info="<html>
<p>
This model defines an interface for components with four ports.
The parameters <code>allowFlowReversal1</code> and
<code>allowFlowReversal2</code> may be used by models that extend
this model to treat flow reversal.
</p>
<p>
This model is identical to
<a href=\"modelica://Modelica.Fluid.Interfaces.PartialTwoPort\">
Modelica.Fluid.Interfaces.PartialTwoPort</a>, except for the
fowllowing:
</p>
<ol>
<li>it has four ports, and
</li>
<li>
the parameters <code>port_a_exposesState</code>,
<code>port_b_exposesState</code> and
<code>showDesignFlowDirection</code>
are not implemented.
</li>
</ol>
</html>", revisions="<html>
<ul>
<li>
August 27, 2024, by Jianjun Hu:<br/>
Corrected dropdown media choice.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1924\">IBPSA #1924</a>.
</li>
<li>
April 6, 2020, by Filip Jorissen:<br/>
Added arrows to the icon indicating the intended flow direction
when <code>allowFlowReversal=false</code>.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1336\">#1336</a>.
</li>
<li>
January 18, 2019, by Jianjun Hu:<br/>
Limited the media choice.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1050\">#1050</a>.
</li>
<li>
July 8, 2018, by Filip Jorissen:<br/>
Added nominal value of <code>h_outflow</code> in <code>FluidPorts</code>.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/977\">#977</a>.
</li>
<li>
November 12, 2015, by Michael Wetter:<br/>
Renamed model from <code>FourPort</code> to
<code>PartialFourPort</code>.
Removed parameters
<code>h_outflow_a1_start</code>,
<code>h_outflow_b1_start</code>,
<code>h_outflow_a2_start</code> and
<code>h_outflow_b2_start</code>.
This is for issue
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/299\">#299</a>.
</li>
<li>
October 30, 2015, by Matthis Thorade:<br/>
Added <code>partial</code> keyword to model declaration.
</li>
<li>
October 6, 2014, by Michael Wetter:<br/>
Changed medium declaration in ports to be final.
</li>
<li>
October 3, 2014, by Michael Wetter:<br/>
Changed assignment of nominal value to avoid in OpenModelica the warning
alias set with different nominal values.
</li>
<li>
November 12, 2013, by Michael Wetter:<br/>
Removed <code>import Modelica.Constants</code> statement.
</li>
<li>
September 26, 2013 by Michael Wetter:<br/>
Added missing <code>each</code> keyword in declaration of nominal value for
<code>Xi_outflow</code>.
</li>
<li>
September 17, 2010 by Michael Wetter:<br/>
Fixed bug: The start value for <code>port_b1.h_outflow</code>
was set to <code>h_outflow_b2_start</code> instead of <code>h_outflow_b1_start</code>.
</li>
<li>
February 26, 2010 by Michael Wetter:<br/>
Added start values for outflowing enthalpy because they
are often iteration variables in nonlinear equation systems.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(
          preserveAspectRatio=true,
          extent={{-100,-100},{100,100}},
          grid={1,1}), graphics={
      Text(
          extent={{-151,147},{149,107}},
          textColor={0,0,255},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255},
          textString="%name"),
      Polygon(
          points={{-5,10},{25,10},{-5,-10},{-5,10}},
          lineColor={0,128,255},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid,
          visible=not allowFlowReversal1,
          origin={75,50},
          rotation=360),
      Polygon(
          points={{10,10},{-20,-10},{10,-10},{10,10}},
          lineColor={0,128,255},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid,
          visible=not allowFlowReversal2,
          origin={-79,-50},
          rotation=360)}));
end PartialFourPort;
