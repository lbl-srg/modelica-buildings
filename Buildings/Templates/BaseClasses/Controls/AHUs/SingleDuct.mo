within Buildings.Templates.BaseClasses.Controls.AHUs;
partial block SingleDuct "Base class for controllers of single duct AHU"
  extends Templates.Interfaces.ControllerAHU;

  outer replaceable Templates.Interfaces.OutdoorReliefReturnSection secOutRel
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
end SingleDuct;
