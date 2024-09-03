within Buildings.BoundaryConditions.SolarIrradiation.BaseClasses.Examples;
model RelativeAirMass "Test model for relative air mass"
  extends Modelica.Icons.Example;
  Buildings.BoundaryConditions.SolarIrradiation.BaseClasses.RelativeAirMass
    relAirMas annotation (Placement(transformation(extent={{20,6},{40,26}})));
  Buildings.BoundaryConditions.SolarGeometry.ZenithAngle zen
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos"))
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  WeatherData.Bus weaBus annotation (Placement(transformation(extent={{-52,14},
            {-12,54}}), iconTransformation(extent={{-232,-2},{-212,18}})));
equation
  connect(zen.y, relAirMas.zen) annotation (Line(
      points={{1,10},{18,10}},
      color={0,0,127}));
  connect(weaDat.weaBus, zen.weaBus) annotation (Line(
      points={{-40,10},{-20,10}},
      color={255,204,51},
      thickness=0.5));
  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{-40,10},{-32,10},{-32,34}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(weaBus.alt, relAirMas.alt) annotation (Line(
      points={{-32,34},{12,34},{12,22},{18,22}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  annotation (
Documentation(info="<html>
<p>
This example computes the relative air mass for sky brightness.
</p>
</html>", revisions="<html>
<ul>
<li>
July 07, 2010, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"),
  experiment(Tolerance=1e-6, StopTime=864000),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/BoundaryConditions/SolarIrradiation/BaseClasses/Examples/RelativeAirMass.mos"
        "Simulate and plot"));
end RelativeAirMass;
