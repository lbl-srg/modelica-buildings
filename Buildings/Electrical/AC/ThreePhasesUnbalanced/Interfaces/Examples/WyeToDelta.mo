within Buildings.Electrical.AC.ThreePhasesUnbalanced.Interfaces.Examples;
model WyeToDelta
  import Buildings;
  Buildings.Electrical.AC.ThreePhasesUnbalanced.Interfaces.WyeToDelta wyeToDelta
    annotation (Placement(transformation(extent={{-30,0},{-10,20}})));
  Buildings.Electrical.AC.ThreePhasesUnbalanced.Sources.FixedVoltage V1(
    f=60,
    V=480,
    Phi=0) annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Buildings.Electrical.AC.ThreePhasesUnbalanced.Loads.ResistiveLoadP load_D(
    P_nominal=-1000,
    V_nominal=480,
    loadConn=Buildings.Electrical.Types.LoadConnection.wye_to_wyeg,
    PlugPhase3=true,
    PlugPhase1=true,
    PlugPhase2=true)
    annotation (Placement(transformation(extent={{40,0},{60,20}})));
  Buildings.Electrical.AC.ThreePhasesUnbalanced.Sensors.ProbeWye probe_Y(PerUnit
      =false, V_nominal=480)
    annotation (Placement(transformation(extent={{-50,20},{-30,40}})));
  Buildings.Electrical.AC.ThreePhasesUnbalanced.Sensors.ProbeWye probeD(PerUnit=
        false, V_nominal=480)
    annotation (Placement(transformation(extent={{-10,20},{10,40}})));
  Buildings.Electrical.AC.ThreePhasesUnbalanced.Loads.ResistiveLoadP load_Y(
    P_nominal=-1000,
    V_nominal=480,
    loadConn=Buildings.Electrical.Types.LoadConnection.wye_to_wyeg,
    PlugPhase3=true,
    PlugPhase1=true,
    PlugPhase2=true)
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
  Buildings.Electrical.AC.ThreePhasesUnbalanced.Sources.FixedVoltage V2(
    f=60,
    V=480,
    Phi=0) annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Buildings.Electrical.AC.ThreePhasesUnbalanced.Sensors.GeneralizedSensor3
    seriesProbe_D annotation (Placement(transformation(extent={{8,0},{28,20}})));
  Buildings.Electrical.AC.ThreePhasesUnbalanced.Sensors.GeneralizedSensor3
    seriesProbe_Y
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
equation
  connect(V1.terminal, wyeToDelta.wye) annotation (Line(
      points={{-60,10},{-30,10}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(probe_Y.term, wyeToDelta.wye) annotation (Line(
      points={{-40,21},{-40,10},{-30,10}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(probeD.term, wyeToDelta.delta) annotation (Line(
      points={{0,21},{0,10},{-10,10}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(wyeToDelta.delta, seriesProbe_D.terminal_n) annotation (Line(
      points={{-10,10},{8,10}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(seriesProbe_D.terminal_p, load_D.terminal_p) annotation (Line(
      points={{28,10},{40,10}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(V2.terminal, seriesProbe_Y.terminal_n) annotation (Line(
      points={{-60,-30},{-20,-30}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(seriesProbe_Y.terminal_p, load_Y.terminal_p) annotation (Line(
      points={{4.44089e-16,-30},{40,-30}},
      color={0,120,120},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end WyeToDelta;
