within Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors;
impure function clusterBoreholes
  "Identify clusters of boreholes with similar heat interactions"
  extends Modelica.Icons.Function;

  input Integer nBor "Number of boreholes";
  input Modelica.Units.SI.Position cooBor[nBor, 2] "Coordinates of boreholes";
  input Modelica.Units.SI.Height hBor "Borehole length";
  input Modelica.Units.SI.Height dBor "Borehole buried depth";
  input Modelica.Units.SI.Radius rBor "Borehole radius";
  input Integer nClu "Number of clusters to be generated";
  input Modelica.Units.SI.TemperatureDifference TTol = 0.001
    "Absolute tolerance on the borehole wall temperature for the identification of clusters";

  output Integer labels[nBor] "Cluster label associated with each data point";
  output Integer cluSiz[nClu] "Size of the clusters";
  output Integer N "Number of unique clusters";

protected
  Modelica.Units.SI.Temperature TBor[nBor,1] "Steady-state borehole wall temperatures";
  Modelica.Units.SI.Temperature TBor_Unique[nBor] "Unique borehole wall temperatures under tolerance";
  Modelica.Units.SI.Length dis "Distance between boreholes";

algorithm
  // ---- Evaluate borehole wall temperatures
  for i in 1:nBor loop
    TBor[i,1] := 0;
    for j in 1:nBor loop
      if i <> j then
        dis := sqrt((cooBor[i,1]-cooBor[j,1])^2 + (cooBor[i,2]-cooBor[j,2])^2);
      else
        dis := rBor;
      end if;
      TBor[i,1] := TBor[i,1] + Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.finiteLineSource_SteadyState(dis, hBor, dBor, hBor, dBor);
    end for;
  end for;

  // ---- Find all unique borehole wall temperatures under tolerance
  // The number of clusters is min(N, nClu)
  N := 1;
  TBor_Unique[1] := TBor[1,1];
  if nClu > 1 and nBor > 1 then
    for i in 2:nBor loop
      for j in 1:N loop
        if abs(TBor[i,1] - TBor_Unique[j]) < TTol then
          break;
        elseif j == N then
          TBor_Unique[N+1] := TBor[i,1];
          N := N + 1;
        end if;
      end for;
    end for;
  end if;
  N := min(N, nClu);

  // ---- Identify borehole clusters
  // This function is impure
  (,labels,cluSiz) := Buildings.Utilities.Clustering.KMeans(
    TBor,
    N,
    nBor,
    1,
    n_cluster_size=nClu);

annotation (
Inline=true,
Documentation(info="<html>
<p>
This function identifies groups of similarly behaving boreholes using a
<i>k</i>-means clustering algorithm. Boreholes are clustered based on their
steady-state dimensionless borehole wall temperatures obtained from the spatial
superposition of the steady-state finite line source solution (see
<a href=\"modelica://Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.finiteLineSource_SteadyState\">
Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.finiteLineSource_SteadyState</a>).
</p>
<h4>Implementation</h4>
<p>
The implemented method differs from the method presented by Prieto and Cimmino
(2021). They used a hierarchical agglomerative clustering method with complete
linkage to identify the borehole clusters. The <i>optimal</i> number of clusters
was identified by cutting the dendrogram generated during the clustering
process.
</p>
<p>
Here, a <i>k</i>-means algorithm is used instead, using the euclidian distance
between steady-state borehole wall temperatures. The number of clusters is a
parameter in this approach. However, as observed by Prieto and Cimmino (2021),
<code>nClu=5</code> clusters should provide acceptable accuracy in most
practical cases. This number can be increased without significant change in the
computational cost.
</p>
<h4>References</h4>
<p>
Prieto, C. and Cimmino, M. 2021. <i>Thermal interactions in large irregular
fields of geothermal boreholes: the method of equivalent boreholes</i>. Journal
of Building Performance Simulation 14(4): 446-460.
<a href=\"https://doi.org/10.1080/19401493.2021.1968953\">
doi:10.1080/19401493.2021.1968953</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
February 1, 2023, by Michael Wetter:<br/>
Added <code>impure</code> declaration which is needed for compliance with the Modelica Language Specification,
and is required by Optimica.
</li>
<li>
February 1, 2023, by Michael Wetter:<br/>
Added units.
</li>
<li>
June 9, 2022 by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end clusterBoreholes;
