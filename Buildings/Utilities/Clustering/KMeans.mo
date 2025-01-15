within Buildings.Utilities.Clustering;
impure function KMeans "k-means clustering algorithm"
  extends Modelica.Icons.Function;
  input Real data[n_samples,n_features] "Data to be clustered";
  input Integer n_clusters "Number of clusters to be generated";
  input Integer n_samples "Number of samples";
  input Integer n_features "Number of features";
  input Real relTol=1e-5 "Relative tolerance on cluster positions";
  input Integer max_iter=500 "Maximum number of k-means iterations";
  input Integer n_init=10 "Number of runs with randomized centroid seeds";
  input Integer n_cluster_size=0 "Length of the cluster_size output vector";
  output Real centroids[n_clusters,n_features] "Centroids of the clusters";
  output Integer labels[n_samples] "Cluster label associated with each data point";
  output Integer cluster_size[max(n_clusters, n_cluster_size)] "Size of the clusters";

protected
  Real old_centroids[n_clusters,n_features] "Previous iteration centroids";
  Real new_centroids[n_clusters,n_features] "Next iteration centroids";
  Real delta_centroids "Maximum relative displacement of cluster centroids between two k-means iterations";
  Integer new_labels[n_samples] "Next iteration cluster labels";
  Real new_inertia "Inertia of the samples during the current run";
  Real inertia "Minimum inertia of the samples since first run";
  Integer id "Id of the random integer generator";
  Integer k_iter "Index of k-means iteration";
  Real min_dis "Minimum distance between a sample (or a centroid) and a cluster centroid";
  Real dis "Distance between a sample (or a centroid) and a cluster centroid";
  Integer n "Random integer";
  constant Integer seed = 2 "Arbitrary seed value";

algorithm
 id := Modelica.Math.Random.Utilities.initializeImpureRandom(seed);

  // ---- Perform n_init successive runs of the k-means algorithm
 for run in 1:n_init loop
    // ---- Select initial centroids at random
    // Select 3 non-repeated data points in the data set
    n := Modelica.Math.Random.Utilities.impureRandomInteger(id,1,n_samples);
    old_centroids[1,:] := data[n,:];
    for i in 2:n_clusters loop
      n := Modelica.Math.Random.Utilities.impureRandomInteger(id,1,n_samples);
      old_centroids[i,:] := data[n,:];
      min_dis := Modelica.Math.Vectors.norm(old_centroids[i,:]-old_centroids[1,:], p=2)^2;
      while min_dis < Modelica.Constants.eps loop
        n := Modelica.Math.Random.Utilities.impureRandomInteger(id,1,n_samples);
        old_centroids[i,:] := data[n,:];
        min_dis := Modelica.Math.Vectors.norm(old_centroids[i,:]-old_centroids[1,:], p=2)^2;
        for j in 1:i-1 loop
          dis := Modelica.Math.Vectors.norm(old_centroids[j,:]-old_centroids[i,:], p=2)^2;
          min_dis := min(dis, min_dis);
        end for;
      end while;
    end for;

    // ---- k-means iterations
    k_iter := 0;
    delta_centroids := 2*relTol;
    while k_iter < max_iter and delta_centroids > relTol loop
      k_iter := k_iter + 1;

      // Find centroid closest to each data point
      for i in 1:n_samples loop
        new_labels[i] := 1;
        min_dis := Modelica.Math.Vectors.norm(data[i,:]-old_centroids[1,:], p=2)^2;
        for j in 1:n_clusters loop
          dis := Modelica.Math.Vectors.norm(data[i,:]-old_centroids[j,:], p=2)^2;
          if dis < min_dis then
            min_dis := min(dis, min_dis);
            new_labels[i] := j;
          end if;
        end for;
      end for;

      // Re-evaluate position of the centroids
      delta_centroids := 0;
      for j in 1:n_clusters loop
        n := sum(if new_labels[i]==j then 1 else 0 for i in 1:n_samples);
        new_centroids[j,:] := zeros(n_features);
        if n>0 then
          for i in 1:n_samples loop
             if new_labels[i]==j then
               new_centroids[j,:] := new_centroids[j,:] + data[i,:]/n;
             end if;
          end for;
        else
          new_centroids[j,:] := old_centroids[j,:];
        end if;
        delta_centroids := max(delta_centroids, sum((new_centroids[j,:] - old_centroids[j,:])./old_centroids[j,:]));
      end for;
      old_centroids := new_centroids;
    end while;

    // Evaluate inertia
    new_inertia := 0;
    for i in 1:n_samples loop
      dis := Modelica.Math.Vectors.norm(data[i,:]-centroids[new_labels[i],:], p=2)^2;
      new_inertia := inertia + dis;
    end for;

    // Keep run results if inertia is minimum
    if new_inertia < inertia or run == 1 then
      centroids := new_centroids;
      inertia := new_inertia;
      labels := new_labels;
    end if;

   end for;

   // Evaluate cluster sizes
   for j in 1:max(n_clusters, n_cluster_size) loop
     cluster_size[j] := sum(if labels[i]==j then 1 else 0 for i in 1:n_samples);
   end for;

annotation (
    Documentation(info="<html>
<p>
This function applies <i>k</i>-means clustering to <i>n</i>-dimentional data and
returns the centroid of the clusters, the cluster labels for each sample, and
the size of each cluster.
</p>
<p>
The returned length of the <code>cluster_size</code> vector is
<code>max(n_clusters, n_cluster_size)</code>.
</p>
<h4>Implementation</h4>
<p>
The seed for random number generation is constant. It can be changed by
modifying the constant <code>seed</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
February 1, 2023, by Michael Wetter:<br/>
Added <code>impure</code> declaration which is needed for compliance with the Modelica Language Specification,
and is required by Optimica.
</li>
<li>
June 9, 2022 by Massimo Cimmino:<br/>
First Implementation
</li>
</ul>
</html>"));
end KMeans;
