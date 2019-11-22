within Buildings.Experimental.EnergyPlus.Validation;
model OneZoneOneOutputVariable
  "Validation model for one zone with one output variable"
  extends Buildings.Experimental.EnergyPlus.Validation.OneZone;
  OutputVariable out(
    key="Core_ZN",
    name="Zone Electric Equipment Electric Power")
    "Block that reads output from EnergyPlus"
    annotation (Placement(transformation(extent={{60,40},{80,60}})));
  annotation (Documentation(info="<html>
<p>
Simple test case for one building with one thermal zone and one output variable.
</p>
<p>
The room air temperature is free floating.
</p>
</html>", revisions="<html>
<ul><li>
October 7, 2019, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
 __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/EnergyPlus/Validation/OneZoneOneOutputVariable.mos"
        "Simulate and plot"),
experiment(
      StopTime=432000,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"));
end OneZoneOneOutputVariable;
