within IceStorage.Validation.EnergyPlus;
model Discharging "Discharigng mode validation"
  extends IceStorage.Validation.BaseClasses.PartialExample(
    coeCha={0.318,0,0,0,0,0},
    coeDisCha={0.0,0.09,-0.15,0.612,-0.324,-0.216},
    dt = 3600,
    mIce_max=5E07/333550,
    mIce_start=0.998733201*mIce_max,
    fileName=Modelica.Utilities.Files.loadResource(
    "modelica://IceStorage/Resources/data/Validation/EnergyPlus/discharging.txt"),
    m_flow_nominal=0.1,
    mod(k=Integer(IceStorage.Types.IceThermalStorageMode.Discharging)));

 annotation (
    experiment(StopTime=28920, __Dymola_Algorithm="Dassl"),
    __Dymola_Commands(file=
          "modelica://VirtualTestbed/Resources/scripts/dymola/NISTChillerTestbed/Component/Calibration/IceTankDischarging_EnergyPlus.mos"
        "Simulate and Plot"),
    Documentation(info="<html>
<p>
This example is to validate the developed tank model against real measurement from NIST chiller tank testbed on day 1.
</p>

</html>", revisions="<html>
April 2021, Yangyang Fu <\\b>
First implementation

</html>"));
end Discharging;
