within Buildings.Electrical.AC.ThreePhasesUnbalanced.Loads.BaseClasses;
partial model BaseLoadCtrl
  "Partial model of a three-phase unbalanced load with voltage controllers"
  extends Buildings.Electrical.Interfaces.PartialPluggableUnbalanced;
  parameter Buildings.Electrical.Types.LoadConnection loadConn=
    Buildings.Electrical.Types.LoadConnection.wye_to_wyeg
    "Type of load connection (Yg or D)";
  parameter Boolean linearized = false
    "If =true introduce a linearization in the load" annotation(Dialog(group="Modelling assumption"));
  parameter Buildings.Electrical.Types.Load mode(
    min=Buildings.Electrical.Types.Load.FixedZ_steady_state,
    max=Buildings.Electrical.Types.Load.VariableZ_y_input)=
    Buildings.Electrical.Types.Load.FixedZ_steady_state "Parameters that specifies the mode of the load (e.g., steady state,
    dynamic, prescribed power consumption, etc.)" annotation(Dialog(group="Modelling assumption"));
  parameter Modelica.SIunits.Power P_nominal(start=0)
    "Nominal power (negative if consumed, positive if generated)"  annotation(Dialog(group="Nominal conditions",
        enable = mode <> Buildings.Electrical.Types.Load.VariableZ_P_input));
  parameter Modelica.SIunits.Voltage V_nominal(min=0, start = 480)
    "Nominal voltage (V_nominal >= 0)"  annotation(Dialog(group="Nominal conditions", enable = (mode==Assumptionm.FixedZ_dynamic or linear)));
  parameter Boolean voltageCtrl = false "This flag enables the voltage control"
                                            annotation(Evaluate=true, Dialog(group="Voltage CTRL"));
  parameter Real vThresh(min=0.0, max=1.0) = 0.1
    "Threshold that activates voltage ctrl (ratio of nominal voltage)" annotation(Dialog(group="Voltage CTRL",
        enable = voltageCtrl));
  parameter Modelica.SIunits.Time tDelay = 300
    "Time to wait before plugging the load again after disconnection" annotation(Dialog(group="Voltage CTRL",
        enable = voltageCtrl));
  parameter Types.InitMode initMode=Buildings.Electrical.Types.InitMode.zero_current
    "Initialization mode for homotopy operator"
    annotation (Dialog(tab="initialization"));
  replaceable Buildings.Electrical.Interfaces.Load load1(
    redeclare package PhaseSystem = Buildings.Electrical.PhaseSystems.OnePhase,
    redeclare Buildings.Electrical.AC.OnePhase.Interfaces.Terminal_n terminal,
    P_nominal=P_nominal,
    linearized=linearized,
    mode=mode,
    V_nominal=V_nominal/sqrt(3),
    initMode=initMode) if
       plugPhase1 "Load 1"
    annotation (Placement(transformation(extent={{-10,40},{10,60}})));
  replaceable Buildings.Electrical.Interfaces.Load load2(
    redeclare package PhaseSystem = Buildings.Electrical.PhaseSystems.OnePhase,
    redeclare Buildings.Electrical.AC.OnePhase.Interfaces.Terminal_n terminal,
    P_nominal=P_nominal,
    linearized=linearized,
    mode=mode,
    V_nominal=V_nominal/sqrt(3),
    initMode=initMode) if
       plugPhase2 "Load 2"
    annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));
  replaceable Buildings.Electrical.Interfaces.Load load3(
    redeclare package PhaseSystem = Buildings.Electrical.PhaseSystems.OnePhase,
    redeclare Buildings.Electrical.AC.OnePhase.Interfaces.Terminal_n terminal,
    P_nominal=P_nominal,
    linearized=linearized,
    mode=mode,
    V_nominal=V_nominal/sqrt(3),
    initMode=initMode) if
       plugPhase3 "Load 3"
    annotation (Placement(transformation(extent={{-10,-98},{10,-78}})));
  Modelica.Blocks.Interfaces.RealInput y1 if  plugPhase1 and
    mode == Buildings.Electrical.Types.Load.VariableZ_y_input
    "Fraction of the nominal power consumed"                       annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=180,
        origin={120,80}),iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=180,
        origin={120,80})));
  Modelica.Blocks.Interfaces.RealInput Pow1(unit="W") if plugPhase1 and
    mode == Buildings.Electrical.Types.Load.VariableZ_P_input "Power consumed"
                                           annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=180,
        origin={120,80}),iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=180,
        origin={120,80})));
  Modelica.Blocks.Interfaces.RealInput y2 if plugPhase2 and
    mode == Buildings.Electrical.Types.Load.VariableZ_y_input
    "Fraction of the nominal power consumed"                       annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=180,
        origin={120,0}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=180,
        origin={120,0})));
  Modelica.Blocks.Interfaces.RealInput Pow2(unit="W") if plugPhase2 and
    mode == Buildings.Electrical.Types.Load.VariableZ_P_input "Power consumed"
                                           annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=180,
        origin={120,0}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=180,
        origin={120,0})));
  Modelica.Blocks.Interfaces.RealInput y3 if plugPhase3 and
    mode == Buildings.Electrical.Types.Load.VariableZ_y_input
    "Fraction of the nominal power consumed"                       annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=180,
        origin={120,-80}),
                         iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=180,
        origin={120,-80})));
  Modelica.Blocks.Interfaces.RealInput Pow3(unit="W") if plugPhase3 and
    mode == Buildings.Electrical.Types.Load.VariableZ_P_input "Power consumed"
                                           annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=180,
        origin={120,-80}),
                         iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=180,
        origin={120,-80})));
  Buildings.Electrical.Utilities.VoltageControl vCTRL_1(
    redeclare package PhaseSystem = Buildings.Electrical.PhaseSystems.OnePhase,
    redeclare Buildings.Electrical.AC.OnePhase.Interfaces.Terminal_n terminal,
    vThresh=vThresh,
    tDelay=tDelay,
    V_nominal=V_nominal/sqrt(3)) if
       plugPhase1 and voltageCtrl "Voltage controller for load 1"
    annotation (Placement(transformation(extent={{10,80},{30,100}})));
  Modelica.Blocks.Math.Product cmd1 if plugPhase1 and voltageCtrl
    "Block that impose voltage ctrl"
    annotation (Placement(transformation(extent={{56,56},{36,76}})));
  Buildings.Electrical.Utilities.VoltageControl vCTRL_2(
    redeclare package PhaseSystem = Buildings.Electrical.PhaseSystems.OnePhase,
    redeclare Buildings.Electrical.AC.OnePhase.Interfaces.Terminal_n terminal,
    vThresh=vThresh,
    tDelay=tDelay,
    V_nominal=V_nominal/sqrt(3)) if
       plugPhase2 and voltageCtrl "Voltage controller for load 2"
    annotation (Placement(transformation(extent={{10,10},{30,30}})));
  Modelica.Blocks.Math.Product cmd2 if plugPhase2 and voltageCtrl
    "Block that impose voltage ctrl"
    annotation (Placement(transformation(extent={{56,-16},{36,4}})));
  Buildings.Electrical.Utilities.VoltageControl vCTRL_3(
    redeclare package PhaseSystem = Buildings.Electrical.PhaseSystems.OnePhase,
    redeclare Buildings.Electrical.AC.OnePhase.Interfaces.Terminal_n terminal,
    vThresh=vThresh,
    tDelay=tDelay,
    V_nominal=V_nominal/sqrt(3)) if
       plugPhase3 and voltageCtrl "Voltage controller for load 3"
    annotation (Placement(transformation(extent={{10,-60},{30,-40}})));
  Modelica.Blocks.Math.Product cmd3 if plugPhase3 and voltageCtrl
    "Block that impose voltage ctrl"
    annotation (Placement(transformation(extent={{56,-80},{36,-60}})));
  Interfaces.WyeToDelta
    wyeToDelta if (loadConn == Buildings.Electrical.Types.LoadConnection.wye_to_delta)
    "Wye to delta load connection"
    annotation (Placement(transformation(extent={{-54,0},{-34,20}})));
  Interfaces.WyeToWyeGround
    wyeToWyeGround if (loadConn == Buildings.Electrical.Types.LoadConnection.wye_to_wyeg)
    "Wye to wye grounded connection"
    annotation (Placement(transformation(extent={{-54,-20},{-34,0}})));

