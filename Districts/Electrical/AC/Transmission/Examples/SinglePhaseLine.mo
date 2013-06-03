within Districts.Electrical.AC.Transmission.Examples;
model SinglePhaseLine
  import Districts;
  extends Modelica.Icons.Example;
  Districts.Electrical.AC.Transmission.SinglePhaseLine singlePhaseLine(
    P=5000,
    V=230,
    redeclare Districts.Electrical.AC.Transmission.Materials.Copper material,
    cable=Districts.Electrical.AC.Transmission.Cables.mmq_1_0(),
    Length(displayUnit="m") = 2000)
           annotation (Placement(transformation(extent={{-50,0},{-30,20}})));
  Districts.Electrical.AC.Sources.Grid gri(
    f=50,
    V=230,
    phi=0) annotation (Placement(transformation(extent={{-70,40},{-50,60}})));
  Districts.Electrical.AC.Loads.InductorResistor load1(P_nominal=5000, pf=0.9)
    annotation (Placement(transformation(extent={{12,24},{32,44}})));
  Districts.Electrical.AC.Interfaces.SinglePhasePlug sPhasePlug1
    "Single phase connector"
    annotation (Placement(transformation(extent={{-14,0},{6,20}})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Basic.Resistor
                                            resistorLine(R_ref=34, useHeatPort=
        false)
    annotation (Placement(transformation(extent={{4,24},{24,4}})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Basic.Inductor
                                            inductorLine(L=8.16e-4)
    annotation (Placement(transformation(extent={{30,4},{50,24}})));
  Districts.Electrical.AC.Interfaces.SinglePhasePlug B1
    annotation (Placement(transformation(extent={{-32,0},{-12,20}})));
equation
  connect(gri.sPhasePlug, load1.sPhasePlug) annotation (Line(
      points={{-60.1,40},{-60,40},{-60,34},{12,34}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(gri.sPhasePlug, singlePhaseLine.A) annotation (Line(
      points={{-60.1,40},{-60.1,10},{-50,10}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(sPhasePlug1.p[1], resistorLine.pin_p) annotation (Line(
      points={{-4,10},{0,10},{0,14},{4,14}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(resistorLine.pin_n, inductorLine.pin_p) annotation (Line(
      points={{24,14},{30,14}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(inductorLine.pin_n, sPhasePlug1.n) annotation (Line(
      points={{50,14},{62,14},{62,-8},{-4,-8},{-4,10}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(singlePhaseLine.B, B1) annotation (Line(
      points={{-30,10},{-22,10}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(B1.p, sPhasePlug1.p) annotation (Line(
      points={{-22,10},{-14,10},{-14,10},{-4,10}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(B1.n, sPhasePlug1.n) annotation (Line(
      points={{-22,10},{-14,10},{-14,10},{-4,10}},
      color={85,170,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end SinglePhaseLine;
