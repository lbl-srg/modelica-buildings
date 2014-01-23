within Districts.BoundaryConditions.WeatherData.BaseClasses.Examples;
model CheckRadiation "Test model for CheckRadiation"
  import Districts;
  extends
    Districts.BoundaryConditions.WeatherData.BaseClasses.Examples.ConvertRadiation;
  Districts.BoundaryConditions.WeatherData.BaseClasses.CheckRadiation cheGloRad
    "Check global horizontal radiation"
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
  Districts.BoundaryConditions.WeatherData.BaseClasses.CheckRadiation cheDifRad
    "Check diffuse horizontal radiation"
    annotation (Placement(transformation(extent={{60,-20},{80,0}})));
equation

  connect(conGloRad.HOut, cheGloRad.HIn) annotation (Line(
      points={{41,30},{58,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conDifRad.HOut, cheDifRad.HIn) annotation (Line(
      points={{41,-10},{58,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(graphics), __Dymola_Commands(file=
          "modelica://Districts/Resources/Scripts/Dymola/BoundaryConditions/WeatherData/BaseClasses/Examples/CheckRadiation.mos"
        "Simulate and plot"));
end CheckRadiation;
