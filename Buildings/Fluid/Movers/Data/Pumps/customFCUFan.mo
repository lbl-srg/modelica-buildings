within Buildings.Fluid.Movers.Data.Pumps;
record customFCUFan "Fan data for the FCU validation model"
  extends Generic(
    speed_rpm_nominal=2900,
    use_powerCharacteristic=true,
    power(V_flow={0.0, 1.5}, P={70, 280}),
    pressure(V_flow={0.0, 1.5}, dp={400, 100}),
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
May 28, 2017, by Iago Cupeiro:
<br/>
Initial version
</li>
</ul>
</html>"));
end customFCUFan;
