within Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.Validation;
model ClusterBoreholes_100boreholes
  "Clustering of a field of 100 boreholes"
  extends Modelica.Icons.Example;

  parameter Integer nBor = 100 "Number of boreholes";
  parameter Modelica.Units.SI.Position cooBor[nBor, 2] = {{7.5*mod(i-1,10), 7.5*floor((i-1)/10)} for i in 1:nBor}
    "Coordinates of boreholes";
  parameter Modelica.Units.SI.Height hBor=150 "Borehole length";
  parameter Modelica.Units.SI.Height dBor=4 "Borehole buried depth";
  parameter Modelica.Units.SI.Radius rBor=0.075 "Borehole radius";
  parameter Integer k=4 "Number of clusters to be generated";

  parameter Integer labels[nBor](each fixed=false) "Cluster label associated with each data point";
  parameter Integer cluSiz[k](each fixed=false) "Size of the clusters";

  parameter Integer labelsExp[nBor]=
    {3, 3, 3, 4, 4, 4, 4, 3, 3, 3, 3, 4, 4, 2, 2, 2, 2, 4, 4, 3, 3, 4, 2, 2, 1,
     1, 2, 2, 4, 3, 4, 2, 2, 1, 1, 1, 1, 2, 2, 4, 4, 2, 1, 1, 1, 1, 1, 1, 2, 4,
     4, 2, 1, 1, 1, 1, 1, 1, 2, 4, 4, 2, 2, 1, 1, 1, 1, 2, 2, 4, 3, 4, 2, 2, 1,
     1, 2, 2, 4, 3, 3, 4, 4, 2, 2, 2, 2, 4, 4, 3, 3, 3, 3, 4, 4, 4, 4, 3, 3, 3}
    "Expected cluster labels";

  // Comparison result
  Boolean cmp "Comparison result";

initial equation
  (labels, cluSiz) = Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.clusterBoreholes(nBor,cooBor,hBor,dBor,rBor,k);

equation
  cmp = Modelica.Math.Vectors.isEqual(labels, labelsExp);

annotation (experiment(Tolerance=1e-6, StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Geothermal/Borefields/BaseClasses/HeatTransfer/ThermalResponseFactors/Validation/ClusterBoreholes_100boreholes.mos"
        "Simulate and plot"),
      Documentation(info="<html>
<p>
This example uses a rectangular field of 10 by 10 boreholes to test the
identification borehole clusters.
</p>
</html>",
revisions="<html>
<ul>
<li>
June 9, 2022 by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end ClusterBoreholes_100boreholes;
