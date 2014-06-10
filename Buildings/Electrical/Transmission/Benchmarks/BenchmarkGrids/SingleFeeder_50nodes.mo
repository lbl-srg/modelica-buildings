within Buildings.Electrical.Transmission.Benchmarks.BenchmarkGrids;
record SingleFeeder_50nodes
  "Grid with single feder and 50 nodes for benchmark (49 nodes for the loads)"
  extends Buildings.Electrical.Transmission.Grids.PartialGrid(
    Nnodes = 50,
    Nlinks = Nnodes-1,
    L = Utilities.LineFeederLengths(Nlinks, 200, 16),
    FromTo = Utilities.LineFeederConnections(Nlinks),
    cables = Utilities.LineFeederCables(
             Nlinks,
             Buildings.Electrical.Transmission.LowVoltageCables.PvcAl120(),
             Buildings.Electrical.Transmission.LowVoltageCables.PvcAl70()));

  annotation (Documentation(info="<html>
</html>"));
end SingleFeeder_50nodes;
