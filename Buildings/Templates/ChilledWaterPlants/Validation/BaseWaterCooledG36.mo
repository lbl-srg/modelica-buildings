within Buildings.Templates.ChilledWaterPlants.Validation;
model BaseWaterCooledG36
  "Base model for validating CHW plant template with water-cooled chillers"
  extends Buildings.Templates.ChilledWaterPlants.Validation.BaseWaterCooled(
    CHI(nAirHan=1,
        redeclare Buildings.Templates.ChilledWaterPlants.Components.Controls.G36 ctl));

  UserProject.DistributionControlPoints disChiWat(nSenDpChiWatRem=CHI.ctl.nSenDpChiWatRem)
    "Emulation of control points from CHW distribution system"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  UserProject.AirHandlerControlPoints airHan[CHI.nAirHan]
    "Emulation of air handling unit control points"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
equation
  connect(disChiWat.bus, CHI.bus) annotation (Line(
      points={{-60,0},{-40,0}},
      color={255,204,51},
      thickness=0.5));
  connect(airHan.bus, CHI.busAirHan) annotation (Line(
      points={{-60,40},{0,40},{0,4}},
      color={255,204,51},
      thickness=0.5));
end BaseWaterCooledG36;
