within Buildings.Fluid.Storage.Ice.Validation.Experiment;
model Charging "Validation against charging experiment"
  extends Buildings.Fluid.Storage.Ice.Validation.BaseClasses.PartialExample(
    fileName=Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/Data/Fluid/Storage/Ice/Validation/Experiment/charging.txt"),
    mod(k=Integer(Buildings.Fluid.Storage.Ice.Types.OperationModes.Charging)),
    mIce_max=2846.35,
    mIce_start=0.158*mIce_max);

  annotation (
    experiment(
      StartTime=15000,
      StopTime=60370,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/Storage/Ice/Validation/Experiment/Charging.mos"
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
