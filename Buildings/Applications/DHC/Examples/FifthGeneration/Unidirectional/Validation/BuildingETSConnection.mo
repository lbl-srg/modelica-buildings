within Buildings.Applications.DHC.Examples.FifthGeneration.Unidirectional.Validation;
model BuildingETSConnection
  "Validation of building and ETS connection"
  extends Modelica.Icons.Example;
    package Medium1 = Buildings.Media.Water
    "Source side medium";
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium=Medium1,
    nPorts=1)
    "Sink for district water"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={130,-40})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetHeaWatSup(
    k=bui.ets.THeaWatSup_nominal)
    "Heating water supply temperature set point"
    annotation (Placement(transformation(extent={{-140,10},{-120,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetChiWatSup(
    k=bui.ets.TChiWatSup_nominal)
    "Chilled water supply temperature set point"
    annotation (Placement(transformation(extent={{-140,-30},{-120,-10}})));
  Fluid.Sources.Boundary_pT sou(
    redeclare package Medium=Medium1,
    use_T_in=true,
    nPorts=1) "Source for district water"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,-40})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TDis(k=273.15 + 15)
    "District water temperature"
    annotation (Placement(transformation(extent={{-140,-70},{-120,-50}})));
  Agents.SpawnBuildingWithETS bui(redeclare package Medium = Medium1)
    "Model of a building with an energy transfer station"
    annotation (Placement(transformation(extent={{20,-50},{40,-30}})));
  inner parameter Data.DesignDataDHC datDes(
    nBui=1,
    mDis_flow_nominal=25,
    mCon_flow_nominal={25},
    epsPla=0.935)
    "Design values"
    annotation (Placement(transformation(extent={{-160,66},{-140,86}})));
equation
  connect(TDis.y, sou.T_in) annotation (Line(points={{-118,-60},{-80,-60},{-80,
          -36},{-62,-36}}, color={0,0,127}));
  connect(sou.ports[1], bui.port_a)
    annotation (Line(points={{-40,-40},{20,-40}},color={0,127,255}));
  connect(bui.port_b, sin.ports[1])
    annotation (Line(points={{40,-40},{120,-40}}, color={0,127,255}));
  connect(TSetHeaWatSup.y, bui.TSetHeaWat) annotation (Line(points={{-118,20},{
          0,20},{0,-32},{19,-32}},      color={0,0,127}));
  connect(TSetChiWatSup.y, bui.TSetChiWat) annotation (Line(points={{-118,-20},
          {-20,-20},{-20,-36},{19,-36}},color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-180,-120},{
            180,120}}),
    graphics={Text(
          extent={{-68,100},{64,74}},
          lineColor={28,108,200},
          textString="Simulation requires
Hidden.AvoidDoubleComputation=true")}),
   experiment(
      StopTime=172800,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
    __Dymola_Commands(file="Resources/Scripts/Dymola/Applications/DHC/Examples/FifthGenUniSeries/Validation/BuildingETSConnection.mos"
        "Simulate and plot"));
end BuildingETSConnection;
