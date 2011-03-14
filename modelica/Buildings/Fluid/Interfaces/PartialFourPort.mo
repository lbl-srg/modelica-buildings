within Buildings.Fluid.Interfaces;
partial model PartialFourPort "Partial model with four ports"
  import Modelica.Constants;
  outer Modelica.Fluid.System system "System wide properties";

  replaceable package Medium1 =
      Modelica.Media.Interfaces.PartialMedium "Medium 1 in the component"
      annotation (choicesAllMatching = true);
  replaceable package Medium2 =
      Modelica.Media.Interfaces.PartialMedium "Medium 2 in the component"
      annotation (choicesAllMatching = true);

  parameter Boolean allowFlowReversal1 = system.allowFlowReversal
    "= true to allow flow reversal in medium 1, false restricts to design direction (port_a -> port_b)"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);
  parameter Boolean allowFlowReversal2 = system.allowFlowReversal
    "= true to allow flow reversal in medium 2, false restricts to design direction (port_a -> port_b)"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);

  parameter Modelica.SIunits.SpecificEnthalpy h_outflow_a1_start = Medium1.h_default
    "Start value for enthalpy flowing out of port a1"
    annotation(Dialog(tab="Initialization"));

  parameter Modelica.SIunits.SpecificEnthalpy h_outflow_b1_start = Medium1.h_default
    "Start value for enthalpy flowing out of port b1"
    annotation(Dialog(tab="Initialization"));

  parameter Modelica.SIunits.SpecificEnthalpy h_outflow_a2_start = Medium2.h_default
    "Start value for enthalpy flowing out of port a2"
    annotation(Dialog(tab="Initialization"));

  parameter Modelica.SIunits.SpecificEnthalpy h_outflow_b2_start = Medium2.h_default
    "Start value for enthalpy flowing out of port b2"
    annotation(Dialog(tab="Initialization"));

  Modelica.Fluid.Interfaces.FluidPort_a port_a1(
                                redeclare package Medium = Medium1,
                     m_flow(min=if allowFlowReversal1 then -Constants.inf else 0),
                     h_outflow(nominal=1E5, start=h_outflow_a1_start),
                     Xi_outflow(nominal=0.01))
    "Fluid connector a1 (positive design flow direction is from port_a1 to port_b1)"
    annotation (Placement(transformation(extent={{-110,50},{-90,70}},
            rotation=0)));
  Modelica.Fluid.Interfaces.FluidPort_b port_b1(
                                redeclare package Medium = Medium1,
                     m_flow(max=if allowFlowReversal1 then +Constants.inf else 0),
                     h_outflow(nominal=1E5, start=h_outflow_b1_start),
                     Xi_outflow(nominal=0.01))
    "Fluid connector b1 (positive design flow direction is from port_a1 to port_b1)"
    annotation (Placement(transformation(extent={{110,50},{90,70}},  rotation=
             0), iconTransformation(extent={{110,50},{90,70}})));

  Modelica.Fluid.Interfaces.FluidPort_a port_a2(
                                redeclare package Medium = Medium2,
                     m_flow(min=if allowFlowReversal2 then -Constants.inf else 0),
                     h_outflow(nominal=1E5,start=h_outflow_a2_start),
                     Xi_outflow(nominal=0.01))
    "Fluid connector a2 (positive design flow direction is from port_a2 to port_b2)"
    annotation (Placement(transformation(extent={{90,-70},{110,-50}},
            rotation=0)));
  Modelica.Fluid.Interfaces.FluidPort_b port_b2(
                                redeclare package Medium = Medium2,
                     m_flow(max=if allowFlowReversal2 then +Constants.inf else 0),
                     h_outflow(nominal=1E5, start=h_outflow_b2_start),
                     Xi_outflow(nominal=0.01))
    "Fluid connector b2 (positive design flow direction is from port_a2 to port_b2)"
    annotation (Placement(transformation(extent={{-90,-70},{-110,-50}},
                                                                     rotation=
             0), iconTransformation(extent={{-90,-70},{-110,-50}})));

  annotation (
    preferedView="info",
    Diagram(coordinateSystem(
          preserveAspectRatio=true,
          extent={{-100,-100},{100,100}},
          grid={1,1}), graphics),
    Documentation(info="<html>
<p>
This partial model defines an interface for components with two ports. 
The treatment of the design flow direction and of flow reversal are predefined based on the parameter <code>allowFlowReversal</code>.
</p>
<p>
This partial model is identical to 
<a href=\"modelica://Modelica.Fluid.Interfaces.PartialTwoPort\"</a>
Modelica.Fluid.Interfaces.PartialTwoPort</a>, except that it has four ports.
</p>
</html>", revisions="<html>
<ul>
<li>
September 17, 2010 by Michael Wetter:<br>
Fixed bug: The start value for <code>port_b1.h_outflow</code>
was set to <code>h_outflow_b2_start</code> instead of <code>h_outflow_b1_start</code>.
</li>
<li>
February 26, 2010 by Michael Wetter:<br>
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
end PartialFourPort;
