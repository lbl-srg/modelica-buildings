within Buildings.Examples.VAVReheat.Validation;
model TraceSubstance
  "This validates the ability to simulate trace substances in the air"
  extends ASHRAE2006(
    MediumA(extraPropertiesNames={"CO2"}));
  annotation (experiment(
      StartTime=3500000,
      StopTime=4650000,
      Interval=900,
      Tolerance=1e-06),
      __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Examples/VAVReheat/Validation/TraceSubstance.mos"
        "Simulate and plot"));
end TraceSubstance;
