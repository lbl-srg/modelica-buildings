within Buildings.Fluid.Movers.Data.Fans.Greenheck;
record BIDW16 "Fan data for Greenheck 16 BIDW fan"
  extends Generic(
    final powerOrEfficiencyIsHydraulic=true,
    etaHydMet=Buildings.Fluid.Movers.BaseClasses.Types.HydraulicEfficiencyMethod.Power_VolumeFlowRate,
    power(V_flow={2.83018867924528, 3.77358490566036, 4.71698113207544,
                  5.66037735849056, 6.60377358490564, 7.54716981132075,
                  8.49056603773583, 8.99776831000203},
               P={       18642.500,        21327.020,        22960.103,
                         23884.771,        24496.245,        24749.783,
                         24466.417,        23519.378}),
    pressure(V_flow={2.83018867924528, 3.77358490566036, 4.71698113207544,
                     5.66037735849056, 6.60377358490564, 7.54716981132075,
                     8.49056603773583, 8.99776831000203},
                 dp={3781.57683024939, 3663.31456154465, 3302.89621882542,
                     2705.95333869670, 2047.06355591311, 1323.41110217216,
                     504.022526146420, 0}));
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
end BIDW16;
