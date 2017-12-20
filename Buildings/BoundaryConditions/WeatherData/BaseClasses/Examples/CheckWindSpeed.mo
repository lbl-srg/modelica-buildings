within Buildings.BoundaryConditions.WeatherData.BaseClasses.Examples;
model CheckWindSpeed "Test model for wind speed check"
  extends Modelica.Icons.Example;
  Buildings.Utilities.Time.ModelTime modTim
    "Block that outputs simulation time"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Buildings.BoundaryConditions.WeatherData.BaseClasses.CheckWindSpeed cheWinSpe
    "Block that constrains the wind speed"
    annotation (Placement(transformation(extent={{60,0},{80,20}})));
  Buildings.BoundaryConditions.WeatherData.BaseClasses.ConvertTime conTim
    "Block that converts time"
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
protected
  Modelica.Blocks.Tables.CombiTable1Ds datRea(
    tableOnFile=true,
    tableName="tab1",
    fileName=Modelica.Utilities.Files.loadResource(
       Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos")),
    columns=2:30,
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative)
    "Data reader"
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
equation
  connect(datRea.y[16], cheWinSpe.winSpeIn) annotation (Line(
      points={{41,10.069},{50,10.069},{50,10},{58,10}},
      color={0,0,127}));
  connect(modTim.y, conTim.modTim) annotation (Line(
      points={{-39,10},{-22,10}},
      color={0,0,127}));
  connect(conTim.calTim, datRea.u) annotation (Line(
      points={{1,10},{18,10}},
      color={0,0,127}));
  annotation (
Documentation(info="<html>
<p>
This example tests the model that constrains the wind speed.
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
</html>"),
  experiment(Tolerance=1e-6, StartTime=0, StopTime=8640000),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/BoundaryConditions/WeatherData/BaseClasses/Examples/CheckWindSpeed.mos"
        "Simulate and plot"));
end CheckWindSpeed;
