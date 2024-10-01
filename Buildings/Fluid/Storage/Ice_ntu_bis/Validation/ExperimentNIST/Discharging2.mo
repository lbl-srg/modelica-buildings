within Buildings.Fluid.Storage.Ice_ntu_bis.Validation.ExperimentNIST;
model Discharging2 "Validation against discharging experiment 2"
  extends Buildings.Fluid.Storage.Ice_ntu_bis.Validation.ExperimentNIST.BaseClasses.PartialChargingDischarging
                                                                                                      (
    fileName=Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/Data/Fluid/Storage/Ice/Validation/Experiment/discharging2.txt"),
    SOC_start=0.96645368,
    offSet(k=-2));

  annotation (
    experiment(
      StartTime=0,
      StopTime=36890,
      Tolerance=1e-06),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Storage/Ice/Validation/ExperimentNIST/Discharging2.mos"
        "Simulate and Plot"),
    Documentation(info="<html>
<p>
This example is to validate the developed ice tank model for discharging mode using data generated from experiment 2.
The outlet temperature setpoint is set to 2 degree below the measured temperature because the measurement data was taken when the bypass was fully closed.
In this way, the implemented model will automatically close the bypass valve during charging.
</p>
</html>", revisions="<html>
<ul>
<li>
December 14, 2021, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end Discharging2;
