within IceStorage.Calibration.Experiment;
model DischargingDay1
  extends IceStorage.Calibration.Experiment.BaseClasses.BaseExample(
   fileName=Modelica.Utilities.Files.loadResource(
    "modelica://IceStorage/Resources/data/Calibration/Experiment/discharging-day1.txt"),
   mod(k=Integer(IceStorage.Types.IceThermalStorageMode.Discharging)),
   mIce_start=0.90996030*mIce_max);


 annotation (
    experiment(
      StartTime = 0,
      StopTime=19990,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
    __Dymola_Commands(file="modelica://IceStorage/Resources/scripts/dymola/Calibration/Experiment/DischargingDay1.mos"
        "Simulate and Plot"),
    Documentation(info="<html>
<p>
This example is to validate the developed tank model against real measurement from NIST chiller tank testbed on day 1.
</p>

</html>", revisions="<html>
April 2021, Yangyang Fu <\\b>
First implementation

</html>"));
end DischargingDay1;
