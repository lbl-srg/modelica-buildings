within Buildings.BoundaryConditions.WeatherData.Validation;
model ThreeYears_usingTwoYearData
  "Validation model for a simulation spanning three years but using only two years of data"
  extends Modelica.Icons.Example;
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    computeWetBulbTemperature=false,
    TDewPoiSou=Buildings.BoundaryConditions.Types.DataSource.Parameter,
    HInfHorSou=Buildings.BoundaryConditions.Types.DataSource.Parameter,
    HInfHor=100,
    calTSky=Buildings.BoundaryConditions.Types.SkyTemperatureCalculation.HorizontalRadiation,
    filNam=Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/Data/BoundaryConditions/WeatherData/Validation/TwoYears_DataOnceAMonth_TMY3.mos"))
    "Weather data reader with data for two years, only monthly values"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  annotation (experiment(
      StopTime=94608000,
      Tolerance=1e-006),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/BoundaryConditions/WeatherData/Validation/ThreeYears_usingTwoYearData.mos"
        "Simulate and plot"),
      Documentation(info="<html>
<p>
This is a validation case for a simulation extending over three years,
but using only two years of data with equidistant monthly values.
</p>
</html>", revisions="<html>
<ul>
<li>September 3, 2018 by Ana Constantin:<br/>
First implementation for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/842\">issue 842</a>.
</li>
</ul>
</html>"));

end ThreeYears_usingTwoYearData;
