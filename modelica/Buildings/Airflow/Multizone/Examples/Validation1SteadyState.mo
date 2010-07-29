within Buildings.Airflow.Multizone.Examples;
model Validation1SteadyState

  package Medium = Buildings.Media.IdealGases.SimpleAir;

  Buildings.Fluid.MixingVolumes.MixingVolume volEas(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=273.15 + 20,
    V=2.5*5*5*1,
    nPorts=5,
    use_HeatTransfer=false) annotation (Placement(transformation(extent={{-34,-30},
            {-14,-10}}, rotation=0)));

  Buildings.Airflow.Multizone.Orifice oriOutBot(
    redeclare package Medium = Medium,
    A=0.01,
    m=0.5) annotation (Placement(transformation(extent={{38,-90},{58,-70}},
          rotation=0)));
  Buildings.Airflow.Multizone.MediumColumn colOutTop(
    redeclare package Medium = Medium,
    h=1.5,
    density=Buildings.Airflow.Multizone.Types.densitySelection.fromBottom)
    annotation (Placement(transformation(extent={{91,-8},{111,12}}, rotation=0)));
  Buildings.Airflow.Multizone.Orifice oriOutTop(
    redeclare package Medium = Medium,
    A=0.01,
    m=0.5) annotation (Placement(transformation(extent={{37,10},{57,30}},
          rotation=0)));
  Buildings.Airflow.Multizone.MediumColumn colEasInTop(
    redeclare package Medium = Medium,
    h=1.5,
    density=Buildings.Airflow.Multizone.Types.densitySelection.fromBottom)
    annotation (Placement(transformation(extent={{9,-10},{29,10}}, rotation=0)));
  Buildings.Fluid.MixingVolumes.MixingVolume volOut(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=273.15 + 10,
    V=1E12,
    nPorts=2) annotation (Placement(transformation(extent={{119,-30},{139,-10}},
          rotation=0)));

  Buildings.Airflow.Multizone.MediumColumn colEasInBot(
    redeclare package Medium = Medium,
    h=1.5,
    density=Buildings.Airflow.Multizone.Types.densitySelection.fromTop)
    annotation (Placement(transformation(extent={{10,-70},{30,-50}}, rotation=0)));
  Buildings.Airflow.Multizone.MediumColumn colOutBot(
    redeclare package Medium = Medium,
    h=1.5,
    density=Buildings.Airflow.Multizone.Types.densitySelection.fromTop)
    annotation (Placement(transformation(extent={{90,-68},{110,-48}}, rotation=
            0)));
  Buildings.Airflow.Multizone.MediumColumn colWesBot(
    redeclare package Medium = Medium,
    h=1.5,
    density=Buildings.Airflow.Multizone.Types.densitySelection.fromBottom)
    annotation (Placement(transformation(extent={{-130,9},{-110,29}}, rotation=
            0)));
  Buildings.Airflow.Multizone.Orifice oriWesTop(
    redeclare package Medium = Medium,
    m=0.5,
    A=0.01) annotation (Placement(transformation(
        origin={-120,49},
        extent={{-10,-10},{10,10}},
        rotation=270)));

  Buildings.Airflow.Multizone.MediumColumn colWesTop(
    redeclare package Medium = Medium,
    h=1.5,
    density=Buildings.Airflow.Multizone.Types.densitySelection.fromTop)
    annotation (Placement(transformation(extent={{-130,71},{-110,91}}, rotation
          =0)));
  Buildings.Airflow.Multizone.DoorDiscretizedOperable dooOpeClo(
    redeclare package Medium = Medium,
    LClo=20*1E-4,
    wOpe=1,
    hOpe=2.2,
    CDOpe=0.78,
    CDClo=0.78,
    nCom=10,
    hA=3/2,
    hB=3/2) "Discretized door" annotation (Placement(transformation(extent={{-61,
            -55},{-41,-35}}, rotation=0)));
  Fluid.MixingVolumes.MixingVolume volWes(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=273.15 + 25,
    nPorts=3,
    p_start=101325,
    V=2.5*5*5,
    use_HeatTransfer=false) annotation (Placement(transformation(extent={{-159,
            -31},{-139,-11}}, rotation=0)));
  Modelica.Blocks.Sources.Constant open(k=1) annotation (Placement(
        transformation(extent={{-104,-21},{-84,-1}}, rotation=0)));
  Buildings.Airflow.Multizone.MediumColumn col1EasBot(
    redeclare package Medium = Medium,
    h=1.5,
    density=Buildings.Airflow.Multizone.Types.densitySelection.fromBottom)
    annotation (Placement(transformation(extent={{-20,9},{0,29}}, rotation=0)));
  Buildings.Airflow.Multizone.Orifice oriEasTop(
    redeclare package Medium = Medium,
    m=0.5,
    A=0.01) annotation (Placement(transformation(
        origin={-10,49},
        extent={{-10,-10},{10,10}},
        rotation=90)));
  Buildings.Airflow.Multizone.MediumColumn colEasTop(
    redeclare package Medium = Medium,
    h=1.5,
    density=Buildings.Airflow.Multizone.Types.densitySelection.fromTop)
    annotation (Placement(transformation(extent={{-20,71},{0,91}}, rotation=0)));
  Buildings.Fluid.MixingVolumes.MixingVolume volTop(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=273.15 + 20,
    V=2.5*5*10*1,
    nPorts=2,
    use_HeatTransfer=false) annotation (Placement(transformation(extent={{-80,
            121},{-60,141}}, rotation=0)));



  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{-180,220},{-160,240}})));
