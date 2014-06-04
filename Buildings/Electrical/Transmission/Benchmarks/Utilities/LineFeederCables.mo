within Buildings.Electrical.Transmission.Benchmarks.Utilities;
function LineFeederCables
  "This functions returns a vector of cables for the feeder"
  input Integer Nlinks "Number of links in the feeder";
  input Buildings.Electrical.Transmission.Base.BaseCable cable_0
    "Cable for the initial link";
  input Buildings.Electrical.Transmission.Base.BaseCable cable_i
    "Cable for the other links";
  output Buildings.Electrical.Transmission.Base.BaseCable cables[Nlinks]
    "Array that contains the characteristics of each cable";
algorithm
  cables[1] := cable_0;
  for i in 2:Nlinks loop
    cables[i] := cable_i;
  end for;
end LineFeederCables;
