within Buildings.Templates.Components.Boilers;
model HotWaterPolynomial "Hot water boiler with efficiency described by a polynomial"
  extends Buildings.Templates.Components.Interfaces.PartialBoilerHotWater(
    final typMod=Buildings.Templates.Components.Types.BoilerHotWaterModel.Polynomial,
    redeclare Buildings.Fluid.Boilers.BoilerPolynomial boi(
      final Q_flow_nominal = dat.cap_nominal,
      final m_flow_nominal=dat.mHeaWat_flow_nominal,
      final dp_nominal=dat.dpHeaWat_nominal,
      final fue=dat.fue));

  annotation (
  defaultComponentName="boi",
  Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This is a model for a hot water boiler where the efficiency is computed
based on a polynomial of the firing rate and optionally of the hot water
temperature.
This model is based on 
<a href=\"modelica://Buildings.Fluid.Boilers.BoilerPolynomial\">
Buildings.Fluid.Boilers.BoilerPolynomial</a>.
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
</html>", revisions="<html>
<ul>
<li>
April 28, 2023, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end HotWaterPolynomial;
