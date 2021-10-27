within Buildings.Templates.AirHandlersFans.Components.Controls.Interfaces;
partial block PartialSingleDuct "Partial control block for single duct AHU"
  extends
    .Buildings.Templates.AirHandlersFans.Components.Controls.Interfaces.PartialController;

  outer replaceable
    OutdoorReliefReturnSection.Interfaces.PartialOutdoorReliefReturnSection
    secOutRel "Outdoor/relief/return air section";

  outer replaceable .Buildings.Templates.Components.Coils.None coiCoo
    "Cooling coil";
  outer replaceable .Buildings.Templates.Components.Coils.None coiHea
    "Heating coil";
  outer replaceable .Buildings.Templates.Components.Coils.None coiReh
    "Reheat coil";

  outer parameter Buildings.Templates.Components.Types.Fan typFanSup
    "Type of supply fan";
  outer parameter Buildings.Templates.Components.Types.Fan typFanRet
    "Type of relief/return fan";

  annotation (Documentation(info="<html>
</html>"));
end PartialSingleDuct;
