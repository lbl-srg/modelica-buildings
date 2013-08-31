within Districts.Electrical.AC.OnePhase.Loads.Examples;
model ThreePhases
  extends Modelica.Icons.Example;
  Sources.FixedVoltage Va(
    f=50,
    V=220,
    Phi=0,
    definiteReference=true)
           annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Impedance Za(
    inductive=true,
    L=1/(2*Modelica.Constants.pi*50),
    R=10)
    annotation (Placement(transformation(extent={{20,40},{40,60}})));
  Sources.FixedVoltage Vb(
    f=50,
    V=220,
    Phi=2.0943951023932,
    definiteReference=true)
           annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Impedance Zb(
    inductive=true,
    L=1/(2*Modelica.Constants.pi*50),
    R=10)
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
  Sources.FixedVoltage Vc(
    f=50,
    V=220,
    Phi=4.1887902047864,
    definiteReference=true)
           annotation (Placement(transformation(extent={{-40,-40},{-20,
            -20}})));
  Impedance Zc(
    inductive=true,
    L=1/(2*Modelica.Constants.pi*50),
    R=10)
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
equation
  connect(Va.terminal, Za.terminal) annotation (Line(
      points={{-20,50},{20,50}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(Vb.terminal, Zb.terminal) annotation (Line(
      points={{-20,10},{20,10}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(Vc.terminal, Zc.terminal) annotation (Line(
      points={{-20,-30},{20,-30}},
      color={0,120,120},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent=
            {{-100,-100},{100,100}}), graphics));
end ThreePhases;
