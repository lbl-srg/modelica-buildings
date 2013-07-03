within Buildings.Fluid.SolarCollectors.BaseClasses;
block ASHRAEHeatLoss
  "Calculate the heat loss of a solar collector per ASHRAE standard 93"

  extends Buildings.Fluid.SolarCollectors.BaseClasses.PartialHeatLoss;

  parameter Modelica.SIunits.CoefficientOfHeatTransfer slope
    "slope from ratings data";

protected
  final parameter Modelica.SIunits.ThermalConductance UA(start = -slope*A_c, fixed = false)
    "Coefficient describing heat loss to ambient conditions";
initial equation
   //Identifies useful heat gain at nominal conditions
   QUse_nominal = G_nominal * A_c * y_intercept + slope * A_c * (dT_nominal);
   //Identifies TFlu[nSeg] at nominal conditions
   m_flow_nominal * Cp_avg * (dT_nominal_fluid[nSeg]) = QUse_nominal;
   //Identifies heat lost to environment at nominal conditions
   QLos_nominal = -slope * A_c * (dT_nominal);
   //Governing equation for the first segment (i=1)
   G_nominal * y_intercept * A_c/nSeg - UA/nSeg * (dT_nominal) = m_flow_nominal * Cp[1]
   * (dT_nominal_fluid[1]);
   //Loop with the governing equations for segments 2:nSeg-1
   for i in 2:nSeg-1 loop
     G_nominal * y_intercept * A_c/nSeg - UA/nSeg * (dT_nominal_fluid[i-1]+dT_nominal) =
     m_flow_nominal * Cp[i] * (dT_nominal_fluid[i]-dT_nominal_fluid[i-1]);
   end for;
   for i in 1:nSeg loop
     nSeg * QLosUA[i] = UA * (dT_nominal_fluid[i]+dT_nominal);
   end for;
   sum(QLosUA[1:nSeg]) = QLos_nominal;
equation
   for i in 1:nSeg loop
     -QLos[i] * nSeg = UA * (TFlu[i] - TEnv);
   end for;
  annotation (
    defaultComponentName="heaLos",
    Documentation(info="<html>
<p>

This component computes the heat loss from the solar thermal collector to the environment. 
It is designed anticipating ratings data collected in accordance with ASHRAE Standard 93.
A negative <code>QLos[i]</code> indicates that heat is being lost to the environment.
</p>
<p>
This model calculates the heat lost from a multiple-segment model using ratings data based 
solely on the inlet temperature. As a result, the slope from the ratings data must be converted 
to a <i>UA</i> value which,
for a given number of segments, yields the same heat loss as the ratings data 
would at nominal conditions. The first three equations, which perform calculations at 
nominal conditions without a <i>UA</i> value, are based on equations
6.17.1 through 6.17.3 in Duffie and Beckman (2006). The <i>UA</i> value is identified using the 
system of equations below:
</p>
<p align=\"center\" style=\"font-style:italic;\">
Q<sub>Use,nom</sub> = G<sub>nom</sub> A<sub>c</sub> F<sub>R</sub>(&tau;&alpha;) + 
F<sub>R</sub>U<sub>L</sub> A<sub>c</sub> (T<sub>In,nom</sub> - T<sub>Amb,nom</sub>)<br/>
T<sub>Fluid,nom</sub>[nSeg]=T<sub>In,nom</sub>+Q<sub>Use,nom</sub>/(m<sub>flow,nom</sub> 
C<sub>p</sub>)<br/>
Q<sub>Los,nom</sub>=-F<sub>R</sub>U<sub>L</sub> A<sub>c</sub> (T<sub>In,nom</sub>-T<sub>
Env,nom</sub>)<br/>
T<sub>Fluid,nom</sub>[i] = T<sub>Fluid,nom</sub>[i-1] + (G<sub>nom</sub> F<sub>R</sub> 
(&tau;&alpha;) A<sub>c</sub>/nSeg - UA/nSeg (T<sub>Fluid,nom</sub>[i-1]-T<sub>Env,nom</sub>))
/(m<sub>Flow,nom</sub> c<sub>p</sub>)<br/>
Q<sub>Loss,UA</sub>=UA/nSeg (T<sub>Fluid,nom</sub>[i]-T<sub>Env,nom</sub>)<br/>
sum(Q<sub>Loss,UA</sub>[1:nSeg])=Q<sub>Loss,nom</sub>
</p>
The effective <i>UA</i> value is calculated at the 
beginning of the simulation and used as a constant through the rest of the simulation.
The actual heat loss from the collector is calculated using
<p align=\"center\" style=\"font-style:italic;\">
-Q<sub>Loss</sub>[i] = UA/nSeg (T<sub>Fluid</sub>[i] - T<sub>Env</sub>)
</p>
<h4>References</h4>
<p>
J.A. Duffie and W.A. Beckman 2006, Solar Engineering of Thermal Processes (3rd Edition), 
John Wiley &amp; Sons, Inc. <br/>
ASHRAE 93-2010 -- Methods of Testing to Determine the Thermal Performance of Solar 
Collectors (ANSI approved)
</p>
</html>", revisions="<html>
<ul>
<li>
Jan 16, 2012, by Peter Grant:<br/>
First implementation
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}),
            graphics),
    Icon(graphics={Text(
          extent={{-48,-32},{36,-66}},
          lineColor={0,0,255},
          textString="%name")}));
end ASHRAEHeatLoss;
