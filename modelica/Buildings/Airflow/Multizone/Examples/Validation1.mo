within Buildings.Airflow.Multizone.Examples;
model Validation1

  package Medium = Buildings.Media.IdealGases.SimpleAir;

  Buildings.Fluid.MixingVolumes.MixingVolume volEas(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=273.15 + 20,
    V=2.5*5*5*1,
    nPorts=5,
    use_HeatTransfer=true) annotation (Placement(transformation(extent={{-34,-30},
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
    use_HeatTransfer=true) annotation (Placement(transformation(extent={{-159,-31},
            {-139,-11}}, rotation=0)));
  Modelica.Blocks.Sources.Constant open(k=1) annotation (Placement(
        transformation(extent={{-100,-21},{-80,-1}}, rotation=0)));
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
    use_HeatTransfer=true) annotation (Placement(transformation(extent={{-80,
            121},{-60,141}}, rotation=0)));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow preHeaWes
    annotation (Placement(transformation(extent={{172,199},{192,219}}, rotation
          =0)));

  Modelica.Blocks.Sources.Constant T25(k=273.15 + 25) annotation (Placement(
        transformation(extent={{20,201},{40,221}}, rotation=0)));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temSenWes annotation
    (Placement(transformation(extent={{58,170},{80,191}}, rotation=0)));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow preHeaEas
    annotation (Placement(transformation(extent={{166.5,132},{186.5,152}},
          rotation=0)));

  Modelica.Blocks.Sources.Constant T20(k=273.15 + 20) annotation (Placement(
        transformation(extent={{80.5,140},{100.5,160}},rotation=0)));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temSenEas annotation
    (Placement(transformation(extent={{80.5,100},{100.5,120}}, rotation=0)));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow preHeaTop
    annotation (Placement(transformation(extent={{163,69},{183,89}}, rotation=0)));

  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temSenTop annotation
    (Placement(transformation(extent={{81,41},{101,61}}, rotation=0)));
  Modelica.Blocks.Continuous.LimPID PIWes(
    Td=1,
    yMax=5000,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=20,
    Ti=1) annotation (Placement(transformation(extent={{136,199},{156,219}},
          rotation=0)));
  Modelica.Blocks.Continuous.LimPID PIEas(
    Td=1,
    yMax=5000,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=20,
    Ti=1) annotation (Placement(transformation(extent={{130.5,132},{150.5,152}},
          rotation=0)));
  Modelica.Blocks.Continuous.LimPID PITop(
    Td=1,
    yMax=5000,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=20,
    Ti=1) annotation (Placement(transformation(extent={{131,69},{151,89}},
          rotation=0)));
  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{-180,220},{-160,240}})));
equation
  connect(open.y, dooOpeClo.y) annotation (Line(points={{-79,-11},{-74,-11},{
          -74,-45},{-62,-45}}, color={0,0,255}));
  connect(PIWes.y, preHeaWes.Q_flow)
    annotation (Line(points={{157,209},{166,210},{172,209}}, color={0,0,255}));
  connect(PIEas.y, preHeaEas.Q_flow) annotation (Line(points={{151.5,142},{160,
          142},{166.5,142}}, color={0,0,255}));
  connect(PITop.y, preHeaTop.Q_flow) annotation (Line(points={{152,79},{158,80},
          {158,79},{163,79}}, color={0,0,255}));
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
  connect(preHeaWes.port, volWes.heatPort) annotation (Line(
      points={{192,209},{214,209},{214,-114},{-164,-114},{-164,-21},{-159,-21}},

      color={191,0,0},
      smooth=Smooth.None));

  connect(preHeaEas.port, volEas.heatPort) annotation (Line(
      points={{186.5,142},{202,142},{202,-106},{-38,-106},{-38,-20},{-34,-20}},

      color={191,0,0},
      smooth=Smooth.None));

  connect(preHeaTop.port, volTop.heatPort) annotation (Line(
      points={{183,79},{196,79},{196,240},{-88,240},{-88,131},{-80,131}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(T20.y, PIEas.u_s) annotation (Line(
      points={{101.5,150},{120,150},{120,142},{128.5,142}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T20.y, PITop.u_s) annotation (Line(
      points={{101.5,150},{120,150},{120,79},{129,79}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T25.y, PIWes.u_s) annotation (Line(
      points={{41,211},{90.5,211},{90.5,209},{134,209}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(temSenWes.port, volWes.heatPort) annotation (Line(
      points={{58,180.5},{-40,180.5},{-40,180},{-164,180},{-164,-21},{-159,-21}},

      color={191,0,0},
      smooth=Smooth.None));

  connect(PIWes.u_m, temSenWes.T) annotation (Line(
      points={{146,197},{146,180},{80,180},{80,180.5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(temSenEas.T, PIEas.u_m) annotation (Line(
      points={{100.5,110},{140.5,110},{140.5,130}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(temSenEas.port, volEas.heatPort) annotation (Line(
      points={{80.5,110},{-34,110},{-34,-20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(temSenTop.port, volTop.heatPort) annotation (Line(
      points={{81,51},{60,51},{60,104},{-88,104},{-88,131},{-80,131}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(temSenTop.T, PITop.u_m) annotation (Line(
      points={{101,51},{141,51},{141,67}},
      color={0,0,127},
      smooth=Smooth.None));
end Validation1;
