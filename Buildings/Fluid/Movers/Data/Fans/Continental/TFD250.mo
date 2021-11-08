within Buildings.Fluid.Movers.Data.Fans.Continental;
record TFD250 "Fan data for Continental TFD250"
  extends Generic(
    powMet=
      Buildings.Fluid.Movers.BaseClasses.Types.PowerMethod.PowerCharacteristic,
    speed_rpm_nominal=3450,
    power(V_flow={440, 870, 1110, 1320, 1520, 1625}.*0.00047194745, P={0.5, 0.6, 0.7, 0.7, 0.7, 0.6}.*745.69987158227),
    pressure(V_flow={440, 870, 1110, 1320, 1520, 1625}.*0.00047194745, dp={5.0, 4.0, 3.0, 2.0, 1.0, 0}.*249.08890833333));
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
end TFD250;
