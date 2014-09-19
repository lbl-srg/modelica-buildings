within Buildings.Electrical.Transmission.Benchmarks.BenchmarkGrids;
record GridInHome_AL70 "Simplified grid for benchmarking (AL70)"
  extends Buildings.Electrical.Transmission.Grids.PartialGrid(
    nNodes=21,
    nLinks=20,
    l = 16.0*ones(nLinks,1),
    fromTo=[[1,2];   [2,3];   [3,4];   [4,5];   [5,6];   [6,7];   [7,8];   [8,9];   [9,10];  [10,11];
            [11,12]; [12,13]; [13,14]; [14,15]; [15,16]; [16,17]; [17,18]; [18,19]; [19,20]; [20,21]],
    cables={LowVoltageCables.PvcAl70(),LowVoltageCables.PvcAl70(),
            LowVoltageCables.PvcAl70(),LowVoltageCables.PvcAl70(),
            LowVoltageCables.PvcAl70(),LowVoltageCables.PvcAl70(),
            LowVoltageCables.PvcAl70(),LowVoltageCables.PvcAl70(),
            LowVoltageCables.PvcAl70(),LowVoltageCables.PvcAl70(),
            LowVoltageCables.PvcAl70(),LowVoltageCables.PvcAl70(),
            LowVoltageCables.PvcAl70(),LowVoltageCables.PvcAl70(),
            LowVoltageCables.PvcAl70(),LowVoltageCables.PvcAl70(),
            LowVoltageCables.PvcAl70(),LowVoltageCables.PvcAl70(),
            LowVoltageCables.PvcAl70(),LowVoltageCables.PvcAl70()});
  annotation (Documentation(info="<html>
<p>Schematic of the grid.
   fixme: Explain what this grid is. It seems to be the same as IEEE 34, but the name suggest that it is a grid inside a home.</p>
<p><img alt=\"alt-image\" src=\"modelica://Buildings/Resources/Images/Electrical/Transmission/Grids/IEEE_34.png\"/></p>
</html>"));
end GridInHome_AL70;
