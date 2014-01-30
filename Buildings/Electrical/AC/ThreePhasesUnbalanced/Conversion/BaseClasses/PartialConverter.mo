within Buildings.Electrical.AC.ThreePhasesUnbalanced.Conversion.BaseClasses;
partial model PartialConverter
  import Buildings;

  replaceable Buildings.Electrical.Interfaces.PartialConversion
                                    conv1(
    redeclare package PhaseSystem_p = Electrical.PhaseSystems.OnePhase,
    redeclare package PhaseSystem_n = Electrical.PhaseSystems.OnePhase,
    redeclare Electrical.AC.OnePhase.Interfaces.Terminal_n terminal_n,
    redeclare Electrical.AC.OnePhase.Interfaces.Terminal_p terminal_p)
    annotation (Placement(transformation(extent={{-10,42},{10,62}})));
  replaceable Buildings.Electrical.Interfaces.PartialConversion
                                    conv2(
    redeclare package PhaseSystem_p = Electrical.PhaseSystems.OnePhase,
    redeclare package PhaseSystem_n = Electrical.PhaseSystems.OnePhase,
    redeclare Electrical.AC.OnePhase.Interfaces.Terminal_n terminal_n,
    redeclare Electrical.AC.OnePhase.Interfaces.Terminal_p terminal_p)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  replaceable Buildings.Electrical.Interfaces.PartialConversion
                                    conv3(
    redeclare package PhaseSystem_p = Electrical.PhaseSystems.OnePhase,
    redeclare package PhaseSystem_n = Electrical.PhaseSystems.OnePhase,
    redeclare Electrical.AC.OnePhase.Interfaces.Terminal_n terminal_n,
    redeclare Electrical.AC.OnePhase.Interfaces.Terminal_p terminal_p)
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
  Interfaces.Terminal_n terminal_n
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Interfaces.Terminal_p terminal_p
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Interfaces.Connection3to4_n connection3to4_n
    annotation (Placement(transformation(extent={{-60,-10},{-80,10}})));
  Interfaces.Connection3to4_p connection3to4_p
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  OnePhase.Basics.Ground ground_n
    annotation (Placement(transformation(extent={{-70,-90},{-50,-70}})));
  OnePhase.Basics.Ground ground_p
    annotation (Placement(transformation(extent={{50,-90},{70,-70}})));
equation

  Connections.branch(connection3to4_n.terminal4.phase[1].theta, connection3to4_n.terminal4.phase[4].theta);
  connection3to4_n.terminal4.phase[1].theta = connection3to4_n.terminal4.phase[4].theta;
  Connections.branch(connection3to4_p.terminal4.phase[1].theta, connection3to4_p.terminal4.phase[4].theta);
  connection3to4_p.terminal4.phase[1].theta = connection3to4_p.terminal4.phase[4].theta;
  for i in 1:3 loop
    Connections.branch(connection3to4_n.terminal3.phase[i].theta, connection3to4_n.terminal4.phase[i].theta);
    connection3to4_n.terminal3.phase[i].theta = connection3to4_n.terminal4.phase[i].theta;

    Connections.branch(connection3to4_p.terminal3.phase[i].theta, connection3to4_p.terminal4.phase[i].theta);
    connection3to4_p.terminal3.phase[i].theta = connection3to4_p.terminal4.phase[i].theta;
  end for;

  connect(connection3to4_n.terminal4.phase[1],conv1. terminal_n) annotation (Line(
      points={{-60,6.66134e-16},{-50,6.66134e-16},{-50,52},{-10,52}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(connection3to4_n.terminal4.phase[2],conv2. terminal_n) annotation (Line(
      points={{-60,6.66134e-16},{-36,6.66134e-16},{-36,0},{-10,0}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(connection3to4_n.terminal4.phase[3],conv3. terminal_n) annotation (Line(
      points={{-60,6.66134e-16},{-50,6.66134e-16},{-50,-60},{-10,-60}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(conv1.terminal_p, connection3to4_p.terminal4.phase[1]) annotation (Line(
      points={{10,52},{50,52},{50,6.66134e-16},{60,6.66134e-16}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(conv2.terminal_p, connection3to4_p.terminal4.phase[2]) annotation (Line(
      points={{10,0},{36,0},{36,6.66134e-16},{60,6.66134e-16}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(conv3.terminal_p, connection3to4_p.terminal4.phase[3]) annotation (Line(
      points={{10,-60},{50,-60},{50,6.66134e-16},{60,6.66134e-16}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(terminal_p, connection3to4_p.terminal3) annotation (Line(
      points={{100,0},{80,0},{80,6.66134e-16}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(terminal_n, connection3to4_n.terminal3) annotation (Line(
      points={{-100,4.44089e-16},{-80,4.44089e-16},{-80,6.66134e-16}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(connection3to4_n.terminal4.phase[4], ground_n.terminal) annotation (Line(
      points={{-60,0},{-60,-70}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(connection3to4_p.terminal4.phase[4], ground_p.terminal) annotation (Line(
      points={{60,0},{60,-70}},
      color={0,120,120},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(graphics));
end PartialConverter;
