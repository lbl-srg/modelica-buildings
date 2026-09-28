within Buildings.Templates.Plants.HeatPumps.Validation;
model HardCase3 "Validation of AWHP plant template"
  extends Buildings.Templates.Plants.HeatPumps.Validation.AirToWaterPolyvalent(
    pla(linearized=false,
      typDis_select1=Buildings.Templates.Plants.HeatPumps.Types.Distribution.Variable1Only,
      typArrPumPri_select=Buildings.Templates.Components.Types.PumpArrangement.Headered,
      ctl(have_senTLooRet_select=true, have_senDpHeaWatRemWir=false)))
      annotation(IconMap(primitivesVisible = false));
annotation(experiment(StopTime=86400,
  Tolerance=1e-06,
  __Dymola_Algorithm="Cvode"));
end HardCase3;
