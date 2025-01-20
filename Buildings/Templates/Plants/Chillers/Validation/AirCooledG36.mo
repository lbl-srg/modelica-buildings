within Buildings.Templates.Plants.Chillers.Validation;
model AirCooledG36
  "Validation of air-cooled chiller plant template with Guideline 36 controls"
  extends Buildings.Templates.Plants.Chillers.Validation.AirCooledOpenLoop(
    pla(nAirHan=1,
        redeclare Buildings.Templates.Plants.Chillers.Components.Controls.G36 ctl));

  UserProject.DistributionControlPoints disChiWat(nSenDpChiWatRem=pla.ctl.nSenDpChiWatRem)
    "Emulation of control points from CHW distribution system"
    annotation (Placement(transformation(extent={{-90,10},{-70,30}})));
  UserProject.AirHandlerControlPoints airHan[pla.nAirHan]
    "Emulation of air handling unit control points"
    annotation (Placement(transformation(extent={{-90,40},{-70,60}})));
equation
  connect(disChiWat.bus, pla.bus) annotation (Line(
      points={{-70,20},{-60,20},{-60,0}},
      color={255,204,51},
      thickness=0.5));
  connect(airHan.bus, pla.busAirHan) annotation (Line(
      points={{-70,50},{-20,50},{-20,4}},
      color={255,204,51},
      thickness=0.5));
end AirCooledG36;
