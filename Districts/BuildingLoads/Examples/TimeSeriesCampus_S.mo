within Districts.BuildingLoads.Examples;
model TimeSeriesCampus_S
  "Example model for the time series building load as part of a campus"
  import Districts;
  extends Modelica.Icons.Example;
  extends Districts.BuildingLoads.Examples.BaseClasses.PartialTimeSeriesCampus(
  PDCGen=500e3,
  redeclare model line=Districts.BuildingLoads.Examples.BaseClasses.DummyLine,
    bat(EMax=PDCGen*20*3600));

  Districts.BuildingLoads.Examples.BaseClasses.BatteryControl_S conBat(PMax=2*
        PDCGen) "Battery control"
    annotation (Placement(transformation(extent={{420,-120},{440,-100}})));
equation
  connect(conBat.S, senDT.S[1]) annotation (Line(
      points={{418,-116},{-50,-116},{-50,-29}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(bat.SOC, conBat.SOC) annotation (Line(
      points={{439,-14},{450,-14},{450,-78},{410,-78},{410,-104},{418,-104}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conBat.P, bat.P) annotation (Line(
      points={{441,-110},{454,-110},{454,0},{428,0},{428,-10}},
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
          "Resources/Scripts/Dymola/BuildingLoads/Examples/TimeSeriesCampus_S.mos"
        "Simulate and plot"));
end TimeSeriesCampus_S;
