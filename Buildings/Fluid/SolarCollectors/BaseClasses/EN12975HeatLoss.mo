within Buildings.Fluid.SolarCollectors.BaseClasses;
block EN12975HeatLoss "Calculate the heat loss of a solar collector per EN12975"
  extends Buildings.Fluid.SolarCollectors.BaseClasses.PartialHeatLoss(
    final QLos_nominal = -A_c * (C1 * dT_nominal - C2 * dT_nominal^2)
      "Heat loss at nominal condition, for reporting only",
    QLos_internal = A_c/nSeg * {dT[i] * (C1 - C2 * dT[i]) for i in 1:nSeg});

  parameter Modelica.SIunits.CoefficientOfHeatTransfer C1(final min=0)
    "C1 from ratings data";

  parameter Real C2(final unit = "W/(m2.K2)", final min=0)
    "C2 from ratings data";

annotation (
defaultComponentName="heaLos",
Documentation(info="<html>
<p>
This component computes the heat loss from the solar thermal collector
to the environment. It is designed anticipating ratings data collected in
accordance with EN12975. A negative heat loss indicates that heat
is being lost to the environment.
</p>
<p>
This model calculates the heat loss to the ambient, for each
segment <i>i &isin; {1, ..., n<sub>seg</sub>}</i>
where <i>n<sub>seg</sub></i> is the number of segments, as
</p>
<p align=\"center\" style=\"font-style:italic;\">
Q<sub>los,i</sub> = A<sub>c</sub> &frasl; n<sub>seg</sub> 
(T<sub>env</sub>-T<sub>flu,i</sub>) (C<sub>1</sub> - C<sub>2</sub> (T<sub>env</sub>-T<sub>flu,i</sub>))
</p>
<p>
where
<i>C<sub>1</sub> &gt; 0</i> is the heat loss coefficient from EN12975 ratings data,
<i>C<sub>2</sub> &ge; 0</i> is the temperature dependence of heat loss from EN12975 ratings data,
<i>A<sub>c</sub></i> is the collector area,
<i>T<sub>env</sub></i> is the environment temperature and
<i>T<sub>flu,i</sub></i> is the fluid temperature in segment
<i>i &isin; {1, ..., n<sub>seg</sub>}</i>.
</p>
<p>
This model reduces the heat loss rate to <i>0</i> when the fluid temperature is within
<i>1</i> Kelvin of the minimum temperature of the medium model. The calculation is
performed using the
<a href=\"modelica://Buildings.Utilities.Math.Functions.smoothHeaviside\">
Buildings.Utilities.Math.Functions.smoothHeaviside</a> function.
</p>
<h4>Implementation</h4>
<p>
EN 12975 uses the arithmetic average temperature of the collector fluid inlet
and outlet temperature to compute the heat loss (see Duffie and Beckmann, p. 293).
However, unless the environment temperature that was present during the collector rating
is known, which is not the case, one cannot compute
a log mean temperature difference that would improve the <i>UA</i> calculation. Hence,
this model is using the fluid temperature of each segment
to compute the heat loss to the environment.
If the arithmetic average temperature were used, then segments at the collector
outlet could be cooled below the ambient temperature, which violates the 2nd law
of Thermodynamics.
</p>
<h4>References</h4>
<p>
CEN 2006, European Standard 12975-1:2006, European Committee for Standardization
</p>
</html>",
revisions="<html>
<ul>
<li>
December 17, 2017, by Michael Wetter:<br/>
Revised computation of heat loss.<br/>
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
