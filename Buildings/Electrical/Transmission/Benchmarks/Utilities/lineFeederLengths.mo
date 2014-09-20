within Buildings.Electrical.Transmission.Benchmarks.Utilities;
function lineFeederLengths
  "This functions returns a vector containing the lenght of the lines for each feeder"
  input Integer nLinks "Number of cables connecting the nodes on the feeder";
  input Modelica.SIunits.Length l0 "Length of the initial link";
  input Modelica.SIunits.Length li "Length of the other links";
  output Modelica.SIunits.Length l[nLinks,1](each min=0) "Length of the cables";
algorithm
  l[1,1] :=l0;
  for i in 2:nLinks loop
    l[i,1] := li;
  end for;

  annotation (Documentation(revisions="<html>
<ul>
<li>
Sept 19 2014 by Marco Bonvini:
Added documentation
</li>
</ul>
</html>", info="<html>
<p>
This function returns a matrix that contains the length of the
cables of feeder.
</p>
<p>
The function takes as input the number of links <code>nLinks</code> in the feeder
and returns a matrix with <code>nLinks</code> rows and 1 column that contains
the legth of each link. The lengths are obtained using the parameters
<code>l0</code> (length of the first element) and <code>li</code> length of the
other ones.
</p>
</html>"));
end lineFeederLengths;
