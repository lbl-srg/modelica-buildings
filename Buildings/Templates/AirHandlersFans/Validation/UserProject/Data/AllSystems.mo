within Buildings.Templates.AirHandlersFans.Validation.UserProject.Data;
record AllSystems "Top-level (whole building) record for testing purposes"
  extends Modelica.Icons.Record;

  parameter .Buildings.Templates.AirHandlersFans.Data.VAVMultiZone VAV_1(
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
      dVFanRet_flow=0.1,
      nPeaSys_nominal=100,
      pAirSupSet_rel_max=500))
    "Paramerers for system VAV_1"
    annotation (Dialog(group="Air handlers and fans"),
      Placement(transformation(extent={{-10,-8},{
            10,12}})));
annotation (
  defaultComponentPrefixes = "parameter",
  defaultComponentName = "dat");
end AllSystems;
