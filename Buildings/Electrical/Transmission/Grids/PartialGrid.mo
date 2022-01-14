within Buildings.Electrical.Transmission.Grids;
record PartialGrid "Partial model that represents a generalized grid"
  extends Modelica.Icons.MaterialProperty;
  parameter Integer nNodes "Number of nodes of the grid";
  parameter Integer nLinks "Number of links connecting the nodes";
  parameter Integer fromTo[nLinks,2]
    "Indexes [i,1]->[i,2] of the nodes connected by link i";
  parameter Modelica.Units.SI.Length l[nLinks,1](each min=0)
    "Length of the cable";
  replaceable Buildings.Electrical.Transmission.BaseClasses.BaseCable cables[nLinks]
    "Array that contains the characteristics of each cable";
  annotation (Documentation(info="<html>
<p>
This abstract grid model specifies the topology of the network by
</p>
<ul>
<li>the number of nodes,</li>
<li>the number of links,</li>
<li>the length of links, and</li>
<li>the connection between links and nodes.</li>
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
September 23, 2014, by Marco Bonvini:<br/>
Revised model structure. Now the type of the cable is replaceable
so it's possible to use either low voltage or medium voltage cable.
</li>
<li>
June 3, 2014, by Marco Bonvini:<br/>
Added User's guide.
</li>
</ul>
</html>"), Icon(graphics={
        Text(
          textColor={0,0,255},
          extent={{-154,104},{146,144}},
          textString="%name")}));
end PartialGrid;
