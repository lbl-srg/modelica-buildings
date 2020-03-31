within Buildings.Electrical.Transmission.Functions;
function computeGMD
  "This function computes the geometric mean distance of a three-phase transmission line"
  input Modelica.Units.SI.Length d1 "Distance between conductors";
  input Modelica.Units.SI.Length d2=d1 "Distance between conductors";
  input Modelica.Units.SI.Length d3=2*d1 "Distance between conductors";
  output Modelica.Units.SI.Length GMD "Geometric Mean Distance";
algorithm
  GMD := (d1*d2*d3)^(1.0/3.0);
annotation(Inline = true, Documentation(revisions="<html>
<ul>
<li>
June 3, 2014, by Marco Bonvini:<br/>
Added User's guide.
</li>
</ul>
</html>", info="<html>
<p>
This function computes the Geometric Mean Distance of a cable.
</p>
<p>
The GMD is computed as
</p>
<p align=\"center\" style=\"font-style:italic;\">
GMD = (d<sub>1</sub> d<sub>2</sub> d<sub>3</sub>)<sup>1/3</sup>,
</p>
<p>
where <i>d<sub>1</sub></i>, <i>d<sub>2</sub></i>, and <i>d<sub>3</sub></i> are
 the distances between the conductors.
</p>
</html>"));
end computeGMD;
