within Districts.BuildingLoads.Examples;
model LinearRegression "Example model for the linear regression building load"
  import Districts;
  extends Modelica.Icons.Example;
  Districts.BuildingLoads.LinearRegression bui1(fileName="Resources/Data/BuildingLoads/Examples/smallOffice_1.txt")
    "Building 1"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Districts.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        "Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos")
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Districts.Electrical.AC.AC3ph.Sources.Grid gri(
    f=60,
    V=480,
    Phi=0) annotation (Placement(transformation(extent={{60,60},{80,80}})));
  Districts.Electrical.AC.AC3ph.Lines.Line lin(
    Length=50,
    V_nominal=480,
    cable=Districts.Electrical.Transmission.Cables.mmq_4_0(),
    wireMaterial=Districts.Electrical.Transmission.Materials.Copper(),
    P_nominal=2e5) "Transmission line"
    annotation (Placement(transformation(extent={{40,40},{20,60}})));
equation
  connect(weaDat.weaBus, bui1.weaBus)             annotation (Line(
      points={{-40,50},{-20,50}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(bui1.terminal, lin.terminal_p) annotation (Line(
      points={{0.4,50},{20,50}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(lin.terminal_n, gri.terminal) annotation (Line(
      points={{40,50},{70,50},{70,60}},
      color={0,120,120},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{140,100}}), graphics), Icon(coordinateSystem(extent={{-100,
            -100},{140,100}})),
    experiment(StopTime=86400, Tolerance=1e-05),
    __Dymola_experimentSetupOutput);
end LinearRegression;
