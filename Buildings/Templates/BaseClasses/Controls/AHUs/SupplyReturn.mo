within Buildings.Templates.BaseClasses.Controls.AHUs;
block SupplyReturn
  extends Buildings.Templates.Interfaces.ControllerAHU;

  outer replaceable Buildings.Templates.BaseClasses.Dampers.None damOut
    "OA damper";
  outer replaceable Buildings.Templates.BaseClasses.Dampers.None damOutMin
    "Minimum OA damper";
  outer replaceable Buildings.Templates.BaseClasses.Dampers.None damRel
    "Relief damper";
  outer replaceable Buildings.Templates.BaseClasses.Dampers.None damRet
    "Return damper";


  outer replaceable Buildings.Templates.BaseClasses.Coils.None coiCoo
    "Cooling coil";
  outer replaceable Buildings.Templates.BaseClasses.Coils.None coiHea
    "Heating coil";
  outer replaceable Buildings.Templates.BaseClasses.Coils.None coiReh
    "Reheat coil";

  outer replaceable Buildings.Templates.BaseClasses.Fans.None fanSupDra
    "Supply fan - Draw through";
  outer replaceable Buildings.Templates.BaseClasses.Fans.None fanSupBlo
    "Supply fan - Blow through";
  outer replaceable Buildings.Templates.BaseClasses.Fans.None fanRel
    "Relief fan";
  outer replaceable Buildings.Templates.BaseClasses.Fans.None fanRet
    "Return fan";

  final inner parameter Buildings.Templates.Types.Fan typFanSup=
    if fanSupDra.typ <> Buildings.Templates.Types.Fan.None then fanSupDra.typ
    elseif fanSupBlo.typ <> Buildings.Templates.Types.Fan.None then fanSupBlo.typ
    else Buildings.Templates.Types.Fan.None
    "Type of supply fan"
    annotation (Evaluate=true);
  final inner parameter Buildings.Templates.Types.Fan typFanRet=
    if fanRel.typ <> Buildings.Templates.Types.Fan.None then fanRel.typ
    elseif fanRet.typ <> Buildings.Templates.Types.Fan.None then fanRet.typ
    else Buildings.Templates.Types.Fan.None
    "Type of return fan"
    annotation (Evaluate=true);

end SupplyReturn;
