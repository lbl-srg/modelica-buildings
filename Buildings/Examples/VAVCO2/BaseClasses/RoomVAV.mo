within Buildings.Examples.VAVCO2.BaseClasses;
model RoomVAV "Model for CO2 emitted by people"
  replaceable package Medium =
      Modelica.Media.Interfaces.PartialMedium "Medium in the component";
  replaceable model MotorModel = Buildings.Fluid.Actuators.Motors.IdealMotor(delta=0.02, tOpe=60);
  Fluid.Actuators.Dampers.VAVBoxExponential vav(
    redeclare package Medium = Medium,
    A=ADam,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=1E2,
    allowFlowReversal=false,
    from_dp=false)
    annotation (extent=[-10,60; 10,80], rotation=270);
  Buildings.Fluid.MixingVolumes.MixingVolume vol(
    redeclare package Medium = Medium,
    V=VRoo,
    nPorts=6,
    m_flow_nominal=m_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial) "Room volume"
                          annotation (extent=[-10,-10; 10,10], Placement(
        transformation(extent={{-10,0},{10,20}})));
  Buildings.Fluid.Sensors.TraceSubstances senCO2(       redeclare package
      Medium =
        Medium) "Sensor at volume"
    annotation (extent=[14,20; 34,40], Placement(transformation(extent={{16,20},
            {36,40}})));
  Buildings.Fluid.Sources.TraceSubstancesFlowSource sou(redeclare package
      Medium =         Medium, use_m_flow_in=true,
    nPorts=1) "CO2 source"
    annotation (extent=[-98,-70; -78,-50], Placement(transformation(extent={{-100,
            -70},{-80,-50}})));
  parameter Modelica.SIunits.Volume VRoo "Volume of room";
  Buildings.Fluid.MixingVolumes.MixingVolume ple(
    redeclare package Medium = Medium,
    V=VPle,
    nPorts=2,
    m_flow_nominal=m_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial) "Plenum volume"
                          annotation (extent=[-10,-70; 10,-50], Placement(
        transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-10,-60})));
  parameter Modelica.SIunits.Volume VPle "Volume of plenum";
  Modelica.Fluid.Interfaces.FluidPort_a portRoo1(redeclare package Medium =
        Medium) "Fluid port"
                     annotation (extent=[-170,-10; -150,10]);
  Modelica.Fluid.Interfaces.FluidPort_a portSup(redeclare package Medium =
        Medium) "Fluid port"
                     annotation (extent=[-8,150; 12,170], Placement(
        transformation(extent={{-10,150},{10,170}})));
  Modelica.Fluid.Interfaces.FluidPort_a portRet(redeclare package Medium =
        Medium) "Fluid port"
                     annotation (extent=[-8,-170; 12,-150], Placement(
        transformation(extent={{-10,-170},{10,-150}})));
  Modelica.Fluid.Interfaces.FluidPort_a portRoo2(redeclare package Medium =
        Medium) "Fluid port"
                     annotation (extent=[150,-10; 170,10]);
  Modelica.Blocks.Interfaces.RealOutput yDam "Damper control signal"
    annotation (extent=[160,70; 180,90]);
  parameter Modelica.SIunits.Area ADam "Damper face area";
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Nominal mass flow rate";
  Modelica.Blocks.Interfaces.RealInput nPeo "Number of people"
    annotation (extent=[-198,-80; -158,-40]);
  Modelica.Blocks.Math.Gain gaiCO2(k=8.18E-6) "CO2 emission per person"
    annotation (extent=[-140,-70; -120,-50], Placement(transformation(extent={{-138,
            -70},{-118,-50}})));
  Fluid.Sensors.Conversions.To_VolumeFraction volFraCO2(
                                                   MMMea=Modelica.Media.
        IdealGases.Common.SingleGasesData.CO2.MM) "CO2 volume fraction"
    annotation (extent=[40,20; 60,40], Placement(transformation(extent={{60,20},
            {80,40}})));
  DamperControl con(Kp=1) "Damper controller"
                                          annotation (extent=[72,20; 92,40],
      Placement(transformation(extent={{100,20},{120,40}})));
  Modelica.Blocks.Math.Gain peoDen(k=2.5/VRoo) "People density per m2"
    annotation (extent=[-120,-120; -100,-100]);
  //res(dp_nominal=5, m_flow_nominal=1.2/3600))
  Modelica.Blocks.Sources.RealExpression vavACH(y=vav.m_flow*3600/VRoo/1.2)
    "VAV box air change per hour"
    annotation (extent=[-124,34; -100,54]);
  Fluid.FixedResistances.FixedResistanceDpM dpPle(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=20,
    from_dp=true,
    allowFlowReversal=false)
                   annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,-30})));
