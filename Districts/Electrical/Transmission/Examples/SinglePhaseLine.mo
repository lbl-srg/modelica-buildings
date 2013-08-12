within Districts.Electrical.Transmission.Examples;
model SinglePhaseLine
  import Districts;
  extends Modelica.Icons.Example;
  Districts.Electrical.AC.AC1ph.Sources.Grid
                                       gri(
    f=50,
    V=230,
    phi=0) annotation (Placement(transformation(extent={{-70,40},{-50,60}})));
  Districts.Electrical.AC.AC1ph.Loads.InductorResistor
                                                 load1(P_nominal=5000, pf=0.9)
    annotation (Placement(transformation(extent={{-10,18},{10,38}})));
  Districts.Electrical.Transmission.SinglePhaseLine    line2(
    P=5000,
    V=230,
    redeclare Districts.Electrical.Transmission.Materials.Copper    material,
    cable=Districts.Electrical.Transmission.Cables.mmq_1_0(),
    Length(displayUnit="m") = 2000)
           annotation (Placement(transformation(extent={{-50,0},{-30,20}})));
  Districts.Electrical.AC.AC1ph.Loads.InductorResistor
                                                 load2(P_nominal=5000, pf=0.9)
    annotation (Placement(transformation(extent={{-10,0},{10,20}})));
  Districts.Electrical.Transmission.SinglePhaseLine    line1(
    P=5000,
    V=230,
    redeclare Districts.Electrical.Transmission.Materials.Copper    material,
    cable=Districts.Electrical.Transmission.Cables.mmq_1_0(),
    Length(displayUnit="m") = 2000)
           annotation (Placement(transformation(extent={{-50,18},{-30,38}})));
equation
  connect(line2.A, gri.sPhasePlug) annotation (Line(
      points={{-50,10},{-60.1,10},{-60.1,40}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(line2.B, load2.sPhasePlug) annotation (Line(
      points={{-30,10},{-10,10}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(gri.sPhasePlug, line1.A) annotation (Line(
      points={{-60.1,40},{-60,40},{-60,28},{-50,28}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(line1.B, load1.sPhasePlug) annotation (Line(
      points={{-30,28},{-10,28}},
      color={0,0,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end SinglePhaseLine;
