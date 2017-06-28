within Buildings.Experimental.OpenBuildingControl.CDL.Logical.Validation;
model TrueHoldWithReset "Validation model for the TrueHoldWithReset block"
  extends Modelica.Icons.Example;

  Sources.BooleanPulse booPul(
    period = 9000,
    startTime=300)
    "Boolean pulse input signal"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
  Logical.TrueHoldWithReset truHol(
    duration=3600)
    "Block that holds a signal on for a requested time period"
    annotation (Placement(transformation(extent={{20,70},{40,90}})));
  Sources.BooleanPulse booPul1(
    period=3600)
    "Boolean pulse input signal"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Logical.TrueHoldWithReset truHol1(
    duration=600)
    "Block that holds a signal on for a requested time period"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  Sources.BooleanPulse booPul2(
    period = 9000,
    startTime=300)
    "Boolean pulse input signal"
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  Logical.TrueHoldWithReset truHol2(
    duration=3600)
    "Block that holds a signal on for a requested time period"
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  Sources.BooleanPulse booPul3(
    period=3600)
    "Boolean pulse input signal"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));
  Logical.TrueHoldWithReset truHol3(
    duration=600)
    "Block that holds a signal on for a requested time period"
    annotation (Placement(transformation(extent={{20,-70},{40,-50}})));
  Logical.Not not2 "Negation of input signal"
    annotation (Placement(transformation(extent={{-10,-20},{10,0}})));
  Logical.Not not3 "Negation of input signal"
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
equation
  connect(booPul.y, truHol.u)
    annotation (Line(points={{-19,80},{2,80},{19,80}},
                                                    color={255,0,255}));
  connect(booPul1.y, truHol1.u)
    annotation (Line(points={{-19,30},{19,30}},
                                              color={255,0,255}));
  connect(booPul2.y, not2.u)
    annotation (Line(points={{-19,-10},{-12,-10}}, color={255,0,255}));
  connect(not2.y, truHol2.u)
    annotation (Line(points={{11,-10},{19,-10}}, color={255,0,255}));
  connect(booPul3.y, not3.u)
    annotation (Line(points={{-19,-60},{-12,-60}}, color={255,0,255}));
  connect(not3.y, truHol3.u)
    annotation (Line(points={{11,-60},{19,-60}}, color={255,0,255}));
  annotation (
  experiment(StopTime=15000.0, Tolerance=1e-06),
  __Dymola_Commands(
  file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/CDL/Logical/Validation/TrueHoldWithReset.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Experimental.OpenBuildingControl.CDL.Logical.TrueHoldWithReset\">
Buildings.Experimental.OpenBuildingControl.CDL.Logical.TrueHoldWithReset</a>.
</p>
<p>
The validation uses different instances to validate different hold durations, different lengths
of the input pulse, and different initial values for the input signal.
</p>
</html>", revisions="<html>
<ul>
<li>
June 14, 2017, by Michael Wetter:<br/>
Added more tests for different initial signals and different hold values.
</li>
<li>
May 24, 2017, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end TrueHoldWithReset;
