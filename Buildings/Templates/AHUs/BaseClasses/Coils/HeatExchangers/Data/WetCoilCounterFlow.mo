within Buildings.Templates.AHUs.BaseClasses.Coils.HeatExchangers.Data;
record WetCoilCounterFlow
  extends Interfaces.Data.HeatExchangerWater;

  parameter Modelica.SIunits.ThermalConductance UA_nominal=
    dat.getReal(varName=id + "." + funStr + " coil.UA (dry coil conditions)")
    "Thermal conductance at nominal flow";
  parameter Real r_nominal=2/3
    "Ratio between air-side and water-side convective heat transfer coefficient";
  parameter Integer nEle=4
    "Number of pipe segments used for discretization";

  annotation (
    defaultComponentName="datHex",
    defaultComponentPrefixes="outer parameter",
    Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end WetCoilCounterFlow;
