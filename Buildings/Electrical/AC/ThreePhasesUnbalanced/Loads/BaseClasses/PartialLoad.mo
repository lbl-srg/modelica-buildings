within Buildings.Electrical.AC.ThreePhasesUnbalanced.Loads.BaseClasses;
partial model PartialLoad
  import Buildings;
  parameter Boolean PlugPhase1 = true
    "This flag indicates if the load on phase 1 is connected or not";
  parameter Boolean PlugPhase2 = false
    "This flag indicates if the load on phase 2 is connected or not";
  parameter Boolean PlugPhase3 = true
    "This flag indicates if the load on phase 3 is connected or not";
  parameter Boolean linear = false
    "If =true introduce a linearization in the load"                                                    annotation(evaluate=true,Dialog(group="Modelling assumption"));
  parameter Buildings.Electrical.Types.Assumption mode(
    min=Buildings.Electrical.Types.Assumption.FixedZ_steady_state,
    max=Buildings.Electrical.Types.Assumption.VariableZ_y_input)=Buildings.Electrical.Types.Assumption.FixedZ_steady_state
    "Parameters that specifies the mode of the load (e.g., steady state, dynamic, prescribed power consumption, etc.)"
                                                                                                        annotation(evaluate=true,Dialog(group="Modelling assumption"));
  Buildings.Electrical.AC.ThreePhasesUnbalanced.Interfaces.Terminal_n
                       terminal_p
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));

  replaceable Electrical.Interfaces.PartialLoad load1(
    redeclare package PhaseSystem = PhaseSystems.OnePhase,
    redeclare Electrical.AC.OnePhase.Interfaces.Terminal_n terminal,
    P_nominal=P_nominal,
    V_nominal=V_nominal,
    linear=linear,
    mode=mode) if PlugPhase1
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));
  replaceable Electrical.Interfaces.PartialLoad load2(
    redeclare package PhaseSystem = PhaseSystems.OnePhase,
    redeclare Electrical.AC.OnePhase.Interfaces.Terminal_n terminal,
    P_nominal=P_nominal,
    V_nominal=V_nominal,
    linear=linear,
    mode=mode) if PlugPhase2
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  replaceable Electrical.Interfaces.PartialLoad load3(
    redeclare package PhaseSystem = PhaseSystems.OnePhase,
    redeclare Electrical.AC.OnePhase.Interfaces.Terminal_n terminal,
    P_nominal=P_nominal,
    V_nominal=V_nominal,
    linear=linear,
    mode=mode) if PlugPhase3
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
  parameter Modelica.SIunits.Power P_nominal(start=0)
    "Nominal power (negative if consumed, positive if generated)"  annotation(evaluate=true,Dialog(group="Nominal conditions",
        enable = mode <> Assumption.VariableZ_P_input));
  parameter Modelica.SIunits.Voltage V_nominal(min=0, start=220)
    "Nominal voltage (V_nominal >= 0)"  annotation(evaluate=true, Dialog(group="Nominal conditions", enable = (mode==Assumptionm.FixedZ_dynamic or linear)));
  Modelica.Blocks.Interfaces.RealInput y1 if  PlugPhase1 and mode==Buildings.Electrical.Types.Assumption.VariableZ_y_input
    "Fraction of the nominal power consumed"                       annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=180,
        origin={100,60}),iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=180,
        origin={100,60})));
  Modelica.Blocks.Interfaces.RealInput Pow1(unit="W") if
                                                        PlugPhase1 and mode==Buildings.Electrical.Types.Assumption.VariableZ_P_input
    "Power consumed"                       annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=180,
        origin={100,60}),iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=180,
        origin={100,60})));
  Modelica.Blocks.Interfaces.RealInput y2 if
                                            PlugPhase2 and mode==Buildings.Electrical.Types.Assumption.VariableZ_y_input
    "Fraction of the nominal power consumed"                       annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=180,
        origin={100,0}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=180,
        origin={100,0})));
  Modelica.Blocks.Interfaces.RealInput Pow2(unit="W") if
                                                        PlugPhase2 and mode==Buildings.Electrical.Types.Assumption.VariableZ_P_input
    "Power consumed"                       annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=180,
        origin={100,0}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=180,
        origin={100,0})));
  Modelica.Blocks.Interfaces.RealInput y3 if
                                            PlugPhase3 and mode==Buildings.Electrical.Types.Assumption.VariableZ_y_input
    "Fraction of the nominal power consumed"                       annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=180,
        origin={100,-60}),
                         iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=180,
        origin={100,-60})));
  Modelica.Blocks.Interfaces.RealInput Pow3(unit="W") if
                                                        PlugPhase3 and mode==Buildings.Electrical.Types.Assumption.VariableZ_P_input
    "Power consumed"                       annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=180,
        origin={100,-60}),
                         iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=180,
        origin={100,-60})));
  Buildings.Electrical.AC.ThreePhasesUnbalanced.Interfaces.Connection3to4_n
                             connection3to4
    annotation (Placement(transformation(extent={{-60,-10},{-80,10}})));
  replaceable Buildings.Electrical.Interfaces.PartialGround ground(
    redeclare package PhaseSystem = PhaseSystems.OnePhase,
    redeclare Electrical.AC.OnePhase.Interfaces.Terminal_n terminal)
    annotation (Placement(transformation(extent={{-70,-80},{-50,-60}})));
