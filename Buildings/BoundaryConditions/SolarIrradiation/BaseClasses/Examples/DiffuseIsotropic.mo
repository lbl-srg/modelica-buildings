within Buildings.BoundaryConditions.SolarIrradiation.BaseClasses.Examples;
model DiffuseIsotropic
  "Test model for diffuse solar irradiation on a tilted surface by using isotropic model"
  extends Modelica.Icons.Example;
  Buildings.BoundaryConditions.SolarIrradiation.BaseClasses.DiffuseIsotropic
    HDifTilIso(til=1.5707963267949)
    annotation (Placement(transformation(extent={{40,0},{60,20}})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos"))
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus
    annotation (Placement(transformation(extent={{-11,-1},{9,21}})));
equation
  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{-40,10},{-1,10}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(weaBus.HGloHor, HDifTilIso.HGloHor) annotation (Line(
      points={{-1,10},{24,10},{24,14},{38,14}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus.HDifHor, HDifTilIso.HDifHor) annotation (Line(
      points={{-1,10},{24,10},{24,6},{38,6}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  annotation (
  Documentation(info="<html>
<p>
This example computes the hemispherical diffuse irradiation on a tilted surface.
</p>
</html>", revisions="<html>
<ul>
<li>
May 24, 2010, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"),
  experiment(Tolerance=1e-6, StartTime=0, StopTime=8640000),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/BoundaryConditions/SolarIrradiation/BaseClasses/Examples/DiffuseIsotropic.mos"
        "Simulate and plot"));
end DiffuseIsotropic;
