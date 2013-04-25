within Districts.BuildingLoads.Examples;
model LinearRegression "Example model for the linear regression building load"
  import Districts;
  extends Modelica.Icons.Example;
  Districts.BuildingLoads.LinearRegression bui1 "Building 1"
    annotation (Placement(transformation(extent={{-30,40},{-10,60}})));
  Districts.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        "/media/sf_proj/ldrd/bie/modeling/github/lbl-srg/modelica-buildings/Districts/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos")
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Districts.BuildingLoads.LinearRegression bui2 "Building 1"
    annotation (Placement(transformation(extent={{-30,0},{-10,20}})));
  Districts.Electrical.AC.Transmission.SinglePhaseLine singlePhaseLine
    annotation (Placement(transformation(extent={{40,40},{60,60}})));
  Districts.Electrical.AC.Interfaces.Adaptor adaptor
    annotation (Placement(transformation(extent={{8,40},{28,60}})));
  Districts.Electrical.AC.Interfaces.Adaptor adaptor1
    annotation (Placement(transformation(extent={{10,0},{30,20}})));
  Districts.Electrical.AC.Transmission.SinglePhaseLine singlePhaseLine1
    annotation (Placement(transformation(extent={{40,26},{60,46}})));
  Districts.Electrical.AC.Transmission.SinglePhaseLine singlePhaseLine2
    annotation (Placement(transformation(extent={{40,54},{60,74}})));
  Districts.Electrical.AC.Transmission.SinglePhaseLine singlePhaseLine3
    annotation (Placement(transformation(extent={{40,0},{60,20}})));
  Districts.Electrical.AC.Transmission.SinglePhaseLine singlePhaseLine4
    annotation (Placement(transformation(extent={{40,-14},{60,6}})));
  Districts.Electrical.AC.Transmission.SinglePhaseLine singlePhaseLine5
    annotation (Placement(transformation(extent={{40,14},{60,34}})));
  Districts.Electrical.AC.Transmission.SinglePhaseLine singlePhaseLine6
    annotation (Placement(transformation(extent={{80,22},{100,42}})));
  Districts.Electrical.AC.Transmission.SinglePhaseLine singlePhaseLine7
    annotation (Placement(transformation(extent={{80,8},{100,28}})));
  Districts.Electrical.AC.Transmission.SinglePhaseLine singlePhaseLine8
    annotation (Placement(transformation(extent={{80,36},{100,56}})));
  Districts.Electrical.AC.Sources.Grid gri
    annotation (Placement(transformation(extent={{108,60},{128,80}})));
equation
  connect(weaDat.weaBus, bui1.weaBus)             annotation (Line(
      points={{-60,50},{-30,50}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(weaDat.weaBus, bui2.weaBus) annotation (Line(
      points={{-60,50},{-50,50},{-50,10},{-30,10}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(bui1.threePhasePlug, adaptor.threePhasePlug) annotation (Line(
      points={{-10,50},{10,50}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(bui2.threePhasePlug, adaptor1.threePhasePlug) annotation (Line(
      points={{-10,10},{12,10}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(adaptor.phase1, singlePhaseLine2.A) annotation (Line(
      points={{28,56},{34,56},{34,64},{40,64}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(adaptor.phase2, singlePhaseLine.A) annotation (Line(
      points={{28,50},{40,50}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(adaptor.phase3, singlePhaseLine1.A) annotation (Line(
      points={{28,44},{34,44},{34,36},{40,36}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(singlePhaseLine8.A, singlePhaseLine2.B) annotation (Line(
      points={{80,46},{72,46},{72,64},{60,64}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(singlePhaseLine.B, singlePhaseLine6.A) annotation (Line(
      points={{60,50},{70,50},{70,32},{80,32}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(singlePhaseLine1.B, singlePhaseLine7.A) annotation (Line(
      points={{60,36},{74,36},{74,18},{80,18}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(singlePhaseLine5.B, singlePhaseLine2.B) annotation (Line(
      points={{60,24},{72,24},{72,64},{60,64}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(singlePhaseLine3.B, singlePhaseLine6.A) annotation (Line(
      points={{60,10},{70,10},{70,32},{80,32}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(singlePhaseLine4.B, singlePhaseLine7.A) annotation (Line(
      points={{60,-4},{74,-4},{74,18},{80,18}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(singlePhaseLine5.A, adaptor1.phase1) annotation (Line(
      points={{40,24},{36,24},{36,16},{30,16}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(adaptor1.phase2, singlePhaseLine3.A) annotation (Line(
      points={{30,10},{40,10}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(singlePhaseLine4.A, adaptor1.phase3) annotation (Line(
      points={{40,-4},{36,-4},{36,4},{30,4}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(singlePhaseLine8.B, gri.sPhasePlug) annotation (Line(
      points={{100,46},{110,46},{110,46},{118,46},{118,60},{117.9,60}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(singlePhaseLine6.B, gri.sPhasePlug) annotation (Line(
      points={{100,32},{117.9,32},{117.9,60}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(singlePhaseLine7.B, gri.sPhasePlug) annotation (Line(
      points={{100,18},{117.9,18},{117.9,60}},
      color={0,0,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{140,100}}), graphics), Icon(coordinateSystem(extent={{-100,
            -100},{140,100}})));
end LinearRegression;
