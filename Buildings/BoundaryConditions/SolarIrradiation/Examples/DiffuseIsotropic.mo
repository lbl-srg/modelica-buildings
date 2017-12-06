within Buildings.BoundaryConditions.SolarIrradiation.Examples;
model DiffuseIsotropic
  "Test model for diffuse solar irradiation on a tilted surface using the isotropic model"
  extends Modelica.Icons.Example;
  parameter Real rho=0.2 "Ground reflectance";

  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos"))
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
    annotation (Placement(
        transformation(extent={{-11,-1},{9,21}}),iconTransformation(extent={{1,
            -1},{2,-2}})));
  Buildings.BoundaryConditions.SolarIrradiation.DiffuseIsotropic
        HDifRoo(til=Buildings.Types.Tilt.Ceiling,
                rho=rho) "Diffuse irradiation on roof"
    annotation (Placement(transformation(extent={{40,0},{60,20}})));
  Buildings.BoundaryConditions.SolarIrradiation.DiffuseIsotropic
        HDifFlo(til=Buildings.Types.Tilt.Floor,
                rho=rho) "Diffuse irradiation on floor"
    annotation (Placement(transformation(extent={{40,-80},{60,-60}})));
  Buildings.BoundaryConditions.SolarIrradiation.DiffuseIsotropic
        HDifWal(
        til=Buildings.Types.Tilt.Wall,
        rho=rho) "Diffuse irradiation on wall"
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));

equation
  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{-20,10},{-1,10}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));

  connect(weaBus,HDifRoo. weaBus) annotation (Line(
      points={{-1,10},{40,10}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(HDifWal.weaBus, weaBus) annotation (Line(
      points={{40,-30},{20,-30},{20,10},{-1,10}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(HDifFlo.weaBus, weaBus) annotation (Line(
      points={{40,-70},{20,-70},{20,10},{-1,10}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  annotation (
    Documentation(info="<html>
<p>
This example computes the hemispherical diffuse irradiation
on a roof, wall and a floor, using an isotropic sky model.
Since the floor only sees the ground,
it receives the lowest amount of diffuse solar irradiation.
</p>
</html>", revisions="<html>
<ul>
<li>
May 24, 2010, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"),
experiment(StartTime=1.82304e+07, Tolerance=1e-6, StopTime=1.83168e+07),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/BoundaryConditions/SolarIrradiation/Examples/DiffuseIsotropic.mos"
        "Simulate and plot"));
end DiffuseIsotropic;
