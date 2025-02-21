within Buildings.Templates.Components.Boilers;
model HotWaterTable "Hot water boiler with efficiency described by a table"
  extends Buildings.Templates.Components.Interfaces.PartialBoilerHotWater(
    final typMod=Buildings.Templates.Components.Types.BoilerHotWaterModel.Table,
    redeclare Buildings.Fluid.Boilers.BoilerTable boi(final per=dat.per));

  annotation (
  defaultComponentName="boi",
  Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This is a model for a hot water boiler where the efficiency is computed
based on a lookup table indexed by the firing rate and the inlet temperature.
This model is based on 
<a href=\"modelica://Buildings.Fluid.Boilers.BoilerTable\">
Buildings.Fluid.Boilers.BoilerTable</a>.
The user may refer to the documentation of 
<a href=\"modelica://Buildings.Fluid.Boilers.UsersGuide\">
Buildings.Fluid.Boilers.UsersGuide</a>
for the modeling assumptions.
</p>
<h4>Control points</h4>
<p>
See the documentation of 
<a href=\"modelica://Buildings.Templates.Components.Interfaces.BoilerHotWater\">
Buildings.Templates.Components.Interfaces.BoilerHotWater</a>.
</p>
<h4>Model parameters</h4>
<p>
The design parameters and the efficiency table are specified with an instance of
<a href=\"modelica://Buildings.Templates.Components.Data.BoilerHotWater\">
Buildings.Templates.Components.Data.BoilerHotWater</a>.
The documentation of this record class provides further details on how to 
properly parameterize the model.
</p>
</html>", revisions="<html>
<ul>
<li>
April 28, 2023, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end HotWaterTable;
