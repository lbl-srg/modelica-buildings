within Buildings.Electrical.Transmission.Benchmarks.BenchmarkGrids;
record SingleFeeder_40nodes
  "Grid with single feder and 40 nodes for benchmark (39 nodes for the loads)"
  extends Buildings.Electrical.Transmission.Grids.PartialGrid(
    Nnodes = 40,
    Nlinks = Nnodes-1,
    L = Utilities.LineFeederLengths(Nlinks, 200, 16),
    FromTo = Utilities.LineFeederConnections(Nlinks),
    cables = Utilities.LineFeederCables(
             Nlinks,
             Buildings.Electrical.Transmission.LowVoltageCables.PvcAl120(),
             Buildings.Electrical.Transmission.LowVoltageCables.PvcAl70()));

  annotation (Documentation(info="<html>
</html>"));
end SingleFeeder_40nodes;
