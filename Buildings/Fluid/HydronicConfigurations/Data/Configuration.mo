within Buildings.Fluid.HydronicConfigurations.Data;
record Configuration "Record with configuration parameters"
  extends Modelica.Icons.Record;

  parameter Boolean have_bypFix
    "Set to true in case of a fixed bypass"
    annotation(Dialog(group="Configuration", enable=false), Evaluate=true);

  parameter Buildings.Fluid.HydronicConfigurations.Types.ValveCharacteristic typCha=
    Buildings.Fluid.HydronicConfigurations.Types.ValveCharacteristic.EqualPercentage
    "Control valve characteristic"
    annotation(Dialog(group="Configuration"), Evaluate=true);

  parameter Boolean have_ctl = false
    "Set to true in case of built-in controls"
    annotation(Dialog(group="Configuration"), Evaluate=true);

  parameter Boolean have_pum
    "Set to true if a secondary pump is used"
    annotation(Dialog(group="Configuration"), Evaluate=true);

  parameter Buildings.Fluid.HydronicConfigurations.Types.Pump typPum=
    Buildings.Fluid.HydronicConfigurations.Types.Pump.SingleVariable
    "Type of secondary pump"
    annotation(Dialog(group="Pump", enable=have_pum), Evaluate=true);

  parameter Buildings.Fluid.HydronicConfigurations.Types.PumpModel typPumMod=
    Buildings.Fluid.HydronicConfigurations.Types.PumpModel.SpeedFractional
    "Type of pump model"
    annotation(Dialog(group="Pump", enable=have_pum), Evaluate=true);

  parameter Buildings.Fluid.HydronicConfigurations.Types.ControlFunction typFun(
    start=Buildings.Fluid.HydronicConfigurations.Types.ControlFunction.Heating)
    "Circuit function (for built-in controls)"
    annotation(Dialog(group="Controls", enable=have_ctl), Evaluate=true);
  annotation (defaultComponentName="cfg");
end Configuration;
