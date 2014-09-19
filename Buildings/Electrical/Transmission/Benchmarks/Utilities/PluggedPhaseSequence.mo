within Buildings.Electrical.Transmission.Benchmarks.Utilities;
function PluggedPhaseSequence
  "This function returns a sequence of booleand that describe which phases are connected"
  input Integer N "Number of elements in the vector";
  input Integer first = 1 "Position of the first element to be True";
  input Integer Mod = 3 "Period of the sequence";
  output Boolean flags[N]
    "Vector of boolean representing if the phases are connected or not";
protected
  Integer j "Iteration variable";
algorithm

  for i in 1:N loop
    j := i - first;
    if mod(j, Mod)==0 then
      flags[i] := true;
    else
      flags[i] := false;
    end if;
  end for;

  annotation (Documentation(revisions="<html>
<ul>
<li>
Sept 19 2014 by Marco Bonvini:</br>
Added documentation
</li>
</ul>
</html>", info="<html>
<p>
This function returns a vector of boolean variable that can be used
to decide which phase of a three phases unbalanced system
should be connected to a specific node of the feeder.
</p>
<p>
The function takes as inputs <code>N</code> the number of elements
of the array, <code>first</code> the index of the first element that 
will be True, and <code>Mod</code> the period of the sequence.
</p>
<pre>
N = 10;
first = 2;
Mod = 3;
sequence = PluggedPhaseSequence(N,first,Mod);
</pre>
<p>
produces a sequence like
</p>
<pre>
   1     2     3      4      5     6      7      8     9      10
{False, True, False, False, True, False, False, True, False, False}
</pre>
</html>"));
end PluggedPhaseSequence;
