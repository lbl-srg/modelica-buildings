within Buildings.Airflow.Multizone.Examples;
model ReverseBuoyancy
  package Medium = Buildings.Media.IdealGases.SimpleAir;
  Buildings.Fluid.MixingVolumes.MixingVolume volEas(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    V=2.5*5*5,
    T_start=273.15 + 25,
    nPorts=5) annotation (Placement(transformation(extent={{-34,-30},{-14,-10}},
          rotation=0)));
  Buildings.Airflow.Multizone.Orifice oriOutBot(
    redeclare package Medium = Medium,
    m=0.5,
    A=0.01,
    dp_turbulent=0.1) annotation (Placement(transformation(extent={{38,-86},{58,
            -66}}, rotation=0)));
  Buildings.Airflow.Multizone.MediumColumn colOutTop(
    redeclare package Medium = Medium,
    h=1.5,
    density=Buildings.Airflow.Multizone.Types.densitySelection.fromBottom)
    annotation (Placement(transformation(extent={{97,-34},{117,-14}}, rotation=
            0)));
  Buildings.Airflow.Multizone.Orifice oriOutTop(
    redeclare package Medium = Medium,
    m=0.5,
    A=0.01,
    dp_turbulent=0.1) annotation (Placement(transformation(extent={{37,-10},{57,
            10}}, rotation=0)));
  Buildings.Airflow.Multizone.MediumColumn colEasInTop(
    redeclare package Medium = Medium,
    h=1.5,
    density=Buildings.Airflow.Multizone.Types.densitySelection.fromBottom)
    annotation (Placement(transformation(extent={{-1,-30},{19,-10}},rotation=0)));
  Buildings.Fluid.MixingVolumes.MixingVolume volOut(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    V=1E12,
    T_start=273.15 + 15,
    nPorts=3) annotation (Placement(transformation(extent={{123,-38},{143,-18}},
          rotation=0)));
  Buildings.Airflow.Multizone.Orifice dummy(
    redeclare package Medium = Medium,
    m=1,
    A=100,
    dp_turbulent=0.1) "to fix absolute pressure" annotation (Placement(
        transformation(extent={{148,-60},{168,-40}}, rotation=0)));
  Buildings.Airflow.Multizone.MediumColumn colEasInBot(
    redeclare package Medium = Medium,
    h=1.5,
    density=Buildings.Airflow.Multizone.Types.densitySelection.fromTop)
    annotation (Placement(transformation(extent={{8,-86},{28,-66}}, rotation=0)));
  Buildings.Airflow.Multizone.MediumColumn colOutBot(
    redeclare package Medium = Medium,
    h=1.5,
    density=Buildings.Airflow.Multizone.Types.densitySelection.fromTop)
    annotation (Placement(transformation(extent={{100,-90},{120,-70}}, rotation
          =0)));
  MediumColumn colWesBot(
    redeclare package Medium = Medium,
    h=1.5,
    density=Buildings.Airflow.Multizone.Types.densitySelection.fromBottom)
    annotation (Placement(transformation(extent={{-124,1},{-104,21}}, rotation=
            0)));
  Buildings.Airflow.Multizone.Orifice oriWesTop(
    redeclare package Medium = Medium,
    m=0.5,
    A=0.01,
    dp_turbulent=0.1) annotation (Placement(transformation(
        origin={-114,47},
        extent={{-10,-10},{10,10}},
        rotation=270)));
  Buildings.Airflow.Multizone.MediumColumn colWesTop(
    redeclare package Medium = Medium,
    h=1.5,
    density=Buildings.Airflow.Multizone.Types.densitySelection.fromTop)
    annotation (Placement(transformation(extent={{-124,73},{-104,93}},rotation=
            0)));
  Buildings.Airflow.Multizone.DoorDiscretizedOperable dooOpeClo(
    redeclare package Medium = Medium,
    LClo=20*1E-4,
    wOpe=1,
    hOpe=2.2,
    hA=3/2,
    hB=3/2,
    CDOpe=0.78,
    CDClo=0.78,
    nCom=10,
    vZer=0.01,
    dp_turbulent=0.1) "Discretized door" annotation (Placement(transformation(
          extent={{-61,-55},{-41,-35}}, rotation=0)));
  Buildings.Fluid.Delays.DelayFirstOrder volWes(
    redeclare package Medium = Medium,
    m_flow_nominal=1.2,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    tau=2.5*5*5,
    p_start=101325,
    T_start=273.15 + 22,
    nPorts=3) annotation (Placement(transformation(extent={{-161,-29},{-141,-9}},
          rotation=0)));
  Modelica.Blocks.Sources.Constant ope(k=1) annotation (Placement(
        transformation(extent={{-102,-23},{-82,-3}}, rotation=0)));
  Buildings.Airflow.Multizone.MediumColumn col1EasBot(
    redeclare package Medium = Medium,
    h=1.5,
    density=Buildings.Airflow.Multizone.Types.densitySelection.fromBottom)
    annotation (Placement(transformation(extent={{-18,-1},{2,19}}, rotation=0)));
  Buildings.Airflow.Multizone.Orifice oriEasTop(
    redeclare package Medium = Medium,
    m=0.5,
    A=0.01,
    dp_turbulent=0.1) annotation (Placement(transformation(
        origin={-8,49},
        extent={{-10,-10},{10,10}},
        rotation=90)));
  Buildings.Airflow.Multizone.MediumColumn colEasTop(
    redeclare package Medium = Medium,
    h=1.5,
    density=Buildings.Airflow.Multizone.Types.densitySelection.fromTop)
    annotation (Placement(transformation(extent={{-18,69},{2,89}}, rotation=0)));
  Buildings.Fluid.MixingVolumes.MixingVolume volTopEas(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    V=2.5*5*10,
    T_start=273.15 + 21,
    nPorts=3) annotation (Placement(transformation(extent={{-30,121},{-10,141}},
          rotation=0)));
  Buildings.Fluid.MixingVolumes.MixingVolume volTopWes(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=273.15 + 20,
    V=2.5*5*10,
    nPorts=3) annotation (Placement(transformation(extent={{-110,120},{-90,140}},
          rotation=0)));
  Buildings.Airflow.Multizone.DoorDiscretizedOperable dooOpeCloTop(
    redeclare package Medium = Medium,
    LClo=20*1E-4,
    wOpe=1,
    hOpe=2.2,
    hA=3/2,
    hB=3/2,
    CDOpe=0.78,
    CDClo=0.78,
    nCom=10,
    vZer=0.01,
    dp_turbulent=0.1) "Discretized door" annotation (Placement(transformation(
          extent={{-63,80},{-43,100}}, rotation=0)));
  Fluid.Sources.FixedBoundary amb(
    redeclare package Medium = Medium,
    p=100000,
    T=283.15,
    nPorts=1) "Ambient conditions" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={190,-50})));
  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{160,140},{180,160}})));
