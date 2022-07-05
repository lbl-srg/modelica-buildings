within Buildings.Fluid.ZoneEquipment.Data;
record customFCUFan "Fan data for the FCU validation model"
  extends Movers.Data.Generic(
    speed_rpm_nominal=2900,
    use_powerCharacteristic=true,
    power(V_flow={0,0.041936,0.083872,0.125808,0.167744,0.209681,0.251617,
          0.293553,0.335489,0.377425,0.419361}, P={0,3.314,4.313,5.403,6.775,
          8.619,11.125,14.484,18.886,24.521,31.581}),
    pressure(V_flow={0,0.041936,0.083872,0.125808,0.167744,0.209681,0.251617,
          0.293553,0.335489,0.377425,0.419361}, dp={75,67.5,60,52.5,45,37.5,30,
          22.5,15,7.5,0}),
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
