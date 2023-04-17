within Buildings.Templates.HeatingPlants.HotWater.Validation;
model BoilerPlant
  "Validation of boiler plant template with G36 controls"
  extends Buildings.Templates.HeatingPlants.HotWater.Validation.BoilerPlantOpenLoop(
    BOI(
      typ=Buildings.Templates.HeatingPlants.HotWater.Types.Boiler.Hybrid,
      nAirHan=1,
      nBoiCon_select=2,
      nBoiNon_select=2,
      typPumHeaWatPriCon=Buildings.Templates.HeatingPlants.HotWater.Types.PumpsPrimary.Variable,
      typPumHeaWatPriNon=Buildings.Templates.HeatingPlants.HotWater.Types.PumpsPrimary.Constant,
      typArrPumHeaWatPriCon_select=Buildings.Templates.Components.Types.PumpArrangement.Dedicated,
      typArrPumHeaWatPriNon_select=Buildings.Templates.Components.Types.PumpArrangement.Headered,
      typPumHeaWatSec=Buildings.Templates.HeatingPlants.HotWater.Types.PumpsSecondary.Centralized,
      redeclare Buildings.Templates.HeatingPlants.HotWater.Components.Controls.Guideline36 ctl(
        typMeaCtlHeaWatPri=Buildings.Templates.HeatingPlants.HotWater.Types.PrimaryOverflowMeasurement.FlowDifference,
        locSenVHeaWatPri=Buildings.Templates.HeatingPlants.HotWater.Types.SensorLocation.Return,
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
annotation (
  experiment(
    StartTime=0,
    StopTime=2000,
    Tolerance=1e-06));
end BoilerPlant;
