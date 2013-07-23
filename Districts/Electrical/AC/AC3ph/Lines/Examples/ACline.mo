within Districts.Electrical.AC.AC3ph.Lines.Examples;
model ACline
  extends Modelica.Icons.Example;
  Sources.FixedVoltage V(
    f=50,
    V=380,
    Phi=0)
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Line line(
    P_nominal=5000,
    V_nominal=380,
    l=2000)
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Loads.LoadRL loadRL(P_nominal=2500) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={10,10})));
equation
  connect(V.terminal, line.terminal_n) annotation (Line(
      points={{-60,10},{-40,10}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(line.terminal_p, loadRL.terminal) annotation (Line(
      points={{-20,10},{-4.44089e-16,10}},
      color={0,120,120},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent=
            {{-100,-100},{100,100}}), graphics));
end ACline;
