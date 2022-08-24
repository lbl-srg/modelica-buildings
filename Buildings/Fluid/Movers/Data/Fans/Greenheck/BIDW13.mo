within Buildings.Fluid.Movers.Data.Fans.Greenheck;
record BIDW13 "Fan data for Greenheck 13 BIDW fan"
  extends Generic(
    final powerOrEfficiencyIsHydraulic=true,
    etaHydMet=Buildings.Fluid.Movers.BaseClasses.Types.HydraulicEfficiencyMethod.Power_VolumeFlowRate,
    speed_rpm_nominal=4100,
    power(V_flow={0.945419103313839, 1.89083820662768, 2.83300844704353,
                   3.77517868745939, 4.71734892787522, 5.38011695906431},
               P={         7091.607,         9492.761,        10954.333,
                          11610.549,        11849.173,        11252.613}),
    pressure(V_flow={0.945419103313839, 1.89083820662768, 2.83300844704353,
                      3.77517868745939, 4.71734892787522, 5.38011695906431},
                 dp={ 3010.50788091068, 3005.25394045534, 2632.22416812609,
                      1802.10157618213, 830.122591943958,                0}));
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
end BIDW13;
