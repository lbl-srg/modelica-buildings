within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.Examples;
model Impedances "Example that illustrates the use of the impedance models"
   extends Modelica.Icons.Example;
  Sources.FixedVoltage sou(f=60, V=480) "Voltage source"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  Impedance Z1(R=0,
    inductive=true,
    L=1/(2*Modelica.Constants.pi*60),
    star=true) "Impedance purely inductive"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Impedance Z2(R=1, star=true) "Impedance purely resistive"
    annotation (Placement(transformation(extent={{-20,10},{0,30}})));
  Impedance Z3(R=0,
    inductive=false,
    C=1/(2*Modelica.Constants.pi*60),
    star=true) "Impedance purely capacitive"
    annotation (Placement(transformation(extent={{-20,-20},{0,0}})));
  Impedance Z4(
    inductive=false,
    R=1,
    C=1/(2*Modelica.Constants.pi*60),
    star=true) "Impedance capacitive"
    annotation (Placement(transformation(extent={{-20,-50},{0,-30}})));
  Impedance Z5(
    R=1,
    inductive=true,
    L=1/(2*Modelica.Constants.pi*60),
    star=true) "Impedance inductive"
    annotation (Placement(transformation(extent={{-20,-78},{0,-58}})));
equation
  connect(sou.terminal, Z1.terminal) annotation (Line(
      points={{-60,-10},{-40,-10},{-40,50},{-20,50}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(sou.terminal, Z2.terminal) annotation (Line(
      points={{-60,-10},{-40,-10},{-40,20},{-20,20}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(sou.terminal, Z3.terminal) annotation (Line(
      points={{-60,-10},{-20,-10}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(sou.terminal, Z4.terminal) annotation (Line(
      points={{-60,-10},{-40,-10},{-40,-40},{-20,-40}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(sou.terminal, Z5.terminal) annotation (Line(
      points={{-60,-10},{-40,-10},{-40,-68},{-20,-68}},
      color={0,120,120},
      smooth=Smooth.None));
  annotation (Documentation(revisions="<html>
<ul>
<li>
September 22, 2014 by Marco Bonvini:<br/>
Added documentation and revised the example.
</li>
</ul>
</html>", info="<html>
<p>
This model illustrates the use of the impedance models.
The impedances have unitary values such that the RMS value of the voltage and of the current are the same.
</p>
</html>"),
    experiment(Tolerance=1e-6, StopTime=1.0),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Electrical/AC/ThreePhasesBalanced/Loads/Examples/Impedances.mos"
        "Simulate and plot"));
end Impedances;
