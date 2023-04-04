within Buildings.Fluid.Movers.Examples.Data;
record EnglanderNorford1992 "Data for the supply fan in Englander and Norford (1992)"
  extends Buildings.Fluid.Movers.Data.Generic(
    etaHydMet=Buildings.Fluid.Movers.BaseClasses.Types.HydraulicEfficiencyMethod.Power_VolumeFlowRate,
    speed_rpm_nominal=875,
    power(V_flow={5.44049459041731, 8.71715610510046, 15.6826378155589,
                  19.9484801648634, 22.5450798557444, 25.6362699639361,
                  27.8619268418341, 29.8402885110767, 32.9314786192684,
                   36.764554353426, 40.1648634724368, 42.9057187017001},
          P={              18642.5,            22371,            29828,
                         34652.679,            37285,         39149.25,
                         39454.987,        38612.346,            37285,
                         35912.912,        35308.895,        36002.396}),
    pressure(V_flow={5.44049459041731, 8.71715610510046, 15.6826378155589,
                     19.9484801648634, 22.5450798557444, 25.6362699639361,
                     27.8619268418341, 29.8402885110767, 32.9314786192684,
                      36.764554353426, 40.1648634724368, 42.9057187017001},
             dp={    1430.48245810056, 1404.41681564246,  1332.4756424581,
                      1280.3443575419,  1224.0425698324, 1128.12100558659,
                     1034.28469273743, 909.169608938547,  702.72972067039,
                     433.732290502792,  197.05625698324, 6.25575418994417}));
  annotation (
defaultComponentPrefixes="parameter",
defaultComponentName="per",
Documentation(info="<html>
<p>
Performance data for the supply fan used in Englander and Norford (1992)
(figure below). See the documentation of
<a href=\"modelica://Buildings.Fluid.Movers.Data.Fans.Greenheck\">
Buildings.Fluid.Movers.Data.Fans.Greenheck</a>
for the methods used to extract data.
</p>
<p align=\"center\">
<img alt=\"Fan curve\" src=\"modelica://Buildings/Resources/Images/Fluid/Movers/Examples/Supply.png\"/></p>
<h4>References</h4>
<p>
Englander, S. L., and L. K. Norford. 
\"Saving fan energy in VAV systems- part 1: analysis of a variable-speed-drive retrofit.\" 
<i>ASHRAE Winter Meeting, Anaheim, CA, USA, 01/25-29/92.</i> 1992.
</p>
</html>"));
end EnglanderNorford1992;
