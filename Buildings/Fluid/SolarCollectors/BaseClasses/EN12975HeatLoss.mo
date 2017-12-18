within Buildings.Fluid.SolarCollectors.BaseClasses;
block EN12975HeatLoss "Calculate the heat loss of a solar collector per EN12975"
  extends Buildings.Fluid.SolarCollectors.BaseClasses.PartialHeatLoss(
    final QLos_nominal = -A_c * (C1 * dT_nominal - C2 * dT_nominal^2),
    QLosInt = A_c/nSeg * {dT[i] * (C1 - C2 * dT[i]) for i in 1:nSeg});

  parameter Modelica.SIunits.CoefficientOfHeatTransfer C1 "C1 from ratings data";

  parameter Real C2(final unit = "W/(m2.K2)") "C2 from ratings data";

protected
  Modelica.SIunits.TemperatureDifference dT[nSeg] "Environment minus collector fluid temperature";

equation
  for i in 1:nSeg loop
    dT[i] = TEnv-TFlu[i];
  end for;

annotation (
defaultComponentName="heaLos",
Documentation(info="<html>
<p>
This component computes the heat loss from the solar thermal collector
to the environment. It is designed anticipating ratings data collected in
accordance with EN12975. A negative <code>QLos[i]</code> indicates that
heat is being lost to the environment.
</p>
<p>
This model calculates the heat lost from a multiple-segment model using
ratings data based on the mean collector temperature. As a result, the
slope from the ratings data must be converted to a <i>UA</i> value which,
for a given number of segments, returns the same heat loss as the ratings
data would at nominal conditions. The <i>UA</i> value is identified using
the system of equations below:
</p>
<p align=\"center\" style=\"font-style:italic;\">
Q<sub>Use,nom</sub> &frasl; A<sub>c</sub> = G<sub>nom</sub> F<sub>R</sub>
(&tau;&alpha;) - C<sub>1</sub> (T<sub>Mean,nom</sub>-
T<sub>Env,nom</sub>)-C<sub>2</sub> (T<sub>Mean,nom</sub>
-T<sub>Env,nom</sub>)<sup>2</sup><br/>
Q<sub>Use,nom</sub> = m<sub>Flow,nom</sub> c<sub>p</sub>
(T<sub>Fluid,nom</sub>[nSeg]-T<sub>Mean,nom</sub>)<br/>
Q<sub>Los,nom</sub> &frasl; A<sub>c</sub> = -C<sub>1</sub> (T<sub>Mean,nom</sub>-T
<sub>Env,nom</sub>)-C<sub>2</sub> (T<sub>Mean,nom</sub>-
T<sub>Env,nom</sub>)<sup>2</sup><br/>
T<sub>Fluid,nom</sub>[i] = T<sub>Fluid,nom</sub>[i-1] + (G<sub>nom</sub>
F<sub>R</sub>(&tau;&alpha;) A<sub>c</sub>/nSeg - Q<sub>Los,UA</sub>) &frasl;
(m<sub>Flow,nom</sub> c<sub>p</sub>)<br/>
Q<sub>Los,UA</sub>=UA/nSeg (T<sub>Fluid,nom</sub>[i]-T<sub>Env,nom
</sub>)<br/>
sum(Q<sub>Los,UA</sub>[1:nSeg])=Q<sub>Los,nom</sub>
</p>
<p>
where <i>Q<sub>Use,nom</sub></i> is the useful heat gain at nominal
conditions,<i>G<sub>nom</sub></i> is the nominal solar irradiance,
<i>A<sub>c</sub></i> is the area of the collector, <i>F<sub>R</sub>
(&tau;&alpha;)</i> is the collector maximum efficiency, <i>C<sub>1
</sub></i> is the collector heat loss coefficient, <i>C<sub>2</sub></i>
is the temperature dependance of the heat loss coefficient, <i>T<sub>Mean,
nom</sub></i> is the nominal mean temperature of the solar collector, <i>T
<sub>Env,nom</sub></i> is the ambient temperature at nominal conditions,
<i>T<sub>Fluid,nom</sub>[i]</i> is the temperature of fluid in a given
segment of the collector, <i>m<sub>Flow,nom</sub></i> is the fluid flow at
nominal conditions, <i>c<sub>p</sub></i> is the specific heat of the heated
fluid, <i>Q<sub>Los,nom</sub></i> is the heat loss identified using
the default value <i>UA</i> is the identified heat loss coefficient for a
multiple-segment equivalent solar collector, <i>nSeg</i> is the number of
segments in the simulation, and <i>Q<sub>Loss,UA</sub></i> is the heat
loss identified using the <i>UA</i> value.
</p>
<p>
The effective <i>UA</i> value is calculated at the beginning of the
simulation and used as a constant through the rest of the simulation. The
actual heat loss from the collector is calculated using
</p>
<p align=\"center\" style=\"font-style:italic;\">
Q<sub>Los</sub>[i] = UA/nSeg (T<sub>Fluid</sub>[i] - T<sub>Env</sub>).
</p>
<p>
where <i>Q<sub>Loss</sub>[i]</i> is the heat loss from a given segment,
<i>UA</i> is the heat loss coefficient for a multiple segments model,
<i>nSeg</i> is the number of segments in the simulation,<i>T<sub>Fluid
</sub>[i]</i> is the temperature of the fluid in a given segment, and
<i>T<sub>Env</sub></i> is the temperature of the surrounding air.
</p>
<p>
This model reduces the heat loss rate to 0 W when the fluid temperature
is within 1 degree C of the minimum temperature of the medium model.
The calculation is performed using the
<a href=\"modelica://Buildings.Utilities.Math.Functions.smoothHeaviside\">
Buildings.Utilities.Math.Functions.smoothHeaviside</a> function.
</p>
<h4>Implementation</h4>
<p>
EN 12975 uses the arithmetic average temperature of the collector fluid inlet
and outlet temperature to compute the heat loss (see Duffie and Beckmann, p. 293).
However, unless TEnv is known, which is not the case, one cannot compute
a LMTD that would improve the UA calculation. Hence,
we are simply using dT_nominal
</p>
<h4>References</h4>
<p>
CEN 2006, European Standard 12975-1:2006, European Committee for Standardization
</p>
</html>",
revisions="<html>
<ul>
<li>
December 14, 2017, by Michael Wetter:<br/>
Revised computation of <code>UA</code>.<br/>
This is for
<a href=\"modelica://https://github.com/lbl-srg/modelica-buildings/issues/1100\">
issue 1100</a>.
</li>
<li>
Jan 16, 2012, by Peter Grant:<br/>
First implementation
</li>
</ul>
</html>"));
end EN12975HeatLoss;
