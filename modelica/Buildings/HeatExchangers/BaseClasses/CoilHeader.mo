model CoilHeader "Header for a heat exchanger register" 
  extends Buildings.BaseClasses.BaseIcon;
  extends Buildings.Fluids.Interfaces.PartialSingleFluidParameters;
  annotation (Diagram,
Documentation(info="<html>
<p>
Header for a heat exchanger coil.</p>
</p>
<p>
This model connects the flow between its ports without
modeling flow friction.
Currently, the ports are connected without redistributing
the flow. In latter versions, the model may be changed to define
different flow reroutings in the coil header.
</p>
</html>",
revisions="<html>
<ul>
<li>
April 14, 2008, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"),
 Icon(Rectangle(extent=[-100,-58; 100,-62],
                                         style(
          color=3,
          rgbcolor={0,0,255},
          fillColor=3,
          rgbfillColor={0,0,255},
          fillPattern=1)),
      Rectangle(extent=[-102,2; 100,-2],
                                      style(
          color=3,
          rgbcolor={0,0,255},
          fillColor=3,
          rgbfillColor={0,0,255},
          fillPattern=1)),
      Rectangle(extent=[-100,62; 100,58],
                                       style(
          color=3,
          rgbcolor={0,0,255},
          fillColor=3,
          rgbfillColor={0,0,255},
          fillPattern=1))));
  
  parameter Integer nPipPar(min=1) "Number of parallel pipes in each register";
  Modelica_Fluid.Interfaces.FluidPort_a port_a[nPipPar](
        redeclare each final package Medium = Medium,
        each m_flow(start=0, min=if allowFlowReversal then -Modelica.Constants.inf else 0)) 
    "Fluid connector a for medium (positive design flow direction is from port_a to port_b)"
    annotation (extent=[-110,-10; -90,10]);
  
  Modelica_Fluid.Interfaces.FluidPort_b port_b[nPipPar](
        redeclare each final package Medium = Medium,
        each m_flow(start=0, max=if allowFlowReversal then +Modelica.Constants.inf else 0)) 
    "Fluid connector b for medium (positive design flow direction is from port_a to port_b)"
    annotation (extent=[110,-10; 90,10]);
  
equation 
  connect(port_a, port_b) annotation (points=[-100,5.55112e-16; -50,5.55112e-16;
        -50,0; 100,0; 100,5.55112e-16], style(
      color=69,
      rgbcolor={0,127,255},
      fillColor=3,
      rgbfillColor={0,0,255},
      fillPattern=1));
end CoilHeader;
