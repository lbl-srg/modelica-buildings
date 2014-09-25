within Buildings.Electrical.Transmission.Benchmarks.Grids;
record SingleFeeder_50nodes_Al120
  "Grid with single feder and 50 nodes for benchmark (49 nodes for the loads)"
  extends Buildings.Electrical.Transmission.Grids.PartialGrid(
    nNodes = 50,
    nLinks = nNodes-1,
    l = Utilities.lineFeederLengths(nLinks, 200, 16),
    fromTo = Utilities.lineFeederConnections(nLinks),
    redeclare Buildings.Electrical.Transmission.LowVoltageCables.Generic cables=
             Buildings.Electrical.Transmission.Benchmarks.Utilities.lineFeederCablesLow(
             nLinks,
             Buildings.Electrical.Transmission.LowVoltageCables.PvcAl120(),
             Buildings.Electrical.Transmission.LowVoltageCables.PvcAl120()));

  annotation (Documentation(info="<html>
<p>
Schematic of the feeder with 50 nodes.
</p>
<p>
The type of the cables is AL120.
</p>
<p><img alt=\"alt-image\" src=\"modelica://Buildings/Resources/Images/Electrical/Transmission/Grids/Feeder50.png\"/></p>
</html>",
        revisions="<html>
<ul>
<li>
September 23, 2014, by Marco Bonvini:<br/>
Added redeclare statement needed to specify the type of cables used in the array.
</li>
<li>
Sept 19 2014 by Marco Bonvini:<br/>
Added documentation
</li>
</ul>
</html>"));
end SingleFeeder_50nodes_Al120;
