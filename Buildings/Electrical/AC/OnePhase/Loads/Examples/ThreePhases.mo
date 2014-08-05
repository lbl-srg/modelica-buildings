within Buildings.Electrical.AC.OnePhase.Loads.Examples;
model ThreePhases
  extends Modelica.Icons.Example;
  Buildings.Electrical.AC.OnePhase.Sources.FixedVoltage Va(
    definiteReference=true,
    f=60,
    V=110) annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Buildings.Electrical.AC.OnePhase.Loads.Impedance Za(
    inductive=true,
    L=1/(2*Modelica.Constants.pi*50),
    R=10)
    annotation (Placement(transformation(extent={{20,40},{40,60}})));
  Buildings.Electrical.AC.OnePhase.Sources.FixedVoltage Vb(
    f=50,
    V=220,
    definiteReference=true,
    Phi=2.0943951023932)
           annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Buildings.Electrical.AC.OnePhase.Loads.Impedance Zb(
    inductive=true,
    L=1/(2*Modelica.Constants.pi*50),
    R=10)
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
  Buildings.Electrical.AC.OnePhase.Sources.FixedVoltage Vc(
    f=50,
    V=220,
    definiteReference=true,
    Phi=4.1887902047864)
           annotation (Placement(transformation(extent={{-40,-40},{-20,
            -20}})));
  Buildings.Electrical.AC.OnePhase.Loads.Impedance Zc(
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
  annotation (experiment(StopTime=1.0, Tolerance=1e-06),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent=
            {{-100,-100},{100,100}}), graphics),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Electrical/AC/OnePhase/Loads/Examples/ThreePhases.mos"
        "Simulate and plot"),
    Documentation(info="<html>
fixme: info section is missing

</html>", revisions="<html>
fixme: revision section is missing

</html>"));
end ThreePhases;
