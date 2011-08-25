within Buildings.Fluid.MixingVolumes.BaseClasses;
partial model PartialMixingVolumeWaterPort
  "Partial mixing volume that allows adding or subtracting water vapor"
  extends Buildings.Fluid.MixingVolumes.MixingVolume(
   steBal(
    sensibleOnly = false,
    final Q_flow = Q_flow + HWat_flow,
    final mXi_flow = mXi_flow),
   dynBal(
    final Q_flow = Q_flow + HWat_flow,
    final mXi_flow = mXi_flow));

 // additional declarations
  Modelica.Blocks.Interfaces.RealInput mWat_flow(final quantity="MassFlowRate",
                                                 final unit = "kg/s")
    "Water flow rate added into the medium"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}},rotation=
           0)));
  Modelica.Blocks.Interfaces.RealInput TWat(final quantity="Temperature",
                                            final unit = "K", displayUnit = "degC", min=260)
    "Temperature of liquid that is drained from or injected into volume"
    annotation (Placement(transformation(extent={{-140,28},{-100,68}},
          rotation=0)));
  Modelica.Blocks.Interfaces.RealOutput X_w "Species composition of medium"
    annotation (Placement(transformation(extent={{100,-60},{140,-20}}, rotation=
           0)));
  Medium.MassFlowRate mXi_flow[Medium.nXi]
    "Mass flow rates of independent substances added to the medium";
  Modelica.SIunits.HeatFlowRate HWat_flow
    "Enthalpy flow rate of extracted water";

  annotation (
    Documentation(info="<html>
Model for an ideally mixed fluid volume with <code>nP</code> ports and the ability 
to store mass and energy. The volume is fixed. 
<p>
This model represents the same physics as 
<a href=\"Modelica:Modelica.Fluid.Vessels.Volume\">
Modelica.Fluid.Vessels.Volume</a> but in addition,
it allows to connect signals for the water exchanged with the volume.
The model is partial in order to allow a submodel that can be used with media
that contain water as a substance, and a submodel that can be used with dry air.
Having separate models is required because calls to the medium property function
<code>enthalpyOfLiquid</code> results in a linker error if a medium such as 
<a href=\"Modelica:Modelica.Media.Air.SimpleAir\">Modelica.Media.Air.SimpleAir</a>
is used that does not implement this function.
</p>
</html>", revisions="<html>
<ul>
<li>
January 10, 2011 by Michael Wetter:<br>
Removed <code>ports_p_static</code> and used instead <code>medium.p</code> since
<code>ports_p_static</code> is not available in 
<a href=\"modelica://Buildings.Fluid.MixingVolumes.MixingVolume\">
Buildings.Fluid.MixingVolumes.MixingVolume</a> which is sometimes used to replace this model.
</li>
<li>
July 30, 2010 by Michael Wetter:<br>
Added nominal value for <code>mC</code> to avoid wrong trajectory 
when concentration is around 1E-7.
See also <a href=\"https://trac.modelica.org/Modelica/ticket/393\">
https://trac.modelica.org/Modelica/ticket/393</a>.
</li>
<li>
March 24, 2010 by Michael Wetter:<br>
Changed base class from <code>Modelica.Fluid</code> to <code>Buildings.Fluid</code>.
<li>
August 12, 2008 by Michael Wetter:<br>
Introduced option to compute model in steady state. This allows the heat exchanger model
to switch from a dynamic model for the medium to a steady state model.
</li>
<li>
August 13, 2008 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"), Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}),
                   graphics),
    Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{100,
            100}}), graphics={
        Text(
          extent={{-76,-6},{198,-48}},
          lineColor={255,255,255},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="X_w"),
        Text(
          extent={{-122,114},{-80,82}},
          lineColor={0,0,0},
          textString="mWat_flow"),
        Text(
          extent={{-152,74},{-42,50}},
          lineColor={0,0,0},
          textString="TWat"),
        Ellipse(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={170,213,255}),
        Text(
          extent={{-60,16},{56,-16}},
          lineColor={0,0,0},
          textString="V=%V")}));
end PartialMixingVolumeWaterPort;
