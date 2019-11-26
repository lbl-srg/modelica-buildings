within Buildings.Applications.DHC.Loads.Examples.BaseClasses;
model SpawnBuilding1ZoneRefactor
  "Spawn building model based on Urbanopt GeoJSON export"
  import Buildings;
  extends Buildings.Applications.DHC.Loads.BaseClasses.PartialBuildingRefactor(
    haveFanPum=true,
    haveEleHeaCoo=false,
    final nLoa=1);
  package Medium2 = Buildings.Media.Air
    "Load side medium";
  parameter String idfPath=
    "modelica://Buildings/Applications/DHC/Loads/Examples/BaseClasses/GeojsonExport/Resources/Data/B5a6b99ec37f4de7f94020090/RefBldgSmallOfficeNew2004_Chicago1.idf"
    "Path of the IDF file";
  parameter String weaPath=
    "modelica://Buildings/Applications/DHC/Loads/Examples/BaseClasses/GeojsonExport/Resources/Data/B5a6b99ec37f4de7f94020090/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"
    "Path of the weather file";
  Modelica.Blocks.Sources.Constant qConGai_flow(k=0) "Convective heat gain"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Modelica.Blocks.Sources.Constant qRadGai_flow(k=0) "Radiative heat gain"
    annotation (Placement(transformation(extent={{-80,100},{-60,120}})));
  Modelica.Blocks.Routing.Multiplex3 multiplex3_1
    annotation (Placement(transformation(extent={{-34,60},{-14,80}})));
  Modelica.Blocks.Sources.Constant qLatGai_flow(k=0) "Latent heat gain"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Buildings.Experimental.EnergyPlus.ThermalZone zon(
    redeclare package Medium = Medium2,
    zoneName="Core_ZN",
    nPorts=2)             "Thermal zone (core zone of the office building with 5 zones)"
    annotation (Placement(transformation(extent={{40,-20},{80,20}})));
  inner Buildings.Experimental.EnergyPlus.Building
                 building(
    idfName=Modelica.Utilities.Files.loadResource(idfPath),
    weaName=Modelica.Utilities.Files.loadResource(weaPath),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    fmuName=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/src/EnergyPlus/FMUs/Zones1.fmu"),
    showWeatherData=false)
    "Building model"
    annotation (Placement(transformation(extent={{40,60},{60,80}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minTSet(k=20) "Minimum temperature setpoint"
    annotation (Placement(transformation(extent={{-300,260},{-280,280}})));
  Buildings.Controls.OBC.UnitConversions.From_degC from_degC1
    annotation (Placement(transformation(extent={{-260,260},{-240,280}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant maxTSet(k=24) "Minimum temperature setpoint"
    annotation (Placement(transformation(extent={{-300,220},{-280,240}})));
  Buildings.Controls.OBC.UnitConversions.From_degC from_degC2
    annotation (Placement(transformation(extent={{-260,220},{-240,240}})));
  Buildings.Applications.DHC.Loads.BaseClasses.FlowDistribution couHea(
    m_flow1_nominal=terUni.m_flow1_nominal[1],
    T_a1_nominal=terUni.T_a1_nominal[1],
    T_b1_nominal=terUni.T_b1_nominal[1],
    nLoa=1)
    annotation (Placement(transformation(extent={{-120,-120},{-100,-100}})));
  Buildings.Applications.DHC.Loads.Examples.BaseClasses.SensibleTerminalUnit terUni(
    Q_flow_nominal={10000,10000},
    T_a2_nominal={293.15,297.15},
    T_b1_nominal={308.15,294.15},
    T_a1_nominal={313.15,289.15},
    m_flow2_nominal={5,5},
    dp2_nominal={100,100})
    annotation (Placement(transformation(extent={{-160,-60},{-140,-40}})));
  Buildings.Applications.DHC.Loads.BaseClasses.FlowDistribution couCoo(
    m_flow1_nominal=terUni.m_flow1_nominal[2],
    T_a1_nominal=terUni.T_a1_nominal[2],
    T_b1_nominal=terUni.T_b1_nominal[2],
    nLoa=1)
    annotation (Placement(transformation(extent={{-120,-160},{-100,-140}})));
equation
  connect(qRadGai_flow.y,multiplex3_1.u1[1])  annotation (Line(
      points={{-59,110},{-40,110},{-40,77},{-36,77}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(qConGai_flow.y,multiplex3_1.u2[1]) annotation (Line(
      points={{-59,70},{-48,70},{-42,70},{-36,70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(multiplex3_1.u3[1],qLatGai_flow.y)
    annotation (Line(points={{-36,63},{-40,63},{-40,30},{-59,30}},  color={0,0,127}));
  connect(multiplex3_1.y, zon.qGai_flow) annotation (Line(points={{-13,70},{16,70},
          {16,10},{38,10}},                                                                       color={0,0,127}));
  connect(minTSet.y,from_degC1. u) annotation (Line(points={{-278,270},{-262,270}},
                                                                                  color={0,0,127}));
  connect(maxTSet.y,from_degC2. u) annotation (Line(points={{-278,230},{-262,230}},
                                                                                  color={0,0,127}));
  connect(couHea.Q_flow1Act, Q_flow1Act[1, 1])
    annotation (Line(points={{-99,-119},{220,-119},{220,270},{320,270}}, color={0,0,127}));
  connect(ports_a1[1],couHea. port_a)
    annotation (Line(points={{-300,0},{-280,0},{-280,-110},{-120,-110}},     color={0,127,255}));
  connect(couHea.port_b, ports_b1[1])
    annotation (Line(points={{-100,-110},{280,-110},{280,0},{300,0}},     color={0,127,255}));
  connect(ports_a1[2],couCoo. port_a)
    annotation (Line(points={{-300,0},{-280,0},{-280,-150},{-120,-150}},   color={0,127,255}));
  connect(couCoo.port_b, ports_b1[2])
    annotation (Line(points={{-100,-150},{280,-150},{280,0},{300,0}},   color={0,127,255}));
  connect(terUni.m_flow1Req[1],couHea. m_flow1Req_i[1])
    annotation (Line(points={{-139,-45},{-130,-45},{-130,-115},{-121,-115}}, color={0,0,127}));
  connect(terUni.m_flow1Req[2],couCoo. m_flow1Req_i[1])
    annotation (Line(points={{-139,-45},{-130,-45},{-130,-155},{-121,-155}}, color={0,0,127}));
  connect(terUni.ports_b1[1],couHea. ports_a1[1])
    annotation (Line(points={{-140,-55.4},{-80,-55.4},{-80,-104},{-100,-104}}, color={0,127,255}));
  connect(couHea.ports_b1[1],terUni. ports_a1[1])
    annotation (Line(points={{-120,-104},{-180,-104},{-180,-55.4},{-160,-55.4}}, color={0,127,255}));
  connect(couCoo.ports_b1[1],terUni. ports_a1[2])
    annotation (Line(points={{-120,-144},{-200,-144},{-200,-55.4},{-160,-55.4}}, color={0,127,255}));
  connect(couCoo.Q_flow1Act, Q_flow1Act[2, 1])
    annotation (Line(points={{-99,-159},{240,-159},{240,270},{320,270}}, color={0,0,127}));
  connect(terUni.ports_b1[2],couCoo. ports_a1[1]) annotation (Line(points={{-140,-55.4},{-100,-55.4},{-100,-56},{-60,-56},{-60,
          -144},{-100,-144}}, color={0,127,255}));
  connect(terUni.PFanPum, PFanPum)
    annotation (Line(points={{-139,-49},{260.5,-49},{260.5,230},{320,230}}, color={0,0,127}));
  connect(zon.ports[1], terUni.port_a2) annotation (Line(points={{58,-19.2},{62,
          -19.2},{62,-42},{-140,-42}}, color={0,127,255}));
  connect(terUni.port_b2, zon.ports[2]) annotation (Line(points={{-160,-42},{-180,
          -42},{-180,-24},{62,-24},{62,-19.2}}, color={0,127,255}));
  connect(from_degC1.y, terUni.uSet[1]) annotation (Line(points={{-238,270},{-200,
          270},{-200,-47},{-161,-47}}, color={0,0,127}));
  connect(from_degC2.y, terUni.uSet[2]) annotation (Line(points={{-238,230},{-200,
          230},{-200,-47},{-161,-47}}, color={0,0,127}));
  annotation (
  Documentation(info="
  <html>
  <p>
  This is a simplified multizone RC model resulting from the translation of a GeoJSON model specified
  within Urbanopt UI. It is composed of 6 thermal zones corresponding to the different load patterns.
  </p>
  </html>"),
  Diagram(coordinateSystem(extent={{-300,-300},{300,300}})), Icon(
        coordinateSystem(extent={{-100,-100},{100,100}})));
end SpawnBuilding1ZoneRefactor;
