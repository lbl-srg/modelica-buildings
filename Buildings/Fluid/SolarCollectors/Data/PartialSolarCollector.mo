within Buildings.Fluid.SolarCollectors.Data;
record PartialSolarCollector

  parameter SolarCollectors.Types.Area ATyp "Gross or aperture area";
  parameter SolarCollectors.Types.DesignFluid Fluid
    "Design fluid - Water or air";
  parameter Modelica.SIunits.Area A "Area";
  parameter Modelica.SIunits.Mass mDry "Dry weight";
  parameter Modelica.SIunits.Volume V "Fluid volume";
  parameter Modelica.SIunits.Pressure dp_nominal "Pressure drop during test";
  parameter Real VperA_flow_nominal(unit="m/s")
    "Volume flow rate per area of test flow";
   parameter Real B0 "1st incident angle modifier coefficient";
   parameter Real B1 "2nd incident angle modifier coefficient";
   parameter Real y_intercept "Y intercept (Maximum efficiency)";
   parameter Real slope(unit = "W/(m2.K)") "Slope from rating data";
   parameter Real IAMDiff "Incidence angle modifier from EN12975 ratings data";
   parameter Real C1 "Heat loss coefficient from EN12974 ratings data";
   parameter Real C2
    "Temperature dependence of heat loss from EN12975 ratings data";
annotation(Documentation(info="<html>
Partial data file which is used for the <a href=\"modelica://Buildings.Fluid.SolarCollectors.BaseClasses.PartialSolarCollector\">Buildings.Fluid.Solarcollectors.BaseClasses.PartialSolarCollector</a>
model.</html>"));
end PartialSolarCollector;
