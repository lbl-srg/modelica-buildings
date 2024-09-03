within Buildings.BoundaryConditions.SolarIrradiation.Examples;
model GlobalPerezTiltedSurface
  "Test model for global solar irradiation on a tilted surface with diffuse
  irradiation calculation based on Perez"
  extends Modelica.Icons.Example;

  parameter Real rho=0.2 "Ground reflectance";

  WeatherData.ReaderTMY3 weaDat(filNam=
        Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos"))
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));

  Buildings.BoundaryConditions.SolarIrradiation.GlobalPerezTiltedSurface HGloRoo(
    til=Buildings.Types.Tilt.Ceiling,
    azi=0.78539816339745,
    rho=rho)
    "Diffuse irradiation on roof"
    annotation (Placement(transformation(extent={{40,0},{60,20}})));
  Buildings.BoundaryConditions.SolarIrradiation.GlobalPerezTiltedSurface HGloFlo(
    til=Buildings.Types.Tilt.Floor,
    azi=0.78539816339745,
    rho=rho)
    "Diffuse irradiation on floor"
    annotation (Placement(transformation(extent={{40,-80},{60,-60}})));
  Buildings.BoundaryConditions.SolarIrradiation.GlobalPerezTiltedSurface HGloWal(
    til=Buildings.Types.Tilt.Wall,
    azi=0.78539816339745,
    rho=rho)
    "Diffuse irradiation on wall"
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
  WeatherData.Bus weaBus
    "Weather data bus"
    annotation (Placement(
        transformation(extent={{1,-1},{21,21}}), iconTransformation(extent={{20,20},
            {21,21}})));
equation
  connect(weaDat.weaBus,weaBus)  annotation (Line(
      points={{-20,10},{11,10}},
      color={255,204,51},
      thickness=0.5), Text(
      textString="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(weaBus,HGloRoo. weaBus) annotation (Line(
      points={{11,10},{40,10}},
      color={255,204,51},
      thickness=0.5), Text(
      textString="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus,HGloFlo. weaBus) annotation (Line(
      points={{11,10},{30,10},{30,-70},{40,-70}},
      color={255,204,51},
      thickness=0.5), Text(
      textString="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus,HGloWal. weaBus) annotation (Line(
      points={{11,10},{30,10},{30,-30},{40,-30}},
      color={255,204,51},
      thickness=0.5), Text(
      textString="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  annotation (
  experiment(StartTime=1.82304e+07, Tolerance=1e-6, StopTime=1.83168e+07),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/BoundaryConditions/SolarIrradiation/Examples/GlobalPerezTiltedSurface.mos"
        "Simulate and plot"),
  Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>This model tests the implementation of global irradiation computation based on Perez&apos; model for diffuse solar radiation.</p>
<p>The three instances of the model compute the global solar irradiation on a roof, a wall and a floor.</p>
<p>Since the floor only sees the ground but not the radiative heat flow that is scattered in the atmosphere,
it receives the lowest amount of diffuse and global solar irradiation.</p>
</html>",
revisions="<html>
<ul>
<li>
Nov 14, 2022, by Laura Maier:<br/>
First implementation.
</li>
</ul>
</html>"));
end GlobalPerezTiltedSurface;
