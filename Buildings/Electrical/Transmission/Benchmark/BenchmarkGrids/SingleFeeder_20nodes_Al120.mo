within Buildings.Electrical.Transmission.Benchmark.BenchmarkGrids;
record SingleFeeder_20nodes_Al120
  "Grid with single feder and 20 nodes for benchmark (19 nodes for the loads)"
  extends Buildings.Electrical.Transmission.Grids.PartialGrid(
    Nnodes = 20,
    Nlinks = Nnodes-1,
    L = Buildings.Electrical.Transmission.Benchmark.Utilities.LineFeederLengths(Nlinks, 200, 16),
    FromTo = Buildings.Electrical.Transmission.Benchmark.Utilities.LineFeederConnections(Nlinks),
    cables = Buildings.Electrical.Transmission.Benchmark.Utilities.LineFeederCables(
             Nlinks,
             Buildings.Electrical.Transmission.LowVoltageCables.PvcAl120(),
             Buildings.Electrical.Transmission.LowVoltageCables.PvcAl120()));

  annotation (Documentation(info="<html>
</html>"));
end SingleFeeder_20nodes_Al120;
