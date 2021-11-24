within Buildings.BoundaryConditions.GroundTemperature;
package ClimaticConstants "Surface temperature climatic constants"
  extends Modelica.Icons.MaterialPropertiesPackage;

  record Generic "Generic climatic constants"
    extends Modelica.Icons.Record;
    parameter Modelica.SIunits.Temperature TSurMea
      "Mean annual surface temperature";
    parameter Modelica.SIunits.TemperatureDifference TSurAmp
      "Surface temperature amplitude";
    parameter Modelica.SIunits.Duration sinPha(displayUnit="d")
      "Phase lag of soil surface temperature";
  end Generic;

  record Boston =
    Buildings.BoundaryConditions.GroundTemperature.ClimaticConstants.Generic(
      TSurMea=284.23,
      TSurAmp=11.57,
      sinPha=9944640) "Boston";

  record NewYork =
    Buildings.BoundaryConditions.GroundTemperature.ClimaticConstants.Generic(
      TSurMea=286.03,
      TSurAmp=11.45,
      sinPha=9728640) "New York";

  record SanFrancisco =
    Buildings.BoundaryConditions.GroundTemperature.ClimaticConstants.Generic(
      TSurMea=287.64,
      TSurAmp=3.35,
      sinPha=10419840) "San Francisco";

  annotation (Documentation(info="<html>
<p>
Surface temperature data that is used in the calculation of undisturbed soil temperature.
See <a href=\"https://tc0602.ashraetcs.org/Climatic_constants_using_ASHRAE_CD_Ver_6.0.pdf\">
Climatic Constants for Calculating Subsurface Soil Temperatures</a> for
more information and a table of values.
</p>
</html>", revisions="<html>
<ul>
<li>
March 17, 2021, by Baptiste Ravache:<br/>
First implementation.
</li>
</ul>
</html>"));
end ClimaticConstants;
