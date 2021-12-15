within IceStorage.Calibration.Experiment;
model DischargingDay2
  extends IceStorage.Calibration.Experiment.BaseClasses.BaseExample(
   fileName=Modelica.Utilities.Files.loadResource(
    "modelica://IceStorage/Resources/data/Calibration/Experiment/discharging-day2.txt"),
   mod(k=Integer(IceStorage.Types.IceThermalStorageMode.Discharging)),
   mIce_start=0.96645368*mIce_max);

  annotation (
    experiment(
      StartTime=0,
      StopTime=36890,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
    __Dymola_Commands(file="modelica://IceStorage/Resources/scripts/dymola/Calibration/Experiment/DischargingDay2.mos"
        "Simulate and Plot"),
    Documentation(info="<html>
<p>This example is to validate the developed tank model against real measurement from NIST chiller tank testbed on day 2.</p>
</html>", revisions="<html>
<p>April 2021, Yangyang Fu First implementation </p>
</html>"));
end DischargingDay2;
