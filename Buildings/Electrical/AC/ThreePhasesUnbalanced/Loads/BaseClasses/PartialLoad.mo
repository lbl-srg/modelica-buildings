within Buildings.Electrical.AC.ThreePhasesUnbalanced.Loads.BaseClasses;
partial model PartialLoad "Partial model of a three phases load"
  extends Buildings.Electrical.Interfaces.PartialPluggableUnbalanced;
  parameter Buildings.Electrical.Types.LoadConnection loadConn=
    Buildings.Electrical.Types.LoadConnection.wye_to_wyeg
    "Type of load connection (Yg or D)";
  parameter Boolean linear = false
    "If =true introduce a linearization in the load" annotation(Dialog(group="Modelling assumption"));
  parameter Buildings.Electrical.Types.Assumption mode(
    min=Buildings.Electrical.Types.Assumption.FixedZ_steady_state,
    max=Buildings.Electrical.Types.Assumption.VariableZ_y_input)=
    Buildings.Electrical.Types.Assumption.FixedZ_steady_state "Parameters that specifies the mode of the load (e.g., steady state, dynamic, 
    prescribed power consumption, etc.)"
    annotation(Dialog(group="Modelling assumption"));
  Buildings.Electrical.AC.ThreePhasesUnbalanced.Interfaces.Terminal_n
  terminal_p
    "Connector for three phases unbalanced systems without neutral cable"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));

  replaceable Buildings.Electrical.Interfaces.PartialLoad load1(
    redeclare package PhaseSystem = Buildings.Electrical.PhaseSystems.OnePhase,
    redeclare Buildings.Electrical.AC.OnePhase.Interfaces.Terminal_n terminal,
    P_nominal=P_nominal,
    V_nominal=(if loadConn == Buildings.Electrical.Types.LoadConnection.wye_to_wyeg then V_nominal else V_nominal/sqrt(3)),
    linear=linear,
    mode=mode) if PlugPhase1 "Load 1"
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));
  replaceable Buildings.Electrical.Interfaces.PartialLoad load2(
    redeclare package PhaseSystem = Buildings.Electrical.PhaseSystems.OnePhase,
    redeclare Buildings.Electrical.AC.OnePhase.Interfaces.Terminal_n terminal,
    P_nominal=P_nominal,
    V_nominal=(if loadConn == Buildings.Electrical.Types.LoadConnection.wye_to_wyeg then V_nominal else V_nominal/sqrt(3)),
    linear=linear,
    mode=mode) if PlugPhase2 "Load 2"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  replaceable Buildings.Electrical.Interfaces.PartialLoad load3(
    redeclare package PhaseSystem = Buildings.Electrical.PhaseSystems.OnePhase,
    redeclare Buildings.Electrical.AC.OnePhase.Interfaces.Terminal_n terminal,
    P_nominal=P_nominal,
    V_nominal=(if loadConn == Buildings.Electrical.Types.LoadConnection.wye_to_wyeg then V_nominal else V_nominal/sqrt(3)),
    linear=linear,
    mode=mode) if PlugPhase3 "Load 3"
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
  parameter Modelica.SIunits.Power P_nominal(start=0)
    "Nominal power (negative if consumed, positive if generated)"  annotation(Dialog(group="Nominal conditions",
        enable = mode <> Assumption.VariableZ_P_input));
  parameter Modelica.SIunits.Voltage V_nominal(min=0, start=480) = 480
    "Nominal voltage (V_nominal >= 0)" annotation(Dialog(group="Nominal conditions", enable = (mode==Assumptionm.FixedZ_dynamic or linear)));
  Modelica.Blocks.Interfaces.RealInput y1 if  PlugPhase1 and
    mode == Buildings.Electrical.Types.Assumption.VariableZ_y_input
    "Fraction of the nominal power consumed"                       annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=180,
        origin={100,60}),iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=180,
        origin={100,60})));
  Modelica.Blocks.Interfaces.RealInput Pow1(unit="W") if PlugPhase1 and
    mode == Buildings.Electrical.Types.Assumption.VariableZ_P_input
    "Power consumed" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=180,
        origin={100,60}),iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=180,
        origin={100,60})));
  Modelica.Blocks.Interfaces.RealInput y2 if PlugPhase2 and
    mode == Buildings.Electrical.Types.Assumption.VariableZ_y_input
    "Fraction of the nominal power consumed" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=180,
        origin={100,0}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=180,
        origin={100,0})));
  Modelica.Blocks.Interfaces.RealInput Pow2(unit="W") if PlugPhase2 and
    mode == Buildings.Electrical.Types.Assumption.VariableZ_P_input
    "Power consumed"                       annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=180,
        origin={100,0}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=180,
        origin={100,0})));
  Modelica.Blocks.Interfaces.RealInput y3 if PlugPhase3 and
    mode == Buildings.Electrical.Types.Assumption.VariableZ_y_input
    "Fraction of the nominal power consumed" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=180,
        origin={100,-60}),
                         iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=180,
        origin={100,-60})));
  Modelica.Blocks.Interfaces.RealInput Pow3(unit="W") if PlugPhase3 and
    mode == Buildings.Electrical.Types.Assumption.VariableZ_P_input
    "Power consumed"                       annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=180,
        origin={100,-60}),
                         iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=180,
        origin={100,-60})));
  Buildings.Electrical.AC.ThreePhasesUnbalanced.Interfaces.WyeToDelta
    wyeToDelta if (loadConn == Buildings.Electrical.Types.LoadConnection.wye_to_delta)
    "Wye to delta load connection"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Buildings.Electrical.AC.ThreePhasesUnbalanced.Interfaces.WyeToWyeGround
    wyeToWyeGround if (loadConn == Buildings.Electrical.Types.LoadConnection.wye_to_wyeg)
    "Wye to wye grounded connection"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
