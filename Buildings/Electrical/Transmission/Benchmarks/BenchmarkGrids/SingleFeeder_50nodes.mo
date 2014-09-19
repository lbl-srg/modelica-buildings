within Buildings.Electrical.Transmission.Benchmarks.BenchmarkGrids;
record SingleFeeder_50nodes
  "Grid with single feder and 50 nodes for benchmark (49 nodes for the loads)"
  extends Buildings.Electrical.Transmission.Grids.PartialGrid(
    nNodes = 50,
    nLinks = nNodes-1,
    L = Utilities.LineFeederLengths(nLinks, 200, 16),
    fromTo = Utilities.LineFeederConnections(nLinks),
    cables = Utilities.LineFeederCables(
             nLinks,
             Buildings.Electrical.Transmission.LowVoltageCables.PvcAl120(),
             Buildings.Electrical.Transmission.LowVoltageCables.PvcAl70()));

  annotation (Documentation(info="<html>
</html>"));
end SingleFeeder_50nodes;
