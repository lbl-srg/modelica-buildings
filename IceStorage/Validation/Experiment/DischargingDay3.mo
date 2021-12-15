within IceStorage.Validation.Experiment;
model DischargingDay3
  extends IceStorage.Validation.BaseClasses.PartialExample(
    fileName=Modelica.Utilities.Files.loadResource(
      "modelica://IceStorage/Resources/data/Validation/Experiment/discharging-day3.txt"),
    mod(k=Integer(IceStorage.Types.IceThermalStorageMode.Discharging)),
    mIce_start=0.96963383*mIce_max);

  annotation (
    experiment(
      StartTime=0,
      StopTime=19950,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
    __Dymola_Commands(file="modelica://IceStorage/Resources/scripts/dymola/Validation/Experiment/DischargingDay3.mos"
        "Simulate and Plot"),
    Documentation(info="<html>
<p>
This example is to validate the developed ice tank model for discharing mode using data generated from experiment 3.
</p>
</html>", revisions="<html>
<ul>
<li>
December 14, 2021, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end DischargingDay3;
