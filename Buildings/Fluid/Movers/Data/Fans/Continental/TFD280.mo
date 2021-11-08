within Buildings.Fluid.Movers.Data.Fans.Continental;
record TFD280 "Fan data for Continental TFD280"
  extends Generic(
    powMet=
      Buildings.Fluid.Movers.BaseClasses.Types.PowerMethod.PowerCharacteristic,
    speed_rpm_nominal=3450,
    power(V_flow={560, 1150, 1480, 1760, 2000, 2170, 2220}.*0.00047194745, P={1.1, 1.3, 1.4, 1.4, 1.4, 1.4, 1.4}.*745.69987158227),
    pressure(V_flow={560, 1150, 1480, 1760, 2000, 2170, 2220}.*0.00047194745, dp={6.0, 5.0, 4.0, 3.0, 2.0, 1.0, 0}.*249.08890833333));
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
end TFD280;
