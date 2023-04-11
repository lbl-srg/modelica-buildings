within Buildings.Fluid.Movers.Data.Pumps.Wilo;
record VeroLine50slash150dash4slash2
  "Pump data for a Wilo Veroline IP-E 50/150-4/2 pump"
  extends Generic(
    final powerOrEfficiencyIsHydraulic=false,
    etaHydMet=Buildings.Fluid.Movers.BaseClasses.Types.HydraulicEfficiencyMethod.Power_VolumeFlowRate,
    power(V_flow={       0.0, 0.00277777, 0.00555555, 0.00833333, 0.01111111,
                  0.01388888, 0.01666666},
               P={    1607.8,     2235.3,     2862.7,     3529.4,     4078.4,
                      4392.2,     4666.7}),
    pressure(V_flow={       0.0, 0.00277777, 0.00555555, 0.00833333, 0.01111111,
                     0.01388888, 0.01666666},
                 dp={    255400,     253000,     250600,     248200,     232010,
                         199640,     156470}),
    motorCooledByFluid=true);
  annotation (
defaultComponentPrefixes="parameter",
defaultComponentName="per",
Documentation(info="<html>
<p>Data from:<a href=\"http://productfinder.wilo.com/com/en/c0000002200012eb000020023/_0000004f0003f94e0001003a/product.html\"> http://productfinder.wilo.com/com/en/c0000002200012eb000020023/_0000004f0003f94e0001003a/product.html</a></p>
<p>See <a href=\"modelica://Buildings.Fluid.Movers.Data.Pumps.Wilo.Stratos25slash1to6\">Buildings.Fluid.Movers.Data.Pumps.Wilo.Stratos25slash1to6</a>for more information about how the data is derived.</p>
</html>",   revisions="<html>
<ul>
<li>
March 29, 2023, by Hongxiang Fu:<br/>
Deleted angular speed parameters with the unit rpm.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1704\">IBPSA, #1704</a>.
</li>
<li>
October 14, 2021, by Hongxiang Fu:<br/>
Rewrote the statements using <code>use_powerCharacteristic</code>
to support the implementation of
<a href=\"Modelica://Buildings.Fluid.Movers.BaseClasses.Euler\">
<code>Buildings.Fluid.Movers.BaseClasses.Euler</code></a>.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2668\">#2668</a>.
</li>
<li>
May 28, 2017, by Iago Cupeiro:
<br/>
Initial version
</li>
</ul>
</html>"));
end VeroLine50slash150dash4slash2;
