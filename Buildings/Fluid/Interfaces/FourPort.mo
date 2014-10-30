within Buildings.Fluid.Interfaces;
model FourPort "Partial model with four ports"



  replaceable package Medium1 =
      Modelica.Media.Interfaces.PartialMedium "Medium 1 in the component"
      annotation (choicesAllMatching = true);
  replaceable package Medium2 =
      Modelica.Media.Interfaces.PartialMedium "Medium 2 in the component"
      annotation (choicesAllMatching = true);

  parameter Boolean allowFlowReversal1 = true
    "= true to allow flow reversal in medium 1, false restricts to design direction (port_a -> port_b)"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);
  parameter Boolean allowFlowReversal2 = true
    "= true to allow flow reversal in medium 2, false restricts to design direction (port_a -> port_b)"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);

  parameter Modelica.SIunits.SpecificEnthalpy h_outflow_a1_start = Medium1.h_default
    "Start value for enthalpy flowing out of port a1"
    annotation (Dialog(tab="Advanced", group="Initialization"));

  parameter Modelica.SIunits.SpecificEnthalpy h_outflow_b1_start = Medium1.h_default
    "Start value for enthalpy flowing out of port b1"
    annotation (Dialog(tab="Advanced", group="Initialization"));

  parameter Modelica.SIunits.SpecificEnthalpy h_outflow_a2_start = Medium2.h_default
    "Start value for enthalpy flowing out of port a2"
    annotation (Dialog(tab="Advanced", group="Initialization"));

  parameter Modelica.SIunits.SpecificEnthalpy h_outflow_b2_start = Medium2.h_default
    "Start value for enthalpy flowing out of port b2"
    annotation (Dialog(tab="Advanced", group="Initialization"));

  Modelica.Fluid.Interfaces.FluidPort_a port_a1(
                     redeclare final package Medium = Medium1,
                     m_flow(min=if allowFlowReversal1 then -Modelica.Constants.inf else 0),
                     h_outflow(start=h_outflow_a1_start))
    "Fluid connector a1 (positive design flow direction is from port_a1 to port_b1)"
    annotation (Placement(transformation(extent={{-110,50},{-90,70}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b1(
                     redeclare final package Medium = Medium1,
                     m_flow(max=if allowFlowReversal1 then +Modelica.Constants.inf else 0),
                     h_outflow(start=h_outflow_b1_start))
    "Fluid connector b1 (positive design flow direction is from port_a1 to port_b1)"
    annotation (Placement(transformation(extent={{110,50},{90,70}}), iconTransformation(extent={{110,50},{90,70}})));

  Modelica.Fluid.Interfaces.FluidPort_a port_a2(
                     redeclare final package Medium = Medium2,
                     m_flow(min=if allowFlowReversal2 then -Modelica.Constants.inf else 0),
                     h_outflow(start=h_outflow_a2_start))
    "Fluid connector a2 (positive design flow direction is from port_a2 to port_b2)"
    annotation (Placement(transformation(extent={{90,-70},{110,-50}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b2(
                     redeclare final package Medium = Medium2,
                     m_flow(max=if allowFlowReversal2 then +Modelica.Constants.inf else 0),
                     h_outflow(start=h_outflow_b2_start))
    "Fluid connector b2 (positive design flow direction is from port_a2 to port_b2)"
    annotation (Placement(transformation(extent={{-90,-70},{-110,-50}}),
                iconTransformation(extent={{-90,-70},{-110,-50}})));

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
Modelica.Fluid.Interfaces.PartialTwoPort</a>, except that it has four ports.
</p>
</html>", revisions="<html>
<ul>
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
          grid={1,1}), graphics={Text(
          extent={{-151,147},{149,107}},
          lineColor={0,0,255},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255},
          textString="%name")}));
end FourPort;
