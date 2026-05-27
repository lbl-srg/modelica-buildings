within Buildings.DHC.Examples.Combined;
package ETSHeatRecoveryHeatPump_BuildingTimeSeries "Package of example models of energy transfer stations for combined heating and cooling connected to building time series loads"
  extends Modelica.Icons.ExamplesPackage;
annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains examples illustrating the use of the models in
<a href=\"modelica://Buildings.DHC.ETS.Combined\">
Buildings.DHC.ETS.Combined</a>,
connected to building loads that are modeled as time series.
</p>
<p>
Note that the models do not contain a district loop. Rather, the service line is
connected to a constant pressure boundary, and the example models contain
an energy transfer station connected to a building load.
</p>
</html>"));
end ETSHeatRecoveryHeatPump_BuildingTimeSeries;
