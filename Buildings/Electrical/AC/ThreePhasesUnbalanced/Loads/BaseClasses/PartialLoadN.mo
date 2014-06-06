within Buildings.Electrical.AC.ThreePhasesUnbalanced.Loads.BaseClasses;
partial model PartialLoadN
  import Buildings;
  extends Buildings.Electrical.Interfaces.PartialPluggableUnbalanced;
  parameter Boolean linear = false
    "If =true introduce a linearization in the load"                                                    annotation(Dialog(group="Modelling assumption"));
  parameter Buildings.Electrical.Types.Assumption mode(
    min=Buildings.Electrical.Types.Assumption.FixedZ_steady_state,
    max=Buildings.Electrical.Types.Assumption.VariableZ_y_input)=Buildings.Electrical.Types.Assumption.FixedZ_steady_state
    "Parameters that specifies the mode of the load (e.g., steady state, dynamic, prescribed power consumption, etc.)"
                                                                                                        annotation(Dialog(group="Modelling assumption"));

  parameter Modelica.SIunits.Power P_nominal(start=0)
    "Nominal power (negative if consumed, positive if generated)"  annotation(Dialog(group="Nominal conditions",
        enable = mode <> Assumption.VariableZ_P_input));
  parameter Modelica.SIunits.Voltage V_nominal(min=0, start=220)
    "Nominal voltage (V_nominal >= 0)"  annotation(Dialog(group="Nominal conditions", enable = (mode==Assumptionm.FixedZ_dynamic or linear)));

  parameter Boolean VoltageCTRL = false "This flag enables the voltage control" annotation(Evaluate=true, Dialog(group="Voltage CTRL"));
  parameter Real Vthresh(min=0.0, max=1.0) = 0.1
    "Threshold that activates voltage ctrl (ratio of nominal voltage)" annotation(Dialog(group="Voltage CTRL",
        enable = VoltageCTRL));
  parameter Modelica.SIunits.Time Tdelay = 300
    "Time to wait before plugging the load again after disconnection" annotation(Dialog(group="Voltage CTRL",
        enable = VoltageCTRL));
  Buildings.Electrical.AC.ThreePhasesUnbalanced.Interfaces.Terminal4_n
                       terminal_p
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));

  replaceable Electrical.Interfaces.PartialLoad load1(
    redeclare package PhaseSystem = PhaseSystems.OnePhase,
    redeclare Electrical.AC.OnePhase.Interfaces.Terminal_n terminal,
    P_nominal=P_nominal,
    V_nominal=V_nominal,
    linear=linear,
    mode=mode) if PlugPhase1
    annotation (Placement(transformation(extent={{-10,40},{10,60}})));
  replaceable Electrical.Interfaces.PartialLoad load2(
    redeclare package PhaseSystem = PhaseSystems.OnePhase,
    redeclare Electrical.AC.OnePhase.Interfaces.Terminal_n terminal,
    P_nominal=P_nominal,
    V_nominal=V_nominal,
    linear=linear,
    mode=mode) if PlugPhase2
    annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));
  replaceable Electrical.Interfaces.PartialLoad load3(
    redeclare package PhaseSystem = PhaseSystems.OnePhase,
    redeclare Electrical.AC.OnePhase.Interfaces.Terminal_n terminal,
    P_nominal=P_nominal,
    V_nominal=V_nominal,
    linear=linear,
    mode=mode) if PlugPhase3
    annotation (Placement(transformation(extent={{-10,-98},{10,-78}})));
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
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Electrical.Utilities.VoltageControl vCTRL_1(
    redeclare package PhaseSystem = PhaseSystems.OnePhase,
    redeclare Buildings.Electrical.AC.OnePhase.Interfaces.Terminal_n
      terminal,
    V_nominal=V_nominal,
    Vthresh=Vthresh,
    Tdelay=Tdelay) if PlugPhase1 and VoltageCTRL
    annotation (Placement(transformation(extent={{10,80},{30,100}})));
  Modelica.Blocks.Math.Product cmd1 if PlugPhase1 and VoltageCTRL
    annotation (Placement(transformation(extent={{56,56},{36,76}})));
  Buildings.Electrical.Utilities.VoltageControl vCTRL_2(
    redeclare package PhaseSystem = PhaseSystems.OnePhase,
    redeclare Buildings.Electrical.AC.OnePhase.Interfaces.Terminal_n
      terminal,
    V_nominal=V_nominal,
    Vthresh=Vthresh,
    Tdelay=Tdelay) if PlugPhase2 and VoltageCTRL
    annotation (Placement(transformation(extent={{10,10},{30,30}})));
  Modelica.Blocks.Math.Product cmd2 if PlugPhase2 and VoltageCTRL
    annotation (Placement(transformation(extent={{56,-16},{36,4}})));
  Buildings.Electrical.Utilities.VoltageControl vCTRL_3(
    redeclare package PhaseSystem = PhaseSystems.OnePhase,
    redeclare Buildings.Electrical.AC.OnePhase.Interfaces.Terminal_n
      terminal,
    V_nominal=V_nominal,
    Vthresh=Vthresh,
    Tdelay=Tdelay) if PlugPhase3 and VoltageCTRL
    annotation (Placement(transformation(extent={{10,-60},{30,-40}})));
  Modelica.Blocks.Math.Product cmd3 if PlugPhase3 and VoltageCTRL
    annotation (Placement(transformation(extent={{56,-80},{36,-60}})));
