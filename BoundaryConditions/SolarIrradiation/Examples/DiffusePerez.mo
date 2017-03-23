within Buildings.BoundaryConditions.SolarIrradiation.Examples;
model DiffusePerez
  "Test model for diffuse solar irradiation on a tilted surface using the Perez model"
  extends Modelica.Icons.Example;
  parameter Modelica.SIunits.Angle lat=37/180*Modelica.Constants.pi "Latitude";
  parameter Modelica.SIunits.Angle azi=0.3 "Azi angle";
  parameter Modelica.SIunits.Angle til=0.5 "Tilted angle";
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        "modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos")
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus annotation (Placement(
        transformation(extent={{1,-1},{21,21}}), iconTransformation(extent={{20,
            20},{21,21}})));
  Buildings.BoundaryConditions.SolarIrradiation.DiffusePerez HDifRoo(
    til=Buildings.HeatTransfer.Types.Tilt.Ceiling,
    lat=0.6457718232379,
    azi=0.78539816339745) "Diffuse irradiation on roof"
    annotation (Placement(transformation(extent={{40,0},{60,20}})));
  Buildings.BoundaryConditions.SolarIrradiation.DiffusePerez HDifFlo(
    til=Buildings.HeatTransfer.Types.Tilt.Floor,
    lat=0.6457718232379,
    azi=0.78539816339745) "Diffuse irradiation on floor"
    annotation (Placement(transformation(extent={{40,-80},{60,-60}})));
  Buildings.BoundaryConditions.SolarIrradiation.DiffusePerez HDifWal(
    til=Buildings.HeatTransfer.Types.Tilt.Wall,
    lat=0.6457718232379,
    azi=0.78539816339745) "Diffuse irradiation on wall"
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
equation
  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{-20,10},{11,10}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(weaBus,HDifRoo. weaBus) annotation (Line(
      points={{11,10},{40,10}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));

  connect(weaBus, HDifFlo.weaBus) annotation (Line(
      points={{11,10},{30.5,10},{30.5,-70},{40,-70}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus, HDifWal.weaBus) annotation (Line(
      points={{11,10},{30,10},{30,-30},{40,-30}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics),
experiment(StartTime=1.82304e+07, StopTime=1.83168e+07),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/BoundaryConditions/SolarIrradiation/Examples/DiffusePerez.mos"
        "Simulate and plot"),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics),
    Documentation(info="<html>
<p>
This model tests the implementation of Perez' model for diffuse solar radiation.
The three instances of Perez' model compute the diffuse solar
irradiation on a roof, a wall and a floor.
Since the floor only sees the ground but not the radiative heat flow that is 
scattered in the atmosphere, it receives the lowest amount of
diffuse solar irradiation.
</p>
</html>"));
end DiffusePerez;
