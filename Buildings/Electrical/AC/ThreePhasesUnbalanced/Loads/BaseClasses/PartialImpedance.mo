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
    useVariableR=useVariableR,
    Rmin=Rmin,
    Rmax=Rmax,
    useVariableC=useVariableC,
    Cmin=Cmin,
    Cmax=Cmax,
    useVariableL=useVariableL,
    Lmin=Lmin,
    Lmax=Lmax) if PlugPhase1
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));
  replaceable Buildings.Electrical.AC.OnePhase.Loads.Impedance
                                                load2(
    redeclare package PhaseSystem = PhaseSystems.OnePhase,
    redeclare Electrical.AC.OnePhase.Interfaces.Terminal_n terminal,
    inductive=inductive,
    R=R,
    L=L,
    C=C,
    useVariableR=useVariableR,
    Rmin=Rmin,
    Rmax=Rmax,
    useVariableC=useVariableC,
    Cmin=Cmin,
    Cmax=Cmax,
    useVariableL=useVariableL,
    Lmin=Lmin,
    Lmax=Lmax) if PlugPhase2
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  replaceable Buildings.Electrical.AC.OnePhase.Loads.Impedance
                                                load3(
    redeclare package PhaseSystem = PhaseSystems.OnePhase,
    redeclare Electrical.AC.OnePhase.Interfaces.Terminal_n terminal,
    inductive=inductive,
    R=R,
    L=L,
    C=C,
    useVariableR=useVariableR,
    Rmin=Rmin,
    Rmax=Rmax,
    useVariableC=useVariableC,
    Cmin=Cmin,
    Cmax=Cmax,
    useVariableL=useVariableL,
    Lmin=Lmin,
    Lmax=Lmax) if PlugPhase3
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
  Buildings.Electrical.AC.ThreePhasesUnbalanced.Interfaces.Connection3to4_n
                             connection3to4
    annotation (Placement(transformation(extent={{-60,-10},{-80,10}})));
  replaceable Buildings.Electrical.Interfaces.PartialGround ground(
    redeclare package PhaseSystem = PhaseSystems.OnePhase,
    redeclare Electrical.AC.OnePhase.Interfaces.Terminal_n terminal)
    annotation (Placement(transformation(extent={{-70,-80},{-50,-60}})));

  parameter Boolean inductive=true
    "If =true the load is inductive, otherwise it is capacitive"
    annotation (Evaluate=true, choices(
      choice=true "Inductive",
      choice=false "Capacitive",
      __Dymola_radioButtons=true));
  parameter Modelica.SIunits.Resistance R(start = 1,min=0) "Resistance"
    annotation (Dialog(enable= not useVariableR));
  parameter Modelica.SIunits.Inductance L(start=0, min=0) "Inductance"
    annotation (Dialog(enable=inductive and (not useVariableL)));
  parameter Modelica.SIunits.Capacitance C(start=0,min=0) "Capacitance"  annotation (Dialog(enable=(not inductive) and (not useVariableC)));
  parameter Boolean useVariableR = true
    "if true R is specified by an input variable" annotation(Dialog(tab = "Variable load", group="Resistance"));
  parameter Modelica.SIunits.Resistance Rmin(start = R, min=Modelica.Constants.eps)
    "Minimum value of the resistance" annotation(Dialog(enable = useVariableR, tab = "Variable load", group="Resistance"));
  parameter Modelica.SIunits.Resistance Rmax(start = R, min=Modelica.Constants.eps)
    "Maximum value of the resistance" annotation(Dialog(enable = useVariableR, tab = "Variable load", group="Resistance"));
  parameter Boolean useVariableC = true
    "if true C is specified by an input variable" annotation(Dialog(tab = "Variable load", group="Capacitance"));
  parameter Modelica.SIunits.Capacitance Cmin(start = C, min=Modelica.Constants.eps)
    "Minimum value of the capacitance" annotation(Dialog(enable = useVariableC, tab = "Variable load", group="Capacitance"));
  parameter Modelica.SIunits.Capacitance Cmax(start = C, min=Modelica.Constants.eps)
    "Maximum value of the capacitance" annotation(Dialog(enable = useVariableC, tab = "Variable load", group="Capacitance"));
  parameter Boolean useVariableL = true
    "if true L is specified by an input variable" annotation(Dialog(tab = "Variable load", group="Inductance"));
  parameter Modelica.SIunits.Inductance Lmin(start = L, min=Modelica.Constants.eps)
    "Minimum value of the inductance" annotation(Dialog(enable = useVariableL, tab = "Variable load", group="Inductance"));
  parameter Modelica.SIunits.Inductance Lmax(start = L, min=Modelica.Constants.eps)
    "Maximum value of the inductance" annotation(Dialog(enable = useVariableL, tab = "Variable load", group="Inductance"));
  Modelica.Blocks.Interfaces.RealInput y_R(min=0, max=1) if useVariableR
    "Input that sepecify variable R"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-40,100})));
  Modelica.Blocks.Interfaces.RealInput y_C(min=0, max=1) if useVariableC
    "Input that sepecify variable C"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,100})));
  Modelica.Blocks.Interfaces.RealInput y_L(min=0, max=1) if useVariableL
    "Input that sepecify variable L"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={40,100})));

