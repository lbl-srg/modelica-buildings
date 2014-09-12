within Buildings.Electrical.Transmission.Benchmarks.BenchmarkGrids;
record SingleFeeder_30nodes_Al120
  "Grid with single feder and 30 nodes for benchmark (29 nodes for the loads)"
  extends Buildings.Electrical.Transmission.Grids.PartialGrid(
    nNodes = 30,
    Nlinks = nNodes-1,
    L = Utilities.LineFeederLengths(Nlinks, 200, 16),
    FromTo = Utilities.LineFeederConnections(Nlinks),
    cables = Utilities.LineFeederCables(
             Nlinks,
             Buildings.Electrical.Transmission.LowVoltageCables.PvcAl120(),
             Buildings.Electrical.Transmission.LowVoltageCables.PvcAl120()));

  annotation (Documentation(info="<html>
</html>"));
end SingleFeeder_30nodes_Al120;
