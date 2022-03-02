within Buildings.Fluid.Movers.Data.Fans.Greenheck;
record BIDW16 "Fan data for Greenheck 16 BIDW fan"
  extends Generic(
    etaHydMet=Buildings.Fluid.Movers.BaseClasses.Types.EfficiencyMethod.PowerCurve,
    speed_rpm_nominal=3750,
    power(V_flow={1.88679245283019,2.83561049663847,3.77358490566036,4.71698113207547,
          5.66579917588375,6.60919540229883,7.55259162871394,8.49598785512903,9.00021687269572},
        P={15652.243,18806.554,21267.364,22967.56,23772.916,24548.444,24749.783,
          24414.218,23437.351}),
    pressure(V_flow={1.88679245283019,2.83561049663847,3.77358490566036,4.71698113207547,
          5.66579917588375,6.60919540229883,7.55259162871394,8.49598785512903,9.00021687269572},
        dp={3782.64604810996,3779.63917525773,3659.36426116838,3301.54639175257,
          2706.1855670103,2047.68041237113,1320.01718213058,502.147766323023,0}));
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
