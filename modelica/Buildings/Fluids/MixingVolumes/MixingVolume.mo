within Buildings.Fluids.MixingVolumes;
model MixingVolume
  "Mixing volume with inlet and outlet ports (flow reversal is allowed)"
  extends Modelica.Fluid.Vessels.ClosedVolume(m(start=V*rho_nominal, fixed=false), use_portsData=false);

  annotation (Documentation(info="<html>
This mixing volume is identical to the one from <tt>Modelica.Fluid</tt>,
but it sets parameters in the parent class and declares protected
variables that are needed by its child classes.
</html>"), Diagram(graphics));
protected
   parameter Medium.ThermodynamicState sta0 = Medium.setState_pTX(T=T_start,
         p=p_start, X=X_start[1:Medium.nXi]);
   parameter Modelica.SIunits.Density rho_nominal=Medium.density(sta0)
    "Density, used to compute fluid mass";
end MixingVolume;
