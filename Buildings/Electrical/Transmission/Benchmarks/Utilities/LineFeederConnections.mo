within Buildings.Electrical.Transmission.Benchmarks.Utilities;
function LineFeederConnections
  "This functions returns a matrix containing the which nodes are connected in the feeder"
  input Integer nLinks "Number of links in the feeder";
  output Integer FromTo[nLinks,2]
    "Indexes [i,1]->[i,2] of the nodes connected by link i";
algorithm
  for i in 1:nLinks loop
    FromTo[i,1] := i;
    FromTo[i,2] := i+1;
  end for;
end LineFeederConnections;
