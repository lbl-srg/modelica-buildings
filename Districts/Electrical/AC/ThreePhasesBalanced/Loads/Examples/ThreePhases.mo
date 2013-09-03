within Districts.Electrical.AC.ThreePhasesBalanced.Loads.Examples;
model ThreePhases
  extends Modelica.Icons.Example;
  Sources.FixedVoltage V(
    f=50,
    V=380,
    Phi=0,
    definiteReference=true)
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Impedance Z(
    R=10,
    L=1/(2*Modelica.Constants.pi*50),
    inductive=true)
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
equation
  connect(V.terminal, Z.terminal) annotation (Line(
      points={{-60,10},{20,10}},
      color={0,120,120},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent=
            {{-100,-100},{100,100}}), graphics));
end ThreePhases;
