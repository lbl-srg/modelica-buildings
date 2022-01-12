within Buildings.Fluid.Storage.Ice.Validation.Experiment;
model Discharging2 "Validation against discharging experiment 2"
  extends Buildings.Fluid.Storage.Ice.Validation.BaseClasses.PartialExample(
    fileName=Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/Data/Fluid/IceStorage/Validation/Experiment/discharging2.txt"),

    mod(k=Integer(Buildings.Fluid.Storage.Ice.Types.OperationModes.Discharging)),

    mIce_max=2846.35,
    mIce_start=0.96645368*mIce_max,
    offSet(k=-2));

  annotation (
    experiment(
      StartTime=0,
      StopTime=36890,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Storage/Ice/Validation/Experiment/Discharging2.mos"
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
