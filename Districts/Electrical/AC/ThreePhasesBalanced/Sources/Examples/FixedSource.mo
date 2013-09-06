within Districts.Electrical.AC.ThreePhasesBalanced.Sources.Examples;
model FixedSource
  extends Modelica.Icons.Example;
  FixedVoltage V(
    definiteReference=true,
    f=50,
    V=380,
    Phi=0)
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Loads.InductiveLoadP
               dynRL(
    mode=Districts.Electrical.Types.Assumption.FixedZ_dynamic,
    P_nominal=2500,
    V_nominal=380,
    pf=0.8)
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Loads.CapacitiveLoadP
               RC(mode=Districts.Electrical.Types.Assumption.VariableZ_P_input,
      pf=0.8)
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
  Loads.InductiveLoadP
               RL(P_nominal=2000, pf=0.75)
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  Modelica.Blocks.Sources.Ramp load_Power(
    duration=0.5,
    startTime=0.2,
    height=2500)
    annotation (Placement(transformation(extent={{40,-40},{20,-20}})));
equation
  connect(V.terminal, RL.terminal) annotation (Line(
      points={{-60,6.66134e-16},{-40,6.66134e-16},{-40,30},{-20,30}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(V.terminal, dynRL.terminal) annotation (Line(
      points={{-60,6.66134e-16},{-20,6.66134e-16}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(V.terminal, RC.terminal) annotation (Line(
      points={{-60,6.66134e-16},{-40,6.66134e-16},{-40,-30},{-20,-30}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(load_Power.y, RC.Pow) annotation (Line(
      points={{19,-30},{0,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent=
            {{-100,-100},{100,100}}), graphics));
end FixedSource;
