within Buildings.Applications.DHC.Loads.Examples.BaseClasses;
model GeojsonRCBuilding
  "Building model of type RC based on Urbanopt GeoJSON export"
  extends Buildings.Applications.DHC.Loads.BaseClasses.PartialBuilding(
    final haveEleHeaCoo=false,
    final haveFanPum=true,
    final nLoa=6, nPorts1=2);
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minTSet[nLoa](k=fill(20, nLoa))
    "Minimum temperature setpoint" annotation (Placement(transformation(extent={{-300,
            240},{-280,260}})));
  Buildings.Controls.OBC.UnitConversions.From_degC from_degC1[nLoa]
    annotation (Placement(transformation(extent={{-260,240},{-240,260}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant maxTSet[nLoa](k=fill(24, nLoa))
    "Maximum temperature setpoint" annotation (Placement(transformation(extent={{-300,
            200},{-280,220}})));
  Buildings.Controls.OBC.UnitConversions.From_degC from_degC2[nLoa]
    annotation (Placement(transformation(extent={{-260,200},{-240,220}})));
  Buildings.Applications.DHC.Loads.Examples.BaseClasses.GeojsonExport.B5a6b99ec37f4de7f94020090.Office
    b5a6b99ec37f4de7f94020090_Office annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));
  Buildings.Applications.DHC.Loads.Examples.BaseClasses.GeojsonExport.B5a6b99ec37f4de7f94020090.Floor
    b5a6b99ec37f4de7f94020090_Floor annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  Buildings.Applications.DHC.Loads.Examples.BaseClasses.GeojsonExport.B5a6b99ec37f4de7f94020090.Storage
    b5a6b99ec37f4de7f94020090_Storage annotation (Placement(transformation(extent={{-20,-20},{0,0}})));
  Buildings.Applications.DHC.Loads.Examples.BaseClasses.GeojsonExport.B5a6b99ec37f4de7f94020090.Meeting
    b5a6b99ec37f4de7f94020090_Meeting annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  Buildings.Applications.DHC.Loads.Examples.BaseClasses.GeojsonExport.B5a6b99ec37f4de7f94020090.Restroom
    b5a6b99ec37f4de7f94020090_Restroom annotation (Placement(transformation(extent={{60,-20},{80,0}})));
  Buildings.Applications.DHC.Loads.Examples.BaseClasses.GeojsonExport.B5a6b99ec37f4de7f94020090.ICT
    b5a6b99ec37f4de7f94020090_ICT annotation (Placement(transformation(extent={{100,-20},{120,0}})));
  Buildings.Applications.DHC.Loads.BaseClasses.FlowDistribution disFloHea(
    m_flow1_nominal=sum(terUni.m_flow1_nominal[1]),
    T_a1_nominal=313.15,
    T_b1_nominal=308.15,
    nLoa=nLoa)
    annotation (Placement(transformation(extent={{-140,-100},{-120,-80}})));
  Buildings.Applications.DHC.Loads.Examples.BaseClasses.Terminal4PipesHeatPorts terUni[nLoa](
    Q_flow_nominal={{50000,10000},{10000,10000},{10000,10000},{10000,10000},{
        10000,10000},{10000,10000}},
    each T_a2_nominal={293.15,297.15},
    each T_b1_nominal={disFloHea.T_b1_nominal,disFloCoo.T_b1_nominal},
    each T_a1_nominal={disFloHea.T_a1_nominal,disFloCoo.T_a1_nominal},
    each m_flow2_nominal={1,1},
    each dp2_nominal={100,100},
    each fraCon={1,1})
    annotation (Placement(transformation(extent={{-200,-60},{-180,-40}})));
  Buildings.Applications.DHC.Loads.BaseClasses.FlowDistribution disFloCoo(
    m_flow1_nominal=sum(terUni.m_flow1_nominal[2]),
    T_a1_nominal=280.15,
    T_b1_nominal=285.15,
    nLoa=nLoa)
    annotation (Placement(transformation(extent={{-140,-160},{-120,-140}})));
equation
  connect(maxTSet.y,from_degC2. u) annotation (Line(points={{-278,210},{-262,210}},   color={0,0,127}));
  connect(minTSet.y, from_degC1.u)
    annotation (Line(points={{-278,250},{-262,250}},                       color={0,0,127}));
  connect(weaBus, b5a6b99ec37f4de7f94020090_Office.weaBus) annotation (Line(
      points={{1,300},{9,300},{9,20.3398},{-96,20.3398},{-96,-10.2}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus, b5a6b99ec37f4de7f94020090_Floor.weaBus) annotation (Line(
      points={{1,300},{10,300},{10,20},{-56,20},{-56,-10.2}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus, b5a6b99ec37f4de7f94020090_Storage.weaBus) annotation (Line(
      points={{1,300},{11,300},{11,20},{-16,20},{-16,-10.2}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus, b5a6b99ec37f4de7f94020090_Meeting.weaBus) annotation (Line(
      points={{1,300},{10,300},{10,20},{24,20},{24,-10.2}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus, b5a6b99ec37f4de7f94020090_Restroom.weaBus) annotation (Line(
      points={{1,300},{9,300},{9,19},{64,19},{64,-10.2}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus, b5a6b99ec37f4de7f94020090_ICT.weaBus) annotation (Line(
      points={{1,300},{10,300},{10,19.8},{104,19.8},{104,-10.2}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(from_degC1.y, terUni.TSetHea[1]) annotation (Line(points={{-238,250},
          {-220,250},{-220,-46.5},{-201,-46.5}}, color={0,0,127}));
  connect(ports_a1[1],disFloHea. port_a) annotation (Line(points={{-300,-20},{-252,
          -20},{-252,-90},{-140,-90}}, color={0,127,255}));
  connect(disFloHea.port_b, ports_b1[1]) annotation (Line(points={{-120,-90},{308,
          -90},{308,-20},{300,-20}},
                                  color={0,127,255}));
  connect(from_degC2.y, terUni.TSetHea[2]) annotation (Line(points={{-238,210},
          {-220,210},{-220,-45.5},{-201,-45.5}}, color={0,0,127}));
  connect(ports_a1[2],disFloCoo. port_a) annotation (Line(points={{-300,20},{-252,
          20},{-252,-150},{-140,-150}},color={0,127,255}));
  connect(disFloCoo.port_b, ports_b1[2]) annotation (Line(points={{-120,-150},{308,
          -150},{308,20},{300,20}},
                                  color={0,127,255}));
  connect(terUni.m1ReqCoo_flow[1], disFloHea.m_flow1Req_i[1]) annotation (Line(
        points={{-179,-44.5},{-160,-44.5},{-160,-98},{-141,-98}}, color={0,0,
          127}));
  connect(terUni.m1ReqCoo_flow[2], disFloCoo.m_flow1Req_i[1]) annotation (Line(
        points={{-179,-43.5},{-160,-43.5},{-160,-158},{-141,-158}}, color={0,0,
          127}));
  connect(terUni.QActHea_flow, QHea_flow[1, :]) annotation (Line(points={{-179,
          -46},{-92,-46},{-92,280},{320,280}}, color={0,0,127}));
  connect(terUni[1].heaPorCon, b5a6b99ec37f4de7f94020090_Office.port_a)
    annotation (Line(points={{-193.8,-50},{-194,-50},{-194,0},{-90,0}}, color={191,
          0,0}));
  connect(terUni[2].heaPorCon, b5a6b99ec37f4de7f94020090_Floor.port_a)
    annotation (Line(points={{-193.8,-50},{-194,-50},{-194,0},{-50,0}}, color={191,
          0,0}));
  connect(terUni[3].heaPorCon, b5a6b99ec37f4de7f94020090_Storage.port_a)
    annotation (Line(points={{-193.8,-50},{-194,-50},{-194,0},{-10,0}}, color={191,
          0,0}));
  connect(terUni[4].heaPorCon, b5a6b99ec37f4de7f94020090_Meeting.port_a)
    annotation (Line(points={{-193.8,-50},{-194,-50},{-194,0},{30,0}}, color={191,
          0,0}));
  connect(terUni[5].heaPorCon, b5a6b99ec37f4de7f94020090_Restroom.port_a)
    annotation (Line(points={{-193.8,-50},{-194,-50},{-194,0},{70,0}}, color={191,
          0,0}));
  connect(terUni[6].heaPorCon, b5a6b99ec37f4de7f94020090_ICT.port_a)
    annotation (Line(points={{-193.8,-50},{-194,-50},{-194,0},{110,0}}, color={191,
          0,0}));
  connect(terUni.ports_b1[1], disFloHea.ports_a1) annotation (Line(points={{
          -180,-58},{-100,-58},{-100,-84},{-120,-84}}, color={0,127,255}));
  connect(terUni.ports_b1[2], disFloCoo.ports_a1) annotation (Line(points={{
          -180,-54},{-80,-54},{-80,-144},{-120,-144}}, color={0,127,255}));
  connect(disFloHea.ports_b1, terUni.ports_a1[1]) annotation (Line(points={{
          -140,-84},{-220,-84},{-220,-58},{-200,-58}}, color={0,127,255}));
  connect(disFloCoo.ports_b1, terUni.ports_a1[2]) annotation (Line(points={{
          -140,-144},{-240,-144},{-240,-54},{-200,-54}}, color={0,127,255}));
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
