within Buildings.Templates.AirHandlersFans.Validation.UserProject.Data;
class AllSystems "Top-level (whole building) system parameters"
  extends Buildings.Templates.Data.AllSystems(
    sysUni=Buildings.Templates.Types.Units.SI,
    stdEne=Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1,
    stdVen=Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1,
    ashCliZon=Buildings.Controls.OBC.ASHRAE.G36.Types.ASHRAEClimateZone.Zone_3B);

  parameter Buildings.Templates.AirHandlersFans.Data.VAVMultiZone VAV_1(
    id="VAV_1",
    damOut(dp_nominal=15),
    damOutMin(dp_nominal=15),
    damRel(dp_nominal=15),
    damRet(dp_nominal=15),
    mOutMin_flow_nominal=0.2,
    fanSup(m_flow_nominal=1, dp_nominal=500),
    fanRel(m_flow_nominal=1, dp_nominal=200),
    fanRet(m_flow_nominal=1, dp_nominal=200),
    coiHeaPre(
      cap_nominal=1e4,
      dpAir_nominal=100,
      dpWat_nominal=0.5e4,
      dpValve_nominal=0.3e4,
      mWat_flow_nominal=1e4/4186/10,
      TAirEnt_nominal=273.15,
      TWatEnt_nominal=50 + 273.15),
    coiHeaReh(
      cap_nominal=1e4,
      dpAir_nominal=100,
      dpWat_nominal=0.5e4,
      dpValve_nominal=0.3e4,
      mWat_flow_nominal=1e4/4186/10,
      TAirEnt_nominal=273.15,
      TWatEnt_nominal=50 + 273.15),
    coiCoo(
      cap_nominal=1e4,
      dpAir_nominal=100,
      dpWat_nominal=3e4,
      dpValve_nominal=2e4,
      mWat_flow_nominal=1e4/4186/5,
      TAirEnt_nominal=30 + 273.15,
      TWatEnt_nominal=7 + 273.15,
      wAirEnt_nominal=0.012),
    ctl(
      VOutUnc_flow_nominal=0.4,
      VOutTot_flow_nominal=0.5,
      VOutAbsMin_flow_nominal=0.3,
      VOutMin_flow_nominal=0.4,
      dpDamOutMinAbs=10,
      dpDamOutMin_nominal=15,
      pAirSupSet_rel_max=500,
      pAirRetSet_rel_min=10,
      pAirRetSet_rel_max=40,
      yFanSup_min=0.1,
      yFanRel_min=0.1,
      yFanRet_min=0.1,
      dVFanRet_flow=0.1,
      TAirSupSet_min=12+273.15,
      TAirSupSet_max=18+273.15,
      TOutRes_min=16+273.15,
      TOutRes_max=21+273.15))
    "Parameters for system VAV_1"
    annotation (Dialog(group="Air handlers and fans"));

annotation (
  defaultComponentPrefixes = "inner parameter",
  defaultComponentName = "datAll",
    Documentation(info="<html>
<p>
This class provides the set of sizing and operating parameters for
the whole HVAC system.
It is aimed for validation purposes only.
</p>
</html>"));
end AllSystems;
