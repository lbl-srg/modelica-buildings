within Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.SingleSpeed;
record Generic "Generic data record for SingleSpeed DXCoils"
  extends Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.DXCoil(
      final nSta=1);
  annotation (
    defaultComponentName="datCoi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                 "<html>
<p>
This record is used as a template for performance data
for SingleSpeed DXCoils
<a href=\"Buildings.Fluid.HeatExchangers.DXCoils.AirSource.SingleSpeed\">
Buildings.Fluid.HeatExchangers.DXCoils.AirSource.SingleSpeed</a>.
</p>
</html>",
        revisions="<html>
<ul>
<li>
November 20, 2012 by Thierry S. Nouidui:<br/>
First implementation.
</li>
</ul>
</html>"));
end Generic;
