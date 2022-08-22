within Buildings.Fluid.SolarCollectors.Data;
record GenericSolarCollector
  "Generic data record providing inputs for specific collector data records"
  extends Modelica.Icons.Record;

  parameter SolarCollectors.Types.Area ATyp "Gross or aperture area";
  parameter Modelica.Units.SI.Area A "Area";
  parameter Modelica.Units.SI.Mass mDry "Dry weight";
  parameter Modelica.Units.SI.Volume V "Fluid volume";
  parameter Modelica.Units.SI.PressureDifference dp_nominal(displayUnit="Pa")
    "Pressure drop during test conditions";
  parameter Real mperA_flow_nominal(unit="kg/(s.m2)")
    "Mass flow rate per unit area of collector";
   parameter Real B0 "1st incident angle modifier coefficient";
   parameter Real B1 "2nd incident angle modifier coefficient";
   parameter Real y_intercept "Y intercept (Maximum efficiency)";
   parameter Real slope(final max=0, final unit = "W/(m2.K)") "Slope from rating data";
   parameter Real IAMDiff "Incidence angle modifier from EN12975 ratings data";
   parameter Real C1 "Heat loss coefficient from EN12975 ratings data";
   parameter Real C2
    "Temperature dependence of heat loss from EN12975 ratings data";
  parameter Modelica.Units.SI.Irradiance G_nominal
    "Nominal solar irradiance specified in ratings data";
  parameter Modelica.Units.SI.TemperatureDifference dT_nominal
    "Nominal temperature difference specified in ratings data";
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
end GenericSolarCollector;
