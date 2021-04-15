within Buildings.BoundaryConditions.GroundTemperature;
package ClimaticConstants "Surface temperature climatic constants"
  extends Modelica.Icons.MaterialPropertiesPackage;

  record Boston =
      Buildings.BoundaryConditions.GroundTemperature.ClimaticConstants.Generic
      (
      TSurMea=273.15+11.08,
      TSurAmp=11.57,
      sinPhaDay=115.1) "Boston";
  record Generic "Generic climatic constants"
    extends Modelica.Icons.Record;
    parameter Modelica.SIunits.Temperature TSurMea
      "Mean annual surface temperature";
    parameter Modelica.SIunits.TemperatureDifference TSurAmp
      "Surface temperature amplitude";
    parameter Modelica.SIunits.Duration sinPhaDay
      "Phase lag of soil surface temperature (in days)";

  end Generic;

  record NewYork =
      Buildings.BoundaryConditions.GroundTemperature.ClimaticConstants.Generic
      (
      TSurMea=273.15+12.88,
      TSurAmp=11.45,
      sinPhaDay=112.6) "New York";
  record SanFrancisco =
      Buildings.BoundaryConditions.GroundTemperature.ClimaticConstants.Generic
      (
      TSurMea=273.15+14.49,
      TSurAmp=3.35,
      sinPhaDay=120.6) "San Francisco";
  annotation (Documentation(info="<html>
<p>
Surface temperature data that is used in the calculation of undisturbed soil temperature.
See <a href=\"https://tc0602.ashraetcs.org/Climatic_constants_using_ASHRAE_CD_Ver_6.0.pdf\">
Climatic Constants for Calculating Subsurface Soil Temperatures</a> for
more information and a table of values
</p>
</html>"));
end ClimaticConstants;
