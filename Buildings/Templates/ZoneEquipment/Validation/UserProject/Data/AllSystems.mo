within Buildings.Templates.ZoneEquipment.Validation.UserProject.Data;
class AllSystems "Top-level (whole building) system parameters"
  extends Buildings.Templates.Data.AllSystems(
    sysUni=Buildings.Templates.Types.Units.SI,
    ashCliZon=Buildings.Controls.OBC.ASHRAE.G36.Types.ASHRAEClimateZone.Zone_3B,
    stdVen=Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1,
    stdEne=Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1);

  parameter Buildings.Templates.ZoneEquipment.Data.VAVBox VAVBox_1(
    id="VAVBox_1",
    id_souAir="VAV_1",
    damVAV(dp_nominal=50),
    coiHea(
      cap_nominal=1e3,
      dpAir_nominal=70,
      dpWat_nominal=0.1e4,
      dpValve_nominal=0.05e4,
      mWat_flow_nominal=1e3/4186/10,
      TAirEnt_nominal=285.15,
      TWatEnt_nominal=323.15),
    ctl(
      final stdVen=stdVen,
      VAirCooSet_flow_max=0.1,
      VAirHeaSet_flow_max=0.03,
      VOutMinOcc_flow=2.5e-3,
      VOutMinAre_flow=3e-3,
      VOutOcc_flow=2.5e-3,
      VOutAre_flow=3e-3,
      VAirSet_flow_min=0.01))
    "Parameters for system VAVBox_1"
    annotation (Dialog(group="Zone equipment"));

  annotation (
  defaultComponentPrefixes = "inner parameter",
  defaultComponentName = "datAll",
  Documentation(info="<html>
<p>
This record provides the set of sizing and operating parameters for
the whole HVAC system.
It is aimed for validation purposes only.
</p>
</html>"));
end AllSystems;
