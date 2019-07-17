within Buildings.BoundaryConditions.SolarIrradiation.BaseClasses.Examples;
model BrighteningCoefficient "Test model for brightening coeffcients"
  extends Modelica.Icons.Example;
  Buildings.BoundaryConditions.SolarGeometry.ZenithAngle zen(lat=
        0.6457718232379)
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  Buildings.BoundaryConditions.SolarIrradiation.BaseClasses.SkyClearness skyCle
    annotation (Placement(transformation(extent={{40,20},{60,40}})));
  Buildings.BoundaryConditions.SolarIrradiation.BaseClasses.BrighteningCoefficient
    briCoe annotation (Placement(transformation(extent={{80,-20},{100,0}})));
  Buildings.BoundaryConditions.SolarIrradiation.BaseClasses.RelativeAirMass
    relAirMas annotation (Placement(transformation(extent={{-10,-20},{10,0}})));
  Buildings.BoundaryConditions.SolarIrradiation.BaseClasses.SkyBrightness
    skyBri annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos"))
    annotation (Placement(transformation(extent={{-90,60},{-70,80}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus annotation (Placement(
        transformation(extent={{-60,60},{-40,80}}),
                                                  iconTransformation(extent={{-20,
            60},{-20,60}})));
equation
  connect(zen.y, skyCle.zen) annotation (Line(
      points={{-19,-10},{-16,-10},{-16,24},{38,24}},
      color={0,0,127}));
  connect(relAirMas.relAirMas, skyBri.relAirMas) annotation (Line(
      points={{11,-10},{30,-10},{30,-26},{38,-26}},
      color={0,0,127}));
  connect(zen.y, relAirMas.zen) annotation (Line(
      points={{-19,-10},{-12,-10}},
      color={0,0,127}));
  connect(skyBri.skyBri, briCoe.skyBri) annotation (Line(
      points={{61,-30},{68,-30},{68,-10},{78,-10}},
      color={0,0,127}));
  connect(skyCle.skyCle, briCoe.skyCle) annotation (Line(
      points={{61,30},{68,30},{68,-4},{78,-4}},
      color={0,0,127}));
  connect(zen.y, briCoe.zen) annotation (Line(
      points={{-19,-10},{-16,-10},{-16,-60},{72,-60},{72,-16},{78,-16}},
      color={0,0,127}));
  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{-70,70},{-50,70}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(weaBus.HGloHor, skyCle.HGloHor) annotation (Line(
      points={{-50,70},{20,70},{20,36},{38,36}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus.HDifHor, skyCle.HDifHor) annotation (Line(
      points={{-50,70},{20,70},{20,30},{38,30}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus.HDifHor, skyBri.HDifHor) annotation (Line(
      points={{-50,70},{20,70},{20,-34},{38,-34}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus, zen.weaBus) annotation (Line(
      points={{-50,70},{-50,70},{-50,28},{-50,28},{-50,-10},{-40,-10}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  annotation (
Documentation(info="<html>
<p>
This example computes the circumsolar and horizon brightening coefficients.
</p>
</html>", revisions="<html>
<ul>
<li>
May 25, 2010, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"),
experiment(Tolerance=1e-6, StopTime=8640000),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/BoundaryConditions/SolarIrradiation/BaseClasses/Examples/BrighteningCoefficient.mos" "run"));
end BrighteningCoefficient;
