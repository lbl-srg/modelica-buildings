within Buildings.Templates.ZoneEquipment.Components.Controls.Interfaces;
partial block PartialVAVBox
  "Partial control block for VAV terminal unit"
  extends
    Buildings.Templates.ZoneEquipment.Components.Controls.Interfaces.PartialController;

  outer replaceable Buildings.Templates.Components.Dampers.PressureIndependent damVAV
    "VAV damper";

end PartialVAVBox;
