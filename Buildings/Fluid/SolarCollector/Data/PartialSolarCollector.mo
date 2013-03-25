within Buildings.Fluid.SolarCollector.Data;
record PartialSolarCollector
  "Contains the information necessary for the PartialSolarCollector model"
  parameter Buildings.Fluid.SolarCollector.Types.Area ATyp
    "Gross or aperture area";
  parameter Buildings.Fluid.SolarCollector.Types.DesignFluid Fluid
    "Design fluid - Water or air";
  parameter Modelica.SIunits.Area A "Area";
  parameter Modelica.SIunits.Mass mDry "Dry weight";
  parameter Modelica.SIunits.Volume V "Fluid volume";
  parameter Modelica.SIunits.Pressure dp_nominal "Pressure drop during test";
  parameter Real VperA_flow_nominal(unit="m/s")
    "Volume flow rate per area of test flow";
   parameter Real B0 "1st incident angle modifier coefficient";
   parameter Real B1=0 "2nd incident angle modifier coefficient";
   parameter Real y_intercept "Y intercept (Maximum efficiency)";
   parameter Real slope(unit = "W/(m2.K)") "Slope from rating data";
   parameter Real IAMDiff "Incidence angle modifier from EN12975 ratings data";
   parameter Real C1 "Heat loss coefficient from EN12974 ratings data";
   parameter Real C2
    "Temperature dependance of heat loss from EN12975 ratings data";
end PartialSolarCollector;
