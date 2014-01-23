within Districts.BuildingLoads.Examples;
model TimeSeriesCampus_V
  "Example model for the time series building load as part of a campus"
  import Districts;
  extends Modelica.Icons.Example;
  extends Districts.BuildingLoads.Examples.BaseClasses.PartialTimeSeriesCampus;

  Districts.BuildingLoads.Examples.BaseClasses.BatteryControl_V conBat(
    VDis=VDCDis_nominal,
    PMax=200e3) "Battery controller"
    annotation (Placement(transformation(extent={{420,6},{440,26}})));
equation
  connect(bat.SOC,conBat. SOC) annotation (Line(
      points={{439,-14},{454,-14},{454,40},{412,40},{412,22},{418,22}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(senA.V,conBat. VMea) annotation (Line(
      points={{339,10},{418,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conBat.P, bat.P) annotation (Line(
      points={{441,16},{444,16},{444,0},{428,0},{428,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-240,
            -140},{460,220}}), graphics),
    experiment(
      StartTime=345600,
      StopTime=950400,
      Tolerance=1e-06,
      __Dymola_Algorithm="Radau"),
      Commands(file=
          "modelica://Districts/Resources/Scripts/Dymola/BuildingLoads/Examples/TimeSeriesCampus_V.mos"
        "Simulate and plot"));
end TimeSeriesCampus_V;
