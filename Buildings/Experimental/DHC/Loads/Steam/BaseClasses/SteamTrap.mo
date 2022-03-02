within Buildings.Experimental.DHC.Loads.Steam.BaseClasses;
model SteamTrap "Steam trap with isenthalpic expansion from high to atmospheric pressure,  
  with all flashed steam discharged as condensate"
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface;
//  parameter Modelica.SIunits.AbsolutePressure pSte
//    "Steam pressure at trap inlet";
  final parameter Modelica.SIunits.AbsolutePressure pAtm=101325
     "Atmospheric pressure discharge state";
  final parameter Modelica.SIunits.Temperature TSat=100+273.15
    "Saturation temperature at atmospheric pressure";
//  final parameter Medium.SpecificEnthalpy hl=419100
//    "Enthalpy of saturated liquid at atmospheric pressure";
  Medium.SpecificEnthalpy dh
    "Change in enthalpy";
  Modelica.Blocks.Interfaces.RealOutput QLos_flow(unit="W") "Heat transfer loss rate"
    annotation (Placement(transformation(extent={{100,60},{120,80}})));
equation
  // Pressure setpoints
  port_b.p = pAtm;

  // Isenthalpic process assumed: no change in enthalpy
  port_a.h_outflow = inStream(port_a.h_outflow);

  // Flashed steam condenses
  port_b.h_outflow = Medium.specificEnthalpy(
    state=Medium.setState_pTX(
      p=pAtm,T=TSat,X=inStream(port_a.Xi_outflow)));
  dh = port_b.h_outflow - inStream(port_a.h_outflow);

  // Reverse flow
//  inStream(port_b.h_outflow) = port_b.h_outflow;
//  port_a.h_outflow = hl + dh;

  // Steady state conservation of mass
  port_a.m_flow + port_b.m_flow = 0;

  // Conservation of energy
  port_a.m_flow*dh = QLos_flow;

  annotation (
    defaultComponentName="tra",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-80,80},{80,-80}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-40,-40},{40,40}},
          lineColor={0,0,0},
          lineThickness=1),
        Ellipse(
          extent={{-40,40},{40,-40}},
          lineColor={0,0,0},
          lineThickness=1,
          startAngle=-45,
          endAngle=135,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid)}),
                                 Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
The steam trap ensures that only liquid condensate leaves 
the component, while any flashed steam is returned to a liquid
state before discharge. The model that assumes an isenthalpic 
thermodynamic process that transforms water from an upstream 
high pressure state to atmospheric pressure, consistent with 
physical valves that contains vents to atmosphere.
</p>
<h4>Implementation</h4>
<p>
This model uses a split-medium approach for liquid and vapor 
phases of water to improve the numerical performance of steam 
heating systems by decoupling pressure and density in the medium 
formulations.
</p>
<h4>Reference</h4>
<p>
Hinkelman, Kathryn, Saranya Anbarasu, Michael Wetter, 
Antoine Gautier, and Wangda Zuo. 2021. “A New Steam 
Medium Model for Fast and Accurate Simulation of District 
Heating Systems.” engrXiv. October 8. 
<a href=\\\"https://engrxiv.org/cqfmv/\\\">doi:10.31224/osf.io/cqfmv</a>
</p>
</html>", revisions="<html>
<ul>
<li>
December 7, 2021 by Kathryn Hinkelman:<br/>
First implementation.
</li>
</ul>
</html>"));
end SteamTrap;
