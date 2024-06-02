within Buildings.UsersGuide.ReleaseNotes;
class Version_0_3_0 "Version 0.3.0"
  extends Modelica.Icons.ReleaseNotes;
    annotation (preferredView="info", Documentation(info=
                 "<html>
<ul>
<li>
Added package <code>Buildings.Fluid.Sources</code>.
The package contains models for modeling species that
do not affect the medium balance of volumes. This can be used to track
for example carbon dioxide or other species that have a small concentration.
</li>
<li>
The package <code>Buildings.Fluid.Actuators.Motors</code> has been added.
The package contains a motor model for valves and dampers.
</li>
<li>
The package <code>Buildings.Media</code> has been reorganized and
the new medium model
<code>Buildings.Media.GasesPTDecoupled.MoistAir</code>
has been added.
<br/>
In addition, this package now contains a bug fix that is needed for Modelica 2.2.1 and 2.2.2.
The bugs are fixed by using a new
base class
<code>Buildings.Media.Interfaces.PartialSimpleIdealGasMedium</code>
 (that fixes the bugs) instead of
<code>Modelica.Media.Interfaces.PartialSimpleIdealGasMedium</code>.
In the original implementation, initial states of fluid volumes can be far away from
the steady-state value because of an inconsistent implementation of the enthalpy
and internal energy.
When the <code>Buildings</code> library is upgraded to
to Modelica 3.0.0, it should be safe to remove this bug fix.
</li>
<li>
The package <code>Buildings.Fluid.HeatExchangers</code>
has been revised and several models have been renamed.
The heat exchanger models have been revised to allow computing the fluid volumes either
dynamically, or in steady-state.
</li>
<li>
The damper with exponential opening characteristic has been revised to allow control signals
over the whole range between <code>0</code> and <code>1</code>. This was in earlier versions restricted.
In the same model, a bug was fixed that caused the flow to be largest for <code>y=0</code>, i.e., when the damper is closed.
</li>
<li>
Additional models for psychrometric equations have been added. The new models contain equations
that convert dew point temperature and water vapor pressure, as well
as water vapor concentration and water vapor pressure.
</li>
<li>
A new mixing volume has been added that allows latent heat exchange with the volume.
This model can be used to model a volume of moist air with water vapor condensation
inside the volume. The condensate is removed from the volume in its liquid phase.
</li>
</ul>
</html>"));
end Version_0_3_0;
