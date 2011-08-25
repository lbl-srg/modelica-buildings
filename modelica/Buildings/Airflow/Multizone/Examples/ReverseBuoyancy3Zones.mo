within Buildings.Airflow.Multizone.Examples;
model ReverseBuoyancy3Zones
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.IdealGases.SimpleAir;
  Buildings.Fluid.MixingVolumes.MixingVolume volEas(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    V=2.5*5*5,
    T_start=273.15 + 25,
    nPorts=5,
    m_flow_nominal=0.001)
              annotation (Placement(transformation(extent={{-32,-26},{-12,-6}},
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
    densitySelection=Buildings.Airflow.Multizone.Types.densitySelection.fromBottom)
    annotation (Placement(transformation(extent={{91,-30},{111,-10}}, rotation=
            0)));
  Buildings.Airflow.Multizone.Orifice oriOutTop(
    redeclare package Medium = Medium,
    m=0.5,
    A=0.01,
    dp_turbulent=0.1) annotation (Placement(transformation(extent={{39,-10},{59,
            10}}, rotation=0)));
  Buildings.Airflow.Multizone.MediumColumn colEasInTop(
    redeclare package Medium = Medium,
    h=1.5,
    densitySelection=Buildings.Airflow.Multizone.Types.densitySelection.fromBottom)
    annotation (Placement(transformation(extent={{11,-30},{31,-10}},rotation=0)));
  Buildings.Fluid.MixingVolumes.MixingVolume volOut(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    V=1E12,
    T_start=273.15 + 15,
    nPorts=2,
    m_flow_nominal=0.001)
              annotation (Placement(transformation(extent={{129,-30},{149,-10}},
          rotation=0)));
  Buildings.Airflow.Multizone.MediumColumn colEasInBot(
    redeclare package Medium = Medium,
    h=1.5,
    densitySelection=Buildings.Airflow.Multizone.Types.densitySelection.fromTop)
    annotation (Placement(transformation(extent={{10,-70},{30,-50}},rotation=0)));
  Buildings.Airflow.Multizone.MediumColumn colOutBot(
    redeclare package Medium = Medium,
    h=1.5,
    densitySelection=Buildings.Airflow.Multizone.Types.densitySelection.fromTop)
    annotation (Placement(transformation(extent={{90,-70},{110,-50}}, rotation=
            0)));
  Buildings.Airflow.Multizone.MediumColumn colWesBot(
    redeclare package Medium = Medium,
    h=1.5,
    densitySelection=Buildings.Airflow.Multizone.Types.densitySelection.fromBottom)
    annotation (Placement(transformation(extent={{-130,11},{-110,31}},rotation=
            0)));
  Buildings.Airflow.Multizone.Orifice oriWesTop(
    redeclare package Medium = Medium,
    m=0.5,
    A=0.01,
    dp_turbulent=0.1) annotation (Placement(transformation(
        origin={-120,47},
        extent={{-10,-10},{10,10}},
        rotation=270)));
  Buildings.Airflow.Multizone.MediumColumn colWesTop(
    redeclare package Medium = Medium,
    h=1.5,
    densitySelection=Buildings.Airflow.Multizone.Types.densitySelection.fromTop)
    annotation (Placement(transformation(extent={{-130,79},{-110,99}},rotation=
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
  Modelica.Blocks.Sources.Constant ope(k=1) annotation (Placement(
        transformation(extent={{-102,-23},{-82,-3}}, rotation=0)));
  Buildings.Airflow.Multizone.MediumColumn col1EasBot(
    redeclare package Medium = Medium,
    h=1.5,
    densitySelection=Buildings.Airflow.Multizone.Types.densitySelection.fromBottom)
    annotation (Placement(transformation(extent={{-20,11},{0,31}}, rotation=0)));
  Buildings.Airflow.Multizone.Orifice oriEasTop(
    redeclare package Medium = Medium,
    m=0.5,
    A=0.01,
    dp_turbulent=0.1) annotation (Placement(transformation(
        origin={-10,49},
        extent={{-10,-10},{10,10}},
        rotation=90)));
  Buildings.Airflow.Multizone.MediumColumn colEasTop(
    redeclare package Medium = Medium,
    h=1.5,
    densitySelection=Buildings.Airflow.Multizone.Types.densitySelection.fromTop)
    annotation (Placement(transformation(extent={{-20,79},{0,99}}, rotation=0)));
  Buildings.Fluid.MixingVolumes.MixingVolume volTopEas(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    V=2.5*5*10,
    T_start=273.15 + 21,
    nPorts=3,
    m_flow_nominal=0.001)
              annotation (Placement(transformation(extent={{-40,111},{-20,131}},
          rotation=0)));
  Buildings.Fluid.MixingVolumes.MixingVolume volTopWes(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=273.15 + 20,
    V=2.5*5*10,
    nPorts=3,
    m_flow_nominal=0.001)
              annotation (Placement(transformation(extent={{-158,120},{-138,140}},
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
  Buildings.Fluid.MixingVolumes.MixingVolume volWes(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    V=2.5*5*5,
    T_start=273.15 + 22,
    nPorts=3,
    m_flow_nominal=0.001)
              annotation (Placement(transformation(extent={{-164,-27},{-144,-7}},
          rotation=0)));
  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{160,140},{180,160}})));
equation
  connect(dooOpeClo.port_b2, volWes.ports[1]) annotation (Line(
      points={{-61,-51},{-104,-51},{-104,-50},{-156.667,-50},{-156.667,-27}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(dooOpeClo.port_a1, volWes.ports[2]) annotation (Line(
      points={{-61,-39},{-108,-39},{-108,-40},{-154,-40},{-154,-27}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(dooOpeCloTop.port_b1, volTopEas.ports[1]) annotation (Line(
      points={{-43,96},{-32.6667,96},{-32.6667,111}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(dooOpeCloTop.port_a2, volTopEas.ports[2]) annotation (Line(
      points={{-43,84},{-30,84},{-30,111}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(dooOpeClo.port_b1, volEas.ports[1]) annotation (Line(
      points={{-41,-39},{-25.2,-39},{-25.2,-26}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(dooOpeClo.port_a2, volEas.ports[2]) annotation (Line(
      points={{-41,-51},{-23.6,-51},{-23.6,-26}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(colWesTop.port_a, volTopWes.ports[1]) annotation (Line(
      points={{-120,99},{-120,106},{-150.667,106},{-150.667,120}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(volTopWes.ports[2], dooOpeCloTop.port_b2) annotation (Line(
      points={{-148,120},{-148,112},{-106,112},{-106,84},{-63,84}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(dooOpeCloTop.port_a1, volTopWes.ports[3]) annotation (Line(
      points={{-63,96},{-100,96},{-100,116},{-145.333,116},{-145.333,120}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(colWesTop.port_b, oriWesTop.port_a) annotation (Line(
      points={{-120,79},{-120,57}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(oriWesTop.port_b, colWesBot.port_a) annotation (Line(
      points={{-120,37},{-120,31}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(colWesBot.port_b, volWes.ports[3]) annotation (Line(
      points={{-120,11},{-120,-34},{-151.333,-34},{-151.333,-27}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(volTopEas.ports[3], colEasTop.port_a) annotation (Line(
      points={{-27.3333,111},{-27.3333,99},{-10,99}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(colEasTop.port_b, oriEasTop.port_b) annotation (Line(
      points={{-10,79},{-10,59}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(oriEasTop.port_a, col1EasBot.port_a) annotation (Line(
      points={{-10,39},{-10,31}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(colEasInBot.port_a, volEas.ports[3]) annotation (Line(
      points={{20,-50},{-22,-50},{-22,-26}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(colEasInTop.port_b, volEas.ports[4]) annotation (Line(
      points={{21,-30},{21,-38},{-20.4,-38},{-20.4,-26}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(col1EasBot.port_b, volEas.ports[5]) annotation (Line(
      points={{-10,11},{-10,-34},{-18.8,-34},{-18.8,-26}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(colOutTop.port_b, volOut.ports[1]) annotation (Line(
      points={{101,-30},{100,-30},{100,-36},{137,-36},{137,-30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(volOut.ports[2], colOutBot.port_a) annotation (Line(
      points={{141,-30},{141,-40},{100,-40},{100,-50}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(colOutBot.port_b, oriOutBot.port_b) annotation (Line(
      points={{100,-70},{100,-78},{58,-78},{58,-76}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(oriOutBot.port_a, colEasInBot.port_b) annotation (Line(
      points={{38,-76},{38,-74},{20,-74},{20,-70}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(colEasInTop.port_a, oriOutTop.port_a) annotation (Line(
      points={{21,-10},{20,-10},{20,0},{39,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(oriOutTop.port_b, colOutTop.port_a) annotation (Line(
      points={{59,0},{101,0},{101,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(dooOpeCloTop.y, ope.y) annotation (Line(
      points={{-64,90},{-72,90},{-72,-13},{-81,-13}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ope.y, dooOpeClo.y) annotation (Line(
      points={{-81,-13},{-72,-13},{-72,-45},{-62,-45}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-200,-100},{200,
            200}}), graphics={Rectangle(
          extent={{-52,48},{48,-96}},
          lineColor={135,135,135},
          lineThickness=1), Rectangle(
          extent={{-176,48},{-52,-96}},
          lineColor={135,135,135},
          lineThickness=1)}),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Airflow/Multizone/Examples/ReverseBuoyancy3Zones.mos"
        "Simulate and plot"),
    Diagram);
end ReverseBuoyancy3Zones;
