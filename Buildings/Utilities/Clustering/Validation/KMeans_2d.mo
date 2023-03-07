within Buildings.Utilities.Clustering.Validation;
model KMeans_2d "Model that verifies the k-means clustering function for 2d data"
  extends Modelica.Icons.Example;

  parameter Integer n_clusters = 3 "Number of clusters to be generated";
  parameter Real data[:,:]=
    [ 1, 1;
      1, 2;
      2, 1;
      2, 1.2;
      3, 0;
      4, 0]
     "Test data to be clustered";

  parameter Integer nDat = size(data,1) "Number of samples";
  parameter Integer nDim = size(data,2) "Number of features";
  parameter Real[n_clusters,nDim] centroids(each fixed=false)
    "Centroids of the clusters";
  parameter Integer[nDat] labels(each fixed=false)
    "Cluster label associated with each data point";
  parameter Integer[n_clusters] cluster_size(each fixed=false)
    "Size of the clusters";

  parameter Integer labelsExp[nDat]=
    {2,2,1,2,1,3}
    "Expected cluster labels";

  // Comparison result
  Boolean cmp "Comparison result";

initial equation
  (centroids, labels, cluster_size) = Buildings.Utilities.Clustering.KMeans(
    data, n_clusters, nDat, nDim);

equation
  cmp = Modelica.Math.Vectors.isEqual(labels, labelsExp);

annotation (experiment(Tolerance=1e-6, StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Utilities/Clustering/Validation/KMeans_2d.mos"
        "Simulate and plot"),
      Documentation(info="<html>
<p>
This example tests the k-means clustering algorithm on 2d data.
</p>
</html>",
revisions="<html>
<ul>
<li>
June 9, 2022 by Massimo Cimmino<br/>
First implementation.
</li>
</ul>
</html>"));
end KMeans_2d;
