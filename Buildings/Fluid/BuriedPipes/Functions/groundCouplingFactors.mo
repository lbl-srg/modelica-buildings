within Buildings.Fluid.BuriedPipes.Functions;
function groundCouplingFactors
  "Geometric factors for buried pipe-ground coupling"
  extends Modelica.Icons.Function;
  input Integer nPip(min=1, fixed=true) "Number of pipes";

  input Modelica.SIunits.Length dep[nPip] "Pipes Buried Depth";
  input Modelica.SIunits.Length pos[nPip] "Pipes Horizontal Coordinate (to an arbitrary reference point)";
  input Modelica.SIunits.Length rad[nPip] "Pipes external radius";

  output Real P[nPip, nPip] "Thermal coupling geometric factors";

algorithm
  for i in 1:nPip loop
    for j in 1:nPip loop
      if i == j then
        P[i,j] := Modelica.Math.log(2*dep[i]/rad[i]);
      else
        P[i,j] := Modelica.Math.log(
        ((pos[i] - pos[j])^2 + (dep[i] + dep[j])^2)/
        ((pos[i] - pos[j])^2 + (dep[i] - dep[j])^2));
      end if;
    end for;
  end for;

  annotation (Documentation(info="<html>
<p>
This function computes the multiple buried pipe system coupling matrix P described by Kusuda (1981).
</p>
<p>
For a network of n buried pipes that are coaxial, the matrix P of size n x n is 
computed from the system geometry:
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/BuriedPipes/GroundCouplingMatrix.png\" />
</p>
<p>
where a<sub>i</sub>, d<sub>i</sub> and r<sub>i</sub> corresponds to the 
horizontal position, depth and external radius, respectively, of pipe i.
</p>
<h4>References</h4>
<p>
Kusuda, T. (1981). <i>Heat transfer analysis of underground heat 
and chilled-water distribution systems</i>. National Bureau of Standards.
</p>
</html>", revisions="<html>
<ul>
<li>
March 17, 2020, by Baptiste Ravache:<br/>
First implementation.
</li>
</ul>
</html>"));
end groundCouplingFactors;
