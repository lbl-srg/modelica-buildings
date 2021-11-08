within Buildings.Fluid.Movers.Data.Fans.Continental;
record TFD450 "Fan data for Continental TFD450"
  extends Generic(
    powMet=
      Buildings.Fluid.Movers.BaseClasses.Types.PowerMethod.PowerCharacteristic,
    speed_rpm_nominal=1750,
    power(V_flow={2160, 2660, 3080, 3460, 3780, 4080, 4320, 4490}.*0.00047194745, P={1.7, 1.8, 1.8, 1.8, 1.8, 1.8, 1.8, 1.8}.*745.69987158227),
    pressure(V_flow={2160, 2660, 3080, 3460, 3780, 4080, 4320, 4490}.*0.00047194745, dp={3.5, 3.0, 2.5, 2.0, 1.5, 1.0, 0.5, 0}.*249.08890833333));
  annotation (
defaultComponentPrefixes="parameter",
defaultComponentName="per",
Documentation(info="<html>
<p>
Fan performance data. 
See the documentation of 
<a href=\"modelica://Buildings.Fluid.Movers.Data.Fans.Continental\">
Buildings.Fluid.Movers.Data.Fans.Continental</a>.
</p>
</html>"));
end TFD450;
