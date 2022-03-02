within Buildings.Experimental.DHC.Loads.Steam.BaseClasses;
model SteamTrap "Steam trap with isenthalpic expansion from high to atmospheric 
  pressure, followed by a isobaric condensation process as flashed steam 
  is brought back to a liquid state"
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface;

  final parameter Modelica.Units.SI.AbsolutePressure pAtm=101325
     "Atmospheric pressure discharge state";
  final parameter Modelica.Units.SI.Temperature TSat=100+273.15
    "Saturation temperature at atmospheric pressure";

  Medium.SpecificEnthalpy dh
    "Change in enthalpy";
  Modelica.Blocks.Interfaces.RealOutput QLos_flow(unit="W")
    "Heat transfer loss rate"
    annotation (Placement(transformation(extent={{100,60},{120,80}})));
equation
  // Pressure setpoints
  port_b.p = pAtm;

  // Flashed steam condenses
  port_b.h_outflow = Medium.specificEnthalpy(
    state=Medium.setState_pTX(
      p=pAtm,T=TSat,X=inStream(port_a.Xi_outflow)));
  dh = port_b.h_outflow - inStream(port_a.h_outflow);

  // Return reverse flow as the inStream value
  port_a.h_outflow = inStream(port_a.h_outflow);

  // Steady state conservation of mass
  port_a.m_flow + port_b.m_flow = 0;

  // Steady state conservation of energy
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
state before discharge. The model assumes a steady state isenthalpic 
thermodynamic process that transforms water from an upstream 
high pressure state to atmospheric pressure, consistent with 
physical valves that vent to the atmosphere.
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
Antoine Gautier, and Wangda Zuo. 2022. “A Fast and Accurate Modeling 
Approach for Water and Steam Thermodynamics with Practical 
Applications in District Heating System Simulation.” Preprint. February 24. 
<a href=\"http://dx.doi.org/10.13140/RG.2.2.20710.29762\">doi:10.13140/RG.2.2.20710.29762</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
March 2, 2022, by Kathryn Hinkelman:<br/>
First implementation.
</li>
</ul>
</html>"));
end SteamTrap;