equation
  // Connections enabled when the input provided is y (between 0 and 1)
  if mode==Buildings.Electrical.Types.Load.VariableZ_y_input then
    if plugPhase1 and voltageCtrl then
      connect(cmd1.y, load1.y) annotation (Line(
        points={{35,66},{20,66},{20,50},{10,50}},
        color={0,0,127},
        smooth=Smooth.None));
      connect(cmd1.u2, y1) annotation (Line(
        points={{58,60},{90,60},{90,80},{120,80}},
        color={0,0,127},
        smooth=Smooth.None));
    end if;
    if plugPhase1 and not voltageCtrl then
      connect(y1, load1.y) annotation (Line(
        points={{120,80},{66,80},{66,50},{10,50}},
        color={0,0,127},
        smooth=Smooth.None));
    end if;

    if plugPhase2 and voltageCtrl then
      connect(cmd2.y, load2.y) annotation (Line(
      points={{35,-6},{23,-6},{23,-20},{10,-20}},
      color={0,0,127},
      smooth=Smooth.None));
      connect(cmd2.u2, y2) annotation (Line(
      points={{58,-12},{72,-12},{72,0},{120,0}},
      color={0,0,127},
      smooth=Smooth.None));
    end if;
    if plugPhase2 and not voltageCtrl then
      connect(y2, load2.y) annotation (Line(
      points={{120,0},{66,0},{66,-20},{10,-20}},
      color={0,0,127},
      smooth=Smooth.None));
    end if;

    if plugPhase3 and voltageCtrl then
      connect(cmd3.y, load3.y) annotation (Line(
      points={{35,-70},{24,-70},{24,-88},{10,-88}},
      color={0,0,127},
      smooth=Smooth.None));
      connect(cmd3.u2, y3) annotation (Line(
      points={{58,-76},{72,-76},{72,-80},{120,-80}},
      color={0,0,127},
      smooth=Smooth.None));
    end if;
    if plugPhase3 and not voltageCtrl then
      connect(y3, load3.y) annotation (Line(
      points={{120,-80},{72,-80},{72,-88},{10,-88}},
      color={0,0,127},
      smooth=Smooth.None));
    end if;
  end if;

  // Connections enabled when the input provided is the power
  if mode==Buildings.Electrical.Types.Load.VariableZ_P_input then
    if plugPhase1 and voltageCtrl then
      connect(cmd1.y, load1.Pow) annotation (Line(
        points={{35,66},{20,66},{20,50},{10,50}},
        color={0,0,127},
        smooth=Smooth.None));
      connect(cmd1.u2, Pow1) annotation (Line(
        points={{58,60},{82,60},{82,80},{120,80}},
        color={0,0,127},
        smooth=Smooth.None));
    end if;
    if plugPhase1 and not voltageCtrl then
      connect(Pow1, load1.Pow) annotation (Line(
        points={{120,80},{70,80},{70,50},{10,50}},
        color={0,0,127},
        smooth=Smooth.None));
    end if;

    if plugPhase2 and voltageCtrl then
      connect(cmd2.y, load2.Pow) annotation (Line(
      points={{35,-6},{23,-6},{23,-20},{10,-20}},
      color={0,0,127},
      smooth=Smooth.None));
      connect(cmd2.u2, Pow2) annotation (Line(
      points={{58,-12},{72,-12},{72,0},{120,0}},
      color={0,0,127},
      smooth=Smooth.None));
    end if;
    if plugPhase2 and not voltageCtrl then
      connect(Pow2, load2.Pow) annotation (Line(
      points={{120,0},{72,0},{72,-20},{10,-20}},
      color={0,0,127},
      smooth=Smooth.None));
    end if;

    if plugPhase3 and voltageCtrl then
      connect(cmd3.y, load3.Pow) annotation (Line(
      points={{35,-70},{24,-70},{24,-88},{10,-88}},
      color={0,0,127},
      smooth=Smooth.None));
      connect(cmd3.u2, Pow3) annotation (Line(
      points={{58,-76},{72,-76},{72,-80},{120,-80}},
      color={0,0,127},
      smooth=Smooth.None));
    end if;
    if plugPhase3 and not voltageCtrl then
      connect(Pow3, load3.Pow) annotation (Line(
      points={{120,-80},{72,-80},{72,-88},{10,-88}},
      color={0,0,127},
      smooth=Smooth.None));
    end if;
  end if;

  // Connection of the single loads to the 3phases connector
  if plugPhase2 then
    connect(wyeToDelta.delta.phase[2], load2.terminal) annotation (Line(
      points={{-34,10},{-30,10},{-30,-20},{-10,-20}},
      color={0,120,120},
      smooth=Smooth.None));
    connect(wyeToWyeGround.wyeg.phase[2], load2.terminal) annotation (Line(
      points={{-34,-10},{-26,-10},{-26,-16},{-16,-16},{-16,-20},{-10,-20}},
      color={0,120,120},
      smooth=Smooth.None,
        pattern=LinePattern.Dash));
  end if;
  if plugPhase3 then
    connect(wyeToDelta.delta.phase[3], load3.terminal) annotation (Line(
      points={{-34,10},{-30,10},{-30,-88},{-10,-88}},
      color={0,120,120},
      smooth=Smooth.None));
    connect(wyeToWyeGround.wyeg.phase[3], load3.terminal) annotation (Line(
      points={{-34,-10},{-26,-10},{-26,-88},{-10,-88}},
      color={0,120,120},
      smooth=Smooth.None,
        pattern=LinePattern.Dash));
  end if;
  if plugPhase1 then
    connect(wyeToDelta.delta.phase[1], load1.terminal) annotation (Line(
      points={{-34,10},{-30,10},{-30,50},{-10,50}},
      color={0,120,120},
      smooth=Smooth.None));
    connect(wyeToWyeGround.wyeg.phase[1], load1.terminal) annotation (Line(
      points={{-34,-10},{-26,-10},{-26,46},{-16,46},{-16,50},{-10,50}},
      color={0,120,120},
      smooth=Smooth.None,
        pattern=LinePattern.Dash));
  end if;

  // Connections enabled when phase 1 is plugged and voltage ctrl activated
  if plugPhase1 and voltageCtrl then
    connect(load1.terminal, vCTRL_1.terminal)        annotation (Line(
      points={{-10,50},{-20,50},{-20,90},{10,90}},
      color={0,120,120},
      smooth=Smooth.None));
    connect(vCTRL_1.y, cmd1.u1)        annotation (Line(
        points={{30.6,90},{70,90},{70,72},{58,72}},
        color={0,0,127},
        smooth=Smooth.None));
  end if;

  if plugPhase2 and voltageCtrl then
    connect(load2.terminal, vCTRL_2.terminal) annotation (Line(
      points={{-10,-20},{-20,-20},{-20,20},{10,20}},
      color={0,120,120},
      smooth=Smooth.None));
    connect(vCTRL_2.y, cmd2.u1) annotation (Line(
        points={{30.6,20},{66,20},{66,0},{58,0}},
        color={0,0,127},
        smooth=Smooth.None));
  end if;

  if plugPhase3 and voltageCtrl then
    connect(load3.terminal, vCTRL_3.terminal) annotation (Line(
      points={{-10,-88},{-20,-88},{-20,-50},{10,-50}},
      color={0,120,120},
      smooth=Smooth.None));
    connect(vCTRL_3.y, cmd3.u1) annotation (Line(
        points={{30.6,-50},{66,-50},{66,-64},{58,-64}},
        color={0,0,127},
        smooth=Smooth.None));
  end if;

    annotation (    Documentation(info="<html>
<p>
This model represents a partial interface for a three-phase AC unbalanced
load.
</p>
<p>
The loads on each phase can be removed using the boolean flags
<code>plugPhase1</code>, <code>plugPhase2</code>, and <code>plugPhase3</code>.
These parameters can be used to generate unbalanced loads.
</p>
<p>
The loads can be connected either in wye (Y) or delta (D) configuration.
The parameter <code>loadConn</code> can be used for such a purpose.
</p>
<p>
Each load model has the option to be controlled by a voltage controller.
When enabled, the voltage controller unplugs the load for a certain amount of
time if the voltage exceeds a given threshold. Mode information about the
voltage controller can be found
<a href=\"modelica://Buildings.Electrical.Utilities.VoltageControl\">here</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
September 24, 2014, by Marco Bonvini:<br/>
Created model and documentation.
</li>
</ul>
</html>"));
end BaseLoadCtrl;
