within Buildings.Applications.DHC.Examples.FifthGeneration.UnidirectionalSeries.Validation;
model BuildingETSConnection
  "Validation of building and ETS connection"
  extends Modelica.Icons.Example;
    package Medium1 = Buildings.Media.Water
    "Source side medium";
  Buildings.Fluid.Sources.Boundary_pT sin(redeclare package Medium = Medium1,
      nPorts=1) "Sink for district water" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={110,-60})));
  Agents.EnergyTransferStation ets(
    redeclare package Medium = Medium1,
    QCoo_flow_nominal=sum(bui.terUni.QCoo_flow_nominal),
    QHea_flow_nominal=sum(bui.terUni.QHea_flow_nominal))
    "Energy transfer station"
    annotation (Placement(transformation(extent={{0,-80},{40,-40}})));
  Loads.Examples.BaseClasses.GeojsonSpawn1Z6BuildingPump bui(redeclare package
      Medium1 = Medium1, nPorts1=2) "Building"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetHeaWatSup(k=ets.THeaWatSup_nominal)
    "Heating water supply temperature set point"
    annotation (Placement(transformation(extent={{-160,-10},{-140,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetChiWatSup(k=ets.TChiWatSup_nominal)
    "Chilled water supply temperature set point"
    annotation (Placement(transformation(extent={{-160,-50},{-140,-30}})));
  inner parameter Data.DesignDataDHC datDes(
    nBui=1,
    mDis_flow_nominal=25,
    mCon_flow_nominal={25},
    epsPla=0.935) "Design values"
    annotation (Placement(transformation(extent={{-160,64},{-140,84}})));
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
equation
  connect(TSetHeaWatSup.y, ets.TSetHeaWat) annotation (Line(points={{-138,0},{
          -40,0},{-40,-42.8571},{-1.42857,-42.8571}}, color={0,0,127}));
  connect(TSetChiWatSup.y, ets.TSetChiWat) annotation (Line(points={{-138,-40},
          {-46,-40},{-46,-48.5714},{-1.42857,-48.5714}}, color={0,0,127}));
  connect(ets.port_b, sin.ports[1])
    annotation (Line(points={{39.8571,-60},{100,-60}}, color={0,127,255}));
  connect(ets.port_bHeaWat, bui.ports_a1[1]) annotation (Line(points={{40,
          -68.5714},{50,-68.5714},{50,-20},{-32,-20},{-32,10},{-20,10}}, color=
          {0,127,255}));
  connect(bui.ports_b1[1], ets.port_aHeaWat) annotation (Line(points={{40,10},{
          60,10},{60,-100},{-20,-100},{-20,-68.5714},{0,-68.5714}}, color={0,
          127,255}));
  connect(ets.port_bChi, bui.ports_a1[2]) annotation (Line(points={{40,-77.2857},
          {40,-78},{54,-78},{54,-16},{-36,-16},{-36,14},{-20,14}}, color={0,127,
          255}));
  connect(bui.ports_b1[2], ets.port_aChi) annotation (Line(points={{40,14},{64,
          14},{64,-104},{-16,-104},{-16,-77.1429},{0,-77.1429}}, color={0,127,
          255}));
  connect(sou.ports[1], ets.port_a)
    annotation (Line(points={{-60,-60},{0,-60}}, color={0,127,255}));
  connect(TDis.y, sou.T_in) annotation (Line(points={{-138,-80},{-100,-80},{
          -100,-56},{-82,-56}},
                           color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-180,-120},{160,
            120}}),
    graphics={Text(
          extent={{-68,74},{64,100}},
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
