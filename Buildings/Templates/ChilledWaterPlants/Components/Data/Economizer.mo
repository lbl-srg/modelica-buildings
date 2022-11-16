within Buildings.Templates.ChilledWaterPlants.Components.Data;
record Economizer "Record for waterside economizer model"
  extends Modelica.Icons.Record;

  parameter Buildings.Templates.ChilledWaterPlants.Types.Economizer typ
    "Equipment type"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));

  parameter Modelica.Units.SI.Density rhoChiWat_default=
    Modelica.Media.Water.ConstantPropertyLiquidWater.d_const
    "Default medium density"
    annotation(Dialog(enable=false));

  parameter Modelica.Units.SI.MassFlowRate mChiWat_flow_nominal(
    final min=0,
    start=0)
    "CHW mass flow rate"
    annotation(Dialog(group="Nominal condition",
    enable=typ<>Buildings.Templates.ChilledWaterPlants.Types.Economizer.None));
  parameter Modelica.Units.SI.MassFlowRate mConWat_flow_nominal(
    final min=0,
    start=0)
    "CW mass flow rate"
    annotation(Dialog(group="Nominal condition",
    enable=typ<>Buildings.Templates.ChilledWaterPlants.Types.Economizer.None));
  parameter Modelica.Units.SI.HeatFlowRate cap_nominal(
    final min=0,
    start=0)
    "Cooling capacity"
    annotation(Dialog(group="Nominal condition",
      enable=typ<>Buildings.Templates.ChilledWaterPlants.Types.Economizer.None));
  parameter Modelica.Units.SI.Temperature TChiWatEnt_nominal(
    final min=273.15,
    start=Buildings.Templates.Data.Defaults.TChiWatEcoEnt)
    "Heat exchanger entering CHW temperature"
    annotation(Dialog(group="Nominal condition",
    enable=typ<>Buildings.Templates.ChilledWaterPlants.Types.Economizer.None));
  parameter Modelica.Units.SI.Temperature TConWatEnt_nominal(
    final min=273.15,
    start=Buildings.Templates.Data.Defaults.TConWatEcoEnt)
    "Heat exchanger entering CW temperature"
    annotation(Dialog(group="Nominal condition",
    enable=typ<>Buildings.Templates.ChilledWaterPlants.Types.Economizer.None));
  parameter Modelica.Units.SI.PressureDifference dpChiWat_nominal(
    final min=0,
    start=Buildings.Templates.Data.Defaults.dpChiWatEco)
    "Heat exchanger CHW pressure drop"
    annotation(Dialog(group="Nominal condition",
    enable=typ<>Buildings.Templates.ChilledWaterPlants.Types.Economizer.None));
  parameter Modelica.Units.SI.PressureDifference dpConWat_nominal(
    final min=0,
    start=Buildings.Templates.Data.Defaults.dpConWatEco)
    "Heat exchanger CW design pressure drop"
    annotation(Dialog(group="Nominal condition",
    enable=typ<>Buildings.Templates.ChilledWaterPlants.Types.Economizer.None));
  parameter Modelica.Units.SI.PressureDifference dpValConWatIso_nominal(
    final min=0)=Buildings.Templates.Data.Defaults.dpValIso
    "WSE CW isolation valve"
    annotation(Dialog(group="Valves",
    enable=typ<>Buildings.Templates.ChilledWaterPlants.Types.Economizer.None));
  parameter Modelica.Units.SI.PressureDifference dpValChiWatByp_nominal(
    final min=0)=Buildings.Templates.Data.Defaults.dpValIso
    "WSE CHW bypass valve"
    annotation(Dialog(group="Valves",
    enable=typ==Buildings.Templates.ChilledWaterPlants.Types.Economizer.HeatExchangerWithValve));
  parameter Modelica.Units.SI.PressureDifference dpPumChiWat_nominal(
    final min=0,
    start=Buildings.Templates.Data.Defaults.dpChiWatEco)=dpChiWat_nominal
    "Total pressure rise"
    annotation (Dialog(group="Heat exchanger CHW pump",
      enable=typ==Buildings.Templates.ChilledWaterPlants.Types.Economizer.HeatExchangerWithPump));
  replaceable parameter Fluid.Movers.Data.Generic perPumChiWat
    constrainedby Buildings.Fluid.Movers.Data.Generic(
      pressure(
        V_flow={0, 1, 2} * mChiWat_flow_nominal / rhoChiWat_default,
        dp={1.14, 1, 0.42} * dpPumChiWat_nominal))
    "Performance data"
    annotation(Dialog(group="Heat exchanger CHW pump",
    enable=typ==Buildings.Templates.ChilledWaterPlants.Types.Economizer.HeatExchangerWithPump));
  annotation (
  defaultComponentName="datEco",
  Documentation(info="<html>
<p>
This record provides the set of sizing and operating parameters for 
waterside economizer models that can be found within 
<a href=\"modelica://Buildings.Templates.ChilledWaterPlants.Components.Economizers\">
Buildings.Templates.ChilledWaterPlants.Components.Economizers</a>.
</p>
</html>"));
end Economizer;
