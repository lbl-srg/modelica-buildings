within Buildings.Electrical.Transmission.Benchmarks.Utilities;
function PluggedPhaseSequence
  "This function returns a sequence of booleand that describe which phases are connected"
  input Integer N "Numbner of elements in the vector";
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

end PluggedPhaseSequence;
