within Buildings.Fluid.Geothermal.BuriedPipes.BaseClasses;
function groundCouplingFactors
  "Geometric factors for buried pipe-ground coupling"
  extends Modelica.Icons.Function;
  input Integer nPip(min=1, fixed=true) "Number of pipes";

  input Modelica.Units.SI.Length dep[nPip] "Pipes Buried Depth";
  input Modelica.Units.SI.Length pos[nPip]
    "Pipes Horizontal Coordinate (to an arbitrary reference point)";
  input Modelica.Units.SI.Length rad[nPip] "Pipes external radius";

  output Real P[nPip, nPip] "Thermal coupling geometric factors";

algorithm
  for i in 1:nPip loop
    for j in 1:nPip loop
      if i == j then
        P[i,j] := Modelica.Math.log(2*dep[i]/rad[i]);
      else
        P[i,j] := 0.5 * Modelica.Math.log(
        ((pos[i] - pos[j])^2 + (dep[i] + dep[j])^2)/
        ((pos[i] - pos[j])^2 + (dep[i] - dep[j])^2));
      end if;
    end for;
  end for;

  annotation (Documentation(info="<html>
<p>
This function computes the multiple buried pipe system coupling matrix <i>P</i>
described by Kusuda (1981).
</p>
<p>
For a network of <i>n</i> buried pipes that are coaxial, the matrix <i>P</i> of size
<i>n x n</i> is computed from the system geometry:
</p>
<p>
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/Geothermal/BuriedPipes/BaseClasses/groundCouplingFactors.svg\" />
</p>
<p>
where: <br>
<i>a<sub>i</sub></i> = horizontal position of pipe <i>i</i> <br>
<i>d<sub>i</sub></i> = depth of pipe <i>i</i> <br>
<i>r<sub>i</sub></i> = external radius of pipe <i>i</i>
</p>
<h4>References</h4>
<p>
Kusuda, T. (1981). <i>Heat transfer analysis of underground heat 
and chilled-water distribution systems</i>. National Bureau of Standards.
</p>
</html>", revisions="<html>
<ul>
<li>
March 17, 2021, by Baptiste Ravache:<br/>
First implementation.
</li>
</ul>
</html>"));
end groundCouplingFactors;
