within Buildings.Airflow.Multizone.Examples;
model ChimneyShaftWithVolume
  "Test model that demonstrates the chimney effect with a shaft that contains an air volume"
  extends Modelica.Icons.Example; 
  import Buildings;
  package Medium = Modelica.Media.Air.SimpleAir;

  Fluid.MixingVolumes.MixingVolume roo(
    nPorts=3,
    V=2.5*5*5,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=273.15 + 20,
    redeclare package Medium = Medium,
    use_HeatTransfer=true,
    p_start=101325) "Air volume of a room"
                           annotation (Placement(transformation(extent={{-10,-48},
            {10,-28}},   rotation=0)));
  Buildings.Airflow.Multizone.Orifice oriChiTop(
    m=0.5,
    redeclare package Medium = Medium,
    A=0.01) annotation (Placement(transformation(
        origin={40,11},
        extent={{-10,-10},{10,10}},
        rotation=90)));
  Buildings.Fluid.Sources.MassFlowSource_T boundary(
    redeclare package Medium = Medium,
    nPorts=1,
    use_m_flow_in=true,
    T=293.15)
    annotation (Placement(transformation(extent={{-50,-90},{-30,-70}})));
  Buildings.Fluid.Sources.Boundary_pT bou0(
    redeclare package Medium = Medium,
    T=273.15,
    nPorts=2)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={60,50})));
  Buildings.Airflow.Multizone.Orifice oriBot(
    m=0.5,
    redeclare package Medium = Medium,
    A=0.01) annotation (Placement(transformation(
        origin={80,-50},
        extent={{10,-10},{-10,10}},
        rotation=90)));
  MediumColumn staOut(
    redeclare package Medium = Medium,
    densitySelection=Buildings.Airflow.Multizone.Types.densitySelection.fromTop,
    h=3/2) "Model for stack effect"
    annotation (Placement(transformation(extent={{70,-1},{90,19}},    rotation=
            0)));
  Buildings.Airflow.Multizone.Orifice oriChiBot(
    m=0.5,
    redeclare package Medium = Medium,
    A=0.01) annotation (Placement(transformation(
        origin={40,-49},
        extent={{-10,-10},{10,10}},
        rotation=90)));
  Buildings.HeatTransfer.Sources.PrescribedHeatFlow preHea
    "Prescribed heat flow" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,10})));
  Buildings.Controls.Continuous.LimPID con(
    Td=10,
    yMax=1,
    yMin=-1,
    Ti=60,
    controllerType=Modelica.Blocks.Types.SimpleController.P,
    k=5) "Controller to maintain volume temperature"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Modelica.Blocks.Sources.Constant TSet(k=293.15) "Temperature set point"
    annotation (Placement(transformation(extent={{-90,20},{-70,40}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temSen
    "Temperature sensor" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-80,0})));
  Modelica.Blocks.Math.Gain gain(k=3000)
    annotation (Placement(transformation(extent={{-28,20},{-8,40}})));
  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Buildings.Airflow.Multizone.MediumColumnDynamic sha(
                                              redeclare package Medium = Medium,
      V=3) "Shaft of chimney"
    annotation (Placement(transformation(extent={{30,-30},{50,-10}})));
  MediumColumn staOut1(
    redeclare package Medium = Medium,
    densitySelection=Buildings.Airflow.Multizone.Types.densitySelection.fromBottom,
    h=3/2) "Model for stack effect"
    annotation (Placement(transformation(extent={{70,-89},{90,-69}},  rotation=
            0)));

  Modelica.Blocks.Sources.CombiTimeTable mRoo_flow(tableOnFile=false, table=[0,0.05;
        600,0.05; 601,0; 1800,0; 1801,-0.05; 2400,-0.05; 2401,0; 3600,0])
    "Mass flow into and out of room to fill the medium column with air of different temperature"
    annotation (Placement(transformation(extent={{-90,-82},{-70,-62}})));
equation
  connect(boundary.ports[1],roo. ports[1]) annotation (Line(
      points={{-30,-80},{-2.66667,-80},{-2.66667,-48}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TSet.y, con.u_s) annotation (Line(
      points={{-69,30},{-62,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(temSen.T, con.u_m) annotation (Line(
      points={{-70,6.10623e-16},{-50,6.10623e-16},{-50,18}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gain.u, con.y) annotation (Line(
      points={{-30,30},{-39,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gain.y, preHea.Q_flow) annotation (Line(
      points={{-7,30},{2.50304e-15,30},{2.50304e-15,20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sha.port_a, oriChiTop.port_a) annotation (Line(
      points={{40,-10},{40,1}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sha.port_b, oriChiBot.port_b) annotation (Line(
      points={{40,-30},{40,-39}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(staOut.port_b, oriBot.port_a) annotation (Line(
      points={{80,-1},{80,-40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(preHea.port, roo.heatPort) annotation (Line(
      points={{-1.22629e-15,1.22125e-15},{-1.22629e-15,-20},{-20,-20},{-20,-38},
          {-10,-38}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(roo.heatPort, temSen.port) annotation (Line(
      points={{-10,-38},{-40,-38},{-40,-20},{-96,-20},{-96,6.10623e-16},{-90,
          6.10623e-16}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(bou0.ports[1], oriChiTop.port_b)  annotation (Line(
      points={{62,40},{58,40},{58,34},{40,34},{40,21}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(bou0.ports[2], staOut.port_a) annotation (Line(
      points={{58,40},{62,40},{62,34},{80,34},{80,19}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(roo.ports[2], oriChiBot.port_a)  annotation (Line(
      points={{5.55112e-16,-48},{4,-48},{4,-64},{40,-64},{40,-59}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(oriBot.port_b, staOut1.port_a) annotation (Line(
      points={{80,-60},{80,-69}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(staOut1.port_b, roo.ports[3]) annotation (Line(
      points={{80,-89},{80,-92},{2.66667,-92},{2.66667,-48}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(mRoo_flow.y[1], boundary.m_flow_in) annotation (Line(
      points={{-69,-72},{-50,-72}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
            {100,100}}),
                      graphics),
    Commands(file="ChimneyShaftWithVolume.mos" "run"),
    experiment(
      StopTime=3600,
      Tolerance=1e-06,
      Algorithm="Radau"),
    experimentSetupOutput,
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}})));
end ChimneyShaftWithVolume;
