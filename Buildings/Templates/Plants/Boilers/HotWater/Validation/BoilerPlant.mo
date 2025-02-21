within Buildings.Templates.Plants.Boilers.HotWater.Validation;
model BoilerPlant
  "Validation of boiler plant template with G36 controls"
  extends
    Buildings.Templates.Plants.Boilers.HotWater.Validation.BoilerPlantOpenLoop(
    BOI(
      typ=Buildings.Templates.Plants.Boilers.HotWater.Types.Boiler.Hybrid,
      nBoiCon_select=2,
      nBoiNon_select=2,
      typPumHeaWatPriCon=Buildings.Templates.Plants.Boilers.HotWater.Types.PumpsPrimary.Variable,
      typPumHeaWatPriNon=Buildings.Templates.Plants.Boilers.HotWater.Types.PumpsPrimary.Constant,
      typArrPumHeaWatPriCon_select=Buildings.Templates.Components.Types.PumpArrangement.Headered,
      typPumHeaWatSec2_select=Buildings.Templates.Plants.Boilers.HotWater.Types.PumpsSecondary.Centralized,
      redeclare
        Buildings.Templates.Plants.Boilers.HotWater.Components.Controls.Guideline36
        ctl(
        nAirHan=1,
        nEquZon=0,
        typMeaCtlHeaWatPri=Buildings.Templates.Plants.Boilers.HotWater.Types.PrimaryOverflowMeasurement.FlowDifference,
        locSenVHeaWatPri=Buildings.Templates.Plants.Boilers.HotWater.Types.SensorLocation.Return,
        locSenVHeaWatSec=Buildings.Templates.Plants.Boilers.HotWater.Types.SensorLocation.Return,
        have_senDpHeaWatLoc=true)));

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
    Tolerance=1e-06), Documentation(info="<html>
<p>
This is a validation model for the boiler plant model
<a href=\"modelica://Buildings.Templates.Plants.Boilers.HotWater.BoilerPlant\">
Buildings.Templates.Plants.Boilers.HotWater.BoilerPlant</a>
with closed-loop controls as implemented within
<a href=\"modelica://Buildings.Templates.Plants.Boilers.HotWater.Components.Controls.Guideline36\">
Buildings.Templates.Plants.Boilers.HotWater.Components.Controls.Guideline36</a>.
</p>
<p>
A Python script is provided with this model to test all supported system
configurations, see
<code>Buildings/Resources/Scripts/travis/templates/BoilerPlant.py</code>.
</p>
</html>"));
end BoilerPlant;
