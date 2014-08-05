within Buildings.Electrical.AC.ThreePhasesUnbalanced.Loads.BaseClasses;
partial model PartialImpedance
  import Buildings;
  extends Buildings.Electrical.Interfaces.PartialPluggableUnbalanced;
  Buildings.Electrical.AC.ThreePhasesUnbalanced.Interfaces.Terminal_n
                       terminal_p
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));

  replaceable Buildings.Electrical.AC.OnePhase.Loads.Impedance
                                                load1(
    redeclare package PhaseSystem = PhaseSystems.OnePhase,
    redeclare Electrical.AC.OnePhase.Interfaces.Terminal_n terminal,
    inductive=inductive,
    R=R,
    L=L,
    C=C,
    use_R_in=use_R_in,
    RMin=RMin,
    RMax=RMax,
    use_C_in=use_C_in,
    CMin=CMin,
    CMax=CMax,
    use_L_in=use_L_in,
    LMin=LMin,
    LMax=LMax) if PlugPhase1
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));
  replaceable Buildings.Electrical.AC.OnePhase.Loads.Impedance
                                                load2(
    redeclare package PhaseSystem = PhaseSystems.OnePhase,
    redeclare Electrical.AC.OnePhase.Interfaces.Terminal_n terminal,
    inductive=inductive,
    R=R,
    L=L,
    C=C,
    use_R_in=use_R_in,
    RMin=RMin,
    RMax=RMax,
    use_C_in=use_C_in,
    CMin=CMin,
    CMax=CMax,
    use_L_in=use_L_in,
    LMin=LMin,
    LMax=LMax) if PlugPhase2
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  replaceable Buildings.Electrical.AC.OnePhase.Loads.Impedance
                                                load3(
    redeclare package PhaseSystem = PhaseSystems.OnePhase,
    redeclare Electrical.AC.OnePhase.Interfaces.Terminal_n terminal,
    inductive=inductive,
    R=R,
    L=L,
    C=C,
    use_R_in=use_R_in,
    RMin=RMin,
    RMax=RMax,
    use_C_in=use_C_in,
    CMin=CMin,
    CMax=CMax,
    use_L_in=use_L_in,
    LMin=LMin,
    LMax=LMax) if PlugPhase3
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
  parameter Buildings.Electrical.Types.LoadConnection loadConn=
    Buildings.Electrical.Types.LoadConnection.wye_to_wyeg
    "Type of load connection (Yg or D)";
  parameter Boolean inductive=true
    "If =true the load is inductive, otherwise it is capacitive"
    annotation (Evaluate=true, choices(
      choice=true "Inductive",
      choice=false "Capacitive",
      __Dymola_radioButtons=true));

  parameter Modelica.SIunits.Resistance R(start = 1,min=0) = 1 "Resistance"
    annotation (Dialog(enable= not use_R_in));
  parameter Modelica.SIunits.Inductance L(start=0, min=0) = 0 "Inductance"
    annotation (Dialog(enable=inductive and (not use_L_in)));
  parameter Modelica.SIunits.Capacitance C(start=0,min=0) = 0 "Capacitance"
  annotation (Dialog(enable=(not inductive) and (not use_C_in)));

  parameter Boolean use_R_in = false "if true, R is specified by an input"
     annotation(Evaluate=true, Dialog(tab = "Variable load", group="Resistance"));
  parameter Modelica.SIunits.Resistance RMin(start = R, min=Modelica.Constants.eps) = 1e-4
    "Minimum value of the resistance"
    annotation(Evaluate=true, Dialog(enable = use_R_in, tab = "Variable load", group="Resistance"));
  parameter Modelica.SIunits.Resistance RMax(start = R, min=Modelica.Constants.eps) = 1e2
    "Maximum value of the resistance"
    annotation(Evaluate=true, Dialog(enable = use_R_in, tab = "Variable load", group="Resistance"));

  parameter Boolean use_C_in = false "if true, C is specified by an input"
    annotation(Evaluate=true, Dialog(tab = "Variable load", group="Capacitance"));
  parameter Modelica.SIunits.Capacitance CMin(start = C, min=Modelica.Constants.eps) = 1e-4
    "Minimum value of the capacitance"
    annotation(Evaluate=true, Dialog(enable = use_C_in, tab = "Variable load", group="Capacitance"));
  parameter Modelica.SIunits.Capacitance CMax(start = C, min=Modelica.Constants.eps) = 1e2
    "Maximum value of the capacitance"
    annotation(Evaluate=true, Dialog(enable = use_C_in, tab = "Variable load", group="Capacitance"));

  parameter Boolean use_L_in = false "if true, L is specified by an input"
     annotation(Evaluate=true, Dialog(tab = "Variable load", group="Inductance"));
  parameter Modelica.SIunits.Inductance LMin(start = L, min=Modelica.Constants.eps) = 1e-4
    "Minimum value of the inductance"
    annotation(Evaluate=true, Dialog(enable = use_L_in, tab = "Variable load", group="Inductance"));
  parameter Modelica.SIunits.Inductance LMax(start = L, min=Modelica.Constants.eps) = 1e2
    "Maximum value of the inductance"
    annotation(Evaluate=true, Dialog(enable = use_L_in, tab = "Variable load", group="Inductance"));

  Modelica.Blocks.Interfaces.RealInput y_R(min=0, max=1) if use_R_in
    "Input that sepecify variable R"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-40,100})));
  Modelica.Blocks.Interfaces.RealInput y_C(min=0, max=1) if use_C_in
    "Input that sepecify variable C"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,100})));
  Modelica.Blocks.Interfaces.RealInput y_L(min=0, max=1) if use_L_in
    "Input that sepecify variable L"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={40,100})));

  Buildings.Electrical.AC.ThreePhasesUnbalanced.Interfaces.WyeToDelta
    wyeToDelta if (loadConn == Buildings.Electrical.Types.LoadConnection.wye_to_delta)
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Buildings.Electrical.AC.ThreePhasesUnbalanced.Interfaces.WyeToWyeGround
    wyeToWyeGround if (loadConn == Buildings.Electrical.Types.LoadConnection.wye_to_wyeg)
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
equation

  // Conditional connections to load 1
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
    if use_R_in then
      connect(y_R, load1.y_R) annotation (Line(
      points={{-40,100},{-40,60},{-4,60},{-4,50}},
      color={0,0,127},
      smooth=Smooth.None));
    end if;
    if use_C_in then
      connect(y_C, load1.y_C) annotation (Line(
      points={{8.88178e-16,100},{8.88178e-16,75},{0,75},{0,50}},
      color={0,0,127},
      smooth=Smooth.None));
    end if;
    if use_L_in then
      connect(y_L, load1.y_L) annotation (Line(
      points={{40,100},{40,60},{4,60},{4,50}},
      color={0,0,127},
      smooth=Smooth.None));
    end if;
  end if;
  // Conditional connections to load 2
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
    if use_R_in then
      connect(y_R, load2.y_R) annotation (Line(
      points={{-40,100},{-40,20},{-4,20},{-4,10}},
      color={0,0,127},
      smooth=Smooth.None));
    end if;
    if use_L_in then
      connect(y_L, load2.y_L) annotation (Line(
      points={{40,100},{40,10},{4,10}},
      color={0,0,127},
      smooth=Smooth.None));
    end if;
    if use_C_in then
      connect(y_C, load2.y_C) annotation (Line(
        points={{0,100},{0,70},{-20,70},{-20,24},{0,24},{0,10}},
        color={0,0,127},
        smooth=Smooth.None));
    end if;
  end if;

  // Conditional connections to load 3
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
    if use_R_in then
      connect(y_R, load3.y_R) annotation (Line(
      points={{-40,100},{-40,-20},{-4,-20},{-4,-30}},
      color={0,0,127},
      smooth=Smooth.None));
    end if;
    if use_C_in then
      connect(y_C, load3.y_C) annotation (Line(
        points={{0,100},{0,70},{-20,70},{-20,-16},{0,-16},{0,-30}},
        color={0,0,127},
        smooth=Smooth.None));
    end if;
    if use_L_in then
      connect(y_L, load3.y_L) annotation (Line(
        points={{40,100},{40,-20},{4,-20},{4,-30}},
        color={0,0,127},
        smooth=Smooth.None));
    end if;
  end if;

  connect(terminal_p, wyeToDelta.wye) annotation (Line(
      points={{-100,0},{-86,0},{-86,10},{-80,10}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(terminal_p, wyeToWyeGround.wye) annotation (Line(
      points={{-100,0},{-86,0},{-86,-10},{-80,-10}},
      color={0,120,120},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}),       graphics), Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics));
end PartialImpedance;