equation

  Connections.branch(connection3to4.terminal4.phase[1].theta, connection3to4.terminal4.phase[4].theta);
  connection3to4.terminal4.phase[1].theta = connection3to4.terminal4.phase[4].theta;
  for i in 1:3 loop
    Connections.branch(connection3to4.terminal3.phase[i].theta, connection3to4.terminal4.phase[i].theta);
    connection3to4.terminal3.phase[i].theta = connection3to4.terminal4.phase[i].theta;
  end for;

  if mode==Buildings.Electrical.Types.Assumption.VariableZ_y_input then
    if PlugPhase1 then
      connect(y1, load1.y) annotation (Line(
      points={{100,60},{40,60},{40,40},{10,40}},
      color={0,0,127},
      smooth=Smooth.None));
    end if;
    if PlugPhase2 then
      connect(y2, load2.y) annotation (Line(
      points={{100,0},{10,0}},
      color={0,0,127},
      smooth=Smooth.None));
    end if;
    if PlugPhase3 then
      connect(y3, load3.y) annotation (Line(
      points={{100,-60},{40,-60},{40,-40},{10,-40}},
      color={0,0,127},
      smooth=Smooth.None));
    end if;
  end if;

  if mode==Buildings.Electrical.Types.Assumption.VariableZ_P_input then
    if PlugPhase1 then
      connect(Pow1, load1.Pow) annotation (Line(
      points={{100,60},{40,60},{40,40},{10,40}},
      color={0,0,127},
      smooth=Smooth.None));
    end if;
    if PlugPhase2 then
      connect(Pow2, load2.Pow) annotation (Line(
      points={{100,0},{10,0}},
      color={0,0,127},
      smooth=Smooth.None));
    end if;
    if PlugPhase3 then
      connect(Pow3, load3.Pow) annotation (Line(
      points={{100,-60},{40,-60},{40,-40},{10,-40}},
      color={0,0,127},
      smooth=Smooth.None));
    end if;
  end if;

  connect(connection3to4.terminal3, terminal_p) annotation (Line(
      points={{-80,6.66134e-16},{-86,6.66134e-16},{-86,4.44089e-16},{-100,4.44089e-16}},
      color={0,120,120},
      smooth=Smooth.None));
  if PlugPhase2 then
    connect(connection3to4.terminal4.phase[2], load2.terminal) annotation (Line(
      points={{-60,6.66134e-16},{-36,6.66134e-16},{-36,0},{-10,0}},
      color={0,120,120},
      smooth=Smooth.None));
  end if;
  if PlugPhase3 then
    connect(connection3to4.terminal4.phase[3], load3.terminal) annotation (Line(
      points={{-60,6.66134e-16},{-40,6.66134e-16},{-40,-40},{-10,-40}},
      color={0,120,120},
      smooth=Smooth.None));
  end if;
  if PlugPhase1 then
    connect(connection3to4.terminal4.phase[1], load1.terminal) annotation (Line(
      points={{-60,6.66134e-16},{-40,6.66134e-16},{-40,40},{-10,40}},
      color={0,120,120},
      smooth=Smooth.None));
  end if;

  connect(connection3to4.terminal4.phase[4], ground.terminal) annotation (Line(
      points={{-60,6.66134e-16},{-60,-60}},
      color={0,120,120},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics));
end PartialLoad;
