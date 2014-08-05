within Buildings.Electrical.Transmission.Benchmarks.BenchmarkGrids;
record SingleFeeder_10nodes_Al35
  "Grid with single feder and 10 nodes for benchmark (9 nodes for the loads)"
  extends Buildings.Electrical.Transmission.Grids.PartialGrid(
    Nnodes = 10,
    Nlinks = Nnodes-1,
    L = Utilities.LineFeederLengths(Nlinks, 200, 16),
    FromTo = Utilities.LineFeederConnections(Nlinks),
    cables = Utilities.LineFeederCables(
             Nlinks,
             Buildings.Electrical.Transmission.LowVoltageCables.PvcAl120(),
             Buildings.Electrical.Transmission.LowVoltageCables.PvcAl35()));

  annotation (Documentation(info="<html>
</html>"));
end SingleFeeder_10nodes_Al35;
