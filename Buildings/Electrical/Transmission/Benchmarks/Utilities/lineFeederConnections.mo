within Buildings.Electrical.Transmission.Benchmarks.Utilities;
function lineFeederConnections
  "This functions returns a matrix containing the which nodes are connected in the feeder"
  input Integer nLinks "Number of links in the feeder";
  output Integer fromTo[nLinks,2]
    "Indexes [i,1]->[i,2] of the nodes connected by link i";
algorithm
  for i in 1:nLinks loop
    fromTo[i,1] := i;
    fromTo[i,2] := i+1;
  end for;

  annotation (Documentation(revisions="<html>
<ul>
<li>
Sept 19 2014 by Marco Bonvini:
Added documentation
</li>
</ul>
</html>",
        info="<html>
<p>
This function returns a matrix that contains how the nodes are
connected in a feeder.
</p>
<p>
The function assumes that the <code>nLinks</code> links in the feeder
are connected in series. The function returns a with <code>nLinks</code>
rows and 2 columns. Each row indicates a link while the column2 indicates
the nodes to which the link is connected.
</p>
<pre>
fromTo = [1,2;  // link[1] is connects nodes (1,2)
          2,3;  // link[1] is connects nodes (2,3)
          3,4]; // link[1] is connects nodes (3,4)
</pre>
</html>"));
end lineFeederConnections;
