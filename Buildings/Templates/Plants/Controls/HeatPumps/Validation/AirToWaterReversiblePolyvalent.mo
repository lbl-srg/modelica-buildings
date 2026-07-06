within Buildings.Templates.Plants.Controls.HeatPumps.Validation;
model AirToWaterReversiblePolyvalent
  "Validation model for AWHP plant controller with reversible and polyvalent heat pumps"
  extends Buildings.Templates.Plants.Controls.HeatPumps.Validation.AirToWaterReversibleHeatRecovery(
    ctl(
      typ=Buildings.Templates.Plants.Controls.Types.PlantHeatPump.ReversiblePolyvalent,
      is_priOnl=false,
      have_valPhpInlIso=false,
      have_valPhpOutIso=false,
      have_pumChiWatPriDedHp_select=false,
      have_pumPriHdr=false,
      nHp_select=2,
      nPhp_select=1,
      nPumHeaWatSec_select=2,
      nPumChiWatSec_select=2,
      capHeaPhp_nominal=fill(300E3, ctl.nPhp),
      capHeaShcPhp_nominal=Buildings.Templates.Data.Defaults.COPHpWwHea/
          Buildings.Templates.Data.Defaults.COPHpAwHea*ctl.capHeaPhp_nominal,
      TOutChiWatLck=273.15,
      capCooPhp_nominal=(1 - 1/Buildings.Templates.Data.Defaults.COPHpAwHea)*
          ctl.capHeaPhp_nominal,
      capCooShcPhp_nominal=(1 - 1/Buildings.Templates.Data.Defaults.COPHpWwHea)
          *ctl.capHeaShcPhp_nominal,
      VChiWatPhp_flow_min=0.6*ctl.VChiWatPhp_flow_nominal,
      VChiWatPhp_flow_nominal=1.1*ctl.capCooPhp_nominal/capCoo_nominal*
          VChiWat_flow_nominal,
      VHeaWatPhp_flow_min=0.6*ctl.VHeaWatPhp_flow_nominal,
      VHeaWatPhp_flow_nominal=1.1*ctl.capHeaPhp_nominal/capHea_nominal*
          VHeaWat_flow_nominal,
      yPumHeaWatPriDedPhpSet
                         =0.8,
      yPumChiWatPriDedPhpSet
                         =0.7),
    ratV_flow(
      table=[
        0, 0, 0;
        5, 0, 0;
        6, 1, 1;
        12, 0.2, 0.2;
        15, 0, 1;
        22, 0.1, 0.1;
        24, 0, 0])
        );
  Components.Controls.StatusEmulator y1Php_actual[ctl.nPhp]
    "Polyvalent HP status"
    annotation(Placement(transformation(extent={{90,94},{70,114}})));
  Buildings.Controls.OBC.CDL.Logical.Or y1HeaOrCooPhp[ctl.nPhp]
    "Polyvalent HP enabled in either mode"
    annotation(Placement(transformation(extent={{70,30},{90,50}})));
equation
  connect(ctl.y1HeaPhp, y1HeaOrCooPhp.u1)
    annotation(Line(points={{42,46},{60,46},{60,40},{68,40}},
      color={255,0,255}));
  connect(ctl.y1CooPhp, y1HeaOrCooPhp.u2)
    annotation(Line(points={{42,44},{60,44},{60,32},{68,32}},
      color={255,0,255}));
  connect(y1HeaOrCooPhp.y, y1Php_actual.y1)
    annotation(Line(points={{92,40},{132,40},{132,104},{92,104}},
      color={255,0,255}));
  connect(y1Php_actual.y1_actual, ctl.u1Php_actual)
    annotation(Line(points={{68,104},{-16,104},{-16,40},{-2,40},{-2,46}},
      color={255,0,255}));
annotation(__Dymola_Commands(
  file="modelica://Buildings/Resources/Scripts/Dymola/Templates/Plants/Controls/HeatPumps/Validation/AirToWaterReversiblePolyvalent.mos"
    "Simulate and plot"),
  experiment(StopTime=86400.0,
    Tolerance=1e-06),
    Documentation(info="<html>
<p>
  This model validates
  <a href=\"modelica://Buildings.Templates.Plants.Controls.HeatPumps.AirToWater\">
    Buildings.Templates.Plants.Controls.HeatPumps.AirToWater</a> in a
  configuration with two reversible heat pumps and one polyvalent heat pump.
</p>
<p>
Simulating this model shows how the controller responds to a varying load by
</p>
<ul>
  <li>enabling the polyvalent heat pump in simultaneous heating and
      cooling mode with priority,</li>
  <li>staging and unstaging the reversible heat pumps,</li>
  <li>enabling the dedicated primary pumps together with their equipment,</li>
  <li>rotating lead/lag equipment to ensure even wear,</li>
  <li>
    resetting the supply temperature and remote differential pressure in
    both the CHW and HW loops based on valve position,
  </li>
  <li>staging the secondary pumps.</li>
</ul>
</html>"));
end AirToWaterReversiblePolyvalent;
