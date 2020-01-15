within Buildings.Applications.DHC.Examples.FifthGeneration.UnidirectionalSeries.Validation;
model BuildingETSConnection1
  "Validation of building and ETS connection"
  extends Modelica.Icons.Example;
    package Medium1 = Buildings.Media.Water
    "Source side medium";
  Buildings.Fluid.Sources.Boundary_pT sin(redeclare package Medium = Medium1,
      nPorts=1) "Sink for district water" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={110,-60})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetHeaWatSup(k=bui.ets.THeaWatSup_nominal)
    "Heating water supply temperature set point"
    annotation (Placement(transformation(extent={{-160,-10},{-140,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetChiWatSup(k=bui.ets.TChiWatSup_nominal)
    "Chilled water supply temperature set point"
    annotation (Placement(transformation(extent={{-160,-50},{-140,-30}})));
  Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium1,
    use_T_in=true,
    nPorts=1) "Source for district water" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,-60})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TDis(k=273.15 + 15)
    "District water temperature"
    annotation (Placement(transformation(extent={{-160,-90},{-140,-70}})));
  Agents.BuildingWithETS bui(redeclare package Medium = Medium1)
    "Model of a building with an energy transfer station"
    annotation (Placement(transformation(extent={{0,-70},{20,-50}})));
  inner parameter Data.DesignDataDHC datDes(
    nBui=1,
    mDis_flow_nominal=25,
    mCon_flow_nominal={25},
    epsPla=0.935) "Design values"
    annotation (Placement(transformation(extent={{-160,66},{-140,86}})));
equation
  connect(TDis.y, sou.T_in) annotation (Line(points={{-138,-80},{-100,-80},{
          -100,-56},{-82,-56}},
                           color={0,0,127}));
  connect(sou.ports[1], bui.port_a)
    annotation (Line(points={{-60,-60},{0,-60}}, color={0,127,255}));
  connect(bui.port_b, sin.ports[1])
    annotation (Line(points={{20,-60},{100,-60}}, color={0,127,255}));
  connect(TSetHeaWatSup.y, bui.TSetHeaWat) annotation (Line(points={{-138,0},{
          -20,0},{-20,-52},{-1,-52}},   color={0,0,127}));
  connect(TSetChiWatSup.y, bui.TSetChiWat) annotation (Line(points={{-138,-40},{
          -40,-40},{-40,-56},{-1,-56}}, color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-180,-120},{160,
            120}}),
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
end BuildingETSConnection1;
