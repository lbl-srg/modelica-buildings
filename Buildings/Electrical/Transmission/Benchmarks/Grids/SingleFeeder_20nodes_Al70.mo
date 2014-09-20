within Buildings.Electrical.Transmission.Benchmarks.Grids;
record SingleFeeder_20nodes_Al70
  "Grid with single feder and 20 nodes for benchmark (19 nodes for the loads)"
  extends Buildings.Electrical.Transmission.Grids.PartialGrid(
    nNodes = 20,
    nLinks = nNodes-1,
    l = Utilities.lineFeederLengths(nLinks, 200, 16),
    fromTo = Utilities.lineFeederConnections(nLinks),
    cables = Utilities.lineFeederCables(
             nLinks,
             Buildings.Electrical.Transmission.LowVoltageCables.PvcAl120(),
             Buildings.Electrical.Transmission.LowVoltageCables.PvcAl70()));

  annotation (Documentation(info="<html>
<p>
Schematic of the feeder with 20 nodes.
</p>
<p>
The type of the first cable is AL120 while the others are AL70.
</p>
<p><img alt=\"alt-image\" src=\"modelica://Buildings/Resources/Images/Electrical/Transmission/Grids/Feeder20.png\"/></p>
</html>",
        revisions="<html>
<ul>
<li>
Sept 19 2014 by Marco Bonvini:
Added documentation
</li>
</ul>
</html>"));
end SingleFeeder_20nodes_Al70;
