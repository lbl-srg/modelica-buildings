within Buildings.Templates.Plants.HeatPumps.Validation;
model AirToWaterDebug "Validation of AWHP plant template"
  extends Buildings.Templates.Plants.HeatPumps.Validation.AirToWater(
    have_chiWat=true,
pla(have_hrc_select=true),
pla(typDis_select1=Buildings.Templates.Plants.HeatPumps.Types.Distribution.Constant1Variable2),
pla(typArrPumPri=Buildings.Templates.Components.Types.PumpArrangement.Dedicated),
pla(typPumHeaWatPri_select1=Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Constant),
pla(have_pumChiWatPriDed_select=false),
pla(ctl(have_senDpHeaWatRemWir=false)));
end AirToWaterDebug;
