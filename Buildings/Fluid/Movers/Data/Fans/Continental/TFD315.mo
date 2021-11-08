within Buildings.Fluid.Movers.Data.Fans.Continental;
record TFD315 "Fan data for Continental TFD315"
  extends Generic(
    powMet=
      Buildings.Fluid.Movers.BaseClasses.Types.PowerMethod.PowerCharacteristic,
    speed_rpm_nominal=3450,
    power(V_flow={1480, 1910, 2230, 2500, 2740, 2960, 3160, 3330}.*0.00047194745, P={2.3, 2.5, 2.6, 2.6, 2.6, 2.5, 2.5, 2.5}.*745.69987158227),
    pressure(V_flow={1480, 1910, 2230, 2500, 2740, 2960, 3160, 3330}.*0.00047194745, dp={7.0, 6.0, 5.0, 4.0, 3.0, 2.0, 1.0, 0}.*249.08890833333));
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
end TFD315;
