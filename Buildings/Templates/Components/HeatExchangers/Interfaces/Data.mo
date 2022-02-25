within Buildings.Templates.Components.HeatExchangers.Interfaces;
record Data
  extends Modelica.Icons.Record;

  parameter Buildings.Templates.Components.Types.HeatExchanger typ
    "Type of heat exchanger"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  // DX coils get nominal air flow rate from data record.


  parameter Modelica.Units.SI.PressureDifference dp1_nominal(
    final min=0,
    start=2e4)
    "Primary side pressure drop"
    annotation (Dialog(
      group="Nominal condition",
      enable=typ==Buildings.Templates.Components.Types.HeatExchanger.WetCoilEffectivenessNTU or
      typ==Buildings.Templates.Components.Types.HeatExchanger.DryCoilEffectivenessNTU or
      typ==Buildings.Templates.Components.Types.HeatExchanger.WetCoilCounterFlow));
  parameter Modelica.Units.SI.PressureDifference dp2_nominal(
    final min=0,
    start=200)
    "Secondary side pressure drop"
    annotation (Dialog(group="Nominal condition"));

  replaceable parameter
    Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Data.Generic.DXCoil datCoi
    constrainedby
    Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Data.Generic.DXCoil
    "Performance record"
    annotation(choicesAllMatching=true, Dialog(
      enable=typ==Buildings.Templates.Components.Types.HeatExchanger.DXMultiStage or
      typ==Buildings.Templates.Components.Types.HeatExchanger.DXVariableSpeed));

end Data;
