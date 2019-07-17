within Buildings.BoundaryConditions.SolarIrradiation.BaseClasses.Examples;
model SkyBrightness "Test model for sky brightness"
  extends Modelica.Icons.Example;
  Buildings.BoundaryConditions.SolarIrradiation.BaseClasses.RelativeAirMass relAirMas
    "Relative air mass"
     annotation (Placement(transformation(extent={{10,20},{30,40}})));
  Buildings.BoundaryConditions.SolarGeometry.ZenithAngle zen(
    lat=0.34906585039887) "Zenith angle"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  Buildings.BoundaryConditions.SolarIrradiation.BaseClasses.SkyBrightness skyBri
    "Sky brightness"
    annotation (Placement(transformation(extent={{60,-16},{80,4}})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
    Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos"))
    "Weather data"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
    annotation (Placement(
        transformation(extent={{-50,-20},{-30,0}}),iconTransformation(extent={{
            -22,-20},{-22,-20}})));
equation
  connect(zen.y, relAirMas.zen) annotation (Line(
      points={{1,30},{8,30}},
      color={0,0,127}));
  connect(relAirMas.relAirMas, skyBri.relAirMas) annotation (Line(
      points={{31,30},{40,30},{40,-2},{58,-2}},
      color={0,0,127}));
  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{-60,-10},{-40,-10}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(weaBus.HDifHor, skyBri.HDifHor) annotation (Line(
      points={{-40,-10},{58,-10}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(zen.weaBus, weaBus) annotation (Line(
      points={{-20,30},{-30,30},{-30,-10},{-40,-10}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  annotation (
Documentation(info="<html>
<p>
This example computes the sky brightness.
</p>
</html>", revisions="<html>
<ul>
<li>
July 07, 2010, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"),
experiment(Tolerance=1e-6, StopTime=8640000),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/BoundaryConditions/SolarIrradiation/BaseClasses/Examples/SkyBrightness.mos"
        "Simulate and plot"));
end SkyBrightness;
