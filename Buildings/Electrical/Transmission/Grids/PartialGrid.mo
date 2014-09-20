within Buildings.Electrical.Transmission.Grids;
record PartialGrid "Partial model that represents a generalized grid"
  extends Modelica.Icons.MaterialProperty;
  parameter Integer nNodes "Number of nodes of the grid";
  parameter Integer nLinks "Number of links connecting the nodes";
  parameter Integer fromTo[nLinks,2]
    "Indexes [i,1]->[i,2] of the nodes connected by link i";
  parameter Modelica.SIunits.Length l[nLinks,1](each min=0)
    "Length of the cable";
  Buildings.Electrical.Transmission.BaseClasses.BaseCable cables[nLinks]
    "Array that contains the characteristics of each cable";
  annotation (Documentation(info="<html>
<p>
This abstract grid model specifies the topology of the network by:
</p>
<ul>
<li>number of nodes,</li>
<li>number of links,</li>
<li>length of links,</li>
<li>relationships between links and nodes.</li>
</ul>
<p>
The picture below describes the meaning of the
values contained in the matrices.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Electrical/Transmission/Grids/partialGrid.png\"/>
</p>
</html>", revisions="<html>
<ul>
<li>
June 3, 2014, by Marco Bonvini:
Added User's guide.
</li>
</ul>
</html>"));
end PartialGrid;
