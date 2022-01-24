within Buildings.Fluid.Movers.Data.Fans.EnglanderNorford1992;
record Supply "Data for the supply fan in Englander and Norford (1992)"
  extends Generic(
    powMet=
      Buildings.Fluid.Movers.BaseClasses.Types.PowerMethod.PowerCharacteristic,
    speed_rpm_nominal=875,
    power(V_flow={5.31958762886598,8.74226804123711,15.6701030927835,22.6391752577319,27.6288659793814,33.1134020618556,42.9278350515463},
          P={18642.5,22371,29828,37285,39447.53,37285,35510.234}),
    pressure(V_flow={5.31958762886598,8.74226804123711,15.6701030927835,22.6391752577319,27.6288659793814,33.1134020618556,42.9278350515463},
             dp={1438.82346368715,1403.37418994413,1332.4756424581,1219.8720670391,1042.62569832402,688.132960893855,4.1705027932961}));
  annotation (
defaultComponentPrefixes="parameter",
defaultComponentName="per",
Documentation(info="<html>
<p>
Performance data for the supply fan used in Englander and Norford (1992)
(figure below). See the documentation of
<a href=\"modelica://Buildings.Fluid.Movers.Data.Fans.EnglanderNorford1992\">
Buildings.Fluid.Movers.Data.Fans.EnglanderNorford1992</a>.
</p>
<p align=\"center\">
<img alt=\"Fan curve\" src=\"modelica://Buildings/Resources/Images/Fluid/Movers/Data/Supply.png\"/></p>
</html>"));
end Supply;
