within Buildings.Electrical.Transmission.Benchmarks.Grids;
record SingleFeeder_40nodes_Al35
  "Grid with single feder and 40 nodes for benchmark (39 nodes for the loads)"
  extends Buildings.Electrical.Transmission.Grids.PartialGrid(
    nNodes = 40,
    nLinks = nNodes-1,
    l = Utilities.LineFeederLengths(nLinks, 200, 16),
    fromTo = Utilities.LineFeederConnections(nLinks),
    cables = Utilities.LineFeederCables(
             nLinks,
             Buildings.Electrical.Transmission.LowVoltageCables.PvcAl120(),
             Buildings.Electrical.Transmission.LowVoltageCables.PvcAl35()));

  annotation (Documentation(info="<html>
</html>"));
end SingleFeeder_40nodes_Al35;
