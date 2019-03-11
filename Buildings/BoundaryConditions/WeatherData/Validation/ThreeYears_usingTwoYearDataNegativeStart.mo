within Buildings.BoundaryConditions.WeatherData.Validation;
model ThreeYears_usingTwoYearDataNegativeStart
  "Validation model for a simulation spanning three years, starting at a negative time and using only two years of data"
  extends
    Buildings.BoundaryConditions.WeatherData.Validation.ThreeYears_usingTwoYearData;

  annotation (experiment(
      StartTime=-47174400,
      StopTime=47433600,
      Tolerance=1e-006),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/BoundaryConditions/WeatherData/Validation/ThreeYears_usingTwoYearDataNegativeStart.mos"
        "Simulate and plot"),
      Documentation(info="<html>
<p>
This is a validation case for a simulation extending over six years
starting at a negative start date,
but using only two years of data with equidistant monthly values.
</p>
</html>", revisions="<html>
<ul>
<li>March 5, 2019 by Michael Wetter:<br/>
First implementation for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/842\">issue 842</a>.
</li>
</ul>
</html>"));

end ThreeYears_usingTwoYearDataNegativeStart;
