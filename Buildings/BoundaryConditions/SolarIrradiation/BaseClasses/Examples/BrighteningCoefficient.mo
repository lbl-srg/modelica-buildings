within Buildings.BoundaryConditions.SolarIrradiation.BaseClasses.Examples;
model BrighteningCoefficient "Test model for brightening coeffcients"
  extends Modelica.Icons.Example;
  Buildings.BoundaryConditions.SolarGeometry.ZenithAngle zen
    annotation (Placement(transformation(extent={{-42,-20},{-22,0}})));
  Buildings.BoundaryConditions.SolarIrradiation.BaseClasses.SkyClearness skyCle
    annotation (Placement(transformation(extent={{40,20},{60,40}})));
  Buildings.BoundaryConditions.SolarIrradiation.BaseClasses.BrighteningCoefficient
    briCoe annotation (Placement(transformation(extent={{80,-20},{100,0}})));
  Buildings.BoundaryConditions.SolarIrradiation.BaseClasses.RelativeAirMass
    relAirMas annotation (Placement(transformation(extent={{-8,-20},{12,0}})));
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
      points={{-21,-10},{-16,-10},{-16,24},{38,24}},
      color={0,0,127}));
  connect(relAirMas.relAirMas, skyBri.relAirMas) annotation (Line(
      points={{13,-10},{30,-10},{30,-24},{38,-24}},
      color={0,0,127}));
  connect(zen.y, relAirMas.zen) annotation (Line(
      points={{-21,-10},{-16,-10},{-16,-16},{-10,-16}},
      color={0,0,127}));
  connect(skyBri.skyBri, briCoe.skyBri) annotation (Line(
      points={{61,-30},{68,-30},{68,-10},{78,-10}},
      color={0,0,127}));
  connect(skyCle.skyCle, briCoe.skyCle) annotation (Line(
      points={{61,30},{68,30},{68,-4},{78,-4}},
      color={0,0,127}));
  connect(zen.y, briCoe.zen) annotation (Line(
      points={{-21,-10},{-16,-10},{-16,-60},{72,-60},{72,-16},{78,-16}},
      color={0,0,127}));
  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{-70,70},{-50,70}},
      color={255,204,51},
      thickness=0.5), Text(
      textString="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(weaBus.HDifHor, skyCle.HDifHor) annotation (Line(
      points={{-50,70},{20,70},{20,30},{38,30}},
      color={255,204,51},
      thickness=0.5), Text(
      textString="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus.HDifHor, skyBri.HDifHor) annotation (Line(
      points={{-50,70},{20,70},{20,-34},{38,-34}},
      color={255,204,51},
      thickness=0.5), Text(
      textString="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus, zen.weaBus) annotation (Line(
      points={{-50,70},{-50,-10},{-42,-10}},
      color={255,204,51},
      thickness=0.5), Text(
      textString="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus.solTim, skyBri.solTim) annotation (Line(
      points={{-50,70},{-50,-38.4},{38,-38.4}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus.HDirNor, skyCle.HDirNor) annotation (Line(
      points={{-50,70},{20,70},{20,36},{38,36}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus.alt, relAirMas.alt) annotation (Line(
      points={{-50,70},{-18,70},{-18,-4},{-10,-4}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
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
__Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/BoundaryConditions/SolarIrradiation/BaseClasses/Examples/BrighteningCoefficient.mos"
      "Simulate and plot"),
    Diagram(coordinateSystem(extent={{-100,-100},{120,100}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end BrighteningCoefficient;
