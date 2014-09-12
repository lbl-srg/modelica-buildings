within Buildings.Electrical.Transmission.Benchmarks.BenchmarkGrids;
record SingleFeeder_20nodes_Al35
  "Grid with single feder and 20 nodes for benchmark (19 nodes for the loads)"
  extends Buildings.Electrical.Transmission.Grids.PartialGrid(
    nNodes = 20,
    Nlinks = nNodes-1,
    L = Utilities.LineFeederLengths(Nlinks, 200, 16),
    FromTo = Utilities.LineFeederConnections(Nlinks),
    cables = Utilities.LineFeederCables(
             Nlinks,
             Buildings.Electrical.Transmission.LowVoltageCables.PvcAl120(),
             Buildings.Electrical.Transmission.LowVoltageCables.PvcAl35()));

  annotation (Documentation(info="<html>
</html>"));
end SingleFeeder_20nodes_Al35;
