within Buildings.Airflow.Multizone.Examples;
model OneDoor
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.PerfectGases.MoistAirUnsaturated;

  Buildings.Fluid.MixingVolumes.MixingVolume volH(
    redeclare package Medium = Medium,
    T_start=273.15 + 50,
    V=2.5*10*10,
    nPorts=4,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=0.01)                                     annotation (
      Placement(transformation(extent={{35,42},{55,62}}, rotation=0)));
  Buildings.Airflow.Multizone.DoorDiscretizedOperable dooOpeClo(redeclare
      package Medium = Medium, LClo=20*1E-4) "Discretized door" annotation (
      Placement(transformation(extent={{-10,26},{10,46}}, rotation=0)));
  Modelica.Blocks.Sources.Constant open(k=1) annotation (Placement(
        transformation(extent={{-48,62},{-28,82}}, rotation=0)));
  Buildings.Fluid.MixingVolumes.MixingVolume volC(
    redeclare package Medium = Medium,
    T_start=273.15 + 0,
    V=2.5*10*10,
    nPorts=4,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=0.01)                                     annotation (
      Placement(transformation(extent={{-92,40},{-72,60}}, rotation=0)));
  Buildings.Airflow.Multizone.DoorDiscretizedOperable dooOpeClo1(redeclare
      package Medium = Medium, LClo=20*1E-4) "Discretized door" annotation (
      Placement(transformation(extent={{-12,-70},{8,-50}}, rotation=0)));
  Modelica.Blocks.Sources.Constant open1(k=1) annotation (Placement(
        transformation(extent={{-50,-34},{-30,-14}}, rotation=0)));
  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{60,-80},{80,-60}})));
equation
  connect(open.y, dooOpeClo.y) annotation (Line(points={{-27,72},{-19,72},{-19,
          36},{-11,36}}, color={0,0,255}));
  connect(open1.y, dooOpeClo1.y) annotation (Line(points={{-29,-24},{-21,-24},{
          -21,-60},{-13,-60}}, color={0,0,255}));
  connect(volC.ports[1], dooOpeClo.port_a1) annotation (Line(
      points={{-85,40},{-48,40},{-48,42},{-10,42}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(volC.ports[2], dooOpeClo.port_b2) annotation (Line(
      points={{-83,40},{-83,30},{-10,30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(dooOpeClo.port_b1, volH.ports[1]) annotation (Line(
      points={{10,42},{42,42}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(dooOpeClo.port_a2, volH.ports[2]) annotation (Line(
      points={{10,30},{44,30},{44,42}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(volC.ports[3], dooOpeClo1.port_a1) annotation (Line(
      points={{-81,40},{-76,40},{-76,-54},{-12,-54}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(volC.ports[4], dooOpeClo1.port_b2) annotation (Line(
      points={{-79,40},{-84,40},{-84,-66},{-12,-66}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(dooOpeClo1.port_b1, volH.ports[3]) annotation (Line(
      points={{8,-54},{46,-54},{46,42}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(dooOpeClo1.port_a2, volH.ports[4]) annotation (Line(
      points={{8,-66},{48,-66},{48,42}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Airflow/Multizone/Examples/OneDoor.mos"
        "Simulate and plot"),                                                                                                    Diagram(graphics));
end OneDoor;
