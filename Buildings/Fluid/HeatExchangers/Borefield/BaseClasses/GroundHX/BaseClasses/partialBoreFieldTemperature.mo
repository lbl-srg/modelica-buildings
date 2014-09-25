within Buildings.Fluid.HeatExchangers.Borefield.BaseClasses.GroundHX.BaseClasses;
partial function partialBoreFieldTemperature
  import SI = Modelica.SIunits;
  extends Modelica.Icons.Function;

  input Data.Records.General gen "General parameters of the borefield";
  input Data.Records.Soil soi "Soil parameters";
  input Integer t_d "Discrete time at which the temperature is calculated";

  output SI.Temperature T "Borefield temperature";

end partialBoreFieldTemperature;
