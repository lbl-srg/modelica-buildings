within Buildings.BoundaryConditions.WeatherData.BaseClasses.Examples;
model CheckTemperature "Test model for CheckTemperature"
  extends Modelica.Icons.Example;
  Buildings.BoundaryConditions.WeatherData.BaseClasses.CheckTemperature
    cheTemDryBul "Check dry bulb temperature "
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
  Buildings.BoundaryConditions.WeatherData.BaseClasses.CheckTemperature
    cheTemDewPoi "Check dew point temperature"
    annotation (Placement(transformation(extent={{60,-20},{80,0}})));
  Buildings.Utilities.Time.ModelTime modTim
    "Block that outputs the model time"
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));
  Buildings.BoundaryConditions.WeatherData.BaseClasses.ConvertTime conTim
    "Block that converts time"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Modelica.Blocks.Math.UnitConversions.From_degC from_degC
    "Block that converts temperature"
    annotation (Placement(transformation(extent={{20,20},{42,40}})));
  Modelica.Blocks.Math.UnitConversions.From_degC from_degC1
    "Block that converts temperature"
    annotation (Placement(transformation(extent={{20,-20},{42,0}})));
protected
  Modelica.Blocks.Tables.CombiTable1Ds datRea(
    tableOnFile=true,
    tableName="tab1",
    fileName=Modelica.Utilities.Files.loadResource(
       Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos")),
    columns=2:30,
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative)
    "Data reader"
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
equation
  connect(modTim.y, conTim.modTim) annotation (Line(
      points={{-79,10},{-62,10}},
      color={0,0,127}));
  connect(conTim.calTim, datRea.u) annotation (Line(
      points={{-39,10},{-22,10}},
      color={0,0,127}));
  connect(datRea.y[1], from_degC.u) annotation (Line(
      points={{1,9.03448},{10,9.03448},{10,30},{17.8,30}},
      color={0,0,127}));
  connect(from_degC.y, cheTemDryBul.TIn) annotation (Line(
      points={{43.1,30},{58,30}},
      color={0,0,127}));
  connect(datRea.y[2], from_degC1.u) annotation (Line(
      points={{1,9.10345},{10,9.10345},{10,-10},{17.8,-10}},
      color={0,0,127}));
  connect(from_degC1.y, cheTemDewPoi.TIn) annotation (Line(
      points={{43.1,-10},{58,-10}},
      color={0,0,127}));
  annotation (
Documentation(info="<html>
<p>
This example tests the model that checks the temperature.
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
__Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/BoundaryConditions/WeatherData/BaseClasses/Examples/CheckTemperature.mos"
        "Simulate and plot"));
end CheckTemperature;
