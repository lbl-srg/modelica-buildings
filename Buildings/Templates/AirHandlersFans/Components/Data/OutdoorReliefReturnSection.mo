within Buildings.Templates.AirHandlersFans.Components.Data;
record OutdoorReliefReturnSection "Record for outdoor/relief/return air section"
  extends Modelica.Icons.Record;

  parameter Buildings.Templates.Components.Types.Damper typDamOut
    "Outdoor air damper type"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Buildings.Templates.Components.Types.Damper typDamOutMin
    "Minimum outdoor air damper type"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Buildings.Templates.Components.Types.Damper typDamRel
    "Relief damper type"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Buildings.Templates.Components.Types.Damper typDamRet
    "Return damper type"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Buildings.Templates.Components.Types.Fan typFanRel
    "Type of relief fan"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Buildings.Templates.Components.Types.Fan typFanRet
    "Type of return fan"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));

  parameter Modelica.Units.SI.MassFlowRate mOutMin_flow_nominal(
    final min=0,
    start=0.2 * damOut.m_flow_nominal)
    "Minimum outdoor air mass flow rate at design conditions"
    annotation (Dialog(group="Dampers and economizers",
      enable=typDamOutMin<>Buildings.Templates.Components.Types.Damper.None));

  parameter Buildings.Templates.Components.Data.Damper damOut(
    final typ=typDamOut)
    "Outdoor air damper"
    annotation (Dialog(group="Dampers and economizers",
    enable=typDamOut <> Buildings.Templates.Components.Types.Damper.None));
  parameter Buildings.Templates.Components.Data.Damper damOutMin(
    final typ=typDamOutMin)
    "Minimum outdoor air damper"
    annotation (Dialog(group="Dampers and economizers",
    enable=typDamOutMin <> Buildings.Templates.Components.Types.Damper.None));
  parameter Buildings.Templates.Components.Data.Damper damRel(
    final typ=typDamRel)
    "Relief damper"
    annotation (Dialog(group="Dampers and economizers",
    enable=typDamRel <> Buildings.Templates.Components.Types.Damper.None));
  parameter Buildings.Templates.Components.Data.Damper damRet(
    final typ=typDamRet)
    "Return damper"
    annotation (Dialog(group="Dampers and economizers",
    enable=typDamRet <> Buildings.Templates.Components.Types.Damper.None));
  parameter Buildings.Templates.Components.Data.Fan fanRel(
    final typ=typFanRel)
    "Relief fan"
    annotation (Dialog(group="Fans",
    enable=typFanRel <>Buildings.Templates.Components.Types.Fan.None));
  parameter Buildings.Templates.Components.Data.Fan fanRet(
    final typ=typFanRet)
    "Return fan"
    annotation (Dialog(group="Fans",
    enable=typFanRet <>Buildings.Templates.Components.Types.Fan.None));
  annotation (Documentation(info="<html>
<p>
This record provides the set of sizing and operating parameters for
the classes within
<a href=\"modelica://Buildings.Templates.AirHandlersFans.Components.OutdoorReliefReturnSection\">
Buildings.Templates.AirHandlersFans.Components.OutdoorReliefReturnSection</a>.
</p>
</html>"));
end OutdoorReliefReturnSection;
