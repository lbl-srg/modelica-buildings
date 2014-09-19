within Buildings.Electrical.Transmission.Benchmarks.Grids;
record SingleFeeder_50nodes_Al120
  "Grid with single feder and 50 nodes for benchmark (49 nodes for the loads)"
  extends Buildings.Electrical.Transmission.Grids.PartialGrid(
    nNodes = 50,
    nLinks = nNodes-1,
    l = Utilities.LineFeederLengths(nLinks, 200, 16),
    fromTo = Utilities.LineFeederConnections(nLinks),
    cables = Utilities.LineFeederCables(
             nLinks,
             Buildings.Electrical.Transmission.LowVoltageCables.PvcAl120(),
             Buildings.Electrical.Transmission.LowVoltageCables.PvcAl120()));

  annotation (Documentation(info="<html>
</html>", revisions="<html>
<ul>
<li>
Sept 19 2014 by Marco Bonvini:</br>
Added documentation
</li>
</ul>
</html>"));
end SingleFeeder_50nodes_Al120;
