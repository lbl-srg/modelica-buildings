within Buildings.Fluid.SolarCollectors.Data.BaseClasses;
record PartialSolarCollector
  "Base record providing common inputs for both ASHRAE93 and EN12975 collector data records"
  extends Modelica.Icons.Record;

  parameter SolarCollectors.Types.Area ATyp
    "Gross, absorber, or aperture area";
  parameter Modelica.Units.SI.Area A "Area";
  parameter Modelica.Units.SI.Mass mDry "Dry weight";
  parameter Modelica.Units.SI.Volume V "Fluid volume";
  parameter Modelica.Units.SI.PressureDifference dp_nominal(displayUnit="Pa")
    "Pressure drop during test conditions";
  parameter Real mperA_flow_nominal(unit="kg/(s.m2)")
    "Mass flow rate per unit area of collector (for pressure drop calculations)";
  parameter Modelica.Units.SI.Irradiance G_nominal
    "Nominal solar irradiance specified in ratings data";
  parameter Modelica.Units.SI.TemperatureDifference dT_nominal
    "Nominal temperature difference (between the collector inlet and outlet) specified in ratings data";
  parameter Real B0 "1st incident angle modifier coefficient";
  parameter Real B1 "2nd incident angle modifier coefficient";

annotation (
defaultComponentPrefixes="parameter",
defaultComponentName="datSolCol",
Documentation(info="<html>
  <p>
    Generic data file which is used for the
    <a href=\"modelica://Buildings.Fluid.SolarCollectors.BaseClasses.PartialSolarCollector\">
    Buildings.Fluid.SolarCollectors.BaseClasses.PartialSolarCollector</a> model. It establishes
    the base inputs needed to create model-specific data packages.
  </p>
</html>"));
end PartialSolarCollector;
