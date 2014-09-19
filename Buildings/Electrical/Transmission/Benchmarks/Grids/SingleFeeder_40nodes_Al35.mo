within Buildings.Electrical.Transmission.Benchmarks.Grids;
record SingleFeeder_40nodes_Al35
  "Grid with single feder and 40 nodes for benchmark (39 nodes for the loads)"
  extends Buildings.Electrical.Transmission.Grids.PartialGrid(
    nNodes = 40,
    nLinks = nNodes-1,
    l = Utilities.lineFeederLengths(nLinks, 200, 16),
    fromTo = Utilities.lineFeederConnections(nLinks),
    cables = Utilities.lineFeederCables(
             nLinks,
             Buildings.Electrical.Transmission.LowVoltageCables.PvcAl120(),
             Buildings.Electrical.Transmission.LowVoltageCables.PvcAl35()));

  annotation (Documentation(info="<html>
<p>
Schematic of the feeder with 40 nodes.
</p>
<p>
The type of the first cable is AL120 while the others are AL35.
</p>
<p><img alt=\"alt-image\" src=\"modelica://Buildings/Resources/Images/Electrical/Transmission/Grids/Feeder40.png\"/></p>
</html>",
        revisions="<html>
<ul>
<li>
Sept 19 2014 by Marco Bonvini:</br>
Added documentation
</li>
</ul>
</html>"));
end SingleFeeder_40nodes_Al35;
