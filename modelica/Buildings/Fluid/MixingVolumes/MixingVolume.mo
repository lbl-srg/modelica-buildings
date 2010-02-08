within Buildings.Fluid.MixingVolumes;
model MixingVolume
  "Mixing volume with inlet and outlet ports (flow reversal is allowed)"
  extends Buildings.Fluid.MixingVolumes.BaseClasses.PartialLumpedVessel(
      m(start=V*rho_nominal, fixed=false),
      final fluidVolume = V,
      heatTransfer(surfaceAreas={4*pi*(3/4*V/pi)^(2/3)}));
    import Modelica.Constants.pi;
  annotation (Documentation(info="<html>
This model represents an instantaneously mixed volume. 
Potential and kinetic energy at the port are neglected.
The volume can be parameterized to allow heat exchange
through a <code>heatPort</code>.
</html>", revisions="<html>
<ul>
<li>
February 7, 2010 by Michael Wetter:<br>
Simplified model and its base classes by removing the port data
and the vessel area.
</li>
<li>
October 12, 2009 by Michael Wetter:<br>
Changed base class to
<a href=\"Modelica://Buildings.Fluid.MixingVolumes.BaseClasses.ClosedVolume\">
Buildings.Fluid.MixingVolumes.BaseClasses.ClosedVolume</a>.
</li>
</ul>
</html>"), Diagram(graphics));
  parameter Modelica.SIunits.Volume V "Volume";

protected
   parameter Medium.ThermodynamicState sta0 = Medium.setState_pTX(T=T_start,
         p=p_start, X=X_start[1:Medium.nXi]);
   parameter Modelica.SIunits.Density rho_nominal=Medium.density(sta0)
    "Density, used to compute fluid mass";
end MixingVolume;
