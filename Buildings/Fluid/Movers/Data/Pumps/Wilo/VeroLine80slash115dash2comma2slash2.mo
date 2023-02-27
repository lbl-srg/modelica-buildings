within Buildings.Fluid.Movers.Data.Pumps.Wilo;
record VeroLine80slash115dash2comma2slash2
  "Pump data for a Wilo Veroline IP-E 80/115-2,2/2 pump"
  extends Generic(
    speed_rpm_nominal=2900,
    final powerOrEfficiencyIsHydraulic=false,
    etaHydMet=Buildings.Fluid.Movers.BaseClasses.Types.HydraulicEfficiencyMethod.Power_VolumeFlowRate,
    power(V_flow={            0.0, 0.00381944444444, 0.00770833333333,
                  0.0111111111111,         0.014375,  0.0171527777778,
                  0.0197916666667,  0.0220138888889},
               P={  1712.23021583,    1939.82995422,     2319.7768316,
                    2599.92683819,    2775.17985612,    2815.09529219,
                    2709.57970466,    2571.61543492}),
    pressure(V_flow={            0.0, 0.00381944444444, 0.00770833333333,
                     0.0111111111111,         0.014375,  0.0171527777778,
                     0.0197916666667,  0.0220138888889},
                 dp={       157548.6,        150053.76,         139302.0,
                            127431.9,         113011.2,         97943.04,
                            76596.48,         57133.44}),
    motorCooledByFluid=true);
  annotation (
defaultComponentPrefixes="parameter",
defaultComponentName="per",
Documentation(info="<html>
<p>Data from:<a href=\"http://productfinder.wilo.com/com/en/c0000002200012eb000020023/_0000001d000149e80001003a/product.html\"> http://productfinder.wilo.com/com/en/c0000002200012eb000020023/_0000001d000149e80001003a/product.html</a></p>
<p>See <a href=\"modelica://Buildings.Fluid.Movers.Data.Pumps.Wilo.Stratos25slash1to6\">Buildings.Fluid.Movers.Data.Pumps.Wilo.Stratos25slash1to6 </a>for more information about how the data is derived. </p>
</html>",   revisions="<html>
<ul>
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
June 01, 2017, by Iago Cupeiro:
<br/>
Changed data link to the English version
</li>
<li>
February 17, 2016, by Michael Wetter:<br/>
Updated parameter names for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/396\">#396</a>.
</li>
<li>
December 12, 2014, by Michael Wetter:<br/>
Added <code>defaultComponentPrefixes</code> and
<code>defaultComponentName</code> annotations.
</li>
<li>April 22, 2014
    by Filip Jorissen:<br/>
       Initial version
</li>
</ul>
</html>"));
end VeroLine80slash115dash2comma2slash2;
