within Buildings.Electrical.Transmission.Grids;
record TestGrid2Nodes "Simple model of a grid with 2 nodes and 1 link"
  extends Buildings.Electrical.Transmission.Grids.PartialGrid(
    nNodes=2,
    nLinks=1,
    fromTo=[[1,2]],
    l=[200],
    redeclare Buildings.Electrical.Transmission.LowVoltageCables.Generic
    cables = {LowVoltageCables.Cu35()});
  annotation (Documentation(info="<html>
<p>
This model represents a simple grid with two nodes and a single link between them.
</p>
<p>
The picture below describes the grid topology.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Electrical/Transmission/Grids/testGrid2Nodes.png\"/>
</p>
</html>", revisions="<html>
<ul>
<li>
September 23, 2014, by Marco Bonvini:<br/>
Added redeclare statement needed to specify the type of cables used in the array.
</li>
<li>
June 3, 2014, by Marco Bonvini:<br/>
Added User's guide.
</li>
</ul>
</html>"));
end TestGrid2Nodes;
