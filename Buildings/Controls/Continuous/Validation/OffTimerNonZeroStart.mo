within Buildings.Controls.Continuous.Validation;
model OffTimerNonZeroStart
  "Test model for off timer with negative start time"
  extends Buildings.Controls.Continuous.Examples.OffTimer(
    booleanPulse(startTime=-1));

  annotation (experiment(Tolerance=1e-6, StartTime=-1, StopTime=0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/Continuous/Validation/OffTimerNonZeroStart.mos"
        "Simulate and plot"),
    Documentation(revisions="<html>
<ul>
<li>
May 12, 2017, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>This model tests the implementation the
<a href=\"Modelica://Buildings.Controls.Continuous.OffTimer\">Buildings.Controls.Continuous.OffTimer</a>
for negative start time.
</p>
</html>"));
end OffTimerNonZeroStart;
