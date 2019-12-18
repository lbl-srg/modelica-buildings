within Buildings.Applications.DHC.Loads.Examples.BaseClasses;
model GeojsonSpawn1Z6Building
  "Spawn building model based on Urbanopt GeoJSON export"
  extends Buildings.Applications.DHC.Loads.BaseClasses.PartialBuilding(
    final haveEleHea=false,
    final haveEleCoo=false,
    final haveFan=true,
    final havePum=false,
    nPorts1=2);
  package Medium2 = Buildings.Media.Air "Medium model";
  parameter Integer nZon = 6
    "Number of thermal zones";
  parameter String idfPath=
    "modelica://Buildings/Applications/DHC/Loads/Examples/BaseClasses/GeojsonExportSpawn/Resources/Data/B5a6b99ec37f4de7f94020090/RefBldgSmallOfficeNew2004_Chicago.idf"
    "Path of the IDF file";
  parameter String weaPath=
    "modelica://Buildings/Applications/DHC/Loads/Examples/BaseClasses/GeojsonExportSpawn/Resources/Data/B5a6b99ec37f4de7f94020090/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"
    "Path of the weather file";
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minTSet[nZon](k=fill(20,
        nZon))        "Minimum temperature setpoint"
    annotation (Placement(transformation(extent={{-300,250},{-280,270}})));
  Buildings.Controls.OBC.UnitConversions.From_degC from_degC1[nZon]
    annotation (Placement(transformation(extent={{-260,250},{-240,270}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant maxTSet[nZon](k=fill(24,
        nZon))        "Maximum temperature setpoint"
    annotation (Placement(transformation(extent={{-300,210},{-280,230}})));
  Buildings.Controls.OBC.UnitConversions.From_degC from_degC2[nZon]
    annotation (Placement(transformation(extent={{-260,210},{-240,230}})));
  Modelica.Blocks.Sources.Constant qConGai_flow(k=0) "Convective heat gain"
    annotation (Placement(transformation(extent={{-60,180},{-40,200}})));
  Modelica.Blocks.Sources.Constant qRadGai_flow(k=0) "Radiative heat gain"
    annotation (Placement(transformation(extent={{-60,220},{-40,240}})));
  Modelica.Blocks.Routing.Multiplex3 multiplex3_1
    annotation (Placement(transformation(extent={{-14,180},{6,200}})));
  Modelica.Blocks.Sources.Constant qLatGai_flow(k=0) "Latent heat gain"
    annotation (Placement(transformation(extent={{-60,140},{-40,160}})));
  Buildings.Experimental.EnergyPlus.ThermalZone znAttic(
    redeclare package Medium = Medium2,
    zoneName="Attic",
    nPorts=2)        "Thermal zone"
    annotation (Placement(transformation(extent={{24,84},{64,124}})));
  Buildings.Experimental.EnergyPlus.ThermalZone znCore_ZN(
    redeclare package Medium = Medium2,
    zoneName="Core_ZN",
    nPorts=2)          "Thermal zone"
    annotation (Placement(transformation(extent={{24,42},{64,82}})));
  Buildings.Experimental.EnergyPlus.ThermalZone znPerimeter_ZN_1(
    redeclare package Medium = Medium2,
    zoneName="Perimeter_ZN_1",
    nPorts=2)                 "Thermal zone"
    annotation (Placement(transformation(extent={{24,0},{64,40}})));
  Buildings.Experimental.EnergyPlus.ThermalZone znPerimeter_ZN_2(
    redeclare package Medium = Medium2,
    zoneName="Perimeter_ZN_2",
    nPorts=2)                 "Thermal zone"
    annotation (Placement(transformation(extent={{24,-40},{64,0}})));
  Buildings.Experimental.EnergyPlus.ThermalZone znPerimeter_ZN_3(
    redeclare package Medium = Medium2,
    zoneName="Perimeter_ZN_3",
    nPorts=2)                 "Thermal zone"
    annotation (Placement(transformation(extent={{24,-80},{64,-40}})));
  Buildings.Experimental.EnergyPlus.ThermalZone znPerimeter_ZN_4(
    redeclare package Medium = Medium2,
    zoneName="Perimeter_ZN_4",
    nPorts=2)                 "Thermal zone"
    annotation (Placement(transformation(extent={{24,-120},{64,-80}})));
  inner Buildings.Experimental.EnergyPlus.Building building(
    idfName=Modelica.Utilities.Files.loadResource(idfPath),
    weaName=Modelica.Utilities.Files.loadResource(weaPath))
    "Building outer component"
    annotation (Placement(transformation(extent={{30,198},{52,218}})));
  Buildings.Applications.DHC.Loads.BaseClasses.FlowDistribution disFloHea(
    m1_flow_nominal=sum(terUni.m1Hea_flow_nominal),
    T_a1_nominal=313.15,
    T_b1_nominal=308.15,
    nLoa=nZon)
    annotation (Placement(transformation(extent={{-238,-190},{-218,-170}})));
  Buildings.Applications.DHC.Loads.BaseClasses.FlowDistribution disFloCoo(
    m1_flow_nominal=sum(terUni.m1Coo_flow_nominal),
    T_a1_nominal=280.15,
    T_b1_nominal=285.15,
    nLoa=nZon)
    annotation (Placement(transformation(extent={{-180,-230},{-160,-210}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum(nin=nZon)
    annotation (Placement(transformation(extent={{220,110},{240,130}})));
  Buildings.Applications.DHC.Loads.Examples.BaseClasses.Terminal4PipesFluidPorts
    terUni[nZon](
    QHea_flow_nominal={50000,10000,10000,10000,10000,10000},
    QCoo_flow_nominal={10000,10000,10000,10000,10000,10000},
    each T_a2Hea_nominal=293.15,
    each T_a2Coo_nominal=297.15,
    each T_b1Hea_nominal=disFloHea.T_b1_nominal,
    each T_b1Coo_nominal=disFloCoo.T_b1_nominal,
    each T_a1Hea_nominal=disFloHea.T_a1_nominal,
    each T_a1Coo_nominal=disFloCoo.T_a1_nominal,
    each m2Hea_flow_nominal=5,
    each m2Coo_flow_nominal=5)
    annotation (Placement(transformation(extent={{-86,-2},{-62,22}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum1(nin=nZon)
    annotation (Placement(transformation(extent={{220,270},{240,290}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum2(nin=nZon)
    annotation (Placement(transformation(extent={{220,230},{240,250}})));
equation
  connect(maxTSet.y,from_degC2.u)
    annotation (Line(points={{-278,220},{-262,220}}, color={0,0,127}));
  connect(minTSet.y, from_degC1.u)
    annotation (Line(points={{-278,260},{-262,260}}, color={0,0,127}));
  connect(qRadGai_flow.y,multiplex3_1.u1[1])  annotation (Line(
      points={{-39,230},{-20,230},{-20,197},{-16,197}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(qConGai_flow.y,multiplex3_1.u2[1])
    annotation (Line(
      points={{-39,190},{-50,190},{-44,190},{-16,190}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(multiplex3_1.u3[1],qLatGai_flow.y)
    annotation (Line(points={{-16,183},{-20,183},{-20,150},{-39,150}}, color={0,0,127}));
  connect(multiplex3_1.y,znAttic.qGai_flow)
    annotation (Line(points={{7,190},{20,190},{20,114},{22,114}}, color={0,0,127}));
  connect(multiplex3_1.y,znCore_ZN.qGai_flow)
    annotation (Line(points={{7,190},{20,190},{20,72},{22,72}}, color={0,0,127}));
  connect(multiplex3_1.y,znPerimeter_ZN_1.qGai_flow)
    annotation (Line(points={{7,190},{20,190},{20,30},{22,30}}, color={0,0,127}));
  connect(multiplex3_1.y,znPerimeter_ZN_2.qGai_flow)
      annotation (Line(points={{7,190},{20,190},{20,-10},{22,-10}}, color={0,0,127}));
  connect(multiplex3_1.y,znPerimeter_ZN_3.qGai_flow)
    annotation (Line(points={{7,190},{20,190},{20,-50},{22,-50}}, color={0,0,127}));
  connect(multiplex3_1.y,znPerimeter_ZN_4.qGai_flow)
    annotation (Line(points={{7,190},{20,190},{20,-90},{22,-90}}, color={0,0,127}));
  connect(ports_a1[1], disFloHea.port_a)
    annotation (Line(points={{-300,-20},{-280,-20},{-280,-180},{-238,-180}},
                                         color={0,127,255}));
  connect(disFloHea.port_b, ports_b1[1])
    annotation (Line(points={{-218,-180},{260,-180},{260,-20},{300,-20}},
                                      color={0,127,255}));
  connect(ports_a1[2], disFloCoo.port_a) annotation (Line(points={{-300,20},{-280,
          20},{-280,-220},{-180,-220}}, color={0,127,255}));
  connect(disFloCoo.port_b, ports_b1[2]) annotation (Line(points={{-160,-220},{280,
          -220},{280,20},{300,20}}, color={0,127,255}));
  connect(PFan, mulSum.y) annotation (Line(points={{320,120},{242,120}},
                      color={0,0,127}));
  connect(from_degC1.y, terUni.TSetHea) annotation (Line(points={{-238,260},{-162,
          260},{-162,18},{-87,18}}, color={0,0,127}));
  connect(from_degC2.y, terUni.TSetCoo) annotation (Line(points={{-238,220},{-162,
          220},{-162,14},{-87,14}}, color={0,0,127}));
  connect(znAttic.ports[1], terUni[1].port_a2) annotation (Line(points={{42,84.8},
          {-8,84.8},{-8,21},{-62,21}},       color={0,127,255}));
  connect(terUni[1].port_b2, znAttic.ports[2]) annotation (Line(points={{-86,21},
          {-20,21},{-20,84.8},{46,84.8}},      color={0,127,255}));
  connect(znCore_ZN.ports[1], terUni[2].port_a2) annotation (Line(points={{42,42.8},
          {-8,42.8},{-8,21},{-62,21}},       color={0,127,255}));
  connect(terUni[2].port_b2, znCore_ZN.ports[2]) annotation (Line(points={{-86,21},
          {-20,21},{-20,42.8},{46,42.8}},      color={0,127,255}));
  connect(znPerimeter_ZN_1.ports[1], terUni[3].port_a2) annotation (Line(points={{42,0.8},
          {-8,0.8},{-8,21},{-62,21}},               color={0,127,255}));
  connect(terUni[3].port_b2, znPerimeter_ZN_1.ports[2]) annotation (Line(points={{-86,21},
          {-20,21},{-20,0.8},{46,0.8}},               color={0,127,255}));
  connect(znPerimeter_ZN_2.ports[1], terUni[4].port_a2) annotation (Line(points={{42,
          -39.2},{-8,-39.2},{-8,21},{-62,21}},          color={0,127,255}));
  connect(terUni[4].port_b2, znPerimeter_ZN_2.ports[2]) annotation (Line(points={{-86,21},
          {-20,21},{-20,-39.2},{46,-39.2}},               color={0,127,255}));
  connect(znPerimeter_ZN_3.ports[1], terUni[5].port_a2) annotation (Line(points={{42,
          -79.2},{-8,-79.2},{-8,21},{-62,21}},          color={0,127,255}));
  connect(terUni[5].port_b2, znPerimeter_ZN_3.ports[2]) annotation (Line(points={{-86,21},
          {-20,21},{-20,-79.2},{46,-79.2}},               color={0,127,255}));
  connect(znPerimeter_ZN_4.ports[1], terUni[6].port_a2) annotation (Line(points={{42,
          -119.2},{-8,-119.2},{-8,21},{-62,21}},          color={0,127,255}));
  connect(terUni[6].port_b2, znPerimeter_ZN_4.ports[2]) annotation (Line(points={{-86,21},
          {-20,21},{-20,-119.2},{46,-119.2}},               color={0,127,255}));
  connect(terUni.port_b1Hea, disFloHea.ports_a1) annotation (Line(points={{-62,-1},
          {-40,-1},{-40,-174},{-218,-174}}, color={0,127,255}));
  connect(disFloHea.ports_b1, terUni.port_a1Hea) annotation (Line(points={{-238,
          -174},{-260,-174},{-260,-1},{-86,-1}}, color={0,127,255}));
  connect(disFloCoo.ports_b1, terUni.port_a1Coo) annotation (Line(points={{-180,
          -214},{-260,-214},{-260,2},{-86,2}}, color={0,127,255}));
  connect(terUni.port_b1Coo, disFloCoo.ports_a1) annotation (Line(points={{-62,2},
          {-38,2},{-38,-214},{-160,-214}}, color={0,127,255}));
  connect(terUni.m1ReqCoo_flow, disFloCoo.m1Req_flow_i) annotation (Line(points=
         {{-61,5},{-61,-111.5},{-181,-111.5},{-181,-228}}, color={0,0,127}));
  connect(terUni.m1ReqHea_flow, disFloHea.m1Req_flow_i) annotation (Line(points=
         {{-61,7},{-61,-91.5},{-239,-91.5},{-239,-188}}, color={0,0,127}));
  connect(mulSum1.y, QHea_flow)
    annotation (Line(points={{242,280},{320,280}}, color={0,0,127}));
  connect(mulSum2.y, QCoo_flow)
    annotation (Line(points={{242,240},{320,240}}, color={0,0,127}));
  connect(terUni.QActHea_flow, mulSum1.u[1:6]) annotation (Line(points={{-61,19},
          {79.5,19},{79.5,280},{218,280}},         color={0,0,127}));
  connect(terUni.QActCoo_flow, mulSum2.u) annotation (Line(points={{-61,17},{78.5,
          17},{78.5,240},{218,240}}, color={0,0,127}));
  connect(terUni.PFan, mulSum.u[1:6]) annotation (Line(points={{-61,11},{218,11},
          {218,120}},     color={0,0,127}));
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
end GeojsonSpawn1Z6Building;