equation

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

  if PlugPhase1 then
    connect(wyeToWyeGround.wyeg.phase[1], load1.terminal) annotation (Line(
      points={{-60,-10},{-20,-10},{-20,40},{-10,40}},
      color={0,120,120},
      smooth=Smooth.None,
        pattern=LinePattern.Dash));
    connect(wyeToDelta.delta.phase[1], load1.terminal) annotation (Line(
        points={{-60,10},{-36,10},{-36,40},{-10,40}},
        color={0,120,120},
        smooth=Smooth.None));
  end if;
  if PlugPhase2 then
    connect(wyeToWyeGround.wyeg.phase[2], load2.terminal) annotation (Line(
      points={{-60,-10},{-20,-10},{-20,0},{-10,0}},
      color={0,120,120},
      smooth=Smooth.None,
        pattern=LinePattern.Dash));
    connect(wyeToDelta.delta.phase[2], load2.terminal) annotation (Line(
        points={{-60,10},{-36,10},{-36,0},{-10,0}},
        color={0,120,120},
        smooth=Smooth.None));
  end if;
  if PlugPhase3 then
    connect(wyeToWyeGround.wyeg.phase[3], load3.terminal) annotation (Line(
      points={{-60,-10},{-20,-10},{-20,-40},{-10,-40}},
      color={0,120,120},
      smooth=Smooth.None,
        pattern=LinePattern.Dash));
    connect(wyeToDelta.delta.phase[3], load3.terminal) annotation (Line(
        points={{-60,10},{-36,10},{-36,-40},{-10,-40}},
        color={0,120,120},
        smooth=Smooth.None));
  end if;

  connect(terminal_p, wyeToDelta.wye) annotation (Line(
      points={{-100,0},{-86,0},{-86,10},{-80,10}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(terminal_p, wyeToWyeGround.wye) annotation (Line(
      points={{-100,0},{-86,0},{-86,-10},{-80,-10}},
      color={0,120,120},
      smooth=Smooth.None));

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics),
    Documentation(info="<html>
<p>
This model represents a partial interface for a three phases AC unbalanced
load without neutral cable.
</p>
<p>
The loads on each phase can be removed using the boolean flags 
<code>plugPhase1</code>, <code>plugPhase2</code>, and <code>plugPhase3</code>.
These parameters can be used to generate unbalanced loads.
</p>
<p>
The loads can be connected either in a Y or Delta configuration using
the parameter <code>loadConn</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
August 27, 2014, by Marco Bonvini:<br/>
Revised documentation.
</li>
</ul>
</html>"));
end PartialLoad;
