within Buildings.Electrical.AC.ThreePhasesUnbalanced.Sources.Examples;
model FixedVoltageSource
  "This example illustrates how using a fixed voltage source"
  extends Modelica.Icons.Example;
  FixedVoltage                             grid(
    f=60,
    V=480,
    definiteReference=true,
    phiSou=0.17453292519943) "AC one phase electrical grid"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  Sensors.ProbeWye                  sen(V_nominal=480)
    "Probe that measures the voltage at the load"
    annotation (Placement(transformation(extent={{-10,60},{10,80}})));
  Loads.Inductive loa(P_nominal=-2000, V_nominal=480) "Inductive load"
    annotation (Placement(transformation(extent={{20,30},{40,50}})));
  FixedVoltage_N grid_N(
    f=60,
    V=480,
    definiteReference=true,
    phiSou=0.17453292519943) "AC one phase electrical grid"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));
  Sensors.ProbeWye_N sen_N(V_nominal=480)
    "Probe that measures the voltage at the load"
    annotation (Placement(transformation(extent={{-10,-40},{10,-20}})));
  Loads.Inductive_N loa_N(P_nominal=-2000, V_nominal=480) "Inductive load"
    annotation (Placement(transformation(extent={{20,-70},{40,-50}})));
equation
  connect(grid.terminal, loa.terminal) annotation (Line(
      points={{-20,40},{20,40}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(grid.terminal, sen.term) annotation (Line(
      points={{-20,40},{0,40},{0,61}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(grid_N.terminal, loa_N.terminal) annotation (Line(
      points={{-20,-60},{20,-60}},
      color={127,0,127},
      smooth=Smooth.None));
  connect(grid_N.terminal, sen_N.term) annotation (Line(
      points={{-20,-60},{0,-60},{0,-39}},
      color={127,0,127},
      smooth=Smooth.None));
  annotation (    experiment(StopTime=1, Tolerance=1e-05),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Electrical/AC/ThreePhasesUnbalanced/Sources/Examples/FixedVoltageSource.mos"
        "Simulate and plot"),
    Documentation(revisions="<html>
<ul>
<li>
September 25, 2014, by Marco Bonvini:<br/>
Created model and documentation.
</li>
</ul>
</html>", info="<html>
<p>
This example shows how to use a fixed voltage generator model.
</p>
</html>"));
end FixedVoltageSource;
