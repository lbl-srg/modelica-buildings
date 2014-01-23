within Districts.Electrical.AC.ThreePhasesBalanced.Loads.Examples;
model TestImpedance
   extends Modelica.Icons.Example;
  Sources.FixedVoltage V(
    f=50,
    V=380,
    Phi=0.5235987755983)
           annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  Impedance Z1(R=0,
    inductive=true,
    L=1/(2*Modelica.Constants.pi*50))
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Impedance Z2(R=1)
    annotation (Placement(transformation(extent={{-20,10},{0,30}})));
  Impedance Z3(R=0,
    inductive=false,
    C=1/(2*Modelica.Constants.pi*50))
    annotation (Placement(transformation(extent={{-20,-20},{0,0}})));
  Impedance Z4(
    inductive=false,
    C=1/(2*Modelica.Constants.pi*50),
    R=1)
    annotation (Placement(transformation(extent={{-20,-50},{0,-30}})));
  Impedance Z5(
    R=1,
    inductive=true,
    L=1/(2*Modelica.Constants.pi*50))
    annotation (Placement(transformation(extent={{-20,-78},{0,-58}})));
equation
  connect(V.terminal, Z1.terminal) annotation (Line(
      points={{-60,-10},{-40,-10},{-40,50},{-20,50}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(V.terminal, Z2.terminal) annotation (Line(
      points={{-60,-10},{-40,-10},{-40,20},{-20,20}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(V.terminal, Z3.terminal) annotation (Line(
      points={{-60,-10},{-20,-10}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(V.terminal, Z4.terminal) annotation (Line(
      points={{-60,-10},{-40,-10},{-40,-40},{-20,-40}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(V.terminal, Z5.terminal) annotation (Line(
      points={{-60,-10},{-40,-10},{-40,-68},{-20,-68}},
      color={0,120,120},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end TestImpedance;
