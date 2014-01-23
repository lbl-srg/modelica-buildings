within Buildings.BoundaryConditions.SolarIrradiation.Examples;
model DiffuseIsotropic
  "Test model for diffuse solar irradiation on a tilted surface using the isotropic model"
  extends Modelica.Icons.Example;
  parameter Real rho=0.2 "Ground reflectance";

  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        "modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos")
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus annotation (Placement(
        transformation(extent={{1,-1},{21,21}}), iconTransformation(extent={{1,
            -1},{2,-2}})));
  Buildings.BoundaryConditions.SolarIrradiation.DiffuseIsotropic
        HDifRoo(til=Buildings.HeatTransfer.Types.Tilt.Ceiling,
                rho=rho) "Diffuse irradiation on roof"
    annotation (Placement(transformation(extent={{40,0},{60,20}})));
  Buildings.BoundaryConditions.SolarIrradiation.DiffuseIsotropic
        HDifFlo(til=Buildings.HeatTransfer.Types.Tilt.Floor,
                rho=rho) "Diffuse irradiation on floor"
    annotation (Placement(transformation(extent={{40,-80},{60,-60}})));
  Buildings.BoundaryConditions.SolarIrradiation.DiffuseIsotropic
        HDifWal(
        til=Buildings.HeatTransfer.Types.Tilt.Wall,
        rho=rho) "Diffuse irradiation on wall"
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
  connect(weaBus,HDifFlo. weaBus) annotation (Line(
      points={{11,10},{30.5,10},{30.5,-70},{40,-70}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus,HDifWal. weaBus) annotation (Line(
      points={{11,10},{30,10},{30,-30},{40,-30}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  annotation (
experiment(StartTime=1.82304e+07, StopTime=1.83168e+07),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/BoundaryConditions/SolarIrradiation/Examples/DiffuseIsotropic.mos"
        "Simulate and plot"),
    Icon(graphics));
end DiffuseIsotropic;
