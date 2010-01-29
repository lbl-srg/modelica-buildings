within Buildings.Fluid.MixingVolumes;
model MixingVolume
  "Mixing volume with inlet and outlet ports (flow reversal is allowed)"
  //extends Modelica.Fluid.Vessels.ClosedVolume(m(start=V*rho_nominal, fixed=false), use_portsData=false);
  extends Buildings.Fluid.MixingVolumes.BaseClasses.ClosedVolume(m(start=V*rho_nominal, fixed=false), use_portsData=false);

  annotation (Documentation(info="<html>
This mixing volume is identical to the one from <tt>Modelica.Fluid</tt>,
but it sets parameters in the parent class and declares protected
variables that are needed by its child classes.
</html>", revisions="<html>
<ul>
<li>
October 12, 2009 by Michael Wetter:<br>
Changed base class to
<a href=\"Modelica://Buildings.Fluid.MixingVolumes.BaseClasses.ClosedVolume\">
Buildings.Fluid.MixingVolumes.BaseClasses.ClosedVolume</a>.
</li>
</ul>
</html>"), Diagram(graphics));
protected
   parameter Medium.ThermodynamicState sta0 = Medium.setState_pTX(T=T_start,
         p=p_start, X=X_start[1:Medium.nXi]);
   parameter Modelica.SIunits.Density rho_nominal=Medium.density(sta0)
    "Density, used to compute fluid mass";
end MixingVolume;
