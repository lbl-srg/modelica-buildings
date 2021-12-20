within Buildings.BoundaryConditions.WeatherData.BaseClasses.Examples;
model LimitMin "Test model for ceiling height check"
  extends Modelica.Icons.Example;
  Buildings.Utilities.Time.ModelTime modTim
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  Buildings.BoundaryConditions.WeatherData.BaseClasses.LimiterCeilingHeight limCeiHei
    "Block that constrains the ceiling height"
    annotation (Placement(transformation(extent={{40,-20},{60,0}})));
  Buildings.BoundaryConditions.WeatherData.BaseClasses.ConvertTime conTim(
    weaDatStaTim=0,
    weaDatEndTim=31536000)
    "Block that converts time"
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
protected
  Modelica.Blocks.Tables.CombiTable1Ds datRea(
    tableOnFile=true,
    tableName="tab1",
    fileName=Modelica.Utilities.Files.loadResource(
       Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos")),
    columns=2:30,
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative)
    "Data reader"
    annotation (Placement(transformation(extent={{0,-20},{20,0}})));
equation
  connect(datRea.y[20],limCeiHei.u) annotation (Line(
      points={{21,-10},{30,-10},{30,-10},{38,-10}},
      color={0,0,127}));
  connect(modTim.y, conTim.modTim) annotation (Line(
      points={{-59,-10},{-42,-10}},
      color={0,0,127}));
  connect(conTim.calTim, datRea.u) annotation (Line(
      points={{-19,-10},{-2,-10}},
      color={0,0,127}));
  annotation (
Documentation(info="<html>
<p>
This example tests the model that constrains the ceiling height.
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
  experiment(Tolerance=1e-6, StartTime=0, StopTime=432000),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/BoundaryConditions/WeatherData/BaseClasses/Examples/LimitMin.mos"
        "Simulate and plot"));
end LimitMin;
