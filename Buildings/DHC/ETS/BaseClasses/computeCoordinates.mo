within Buildings.DHC.ETS.BaseClasses;
function computeCoordinates
  "Coordinates of evenly distributed boreholes given the number of boreholes"
  extends Modelica.Icons.Function;

  input Integer nBorHol
    "Number of boreholes";
  input Modelica.Units.SI.Distance dxy=6
    "Distance in x-axis (and y-axis) between borehole axes";
  output Modelica.Units.SI.Distance cooBor[nBorHol,2]
    "Coordinates of boreholes";
protected
  Integer k=1
    "Iteration index";
algorithm
  for i in 0:sqrt(
    nBorHol)-1 loop
    for j in 0:sqrt(
      nBorHol)-1 loop
      cooBor[k,1] := i*dxy;
      cooBor[k,2] := j*dxy;
      k := k+1;
    end for;
  end for;
  annotation (
    Documentation(
      revisions="<html>
<ul>
<li>
July 31, 2020, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>",
      info="<html>
<p>
This function computes the coordinates of boreholes evenly
distributed along the <code>x</code> and <code>y</code> axis,
given the number of boreholes (which must be the square of
an integer).
</p>
</html>"));
end computeCoordinates;
