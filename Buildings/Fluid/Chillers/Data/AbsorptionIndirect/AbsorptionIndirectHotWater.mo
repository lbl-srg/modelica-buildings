within Buildings.Fluid.Chillers.Data.AbsorptionIndirect;
record AbsorptionIndirectHotWater
  "Generic data record for absorption indirect chiller and heat source is hot water"
  extends Buildings.Fluid.Chillers.Data.BaseClasses.PartialGeneric(
           final hotWater= true);
  annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                 "<html>
<p>
This record is used as a template for performance data
for the absorption indirect hot water chiller model
<a href=\"Buildings.Fluid.Chillers.AbsorptionIndirectHotWaterRemovableRecords\">
Buildings.Fluid.Chillers.AbsorptionIndirectHotWaterRemovableRecords</a>.
</p>
<p>
The parameter <code>mGen_flow_nominal</code> and the performance coeffcients 
<code>capFunGen</code> are valid only if the Boolean parameter<code>hotWater</code>
is true.
</p>
</html>",
revisions="<html>
<ul>
<li>
January 4, 2020 by Hagar Elarga:<br/>
First implementation.
</li>
</ul>
</html>"));
end AbsorptionIndirectHotWater;
