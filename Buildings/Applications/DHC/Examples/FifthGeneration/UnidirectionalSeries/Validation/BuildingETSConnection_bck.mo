within Buildings.Applications.DHC.Examples.FifthGeneration.UnidirectionalSeries.Validation;
model BuildingETSConnection_bck "Validation of building and ETS connection"
  extends Modelica.Icons.Example;
    package Medium1 = Buildings.Media.Water
    "Source side medium";
  Buildings.Fluid.Sources.Boundary_pT sin(redeclare package Medium = Medium1,
      nPorts=1) "Sink for district water" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={132,-60})));
  Agents.EnergyTransferStation_bck
                               ets(
    redeclare package Medium = Medium1,
    QCoo_flow_nominal=sum(bui.terUni.QCoo_flow_nominal),
    QHea_flow_nominal=sum(bui.terUni.QHea_flow_nominal))
    "Energy transfer station"
    annotation (Placement(transformation(extent={{20,-80},{60,-40}})));
  Loads.Examples.BaseClasses.GeojsonSpawn1Z6BuildingPump bui(redeclare package
      Medium1 = Medium1, nPorts1=2) "Building"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetHeaWatSup(k=ets.THeaWatSup_nominal)
    "Heating water supply temperature set point"
    annotation (Placement(transformation(extent={{-140,-10},{-120,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetChiWatSup(k=ets.TChiWatSup_nominal)
    "Chilled water supply temperature set point"
    annotation (Placement(transformation(extent={{-140,-50},{-120,-30}})));
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
        origin={-50,-60})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TDis(k=273.15 + 15)
    "District water temperature"
    annotation (Placement(transformation(extent={{-140,-90},{-120,-70}})));
equation
  connect(TSetHeaWatSup.y, ets.TSetHeaWat) annotation (Line(points={{-118,0},{
          -20,0},{-20,-42.8571},{18.5714,-42.8571}},  color={0,0,127}));
  connect(TSetChiWatSup.y, ets.TSetChiWat) annotation (Line(points={{-118,-40},
          {-26,-40},{-26,-48.5714},{18.5714,-48.5714}},  color={0,0,127}));
  connect(ets.port_b, sin.ports[1])
    annotation (Line(points={{59.8571,-60},{122,-60}}, color={0,127,255}));
  connect(sou.ports[1], ets.port_a)
    annotation (Line(points={{-40,-60},{20,-60}},color={0,127,255}));
  connect(TDis.y, sou.T_in) annotation (Line(points={{-118,-80},{-80,-80},{-80,
          -56},{-62,-56}}, color={0,0,127}));
  connect(bui.ports_b1[1], ets.port_aHeaWat) annotation (Line(points={{60,10},{
          78,10},{78,-34},{0,-34},{0,-68.5714},{20,-68.5714}}, color={0,127,255}));
  connect(ets.port_bHeaWat, bui.ports_a1[1]) annotation (Line(points={{60,
          -68.5714},{72,-68.5714},{72,-10},{-10,-10},{-10,10},{0,10}}, color={0,
          127,255}));
  connect(bui.ports_b1[2], ets.port_aChi) annotation (Line(points={{60,14},{72,
          14},{72,8},{94,8},{94,-100},{0,-100},{0,-77.1429},{20,-77.1429}},
        color={0,127,255}));
  connect(ets.port_bChi, bui.ports_a1[2]) annotation (Line(points={{60,-77.2857},
          {74,-77.2857},{74,-6},{0,-6},{0,14}}, color={0,127,255}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-180,-120},{
            180,120}}),
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
end BuildingETSConnection_bck;