equation
  connect(gaiCO2.y, sou.m_flow_in) annotation (Line(
      points={{-117,-60},{-102.1,-60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(senCO2.C, volFraCO2.m) annotation (Line(
      points={{37,30},{59,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(volFraCO2.V, con.u) annotation (Line(
      points={{81,30},{98,30}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(con.y, yDam) annotation (Line(
      points={{121,30},{140,30},{140,80},{170,80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(con.y, vav.y) annotation (Line(
      points={{121,30},{140,30},{140,70},{12,70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ple.ports[1], portRet) annotation (Line(
      points={{4.44089e-16,-62},{4.44089e-16,-83.5},{1.27676e-15,-83.5},{
          1.27676e-15,-109},{5.55112e-16,-109},{5.55112e-16,-160}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(nPeo, gaiCO2.u) annotation (Line(
      points={{-178,-60},{-140,-60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(nPeo, peoDen.u) annotation (Line(
      points={{-178,-60},{-148,-60},{-148,-110},{-122,-110}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(portSup, vav.port_a) annotation (Line(
      points={{5.55112e-16,160},{5.55112e-16,80},{2.44753e-15,80}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(portRoo1, vol.ports[1]) annotation (Line(
      points={{-160,5.55112e-16},{-120.833,5.55112e-16},{-120.833,4.87687e-22},
          {-81.6667,4.87687e-22},{-81.6667,-5.55112e-16},{-3.33333,-5.55112e-16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(vav.port_b, vol.ports[2]) annotation (Line(
      points={{-1.22629e-15,60},{0,60},{0,40},{-22,40},{-22,-5.55112e-16},{-2,
          -5.55112e-16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senCO2.port, vol.ports[3]) annotation (Line(
      points={{26,20},{26,-5.55112e-16},{-0.666667,-5.55112e-16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(portRoo2, vol.ports[4]) annotation (Line(
      points={{160,5.55112e-16},{120.167,5.55112e-16},{120.167,4.87687e-22},{
          80.3333,4.87687e-22},{80.3333,-5.55112e-16},{0.666667,-5.55112e-16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou.ports[1], vol.ports[5]) annotation (Line(
      points={{-80,-60},{-40,-60},{-40,-5.55112e-16},{2,-5.55112e-16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(dpPle.port_a, vol.ports[6]) annotation (Line(
      points={{2.44753e-15,-20},{3.33333,-20},{3.33333,-5.55112e-16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(dpPle.port_b, ple.ports[2]) annotation (Line(
      points={{-1.22629e-15,-40},{-1.22629e-15,-47},{7.21645e-16,-47},{
          7.21645e-16,-58}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-160,-160},{160,
            160}})),
    Icon(
      coordinateSystem(extent={{-160,-160},{160,160}}),
      Rectangle(extent=[-132,90; 130,-112], style(
          color=0,
          rgbcolor={0,0,0},
          fillColor=0,
          rgbfillColor={0,0,0})),
      Rectangle(extent=[-120,80; 120,-100], style(
          color=0,
          rgbcolor={0,0,0},
          fillColor=30,
          rgbfillColor={215,215,215})),
      Rectangle(extent=[-160,6; -120,-6], style(
          color=0,
          rgbcolor={0,0,0},
          fillColor=74,
          rgbfillColor={0,0,127},
          fillPattern=1)),
      Rectangle(extent=[120,6; 160,-6], style(
          color=0,
          rgbcolor={0,0,0},
          fillColor=74,
          rgbfillColor={0,0,127},
          fillPattern=1)),
      Rectangle(extent=[-4,-100; 6,-158], style(
          color=0,
          rgbcolor={0,0,0},
          fillColor=74,
          rgbfillColor={0,0,127},
          fillPattern=1)),
      Rectangle(extent=[-4,160; 6,80], style(
          color=0,
          rgbcolor={0,0,0},
          fillColor=74,
          rgbfillColor={0,0,127},
          fillPattern=1)),
      Text(
        extent=[-206,182; -92,136],
        style(
          color=0,
          rgbcolor={0,0,0},
          fillColor=74,
          rgbfillColor={0,0,127},
          fillPattern=1),
        string="PAtm"),
      Text(
        extent=[42,144; 154,100],
        style(
          color=0,
          rgbcolor={0,0,0},
          fillColor=74,
          rgbfillColor={0,0,127},
          fillPattern=1),
        string="yDam"),
      Text(
        extent=[-76,-6; 60,-104],
        style(
          color=0,
          rgbcolor={0,0,0},
          fillColor=74,
          rgbfillColor={0,0,127},
          fillPattern=1),
        string="%name"),
      Text(
        extent=[-208,-80; -134,-140],
        style(
          color=0,
          rgbcolor={0,0,0},
          fillColor=74,
          rgbfillColor={0,0,127},
          fillPattern=1),
        string="occ")));
end RoomVAV;
