within Buildings.Templates.AirHandlersFans.Components.Data;
record OutdoorReliefReturnSection
  extends Modelica.Icons.Record;

  parameter Buildings.Templates.Components.Types.Damper typDamOut
    "Outdoor air damper type"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Buildings.Templates.Components.Types.Damper typDamOutMin
    "Minimum outdoor air damper type"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));

  parameter Buildings.Templates.Components.Data.Damper damOut(final typ=
        typDamOut) "Outdoor air damper" annotation (Dialog(group="Mechanical",
        enable=typDamOut <> Buildings.Templates.Components.Types.Damper.None));
  parameter Buildings.Templates.Components.Data.Damper damOutMin(final typ=
        typDamOutMin) "Minimum outdoor air damper" annotation (Dialog(group=
          "Mechanical", enable=typDamOutMin <> Buildings.Templates.Components.Types.Damper.None));
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

  parameter Buildings.Templates.Components.Data.Damper damRel(final typ=
        typDamRel) "Relief damper" annotation (Dialog(group="Mechanical",
        enable=typDamRel <> Buildings.Templates.Components.Types.Damper.None));
  parameter Buildings.Templates.Components.Data.Damper damRet(final typ=
        typDamRet) "Return damper" annotation (Dialog(group="Mechanical",
        enable=typDamRet <> Buildings.Templates.Components.Types.Damper.None));
  parameter Buildings.Templates.Components.Data.Fan fanRel(final typ=typFanRel)
    "Relief fan" annotation (Dialog(group="Mechanical", enable=typFanRel <>
          Buildings.Templates.Components.Types.Fan.None));
  parameter Buildings.Templates.Components.Data.Fan fanRet(final typ=typFanRet)
    "Return fan" annotation (Dialog(group="Mechanical", enable=typFanRet <>
          Buildings.Templates.Components.Types.Fan.None));
end OutdoorReliefReturnSection;
