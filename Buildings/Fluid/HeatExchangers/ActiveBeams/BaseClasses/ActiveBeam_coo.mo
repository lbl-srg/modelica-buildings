within Buildings.Fluid.HeatExchangers.ActiveBeams.BaseClasses;
record ActiveBeam_coo "Generic data record for active beams"
  extends Modelica.Icons.Record;

  parameter
    Buildings.Fluid.HeatExchangers.ActiveBeams.BaseClasses.Characteristics.PerformanceCurve_AirFlow
    primaryair(Normalized_AirFlow={0,0.2,1}, ModFactor={0,0.5,1}) "primaryair";
  parameter
    Buildings.Fluid.HeatExchangers.ActiveBeams.BaseClasses.Characteristics.PerformanceCurve_WaterFlow
    water(Normalized_WaterFlow={0,0.5,1}, ModFactor={0,0.7,1}) "water";

  parameter
    Buildings.Fluid.HeatExchangers.ActiveBeams.BaseClasses.Characteristics.PerformanceCurve_TempDiff
    temp_diff(Normalized_TempDiff={0,0.5,1}, ModFactor={0,0.5,1})
    "deltaT room water";

parameter Real mAir_flow_nominal "Nominal air mass flow rate";

  parameter Real mWat_flow_nominal_coo "Nominal water mass flow rate"
  annotation (Dialog(group="Nominal condition Cooling"));
  parameter Real temp_diff_nominal_coo
    "Nominal temperature difference room-water"
  annotation (Dialog(group="Nominal condition Cooling"));
  parameter Real Q_flow_nominal_coo "Nominal capacity"
  annotation (Dialog(group="Nominal condition Cooling"));

end ActiveBeam_coo;
