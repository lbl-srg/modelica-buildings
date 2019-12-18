within Buildings.Applications.DHC.Loads.Examples.BaseClasses;
model GeojsonRCBuilding
  "Building model of type RC based on Urbanopt GeoJSON export"
  extends Buildings.Applications.DHC.Loads.BaseClasses.PartialBuilding(
    final haveEleHea=false,
    final haveEleCoo=false,
    final haveFan=false,
    final havePum=false,
    nPorts1=2);
  parameter Integer nZon = 6
    "Number of thermal zones";
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minTSet[nZon](k=fill(20, nZon))
    "Minimum temperature setpoint" annotation (Placement(transformation(extent={{-300,
            240},{-280,260}})));
  Buildings.Controls.OBC.UnitConversions.From_degC from_degC1[nZon]
    annotation (Placement(transformation(extent={{-260,240},{-240,260}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant maxTSet[nZon](k=fill(24, nZon))
    "Maximum temperature setpoint" annotation (Placement(transformation(extent={{-300,
            200},{-280,220}})));
  Buildings.Controls.OBC.UnitConversions.From_degC from_degC2[nZon]
    annotation (Placement(transformation(extent={{-260,200},{-240,220}})));
  Buildings.Applications.DHC.Loads.BaseClasses.FlowDistribution disFloHea(
    m1_flow_nominal=sum(terUni.m1Hea_flow_nominal),
    T_a1_nominal=313.15,
    T_b1_nominal=308.15,
    nLoa=nZon)
    annotation (Placement(transformation(extent={{-140,-100},{-120,-80}})));
  Buildings.Applications.DHC.Loads.Examples.BaseClasses.Terminal4PipesHeatPorts terUni[nZon](
    QHea_flow_nominal={10000,10000,10000,10000,10000,10000},
    QCoo_flow_nominal={10000,10000,10000,10000,10000,50000},
    each T_a2Hea_nominal=293.15,
    each T_a2Coo_nominal=297.15,
    each T_b1Hea_nominal=disFloHea.T_b1_nominal,
    each T_b1Coo_nominal=disFloCoo.T_b1_nominal,
    each T_a1Hea_nominal=disFloHea.T_a1_nominal,
    each T_a1Coo_nominal=disFloCoo.T_a1_nominal,
    each m2Hea_flow_nominal=1,
    each m2Coo_flow_nominal=1,
    each final fraCon={1,1})
    annotation (Placement(transformation(extent={{-200,-60},{-180,-40}})));
  Buildings.Applications.DHC.Loads.BaseClasses.FlowDistribution disFloCoo(
    m1_flow_nominal=sum(terUni.m1Coo_flow_nominal),
    T_a1_nominal=280.15,
    T_b1_nominal=285.15,
    nLoa=nZon)
    annotation (Placement(transformation(extent={{-140,-160},{-120,-140}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum1(nin=nZon)
    annotation (Placement(transformation(extent={{240,270},{260,290}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum2(nin=nZon)
    annotation (Placement(transformation(extent={{240,230},{260,250}})));
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
equation
  connect(maxTSet.y,from_degC2. u) annotation (Line(points={{-278,210},{-262,210}},   color={0,0,127}));
  connect(minTSet.y, from_degC1.u)
    annotation (Line(points={{-278,250},{-262,250}},                       color={0,0,127}));
  connect(ports_a1[1],disFloHea. port_a) annotation (Line(points={{-300,-20},{-252,
          -20},{-252,-90},{-140,-90}}, color={0,127,255}));
  connect(disFloHea.port_b, ports_b1[1]) annotation (Line(points={{-120,-90},{308,
          -90},{308,-20},{300,-20}},
                                  color={0,127,255}));
  connect(ports_a1[2],disFloCoo. port_a) annotation (Line(points={{-300,20},{-252,
          20},{-252,-150},{-140,-150}},color={0,127,255}));
  connect(disFloCoo.port_b, ports_b1[2]) annotation (Line(points={{-120,-150},{308,
          -150},{308,20},{300,20}},
                                  color={0,127,255}));
  connect(from_degC1.y, terUni.TSetHea) annotation (Line(points={{-238,250},{
          -220,250},{-220,-43.3333},{-200.833,-43.3333}},
                                                     color={0,0,127}));
  connect(from_degC2.y, terUni.TSetCoo) annotation (Line(points={{-238,210},{
          -220,210},{-220,-46.6667},{-200.833,-46.6667}},
                                                     color={0,0,127}));
  connect(terUni.m1ReqHea_flow, disFloHea.m1Req_flow_i) annotation (Line(points={{
          -179.167,-52.5},{-179.167,-98.0833},{-141,-98.0833},{-141,-98}},
        color={0,0,127}));
  connect(terUni.m1ReqCoo_flow, disFloCoo.m1Req_flow_i) annotation (Line(points={{
          -179.167,-54.1667},{-179.167,-158.083},{-141,-158.083},{-141,-158}},
        color={0,0,127}));
  connect(terUni.port_b1Hea, disFloHea.ports_a1) annotation (Line(points={{-180,
          -59.1667},{-100,-59.1667},{-100,-84},{-120,-84}}, color={0,127,255}));
  connect(terUni.port_b1Coo, disFloCoo.ports_a1) annotation (Line(points={{-180,
          -56.6667},{-80,-56.6667},{-80,-144},{-120,-144}}, color={0,127,255}));
  connect(disFloHea.ports_b1, terUni.port_a1Hea) annotation (Line(points={{-140,
          -84},{-220,-84},{-220,-59.1667},{-200,-59.1667}}, color={0,127,255}));
  connect(disFloCoo.ports_b1, terUni.port_a1Coo) annotation (Line(points={{-140,
          -144},{-240,-144},{-240,-56.6667},{-200,-56.6667}}, color={0,127,255}));
  connect(terUni.QActHea_flow, mulSum1.u) annotation (Line(points={{-179.167,
          -42.5},{-160.584,-42.5},{-160.584,280},{238,280}},
                                                      color={0,0,127}));
  connect(terUni.QActCoo_flow, mulSum2.u) annotation (Line(points={{-179.167,
          -44.1667},{-160.584,-44.1667},{-160.584,240},{238,240}},
                                                         color={0,0,127}));
  connect(mulSum1.y, QHea_flow) annotation (Line(points={{262,280},{286,280},{
          286,280},{320,280}}, color={0,0,127}));
  connect(mulSum2.y, QCoo_flow) annotation (Line(points={{262,240},{284,240},{
          284,240},{320,240}}, color={0,0,127}));
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
end GeojsonRCBuilding;
