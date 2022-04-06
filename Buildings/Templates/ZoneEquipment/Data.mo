within Buildings.Templates.ZoneEquipment;
package Data "Records for design and operating parameters"
  extends Modelica.Icons.MaterialPropertiesPackage;

  record PartialAirTerminal "Record for air terminal unit interface class"
    extends Modelica.Icons.Record;

    parameter Buildings.Templates.ZoneEquipment.Types.Configuration typ
      "Type of system"
      annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
    parameter Boolean have_souChiWat
      "Set to true if system uses CHW"
      annotation (Evaluate=true, Dialog(group="Configuration"));
    parameter Boolean have_souHeaWat
      "Set to true if system uses HHW"
      annotation (Evaluate=true, Dialog(group="Configuration"));
    parameter Buildings.Templates.ZoneEquipment.Types.Controller typCtl
      "Type of controller"
      annotation (Evaluate=true, Dialog(group="Configuration", enable=false));

    parameter String id
     "System tag"
      annotation (Dialog(group="Configuration"));
    parameter String id_souAir=""
      "Air supply system tag"
      annotation (Evaluate=true, Dialog(group="Configuration"));
    parameter String id_souChiWat=""
      "CHW supply system tag"
      annotation (Evaluate=true, Dialog(group="Configuration", enable=have_souChiWat));
    parameter String id_souHeaWat=""
      "HHW supply system tag"
      annotation (Evaluate=true, Dialog(group="Configuration", enable=have_souHeaWat));

    parameter Modelica.Units.SI.MassFlowRate mAir_flow_nominal(
      final min=0,
      start=1)
      "Discharge air mass flow rate"
      annotation (Dialog(group="Nominal condition"));

    replaceable parameter Buildings.Templates.ZoneEquipment.Components.Data.PartialController
      ctl(final typ=typCtl)
      "Controller"
      annotation (Dialog(group="Controls"));

  end PartialAirTerminal;

  record VAVBox "Record for VAV terminal unit"
    extends Buildings.Templates.ZoneEquipment.Data.PartialAirTerminal(
      redeclare Buildings.Templates.ZoneEquipment.Components.Data.VAVBoxController
        ctl(final have_CO2Sen=have_CO2Sen),
      final mAir_flow_nominal=ctl.VAir_flow_nominal * 1.2);

    parameter Buildings.Templates.Components.Types.Damper typDamVAV
      "Type of VAV damper"
      annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
    parameter Buildings.Templates.Components.Types.Coil typCoiHea
      "Type of heating coil"
      annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
    parameter Buildings.Templates.Components.Types.Valve typValCoiHea
      "Type of valve for heating coil"
      annotation (Dialog(group="Configuration", enable=false));
    parameter Boolean have_CO2Sen
      "Set to true if the zone has CO2 sensor"
      annotation (Dialog(group="Configuration", enable=false));

    parameter Buildings.Templates.Components.Data.Damper damVAV(
      final typ=typDamVAV,
      m_flow_nominal=mAir_flow_nominal)
      "VAV damper"
      annotation (Dialog(group="Equipment"));

    parameter Buildings.Templates.Components.Data.Coil coiHea(
      final typ=typCoiHea,
      final typVal=typValCoiHea,
      final have_sou=have_souHeaWat,
      mAir_flow_nominal=ctl.VAirHeaSet_flow_max*1.2)
      "Reheat coil"
      annotation (Dialog(group="Equipment"));

  end VAVBox;
annotation (Documentation(info="<html>
<p>
This package provides records for design and operating parameters.
</p>
</html>"));
end Data;
