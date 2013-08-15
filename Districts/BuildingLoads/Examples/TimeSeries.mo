within Districts.BuildingLoads.Examples;
model TimeSeries "Example model for the time series building load"
  import Districts;
  extends Modelica.Icons.Example;
  Districts.BuildingLoads.TimeSeries buiA(fileName="Resources/Data/BuildingLoads/Examples/buildingA.txt")
    "Building A"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Districts.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        "Resources/weatherdata/CZ10RV2.mos")
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Districts.Electrical.AC.AC3ph.Sources.Grid gri(
    f=60,
    V=480,
    Phi=0) annotation (Placement(transformation(extent={{78,60},{98,80}})));
  Districts.Electrical.AC.AC3ph.Lines.Line lin(
    l=50,
    V_nominal=480,
    cable=Districts.Electrical.Transmission.Cables.mmq_4_0(),
    wireMaterial=Districts.Electrical.Transmission.Materials.Copper(),
    P_nominal=2e5) "Transmission line"
    annotation (Placement(transformation(extent={{80,40},{60,60}})));
  Districts.Electrical.DC.Sources.ConstantVoltage souDC(V=240) "DC source"
    annotation (Placement(transformation(extent={{100,10},{80,30}})));
  Modelica.Electrical.Analog.Basic.Ground ground
    annotation (Placement(transformation(extent={{100,-20},{120,0}})));
  Districts.Electrical.AC.AC3ph.Sensors.GeneralizedSensor senAC
    "Sensor for AC line"
    annotation (Placement(transformation(extent={{20,40},{40,60}})));
  Districts.Electrical.DC.Sensors.GeneralizedSensor senDC "Sensor for DC line"
    annotation (Placement(transformation(extent={{20,10},{40,30}})));
equation
  connect(weaDat.weaBus,buiA. weaBus)             annotation (Line(
      points={{-40,50},{-20,50}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(lin.terminal_n, gri.terminal) annotation (Line(
      points={{80,50},{88,50},{88,60}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(ground.p, souDC.n) annotation (Line(
      points={{110,0},{110,20},{100,20}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(lin.terminal_p, senAC.terminal_p) annotation (Line(
      points={{60,50},{40,50}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(senAC.terminal_n,buiA. terminal) annotation (Line(
      points={{20,50},{0.4,50}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(buiA.terminal_dc, senDC.terminal_n) annotation (Line(
      points={{4.44089e-16,44},{12,44},{12,20},{20,20}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(senDC.terminal_p, souDC.terminal) annotation (Line(
      points={{40,20},{80,20}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{140,100}}), graphics),
    experiment(StopTime=86400, Tolerance=1e-05),
    __Dymola_experimentSetupOutput,
    Commands(file=
          "Resources/Scripts/Dymola/BuildingLoads/Examples/TimeSeries.mos"
        "Simulate and plot"));
end TimeSeries;
