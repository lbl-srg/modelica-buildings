within Buildings.Templates.Plants.Controls.HeatPumps.Validation;
model AirToWaterPolyvalent
  "Validation model for AWHP plant controller with polyvalent heat pumps"
  extends Buildings.Templates.Plants.Controls.HeatPumps.Validation.AirToWater(
    ctl(
      typ=Buildings.Templates.Plants.Controls.Types.PlantHeatPump.ReversiblePolyvalent,
      have_valPhpInlIso=false,
      have_valPhpOutIso=false,
      have_pumChiWatPriDedHp_select=true,
      nHp_select=2,
      nPhp_select=1,
      capHeaPhp_nominal=fill(300E3, ctl.nPhp),
      capHeaShcPhp_nominal=Buildings.Templates.Data.Defaults.COPHpWwHea /
        Buildings.Templates.Data.Defaults.COPHpAwHea * ctl.capHeaPhp_nominal,
      TOutChiWatLck=273.15,
      capCooPhp_nominal=(1 - 1 / Buildings.Templates.Data.Defaults.COPHpAwHea) *
        ctl.capHeaPhp_nominal,
      capCooShcPhp_nominal=(1 - 1 /
        Buildings.Templates.Data.Defaults.COPHpWwHea) *
        ctl.capHeaShcPhp_nominal),
    ratV_flow(
      table=[
        0, 0, 0;
        5, 0, 0;
        6, 1, 1;
        12, 0.2, 0.2;
        15, 0, 1;
        22, 0.1, 0.1;
        24, 0, 0
      ]));
  Components.Controls.StatusEmulator y1Php_actual[ctl.nPhp]
    "Polyvalent HP status"
    annotation(Placement(transformation(extent={{90,94},{70,114}})));
  Buildings.Controls.OBC.CDL.Logical.Or y1HeaOrCooPhp[ctl.nPhp]
    "Polyvalent HP enabled in either mode"
    annotation(Placement(transformation(extent={{70,24},{90,44}})));
equation
  connect(ctl.y1HeaPhp, y1HeaOrCooPhp.u1)
    annotation(Line(points={{42,34},{68,34}},
      color={255,0,255}));
  connect(ctl.y1CooPhp, y1HeaOrCooPhp.u2)
    annotation(Line(points={{42,32},{60,32},{60,26},{68,26}},
      color={255,0,255}));
  connect(y1HeaOrCooPhp.y, y1Php_actual.y1)
    annotation(Line(points={{92,34},{102,34},{102,104},{92,104}},
      color={255,0,255}));
  connect(y1Php_actual.y1_actual, ctl.u1Php_actual)
    annotation(Line(points={{68,104},{-16,104},{-16,40},{-2,40},{-2,40.2}},
      color={255,0,255}));
annotation(__Dymola_Commands(
  file="modelica://Buildings/Resources/Scripts/Dymola/Templates/Plants/Controls/HeatPumps/Validation/AirToWaterPolyvalent.mos"
    "Simulate and plot"),
  experiment(StopTime=86400.0,
    Tolerance=1e-06));
end AirToWaterPolyvalent;
