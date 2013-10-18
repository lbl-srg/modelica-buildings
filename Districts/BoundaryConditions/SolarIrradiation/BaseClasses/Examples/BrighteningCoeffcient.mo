within Districts.BoundaryConditions.SolarIrradiation.BaseClasses.Examples;
model BrighteningCoeffcient "Test model for brightening coeffcients"
  extends Modelica.Icons.Example;
  import Districts;
  Districts.BoundaryConditions.SolarGeometry.ZenithAngle zen(lat=
        0.6457718232379)
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  Districts.BoundaryConditions.SolarIrradiation.BaseClasses.SkyClearness skyCle
    annotation (Placement(transformation(extent={{40,20},{60,40}})));
  Districts.BoundaryConditions.SolarIrradiation.BaseClasses.BrighteningCoefficient
    briCoe annotation (Placement(transformation(extent={{80,-20},{100,0}})));
  Districts.BoundaryConditions.SolarIrradiation.BaseClasses.RelativeAirMass
    relAirMas annotation (Placement(transformation(extent={{0,-20},{20,0}})));
  Districts.BoundaryConditions.SolarIrradiation.BaseClasses.SkyBrightness
    skyBri annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
  Districts.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        "modelica://Districts/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos")
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Districts.BoundaryConditions.WeatherData.Bus weaBus annotation (Placement(
        transformation(extent={{-20,60},{0,80}}), iconTransformation(extent={{-20,
            60},{-20,60}})));
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
  connect(weaBus, zen.weaBus) annotation (Line(
      points={{-10,70},{-12,70},{-12,28},{-54,28},{-54,-10},{-40.2,-10}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  annotation (
    Diagram(graphics),
    __Dymola_Commands(file="modelica://Districts/Resources/Scripts/Dymola/BoundaryConditions/SolarIrradiation/BaseClasses/Examples/BrighteningCoefficient.mos" "run"),
    Icon(graphics));
end BrighteningCoeffcient;
