within Buildings.Electrical.Transmission.Grids;
record IEEE_34_AL120
  "IEEE 34 Bus Grid District 1 (AL120,AL70,Al35) - freestanding"
  extends Buildings.Electrical.Transmission.Grids.PartialGrid(
    Nnodes=34,
    Nlinks=33,
    L={48,16,16,40,32,16,16,16,16,16,16,32,32,16,32,32,32,48,48,32,32,16,16,16,
        16,16,32,32,16,32,16,16,16},
    FromTo=[[1,2]; [2,3]; [3,4]; [4,5]; [4,6]; [6,7]; [7,8]; [9,26]; [10,26]; [
        11,9]; [12,11]; [13,10]; [14,10]; [15,14]; [16,15]; [17,27]; [18,27]; [
        19,31]; [20,31]; [21,32]; [22,32]; [23,20]; [24,23]; [25,24]; [26,8]; [
        27,29]; [28,16]; [29,16]; [30,17]; [31,17]; [32,19]; [33,22]; [34,18]],
    cables={LowVoltageCables.PvcAl120(),LowVoltageCables.PvcAl120(),
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
<p>Schematic of the IEEE-34 grid</p>
<p><img src=\"modelica://Districts/Resources/Images/Electrical/Transmission/Grids/IEEE_34.png\"/></p>
</html>"));
end IEEE_34_AL120;
