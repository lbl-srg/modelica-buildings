within Buildings.Electrical.AC.ThreePhasesUnbalanced.Loads.BaseClasses;
partial model PartialLoad
  parameter Boolean linear = false
    "If =true introduce a linearization in the load"                                                    annotation(evaluate=true,Dialog(group="Modelling assumption"));
  parameter Buildings.Electrical.Types.Assumption mode(
    min=Buildings.Electrical.Types.Assumption.FixedZ_steady_state,
    max=Buildings.Electrical.Types.Assumption.VariableZ_y_input)=Buildings.Electrical.Types.Assumption.FixedZ_steady_state
    "Parameters that specifies the mode of the load (e.g., steady state, dynamic, prescribed power consumption, etc.)"
                                                                                                        annotation(evaluate=true,Dialog(group="Modelling assumption"));
  Interface.Terminal_n terminal_p
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  replaceable Electrical.Interfaces.PartialLoad load1(
    redeclare package PhaseSystem = PhaseSystems.OnePhase,
    redeclare Electrical.AC.OnePhase.Interfaces.Terminal_n terminal,
    P_nominal=P_nominal,
    V_nominal=V_nominal,
    linear=linear,
    mode=mode)
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));
  replaceable Electrical.Interfaces.PartialLoad load2(
    redeclare package PhaseSystem = PhaseSystems.OnePhase,
    redeclare Electrical.AC.OnePhase.Interfaces.Terminal_n terminal,
    P_nominal=P_nominal,
    V_nominal=V_nominal,
    linear=linear,
    mode=mode)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  replaceable Electrical.Interfaces.PartialLoad load3(
    redeclare package PhaseSystem = PhaseSystems.OnePhase,
    redeclare Electrical.AC.OnePhase.Interfaces.Terminal_n terminal,
    P_nominal=P_nominal,
    V_nominal=V_nominal,
    linear=linear,
    mode=mode)
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
  parameter Modelica.SIunits.Power P_nominal(start=0)
    "Nominal power (negative if consumed, positive if generated)"  annotation(evaluate=true,Dialog(group="Nominal conditions",
        enable = mode <> Assumption.VariableZ_P_input));
  parameter Modelica.SIunits.Voltage V_nominal(min=0, start=220)
    "Nominal voltage (V_nominal >= 0)"  annotation(evaluate=true, Dialog(group="Nominal conditions", enable = (mode==Assumptionm.FixedZ_dynamic or linear)));
  Modelica.Blocks.Interfaces.RealInput y1 if
                                            mode==Buildings.Electrical.Types.Assumption.VariableZ_y_input
    "Fraction of the nominal power consumed"                       annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=180,
        origin={100,60}),iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=180,
        origin={100,60})));
  Modelica.Blocks.Interfaces.RealInput Pow1(unit="W") if
                                                        mode==Buildings.Electrical.Types.Assumption.VariableZ_P_input
    "Power consumed"                       annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=180,
        origin={100,60}),iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=180,
        origin={100,60})));
  Modelica.Blocks.Interfaces.RealInput y2 if
                                            mode==Buildings.Electrical.Types.Assumption.VariableZ_y_input
    "Fraction of the nominal power consumed"                       annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=180,
        origin={100,0}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=180,
        origin={100,0})));
  Modelica.Blocks.Interfaces.RealInput Pow2(unit="W") if
                                                        mode==Buildings.Electrical.Types.Assumption.VariableZ_P_input
    "Power consumed"                       annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=180,
        origin={100,0}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=180,
        origin={100,0})));
  Modelica.Blocks.Interfaces.RealInput y3 if
                                            mode==Buildings.Electrical.Types.Assumption.VariableZ_y_input
    "Fraction of the nominal power consumed"                       annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=180,
        origin={100,-60}),
                         iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=180,
        origin={100,-60})));
  Modelica.Blocks.Interfaces.RealInput Pow3(unit="W") if
                                                        mode==Buildings.Electrical.Types.Assumption.VariableZ_P_input
    "Power consumed"                       annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=180,
        origin={100,-60}),
                         iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=180,
        origin={100,-60})));
equation
  connect(load1.terminal, terminal_p.phase[1])          annotation (Line(
      points={{-10,40},{-56,40},{-56,4.44089e-16},{-100,4.44089e-16}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(load2.terminal, terminal_p.phase[2])           annotation (Line(
      points={{-10,6.66134e-16},{-54,6.66134e-16},{-54,4.44089e-16},{-100,4.44089e-16}},
      color={0,120,120},
      smooth=Smooth.None));

  connect(load3.terminal, terminal_p.phase[3])           annotation (Line(
      points={{-10,-40},{-56,-40},{-56,4.44089e-16},{-100,4.44089e-16}},
      color={0,120,120},
      smooth=Smooth.None));

  if mode==Buildings.Electrical.Types.Assumption.VariableZ_y_input then
    connect(y1, load1.y) annotation (Line(
      points={{100,60},{40,60},{40,40},{10,40}},
      color={0,0,127},
      smooth=Smooth.None));
    connect(y2, load2.y) annotation (Line(
      points={{100,0},{10,0}},
      color={0,0,127},
      smooth=Smooth.None));
    connect(y3, load3.y) annotation (Line(
      points={{100,-60},{40,-60},{40,-40},{10,-40}},
      color={0,0,127},
      smooth=Smooth.None));
  end if;

  if mode==Buildings.Electrical.Types.Assumption.VariableZ_P_input then
    connect(Pow1, load1.Pow) annotation (Line(
      points={{100,60},{40,60},{40,40},{10,40}},
      color={0,0,127},
      smooth=Smooth.None));
    connect(Pow2, load2.Pow) annotation (Line(
      points={{100,0},{10,0}},
      color={0,0,127},
      smooth=Smooth.None));
    connect(Pow3, load3.Pow) annotation (Line(
      points={{100,-60},{40,-60},{40,-40},{10,-40}},
      color={0,0,127},
      smooth=Smooth.None));
  end if;

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics));
end PartialLoad;
