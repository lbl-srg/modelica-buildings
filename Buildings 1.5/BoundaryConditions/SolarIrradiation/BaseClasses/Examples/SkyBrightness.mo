within Buildings.BoundaryConditions.SolarIrradiation.BaseClasses.Examples;
model SkyBrightness "Test model for sky brightness"
  extends Modelica.Icons.Example;
  Buildings.BoundaryConditions.SolarIrradiation.BaseClasses.RelativeAirMass
    relAirMas annotation (Placement(transformation(extent={{10,20},{30,40}})));
  Buildings.BoundaryConditions.SolarGeometry.ZenithAngle zen(lat=
        0.34906585039887)
    annotation (Placement(transformation(extent={{-30,20},{-10,40}})));
  Buildings.BoundaryConditions.SolarIrradiation.BaseClasses.SkyBrightness
    skyBri annotation (Placement(transformation(extent={{60,0},{80,20}})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        "modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos")
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus annotation (Placement(
        transformation(extent={{-22,-20},{-2,0}}), iconTransformation(extent={{
            -22,-20},{-22,-20}})));
equation
  connect(zen.y, relAirMas.zen) annotation (Line(
      points={{-9,30},{8,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(relAirMas.relAirMas, skyBri.relAirMas) annotation (Line(
      points={{31,30},{40,30},{40,14},{58,14}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{-40,-10},{-12,-10}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(weaBus.HDifHor, skyBri.HDifHor) annotation (Line(
      points={{-12,-10},{10,-10},{10,6},{58,6}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(zen.weaBus, weaBus) annotation (Line(
      points={{-30.2,30},{-34,30},{-34,10},{-12,10},{-12,-10}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  annotation (
experiment(StopTime=8640000),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/BoundaryConditions/SolarIrradiation/BaseClasses/Examples/SkyBrightness.mos"
        "Simulate and plot"),
    Icon(graphics));
end SkyBrightness;
