within Buildings.Applications.DHC.Loads.Examples.BaseClasses;
model SpawnZ1Building "Spawn building model based on Urbanopt GeoJSON export"
  import Buildings;
  extends Buildings.Applications.DHC.Loads.BaseClasses.PartialBuilding(
    haveFan=true,
    havePum=false,
    haveEleHea=false,
    haveEleCoo=false,
    nPorts1=2);
  package Medium2 = Buildings.Media.Air
    "Load side medium";
  parameter String idfPath=
    "modelica://Buildings/Resources/Data/Experimental/EnergyPlus/Validation/RefBldgSmallOfficeNew2004_Chicago.idf"
    "Path of the IDF file";
  parameter String weaPath=
    "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"
    "Path of the weather file";
  Buildings.Applications.DHC.Loads.Examples.BaseClasses.Terminal4PipesFluidPorts
    terUni(
    QHea_flow_nominal=10000,
    QCoo_flow_nominal=10000,
    T_a2Hea_nominal=293.15,
    T_a2Coo_nominal=297.15,
    T_b1Hea_nominal=disFloHea.T_b1_nominal,
    T_b1Coo_nominal=disFloCoo.T_b1_nominal,
    T_a1Hea_nominal=disFloHea.T_a1_nominal,
    T_a1Coo_nominal=disFloCoo.T_a1_nominal,
    m2Hea_flow_nominal=5,
    m2Coo_flow_nominal=5)
    annotation (Placement(transformation(extent={{-160,-60},{-140,-40}})));
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
  inner Buildings.Experimental.EnergyPlus.Building building(
    idfName=Modelica.Utilities.Files.loadResource(idfPath),
    weaName=Modelica.Utilities.Files.loadResource(weaPath),
    fmuName=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/src/EnergyPlus/FMUs/Zones1.fmu"),
    showWeatherData=false)
    "Building model"
    annotation (Placement(transformation(extent={{40,60},{60,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minTSet(k=20) "Minimum temperature setpoint"
    annotation (Placement(transformation(extent={{-300,250},{-280,270}})));
  Buildings.Controls.OBC.UnitConversions.From_degC from_degC1
    annotation (Placement(transformation(extent={{-260,250},{-240,270}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant maxTSet(k=24) "Minimum temperature setpoint"
    annotation (Placement(transformation(extent={{-300,210},{-280,230}})));
  Buildings.Controls.OBC.UnitConversions.From_degC from_degC2
    annotation (Placement(transformation(extent={{-260,210},{-240,230}})));
  Buildings.Applications.DHC.Loads.BaseClasses.FlowDistribution disFloHea(
    m1_flow_nominal=terUni.m1Hea_flow_nominal,
    T_a1_nominal=313.15,
    T_b1_nominal=308.15,
    nLoa=1)
    annotation (Placement(transformation(extent={{-120,-120},{-100,-100}})));
  Buildings.Applications.DHC.Loads.BaseClasses.FlowDistribution disFloCoo(
    m1_flow_nominal=terUni.m1Hea_flow_nominal,
    T_a1_nominal=280.15,
    T_b1_nominal=285.15,
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
  connect(minTSet.y,from_degC1. u) annotation (Line(points={{-278,260},{-262,
          260}},                                                                  color={0,0,127}));
  connect(maxTSet.y,from_degC2. u) annotation (Line(points={{-278,220},{-262,
          220}},                                                                  color={0,0,127}));
  connect(ports_a1[1], disFloHea.port_a) annotation (Line(points={{-300,-20},{-280,
          -20},{-280,-110},{-120,-110}}, color={0,127,255}));
  connect(disFloHea.port_b, ports_b1[1]) annotation (Line(points={{-100,-110},{280,
          -110},{280,-20},{300,-20}}, color={0,127,255}));
  connect(ports_a1[2], disFloCoo.port_a) annotation (Line(points={{-300,20},{-280,
          20},{-280,-150},{-120,-150}}, color={0,127,255}));
  connect(disFloCoo.port_b, ports_b1[2]) annotation (Line(points={{-100,-150},{280,
          -150},{280,20},{300,20}}, color={0,127,255}));
  connect(zon.ports[1], terUni.port_a2) annotation (Line(points={{58,-19.2},{62,
          -19.2},{62,-40.8333},{-140,-40.8333}},
                                       color={0,127,255}));
  connect(terUni.port_b2, zon.ports[2]) annotation (Line(points={{-160,-40.8333},
          {-180,-40.8333},{-180,-24},{62,-24},{62,-19.2}},
                                                color={0,127,255}));
  connect(terUni.port_b1Hea, disFloHea.ports_a1[1]) annotation (Line(points={{-140,
          -59.1667},{-140,-59.5833},{-100,-59.5833},{-100,-104}}, color={0,127,255}));
  connect(terUni.port_b1Coo, disFloCoo.ports_a1[1]) annotation (Line(points={{-140,
          -56.6667},{-80,-56.6667},{-80,-144},{-100,-144}}, color={0,127,255}));
  connect(disFloHea.ports_b1[1], terUni.port_a1Hea) annotation (Line(points={{-120,
          -104},{-180,-104},{-180,-59.1667},{-160,-59.1667}}, color={0,127,255}));
  connect(disFloCoo.ports_b1[1], terUni.port_a1Coo) annotation (Line(points={{-120,
          -144},{-200,-144},{-200,-56.6667},{-160,-56.6667}}, color={0,127,255}));
  connect(terUni.m1ReqHea_flow, disFloHea.m1Req_flow_i[1]) annotation (Line(
        points={{-139.167,-52.5},{-139.167,-118.083},{-121,-118.083},{-121,-118}},
        color={0,0,127}));
  connect(terUni.m1ReqCoo_flow, disFloCoo.m1Req_flow_i[1]) annotation (Line(
        points={{-139.167,-54.1667},{-139.167,-158.083},{-121,-158.083},{-121,
          -158}},
        color={0,0,127}));
  connect(from_degC2.y, terUni.TSetCoo) annotation (Line(points={{-238,220},{
          -200,220},{-200,-46.6667},{-160.833,-46.6667}},
                                                     color={0,0,127}));
  connect(from_degC1.y, terUni.TSetHea) annotation (Line(points={{-238,260},{
          -200,260},{-200,-43.3333},{-160.833,-43.3333}},
                                                     color={0,0,127}));
  connect(terUni.QActHea_flow, QHea_flow) annotation (Line(points={{-139.167,
          -42.5},{-130,-42.5},{-130,-42},{-120,-42},{-120,280},{320,280}},
                                                                    color={0,0,127}));
  connect(terUni.QActCoo_flow, QCoo_flow) annotation (Line(points={{-139.167,
          -44.1667},{-139.167,-46},{-120,-46},{-120,240},{320,240}},
                                                           color={0,0,127}));
  connect(terUni.PFan, PFan) annotation (Line(points={{-139.167,-49.1667},{260,
          -49.1667},{260,120},{320,120}},
                                color={0,0,127}));
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
end SpawnZ1Building;
