within Buildings.Templates.HeatingPlants.HotWater.Validation;
model BoilerPlantG36
  "Validation of boiler plant template with G36 controls"
  extends
    Buildings.Templates.HeatingPlants.HotWater.Validation.BoilerPlantOpenLoop(
    BOI(nAirHan=1, redeclare
        Buildings.Templates.HeatingPlants.HotWater.Components.Controls.Guideline36
        ctl(typMeaCtlHeaWatPri=Buildings.Templates.HeatingPlants.HotWater.Types.PrimaryOverflowMeasurement.FlowDifference,
          have_senDpHeaWatLoc=false)));

  UserProject.AirHandlerControlPoints sigAirHan[BOI.nAirHan]
    "AHU control points"
    annotation (Placement(transformation(extent={{-90,50},{-70,70}})));
  UserProject.BASControlPoints sigBAS "BAS control points"
    annotation (Placement(transformation(extent={{-90,10},{-70,30}})));
  UserProject.DistributionControlPoints sigDis(nSenDpHeaWatRem=BOI.ctl.nSenDpHeaWatRem)
    "HW distribution system control points"
    annotation (Placement(transformation(extent={{-90,-30},{-70,-10}})));
equation
  connect(sigAirHan.bus, BOI.busAirHan) annotation (Line(
      points={{-70,60},{-20,60},{-20,4}},
      color={255,204,51},
      thickness=0.5));
  connect(sigBAS.bus, BOI.bus) annotation (Line(
      points={{-70,20},{-60,20},{-60,0}},
      color={255,204,51},
      thickness=0.5));
  connect(sigDis.bus, BOI.bus) annotation (Line(
      points={{-70,-20},{-60,-20},{-60,0}},
      color={255,204,51},
      thickness=0.5));
end BoilerPlantG36;
