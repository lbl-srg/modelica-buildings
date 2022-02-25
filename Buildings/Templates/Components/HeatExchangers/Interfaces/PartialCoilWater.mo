within Buildings.Templates.Components.HeatExchangers.Interfaces;
partial model PartialCoilWater
  extends Buildings.Fluid.Interfaces.PartialFourPortInterface(
    final m1_flow_nominal=datRec.m1_flow_nominal,
    final m2_flow_nominal=datRec.m2_flow_nominal);

  parameter Buildings.Templates.Components.Types.HeatExchanger typ
    "Type of heat exchanger"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  parameter Buildings.Templates.Components.HeatExchangers.Interfaces.Data datRec(
    final typ=typ)
    "Design and operating parameters";

  final parameter Modelica.Units.SI.PressureDifference dp1_nominal = datRec.dp1_nominal
    "Liquid pressure drop"
    annotation (Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.PressureDifference dp2_nominal = datRec.dp2_nominal
    "Air pressure drop"
    annotation (Dialog(group="Nominal condition"));



  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
    Bitmap(
      extent={{-100,-100},{100,100}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/HeatExchangers/Generic.svg")}),
                                            Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialCoilWater;
