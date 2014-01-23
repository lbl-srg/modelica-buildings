within Districts.BoundaryConditions.SolarIrradiation.Examples;
model DiffuseIsotropic
  "Test model for diffuse solar irradiation on a tilted surface using the isotropic model"
  extends Modelica.Icons.Example;
  import Districts;
  parameter Real rho=0.2 "Ground reflectance";

  Districts.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        "modelica://Districts/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos")
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Districts.BoundaryConditions.WeatherData.Bus weaBus annotation (Placement(
        transformation(extent={{1,-1},{21,21}}), iconTransformation(extent={{1,
            -1},{2,-2}})));
  Districts.BoundaryConditions.SolarIrradiation.DiffuseIsotropic
        HDifRoo(til=Districts.BoundaryConditions.Types.Tilt.FacingUp,
                rho=rho) "Diffuse irradiation on roof"
    annotation (Placement(transformation(extent={{40,0},{60,20}})));
  Districts.BoundaryConditions.SolarIrradiation.DiffuseIsotropic
        HDifFlo(til=Districts.BoundaryConditions.Types.Tilt.FacingDown,
                rho=rho) "Diffuse irradiation on floor"
    annotation (Placement(transformation(extent={{40,-80},{60,-60}})));
  Districts.BoundaryConditions.SolarIrradiation.DiffuseIsotropic
        HDifWal(
        til=Districts.BoundaryConditions.Types.Tilt.Wall,
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
    Diagram(graphics),
    __Dymola_Commands(file="modelica://Districts/Resources/Scripts/Dymola/BoundaryConditions/SolarIrradiation/Examples/DiffuseIsotropic.mos"
        "Simulate and plot"),
    Icon(graphics));
end DiffuseIsotropic;
