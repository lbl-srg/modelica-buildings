within IceStorage.Validation.Experiment;
model Charging
  extends IceStorage.Validation.BaseClasses.PartialExample(
   fileName=Modelica.Utilities.Files.loadResource(
    "modelica://IceStorage/Resources/data/Validation/Experiment/charging.txt"),
   mod(k=Integer(IceStorage.Types.IceThermalStorageMode.Charging)),
   mIce_start=0.158*mIce_max);

  annotation (
    experiment(
      StartTime=15000,
      StopTime=60370,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
    __Dymola_Commands(file=
          "modelica://IceStorage/Resources/scripts/dymola/Validation/Experiment/Charging.mos"
        "Simulate and Plot"),
    Documentation(info="<html>
<p>
This example is to validate the developed ice tank model for charging mode using data generated from experiment 1.
</p>
</html>", revisions="<html>
<ul>
<li>
December 14, 2021, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end Charging;
