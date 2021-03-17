within Buildings.BoundaryConditions.GroundTemperature;
package ClimaticConstants
  record Generic
    extends Modelica.Icons.Record;
    parameter Modelica.SIunits.Temperature TMeaSur "Mean annual surface temperature";
    parameter Modelica.SIunits.TemperatureDifference TSurAmp "Surface temperature amplitude";
    parameter Modelica.SIunits.Duration sinPhaDay "Phase lag of soil surface temperature (in days)";

  end Generic;
  extends Modelica.Icons.MaterialPropertiesPackage;

  record NewYork =
      Buildings.BoundaryConditions.GroundTemperature.ClimaticConstants.Generic
      (
      TMeaSur=273.15+12.88,
      TSurAmp=11.45,
      sinPhaDay=112.6) "New York";
  record SanFrancisco =
      Buildings.BoundaryConditions.GroundTemperature.ClimaticConstants.Generic
      (
      TMeaSur=273.15+14.49,
      TSurAmp=3.35,
      sinPhaDay=120.6) "San Francisco";
  record Boston =
      Buildings.BoundaryConditions.GroundTemperature.ClimaticConstants.Generic
      (
      TMeaSur=273.15+11.08,
      TSurAmp=11.57,
      sinPhaDay=115.1) "Boston";
  annotation (Documentation(info="<html>
See \"Climatic Constants for Calculating Subsurface Soil Temperatures\"
</html>"));
end ClimaticConstants;
