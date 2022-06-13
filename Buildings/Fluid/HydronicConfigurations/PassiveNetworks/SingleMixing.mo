within Buildings.Fluid.HydronicConfigurations.PassiveNetworks;
model SingleMixing "Single mixing circuit"
  extends Fluid.HydronicConfigurations.ActiveNetworks.SingleMixing(
    final m1_flow_nominal=m2_flow_nominal,
    final dpBal1_nominal=0,
    dpValve_nominal=3e3)
  annotation (IconMap(primitivesVisible = false));

  annotation (
    defaultComponentName="con",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={175,175,175},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
    Bitmap(
      extent={{-100,-100},{100,100}},
      fileName="modelica://Buildings/Resources/Images/Fluid/HydronicConfigurations/PassiveNetworks/SingleMixing.svg"),
        Text(
          extent={{-149,-114},{151,-154}},
          textColor={0,0,255},
          textString="%name")}),
    Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
Variable primary
</p>
    
<p>
This is a typical configuration for constant flow secondary circuits that
have a design supply temperature identical to the primary circuit.

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
