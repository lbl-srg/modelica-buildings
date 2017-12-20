within Buildings.BoundaryConditions.WeatherData.BaseClasses.Examples;
model ConvertRelativeHumidity
  "Test model for converting relative humidity and checking its validity"
  extends Modelica.Icons.Example;
  Buildings.BoundaryConditions.WeatherData.BaseClasses.ConvertRelativeHumidity conRelHum
    "Block that converts relative humidity"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Utilities.Time.ModelTime modTim
    "Block that outputs simulation time"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.BoundaryConditions.WeatherData.BaseClasses.ConvertTime conTim
    "Block that converts time"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
protected
  Modelica.Blocks.Tables.CombiTable1Ds datRea(
    tableOnFile=true,
    tableName="tab1",
    fileName=Modelica.Utilities.Files.loadResource(
       Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos")),
    columns=2:30,
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative)
    "Data reader"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));

equation
  connect(datRea.y[3], conRelHum.relHumIn) annotation (Line(
      points={{21,-0.827586},{30,-0.827586},{30,0},{38,0}},
      color={0,0,127}));
  connect(modTim.y, conTim.modTim) annotation (Line(
      points={{-59,0},{-42,0}},
      color={0,0,127}));
  connect(conTim.calTim, datRea.u) annotation (Line(
      points={{-19,0},{-2,0}},
      color={0,0,127}));
  annotation (
  Documentation(info="<html>
<p>
This example tests the model that converts relative humidity.
</p>
</html>",
revisions="<html>
<ul>
<li>
April 21, 2016, by Michael Wetter:<br/>
Replaced <code>ModelicaServices.ExternalReferences.loadResource</code> with
<code>Modelica.Utilities.Files.loadResource</code>.
</li>
<li>
July 14, 2010, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"),experiment(Tolerance=1e-6, StartTime=0, StopTime=8640000),
__Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/BoundaryConditions/WeatherData/BaseClasses/Examples/ConvertRelativeHumidity.mos"
        "Simulate and plot"));
end ConvertRelativeHumidity;
