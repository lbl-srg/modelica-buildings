within Buildings.Fluid.Movers.Data.Fans.Greenheck;
record BIDW18 "Fan data for Greenheck 18 BIDW fan"
  extends Generic(
    final powerOrEfficiencyIsHydraulic=true,
    etaHydMet=Buildings.Fluid.Movers.BaseClasses.Types.HydraulicEfficiencyMethod.Power_VolumeFlowRate,
    speed_rpm_nominal=3530,
    power(V_flow={2.83387830993139, 3.77636725011219,   4.718856190293,
                  5.66134513047381, 6.60383407065461, 7.55273450022439,
                  8.49522344040519,   9.437712380586, 10.3802013207668,
                  10.8546515355517},
               P={       23966.798,        27486.502,        30163.565,
                         32236.611,        33996.463,        35167.212,
                         35965.111,        35883.084,        35308.895,
                         34167.974}),
    pressure(V_flow={2.83387830993139, 3.77636725011219,   4.718856190293,
                     5.66134513047381, 6.60383407065461, 7.55273450022439,
                     8.49522344040519,   9.437712380586, 10.3802013207668,
                     10.8546515355517},
                 dp={4223.51959966638, 4203.50291909924,  4106.7556296914,
                     3913.26105087572, 3532.94412010008,  2855.7130942452,
                     2105.08757297748,  1274.3953294412, 457.047539616347,
                                    0}));
  annotation (
defaultComponentPrefixes="parameter",
defaultComponentName="per",
Documentation(info="<html>
<p>
Fan performance data.
See the documentation of
<a href=\"modelica://Buildings.Fluid.Movers.Data.Fans.Greenheck\">
Buildings.Fluid.Movers.Data.Fans.Greenheck</a>.
</p>
</html>"));
end BIDW18;
