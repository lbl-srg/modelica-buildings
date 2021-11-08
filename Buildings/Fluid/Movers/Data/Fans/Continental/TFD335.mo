within Buildings.Fluid.Movers.Data.Fans.Continental;
record TFD335 "Fan data for Continental TFD335"
  extends Generic(
    powMet=
      Buildings.Fluid.Movers.BaseClasses.Types.PowerMethod.PowerCharacteristic,
    speed_rpm_nominal=1750,
    power(V_flow={720, 1300, 1630, 1900, 2110, 2320}.*0.00047194745, P={0.6, 0.6, 0.6, 0.7, 0.6, 0.6}.*745.69987158227),
    pressure(V_flow={720, 1300, 1630, 1900, 2110, 2320}.*0.00047194745, dp={2.5, 2.0, 1.5, 1.0, 0.5, 0}.*249.08890833333));
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
end TFD335;
