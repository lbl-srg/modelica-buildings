within Buildings.Templates.AHUs.BaseClasses.Controls;
partial block PartialSingleDuct "Partial control block for single duct AHU"
  extends Interfaces.Controller;

  outer replaceable Interfaces.OutdoorReliefReturnSection secOutRel
    "Outdoor/relief/return air section";

  outer replaceable Templates.BaseClasses.Coils.None coiCoo
    "Cooling coil";
  outer replaceable Templates.BaseClasses.Coils.None coiHea
    "Heating coil";
  outer replaceable Templates.BaseClasses.Coils.None coiReh
    "Reheat coil";

  outer parameter Templates.Types.Fan typFanSup
    "Type of supply fan";
  outer parameter Templates.Types.Fan typFanRet
    "Type of relief/return fan";

  annotation (Documentation(info="<html>
</html>"));
end PartialSingleDuct;
