within Buildings.Examples.VAVCO2.BaseClasses;
model Suite "Model of a suite consisting of five rooms of the MIT system model"
  replaceable package Medium =
      Modelica.Media.Interfaces.PartialMedium "Medium in the component";
  Modelica.Blocks.Interfaces.RealInput p "Pressure"
    annotation (Placement(transformation(extent={{-138,160},{-98,200}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_aSup(
    redeclare package Medium = Medium)
  annotation (Placement(transformation(extent={{-110,110},{-90,130}})));

  parameter Real scaM_flow "Scaling factor for mass flow rate";
  parameter Modelica.SIunits.MassFlowRate m0Tot_flow=
    scaM_flow*(5.196+2.8428+1.0044+0.9612+0.3624+0.1584);
  parameter Real l(min=1e-10, max=1) = 0.0001
    "Damper leakage, ratio of flow coefficients k(y=0)/k(y=1)"
    annotation(Dialog(tab="Damper coefficients"));
  Buildings.Fluid.FixedResistances.Junction spl34(
    redeclare package Medium = Medium,
    m_flow_nominal=scaM_flow*{1,-1,-1},
    dp_nominal={0.176,-0.844,-0.0662},
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    annotation (
    Placement(transformation(extent={{-30,110},{-10,130}})));
  Buildings.Fluid.FixedResistances.Junction mix55(
    redeclare package Medium = Medium,
    m_flow_nominal=scaM_flow*{-1,1,1},
    dp_nominal=1E3*{-0.263200E-02,0.999990E-03,0.649000E-03},
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)  annotation (
      Placement(transformation(extent={{-30,-30},{-10,-50}})));
  Buildings.Fluid.FixedResistances.PressureDrop res13(
    m_flow_nominal=scaM_flow*1,
    dp_nominal=0.1E3,
    redeclare package Medium = Medium) annotation (
      Placement(transformation(extent={{0,10},{20,30}})));
  Buildings.Fluid.FixedResistances.PressureDrop res14(
    m_flow_nominal=scaM_flow*1,
    dp_nominal=0.1E3,
    redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{60,10},{80,30}})));
  Buildings.Fluid.FixedResistances.PressureDrop res15(
    m_flow_nominal=scaM_flow*1,
    dp_nominal=0.1E3,
    redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{120,10},{140,30}})));
  Buildings.Fluid.FixedResistances.PressureDrop res16(
    m_flow_nominal=scaM_flow*1,
    dp_nominal=0.1E3,
    redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{180,10},{200,30}})));
  Buildings.Fluid.FixedResistances.PressureDrop res17(
    m_flow_nominal=scaM_flow*1,
    dp_nominal=0.1E3,
    redeclare package Medium = Medium) annotation (
      Placement(transformation(extent={{240,10},{260,30}})));
  Buildings.Fluid.FixedResistances.Junction spl35(
    redeclare package Medium = Medium,
    m_flow_nominal=scaM_flow*{1,-1,-1},
    dp_nominal=1E3*{0.371000E-04,-0.259000E-02,-0.131000E-02},
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    annotation (Placement(transformation(extent={{30,110},{50,130}})));
  Buildings.Fluid.FixedResistances.Junction spl36(
    redeclare package Medium = Medium,
    m_flow_nominal=scaM_flow*{1,-1,-1},
    dp_nominal=1E3*{0.211000E-03,-0.128000E-01,-0.223000E-02},
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    annotation (Placement(transformation(extent={{90,110},{110,130}})));
  Buildings.Fluid.FixedResistances.Junction spl37(
    redeclare package Medium = Medium,
    m_flow_nominal=scaM_flow*{1,-1,-1},
    dp_nominal=1E3*{0.730000E-03,-0.128000E-01,-0.938000E-02},
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    annotation (Placement(transformation(extent={{150,110},{170,130}})));
  Buildings.Fluid.FixedResistances.Junction spl38(
    redeclare package Medium = Medium,
    m_flow_nominal=scaM_flow*{1,-1,-1},
    dp_nominal=1E3*{0.731000E-02,-0.895000E-01,-0.942000E-01},
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    annotation (Placement(transformation(extent={{210,110},{230,130}})));
  Buildings.Fluid.FixedResistances.Junction mix54(
    redeclare package Medium = Medium,
    m_flow_nominal=scaM_flow*{-1,1,1},
    dp_nominal=1E3*{-0.653000E-02,0.271000E-03,0.402000E-04},
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    annotation (Placement(transformation(extent={{30,-30},{50,-50}})));
  Buildings.Fluid.FixedResistances.Junction mix53(
    redeclare package Medium = Medium,
    m_flow_nominal=scaM_flow*{-1,1,1},
    dp_nominal=1E3*{-0.566000E-01,0.541000E-02,0.749000E-04},
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    annotation (Placement(transformation(extent={{90,-30},{110,-50}})));
  Buildings.Fluid.FixedResistances.Junction mix52(
    redeclare package Medium = Medium,
    m_flow_nominal=scaM_flow*{-1,1,1},
    dp_nominal=1E3*{-0.353960,0.494000E-03,0.922000E-03},
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)  annotation (
      Placement(transformation(extent={{150,-30},{170,-50}})));
  Buildings.Fluid.FixedResistances.Junction mix51(
    redeclare package Medium = Medium,
    m_flow_nominal=scaM_flow*{-1,1,1},
    dp_nominal=1E3*{-0.847600E-01,1.89750,0.150000E-02},
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    annotation (Placement(transformation(extent={{210,-30},{230,-50}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_bExh(
    redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-110,-50},{-90,-30}})));
  Buildings.Fluid.FixedResistances.PressureDrop res1(
    m_flow_nominal=scaM_flow*1,
    dp_nominal=0.1E3,
    redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  RoomVAV roo45(
    redeclare package Medium = Medium,
    ADam=scaM_flow*0.49,
    m_flow_nominal=scaM_flow*5.196,
    VRoo=1820,
    VPle=396,
    final l=l) "Room model"
    annotation (Placement(transformation(extent={{-30,10},{-10,30}})));
  RoomVAV roo46(
    redeclare package Medium = Medium,
    ADam=scaM_flow*0.245,
    m_flow_nominal=scaM_flow*2.8428,
    VRoo=1210,
    VPle=330,
    final l=l) "Room model"
    annotation (Placement(transformation(extent={{30,10},{50,30}})));
  RoomVAV roo47(
    redeclare package Medium = Medium,
    ADam=scaM_flow*0.128,
    m_flow_nominal=scaM_flow*1.0044,
    VRoo=647,
    VPle=125,
    final l=l) "Room model"
    annotation (Placement(transformation(extent={{90,10},{110,30}})));
  RoomVAV roo48(
    redeclare package Medium = Medium,
    ADam=scaM_flow*0.128,
    m_flow_nominal=scaM_flow*0.9612,
    VRoo=385,
    VPle=107,
    final l=l) "Room model"
    annotation (Placement(transformation(extent={{150,10},{170,30}})));
  RoomVAV roo49(
    redeclare package Medium = Medium,
    ADam=scaM_flow*0.0494,
    m_flow_nominal=scaM_flow*0.3624,
    VRoo=48,
    VPle=13,
    final l=l) "Room model"
    annotation (Placement(transformation(extent={{210,10},{230,30}})));
  RoomVAV roo50(
    redeclare package Medium = Medium,
    ADam=scaM_flow*0.024,
    m_flow_nominal=scaM_flow*0.1584,
    VRoo=155,
    VPle=43,
    final l=l) "Room model"
    annotation (Placement(transformation(extent={{270,10},{290,30}})));
  Occupancy occ "Occupancy"
  annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  Buildings.Fluid.Sensors.RelativePressure dpMea(
      redeclare package Medium = Medium) "Static pressure measurement"
    annotation (Placement(transformation(extent={{-192,-110},{-212,-90}},
                                                                   rotation=90,
        origin={108,302})));
  Modelica.Blocks.Interfaces.RealOutput p_rel "Relative pressure signal"
    annotation (Placement(transformation(extent={{300,110},{320,90}})));
  Modelica.Blocks.Interfaces.RealOutput yDam[6] "VAV damper positions"
    annotation (Placement(transformation(extent={{300,70},{320,50}})));
  Buildings.Fluid.Sensors.Pressure pRoo(redeclare package Medium = Medium)
    "Room pressure"
    annotation (Placement(transformation(extent={{234,140},{254,160}})));
  Modelica.Blocks.Math.Feedback feeBac
    annotation (Placement(transformation(extent={{262,160},{282,180}})));
  Modelica.Blocks.Interfaces.RealOutput dPRoo "Room pressurization"
    annotation (Placement(transformation(extent={{300,180},{320,160}})));
equation
  connect(spl38.port_2, roo50.portSup) annotation (
    Line(
    points={{230,120},{280,120},{280,30}}));
  connect(port_aSup, spl34.port_1) annotation (Line(
      points={{-100,120},{-30,120}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(spl34.port_2, spl35.port_1) annotation (Line(
      points={{-10,120},{30,120}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(spl35.port_2, spl36.port_1) annotation (Line(
      points={{50,120},{90,120}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(spl36.port_2, spl37.port_1) annotation (Line(
      points={{110,120},{150,120}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(spl37.port_2, spl38.port_1) annotation (Line(
      points={{170,120},{210,120}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(dpMea.port_a, spl38.port_1) annotation (Line(
      points={{208,110},{208,120},{210,120},{210,120}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pRoo.p, feeBac.u2) annotation (Line(
      points={{255,150},{272,150},{272,162}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(roo50.portRoo2, pRoo.port) annotation (Line(
      points={{290,20},{290,20},{292,20},{292,140},{244,140}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(spl34.port_3, roo45.portSup) annotation (Line(
      points={{-20,110},{-20,30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(spl35.port_3, roo46.portSup) annotation (Line(
      points={{40,110},{40,30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(spl36.port_3, roo47.portSup) annotation (Line(
      points={{100,110},{100,30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(spl37.port_3, roo48.portSup) annotation (Line(
      points={{160,110},{160,30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(spl38.port_3, roo49.portSup) annotation (Line(
      points={{220,110},{220,30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(dpMea.port_b, res16.port_b) annotation (Line(
      points={{208,90},{208,56},{208,56},{208,20},{200,20},{200,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(p, feeBac.u1) annotation (Line(
      points={{-118,180},{240,180},{240,170},{264,170}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dPRoo, feeBac.y) annotation (Line(
      points={{310,170},{281,170}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dpMea.p_rel, p_rel) annotation (Line(
      points={{217,100},{310,100}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(roo45.yDam, yDam[1]) annotation (Line(
      points={{-9.375,25},{-2,25},{-2,68.3333},{310,68.3333}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(roo46.yDam, yDam[2]) annotation (Line(
      points={{50.625,25},{56,25},{56,65},{310,65}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(roo47.yDam, yDam[3]) annotation (Line(
      points={{110.625,25},{114,25},{114,61.6667},{310,61.6667}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(roo48.yDam, yDam[4]) annotation (Line(
      points={{170.625,25},{176,25},{176,58.3333},{310,58.3333}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(roo49.yDam, yDam[5]) annotation (Line(
      points={{230.625,25},{236,25},{236,55},{310,55}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(roo50.yDam, yDam[6]) annotation (Line(
      points={{290.625,25},{310,25},{310,51.6667}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(occ.y1[1], roo45.nPeo) annotation (Line(
      points={{-59,-3.5},{-48,-3.5},{-48,-2},{-36,-2},{-36,16.25},{-31.125,16.25}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(occ.y1[2], roo46.nPeo) annotation (Line(
      points={{-59,-2.5},{24,-2.5},{24,16.25},{28.875,16.25}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(occ.y2[1], roo47.nPeo) annotation (Line(
      points={{-59,-10.5},{84,-10.5},{84,16.25},{88.875,16.25}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(occ.y2[2], roo48.nPeo) annotation (Line(
      points={{-59,-9.5},{144,-9.5},{144,16.25},{148.875,16.25}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(occ.y3[1], roo49.nPeo) annotation (Line(
      points={{-59,-17.5},{72,-18},{204,-18},{204,16.25},{208.875,16.25}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(occ.y3[2], roo50.nPeo) annotation (Line(
      points={{-59,-16.5},{106,-18},{264,-18},{264,16.25},{268.875,16.25}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(port_bExh, mix55.port_1) annotation (Line(
      points={{-100,-40},{-30,-40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(mix55.port_2, mix54.port_1) annotation (Line(
      points={{-10,-40},{30,-40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(mix54.port_2, mix53.port_1) annotation (Line(
      points={{50,-40},{90,-40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(mix53.port_2, mix52.port_1) annotation (Line(
      points={{110,-40},{150,-40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(mix52.port_2, mix51.port_1) annotation (Line(
      points={{170,-40},{210,-40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(mix51.port_2, roo50.portRet) annotation (Line(
      points={{230,-40},{280,-40},{280,10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(roo48.portRet, mix51.port_3) annotation (Line(
      points={{160,10},{160,-4},{220,-4},{220,-30}},
      color={0,127,255},
      smooth=Smooth.Bezier));
  connect(mix52.port_3, roo49.portRet) annotation (Line(
      points={{160,-30},{160,-10},{220,-10},{220,10}},
      color={0,127,255},
      smooth=Smooth.Bezier));
  connect(roo47.portRet, mix53.port_3) annotation (Line(
      points={{100,10},{100,-30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(roo46.portRet, mix54.port_3) annotation (Line(
      points={{40,10},{40,-30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(roo45.portRet, mix55.port_3) annotation (Line(
      points={{-20,10},{-20,-30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(res1.port_b, roo45.portRoo1) annotation (Line(
      points={{-40,20},{-30,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(roo45.portRoo2, res13.port_a) annotation (Line(
      points={{-10,20},{-5.55112e-16,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(res13.port_b, roo46.portRoo1) annotation (Line(
      points={{20,20},{30,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(roo46.portRoo2, res14.port_a) annotation (Line(
      points={{50,20},{60,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(res14.port_b, roo47.portRoo1) annotation (Line(
      points={{80,20},{90,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(roo47.portRoo2, res15.port_a) annotation (Line(
      points={{110,20},{120,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(res15.port_b, roo48.portRoo1) annotation (Line(
      points={{140,20},{150,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(roo48.portRoo2, res16.port_a) annotation (Line(
      points={{170,20},{180,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(res16.port_b, roo49.portRoo1) annotation (Line(
      points={{200,20},{210,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(roo49.portRoo2, res17.port_a) annotation (Line(
      points={{230,20},{240,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(res17.port_b, roo50.portRoo1) annotation (Line(
      points={{260,20},{270,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(roo50.portRoo2, res1.port_a) annotation (Line(
      points={{290,20},{292,20},{292,40},{-72,40},{-72,20},{-60,20}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -60},{300,200}})),
                       Icon(
      coordinateSystem(extent={{-100,-60},{300,200}}),
      graphics={
      Rectangle(extent={{-98,-38},{284,-42}},
          fillColor={0,127,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
      Rectangle(extent={{-102,122},{284,118}},
          fillColor={0,127,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
      Rectangle(extent={{-18,22},{284,18}},
          fillColor={0,127,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
      Rectangle(extent={{-20,118},{-16,-38}},
          fillColor={0,127,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
      Rectangle(extent={{40,118},{44,-38}},
          fillColor={0,127,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
      Rectangle(extent={{102,118},{106,-38}},
          fillColor={0,127,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
      Rectangle(extent={{160,118},{164,20}},
          fillColor={0,127,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
      Rectangle(extent={{220,120},{224,22}},
          fillColor={0,127,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
      Rectangle(extent={{220,-20},{224,-38}},
          fillColor={0,127,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
      Rectangle(extent={{160,-8},{ 164,-38}},
          fillColor={0,127,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
      Rectangle(extent={{220,18},{224,-10}},
          fillColor={0,127,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
      Rectangle(extent={{160,20},{ 164,0}},
          fillColor={0,127,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
      Rectangle(extent={{162,4},{ 194,0}},
          fillColor={0,127,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
      Rectangle(extent={{190,-18},{224,-22}},
          fillColor={0,127,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
      Rectangle(extent={{160,-8},{ 224,-12}},
          fillColor={0,127,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
      Rectangle(extent={{190,2},{ 194,-20}},
          fillColor={0,127,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
      Text(
        extent={{-140,234},{-96,192}},
        textString="PAtm"),
      Line(points={{-136,180},{190,180},{252,180}}),
      Line(points={{192,180},{192,40},{222,20}}),
      Rectangle(extent={{-26,80},{-10,60}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
      Line(points={{132,180},{132,40},{162,20}}),
      Line(points={{72,180},{72,40},{102,20}}),
      Line(points={{12,180},{12,40},{42,20}}),
      Line(points={{-48,180},{-48,40},{-18,20}}),
      Rectangle(extent={{280,120},{284,-40}},
          fillColor={0,127,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
      Line(points={{252,180},{252,40},{282,20}}),
      Text(
        extent={{296,158},{340,84}},
        textString="dPSup"),
      Text(
        extent={{38,222},{166,190}},
        textString="%name"),
      Text(
        extent={{298,66},{ 342,-8}},
        textString="yDam"),
      Text(
        extent={{296,230},{340,156}},
        textString="dPRoo"),
      Rectangle(extent={{34,80},{50,60}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
      Rectangle(extent={{154,80},{170,60}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
      Rectangle(extent={{96,80},{112,60}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
      Rectangle(extent={{274,80},{290,60}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
      Rectangle(extent={{214,80},{230,60}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
      Rectangle(extent={{-34,34},{0,8}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
      Rectangle(extent={{-30,30},{-4,12}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
      Rectangle(extent={{146,34},{180,8}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
      Rectangle(extent={{150,30},{176,12}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
      Rectangle(extent={{206,34},{240,8}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
      Rectangle(extent={{210,30},{236,12}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
      Rectangle(extent={{262,34},{296,8}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
      Rectangle(extent={{266,30},{292,12}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
      Rectangle(extent={{86,34},{120,8}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
      Rectangle(extent={{90,30},{116,12}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
      Rectangle(extent={{24,34},{58,8}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
      Rectangle(extent={{28,30},{54,12}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),
    Documentation(info="<html>
<p>
Model of a suite consisting of five rooms for the MIT system model.
</p></html>", revisions="<html>
<ul>
<li>
June 12, 2019, by Michael Wetter:<br/>
Removed control volume in all junctions, as this leads to much faster simulation
in JModelica.
</li>
<li>
January 22, 2016, by Michael Wetter:<br/>
Corrected type declaration of pressure difference.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/404\">#404</a>.
</li>
<li>
July 20, 2007 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Suite;
