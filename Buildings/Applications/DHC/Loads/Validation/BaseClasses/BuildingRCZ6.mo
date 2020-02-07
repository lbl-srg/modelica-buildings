within Buildings.Applications.DHC.Loads.Validation.BaseClasses;
model BuildingRCZ6
  "RC building model (6 zones) based on URBANopt GeoJSON export, with distribution pumps"
  extends Buildings.Applications.DHC.Loads.BaseClasses.PartialBuilding(
    redeclare package Medium = Buildings.Media.Water,
    final have_eleHea=false,
    final have_eleCoo=false,
    final have_fan=false,
    final have_pum=true);
  package Medium2 = Buildings.Media.Air
    "Load side medium";
  parameter Integer nZon = 6
    "Number of thermal zones";
  parameter Integer facSca = 3
    "Scaling factor to be applied to on each extensive quantity";
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minTSet[nZon](k=fill(20, nZon))
    "Minimum temperature setpoint"
    annotation (Placement(transformation(extent={{-300,
            240},{-280,260}})));
  Buildings.Controls.OBC.UnitConversions.From_degC from_degC1[nZon]
    annotation (Placement(transformation(extent={{-260,240},{-240,260}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant maxTSet[nZon](k=fill(24, nZon))
    "Maximum temperature setpoint"
    annotation (Placement(transformation(extent={{-300,
            200},{-280,220}})));
  Buildings.Controls.OBC.UnitConversions.From_degC from_degC2[nZon]
    annotation (Placement(transformation(extent={{-260,200},{-240,220}})));
  GeojsonExportRC.B5a6b99ec37f4de7f94020090.Office office
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));
  GeojsonExportRC.B5a6b99ec37f4de7f94020090.Floor floor
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  GeojsonExportRC.B5a6b99ec37f4de7f94020090.Storage storage
    annotation (Placement(transformation(extent={{-20,-20},{0,0}})));
  GeojsonExportRC.B5a6b99ec37f4de7f94020090.Meeting meeting
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  GeojsonExportRC.B5a6b99ec37f4de7f94020090.Restroom restroom
    annotation (Placement(transformation(extent={{60,-20},{80,0}})));
  GeojsonExportRC.B5a6b99ec37f4de7f94020090.ICT iCT
    annotation (Placement(transformation(extent={{100,-20},{120,0}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum(nin=2)
    annotation (Placement(transformation(extent={{260,50},{280,70}})));
  Buildings.Applications.DHC.Loads.Validation.BaseClasses.FanCoil4PipesHeatPorts
    terUni[nZon](
    redeclare each package Medium1 = Medium,
    redeclare each package Medium2 = Medium2,
    each facSca=facSca,
    QHea_flow_nominal={10000,10000,10000,10000,10000,10000},
    QCoo_flow_nominal={-10000,-10000,-10000,-10000,-10000,-50000},
    each T_aLoaHea_nominal=293.15,
    each T_aLoaCoo_nominal=297.15,
    each T_bHeaWat_nominal=35 + 273.15,
    each T_bChiWat_nominal=12 + 273.15,
    each T_aHeaWat_nominal=40 + 273.15,
    each T_aChiWat_nominal=7 + 273.15,
    each mLoaHea_flow_nominal=5,
    each mLoaCoo_flow_nominal=5) "Terminal unit"
    annotation (Placement(transformation(extent={{-200,-60},{-180,-40}})));
  Buildings.Applications.DHC.Loads.BaseClasses.FlowDistribution disFloHea(
    redeclare package Medium = Medium,
    m_flow_nominal=sum(terUni.mHeaWat_flow_nominal .* terUni.facSca),
    have_pum=true,
    dp_nominal=100000,
    nPorts_a1=nZon,
    nPorts_b1=nZon)
    "Heating water distribution system"
    annotation (Placement(transformation(extent={{-140, -100},{-120,-80}})));
  Buildings.Applications.DHC.Loads.BaseClasses.FlowDistribution disFloCoo(
    redeclare package Medium = Medium,
    m_flow_nominal=sum(terUni.mChiWat_flow_nominal .* terUni.facSca),
    disTyp=Buildings.Applications.DHC.Loads.Types.DistributionType.ChilledWater,
    have_pum=true,
    dp_nominal=100000,
    nPorts_a1=nZon,
    nPorts_b1=nZon)
    "Chilled water distribution system"
    annotation (Placement(transformation(extent={{-140, -160},{-120,-140}})));
equation
  connect(maxTSet.y,from_degC2. u) annotation (Line(points={{-278,210},{-262,210}},   color={0,0,127}));
  connect(minTSet.y, from_degC1.u)
    annotation (Line(points={{-278,250},{-262,250}},                       color={0,0,127}));
  connect(ports_a[1],disFloHea. port_a) annotation (Line(points={{-300,0},{-252,
          0},{-252,-90},{-140,-90}},   color={0,127,255}));
  connect(disFloHea.port_b, ports_b[1]) annotation (Line(points={{-120,-90},{308,
          -90},{308,0},{300,0}},  color={0,127,255}));
  connect(ports_a[2],disFloCoo. port_a) annotation (Line(points={{-300,0},{-252,
          0},{-252,-150},{-140,-150}}, color={0,127,255}));
  connect(disFloCoo.port_b, ports_b[2]) annotation (Line(points={{-120,-150},{308,
          -150},{308,0},{300,0}}, color={0,127,255}));
  connect(from_degC1.y, terUni.TSetHea) annotation (Line(points={{-238,250},{
          -220,250},{-220,-43.3333},{-200.833,-43.3333}},
                                                     color={0,0,127}));
  connect(from_degC2.y, terUni.TSetCoo) annotation (Line(points={{-238,210},{
          -220,210},{-220,-46.6667},{-200.833,-46.6667}},
                                                     color={0,0,127}));
  connect(terUni.port_bHeaWat, disFloHea.ports_a1) annotation (Line(points={{-180,
          -58.3333},{-100,-58.3333},{-100,-84},{-120,-84}}, color={0,127,255}));
  connect(terUni.port_bChiWat, disFloCoo.ports_a1) annotation (Line(points={{-180,
          -56.6667},{-80,-56.6667},{-80,-144},{-120,-144}}, color={0,127,255}));
  connect(disFloHea.ports_b1, terUni.port_aHeaWat) annotation (Line(points={{-140,
          -84},{-220,-84},{-220,-58.3333},{-200,-58.3333}}, color={0,127,255}));
  connect(disFloCoo.ports_b1, terUni.port_aChiWat) annotation (Line(points={{-140,
          -144},{-240,-144},{-240,-56.6667},{-200,-56.6667}}, color={0,127,255}));
  connect(weaBus, office.weaBus) annotation (Line(
      points={{1,300},{0,300},{0,20},{-66,20},{-66,-10.2},{-96,-10.2}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(weaBus, floor.weaBus) annotation (Line(
      points={{1,300},{1,160},{0,20},{-56,20},{-56,-10.2}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus, storage.weaBus) annotation (Line(
      points={{1,300},{0,300},{0,-10.2},{-16,-10.2}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(weaBus, meeting.weaBus) annotation (Line(
      points={{1,300},{1,20},{24,20},{24,-10.2}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus, restroom.weaBus) annotation (Line(
      points={{1,300},{2,300},{2,20},{68,20},{68,-10.2},{64,-10.2}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(weaBus, iCT.weaBus) annotation (Line(
      points={{1,300},{0,300},{0,19.8},{104,19.8},{104,-10.2}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(terUni[1].heaPorCon, office.port_a) annotation (Line(points={{
          -193.333,-50},{-192,-50},{-192,0},{-90,0}}, color={191,0,0}));
  connect(terUni[2].heaPorCon, floor.port_a) annotation (Line(points={{-193.333,
          -50},{-192,-50},{-192,0},{-50,0}}, color={191,0,0}));
  connect(terUni[3].heaPorCon, storage.port_a) annotation (Line(points={{
          -193.333,-50},{-192,-50},{-192,0},{-10,0}}, color={191,0,0}));
  connect(terUni[4].heaPorCon, meeting.port_a) annotation (Line(points={{
          -193.333,-50},{-192,-50},{-192,0},{30,0}}, color={191,0,0}));
  connect(terUni[5].heaPorCon, restroom.port_a) annotation (Line(points={{
          -193.333,-50},{-192,-50},{-192,0},{70,0}}, color={191,0,0}));
  connect(terUni[6].heaPorCon, iCT.port_a) annotation (Line(points={{-193.333,
          -50},{-192,-50},{-192,0},{110,0}}, color={191,0,0}));
  connect(terUni[1].heaPorRad, office.port_a) annotation (Line(points={{
          -186.667,-50},{-90,-50},{-90,0}}, color={191,0,0}));
  connect(terUni[2].heaPorRad, floor.port_a) annotation (Line(points={{-186.667,
          -50},{-50,-50},{-50,0}}, color={191,0,0}));
  connect(terUni[3].heaPorRad, storage.port_a) annotation (Line(points={{
          -186.667,-50},{-10,-50},{-10,0}}, color={191,0,0}));
  connect(terUni[4].heaPorRad, meeting.port_a) annotation (Line(points={{
          -186.667,-50},{30,-50},{30,0}}, color={191,0,0}));
  connect(terUni[5].heaPorRad, restroom.port_a) annotation (Line(points={{
          -186.667,-50},{70,-50},{70,0}}, color={191,0,0}));
  connect(terUni[6].heaPorRad, iCT.port_a) annotation (Line(points={{-186.667,
          -50},{110,-50},{110,0}}, color={191,0,0}));
  connect(terUni.mReqHeaWat_flow, disFloHea.mReq_flow) annotation (Line(points={{
          -179.167,-53.3333},{-179.167,-74},{-180,-74},{-180,-94},{-141,-94},{
          -141,-94}},
                 color={0,0,127}));
  connect(terUni.mReqChiWat_flow, disFloCoo.mReq_flow) annotation (Line(points={{
          -179.167,-55},{-179.167,-155.083},{-141,-155.083},{-141,-154}},
        color={0,0,127}));
  connect(mulSum.y, PPum)
    annotation (Line(points={{282,60},{302,60},{302,80},{320,80}},
                                                 color={0,0,127}));
  connect(disFloHea.PPum, mulSum.u[1]) annotation (Line(points={{-119,-98},{240,
          -98},{240,61},{258,61}}, color={0,0,127}));
  connect(disFloCoo.PPum, mulSum.u[2]) annotation (Line(points={{-119,-158},{
          240,-158},{240,59},{258,59}}, color={0,0,127}));
  connect(disFloHea.QActTot_flow, QHea_flow) annotation (Line(points={{-119,-96},
          {223.5,-96},{223.5,280},{320,280}}, color={0,0,127}));
  connect(disFloCoo.QActTot_flow, QCoo_flow) annotation (Line(points={{-119,
          -156},{230,-156},{230,240},{320,240}}, color={0,0,127}));
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
end BuildingRCZ6;
