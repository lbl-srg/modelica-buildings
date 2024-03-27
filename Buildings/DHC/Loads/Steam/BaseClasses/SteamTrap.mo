within Buildings.DHC.Loads.Steam.BaseClasses;
model SteamTrap "Steam trap with isenthalpic expansion from high to atmospheric
  pressure, followed by a isobaric condensation process as flashed steam
  is brought back to a liquid state"
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(
      redeclare replaceable package Medium=Buildings.Media.Water);

  constant Modelica.Units.SI.AbsolutePressure pAtm=101325
     "Atmospheric pressure discharge state";
  constant Modelica.Units.SI.Temperature TSat=
    Buildings.Media.Steam.saturationTemperature(pAtm)
    "Saturation temperature at atmospheric pressure";

  Modelica.Blocks.Interfaces.RealOutput QLos_flow(unit="W")
    "Heat transfer loss rate"
    annotation (Placement(transformation(extent={{100,60},{120,80}})));

  Medium.SpecificEnthalpy dh
    "Change in enthalpy";
equation
  // Pressure setpoints
  port_b.p = pAtm;

  // Flashed steam condenses
  port_b.h_outflow = Medium.specificEnthalpy(
    state=Medium.setState_pTX(
      p=pAtm,
      T=TSat,
      X=inStream(port_a.Xi_outflow)));
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
high pressure state to atmospheric pressure, followed by an
isobaric condensation process as flashed steam vapor is returned to
a liquid state. This implementation is consistent with
physical valves that vent to the atmosphere.
</p>
<h4>References </h4>
<p>
Kathryn Hinkelman, Saranya Anbarasu, Michael Wetter, Antoine Gautier, Wangda Zuo. 2022.
&ldquo;A Fast and Accurate Modeling Approach for Water and Steam
Thermodynamics with Practical Applications in District Heating System Simulation,&rdquo;
<i>Energy</i>, 254(A), pp. 124227.
<a href=\"https://doi.org/10.1016/j.energy.2022.124227\">10.1016/j.energy.2022.124227</a>
</p>
<p>
Kathryn Hinkelman, Saranya Anbarasu, Michael Wetter, Antoine Gautier, Baptiste Ravache, Wangda Zuo 2022.
&ldquo;Towards Open-Source Modelica Models For Steam-Based District Heating Systems.&rdquo;
<i>Proc. of the 1st International Workshop On Open Source Modelling And Simulation Of
Energy Systems (OSMSES 2022)</i>, Aachen, German, April 4-5, 2022.
<a href=\"https://doi.org/10.1109/OSMSES54027.2022.9769121\">10.1109/OSMSES54027.2022.9769121</a>
</p>
</html>", revisions="<html>
<ul>
<li>
September 15, 2023, by Kathryn Hinkelman:<br/>
Added publication references.
</li>
<li>
March 2, 2022, by Kathryn Hinkelman:<br/>
First implementation.
</li>
</ul>
</html>"));
end SteamTrap;
