partial model PartialDuctPipeManifold 
  "Partial heat exchanger duct and pipe manifold" 
  extends Buildings.BaseClasses.BaseIcon;
  extends Buildings.Fluids.Interfaces.PartialSingleFluidParameters;
  
  annotation (Icon(
      Rectangle(extent=[-96,2; 0,-2], style(
          color=3,
          rgbcolor={0,0,255},
          fillColor=3,
          rgbfillColor={0,0,255},
          fillPattern=1)),
      Rectangle(extent=[0,62; 100,58], style(
          color=3,
          rgbcolor={0,0,255},
          fillColor=3,
          rgbfillColor={0,0,255},
          fillPattern=1)),
      Rectangle(extent=[0,2; 100,-2], style(
          color=3,
          rgbcolor={0,0,255},
          fillColor=3,
          rgbfillColor={0,0,255},
          fillPattern=1)),
      Rectangle(extent=[0,-58; 100,-62], style(
          color=3,
          rgbcolor={0,0,255},
          fillColor=3,
          rgbfillColor={0,0,255},
          fillPattern=1)),
      Rectangle(extent=[-2,-62; 2,62], style(
          color=3,
          rgbcolor={0,0,255},
          fillColor=3,
          rgbfillColor={0,0,255},
          fillPattern=1)),
      Text(
        extent=[-84,-48; 84,-120],
        style(
          color=3,
          rgbcolor={0,0,255},
          fillColor=3,
          rgbfillColor={0,0,255},
          fillPattern=1))),
    Diagram,Documentation(info="<html>
<p>
Partial heat exchanger manifold.
This partial model defines ports and parameters that are used
for air-side and water-side heat exchanger manifolds.
</p>
</html>",
revisions="<html>
<ul>
<li>
August 22, 2008, by Michael Wetter:<br>
Added start value for port mass flow rate.
</li>
<li>
April 14, 2008, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
  parameter Integer nPipPar(min=1) "Number of parallel pipes in each register";
  
  parameter Modelica.SIunits.MassFlowRate mStart_flow_a 
    "Guess value for mass flow rate at port_a" 
    annotation(Dialog(group = "Initialization"));
  
  Modelica_Fluid.Interfaces.FluidPort_a port_a(
        redeclare package Medium = Medium,
        m_flow(start=mStart_flow_a, min=if allowFlowReversal then -Modelica.Constants.inf else 0)) 
    "Fluid connector a for medium (positive design flow direction is from port_a to port_b)"
    annotation (extent=[-110,-10; -90,10]);
end PartialDuctPipeManifold;
