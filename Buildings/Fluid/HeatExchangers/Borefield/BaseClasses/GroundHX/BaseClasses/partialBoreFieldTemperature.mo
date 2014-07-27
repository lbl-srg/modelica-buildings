within Buildings.Fluid.HeatExchangers.Borefield.BaseClasses.GroundHX.BaseClasses;
partial function partialBoreFieldTemperature
  import SI = Modelica.SIunits;

  input Data.Records.General gen;
  input Data.Records.Soil soi;
  input Integer t_d "discrete time at which the temperature is calculated";

  output SI.Temperature T;

end partialBoreFieldTemperature;
