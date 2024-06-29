within Buildings.Fluid.Geothermal.ZonedBorefields.BaseClasses.HeatTransfer;
function temporalSuperposition
  "Performs temporal superposition for the load aggregation procedure"
  extends Modelica.Icons.Function;

  input Integer i "Number of aggregation cells";
  input Integer nSeg "Number of segments";
  input Modelica.Units.SI.HeatFlowRate QAgg_flow[nSeg,i]
    "Array of aggregated loads";
  input Modelica.Units.SI.ThermalResistance kappa[nSeg,nSeg,i]
    "Weighting factors for each aggregation cell";
  input Integer curCel "Current occupied aggregation cell";

  output Modelica.Units.SI.TemperatureDifference deltaTb[nSeg] "Delta T at wall";

algorithm
  deltaTb := kappa[:,:,1] * QAgg_flow[:,1];
  for k in 2:curCel loop
    deltaTb := deltaTb + kappa[:,:,k] * QAgg_flow[:,k];
  end for;

  annotation (
Inline=true,
Documentation(info="<html>
<p>
Performs the temporal and spatial superposition operations to obtain the
temperature change at the wall of a borehole segment at the current time step.
The spatial superposition of one load aggregation cell is the matrix-vector
product of the <code>kappa[:,:,k]</code> step response matrix (at a cell k) and
the vector of aggregated loads of all borehole segments in cell k,
QAgg_flow[:,k]. The temporal superposition is the sum of the contributions of
all load aggregation cells. To avoid unnecessary calculations, the current
aggregation cell in the simulation is used to truncate the values from the
vectors that are not required.
</p>
<p>
This is a vectorized implementation of
<a href=\"modelica://Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.temporalSuperposition\">
Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.temporalSuperposition</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
February 2024, by Massimo Cimmino<br/>
First implementation.
</li>
</ul>
</html>"));
end temporalSuperposition;
