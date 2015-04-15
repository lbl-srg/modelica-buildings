within Buildings.Electrical.Transmission.Grids;
record IEEE_34_AL120 "Grid model inspired to the IEEE 34 Node test feeder"
  extends Buildings.Electrical.Transmission.Grids.PartialGrid(
    nNodes=34,
    nLinks=33,
    l=[48;16;16;40;32;16;16;16;16;16;16;32;32;16;32;32;32;48;48;32;32;16;16;16;
        16;16;32;32;16;32;16;16;16],
    fromTo=[[1,2]; [2,3]; [3,4]; [4,5]; [4,6]; [6,7]; [7,8]; [9,26]; [10,26]; [
        11,9]; [12,11]; [13,10]; [14,10]; [15,14]; [16,15]; [17,27]; [18,27]; [
        19,31]; [20,31]; [21,32]; [22,32]; [23,20]; [24,23]; [25,24]; [26,8]; [
        27,29]; [28,16]; [29,16]; [30,17]; [31,17]; [32,19]; [33,22]; [34,18]],
    redeclare Buildings.Electrical.Transmission.LowVoltageCables.Generic cables=
       {LowVoltageCables.PvcAl120(),LowVoltageCables.PvcAl120(),
        LowVoltageCables.PvcAl120(),LowVoltageCables.PvcAl120(),
        LowVoltageCables.PvcAl120(),LowVoltageCables.PvcAl120(),
        LowVoltageCables.PvcAl120(),LowVoltageCables.PvcAl120(),
        LowVoltageCables.PvcAl120(),LowVoltageCables.PvcAl120(),
        LowVoltageCables.PvcAl120(),LowVoltageCables.PvcAl120(),
        LowVoltageCables.PvcAl120(),LowVoltageCables.PvcAl120(),
        LowVoltageCables.PvcAl120(),LowVoltageCables.PvcAl70(),
        LowVoltageCables.PvcAl70(),LowVoltageCables.PvcAl35(),
        LowVoltageCables.PvcAl35(),LowVoltageCables.PvcAl35(),
        LowVoltageCables.PvcAl35(),LowVoltageCables.PvcAl35(),
        LowVoltageCables.PvcAl35(),LowVoltageCables.PvcAl35(),
        LowVoltageCables.PvcAl120(),LowVoltageCables.PvcAl70(),
        LowVoltageCables.PvcAl70(),LowVoltageCables.PvcAl70(),
        LowVoltageCables.PvcAl70(),LowVoltageCables.PvcAl70(),
        LowVoltageCables.PvcAl35(),LowVoltageCables.PvcAl35(),
        LowVoltageCables.PvcAl70()});

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
<p> This model represents a grid inspired by the IEEE 34 node test feeder.
In this example, the cable types and lengths have been modified in order to
represent a typical distribution feeder.</p>
<p>The following three type of cables are in the grid: AL120, AL70, and Al35.
</p>
<p><img alt=\"alt-image\" src=\"modelica://Buildings/Resources/Images/Electrical/Transmission/Grids/IEEE_34.png\"/></p>
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
end IEEE_34_AL120;
