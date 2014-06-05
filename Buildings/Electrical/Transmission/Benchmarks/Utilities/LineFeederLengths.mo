within Buildings.Electrical.Transmission.Benchmarks.Utilities;
function LineFeederLengths
  "This functions returns a vector containing the lenght of the lines for each feeder"
  input Integer Nlinks "Number of cables connecting the nodes on the feeder";
  input Modelica.SIunits.Length L0 "Length of the initial link";
  input Modelica.SIunits.Length Li "Length of the other links";
  output Modelica.SIunits.Length L[Nlinks,1](each min=0) "Length of the cables";
algorithm
  L[1,1] :=L0;
  for i in 2:Nlinks loop
    L[i,1] := Li;
  end for;
end LineFeederLengths;
