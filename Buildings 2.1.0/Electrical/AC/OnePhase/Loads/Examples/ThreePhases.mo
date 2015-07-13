within Buildings.Electrical.AC.OnePhase.Loads.Examples;
model ThreePhases
  "Examples that illustrates how to replicate a three-phase balanced system"
  extends Modelica.Icons.Example;
  Buildings.Electrical.AC.OnePhase.Sources.FixedVoltage Va(
    definiteReference=true,
    f=60,
    V=120) "Source phase A"
           annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Buildings.Electrical.AC.OnePhase.Loads.Impedance Za(
    inductive=true,
    L=1/(2*Modelica.Constants.pi*60),
    R=12) "Impedance phase A"
    annotation (Placement(transformation(extent={{20,40},{40,60}})));
  Buildings.Electrical.AC.OnePhase.Sources.FixedVoltage Vb(
    definiteReference=true, phiSou=-2.0943951023932,
    f=60,
    V=120) "Source phase B"
           annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Buildings.Electrical.AC.OnePhase.Loads.Impedance Zb(
    inductive=true,
    L=1/(2*Modelica.Constants.pi*60),
    R=12) "Impedance phase B"
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
  Buildings.Electrical.AC.OnePhase.Sources.FixedVoltage Vc(
    definiteReference=true, phiSou=2.0943951023932,
    f=60,
    V=120) "Source phase C"
           annotation (Placement(transformation(extent={{-40,-40},{-20,
            -20}})));
  Buildings.Electrical.AC.OnePhase.Loads.Impedance Zc(
    inductive=true,
    L=1/(2*Modelica.Constants.pi*60),
    R=12) "Impedance phase C"
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
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Electrical/AC/OnePhase/Loads/Examples/ThreePhases.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This model shows how a balanced three phase system can be represented with three
independent single phase circuits.
</p>
</html>", revisions="<html>
<ul>
<li>
August 5, 2014, by Marco Bonvini:<br/>
Revised model and documentation.
</li>
</ul>
</html>"));
end ThreePhases;
