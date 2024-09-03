within Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.LoadAggregation;
function temporalSuperposition
  "Performs temporal superposition for the load aggregation procedure"
  extends Modelica.Icons.Function;

  input Integer i "Number of aggregation cells";
  input Modelica.Units.SI.HeatFlowRate QAgg_flow[i]
    "Vector of aggregated loads";
  input Modelica.Units.SI.ThermalResistance kappa[i]
    "Weighting factors for each aggregation cell";
  input Integer curCel "Current occupied aggregation cell";

  output Modelica.Units.SI.TemperatureDifference deltaTb "Delta T at wall";

algorithm
  deltaTb := QAgg_flow[1:curCel]*kappa[1:curCel];

  annotation (
Inline=true,
Documentation(info="<html>
<p>
Performs the temporal superposition operation to obtain the temperature change
at the borehole wall at the current time step, which is the scalar product of
the aggregated load vector and the <code>kappa</code> step response vector. To
avoid unnecessary calculations, the current aggregation cell in the simulation
is used to truncate the values from the vectors that are not required.
</p>
</html>", revisions="<html>
<ul>
<li>
March 5, 2018, by Alex Laferri&egrave;re:<br/>
First implementation.
</li>
</ul>
</html>"));
end temporalSuperposition;