equation
  Connections.branch(connection3to4.terminal4.phase[1].theta, connection3to4.terminal4.phase[4].theta);
  connection3to4.terminal4.phase[1].theta = connection3to4.terminal4.phase[4].theta;
  for i in 1:3 loop
    Connections.branch(connection3to4.terminal3.phase[i].theta, connection3to4.terminal4.phase[i].theta);
    connection3to4.terminal3.phase[i].theta = connection3to4.terminal4.phase[i].theta;
  end for;

  connect(connection3to4.terminal3, terminal_p) annotation (Line(
      points={{-80,6.66134e-16},{-86,6.66134e-16},{-86,4.44089e-16},{-100,4.44089e-16}},
      color={0,120,120},
      smooth=Smooth.None));

  // Conditional connections to load 2
  if PlugPhase2 then
    connect(connection3to4.terminal4.phase[2], load2.terminal) annotation (Line(
      points={{-60,6.66134e-16},{-36,6.66134e-16},{-36,0},{-10,0}},
      color={0,120,120},
      smooth=Smooth.None));
    connect(y_R, load2.y_R) annotation (Line(
      points={{-40,100},{-40,20},{-4,20},{-4,10}},
      color={0,0,127},
      smooth=Smooth.None));
    connect(y_C, load2.y_C) annotation (Line(
        points={{0,100},{0,70},{-20,70},{-20,24},{0,24},{0,10}},
        color={0,0,127},
        smooth=Smooth.None));
  end if;

  // Conditional connections to load 3
  if PlugPhase3 then
    connect(connection3to4.terminal4.phase[3], load3.terminal) annotation (Line(
      points={{-60,6.66134e-16},{-50,6.66134e-16},{-50,-40},{-10,-40}},
      color={0,120,120},
      smooth=Smooth.None));
    connect(y_R, load3.y_R) annotation (Line(
      points={{-40,100},{-40,-20},{-4,-20},{-4,-30}},
      color={0,0,127},
      smooth=Smooth.None));
    connect(y_C, load3.y_C) annotation (Line(
        points={{0,100},{0,70},{-20,70},{-20,-16},{0,-16},{0,-30}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(y_L, load3.y_L) annotation (Line(
        points={{40,100},{40,-20},{4,-20},{4,-30}},
        color={0,0,127},
        smooth=Smooth.None));
  end if;

  // Conditional connections to load 1
  if PlugPhase1 then
    connect(connection3to4.terminal4.phase[1], load1.terminal) annotation (Line(
      points={{-60,4.44089e-16},{-50,4.44089e-16},{-50,40},{-10,40}},
      color={0,120,120},
      smooth=Smooth.None));
    connect(y_R, load1.y_R) annotation (Line(
      points={{-40,100},{-40,60},{-4,60},{-4,50}},
      color={0,0,127},
      smooth=Smooth.None));
    connect(y_C, load1.y_C) annotation (Line(
      points={{8.88178e-16,100},{8.88178e-16,75},{0,75},{0,50}},
      color={0,0,127},
      smooth=Smooth.None));
    connect(y_L, load1.y_L) annotation (Line(
      points={{40,100},{40,60},{4,60},{4,50}},
      color={0,0,127},
      smooth=Smooth.None));
  end if;

  connect(connection3to4.terminal4.phase[4], ground.terminal) annotation (Line(
      points={{-60,6.66134e-16},{-60,-60}},
      color={0,120,120},
      smooth=Smooth.None));

  connect(load2.y_L, y_L) annotation (Line(
      points={{4,10},{4,20},{40,20},{40,100}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics));
end PartialImpedance;
