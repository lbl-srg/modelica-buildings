within IceStorage.Validation.Experiment;
model Discharging2 "Validation against discharging experiment 2"
  extends IceStorage.Validation.BaseClasses.PartialExample(
   fileName=Modelica.Utilities.Files.loadResource(
    "modelica://IceStorage/Resources/data/Validation/Experiment/discharging2.txt"),
   mod(k=Integer(IceStorage.Types.IceThermalStorageMode.Discharging)),
   coeCha={1.99810397E-04,0,0,0,0,0},
   coeDisCha={5.54E-05,-1.45679E-04,9.28E-05,1.126122E-03, -1.1012E-03,3.00544E-04},
   dt = 10,
   mIce_max=2846.35,
   mIce_start=0.96645368*mIce_max);

  annotation (
    experiment(
      StartTime=0,
      StopTime=36890,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
    __Dymola_Commands(file="modelica://IceStorage/Resources/scripts/dymola/Validation/Experiment/Discharging2.mos"
        "Simulate and Plot"),
    Documentation(info="<html>
<p>
This example is to validate the developed ice tank model for discharging mode using data generated from experiment 2.
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
