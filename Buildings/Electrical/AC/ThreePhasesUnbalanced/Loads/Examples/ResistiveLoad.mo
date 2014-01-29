within Buildings.Electrical.AC.ThreePhasesUnbalanced.Loads.Examples;
model ResistiveLoad
  extends Modelica.Icons.Example;
  Sources.FixedVoltage Vsource(
    f=50,
    V=200,
    Phi=0)
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Modelica.Blocks.Sources.Sine sine(
    amplitude=20,
    freqHz=0.1,
    offset=50) annotation (Placement(transformation(extent={{20,40},{40,60}})));
  Modelica.Blocks.Sources.Constant const(k=0)
    annotation (Placement(transformation(extent={{20,70},{40,90}})));
  ResistiveLoadP resistiveLoadP(
    mode=Buildings.Electrical.Types.Assumption.VariableZ_P_input,
    PlugPhase1=true,
    PlugPhase2=true,
    PlugPhase3=true)
    annotation (Placement(transformation(extent={{-8,-10},{12,10}})));
equation
  connect(sine.y, resistiveLoadP.Pow1) annotation (Line(
      points={{41,50},{54,50},{54,6},{12,6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(const.y, resistiveLoadP.Pow3) annotation (Line(
      points={{41,80},{68,80},{68,-6},{12,-6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(const.y, resistiveLoadP.Pow2) annotation (Line(
      points={{41,80},{60,80},{60,6.66134e-16},{12,6.66134e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Vsource.terminal, resistiveLoadP.terminal_p) annotation (Line(
      points={{-60,0},{-8,0}},
      color={0,120,120},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),      graphics));
end ResistiveLoad;
