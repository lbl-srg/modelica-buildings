within Buildings.Templates.ZoneEquipment.Validation.UserProject.Data;
class AllSystems "Top-level (whole building) system parameters"
  extends Buildings.Templates.Data.AllSystems(stdVen=Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1,
      stdEne=Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1);

  /*
  The construct below where a replaceable model is used inside the `outer`
  component declaration is for validation purposes only, where various configuration
  classes are tested with the same instance name `VAV_1`.
  It is needed here because
  - the `inner` instance must be a subtype of the `outer` component, and
  - the `outer` component references only the subcomponents from its own type
  (as opposed to all the subcomponents from the `inner` type), and
  - modification of an outer declaration is prohibited.
  The standard export workflow should use an explicit reference to the configuration
  class for each MZVAV model instance.
  */
  replaceable model VAVBox =
      Buildings.Templates.ZoneEquipment.Interfaces.PartialAirTerminal
    "Model of VAV box";

  outer VAVBox VAVBox_1
    "Instance of VAV box model";

  parameter Buildings.Templates.ZoneEquipment.Data.VAVBox dat_VAVBox_1(
    final typ=VAVBox_1.typ,
    final have_souChiWat=VAVBox_1.have_souChiWat,
    final have_souHeaWat=VAVBox_1.have_souHeaWat,
    final typCtl=VAVBox_1.ctl.typ,
    final typDamVAV=VAVBox_1.damVAV.typ,
    final typCoiHea=VAVBox_1.coiHea.typ,
    final typValCoiHea=VAVBox_1.coiHea.typVal,
    final stdVen=VAVBox_1.ctl.stdVen,
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
      final stdVen=VAVBox_1.ctl.stdVen,
      VAirCooSet_flow_max=0.1,
      VAirHeaSet_flow_max=0.03,
      VOutMinOcc_flow=2.5e-3,
      VOutMinAre_flow=3e-3,
      VOutOcc_flow=2.5e-3,
      VOutAre_flow=3e-3,
      VAirSet_flow_min=0.01))
    "Parameters for system VAVBox_1"
    annotation (
      Dialog(group="Zone equipment"));

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
