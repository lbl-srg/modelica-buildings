within Buildings.Fluid.SolarCollectors.BaseClasses;
block ASHRAEHeatLoss
  "Calculate the heat loss of a solar collector per ASHRAE standard 93"
  extends Buildings.Fluid.SolarCollectors.BaseClasses.PartialHeatLoss(
  final QLos_nominal = slope * A_c * dT_nominal
    "Heat loss at nominal condition, for reporting only",
  QLos_internal = -slope * A_c/nSeg * {dT[i] for i in 1:nSeg});

  parameter Real slope(final max=0, final unit = "W/(m2.K)")
    "Slope from ratings data";

annotation (
defaultComponentName="heaLos",
Documentation(info="<html>
<p>
This component computes the heat loss from the solar thermal collector to the
environment.
It is designed for use with ratings data collected in accordance with 
ASHRAE Standard 93.
A negative heat loss indicates that heat is being lost to the environment.
</p>

<h4> Model description </h4>
<p>
This model calculates the heat loss to the ambient, for each segment 
<i>i &isin; {1, ..., n<sub>seg</sub>}</i> where <i>n<sub>seg</sub></i> is 
the number of segments, as
</p>
<p align=\"center\" style=\"font-style:italic;\">
Q<sub>los,i</sub> = -slope A<sub>c</sub> &frasl; n<sub>seg</sub>
  (T<sub>env</sub>-T<sub>flu,i</sub>)
</p>
<p>
where
<i>slope &lt; 0</i> is the slope for the heat loss as specified in the ratings 
data, <i>A<sub>c</sub></i> is the collector area, <i>T<sub>env</sub></i> is
the environment temperature, and <i>T<sub>flu,i</sub></i> is the 
fluid temperature in segment <i>i &isin; {1, ..., n<sub>seg</sub>}</i>.
</p>
<p>
This model reduces the heat loss rate to <i>0</i> when the fluid temperature 
is within <i>1</i> Kelvin of the minimum temperature of the medium model. 
The calculation is performed using the 
<a href=\"modelica://Buildings.Utilities.Math.Functions.smoothHeaviside\">
Buildings.Utilities.Math.Functions.smoothHeaviside</a> function.
</p>

<h4>Implementation</h4>
<p>
ASHRAE uses the collector fluid inlet temperature to compute the heat loss 
(see Duffie and Beckmann, p. 293).
However, unless the environment temperature which was present during the 
collector rating is known, which is not the case, one cannot compute a 
log mean temperature difference that would improve the <i>UA</i> calculation.
Hence, this model is using the fluid temperature of each segment
to compute the heat loss to the environment.
</p>

<h4>References</h4>
<p>
ASHRAE 93-2010 -- Methods of Testing to Determine the Thermal Performance of Solar
Collectors (ANSI approved)
</p>
<p>
J.A. Duffie and W.A. Beckman 2006, Solar Engineering of Thermal Processes (3rd Edition),
John Wiley &amp; Sons, Inc.
</p>
</html>", revisions="<html>
<ul>
<li>
January, 2024, by Jelger Jansen:<br/>
Refactor model.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3604\">Buildings, #3604</a>.
</li>      
<li>
December 17, 2017, by Michael Wetter:<br/>
Revised computation of heat loss.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1100\">
issue 1100</a>.
</li>
<li>
Jan 16, 2012, by Peter Grant:<br/>
First implementation
</li>
</ul>
</html>"));
end ASHRAEHeatLoss;
