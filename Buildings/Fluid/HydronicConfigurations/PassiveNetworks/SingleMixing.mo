within Buildings.Fluid.HydronicConfigurations.PassiveNetworks;
model SingleMixing "Single mixing circuit"
  extends Fluid.HydronicConfigurations.ActiveNetworks.SingleMixing(
    final dpBal1_nominal=0)
  annotation (IconMap(primitivesVisible = false));

  annotation (
    defaultComponentName="con",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
    Bitmap(
      extent={{-100,-100},{100,100}},
      fileName="modelica://Buildings/Resources/Images/Fluid/HydronicConfigurations/PassiveNetworks/SingleMixing.svg")}),
    Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
Variable primary
</p>
    
<p>
This is a typical configuration for constant flow secondary circuits that
have a design supply temperature identical to the primary circuit.

The control valve authority is equal to 
<i>&beta; = &Delta;p<sub>A-AB</sub> / (&Delta;p<sub>a1-b1</sub>
+ &Delta;p<sub>B-AB</sub></i>).
The valve is typically sized so that the design pressure drop in 
the direct branch <i>&Delta;p<sub>A-AB</sub></i> is close 
to the primary pressure differential <i>&Delta;p<sub>a1-b1</sub></i>,
which yields an authority close to <i>0.5</i>.
(Note that the authority does not depend on the primary balancing 
valve.)
</p>
<p>
The balancing procedure should ensure that the 
primary pressure differential is compensated for by the primary balancing valve.
Otherwise, the flow may reverse in the bypass branch and the mixing function of
the three-way valve cannot be achieved.
Valve authority = Δp_V / (Δp1 + Δp_Vbyp) (independent of the balancing valve Δp). For good authority Δp_V~Δp1 which must be compensated for by the secondary pump. 
</p>
<h4>
Parameterization
</h4>
<p>
By default the secondary pump is parameterized with <code>m2_flow_nominal</code> 
and <code>dp2_nominal</code> at maximum speed.
The partner valve <code>bal2</code> is therefore configured with zero
pressure drop.
</p>
</html>"));
end SingleMixing;
