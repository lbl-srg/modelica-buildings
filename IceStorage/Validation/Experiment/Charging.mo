within IceStorage.Validation.Experiment;
model Charging "Validation against charging experiment"
  extends IceStorage.Validation.BaseClasses.PartialExample(
   fileName=Modelica.Utilities.Files.loadResource(
    "modelica://IceStorage/Resources/data/Validation/Experiment/charging.txt"),
   mod(k=Integer(IceStorage.Types.IceThermalStorageMode.Charging)),
   coeCha={1.99810397E-04,0,0,0,0,0},
   coeDisCha={5.54E-05,-1.45679E-04,9.28E-05,1.126122E-03, -1.1012E-03,3.00544E-04},
   dt = 10,
   mIce_max=2846.35,
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
This example is to validate the developed ice tank model for charging mode.
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
