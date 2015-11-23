within Buildings.Fluid.HeatExchangers.ActiveBeams.Data;
record CapacityActiveBeam "Generic data record for active beams"
  extends Modelica.Icons.Record;

  parameter
    Buildings.Fluid.HeatExchangers.ActiveBeams.BaseClasses.Characteristics.PerformanceCurve
    primaryair(variable={0,0.2,1}, f={0,0.5,1}) "primaryair";
  parameter
    Buildings.Fluid.HeatExchangers.ActiveBeams.BaseClasses.Characteristics.PerformanceCurve
    water(variable={0,0.5,1}, f={0,0.7,1}) "water";

  parameter
    Buildings.Fluid.HeatExchangers.ActiveBeams.BaseClasses.Characteristics.PerformanceCurve
    temp_diff(variable={0,0.5,1}, f={0,0.5,1}) "deltaT room water";

end CapacityActiveBeam;
