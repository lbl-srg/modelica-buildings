within Buildings.ThermalZones.EnergyPlus.Examples.SingleFamilyHouse;
model UnconditionedNoOutput
  "Failing example caused by missing Output:Variable in the idf"
  extends Buildings.ThermalZones.EnergyPlus.Examples.SingleFamilyHouse.Unconditioned(
   building(idfName=Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/Data/ThermalZones/EnergyPlus/Examples/SingleFamilyHouse_TwoSpeed_ZoneAirBalance/SingleFamilyHouse_TwoSpeed_ZoneAirBalance_NoOutput.idf")));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=432000,
      Tolerance=1e-06));
end UnconditionedNoOutput;
