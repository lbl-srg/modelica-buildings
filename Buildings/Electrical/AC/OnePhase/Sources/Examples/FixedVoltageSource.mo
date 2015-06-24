within Buildings.Electrical.AC.OnePhase.Sources.Examples;
model FixedVoltageSource
  "This example illustrates how using a fixed voltage source"
  extends Modelica.Icons.Example;
  Buildings.Electrical.AC.OnePhase.Loads.Inductive RL(
      P_nominal=-300, mode=Buildings.Electrical.Types.Load.FixedZ_steady_state,
    V_nominal=120) "Load model"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  FixedVoltage grid(
    f=60,
    V=120,
    phiSou=0.34906585039887) "AC one phase electrical grid"
           annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Sensors.Probe sen(V_nominal=120)
    "Probe that measures the voltage at the load"
    annotation (Placement(transformation(extent={{-10,20},{10,40}})));
equation
  connect(grid.terminal, RL.terminal)
                                     annotation (Line(
      points={{-20,4.44089e-16},{-20,0},{20,0},{20,5.55112e-16}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(grid.terminal, sen.term) annotation (Line(
      points={{-20,6.66134e-16},{0,6.66134e-16},{0,21},{4.44089e-16,21}},
      color={0,120,120},
      smooth=Smooth.None));
  annotation (    experiment(StopTime=1, Tolerance=1e-05),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Electrical/AC/OnePhase/Sources/Examples/FixedVoltageSource.mos"
        "Simulate and plot"),
    Documentation(revisions="<html>
<ul>
<li>
September 22, 2014, by Marco Bonvini:<br/>
Created model and documentation.
</li>
</ul>
</html>", info="<html>
<p>
This example shows how to use a fixed voltage generator model.
</p>
</html>"));
end FixedVoltageSource;
