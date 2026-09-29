within Buildings.Templates.Plants.Chillers.Validation;
model HardCase2
  "Validation of chiller plant template"
  extends Buildings.Templates.Plants.Chillers.Validation.WaterCooled(
    pla(
      ctl(
        locSenFloChiWatPri=Buildings.Templates.Plants.Chillers.Types.SensorLocation.Supply,
        have_senDpChiWatRemWir=true,
        typCtlHea=Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Types.HeadPressureControl.ByPlant),
      redeclare Buildings.Templates.Plants.Chillers.Components.Economizers.HeatExchangerWithPump eco))
  annotation(IconMap(primitivesVisible = false));
annotation(experiment(Tolerance=1e-6,
  StopTime=86400.0,
  __Dymola_Algorithm="Cvode"));
end HardCase2;
