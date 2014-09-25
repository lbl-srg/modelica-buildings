within Buildings.Electrical.Transmission.Benchmarks.Utilities;
function lineFeederCables
  "This functions returns a vector of cables for the feeder"
  input Integer nLinks "Number of links in the feeder";
  replaceable input Buildings.Electrical.Transmission.BaseClasses.BaseCable cable_0
    "Cable for the initial link";
  replaceable input Buildings.Electrical.Transmission.BaseClasses.BaseCable cable_i
    "Cable for the other links";
  replaceable output Buildings.Electrical.Transmission.BaseClasses.BaseCable cables[nLinks]
    "Array that contains the characteristics of each cable";
algorithm
  cables[1] := cable_0;
  for i in 2:nLinks loop
    cables[i] := cable_i;
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
This function returns an array that contains the type of
cables that are part of the feeder.
</p>
<p>
The function takes as input the number of links <code>nLinks</code> in the feeder
and returns an array with <code>nLinks</code> cable types.
The types are obtained using the parameters
<code>cable_0</code> (cable of the first link) and <code>cable_i</code> cables of the
other ones.
</p>
</html>"));
end lineFeederCables;
