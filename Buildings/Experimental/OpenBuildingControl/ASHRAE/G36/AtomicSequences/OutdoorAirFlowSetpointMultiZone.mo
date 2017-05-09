within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.AtomicSequences;
model OutdoorAirFlowSetpointMultiZone
  "Find out the minimum outdoor airflow rate setpoint"

  parameter Integer numOfZon = 5 "Total number of zones that the system serves";
  parameter Real outAirPerAre[numOfZon](displayUnit="m3/s.m2")= 3e-4 "Area outdoor air rate Ra";
  parameter Real outAirPerPer[numOfZon](displayUnit="m3/s.person") = 2.5e-3 "People outdoor air rate Rp";
  parameter Modelica.SIunits.Area zonAre[numOfZon](displayUnit="m2") "Each zone area";

  parameter Real occDen[numOfZon](displayUnit="person/m2") = 0.05 "Default number of person in unit area";



  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));




end OutdoorAirFlowSetpointMultiZone;