equation

  Connections.branch(connection3to4.terminal4.phase[1].theta, connection3to4.terminal4.phase[4].theta);
  connection3to4.terminal4.phase[1].theta = connection3to4.terminal4.phase[4].theta;
  for i in 1:3 loop
    Connections.branch(connection3to4.terminal3.phase[i].theta, connection3to4.terminal4.phase[i].theta);
    connection3to4.terminal3.phase[i].theta = connection3to4.terminal4.phase[i].theta;
  end for;

  // This connection is NOT conditional
  connect(connection3to4.terminal4, terminal_p) annotation (Line(
      points={{-80,6.66134e-16},{-86,6.66134e-16},{-86,4.44089e-16},{-100,
          4.44089e-16}},
      color={0,120,120},
      smooth=Smooth.None));

  // Connections enabled when the input provided is y (between 0 and 1)
  if mode==Buildings.Electrical.Types.Assumption.VariableZ_y_input then
    if PlugPhase1 and VoltageCTRL then
      connect(cmd1.y, load1.y) annotation (Line(
        points={{35,66},{20,66},{20,50},{10,50}},
        color={0,0,127},
        smooth=Smooth.None));
      connect(cmd1.u2, y1) annotation (Line(
        points={{58,60},{100,60}},
        color={0,0,127},
        smooth=Smooth.None));
    end if;
    if PlugPhase1 and not VoltageCTRL then
      connect(y1, load1.y) annotation (Line(
        points={{100,60},{70,60},{70,50},{10,50}},
        color={0,0,127},
        smooth=Smooth.None));
    end if;

    if PlugPhase2 and VoltageCTRL then
      connect(cmd2.y, load2.y) annotation (Line(
      points={{35,-6},{23,-6},{23,-20},{10,-20}},
      color={0,0,127},
      smooth=Smooth.None));
      connect(cmd2.u2, y2) annotation (Line(
      points={{58,-12},{72,-12},{72,1.77636e-15},{100,1.77636e-15}},
      color={0,0,127},
      smooth=Smooth.None));
    end if;
    if PlugPhase2 and not VoltageCTRL then
      connect(y2, load2.y) annotation (Line(
      points={{100,8.88178e-16},{72,8.88178e-16},{72,-20},{10,-20}},
      color={0,0,127},
      smooth=Smooth.None));
    end if;

    if PlugPhase3 and VoltageCTRL then
      connect(cmd3.y, load3.y) annotation (Line(
      points={{35,-70},{24,-70},{24,-88},{10,-88}},
      color={0,0,127},
      smooth=Smooth.None));
      connect(cmd3.u2, y3) annotation (Line(
      points={{58,-76},{72,-76},{72,-60},{100,-60}},
      color={0,0,127},
      smooth=Smooth.None));
    end if;
    if PlugPhase3 and not VoltageCTRL then
      connect(y3, load3.y) annotation (Line(
      points={{100,-60},{72,-60},{72,-88},{10,-88}},
      color={0,0,127},
      smooth=Smooth.None));
    end if;
  end if;

  // Connections enabled when the input provided is the power
  if mode==Buildings.Electrical.Types.Assumption.VariableZ_P_input then
    if PlugPhase1 and VoltageCTRL then
      connect(cmd1.y, load1.Pow) annotation (Line(
        points={{35,66},{20,66},{20,50},{10,50}},
        color={0,0,127},
        smooth=Smooth.None));
      connect(cmd1.u2, Pow1) annotation (Line(
        points={{58,60},{100,60}},
        color={0,0,127},
        smooth=Smooth.None));
    end if;
    if PlugPhase1 and not VoltageCTRL then
      connect(Pow1, load1.Pow) annotation (Line(
        points={{100,60},{70,60},{70,50},{10,50}},
        color={0,0,127},
        smooth=Smooth.None));
    end if;

    if PlugPhase2 and VoltageCTRL then
      connect(cmd2.y, load2.Pow) annotation (Line(
      points={{35,-6},{23,-6},{23,-20},{10,-20}},
      color={0,0,127},
      smooth=Smooth.None));
      connect(cmd2.u2, Pow2) annotation (Line(
      points={{58,-12},{72,-12},{72,1.77636e-15},{100,1.77636e-15}},
      color={0,0,127},
      smooth=Smooth.None));
    end if;
    if PlugPhase2 and not VoltageCTRL then
      connect(Pow2, load2.Pow) annotation (Line(
      points={{100,8.88178e-16},{72,8.88178e-16},{72,-20},{10,-20}},
      color={0,0,127},
      smooth=Smooth.None));
    end if;

    if PlugPhase3 and VoltageCTRL then
      connect(cmd3.y, load3.Pow) annotation (Line(
      points={{35,-70},{24,-70},{24,-88},{10,-88}},
      color={0,0,127},
      smooth=Smooth.None));
      connect(cmd3.u2, Pow3) annotation (Line(
      points={{58,-76},{72,-76},{72,-60},{100,-60}},
      color={0,0,127},
      smooth=Smooth.None));
    end if;
    if PlugPhase3 and not VoltageCTRL then
      connect(Pow3, load3.Pow) annotation (Line(
      points={{100,-60},{72,-60},{72,-88},{10,-88}},
      color={0,0,127},
      smooth=Smooth.None));
    end if;
  end if;

  // Connection of the single loads to the 3phases connector
  if PlugPhase2 then
    connect(connection3to4.terminal3.phase[2], load2.terminal) annotation (Line(
      points={{-60,6.66134e-16},{-40,6.66134e-16},{-40,-20},{-10,-20}},
      color={0,120,120},
      smooth=Smooth.None));
  end if;
  if PlugPhase3 then
    connect(connection3to4.terminal3.phase[3], load3.terminal) annotation (Line(
      points={{-60,6.66134e-16},{-40,6.66134e-16},{-40,-88},{-10,-88}},
      color={0,120,120},
      smooth=Smooth.None));
  end if;
  if PlugPhase1 then
    connect(connection3to4.terminal3.phase[1], load1.terminal) annotation (Line(
      points={{-60,6.66134e-16},{-40,6.66134e-16},{-40,50},{-10,50}},
      color={0,120,120},
      smooth=Smooth.None));
  end if;

  // Connections enabled when phase 1 is plugged and voltage ctrl activated
  if PlugPhase1 and VoltageCTRL then
    connect(load1.terminal, vCTRL_1.terminal)        annotation (Line(
      points={{-10,50},{-20,50},{-20,90},{10,90}},
      color={0,120,120},
      smooth=Smooth.None));
    connect(vCTRL_1.y, cmd1.u1)        annotation (Line(
        points={{30.6,90},{70,90},{70,72},{58,72}},
        color={0,0,127},
        smooth=Smooth.None));
  end if;

  if PlugPhase2 and VoltageCTRL then
    connect(load2.terminal, vCTRL_2.terminal) annotation (Line(
      points={{-10,-20},{-20,-20},{-20,20},{10,20}},
      color={0,120,120},
      smooth=Smooth.None));
    connect(vCTRL_2.y, cmd2.u1) annotation (Line(
        points={{30.6,20},{66,20},{66,0},{58,0}},
        color={0,0,127},
        smooth=Smooth.None));
  end if;

  if PlugPhase3 and VoltageCTRL then
    connect(load3.terminal, vCTRL_3.terminal) annotation (Line(
      points={{-10,-88},{-20,-88},{-20,-50},{10,-50}},
      color={0,120,120},
      smooth=Smooth.None));
    connect(vCTRL_3.y, cmd3.u1) annotation (Line(
        points={{30.6,-50},{66,-50},{66,-64},{58,-64}},
        color={0,0,127},
        smooth=Smooth.None));
  end if;

    annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics));
end PartialLoadN;
