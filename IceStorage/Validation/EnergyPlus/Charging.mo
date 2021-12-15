within IceStorage.Validation.EnergyPlus;
model Charging "Charging mode validation"
   extends IceStorage.Validation.BaseClasses.PartialExample(
    coeCha={0.318,0,0,0,0,0},
    coeDisCha={0.0,0.09,-0.15,0.612,-0.324,-0.216},
    dt = 3600,
    mIce_max=5e7/333550,
    mIce_start=0.605139456*mIce_max,
    fileName=Modelica.Utilities.Files.loadResource(
    "modelica://IceStorage/Resources/data/Validation/EnergyPlus/charging.txt"),
    m_flow_nominal=0.1,
    mod(k=Integer(IceStorage.Types.IceThermalStorageMode.Charging)),
    iceTan(Ti=0.5));

   annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=4450, __Dymola_Algorithm="Dassl"),
    __Dymola_Commands(file=
          "modelica://VirtualTestbed/Resources/Scripts/Dymola/NISTChillerTestbed/Component/Calibration/IceTankCharging_EnergyPlus.mos"
        "Simulate and Plot"),
    Documentation(info="<html>
<p>This example is to validate the developed tank model against real measurement from NIST chiller tank testbed on day 2.</p>
</html>", revisions="<html>
<p>April 2021, Yangyang Fu First implementation </p>
</html>"));
end Charging;
