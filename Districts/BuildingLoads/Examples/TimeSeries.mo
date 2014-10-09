within Districts.BuildingLoads.Examples;
model TimeSeries "Example model for the time series building load"
  import Districts;
  extends Modelica.Icons.Example;
  Districts.BuildingLoads.TimeSeries buiA(fileName="modelica://Districts/Resources/Data/BuildingLoads/Examples/buildingA.txt",
    V_nominal_AC=480,
    V_nominal_DC=240) "Building A"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Districts.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        "modelica://Districts/Resources/weatherdata/CZ10RV2.mos")
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Districts.Electrical.AC.ThreePhasesBalanced.Sources.Grid
                                             gri(
    f=60,
    V=480,
    Phi=0) annotation (Placement(transformation(extent={{110,60},{130,80}})));
  Districts.Electrical.AC.ThreePhasesBalanced.Lines.Line
                                           lin(
    l=50,
    V_nominal=480,
    P_nominal=2e7,
    mode=Districts.Electrical.Types.CableMode.commercial,
    commercialCable=Districts.Electrical.Transmission.CommercialCables.Cu50())
    "Transmission line"
    annotation (Placement(transformation(extent={{70,40},{50,60}})));
  Districts.Electrical.AC.ThreePhasesBalanced.Sensors.GeneralizedSensor
                                                          senAC
    "Sensor for AC line"
    annotation (Placement(transformation(extent={{20,40},{40,60}})));
  Districts.Electrical.DC.Sensors.GeneralizedSensor senDC "Sensor for DC line"
    annotation (Placement(transformation(extent={{20,10},{40,30}})));
  Districts.Electrical.AC.ThreePhasesBalanced.Conversion.ACDCConverter
                                                         acdc(
                  eta=0.9, conversionFactor=240/480) "AC/DC converter"
    annotation (Placement(transformation(extent={{80,10},{60,30}})));
  Districts.Electrical.AC.ThreePhasesBalanced.Lines.Line
                                           linGri(
    l=50,
    V_nominal=480,
    P_nominal=2*2e7,
    mode=Districts.Electrical.Types.CableMode.commercial,
    commercialCable=Districts.Electrical.Transmission.CommercialCables.Cu50())
    "Transmission line"
    annotation (Placement(transformation(extent={{110,40},{90,60}})));
equation
  connect(weaDat.weaBus,buiA. weaBus)             annotation (Line(
      points={{-40,50},{-20,50}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(buiA.terminal_dc, senDC.terminal_n) annotation (Line(
      points={{4.44089e-16,44},{12,44},{12,20},{20,20}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(buiA.terminal, senAC.terminal_n) annotation (Line(
      points={{0.4,50},{20,50}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(senAC.terminal_p, lin.terminal_p) annotation (Line(
      points={{40,50},{50,50}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(senDC.terminal_p, acdc.terminal_p) annotation (Line(
      points={{40,20},{60,20}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(lin.terminal_n, linGri.terminal_p) annotation (Line(
      points={{70,50},{90,50}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(acdc.terminal_n, linGri.terminal_p) annotation (Line(
      points={{80,20},{84,20},{84,50},{90,50}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(linGri.terminal_n, gri.terminal) annotation (Line(
      points={{110,50},{120,50},{120,60}},
      color={0,120,120},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{140,100}}), graphics),
    experiment(StopTime=86400, Tolerance=1e-05),
    __Dymola_experimentSetupOutput,
    Commands(file=
          "modelica://Districts/Resources/Scripts/Dymola/BuildingLoads/Examples/TimeSeries.mos"
        "Simulate and plot"));
end TimeSeries;
