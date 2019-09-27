within Buildings.Applications.DHC.Loads.Examples.BaseClasses;
model GeojsonBuildingAirFlow "Building model of type RC based on Urbanopt GeoJSON export"
  import Buildings;
  extends Buildings.Applications.DHC.Loads.BaseClasses.PartialBuilding(
    hasFraLat=cat(
        1,
        {true},
        fill(false, 5)),
    m_flowCooLoa_nominal=cat(
        1,
        {5000},
        fill(0, 5)),
    m_flowHeaLoa_nominal=cat(
        1,
        {5000},
        fill(0, 5)),
    floRegCooLoa=cat(
        1,
        {Buildings.Fluid.Types.HeatExchangerFlowRegime.CounterFlow},
        fill(Buildings.Fluid.Types.HeatExchangerFlowRegime.ConstantTemperaturePhaseChange, 5)),
    floRegHeaLoa=cat(
        1,
        {Buildings.Fluid.Types.HeatExchangerFlowRegime.CounterFlow},
        fill(Buildings.Fluid.Types.HeatExchangerFlowRegime.ConstantTemperaturePhaseChange, 5)),
    final heaLoaTyp=fill(Buildings.Applications.DHC.Loads.Types.ModelType.HeatPort, nHeaLoa),
    final cooLoaTyp=fill(Buildings.Applications.DHC.Loads.Types.ModelType.HeatPort, nCooLoa),
    final nHeaLoa=6,
    final nCooLoa=6,
    Q_flowCoo_nominal={30000,5000,5000,5000,5000,20000},
    Q_flowHea_nominal={15000,10000,5000,8000,5000,1000});
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minTSet[nHeaLoa](k=fill(20, nHeaLoa))
    "Minimum temperature setpoint" annotation (Placement(transformation(extent={{-140,120},{-120,140}})));
  Buildings.Controls.OBC.UnitConversions.From_degC from_degC1[nHeaLoa]
    annotation (Placement(transformation(extent={{-100,120},{-80,140}})));
  Buildings.Controls.OBC.CDL.Continuous.LimPID conPIDMinT[nHeaLoa](
    each yMax=1,
    each controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    each reverseAction=false,
    each yMin=0,
    each Ti=120) "PID controller for minimum temperature"
    annotation (Placement(transformation(extent={{-60,120},{-40,140}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai[nHeaLoa](k=Q_flowHea_nominal)
    annotation (Placement(transformation(extent={{-20,120},{0,140}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant maxTSet[nCooLoa](k=fill(24, nCooLoa))
    "Maximum temperature setpoint" annotation (Placement(transformation(extent={{-140,-140},{-120,-120}})));
  Buildings.Controls.OBC.UnitConversions.From_degC from_degC2[nCooLoa]
    annotation (Placement(transformation(extent={{-100,-140},{-80,-120}})));
  Buildings.Controls.OBC.CDL.Continuous.LimPID conPIDMax[nCooLoa](
    each controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    each reverseAction=true,
    each yMax=1,
    each yMin=0,
    each Ti=120)
    "PID controller for maximum temperature"
    annotation (Placement(transformation(extent={{-60,-140},{-40,-120}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai1[nCooLoa](k=-Q_flowCoo_nominal)
    annotation (Placement(transformation(extent={{-20,-140},{0,-120}})));
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
  Buildings.Controls.OBC.CDL.Continuous.Line lin annotation (Placement(transformation(extent={{200,-100},{220,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.Max max annotation (Placement(transformation(extent={{160,-100},{180,-80}})));
  Modelica.Blocks.Sources.Constant x1(k=0) annotation (Placement(transformation(extent={{160,-20},{180,0}})));
  Modelica.Blocks.Sources.Constant y1(k=0.1*m_flowCooLoa_nominal[1])
    annotation (Placement(transformation(extent={{160,-60},{180,-40}})));
  Modelica.Blocks.Sources.Constant y2(k=m_flowCooLoa_nominal[1])
    annotation (Placement(transformation(extent={{160,-180},{180,-160}})));
  Modelica.Blocks.Sources.Constant x2(k=1) annotation (Placement(transformation(extent={{160,-140},{180,-120}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(k=0.2)
    annotation (Placement(transformation(extent={{200,-42},{220,-20}})));
equation
  connect(from_degC1.y,conPIDMinT. u_s) annotation (Line(points={{-79,130},{-62,130}}, color={0,0,127}));
  connect(conPIDMinT.y,gai. u) annotation (Line(points={{-39,130},{-22,130}}, color={0,0,127}));
  connect(from_degC2.y,conPIDMax. u_s) annotation (Line(points={{-79,-130},{-62,-130}}, color={0,0,127}));
  connect(maxTSet.y,from_degC2. u) annotation (Line(points={{-119,-130},{-102,-130}}, color={0,0,127}));
  connect(conPIDMax.y,gai1. u) annotation (Line(points={{-39,-130},{-22,-130}}, color={0,0,127}));
  connect(minTSet.y, from_degC1.u)
    annotation (Line(points={{-119,130},{-110,130},{-110,130},{-102,130}}, color={0,0,127}));
  connect(b5a6b99ec37f4de7f94020090_Floor.TAir, conPIDMinT[2].u_m)
    annotation (Line(points={{-39,-10},{-30,-10},{-30,100},{-50,100},{-50,118}}, color={0,0,127}));
  connect(b5a6b99ec37f4de7f94020090_Meeting.TAir, conPIDMinT[4].u_m)
    annotation (Line(points={{41,-10},{50,-10},{50,100},{-50,100},{-50,118}}, color={0,0,127}));
  connect(b5a6b99ec37f4de7f94020090_Restroom.TAir, conPIDMinT[5].u_m)
    annotation (Line(points={{81,-10},{90,-10},{90,100},{-50,100},{-50,118}}, color={0,0,127}));
  connect(b5a6b99ec37f4de7f94020090_ICT.TAir, conPIDMinT[6].u_m)
    annotation (Line(points={{121,-10},{130,-10},{130,100},{-50,100},{-50,118}}, color={0,0,127}));
  connect(b5a6b99ec37f4de7f94020090_Floor.TAir, conPIDMax[2].u_m)
    annotation (Line(points={{-39,-10},{-30,-10},{-30,-160},{-50,-160},{-50,-142}}, color={0,0,127}));
  connect(b5a6b99ec37f4de7f94020090_Storage.TAir, conPIDMax[3].u_m)
    annotation (Line(points={{1,-10},{10,-10},{10,-160},{-50,-160},{-50,-142}}, color={0,0,127}));
  connect(b5a6b99ec37f4de7f94020090_Meeting.TAir, conPIDMax[4].u_m)
    annotation (Line(points={{41,-10},{50,-10},{50,-160},{-50,-160},{-50,-142}}, color={0,0,127}));
  connect(b5a6b99ec37f4de7f94020090_ICT.TAir, conPIDMax[6].u_m)
    annotation (Line(points={{121,-10},{130,-10},{130,-160},{-50,-160},{-50,-142}}, color={0,0,127}));
  connect(gai1.y, Q_flowCooReq) annotation (Line(points={{1,-130},{152,-130},{152,-192},{310,-192}}, color={0,0,127}));
  connect(gai.y, Q_flowHeaReq) annotation (Line(points={{1,130},{152,130},{152,200},{310,200}}, color={0,0,127}));
  connect(b5a6b99ec37f4de7f94020090_Office.TAir, conPIDMinT[1].u_m)
    annotation (Line(points={{-79,-10},{-70,-10},{-70,100},{-50,100},{-50,118}}, color={0,0,127}));
  connect(b5a6b99ec37f4de7f94020090_Office.TAir, conPIDMax[1].u_m)
    annotation (Line(points={{-79,-10},{-70,-10},{-70,-160},{-50,-160},{-50,-142}}, color={0,0,127}));
  connect(b5a6b99ec37f4de7f94020090_Restroom.TAir, conPIDMax[5].u_m)
    annotation (Line(points={{81,-10},{90,-10},{90,-160},{-50,-160},{-50,-142}}, color={0,0,127}));
  connect(b5a6b99ec37f4de7f94020090_Storage.TAir, conPIDMinT[3].u_m)
    annotation (Line(points={{1,-10},{10,-10},{10,100},{-50,100},{-50,118}}, color={0,0,127}));
  connect(weaBus, b5a6b99ec37f4de7f94020090_Office.weaBus) annotation (Line(
      points={{1,300},{9,300},{9,20.3398},{-100,20.3398},{-100,-10}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus, b5a6b99ec37f4de7f94020090_Floor.weaBus) annotation (Line(
      points={{1,300},{10,300},{10,20},{-60,20},{-60,-10}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus, b5a6b99ec37f4de7f94020090_Storage.weaBus) annotation (Line(
      points={{1,300},{11,300},{11,20},{-20,20},{-20,-10}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus, b5a6b99ec37f4de7f94020090_Meeting.weaBus) annotation (Line(
      points={{1,300},{10,300},{10,20},{20,20},{20,-10}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus, b5a6b99ec37f4de7f94020090_Restroom.weaBus) annotation (Line(
      points={{1,300},{9,300},{9,19},{60,19},{60,-10}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus, b5a6b99ec37f4de7f94020090_ICT.weaBus) annotation (Line(
      points={{1,300},{10,300},{10,20},{100,20},{100,-10}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(b5a6b99ec37f4de7f94020090_Office.port_a, heaFloHeaLoaH[1].port_b)
    annotation (Line(points={{-90,0},{-160,0},{-160,150},{-260,150}}, color={191,0,0}));
  connect(b5a6b99ec37f4de7f94020090_Floor.port_a, heaFloHeaLoaH[2].port_b)
    annotation (Line(points={{-50,0},{-160,0},{-160,150},{-260,150}}, color={191,0,0}));
  connect(b5a6b99ec37f4de7f94020090_Storage.port_a, heaFloHeaLoaH[3].port_b)
    annotation (Line(points={{-10,0},{-160,0},{-160,150},{-260,150}}, color={191,0,0}));
  connect(b5a6b99ec37f4de7f94020090_Meeting.port_a, heaFloHeaLoaH[4].port_b)
    annotation (Line(points={{30,0},{-160,0},{-160,150},{-260,150}}, color={191,0,0}));
  connect(b5a6b99ec37f4de7f94020090_Restroom.port_a, heaFloHeaLoaH[5].port_b)
    annotation (Line(points={{70,0},{-160,0},{-160,150},{-260,150}}, color={191,0,0}));
  connect(b5a6b99ec37f4de7f94020090_ICT.port_a, heaFloHeaLoaH[6].port_b)
    annotation (Line(points={{110,0},{-160,0},{-160,150},{-260,150}}, color={191,0,0}));
  connect(b5a6b99ec37f4de7f94020090_Office.port_a, heaFloCooLoaH[1].port_b)
    annotation (Line(points={{-90,0},{-160,0},{-160,-150},{-260,-150}}, color={191,0,0}));
  connect(b5a6b99ec37f4de7f94020090_Floor.port_a, heaFloCooLoaH[2].port_b)
    annotation (Line(points={{-50,0},{-160,0},{-160,-150},{-260,-150}}, color={191,0,0}));
  connect(b5a6b99ec37f4de7f94020090_Storage.port_a, heaFloCooLoaH[3].port_b)
    annotation (Line(points={{-10,0},{-160,0},{-160,-150},{-260,-150}}, color={191,0,0}));
  connect(b5a6b99ec37f4de7f94020090_Meeting.port_a, heaFloCooLoaH[4].port_b)
    annotation (Line(points={{30,0},{-160,0},{-160,-150},{-260,-150}}, color={191,0,0}));
  connect(b5a6b99ec37f4de7f94020090_Restroom.port_a, heaFloCooLoaH[5].port_b)
    annotation (Line(points={{70,0},{-160,0},{-160,-150},{-260,-150}}, color={191,0,0}));
  connect(b5a6b99ec37f4de7f94020090_ICT.port_a, heaFloCooLoaH[6].port_b)
    annotation (Line(points={{110,0},{-160,0},{-160,-150},{-260,-150}}, color={191,0,0}));
  connect(conPIDMinT[1].y, max.u1) annotation (Line(points={{-39,130},{152,130},{152,-84},{158,-84}}, color={0,0,127}));
  connect(conPIDMax[1].y, max.u2)
    annotation (Line(points={{-39,-130},{152,-130},{152,-96},{158,-96}}, color={0,0,127}));
  connect(max.y, lin.u) annotation (Line(points={{181,-90},{190,-90},{190,-90},{198,-90}}, color={0,0,127}));
  connect(x1.y, lin.x1) annotation (Line(points={{181,-10},{190,-10},{190,-82},{198,-82}}, color={0,0,127}));
  connect(y1.y, lin.f1) annotation (Line(points={{181,-50},{186,-50},{186,-86},{198,-86}}, color={0,0,127}));
  connect(x2.y, lin.x2) annotation (Line(points={{181,-130},{186,-130},{186,-94},{198,-94}}, color={0,0,127}));
  connect(y2.y, lin.f2) annotation (Line(points={{181,-170},{190,-170},{190,-98},{198,-98}}, color={0,0,127}));
  connect(lin.y, m_flowHeaLoa[1])
    annotation (Line(points={{221,-90},{240,-90},{240,91.6667},{310,91.6667}}, color={0,0,127}));
  connect(lin.y, m_flowCooLoa[1])
    annotation (Line(points={{221,-90},{240,-90},{240,-120.333},{310,-120.333}}, color={0,0,127}));
  connect(con.y, fraLatCooReq[1])
    annotation (Line(points={{221,-31},{261.5,-31},{261.5,-38.3333},{310,-38.3333}}, color={0,0,127}));
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
end GeojsonBuildingAirFlow;
