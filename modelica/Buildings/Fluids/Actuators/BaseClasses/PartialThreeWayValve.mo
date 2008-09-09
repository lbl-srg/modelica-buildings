partial model PartialThreeWayValve "Partial three way valve" 
    extends Buildings.Fluids.BaseClasses.PartialThreeWayResistance(
        port_3(
        m_flow(start=0,min=if allowFlowReversal then -Modelica.Constants.inf else 0)),
      redeclare FixedResistances.LosslessPipe res2(
          redeclare package Medium = Medium,
          flowDirection=Modelica_Fluid.Types.FlowDirection.Bidirectional));
  
  annotation (Diagram, Icon(
      Rectangle(extent=[-100,44; 100,-36],   style(
          color=0,
          gradient=2,
          fillColor=8)),
      Rectangle(extent=[-100,26; 100,-20],   style(
          color=69,
          gradient=2,
          fillColor=69)),               Polygon(points=[-2,2; -80,64; -80,-56;
            -2,2],  style(
          color=0,
          rgbcolor={0,0,0},
          fillColor=0,
          rgbfillColor={0,0,0})),
      Polygon(points=[-70,56; -2,2; 54,44; 74,60; -70,56],  style(
          pattern=0,
          fillColor=7,
          rgbfillColor={255,255,255},
          fillPattern=1)),
      Polygon(points=[-58,-40; -2,2; 54,44; 58,-40; -58,-40],  style(
          pattern=0,
          fillColor=7,
          rgbfillColor={255,255,255},
          fillPattern=1)),
                   Polygon(points=[-2,2; 80,64; 80,-54; -2,2],   style(
          color=0,
          rgbcolor={0,0,0},
          fillColor=7,
          rgbfillColor={255,255,255})),
      Rectangle(extent=[-24,-56; 24,-100],
                                         style(
          color=0,
          rgbcolor={0,0,0},
          gradient=1,
          fillColor=8,
          rgbfillColor={192,192,192})),
      Rectangle(extent=[-14,-56; 14,-100],
                                         style(
          color=69,
          rgbcolor={0,127,255},
          gradient=1,
          fillColor=69,
          rgbfillColor={0,127,255})),   Polygon(points=[-2,2; 60,-80; -60,-80;
            -2,2],  style(
          color=0,
          rgbcolor={0,0,0},
          fillColor=0,
          rgbfillColor={0,0,0}))),
    Documentation(info="<html>
<p>
Partial model of a three way valve. This is the base model for valves
with different opening characteristics, such as linear, equal percentage
or quick opening. The three way valve model consists of a mixer where 
valves are placed in two of the flow legs. The third flow leg
has no friction. 
The flow coefficient <tt>k_SI</tt> for flow from <tt>port_1 -> port_2</tt> is
a parameter and the flow coefficient for flow from <tt>port_3 -> port_2</tt>
is computed as<pre>
         k_SI(port_1 -> port_2)
  fraK = ----------------------
         k_SI(port_3 -> port_2)
</pre> 
where <tt>fraK</tt> is a parameter.
</p><p>
Since this model uses two way valves to construct a three way valve, see 
<a href=\"Modelica:Buildings.Fluids.Actuators.BaseClasses.PartialTwoWayValve\">
PartialTwoWayValve</a> for details regarding the valve implementation.
</p>
</html>", revisions="<html>
<ul>
<li>
June 3, 2008 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"),
revisions="<html>
<ul>
<li>
June 16, 2008 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>");
  
  parameter Real k_SI(min=0, unit="(kg*m)^(1/2)") 
    "Flow coefficient for fully open valve in SI units, k=m_flow/sqrt(dp)";
  parameter Real fraK(min=0, max=1) = 0.7 
    "Fraction k_SI(port_1->port_2)/k_SI(port_3->port_2)";
  parameter Real[2] l(min=0, max=1) = {0, 0} "Valve leakage, l=Cv(y=0)/Cvs";
  parameter Real deltaM = 0.02 
    "Fraction of nominal flow rate where linearization starts, if y=1" 
    annotation(Dialog(group="Pressure-flow linearization"));
  parameter Modelica.SIunits.Pressure dp0 = 6000 "Nominal pressure drop" 
    annotation(Dialog(group="Pressure-flow linearization"));
  parameter Boolean[2] linearized = {false, false} 
    "= true, use linear relation between m_flow and dp for any flow rate" 
    annotation(Dialog(tab="Advanced"));
  
  Modelica.Blocks.Interfaces.RealInput y "Damper position (0: closed, 1: open)"
    annotation (extent=[-140,60; -100,100]);
protected 
  Modelica.Blocks.Math.Feedback inv "Inversion of control signal" 
    annotation (extent=[-54,62; -34,82]);
  Modelica.Blocks.Sources.Constant uni(final k=1) 
    "Outputs one for bypass valve" 
    annotation (extent=[-84,62; -64,82]);
equation 
  connect(uni.y, inv.u1) 
    annotation (points=[-63,72; -52,72], style(color=74, rgbcolor={0,0,127}));
end PartialThreeWayValve;
