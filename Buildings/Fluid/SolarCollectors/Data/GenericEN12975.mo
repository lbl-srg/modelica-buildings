within Buildings.Fluid.SolarCollectors.Data;
record GenericEN12975
  "Generic data record providing inputs for specific EN12975 collector data records"
  extends Buildings.Fluid.SolarCollectors.Data.BaseClasses.PartialSolarCollector;

  parameter Real IAMDiff "Incidence angle modifier from EN12975 ratings data";
  parameter Real eta_0 "Optical efficiency (Maximum efficiency)";
  parameter Real C1 "Heat loss coefficient from EN12975 ratings data";
  parameter Real C2
    "Temperature dependence of heat loss from EN12975 ratings data";

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
end GenericEN12975;
