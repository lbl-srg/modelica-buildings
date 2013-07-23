within Districts.BuildingLoads.Examples;
model LinearRegressionCampus
  "Example model for the linear regression building load as part of a campus"
  import Districts;
  extends Modelica.Icons.Example;
  parameter Modelica.SIunits.Voltage VTra = 50e3 "Voltage of transmission grid";
  parameter Modelica.SIunits.Voltage VDis = 480
    "Voltage of the distribution grid";

  // Rated power that is used to size cables
  parameter Modelica.SIunits.Power P_a = 1e5 "Rated power for sizing";
  parameter Modelica.SIunits.Power P_b = 1e5 "Rated power for sizing";
  parameter Modelica.SIunits.Power P_c = 1e5 "Rated power for sizing";
  parameter Modelica.SIunits.Power P_d = 1e5 "Rated power for sizing";
  parameter Modelica.SIunits.Power P_e = 1e5 "Rated power for sizing";
  parameter Modelica.SIunits.Power P_bc = P_a  + P_b "Rated power for sizing";
  parameter Modelica.SIunits.Power P_ce = P_bc + P_c "Rated power for sizing";
  parameter Modelica.SIunits.Power P_de = P_ce + P_e "Rated power for sizing";
  parameter Modelica.SIunits.Power P_dt = P_de + P_d "Rated power for sizing";
  // Declaration of the line model
  // Set it either to DummyLine or to Districts.Electrical.AC.AC3ph.Lines.Line
  model line = DummyLine "Line model";

  Districts.BuildingLoads.LinearRegression buiA(fileName="Resources/Data/BuildingLoads/Examples/smallOffice_1.txt")
    "Building A"
    annotation (Placement(transformation(extent={{230,30},{250,50}})));
  Districts.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        "Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos")
    annotation (Placement(transformation(extent={{-220,60},{-200,80}})));
  Districts.Electrical.AC.AC3ph.Sources.Grid gri(
    f=60,
    Phi=0,
    V=VTra)
           annotation (Placement(transformation(extent={{-160,0},{-140,20}})));
  Districts.Electrical.AC.AC3ph.Conversion.ACACConverter acac(eta=0.9,
      conversionFactor=VTra/VDis) "AC/AC converter"
    annotation (Placement(transformation(extent={{-120,-30},{-100,-10}})));
  line dt(
    P_nominal=P_dt,
    V_nominal=VDis,
    l=40,
    cable=Districts.Electrical.Transmission.Cables.mmq_4_0(),
    wireMaterial=Districts.Electrical.Transmission.Materials.Copper())
    "Distribution line"
    annotation (Placement(transformation(extent={{-22,-30},{-2,-10}})));
  line de(
    V_nominal=VDis,
    P_nominal=P_de,
    l=400,
    cable=Districts.Electrical.Transmission.Cables.mmq_4_0(),
    wireMaterial=Districts.Electrical.Transmission.Materials.Copper())
    "Distribution line"
    annotation (Placement(transformation(extent={{40,-30},{60,-10}})));
  line d(
    V_nominal=VDis,
    P_nominal=P_d,
    l=20,
    cable=Districts.Electrical.Transmission.Cables.mmq_4_0(),
    wireMaterial=Districts.Electrical.Transmission.Materials.Copper())
    "Distribution line"       annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={20,-50})));
  line e(
    V_nominal=VDis,
    P_nominal=P_e,
    l=20,
    cable=Districts.Electrical.Transmission.Cables.mmq_4_0(),
    wireMaterial=Districts.Electrical.Transmission.Materials.Copper())
    "Distribution line"       annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={80,-50})));
  line ce(
    V_nominal=VDis,
    P_nominal=P_ce,
    l=50,
    cable=Districts.Electrical.Transmission.Cables.mmq_4_0(),
    wireMaterial=Districts.Electrical.Transmission.Materials.Copper())
    "Distribution line"
    annotation (Placement(transformation(extent={{100,-30},{120,-10}})));
  line c(
    V_nominal=VDis,
    P_nominal=P_c,
    l=60,
    cable=Districts.Electrical.Transmission.Cables.mmq_4_0(),
    wireMaterial=Districts.Electrical.Transmission.Materials.Copper())
    "Distribution line"       annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={140,10})));
  line bc(
    V_nominal=VDis,
    P_nominal=P_bc,
    l=40,
    cable=Districts.Electrical.Transmission.Cables.mmq_4_0(),
    wireMaterial=Districts.Electrical.Transmission.Materials.Copper())
    "Distribution line"
    annotation (Placement(transformation(extent={{160,-30},{180,-10}})));
  line b(
    V_nominal=VDis,
    P_nominal=P_b,
    l=20,
    cable=Districts.Electrical.Transmission.Cables.mmq_4_0(),
    wireMaterial=Districts.Electrical.Transmission.Materials.Copper())
    "Distribution line"       annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={200,10})));
  line a(
    V_nominal=VDis,
    P_nominal=P_a,
    l=120,
    cable=Districts.Electrical.Transmission.Cables.mmq_4_0(),
    wireMaterial=Districts.Electrical.Transmission.Materials.Copper())
    "Distribution line"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={280,10})));
  Districts.BuildingLoads.LinearRegression buiB(fileName="Resources/Data/BuildingLoads/Examples/smallOffice_1.txt")
    "Building B"
    annotation (Placement(transformation(extent={{170,30},{190,50}})));
  Districts.BuildingLoads.LinearRegression buiC(fileName="Resources/Data/BuildingLoads/Examples/smallOffice_1.txt")
    "Building C"
    annotation (Placement(transformation(extent={{108,30},{128,50}})));
  Districts.BuildingLoads.LinearRegression buiD(fileName="Resources/Data/BuildingLoads/Examples/smallOffice_1.txt")
    "Building D"
    annotation (Placement(transformation(extent={{-10,-90},{10,-70}})));
  Districts.BuildingLoads.LinearRegression buiE(fileName="Resources/Data/BuildingLoads/Examples/smallOffice_1.txt")
    "Building E"
    annotation (Placement(transformation(extent={{50,-90},{70,-70}})));

