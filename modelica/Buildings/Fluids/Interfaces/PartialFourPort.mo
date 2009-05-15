within Buildings.Fluids.Interfaces;
partial model PartialFourPort "Partial model with four ports"
  import Modelica.Constants;
  outer Modelica_Fluid.System system "System wide properties";

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

  Modelica_Fluid.Interfaces.FluidPort_a port_a1(
                                redeclare package Medium = Medium1,
                     m_flow(min=if allowFlowReversal1 then -Constants.inf else 0))
    "Fluid connector a1 (positive design flow direction is from port_a1 to port_b1)"
    annotation (Placement(transformation(extent={{-110,50},{-90,70}},
            rotation=0)));
  Modelica_Fluid.Interfaces.FluidPort_b port_b1(
                                redeclare package Medium = Medium1,
                     m_flow(max=if allowFlowReversal1 then +Constants.inf else 0))
    "Fluid connector b1 (positive design flow direction is from port_a1 to port_b1)"
    annotation (Placement(transformation(extent={{110,50},{90,70}},  rotation=
             0), iconTransformation(extent={{110,50},{90,70}})));

  Modelica_Fluid.Interfaces.FluidPort_a port_a2(
                                redeclare package Medium = Medium2,
                     m_flow(min=if allowFlowReversal2 then -Constants.inf else 0))
    "Fluid connector a2 (positive design flow direction is from port_a2 to port_b2)"
    annotation (Placement(transformation(extent={{90,-70},{110,-50}},
            rotation=0)));
  Modelica_Fluid.Interfaces.FluidPort_b port_b2(
                                redeclare package Medium = Medium2,
                     m_flow(max=if allowFlowReversal2 then +Constants.inf else 0))
    "Fluid connector b2 (positive design flow direction is from port_a2 to port_b2)"
    annotation (Placement(transformation(extent={{-90,-70},{-110,-50}},
                                                                     rotation=
             0), iconTransformation(extent={{-90,-70},{-110,-50}})));
  // Model structure, e.g. used for visualization
protected
  parameter Boolean port_a1_exposesState = false
    "= true if port_a1 exposes the state of a fluid volume";
  parameter Boolean port_b1_exposesState = false
    "= true if port_b1 exposes the state of a fluid volume";
  parameter Boolean port_a2_exposesState = false
    "= true if port_a1 exposes the state of a fluid volume";
  parameter Boolean port_b2_exposesState = false
    "= true if port_b1 exposes the state of a fluid volume";

  annotation (
    Diagram(coordinateSystem(
          preserveAspectRatio=true,
          extent={{-100,-100},{100,100}},
          grid={1,1}), graphics),
    Documentation(info="<html>
<p>
This partial model defines an interface for components with two ports. 
The treatment of the design flow direction and of flow reversal are predefined based on the parameter <tt><b>allowFlowReversal</b></tt>.
</p>
<ul>
<li><tt>m1_flow</tt> (or <tt>m2_flow</tt>) defines the mass flow rate in design direction, which is port_a1.m_flow.</li> 
</ul>
<p>
An extending model providing direct access to internal storage of mass or energy through port_a or port_b (or
port_a2 and port_b2)
should redefine the protected parameters <tt><b>port_a1_exposesState</b></tt> and <tt><b>port_b1_exposesState</b></tt> appropriately. 
This will be visualized at the port icons, in order to improve the understanding of fluid model diagrams.
</p>
<p>
This partial model is identical to <a href=\"Modelica:Modelica_Fluid.Interfaces.PartialTwoPort</a>
Modelica_Fluid.Interfaces.PartialTwoPort</a>, except that it has four ports.
</p>
</html>"),
    Icon(coordinateSystem(
          preserveAspectRatio=true,
          extent={{-100,-100},{100,100}},
          grid={1,1}), graphics={Text(
          extent={{-149,-114},{151,-154}},
          lineColor={0,0,255},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255},
          textString="%name")}));
end PartialFourPort;
