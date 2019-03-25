within Buildings.BoundaryConditions.WeatherData.Validation;
model OverAYear_usingOneYearData
  "Validation model for a simulation extending with two months over one year but using data for only one year"
  extends Modelica.Icons.Example;
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    computeWetBulbTemperature=false,
    TDewPoiSou=Buildings.BoundaryConditions.Types.DataSource.Parameter,
    HInfHorSou=Buildings.BoundaryConditions.Types.DataSource.Parameter,
    HInfHor=100,
    calTSky=Buildings.BoundaryConditions.Types.SkyTemperatureCalculation.HorizontalRadiation,
    filNam=Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos"))
    "Weather data reader with data file for one year, hourly data"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  annotation (experiment(
      StopTime=36633600,
      Tolerance=1e-006),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/BoundaryConditions/WeatherData/Validation/OverAYear_usingOneYearData.mos"
        "Simulate and plot"),
      Documentation(info="<html>
<p>
This is a validation case for a simulation extending with two months over one year,
but using data for only one year.
</p>
<p>
The test script plots the dry bulb temperature for the days 0-10 and 365-375 for comparison.
</p>
</html>", revisions="<html>
<ul>
<li>September 3, 2018 by Ana Constantin:<br/>
First implementation for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/842\">issue 842</a>.
</li>
</ul>
</html>"));

end OverAYear_usingOneYearData;
