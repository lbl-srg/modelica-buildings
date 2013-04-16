within Districts.Electrical.AC.Transmission.Examples;
model SinglePhaseLine
  import Districts;
  extends Modelica.Icons.Example;
  Districts.Electrical.AC.Transmission.SinglePhaseLine singlePhaseLine(
    Length(displayUnit="km") = 2000000,
    P=5000,
    V=230) annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Districts.Electrical.AC.Sources.Grid gri(
    f=50,
    V=230,
    phi=0) annotation (Placement(transformation(extent={{-70,40},{-50,60}})));
  Districts.Electrical.AC.Transmission.SinglePhaseLine singlePhaseLine1(
    Length(displayUnit="km") = 2000000,
    P=5000,
    V=230) annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
  Districts.Electrical.AC.Transmission.SinglePhaseLine singlePhaseLine2(
    Length(displayUnit="km") = 2000000,
    P=5000,
    V=230) annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));
  Districts.Electrical.AC.Loads.InductorResistor load1(P_nominal=5000, pf=0.9)
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Districts.Electrical.AC.Loads.InductorResistor load2(P_nominal=5000, pf=0.75)
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
  Districts.Electrical.AC.Loads.InductorResistor load3(P_nominal=4000, pf=0.8)
    annotation (Placement(transformation(extent={{0,-80},{20,-60}})));
equation
  connect(gri.sPhasePlug, singlePhaseLine.A) annotation (Line(
      points={{-60.1,40},{-60.1,10},{-40,10}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(gri.sPhasePlug, singlePhaseLine1.A) annotation (Line(
      points={{-60.1,40},{-60,40},{-60,-30},{-40,-30}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(singlePhaseLine2.A, gri.sPhasePlug) annotation (Line(
      points={{-40,-70},{-60.1,-70},{-60.1,40}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(singlePhaseLine.B, load1.sPhasePlug) annotation (Line(
      points={{-20,10},{-4.44089e-16,10}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(load2.sPhasePlug, singlePhaseLine1.B) annotation (Line(
      points={{-4.44089e-16,-30},{-20,-30}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(load3.sPhasePlug, singlePhaseLine2.B) annotation (Line(
      points={{-4.44089e-16,-70},{-20,-70}},
      color={0,0,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end SinglePhaseLine;
