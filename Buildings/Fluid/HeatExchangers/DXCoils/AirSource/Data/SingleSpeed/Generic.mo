within Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.SingleSpeed;
record Generic "Generic data record for SingleSpeed DXCoils"
  extends Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.CoolingCoil(
      final nSta=1);
  annotation (
    defaultComponentName="datCoi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                 "<html>
<p>
This record is used as a template for performance data
for SingleSpeed DX cooling coils in
<a href=\"Buildings.Fluid.HeatExchangers.DXCoils.AirSource.SingleSpeed\">
Buildings.Fluid.HeatExchangers.DXCoils.AirSource.SingleSpeed</a>.
</p>
</html>",
        revisions="<html>
<ul>
<li>
April 4, 2023, by Xing Lu and Karthik Devaprasad:
Updated class name being extended from <code>Generic.DXCoil</code> to 
<a href=\"Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.CoolingCoil\">Generic.CoolingCoil</a>.<br/>
Updated information section.
</li>        
<li>
November 20, 2012 by Thierry S. Nouidui:<br/>
First implementation.
</li>
</ul>
</html>"));
end Generic;
