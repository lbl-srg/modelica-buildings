within Buildings.Fluids.MixingVolumes;
model MixingVolume
  "Mixing volume with inlet and outlet ports (flow reversal is allowed)"
  extends Modelica_Fluid.Vessels.ClosedVolume(m(start=V*rho0, fixed=false), use_portsData=false);

  annotation (Documentation(info="<html>
This mixing volume is identical to the one from <tt>Modelica_Fluid</tt>.
</html>"));
protected
   parameter Medium.ThermodynamicState sta0 = Medium.setState_pTX(T=T_start,
         p=p_start, X=X_start[1:Medium.nXi]);
   parameter Modelica.SIunits.Density rho0=Medium.density(sta0)
    "Density, used to compute fluid mass";
end MixingVolume;
