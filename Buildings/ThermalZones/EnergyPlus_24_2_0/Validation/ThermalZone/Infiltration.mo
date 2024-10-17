within Buildings.ThermalZones.EnergyPlus_24_2_0.Validation.ThermalZone;
model Infiltration
  "Validation model for outside air infiltration in zones not modeled in Modelica"
  extends Modelica.Icons.Example;
  package Medium=Buildings.Media.Air
    "Medium model";

  Buildings.ThermalZones.EnergyPlus_24_2_0.Examples.SingleFamilyHouse.RadiantHeatingCooling_TRoom defInf(
    building(
      idfName = Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/Data/ThermalZones/EnergyPlus_24_2_0/Examples/SingleFamilyHouse_TwoSpeed_ZoneAirBalance/SingleFamilyHouse_TwoSpeed_ZoneAirBalance_aboveSoil.idf")))
    "Model with default infiltration in attic"
    annotation (Placement(transformation(extent={{-10,20},{10,40}})));
  Buildings.ThermalZones.EnergyPlus_24_2_0.Examples.SingleFamilyHouse.RadiantHeatingCooling_TRoom higInf(
    building(
      idfName = Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/Data/ThermalZones/EnergyPlus_24_2_0/Examples/SingleFamilyHouse_TwoSpeed_ZoneAirBalance/SingleFamilyHouse_TwoSpeed_ZoneAirBalance_aboveSoilHighInfiltration.idf")))
    "Model with high infiltration in attic"
    annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This validation case simulates two instances of
<a href=\"modelica://Buildings.ThermalZones.EnergyPlus_24_2_0.Examples.SingleFamilyHouse.RadiantHeatingCooling_TRoom\">
Buildings.ThermalZones.EnergyPlus_24_2_0.Examples.SingleFamilyHouse.RadiantHeatingCooling_TRoom</a>.
In the instance <code>higInf</code>, the infiltration rate of the unconditioned attic has been
significantly increased. This leads to a different surface temperature of the attic floor,
which can be shown by comparing the variables
<code>defInf.attFlo.heaPorFro.T</code> and
<code>higInf.attFlo.heaPorFro.T</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
May 18, 2021, by Michael Wetter:<br/>
First implementation for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2492\">#2492</a>.
</li>
</ul>
</html>"),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/EnergyPlus_24_2_0/Validation/ThermalZone/Infiltration.mos" "Simulate and plot"),
    experiment(
      StopTime=86400,
      Tolerance=1e-06));
end Infiltration;
