within Buildings.ThermalZones.EnergyPlus_24_1_0.Validation.OutputVariable;
model OneZoneOutputVariable
  "Validation model that has only one output variable from a zone reported to Modelica"
  extends Buildings.ThermalZones.EnergyPlus_24_1_0.Validation.OutputVariable.OneEnvironmentOutputVariable(TEnePlu(
        name="Zone Mean Air Temperature",
        key="LIVING ZONE"));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/EnergyPlus_24_1_0/Validation/OutputVariable/OneZoneOutputVariable.mos" "Simulate and plot"),
    experiment(
      StartTime=864000,
      StopTime=950400,
      Tolerance=1e-06),
    Documentation(info="<html>
<p>
Simple test case for one building in which only an EnergyPlus output variable is read.
</p>
<p>
In this model, the zone mean air temperature is obtained from EnergyPlus.
</p>
</html>", revisions="<html>
<ul>
<li>
May 28, 2021, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end OneZoneOutputVariable;
