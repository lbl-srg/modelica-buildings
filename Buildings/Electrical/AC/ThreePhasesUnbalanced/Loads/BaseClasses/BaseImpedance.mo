within Buildings.Electrical.AC.ThreePhasesUnbalanced.Loads.BaseClasses;
partial model BaseImpedance
  "Partial model of a three-phase unbalanced impedance"
  extends Buildings.Electrical.Interfaces.PartialPluggableUnbalanced;
  replaceable Buildings.Electrical.AC.OnePhase.Loads.Impedance
    load1(
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
    LMax=LMax)
    if plugPhase1 "Load 1"
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));
  replaceable Buildings.Electrical.AC.OnePhase.Loads.Impedance
    load2(
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
    LMax=LMax)
    if plugPhase2 "Load 2"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  replaceable Buildings.Electrical.AC.OnePhase.Loads.Impedance
    load3(
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
    LMax=LMax)
    if plugPhase3 "Load 3"
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
  parameter Modelica.Units.SI.Resistance R(
    start=1,
    min=0) = 1 "Resistance" annotation (Dialog(enable=not use_R_in));
  parameter Modelica.Units.SI.Inductance L(
    start=0,
    min=0) = 0 "Inductance"
    annotation (Dialog(enable=inductive and (not use_L_in)));
  parameter Modelica.Units.SI.Capacitance C(
    start=0,
    min=0) = 0 "Capacitance"
    annotation (Dialog(enable=(not inductive) and (not use_C_in)));
  parameter Boolean use_R_in = false "if true, R is specified by an input"
     annotation(Evaluate=true, Dialog(tab = "Variable load", group="Resistance"));
  parameter Modelica.Units.SI.Resistance RMin(
    start=R,
    min=Modelica.Constants.eps) = 1e-4 "Minimum value of the resistance"
    annotation (Evaluate=true, Dialog(
      enable=use_R_in,
      tab="Variable load",
      group="Resistance"));
  parameter Modelica.Units.SI.Resistance RMax(
    start=R,
    min=Modelica.Constants.eps) = 1e2 "Maximum value of the resistance"
    annotation (Evaluate=true, Dialog(
      enable=use_R_in,
      tab="Variable load",
      group="Resistance"));
  parameter Boolean use_C_in = false "if true, C is specified by an input"
    annotation(Evaluate=true, Dialog(tab = "Variable load", group="Capacitance"));
  parameter Modelica.Units.SI.Capacitance CMin(
    start=C,
    min=Modelica.Constants.eps) = 1e-4 "Minimum value of the capacitance"
    annotation (Evaluate=true, Dialog(
      enable=use_C_in,
      tab="Variable load",
      group="Capacitance"));
  parameter Modelica.Units.SI.Capacitance CMax(
    start=C,
    min=Modelica.Constants.eps) = 1e2 "Maximum value of the capacitance"
    annotation (Evaluate=true, Dialog(
      enable=use_C_in,
      tab="Variable load",
      group="Capacitance"));
  parameter Boolean use_L_in = false "if true, L is specified by an input"
     annotation(Evaluate=true, Dialog(tab = "Variable load", group="Inductance"));
  parameter Modelica.Units.SI.Inductance LMin(
    start=L,
    min=Modelica.Constants.eps) = 1e-4 "Minimum value of the inductance"
    annotation (Evaluate=true, Dialog(
      enable=use_L_in,
      tab="Variable load",
      group="Inductance"));
  parameter Modelica.Units.SI.Inductance LMax(
    start=L,
    min=Modelica.Constants.eps) = 1e2 "Maximum value of the inductance"
    annotation (Evaluate=true, Dialog(
      enable=use_L_in,
      tab="Variable load",
      group="Inductance"));
  Modelica.Blocks.Interfaces.RealInput y_R(min=0, max=1) if use_R_in
    "Input that sepecifies variable R"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-40,100})));
  Modelica.Blocks.Interfaces.RealInput y_C(min=0, max=1) if use_C_in
    "Input that sepecifies variable C"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,100})));
  Modelica.Blocks.Interfaces.RealInput y_L(min=0, max=1) if use_L_in
    "Input that sepecifies variable L"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={40,100})));

  Buildings.Electrical.AC.ThreePhasesUnbalanced.Interfaces.WyeToDelta
    wyeToDelta if (loadConn == Buildings.Electrical.Types.LoadConnection.wye_to_delta)
    "Wye to delta load connection"
    annotation (Placement(transformation(extent={{-64,0},{-44,20}})));
  Buildings.Electrical.AC.ThreePhasesUnbalanced.Interfaces.WyeToWyeGround
    wyeToWyeGround if (loadConn == Buildings.Electrical.Types.LoadConnection.wye_to_wyeg)
    "Wye to grounded wye connection"
    annotation (Placement(transformation(extent={{-64,-20},{-44,0}})));
