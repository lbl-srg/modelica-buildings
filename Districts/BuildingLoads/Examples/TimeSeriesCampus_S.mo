within Districts.BuildingLoads.Examples;
model TimeSeriesCampus_S
  "Example model for the time series building load as part of a campus"
  import Districts;
  extends Modelica.Icons.Example;
  extends Districts.BuildingLoads.Examples.BaseClasses.PartialTimeSeriesCampus;

  Districts.BuildingLoads.Examples.BaseClasses.BatteryControl_S conBat(PMax=PBat)
    "Battery control"
    annotation (Placement(transformation(extent={{422,-120},{442,-100}})));
equation
  connect(bat.SOC, conBat.SOC) annotation (Line(
      points={{439,-14},{450,-14},{450,-78},{410,-78},{410,-104},{420,-104}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conBat.P, bat.P) annotation (Line(
      points={{443,-110},{454,-110},{454,0},{428,0},{428,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-240,
            -160},{460,220}}), graphics),
    experiment(
      StartTime=345600,
      StopTime=950400,
      Tolerance=1e-06,
      __Dymola_Algorithm="Radau"),
      Commands(file=
          "modelica://Districts/Resources/Scripts/Dymola/BuildingLoads/Examples/TimeSeriesCampus_S.mos"
        "Simulate and plot"));
end TimeSeriesCampus_S;
