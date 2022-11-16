within Buildings.Templates.ChilledWaterPlants.Validation;
model WaterCooledG36
  "Validation of water-cooled chiller plant template with closed-loop controls"
  extends Buildings.Templates.ChilledWaterPlants.Validation.WaterCooledOpenLoop(
    CHI(nAirHan=1,
        redeclare Buildings.Templates.ChilledWaterPlants.Components.Controls.G36 ctl));

  UserProject.DistributionControlPoints disChiWat(nSenDpChiWatRem=CHI.ctl.nSenDpChiWatRem)
    "Emulation of control points from CHW distribution system"
    annotation (Placement(transformation(extent={{-90,10},{-70,30}})));
  UserProject.AirHandlerControlPoints airHan[CHI.nAirHan]
    "Emulation of air handling unit control points"
    annotation (Placement(transformation(extent={{-90,40},{-70,60}})));
equation
  connect(disChiWat.bus, CHI.bus) annotation (Line(
      points={{-70,20},{-60,20},{-60,0}},
      color={255,204,51},
      thickness=0.5));
  connect(airHan.bus, CHI.busAirHan) annotation (Line(
      points={{-70,50},{-20,50},{-20,4}},
      color={255,204,51},
      thickness=0.5));
  annotation (
  experiment(
    StartTime=19612800,
    StopTime=19615000,
    Tolerance=1e-06),
  __Dymola_Commands(file=
  "modelica://Buildings/Resources/Scripts/Dymola/Templates/ChilledWaterPlants/Validation/WaterCooledG36.mos"
  "Simulate and plot"),
  Documentation(revisions="<html>
<ul>
<li>
November 18, 2022, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This is a validation model for the water-cooled chiller plant model
<a href=\"modelica://Buildings.Templates.ChilledWaterPlants.WaterCooled\">
Buildings.Templates.ChilledWaterPlants.WaterCooled</a>
with closed-loop controls as implemented within
<a href=\"modelica://Buildings.Templates.ChilledWaterPlants.Components.Controls.G36\">
Buildings.Templates.ChilledWaterPlants.Components.Controls.G36</a>.
</p>
</html>"));
end WaterCooledG36;
