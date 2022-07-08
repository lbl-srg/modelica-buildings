within Buildings.Templates.ZoneEquipment.Validation.UserProject.Data;
record AllSystems "Top-level (whole building) record for testing purposes"
  extends Modelica.Icons.Record;

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
      VAirCooSet_flow_max=0.1,
      VAirHeaSet_flow_max=0.03,
      VAirSet_flow_min=0.01,
      AFlo=10,
      nOcc_nominal=1))
    "Parameters for system VAVBox_1"
    annotation (
      Dialog(group="Zone equipment"),
      Placement(transformation(extent={{-10,-8},{10,12}})));

  annotation (
  defaultComponentPrefixes = "parameter",
  defaultComponentName = "dat");
end AllSystems;
