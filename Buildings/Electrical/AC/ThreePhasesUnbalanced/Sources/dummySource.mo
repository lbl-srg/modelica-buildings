within Buildings.Electrical.AC.ThreePhasesUnbalanced.Sources;
model dummySource

  Interface.Terminal_p terminal_n
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  OnePhase.Sources.FixedVoltage fixedVoltage(
    definiteReference=true,
    f=f,
    V=V,
    Phi=Phi) annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  parameter Modelica.SIunits.Frequency f "Frequency of the source";
  parameter Modelica.SIunits.Voltage V;
  parameter Modelica.SIunits.Angle Phi;
  OnePhase.Sources.FixedVoltage fixedVoltage1(
    f=f,
    V=V,
    Phi=Phi,
    definiteReference=false)
             annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
  OnePhase.Sources.FixedVoltage fixedVoltage2(
    f=f,
    V=V,
    Phi=Phi,
    definiteReference=false)
             annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
equation
  connect(fixedVoltage.terminal, terminal_n.phase[1]) annotation (Line(
      points={{-40,0},{100,0}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(fixedVoltage2.terminal, terminal_n.phase[2]) annotation (Line(
      points={{-20,50},{40,50},{40,0},{100,0}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(fixedVoltage1.terminal, terminal_n.phase[3]) annotation (Line(
      points={{-20,-30},{40,-30},{40,0},{100,0}},
      color={0,120,120},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end dummySource;
