within Buildings.BoundaryConditions.SolarIrradiation.BaseClasses.Examples;
model BrighteningCoeffcient "Test model for brightening coeffcients"
  import Buildings;
  Buildings.BoundaryConditions.SolarGeometry.ZenithAngle zen(lat=
        0.6457718232379)
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  Buildings.BoundaryConditions.SolarIrradiation.BaseClasses.SkyClearness skyCle
    annotation (Placement(transformation(extent={{40,20},{60,40}})));
  Buildings.BoundaryConditions.SolarIrradiation.BaseClasses.BrighteningCoefficient
    briCoe annotation (Placement(transformation(extent={{80,-20},{100,0}})));
  Buildings.BoundaryConditions.SolarIrradiation.BaseClasses.RelativeAirMass
    relAirMas annotation (Placement(transformation(extent={{0,-20},{20,0}})));
  Buildings.BoundaryConditions.SolarIrradiation.BaseClasses.SkyBrightness
    skyBri annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
  Buildings.BoundaryConditions.WeatherData.ReadWeatherData weaDat(filNam=
        "Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos")
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Buildings.BoundaryConditions.WeatherData.WeatherBus weaBus annotation (Placement(
        transformation(extent={{-20,60},{0,80}}), iconTransformation(extent={{-20,
            60},{-20,60}})));
  Buildings.Utilities.SimulationTime simTim
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));
equation
  connect(zen.y, skyCle.zen) annotation (Line(
      points={{-19,-10},{-8,-10},{-8,24},{38,24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(relAirMas.relAirMas, skyBri.relAirMas) annotation (Line(
      points={{21,-10},{30,-10},{30,-26},{38,-26}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(zen.y, relAirMas.zen) annotation (Line(
      points={{-19,-10},{-2,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(skyBri.skyBri, briCoe.skyBri) annotation (Line(
      points={{61,-30},{68,-30},{68,-10},{78,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(skyCle.skyCle, briCoe.skyCle) annotation (Line(
      points={{61,30},{68,30},{68,-4},{78,-4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(zen.y, briCoe.zen) annotation (Line(
      points={{-19,-10},{-8,-10},{-8,-60},{72,-60},{72,-16},{78,-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{-40,70},{-10,70}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(weaBus.HGloHor, skyCle.HGloHor) annotation (Line(
      points={{-10,70},{22,70},{22,36},{38,36}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus.HDifHor, skyCle.HDifHor) annotation (Line(
      points={{-10,70},{22,70},{22,30},{38,30}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus.HDifHor, skyBri.HDifHor) annotation (Line(
      points={{-10,70},{22,70},{22,-34},{38,-34}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(simTim.y, weaDat.cloTim) annotation (Line(
      points={{-79,-10},{-70,-10},{-70,70},{-62,70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(weaBus.cloTim, zen.cloTim) annotation (Line(
      points={{-10,70},{-10,30},{-60,30},{-60,-10},{-42,-10}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  annotation (
    Diagram(graphics),
    Commands(file="BrighteningCoefficient.mos" "run"),
    Icon(graphics));
end BrighteningCoeffcient;