equation
  connect(open.y, dooOpeClo.y) annotation (Line(points={{-83,-11},{-74,-11},{-74,
          -45},{-62,-45}}, color={0,0,255}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-200,-150},{300,
            250}}), graphics={
        Rectangle(
          extent={{-52,48},{48,-96}},
          lineColor={135,135,135},
          lineThickness=1),
        Rectangle(
          extent={{-176,48},{-52,-96}},
          lineColor={135,135,135},
          lineThickness=1),
        Rectangle(
          extent={{-176,150},{48,49}},
          lineColor={135,135,135},
          lineThickness=1)}),
    Commands(file="Validation1.mos" "run"),
    Diagram);
  connect(volWes.ports[1], dooOpeClo.port_b2) annotation (Line(
      points={{-151.667,-31},{-151.667,-51},{-61,-51}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(volWes.ports[2], dooOpeClo.port_a1) annotation (Line(
      points={{-149,-31},{-149,-39},{-61,-39}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(volWes.ports[3], colWesBot.port_b) annotation (Line(
      points={{-146.333,-31},{-120,-31},{-120,9}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(colWesBot.port_a, oriWesTop.port_b) annotation (Line(
      points={{-120,29},{-120,39}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(oriWesTop.port_a, colWesTop.port_b) annotation (Line(
      points={{-120,59},{-120,71}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(colWesTop.port_a, volTop.ports[1]) annotation (Line(
      points={{-120,91},{-120,100},{-72,100},{-72,121}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(volTop.ports[2], colEasTop.port_a) annotation (Line(
      points={{-68,121},{-68,100},{-10,100},{-10,91}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(colEasTop.port_b, oriEasTop.port_b) annotation (Line(
      points={{-10,71},{-10,59}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(oriEasTop.port_a, col1EasBot.port_a) annotation (Line(
      points={{-10,39},{-10,29}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(dooOpeClo.port_b1, volEas.ports[1]) annotation (Line(
      points={{-41,-39},{-25.5,-39},{-25.5,-30},{-27.2,-30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(volEas.ports[2], dooOpeClo.port_a2) annotation (Line(
      points={{-25.6,-30},{-25.6,-50},{-41,-50},{-41,-51}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(colEasInBot.port_a, volEas.ports[3]) annotation (Line(
      points={{20,-50},{-24,-50},{-24,-30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(volEas.ports[4], colEasInTop.port_b) annotation (Line(
      points={{-22.4,-30},{-22,-30},{-22,-38},{19,-38},{19,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(volEas.ports[5], col1EasBot.port_b) annotation (Line(
      points={{-20.8,-30},{-20.8,-34},{-10,-34},{-10,9}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(colEasInTop.port_a, oriOutTop.port_a) annotation (Line(
      points={{19,10},{19,20},{37,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(oriOutTop.port_b, colOutTop.port_a) annotation (Line(
      points={{57,20},{101,20},{101,12}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(colOutTop.port_b, volOut.ports[1]) annotation (Line(
      points={{101,-8},{101,-34},{128,-34},{128,-30},{127,-30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(colOutBot.port_a, volOut.ports[2]) annotation (Line(
      points={{100,-48},{100,-44},{131,-44},{131,-30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(colOutBot.port_b, oriOutBot.port_b) annotation (Line(
      points={{100,-68},{100,-80},{58,-80}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(oriOutBot.port_a, colEasInBot.port_b) annotation (Line(
      points={{38,-80},{20,-80},{20,-70}},
      color={0,127,255},
      smooth=Smooth.None));



end Validation1SteadyState;
