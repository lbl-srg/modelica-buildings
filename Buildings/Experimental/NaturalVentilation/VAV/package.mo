within Buildings.Experimental.NaturalVentilation;
package VAV "VAV interlock controls"



annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains the two VAV control blocks, which determine adjusted VAV airflow and temperature setpoints when the building is in natural ventilation mode.
<li> When the building is not in natural ventilation mode, temperature and airflow setpoints are passed through the blocks unchanged. 
The VAV control blocks are as follows:
<li> 1. VAV Airflow Setpoint Reset (<a href=\"modelica://Buildings.Experimental.NaturalVentilation.VAV.SetpointAirflowReset\">
Buildings.Experimental.NaturalVentilation.VAV.SetpointAirflowReset</a>)
<li> 2. VAV Temperature Setpoint Reset (<a href=\"modelica://Buildings.Experimental.NaturalVentilation.VAV.SetpointTemperatureReset\">
Buildings.Experimental.NaturalVentilation.VAV.SetpointTemperatureReset</a>)
</html>"));
end VAV;
