within IceStorage.Validation.Experiment;
model Discharging3 "Validation against discharging experiment 3"
  extends IceStorage.Validation.BaseClasses.PartialExample(
   fileName=Modelica.Utilities.Files.loadResource(
    "modelica://IceStorage/Resources/data/Validation/Experiment/discharging3.txt"),
   mod(k=Integer(IceStorage.Types.IceThermalStorageMode.Discharging)),
   mIce_max=2846.35,
   mIce_start=0.969633826*mIce_max,
    offSet(k=-2));

  annotation (
    experiment(
      StartTime=0,
      StopTime=19950,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
    __Dymola_Commands(file="modelica://IceStorage/Resources/scripts/dymola/Validation/Experiment/Discharging3.mos"
        "Simulate and Plot"),
    Documentation(info="<html>
<p>
This example is to validate the developed ice tank model for discharging mode using data generated from experiment 3.
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
end Discharging3;