equation
  connect(ope.y, dooOpeClo.y) annotation (Line(points={{-81,-13},{-74,-13},{-74,
          -45},{-62,-45}}, color={0,0,255}));
  connect(ope.y, dooOpeCloTop.y) annotation (Line(points={{-81,-13},{-72,-13},{
          -72,90},{-64,90}}, color={0,0,255}));
  connect(oriEasTop.port_b, colEasTop.port_b)
    annotation (Line(points={{-8,59},{-8,69},{-8,69}}, color={0,127,255}));
  connect(oriWesTop.port_b, colWesBot.port_a)
    annotation (Line(points={{-114,37},{-114,21}},color={0,127,255}));
  connect(oriWesTop.port_a, colWesTop.port_b) annotation (Line(points={{-114,57},
          {-114,66},{-114,73}}, color={0,127,255}));
  connect(oriOutBot.port_b, colOutBot.port_b) annotation (Line(points={{58,-76},
          {68,-76},{68,-90},{110,-90}},color={0,127,255}));
  connect(colEasInBot.port_b, oriOutBot.port_a) annotation (Line(points={{18,-86},
          {18,-86},{18,-94},{38,-94},{38,-76}}, color={0,127,255}));
  connect(colEasInTop.port_a, oriOutTop.port_a) annotation (Line(points={{9,-10},
          {15.25,-10},{15.25,0},{23.5,0},{23.5,6.10623e-16},{37,6.10623e-16}},
        color={0,127,255}));
  connect(oriOutTop.port_b, colOutTop.port_a) annotation (Line(points={{57,
          6.10623e-16},{108,6.10623e-16},{108,-12},{108,-14},{107,-14}}, color=
          {0,127,255}));
  connect(volWes.ports[1], dooOpeClo.port_b2) annotation (Line(
      points={{-153.667,-29},{-153.667,-51},{-61,-51}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(volWes.ports[2], dooOpeClo.port_a1) annotation (Line(
      points={{-151,-29},{-151,-39},{-61,-39}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(colWesBot.port_b, volWes.ports[3]) annotation (Line(
      points={{-114,1},{-114,-36},{-148.333,-36},{-148.333,-29}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(volTopWes.ports[1], colWesTop.port_a) annotation (Line(
      points={{-102.667,120},{-102.667,93},{-114,93}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(volTopWes.ports[2], dooOpeCloTop.port_b2) annotation (Line(
      points={{-100,120},{-100,84},{-63,84}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(volTopWes.ports[3], dooOpeCloTop.port_a1) annotation (Line(
      points={{-97.3333,120},{-97.3333,110},{-90,110},{-90,96},{-63,96}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(volTopEas.ports[1], dooOpeCloTop.port_b1) annotation (Line(
      points={{-22.6667,121},{-22.6667,96},{-43,96}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(dooOpeCloTop.port_a2, volTopEas.ports[2]) annotation (Line(
      points={{-43,84},{-20,84},{-20,121}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(colEasTop.port_a, volTopEas.ports[3]) annotation (Line(
      points={{-8,89},{-8,104},{-17.3333,104},{-17.3333,121}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(oriEasTop.port_a, col1EasBot.port_a) annotation (Line(
      points={{-8,39},{-8,29},{-8,19},{-8,19}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(dooOpeClo.port_b1, volEas.ports[1]) annotation (Line(
      points={{-41,-39},{-33.5,-39},{-33.5,-30},{-27.2,-30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(dooOpeClo.port_a2, volEas.ports[2]) annotation (Line(
      points={{-41,-51},{-25.6,-51},{-25.6,-30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(colEasInBot.port_a, volEas.ports[3]) annotation (Line(
      points={{18,-66},{18,-60},{-24,-60},{-24,-30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(colEasInTop.port_b, volEas.ports[4]) annotation (Line(
      points={{9,-30},{8,-30},{8,-42},{-22,-42},{-22,-30},{-22.4,-30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(col1EasBot.port_b, volEas.ports[5]) annotation (Line(
      points={{-8,-1},{-8,-30},{-20.8,-30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(colOutTop.port_b, volOut.ports[1]) annotation (Line(
      points={{107,-34},{106,-34},{106,-46},{130.333,-46},{130.333,-38}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(colOutBot.port_a, volOut.ports[2]) annotation (Line(
      points={{110,-70},{110,-54},{133,-54},{133,-38}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(dummy.port_a, volOut.ports[3]) annotation (Line(
      points={{148,-50},{135.667,-50},{135.667,-38}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(amb.ports[1], dummy.port_b) annotation (Line(
      points={{180,-50},{168,-50}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-200,-100},{200,
            200}}), graphics={
        Rectangle(
          extent={{-52,48},{48,-96}},
          lineColor={135,135,135},
          lineThickness=1),
        Rectangle(
          extent={{-176,48},{-52,-96}},
          lineColor={135,135,135},
          lineThickness=1),
        Rectangle(
          extent={{-52,156},{48,49}},
          lineColor={135,135,135},
          lineThickness=1),
        Rectangle(
          extent={{-176,156},{-52,48}},
          lineColor={135,135,135},
          lineThickness=1)}),
    Commands(file="ReverseBuoyancy.mos" "run"),
    Diagram);
end ReverseBuoyancy;
