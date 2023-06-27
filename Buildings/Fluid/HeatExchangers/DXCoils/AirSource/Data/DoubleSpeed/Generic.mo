within Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.DoubleSpeed;
record Generic "Generic data record for DoubleSpeed DXCoils"
  extends Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.DXCoil(
      final nSta=2);
  annotation (
    defaultComponentName="datCoi",
    defaultComponentPrefixes="parameter",
    Documentation(info="<html>
<p>
This record is used as a template for performance data
for the air source DX coils
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.AirSource.MultiStage\">
Buildings.Fluid.HeatExchangers.DXCoils.AirSource.MultiStage</a> with double speed.
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
