within Buildings.BoundaryConditions.GroundTemperature.ClimaticConstants;
record Generic "Generic climatic constants"
  extends Modelica.Icons.Record;
  parameter Modelica.SIunits.Temperature TMeaSur "Mean annual surface temperature";
  parameter Modelica.SIunits.TemperatureDifference TSurAmp "Surface temperature amplitude";
  parameter Modelica.SIunits.Duration sinPhaDay "Phase lag of soil surface temperature (in days)";

end Generic;
