within Buildings.Fluid.Movers.Data.Fans.Greenheck;
record BIDW15 "Fan data for Greenheck 15 BIDW fan"
  extends Generic(
    powMet=
      Buildings.Fluid.Movers.BaseClasses.Types.PowerMethod.PowerCharacteristic,
    speed_rpm_nominal=3900,
    power(V_flow={0,0.940664447218753,1.88566375364128,2.82632820086003,3.77132750728255,4.7119919545013,5.66132612012761,6.60199056734636,7.02680676931611},
          P={6890.268,9216.852,12169.824,15189.909,16248.803,16122.034,16718.594,16890.105,16427.771}),
    pressure(V_flow={0,0.940664447218753,1.88566375364128,2.82632820086003,3.77132750728255,4.7119919545013,5.66132612012761,6.60199056734636,7.02680676931611},
             dp={3247.58560140474,3347.67339771729,3389.81562774363,3300.26338893766,2894.64442493415,2183.49429323968,1409.1308165057,479.367866549604,0}));
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
end BIDW15;