protected
  Interfaces.Adapter3to3 adaDel
    if (loadConn == Buildings.Electrical.Types.LoadConnection.wye_to_delta)
    "Adapter"
    annotation (Placement(transformation(extent={{-40,-50},{-60,-30}})));
  Interfaces.Adapter3to3 adaWye
    if (loadConn == Buildings.Electrical.Types.LoadConnection.wye_to_wyeg)
    "Adapter"
    annotation (Placement(transformation(extent={{-40,-80},{-60,-60}})));
equation

  // Conditional connections to load 1
  if plugPhase1 then
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
  if plugPhase2 then
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
  if plugPhase3 then
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

  // Connection of the single loads to the 3phases connector
  if plugPhase1 then
    connect(load1.terminal, adaDel.terminals[1]) annotation (Line(points={{-10,40},
            {-26,40},{-26,-40.5333},{-40,-40.5333}},
                                                   color={0,120,120}));
    connect(load1.terminal, adaWye.terminals[1]) annotation (Line(points={{-10,40},
            {-26,40},{-26,-70.5333},{-40,-70.5333}},
                                                   color={0,120,120}));
  end if;

  if plugPhase2 then
    connect(load2.terminal, adaDel.terminals[2]) annotation (Line(points={{-10,0},
            {-22,0},{-22,-40},{-40,-40}}, color={0,120,120}));
    connect(load2.terminal, adaWye.terminals[2]) annotation (Line(points={{-10,0},
            {-22,0},{-22,-70},{-40,-70}}, color={0,120,120}));
  end if;
  if plugPhase3 then
    connect(load3.terminal, adaDel.terminals[3]) annotation (Line(points={{-10,-40},
            {-20,-40},{-20,-40},{-30,-40},{-30,-39.4667},{-40,-39.4667}},
                                                              color={0,120,120}));
    connect(load3.terminal, adaWye.terminals[3]) annotation (Line(points={{-10,-40},
            {-20,-40},{-20,-69.4667},{-40,-69.4667}},
                                                    color={0,120,120}));
  end if;

  connect(adaDel.terminal, wyeToDelta.delta) annotation (Line(points={{-60,-40},
          {-64,-40},{-64,-20},{-28,-20},{-28,10},{-44,10}}, color={0,120,120}));
  connect(adaWye.terminal, wyeToWyeGround.wyeg) annotation (Line(points={{-60,-70},
          {-66,-70},{-66,-18},{-30,-18},{-30,-10},{-44,-10}}, color={0,120,120}));

  annotation (    Documentation(info="<html>
<p>
This model represents a partial interface for a three-phase AC
unbalanced impedance.
</p>
<p>
The model can be configured in order to represent different type of
impedances as well as configurations.
</p>
<p>
The loads can be connected either in wye (Y) or delta (D) configuration.
The parameter <code>loadConn</code> can be used for such a purpose.
</p>
<p>
The model has three impedances that can be either connected in Y or
D configuration. The parameter <code>loadConn</code> can be used for
such a purpose. The Boolean parameter <code>inductive</code> can be selected
to specify the type of impedance.
</p>
<p>
The impedances on each phase can be removed using the boolean flags
<code>plugPhase1</code>, <code>plugPhase2</code>, and <code>plugPhase3</code>.
These parameters can be used to generate unbalanced loads.
</p>
<p>
The values of the impedances are computed starting from the parameters <code>R</code>,
<code>L</code>, and <code>C</code>. Depending on the values of the boolean flag
<code>inductive</code> some of these parameters may be disabled. There are additional
flags <code>use_R_in</code>, <code>use_L_in</code>, and <code>use_C_in</code> that can
be used to specify time varying impedances.
</p>
</html>", revisions="<html>
<ul>
<li>
February 26, 2016, by Michael Wetter:<br/>
Added adapters for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/426\">issue 426</a>.
</li>
<li>
September 24, 2014, by Marco Bonvini:<br/>
Created model from previus version.
</li>
</ul>
</html>"));
end BaseImpedance;
