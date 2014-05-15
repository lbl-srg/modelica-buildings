within Buildings.Electrical.Transmission.Benchmark.Utilities;
function PluggedPhaseFromRndSeq
  "This function returns a sequence of booleand that describe which phases are connected given a random sequence of numbers"
  input Integer N "Numbner of elements in the vector";
  input Real min = 0 "Boundaries to consider";
  input Real max = 1 "Boundaires to consider";
  input Real val[N] "Sequence or random numbers provided";
  output Boolean flags[N]
    "vector of boolean representing if the phases are connected or not";
protected
  Integer j;
algorithm

  for i in 1:N loop
    if val[i]>=min and val[i]<max then
      flags[i] := true;
    else
      flags[i] := false;
    end if;
  end for;

end PluggedPhaseFromRndSeq;
