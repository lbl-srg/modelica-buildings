within Districts.Electrical.Transmission;
package Grids
  extends Modelica.Icons.MaterialPropertiesPackage;
  record PartialGrid "Partial model representing a grid"
    extends Modelica.Icons.MaterialProperty;
    parameter Integer Nnodes "Number of nodes of the grid";
    parameter Integer Nlinks "Number of links connecting the nodes";
    parameter Integer FromTo[Nlinks,2]
      "Indexes [i,1]->[i,2] of the nodes connected by link i";
    parameter Modelica.SIunits.Length L[Nlinks] "Length of the cable";
    Districts.Electrical.Transmission.CommercialCables.Cable cables[Nlinks]
      "Array that contains the characteristics of each cable";
  end PartialGrid;

  record TestGrid2Nodes "Simple model of a 2-nodes 1-link grid"
    extends Districts.Electrical.Transmission.Grids.PartialGrid(
    Nnodes = 2,
    Nlinks = 1,
    FromTo = [[1,2]],
    L = {200},
    cables = {CommercialCables.Cu35()});
  end TestGrid2Nodes;

  record IEEE_34_AL120
    "IEEE 34 Bus Grid District 1 (AL120,AL70,Al35) - freestanding"
    extends Districts.Electrical.Transmission.Grids.PartialGrid(
    Nnodes = 34,
    Nlinks = 33,
    L = {48,16,16,40,32,16,16,16,16,16,16,32,32,16,32,32,32,48,48,32,32,16,16,16,16,16,32,32,16,32,16,16,16},
    FromTo = [
    [1,2];
    [2,3];
    [3,4];
    [4,5];
    [4,6];
    [6,7];
    [7,8];
    [9,26];
    [10,26];
    [11,9];
    [12,11];
    [13,10];
    [14,10];
    [15,14];
    [16,15];
    [17,27];
    [18,27];
    [19,31];
    [20,31];
    [21,32];
    [22,32];
    [23,20];
    [24,23];
    [25,24];
    [26,8];
    [27,29];
    [28,16];
    [29,16];
    [30,17];
    [31,17];
    [32,19];
    [33,22];
    [34,18]],
    cables= {CommercialCables.PvcAl120(),
            CommercialCables.PvcAl120(),
            CommercialCables.PvcAl120(),
            CommercialCables.PvcAl120(),
            CommercialCables.PvcAl120(),
            CommercialCables.PvcAl120(),
            CommercialCables.PvcAl120(),
            CommercialCables.PvcAl120(),
            CommercialCables.PvcAl120(),
            CommercialCables.PvcAl120(),
            CommercialCables.PvcAl120(),
            CommercialCables.PvcAl120(),
            CommercialCables.PvcAl120(),
            CommercialCables.PvcAl120(),
            CommercialCables.PvcAl120(),
            CommercialCables.PvcAl70(),
            CommercialCables.PvcAl70(),
            CommercialCables.PvcAl35(),
            CommercialCables.PvcAl35(),
            CommercialCables.PvcAl35(),
            CommercialCables.PvcAl35(),
            CommercialCables.PvcAl35(),
            CommercialCables.PvcAl35(),
            CommercialCables.PvcAl35(),
            CommercialCables.PvcAl120(),
            CommercialCables.PvcAl70(),
            CommercialCables.PvcAl70(),
            CommercialCables.PvcAl70(),
            CommercialCables.PvcAl70(),
            CommercialCables.PvcAl70(),
            CommercialCables.PvcAl35(),
            CommercialCables.PvcAl35(),
            CommercialCables.PvcAl70()});

     /*
   LEFT HERE TO CHECK CONSISTENCY
   
   LenVec={
   0,48,16,16,40,
   32,16,16,16,16,
   16,16,32,32,16,
   32,32,32,48,48,
   32,32,16,16,16,
   16,16,32,32,16,
   32,16,16,16},
   
    CabTyp={
               ,.PvcAl120(),.PvcAl120(),.PvcAl120(),.PvcAl120(),
    .PvcAl120(),.PvcAl120(),.PvcAl120(),.PvcAl120(),.PvcAl120(),
    .PvcAl120(),.PvcAl120(),.PvcAl120(),.PvcAl120(),.PvcAl120(),
    .PvcAl120(),.PvcAl70(),.PvcAl70(),.PvcAl35(),.PvcAl35(),
    .PvcAl35(),.PvcAl35(),.PvcAl35(),.PvcAl35(),.PvcAl35(),
    .PvcAl120(),.PvcAl70(),.PvcAl70(),.PvcAl70(),.PvcAl70(),
    .PvcAl70(),.PvcAl35(),.PvcAl35(),.PvcAl70()});
   */
    annotation (Documentation(info="<html>
<p>Schematic of the IEEE-34 grid</p>
<p><img src=\"modelica://Districts/Resources/Images/Electrical/Transmission/Grids/IEEE_34.png\"/></p>
</html>"));
  end IEEE_34_AL120;
end Grids;
