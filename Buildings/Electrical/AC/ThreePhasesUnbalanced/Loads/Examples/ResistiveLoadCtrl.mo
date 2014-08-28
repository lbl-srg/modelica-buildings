within Buildings.Electrical.AC.ThreePhasesUnbalanced.Loads.Examples;
model ResistiveLoadCtrl
  extends Modelica.Icons.Example;
  Sources.FixedVoltage_N Vsource(
    f=50,
    Phi=0,
    V=110) annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Modelica.Blocks.Sources.Sine sine(
    freqHz=0.1,
    amplitude=4500,
    offset=-6000)
               annotation (Placement(transformation(extent={{60,10},{40,30}})));
  Modelica.Blocks.Sources.Constant const(k=0)
    annotation (Placement(transformation(extent={{90,-10},{70,10}})));
  Resistive_N load_ctrl(
    mode=Buildings.Electrical.Types.Assumption.VariableZ_P_input,
    PlugPhase1=true,
    PlugPhase2=true,
    PlugPhase3=true,
    VoltageCTRL=true,
    Vthresh=0.1,
    V_nominal=110,
    Tdelay=2) annotation (Placement(transformation(extent={{-8,-10},{12,10}})));
  Lines.LineN line_ctrl(
    l=100,
    P_nominal=5000,
    V_nominal=110,
    mode=Buildings.Electrical.Types.CableMode.commercial,
    voltageLevel=Buildings.Electrical.Types.VoltageLevel.Low,
    commercialCable_low=Buildings.Electrical.Transmission.LowVoltageCables.Cu25())
            annotation (Placement(transformation(extent={{-46,-10},{-26,10}})));
  Resistive_N load(
    mode=Buildings.Electrical.Types.Assumption.VariableZ_P_input,
    PlugPhase1=true,
    PlugPhase2=true,
    PlugPhase3=true,
    Vthresh=0.1,
    Tdelay=5,
    V_nominal=110,
    VoltageCTRL=false)
    annotation (Placement(transformation(extent={{-8,-40},{12,-20}})));
  Lines.LineN line(
    l=100,
    P_nominal=5000,
    V_nominal=110,
    mode=Buildings.Electrical.Types.CableMode.commercial,
    voltageLevel=Buildings.Electrical.Types.VoltageLevel.Low,
    commercialCable_low=Buildings.Electrical.Transmission.LowVoltageCables.Cu25())
            annotation (Placement(transformation(extent={{-46,-40},{-26,-20}})));
equation
  connect(const.y, load_ctrl.Pow3)      annotation (Line(
      points={{69,4.44089e-16},{60,4.44089e-16},{60,-6},{12,-6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(const.y, load_ctrl.Pow2)      annotation (Line(
      points={{69,4.44089e-16},{60,4.44089e-16},{60,6.66134e-16},{12,
          6.66134e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Vsource.terminal, line_ctrl.terminal_n) annotation (Line(
      points={{-60,0},{-46,0}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(line_ctrl.terminal_p, load_ctrl.terminal_p) annotation (Line(
      points={{-26,0},{-8,0}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(line.terminal_p, load.terminal_p) annotation (Line(
      points={{-26,-30},{-8,-30}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(Vsource.terminal, line.terminal_n) annotation (Line(
      points={{-60,0},{-54,0},{-54,-30},{-46,-30}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(const.y, load.Pow2) annotation (Line(
      points={{69,4.44089e-16},{60,4.44089e-16},{60,-30},{12,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(const.y, load.Pow3) annotation (Line(
      points={{69,4.44089e-16},{60,4.44089e-16},{60,-36},{12,-36}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sine.y, load_ctrl.Pow1) annotation (Line(
      points={{39,20},{30,20},{30,6},{12,6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sine.y, load.Pow1) annotation (Line(
      points={{39,20},{30,20},{30,-24},{12,-24}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),      graphics));
end ResistiveLoadCtrl;
