within Buildings.BoundaryConditions.WeatherData.Validation;
model ReaderTMY3WindDirection "Validation model for wind direction"
  extends Modelica.Icons.Example;
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDatInpCon(filNam=
        Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"),
    computeWetBulbTemperature=false,
      winDirSou=Buildings.BoundaryConditions.Types.DataSource.Input)
    "Weather data reader with wind direction from input connector"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.Ramp winDir(
    height=12*Modelica.Constants.pi,
    duration=8640000,
    offset=-6*Modelica.Constants.pi)
    "Wind incidence angle"
    annotation (Placement(transformation(extent={{-60,-16},{-40,4}})));
equation
  connect(winDir.y, weaDatInpCon.winDir_in)
    annotation (Line(points={{-39,-6},{-11,-6}}, color={0,0,127}));
  annotation (experiment(Tolerance=1e-6, StartTime=0, StopTime=8640000),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/BoundaryConditions/WeatherData/Validation/ReaderTMY3WindDirection.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This model tests the TMY3 data reader and its restriction on the wind direction
if the wind direction has a large range.
On the weather bus, the wind direction has the range of [0, 360) degrees.
</p>
</html>",
revisions="<html>
<ul>
<li>
May 1, 2026, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end ReaderTMY3WindDirection;
