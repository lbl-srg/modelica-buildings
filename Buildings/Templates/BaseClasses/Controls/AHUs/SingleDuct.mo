within Buildings.Templates.BaseClasses.Controls.AHUs;
partial block SingleDuct "Base class for controllers of single duct AHU"
  extends Buildings.Templates.Interfaces.ControllerAHU;

  outer replaceable Buildings.Templates.Interfaces.OutdoorAirSection secOut
    "Outdoor air section";
  outer replaceable Buildings.Templates.Interfaces.ReliefReturnSection secRel
    "Exhaust/relief/return section";

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

  final inner parameter Buildings.Templates.Types.Fan typFanSup=
    if fanSupDra.typ <> Buildings.Templates.Types.Fan.None then fanSupDra.typ
    elseif fanSupBlo.typ <> Buildings.Templates.Types.Fan.None then fanSupBlo.typ
    else Buildings.Templates.Types.Fan.None
    "Type of supply fan"
    annotation (Evaluate=true);
  final inner parameter Templates.Types.Fan typFanRet=secRel.typFan
    "Type of return fan"
    annotation (Evaluate=true);

end SingleDuct;
