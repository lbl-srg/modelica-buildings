within Buildings.ThermalZones.EnergyPlus.Validation.OutputVariable;
model NoOutputVariable
  "Failing example caused by missing Output:Variable in the idf"
  extends Buildings.ThermalZones.EnergyPlus.Examples.SingleFamilyHouse.Unconditioned(
   building(idfName=Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/Data/ThermalZones/EnergyPlus/Examples/SingleFamilyHouse_TwoSpeed_ZoneAirBalance/SingleFamilyHouse_TwoSpeed_ZoneAirBalance_NoOutput.idf")));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/EnergyPlus/Validation/OutputVariable/NoOutputVariable.mos" "Simulate and plot"),
    experiment(
      StopTime=86400,
      Tolerance=1e-06),
    Documentation(info="<html>
<p>
This validation case tests whether Spawn works for an idf file that has no output variables declared.
</p>
<p>
The model is identical to
<a href=\"Buildings.ThermalZones.EnergyPlus.Examples.SingleFamilyHouse.Unconditioned\">
Buildings.ThermalZones.EnergyPlus.Examples.SingleFamilyHouse.Unconditioned</a>
except that it uses an idf file that has no output variables.
</p>
</html>", revisions="<html>
<ul>
<li>
June 1, 2021, by Baptiste Ravache:<br/>
First implementation.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2512\">issue 2512</a>.
</li>
</ul>
</html>"));
end NoOutputVariable;