model DummyLine
  extends Districts.Electrical.Interfaces.PartialTwoPort(
      redeclare package PhaseSystem_p =
        Districts.Electrical.PhaseSystems.ThreePhase_dq,
      redeclare package PhaseSystem_n =
        Districts.Electrical.PhaseSystems.ThreePhase_dq,
      redeclare Districts.Electrical.AC.AC3ph.Interfaces.Terminal_n terminal_n,
      redeclare Districts.Electrical.AC.AC3ph.Interfaces.Terminal_n terminal_p);

  parameter Modelica.SIunits.Distance l(min=0) "Length of the line";
  parameter Modelica.SIunits.Power P_nominal(min=0) "Nominal power of the line";
  parameter Modelica.SIunits.Voltage V_nominal "Nominal voltage of the line";
  parameter Districts.Electrical.Transmission.Cables.Cable cable=
      Functions.selectCable(P_nominal, V_nominal) "Type of cable"
  annotation (choicesAllMatching=true,Dialog(tab="Tech. specification"), Placement(transformation(extent={{20,60},
              {40,80}})));
  parameter Districts.Electrical.Transmission.Materials.Material wireMaterial=
      Functions.selectMaterial(0.0) "Material of the cable"
    annotation (choicesAllMatching=true,Dialog(tab="Tech. specification"), Placement(transformation(extent={{60,60},
              {80,80}})));
equation

  connect(terminal_n, terminal_p) annotation (Line(
      points={{-100,2.22045e-16},{-4,2.22045e-16},{-4,0},{100,0}},
      color={0,120,120},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(coordinateSystem(
            preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
          graphics={
          Rectangle(extent={{-80,12},{80,-12}}, lineColor={0,0,0}),
          Line(
            points={{-80,0},{-100,0}},
            color={0,0,0},
            smooth=Smooth.None),
          Line(
            points={{80,0},{100,0}},
            color={0,0,0},
            smooth=Smooth.None)}));
end DummyLine;
  Districts.Electrical.AC.AC3ph.Sensors.Power senPow
    "Power after the transformer"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
equation
  connect(weaDat.weaBus,buiA. weaBus)             annotation (Line(
      points={{-200,70},{220,70},{220,40},{230,40}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(gri.terminal, acac.terminal_n)          annotation (Line(
      points={{-150,-4.44089e-16},{-150,-20},{-120,-20}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(dt.terminal_p, de.terminal_n) annotation (Line(
      points={{-2,-20},{40,-20}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(dt.terminal_p, d.terminal_p) annotation (Line(
      points={{-2,-20},{20,-20},{20,-40}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(de.terminal_p, ce.terminal_n) annotation (Line(
      points={{60,-20},{100,-20}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(e.terminal_p, de.terminal_p) annotation (Line(
      points={{80,-40},{80,-20},{60,-20}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(ce.terminal_p, bc.terminal_n) annotation (Line(
      points={{120,-20},{160,-20}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(c.terminal_n, ce.terminal_p) annotation (Line(
      points={{140,0},{140,-20},{120,-20}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(bc.terminal_p, a.terminal_n) annotation (Line(
      points={{180,-20},{280,-20},{280,-4.44089e-16}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(b.terminal_n, bc.terminal_p) annotation (Line(
      points={{200,-4.44089e-16},{200,-20},{180,-20}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(a.terminal_p, buiA.terminal) annotation (Line(
      points={{280,20},{280,40},{250.4,40}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(b.terminal_p, buiB.terminal) annotation (Line(
      points={{200,20},{200,40},{190.4,40}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(c.terminal_p, buiC.terminal) annotation (Line(
      points={{140,20},{140,40},{128.4,40}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(buiE.terminal, e.terminal_n) annotation (Line(
      points={{70.4,-80},{80,-80},{80,-60}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(buiD.terminal, d.terminal_n) annotation (Line(
      points={{10.4,-80},{20,-80},{20,-60}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(weaDat.weaBus, buiB.weaBus) annotation (Line(
      points={{-200,70},{160,70},{160,40},{170,40}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(weaDat.weaBus, buiC.weaBus) annotation (Line(
      points={{-200,70},{100,70},{100,40},{108,40}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(weaDat.weaBus, buiE.weaBus) annotation (Line(
      points={{-200,70},{-180,70},{-180,-100},{40,-100},{40,-80},{50,-80}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(weaDat.weaBus, buiD.weaBus) annotation (Line(
      points={{-200,70},{-180,70},{-180,-100},{-20,-100},{-20,-80},{-10,-80}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(acac.terminal_p, senPow.terminal_n) annotation (Line(
      points={{-100,-20},{-80,-20}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(senPow.terminal_p, dt.terminal_n) annotation (Line(
      points={{-60,-20},{-22,-20}},
      color={0,120,120},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-240,
            -120},{300,100}}), graphics),
    experiment(StopTime=86400, Tolerance=1e-05));
end LinearRegressionCampus;
