within Districts.Electrical.AC.OnePhase.Loads.Examples;
model TestImpedance
  extends Modelica.Icons.Example;
  Sources.FixedVoltage V(
    f=50,
    V=220,
    Phi=0) annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Impedance Z1(R=0,
    inductive=true,
    L=1/(2*Modelica.Constants.pi*50))
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  Impedance Z2(R=0,
    inductive=false,
    C=1/(2*Modelica.Constants.pi*50))
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
  Impedance Z3(R=1)
    annotation (Placement(transformation(extent={{-20,-20},{0,0}})));
  Impedance Z4(R=1, L=1/(2*Modelica.Constants.pi*50))
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
  Impedance Z5(
    R=1,
    inductive=false,
    C=1/(2*Modelica.Constants.pi*50))
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
equation
  connect(V.terminal, Z1.terminal)  annotation (Line(
      points={{-60,30},{-20,30}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(V.terminal, Z2.terminal) annotation (Line(
      points={{-60,30},{-40,30},{-40,10},{-20,10}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(V.terminal, Z3.terminal) annotation (Line(
      points={{-60,30},{-40,30},{-40,-10},{-20,-10}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(V.terminal, Z4.terminal) annotation (Line(
      points={{-60,30},{-40,30},{-40,-30},{-20,-30}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(V.terminal, Z5.terminal) annotation (Line(
      points={{-60,30},{-40,30},{-40,-50},{-20,-50}},
      color={0,120,120},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end TestImpedance;
