within Buildings.Templates.BaseClasses.Controls.AHUs;
partial block SupplyReturn "Base class for controllers for AHU with supply and return"
  extends Buildings.Templates.Interfaces.ControllerAHU;

  outer replaceable Buildings.Templates.Interfaces.OutdoorAirSection outAir
    "OA section";

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
