within Buildings.Fluid.HeatExchangers.BaseClasses;
model HexElementSensible
  "Element of a heat exchanger with humidity condensation of fluid 2"
  extends Buildings.Fluid.HeatExchangers.BaseClasses.PartialHexElement(
    redeclare final Buildings.Fluid.MixingVolumes.MixingVolume vol2(
        final energyDynamics=energyDynamics2,
        final massDynamics=energyDynamics2));

  annotation (
    Documentation(info="<html>
<p>
Element of a heat exchanger with humidity condensation and
with dynamics of the fluids and the solid. 
</p>
<p>
See 
<a href=\"modelica://Buildings.Fluid.HeatExchangers.BaseClasses.PartialHexElement\">
Buildings.Fluid.HeatExchangers.BaseClasses.PartialHexElement</a>
for a description of the physics.
</p>
</html>",
revisions="<html>
<ul>
<li>
September 11, 2013, by Michael Wetter:<br/>
Separated old model into one for dry and for wet heat exchangers.
This was done to make the coil compatible with OpenModelica.
</li>
<li>
May 1, 2013, by Michael Wetter:<br/>
Changed the redeclaration of <code>vol2</code> to be replaceable,
as <code>vol2</code> is replaced in some models.
</li>
<li>
April 19, 2013, by Michael Wetter:<br/>
Made instance <code>MassExchange</code> replaceable, rather than
conditionally removing the model, to avoid a warning
during translation because of unused connector variables.
</li>
<li>
July 11, 2011, by Michael Wetter:<br/>
Removed assignment of medium in <code>vol1</code> and <code>vol2</code>,
since this assignment is already done in the base class using the
<code>final</code> modifier.
</li>
<li>
August 12, 2008, by Michael Wetter:<br/>
Introduced option to compute each medium using a steady state model or
a dynamic model.
</li>
<li>
March 25, 2008, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"), Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}),
                   graphics),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics));
end HexElementSensible;
