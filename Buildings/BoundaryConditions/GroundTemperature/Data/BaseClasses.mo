within Buildings.BoundaryConditions.GroundTemperature.Data;
package BaseClasses
  record ClimaticConstants
    extends Modelica.Icons.Record;
    parameter Modelica.SIunits.Temperature TMeaSur "Mean annual surface temperature";
    parameter Modelica.SIunits.TemperatureDifference TSurAmp "Surface temperature amplitude";
    parameter Modelica.SIunits.Duration sinPhaDay "Phase lag of soil surface temperature (in days)";

  end ClimaticConstants;
end BaseClasses;
