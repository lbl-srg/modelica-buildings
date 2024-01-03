within Buildings.Fluid.SolarCollectors.Data.BaseClasses;
record Generic
  "Base record providing common inputs for both ASHRAE93 and EN12975 collector data records"
  extends Modelica.Icons.Record;

  parameter SolarCollectors.Types.Area ATyp
    "Gross, absorber, or aperture area";
  parameter Modelica.Units.SI.Area A "Area";
  parameter Modelica.Units.SI.HeatCapacity C
    "Heat capacity of the solar thermal collector including fluid";
  parameter Real mperA_flow_nominal(unit="kg/(s.m2)")
    "Nominal mass flow rate per unit area of collector";
  parameter Modelica.Units.SI.PressureDifference dp_nominal(displayUnit="Pa")
    "Nominal pressure drop";
  parameter Modelica.Units.SI.TemperatureDifference dT_nominal=10
    "Nominal temperature difference (between the collector inlet and outlet) specified in ratings data";
  parameter Real b0 "1st incident angle modifier coefficient";
  parameter Real b1 "2nd incident angle modifier coefficient";

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
end Generic;
