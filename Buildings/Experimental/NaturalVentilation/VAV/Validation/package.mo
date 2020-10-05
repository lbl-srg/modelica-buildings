within Buildings.Experimental.NaturalVentilation.VAV;
package Validation "Validation models for VAV & nat vent interlock logics"

annotation (preferredView="info", Documentation(info="<html>

This package contains validation models for the two VAV control blocks, which determine adjusted VAV airflow (<a href=\"modelica://Buildings.Experimental.NaturalVentilation.VAV.SetpointAirflowReset\">
Buildings.Experimental.NaturalVentilation.VAV.SetpointAirflowReset</a>)
<li> and temperature setpoints (<a href=\"modelica://Buildings.Experimental.NaturalVentilation.VAV.SetpointTemperatureReset\">
Buildings.Experimental.NaturalVentilation.VAV.SetpointTemperatureReset</a>) when the building is in natural ventilation mode.
<li> When the building is not in natural ventilation mode, temperature and airflow setpoints are passed through the blocks unchanged. 
</html>"));
end Validation;
