within Buildings.Electrical.Transmission.Benchmark.Utilities;
function LineFeederConnections
  "This functions returns a matrix containing the which nodes are connected in the feeder"
  input Integer Nlinks "Number of links in the feeder";
  output Integer FromTo[Nlinks,2]
    "Indexes [i,1]->[i,2] of the nodes connected by link i";
algorithm
  for i in 1:Nlinks loop
    FromTo[i,1] := i;
    FromTo[i,2] := i+1;
  end for;
end LineFeederConnections;
