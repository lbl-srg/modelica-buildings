within Buildings.Fluid.Chillers.Data.AbsorptionIndirect;
record AbsorptionIndirectSteam
  "Generic data record for absorption indirect chiller and heat source is steam"
  extends Buildings.Fluid.Chillers.Data.BaseClasses.PartialGeneric(
      final hotWater= false,
      final mGen_flow_nominal=0,
      final dpGen_nominal=0,
      final capFunGen={1,0,0});
  annotation (
    defaultComponentName="datChi",
    defaultComponentPrefixes="parameter",
    Documentation(info=
                 "<html>
<p>
This record is used as a template for performance data
for the absorption steam chiller model
<a href=\"Buildings.Fluid.Chillers.AbsorptionIndirectSteamRemovableRecords\">
Buildings.Fluid.Chillers.AbsorptionIndirectSteamRemovableRecords</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
January 6, 2020 by Hagar Elarga:<br/>
Modified the record to remove the un necessary parameter <code>mGen_flow_nominal</code> 
and the performance coefficients <code>capFunGen</code> in case of implementing the
steam as a generator heat source.
</li>
<li>
July 3, 2019 by Hagar Elarga:<br/>
First implementation.
</li>
</ul>
</html>"));
end AbsorptionIndirectSteam;
