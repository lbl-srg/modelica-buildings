within Districts.BuildingLoads.Examples;
model LinearRegression "Example model for the linear regression building load"
  import Districts;
  extends Modelica.Icons.Example;
  Districts.BuildingLoads.LinearRegression bui1 "Building 1"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Districts.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        "/media/sf_proj/ldrd/bie/modeling/github/lbl-srg/modelica-buildings/Districts/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos")
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Districts.Electrical.AC.Interfaces.Adaptor adaptor
    annotation (Placement(transformation(extent={{8,40},{28,60}})));
  Districts.Electrical.AC.Sources.Grid gri(
    f=60,
    V=480,
    phi=0)
    annotation (Placement(transformation(extent={{80,60},{100,80}})));
  Districts.Electrical.AC.Transmission.SinglePhaseLine singlePhaseLine(
    Length=50,
    P=200e3,
    V=480) annotation (Placement(transformation(extent={{40,46},{60,66}})));
  Districts.Electrical.AC.Transmission.SinglePhaseLine singlePhaseLine1(
    Length=50,
    P=200e3,
    V=480) annotation (Placement(transformation(extent={{40,40},{60,60}})));
  Districts.Electrical.AC.Transmission.SinglePhaseLine singlePhaseLine2(
    Length=50,
    P=200e3,
    V=480) annotation (Placement(transformation(extent={{40,34},{60,54}})));
equation
  connect(weaDat.weaBus, bui1.weaBus)             annotation (Line(
      points={{-40,50},{-20,50}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(bui1.threePhasePlug, adaptor.threePhasePlug) annotation (Line(
      points={{8.88178e-16,50},{10,50}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(adaptor.phase1, singlePhaseLine.A) annotation (Line(
      points={{28,56},{40,56}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(adaptor.phase2, singlePhaseLine1.A) annotation (Line(
      points={{28,50},{40,50}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(adaptor.phase3, singlePhaseLine2.A) annotation (Line(
      points={{28,44},{40,44}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(singlePhaseLine.B, gri.sPhasePlug) annotation (Line(
      points={{60,56},{89.9,56},{89.9,60}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(singlePhaseLine1.B, gri.sPhasePlug) annotation (Line(
      points={{60,50},{89.9,50},{89.9,60}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(singlePhaseLine2.B, gri.sPhasePlug) annotation (Line(
      points={{60,44},{90,44},{90,58},{89.9,60}},
      color={0,0,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{140,100}}), graphics), Icon(coordinateSystem(extent={{-100,
            -100},{140,100}})));
end LinearRegression;
