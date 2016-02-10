within Buildings.Examples.VAVCO2.BaseClasses;
model Suite "Model of a suite consisting of five rooms of the MIT system model"
  replaceable package Medium =
      Modelica.Media.Interfaces.PartialMedium "Medium in the component";
  Modelica.Blocks.Interfaces.RealInput p "Pressure"
    annotation (extent=[-138,160; -98,200]);
  Modelica.Fluid.Interfaces.FluidPort_b port_aSup(redeclare package Medium =
        Medium)                 annotation (extent=[-110,110; -90,130]);
  parameter Real scaM_flow "Scaling factor for mass flow rate";
  parameter Modelica.SIunits.MassFlowRate m0Tot_flow=
scaM_flow*(5.196+2.8428+1.0044+0.9612+0.3624+0.1584);
  Buildings.Fluid.FixedResistances.SplitterFixedResistanceDpM spl34(
    redeclare package Medium = Medium,
    m_flow_nominal=scaM_flow*{1,-1,-1},
    dp_nominal={0.176,-0.844,-0.0662},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)     annotation (extent=[-30,110;
        -10,130], Placement(transformation(extent={{-30,110},{-10,130}})));
  Buildings.Fluid.FixedResistances.SplitterFixedResistanceDpM mix55(
    redeclare package Medium = Medium,
    m_flow_nominal=scaM_flow*{-1,1,1},
    dp_nominal=1E3*{-0.263200E-02,0.999990E-03,0.649000E-03},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    annotation (extent=[-30,-30; -10,-50], Placement(transformation(extent={{
            -30,-30},{-10,-50}})));
  Buildings.Fluid.FixedResistances.FixedResistanceDpM res13(
                                      m_flow_nominal=scaM_flow*1, dp_nominal=0.1E3,
    redeclare package Medium = Medium)
    annotation (extent=[0,10; 20,30], Placement(transformation(extent={{0,10},{
            20,30}})));
  Buildings.Fluid.FixedResistances.FixedResistanceDpM res14(
                                      m_flow_nominal=scaM_flow*1, dp_nominal=0.1E3,
    redeclare package Medium = Medium)
    annotation (extent=[60,10; 80,30]);
  Buildings.Fluid.FixedResistances.FixedResistanceDpM res15(
                                      m_flow_nominal=scaM_flow*1, dp_nominal=0.1E3,
    redeclare package Medium = Medium)
    annotation (extent=[120,10; 140,30]);
  Buildings.Fluid.FixedResistances.FixedResistanceDpM res16(
                                      m_flow_nominal=scaM_flow*1, dp_nominal=0.1E3,
    redeclare package Medium = Medium)
    annotation (extent=[180,10; 200,30], Placement(transformation(extent={{180,
            10},{200,30}})));
  Buildings.Fluid.FixedResistances.FixedResistanceDpM res17(
                                      m_flow_nominal=scaM_flow*1, dp_nominal=0.1E3,
    redeclare package Medium = Medium)
    annotation (extent=[240,10; 260,30], Placement(transformation(extent={{240,
            10},{260,30}})));
  Buildings.Fluid.FixedResistances.SplitterFixedResistanceDpM spl35(
    redeclare package Medium = Medium,
    m_flow_nominal=scaM_flow*{1,-1,-1},
    dp_nominal=1E3*{0.371000E-04,-0.259000E-02,-0.131000E-02},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)     annotation (extent=[30,110;
        50,130]);
  Buildings.Fluid.FixedResistances.SplitterFixedResistanceDpM spl36(
    redeclare package Medium = Medium,
    m_flow_nominal=scaM_flow*{1,-1,-1},
    dp_nominal=1E3*{0.211000E-03,-0.128000E-01,-0.223000E-02},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)     annotation (extent=[90,110;
        110,130]);
  Buildings.Fluid.FixedResistances.SplitterFixedResistanceDpM spl37(
    redeclare package Medium = Medium,
    m_flow_nominal=scaM_flow*{1,-1,-1},
    dp_nominal=1E3*{0.730000E-03,-0.128000E-01,-0.938000E-02},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)     annotation (extent=[150,110;
        170,130]);
  Buildings.Fluid.FixedResistances.SplitterFixedResistanceDpM spl38(
    redeclare package Medium = Medium,
    m_flow_nominal=scaM_flow*{1,-1,-1},
    dp_nominal=1E3*{0.731000E-02,-0.895000E-01,-0.942000E-01},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)     annotation (extent=[210,110;
        230,130]);
  Buildings.Fluid.FixedResistances.SplitterFixedResistanceDpM mix54(
    redeclare package Medium = Medium,
    m_flow_nominal=scaM_flow*{-1,1,1},
    dp_nominal=1E3*{-0.653000E-02,0.271000E-03,0.402000E-04},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    annotation (extent=[30,-30; 50,-50]);
  Buildings.Fluid.FixedResistances.SplitterFixedResistanceDpM mix53(
    redeclare package Medium = Medium,
    m_flow_nominal=scaM_flow*{-1,1,1},
    dp_nominal=1E3*{-0.566000E-01,0.541000E-02,0.749000E-04},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    annotation (extent=[90,-30; 110,-50]);
  Buildings.Fluid.FixedResistances.SplitterFixedResistanceDpM mix52(
    redeclare package Medium = Medium,
    m_flow_nominal=scaM_flow*{-1,1,1},
    dp_nominal=1E3*{-0.353960,0.494000E-03,0.922000E-03},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    annotation (extent=[150,-30; 170,-50], Placement(transformation(extent={{
            150,-30},{170,-50}})));
  Buildings.Fluid.FixedResistances.SplitterFixedResistanceDpM mix51(
    redeclare package Medium = Medium,
    m_flow_nominal=scaM_flow*{-1,1,1},
    dp_nominal=1E3*{-0.847600E-01,1.89750,0.150000E-02},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    annotation (extent=[210,-30; 230,-50]);
  Modelica.Fluid.Interfaces.FluidPort_b port_bExh(redeclare package Medium =
        Medium)                 annotation (extent=[-110,-50; -90,-30]);
  Buildings.Fluid.FixedResistances.FixedResistanceDpM res1(
                                      m_flow_nominal=scaM_flow*1, dp_nominal=0.1E3,
    redeclare package Medium = Medium)
    annotation (extent=[-60,10; -40,30],   style(thickness=2));
  RoomVAV roo45(
    redeclare package Medium = Medium,
    ADam=scaM_flow*0.49,
    m_flow_nominal=scaM_flow*5.196,
    VRoo=1820,
    VPle=396) "Room model"      annotation (extent=[-30,10; -10,30], Placement(
        transformation(extent={{-30,10},{-10,30}})));
  RoomVAV roo46(
    redeclare package Medium = Medium,
    ADam=scaM_flow*0.245,
    m_flow_nominal=scaM_flow*2.8428,
    VRoo=1210,
    VPle=330) "Room model"       annotation (extent=[30,10; 50,30]);
  RoomVAV roo47(
    redeclare package Medium = Medium,
    ADam=scaM_flow*0.128,
    m_flow_nominal=scaM_flow*1.0044,
    VRoo=647,
    VPle=125) "Room model"       annotation (extent=[90,10; 110,30]);
  RoomVAV roo48(
    redeclare package Medium = Medium,
    ADam=scaM_flow*0.128,
    m_flow_nominal=scaM_flow*0.9612,
    VRoo=385,
    VPle=107) "Room model"       annotation (extent=[150,10; 170,30]);
  RoomVAV roo49(
    redeclare package Medium = Medium,
    ADam=scaM_flow*0.0494,
    m_flow_nominal=scaM_flow*0.3624,
    VRoo=48,
    VPle=13) "Room model"        annotation (extent=[210,10; 230,30]);
  RoomVAV roo50(
    redeclare package Medium = Medium,
    ADam=scaM_flow*0.024,
    m_flow_nominal=scaM_flow*0.1584,
    VRoo=155,
    VPle=43) "Room model"        annotation (extent=[270,10; 290,30]);
  Occupancy occ "Occupancy"        annotation (extent=[-80,-20; -60,0],
      Placement(transformation(extent={{-80,-20},{-60,0}})));
  Buildings.Fluid.Sensors.RelativePressure dpMea(
      redeclare package Medium = Medium) "Static pressure measurement"
    annotation (extent=[192,110; 212,90], rotation=90);
  Modelica.Blocks.Interfaces.RealOutput p_rel "Relative pressure signal"
                                                annotation (extent=[300,110;
        320,90]);
  Modelica.Blocks.Interfaces.RealOutput yDam[6] "VAV damper positions"
                                                annotation (extent=[300,70; 320,
        50]);
  Buildings.Fluid.Sensors.Pressure pRoo(redeclare package Medium = Medium)
    "Room pressure"
    annotation (extent=[234,140; 254,160], Placement(transformation(extent={{
            234,140},{254,160}})));
  Modelica.Blocks.Math.Feedback feeBac annotation (extent=[262,160; 282,180],
      Placement(transformation(extent={{262,160},{282,180}})));
  Modelica.Blocks.Interfaces.RealOutput dPRoo "Room pressurization"
                                                annotation (extent=[300,180;
        320,160]);
equation
  connect(spl38.port_2, roo50.portSup) annotation (points=[231,120; 280.125,120;
        280.125,30], style(color=69, rgbcolor={0,127,255}));
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
      points={{202,110},{202,120},{210,120}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pRoo.p, feeBac.u2) annotation (Line(
      points={{255,150},{272,150},{272,162}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(roo50.portRoo2, pRoo.port) annotation (Line(
      points={{290,20},{290,140},{244,140}},
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
      points={{202,90},{202,20},{200,20}},
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
      points={{211,100},{310,100}},
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
      points={{-59,-3.5},{-36,-3.5},{-36,16.25},{-31.125,16.25}},
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
      smooth=Smooth.None));
  connect(mix52.port_3, roo49.portRet) annotation (Line(
      points={{160,-30},{160,-10},{220,-10},{220,10}},
      color={0,127,255},
      smooth=Smooth.None));
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
      points={{290,20},{294,20},{294,4},{-70,4},{-70,20},{-60,20}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -60},{300,200}})),
                       Icon(
      coordinateSystem(extent={{-100,-60},{300,200}}),
      Rectangle(extent=[-98,-38; 284,-42],   style(
          color=69,
          gradient=2,
          fillColor=69)),
      Rectangle(extent=[-102,122; 284,118],  style(
          color=69,
          gradient=2,
          fillColor=69)),
      Rectangle(extent=[-18,22; 284,18],     style(
          color=69,
          gradient=2,
          fillColor=69)),
      Rectangle(extent=[-20,118; -16,-38],
                                         style(
          color=3,
          rgbcolor={0,0,255},
          gradient=1,
          fillColor=69,
          rgbfillColor={0,128,255})),
      Rectangle(extent=[40,118; 44,-38], style(
          color=3,
          rgbcolor={0,0,255},
          gradient=1,
          fillColor=69,
          rgbfillColor={0,128,255})),
      Rectangle(extent=[102,118; 106,-38], style(
          color=3,
          rgbcolor={0,0,255},
          gradient=1,
          fillColor=69,
          rgbfillColor={0,128,255})),
      Rectangle(extent=[160,118; 164,20], style(
          color=3,
          rgbcolor={0,0,255},
          gradient=1,
          fillColor=69,
          rgbfillColor={0,128,255})),
      Rectangle(extent=[220,120; 224,22], style(
          color=3,
          rgbcolor={0,0,255},
          gradient=1,
          fillColor=69,
          rgbfillColor={0,128,255})),
      Rectangle(extent=[220,-20; 224,-38], style(
          color=3,
          rgbcolor={0,0,255},
          gradient=1,
          fillColor=69,
          rgbfillColor={0,128,255})),
      Rectangle(extent=[160,-8; 164,-38], style(
          color=3,
          rgbcolor={0,0,255},
          gradient=1,
          fillColor=69,
          rgbfillColor={0,128,255})),
      Rectangle(extent=[220,18; 224,-10], style(
          color=3,
          rgbcolor={0,0,255},
          gradient=1,
          fillColor=69,
          rgbfillColor={0,128,255})),
      Rectangle(extent=[160,20; 164,0], style(
          color=3,
          rgbcolor={0,0,255},
          gradient=1,
          fillColor=69,
          rgbfillColor={0,128,255})),
      Rectangle(extent=[162,4; 194,0],       style(
          color=69,
          gradient=2,
          fillColor=69)),
      Rectangle(extent=[190,-18; 224,-22],   style(
          color=69,
          gradient=2,
          fillColor=69)),
      Rectangle(extent=[160,-8; 224,-12],    style(
          color=69,
          gradient=2,
          fillColor=69)),
      Rectangle(extent=[190,2; 194,-20], style(
          color=3,
          rgbcolor={0,0,255},
          gradient=1,
          fillColor=69,
          rgbfillColor={0,128,255})),
      Text(
        extent=[-140,234; -96,192],
        style(color=3, rgbcolor={0,0,255}),
        string="PAtm"),
      Line(points=[-136,180; 190,180; 252,180],style(color=3, rgbcolor={0,0,255})),
      Line(points=[192,180; 192,40; 222,20], style(color=3, rgbcolor={0,0,255})),
      Rectangle(extent=[216,78; 230,58], style(
          color=3,
          rgbcolor={0,0,255},
          fillColor=74,
          rgbfillColor={0,0,127})),
      Rectangle(extent=[156,78; 170,58], style(
          color=3,
          rgbcolor={0,0,255},
          fillColor=74,
          rgbfillColor={0,0,127})),
      Rectangle(extent=[96,78; 110,58],  style(
          color=3,
          rgbcolor={0,0,255},
          fillColor=74,
          rgbfillColor={0,0,127})),
      Rectangle(extent=[34,78; 48,58], style(
          color=3,
          rgbcolor={0,0,255},
          fillColor=74,
          rgbfillColor={0,0,127})),
      Rectangle(extent=[-26,78; -12,58],
                                       style(
          color=3,
          rgbcolor={0,0,255},
          fillColor=74,
          rgbfillColor={0,0,127})),
      Line(points=[132,180; 132,40; 162,20], style(color=3, rgbcolor={0,0,255})),
      Line(points=[72,180; 72,40; 102,20],   style(color=3, rgbcolor={0,0,255})),
      Line(points=[12,180; 12,40; 42,20], style(color=3, rgbcolor={0,0,255})),
      Line(points=[-48,180; -48,40; -18,20],style(color=3, rgbcolor={0,0,255})),
      Rectangle(extent=[280,120; 284,-40],style(
          color=3,
          rgbcolor={0,0,255},
          gradient=1,
          fillColor=69,
          rgbfillColor={0,128,255})),
      Rectangle(extent=[276,78; 290,58], style(
          color=3,
          rgbcolor={0,0,255},
          fillColor=74,
          rgbfillColor={0,0,127})),
      Line(points=[252,180; 252,40; 282,20], style(color=3, rgbcolor={0,0,255})),
      Text(
        extent=[296,158; 340,84],
        style(color=3, rgbcolor={0,0,255}),
        string="dPSup"),
      Text(
        extent=[38,222; 166,190],
        style(color=3, rgbcolor={0,0,255}),
        string="%name"),
      Text(
        extent=[298,66; 342,-8],
        style(color=3, rgbcolor={0,0,255}),
        string="yDam"),
      Text(
        extent=[296,230; 340,156],
        style(color=3, rgbcolor={0,0,255}),
        string="dPRoo")),
    Documentation(info="<html>
<p>
Model of a suite consisting of five rooms for the MIT system model.
</p></html>", revisions="<html>
<ul>
<li>
January 22, 2016, by Michael Wetter:<br/>
Corrected type declaration of pressure difference.
This is
for <a href=\"https://github.com/iea-annex60/modelica-annex60/issues/404\">#404</a>.
</li>
<li>
July 20, 2007 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Suite;
