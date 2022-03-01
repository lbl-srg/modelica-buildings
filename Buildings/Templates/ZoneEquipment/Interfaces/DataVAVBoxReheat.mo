within Buildings.Templates.ZoneEquipment.Interfaces;
record DataVAVBoxReheat
  extends Buildings.Templates.ZoneEquipment.Interfaces.Data(
    mAir_flow_nominal=ctl.VAir_flow_nominal * 1.2);

  parameter Buildings.Templates.Components.Types.Damper typDamVAV
    "Type of VAV damper"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));

  parameter Buildings.Templates.Components.Types.Coil typCoiHea
    "Type of heating coil"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));

  parameter Boolean have_CO2Sen
    "Set to true if the zone has CO2 sensor"
    annotation (Dialog(group="Configuration", enable=false));

  parameter Buildings.Templates.Components.Dampers.Interfaces.Data damVAV(
    final typ=typDamVAV,
    m_flow_nominal=mAir_flow_nominal)
    "VAV damper";

  parameter Buildings.Templates.Components.Coils.Interfaces.Data coiHea(
    final typ=typCoiHea,
    mAir_flow_nominal=ctl.VAirHeaSet_flow_max * 1.2)
    "Reheat coil";

  parameter Buildings.Templates.ZoneEquipment.Components.Controls.Interfaces.DataG36VAVBoxReheat ctl(
    final have_CO2Sen=have_CO2Sen);

end DataVAVBoxReheat;
