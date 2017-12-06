within Buildings.BoundaryConditions.WeatherData.BaseClasses.Examples;
model ConvertRadiation "Test model for ConvertRadiation"
  extends Modelica.Icons.Example;
  Buildings.BoundaryConditions.WeatherData.BaseClasses.ConvertRadiation
    conGloRad "Convert units for global horizontal radiation"
    annotation (Placement(transformation(extent={{40,10},{60,30}})));
  Buildings.BoundaryConditions.WeatherData.BaseClasses.ConvertRadiation
    conDifRad "Convert units for diffuse horizontal radiation"
    annotation (Placement(transformation(extent={{40,-30},{60,-10}})));
  Buildings.Utilities.Time.ModelTime modTim
    "Block that outputs simulation time"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.BoundaryConditions.WeatherData.BaseClasses.ConvertTime timCon
    "Convert simmulation time to calendar time"
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
  connect(timCon.calTim, datRea.u) annotation (Line(
      points={{-19,0},{-2,0}},
      color={0,0,127}));
  connect(datRea.y[8], conGloRad.HIn) annotation (Line(
      points={{21,-0.482759},{30,-0.482759},{30,20},{38,20}},
      color={0,0,127}));
  connect(datRea.y[10], conDifRad.HIn) annotation (Line(
      points={{21,-0.344828},{30,-0.344828},{30,-20},{38,-20}},
      color={0,0,127}));
  connect(modTim.y, timCon.modTim) annotation (Line(
      points={{-59,0},{-42,0}},
      color={0,0,127}));
  annotation (
Documentation(info="<html>
<p>
This example tests the model that converts radiation.
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
          "modelica://Buildings/Resources/Scripts/Dymola/BoundaryConditions/WeatherData/BaseClasses/Examples/ConvertRadiation.mos"
        "Simulate and plot"));
end ConvertRadiation;
