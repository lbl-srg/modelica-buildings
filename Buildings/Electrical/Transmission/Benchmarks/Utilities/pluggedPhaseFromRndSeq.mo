within Buildings.Electrical.Transmission.Benchmarks.Utilities;
function pluggedPhaseFromRndSeq
  "This function returns a sequence of booleand that describe which phases are connected given a random sequence of numbers"
  input Integer N "Numbner of elements in the vector";
  input Real min = 0 "Boundaries to consider";
  input Real max = 1 "Boundaires to consider";
  input Real val[N] "Sequence or random numbers provided";
  output Boolean flags[N]
    "Vector of boolean representing if the phases are connected or not";
protected
  Integer j "Iteration variable";
algorithm

  for i in 1:N loop
    if val[i]>=min and val[i]<max then
      flags[i] := true;
    else
      flags[i] := false;
    end if;
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
This function returns a vector of boolean variable that can be used
to decide which phase of a three phases unbalanced system
should be connected to a specific node of the feeder, depending on 
an array of random numbers.
</p>
<p>
The function takes as inputs <code>N</code> the number of elements
of the array, <code>val</code> the array of random numbers comprises
between 0 and 1, <code>min</code> and <code>max</code> the boundaries
of the region that identify if a random number will be transformed in 
a True or False value.
</p>
<pre>
N = 10;
val = {0.3, 0.5, 0.65, 0.7};
min = 0.63;
max = 0.99;
sequence = pluggedPhaseFromRndSeq(N,min,max,val);
</pre>
<p>
produces a sequence like
</p>
<pre>
   1     2       3     4    
{False, False, True, True}
</pre>
</html>"));
end pluggedPhaseFromRndSeq;
