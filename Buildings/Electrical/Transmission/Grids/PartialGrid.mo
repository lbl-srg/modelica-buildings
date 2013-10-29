within Buildings.Electrical.Transmission.Grids;
record PartialGrid "Partial model representing a grid"
  extends Modelica.Icons.MaterialProperty;
  parameter Integer Nnodes "Number of nodes of the grid";
  parameter Integer Nlinks "Number of links connecting the nodes";
  parameter Integer FromTo[Nlinks,2]
    "Indexes [i,1]->[i,2] of the nodes connected by link i";
  parameter Modelica.SIunits.Length L[Nlinks] "Length of the cable";
  Buildings.Electrical.Transmission.Base.BaseCable cables[Nlinks]
    "Array that contains the characteristics of each cable";
end PartialGrid;
