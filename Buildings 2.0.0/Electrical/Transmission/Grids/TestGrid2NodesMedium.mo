within Buildings.Electrical.Transmission.Grids;
record TestGrid2NodesMedium
  "Simple model of a grid with 2 nodes and 1 link for medium voltage"
  extends Buildings.Electrical.Transmission.Grids.PartialGrid(
    nNodes=2,
    nLinks=1,
    fromTo=[[1,2]],
    l=[200],
    redeclare Buildings.Electrical.Transmission.MediumVoltageCables.Generic
    cables = {MediumVoltageCables.Annealed_Al_30()});
  annotation (Documentation(info="<html>
<p>
This model represents a simple grid with two nodes and a single link between them.
This model differs from
<a href=\"modelica://Buildings.Electrical.Transmission.Grids.TestGrid2Nodes\">
Buildings.Electrical.Transmission.Grids.TestGrid2Nodes</a> because it defines a medium voltage
cable instead of a low voltage cable.
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
end TestGrid2NodesMedium;
