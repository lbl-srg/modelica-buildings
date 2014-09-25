within Buildings.Electrical.Transmission.Benchmarks.Grids;
record SingleFeeder_10nodes_Al70
  "Grid with single feder and 10 nodes for benchmark (9 nodes for the loads)"
  extends Buildings.Electrical.Transmission.Grids.PartialGrid(
    nNodes = 10,
    nLinks = nNodes-1,
    l = Utilities.lineFeederLengths(nLinks, 200, 16),
    fromTo = Utilities.lineFeederConnections(nLinks),
    redeclare Buildings.Electrical.Transmission.LowVoltageCables.Generic cables=
             Buildings.Electrical.Transmission.Benchmarks.Utilities.lineFeederCablesLow(
             nLinks,
             Buildings.Electrical.Transmission.LowVoltageCables.PvcAl120(),
             Buildings.Electrical.Transmission.LowVoltageCables.PvcAl70()));
  annotation (Documentation(info="<html>
<p>
Schematic of the feeder with 10 nodes.
</p>
<p>
The type of the first cable is AL120 while the others are AL70.
</p>
<p><img alt=\"alt-image\" src=\"modelica://Buildings/Resources/Images/Electrical/Transmission/Grids/Feeder10.png\"/></p>
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
end SingleFeeder_10nodes_Al70;
