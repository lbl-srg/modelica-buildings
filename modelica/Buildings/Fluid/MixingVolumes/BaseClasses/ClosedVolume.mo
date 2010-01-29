within Buildings.Fluid.MixingVolumes.BaseClasses;
model ClosedVolume
  "Volume of fixed size, closed to the ambient, with inlet/outlet ports"
  import Modelica.Constants.pi;

  // Mass and energy balance, ports
  extends Buildings.Fluid.MixingVolumes.BaseClasses.PartialLumpedVessel(
    final fluidVolume = V,
    vesselArea = pi*(3/4*V)^(2/3),
    heatTransfer(surfaceAreas={4*pi*(3/4*V/pi)^(2/3)}));

  parameter Modelica.SIunits.Volume V "Volume";

equation
  Wb_flow = 0;
  for i in 1:nPorts loop
    vessel_ps_static[i] = medium.p;
  end for;

  annotation (defaultComponentName="volume",
    Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{100,
            100}}), graphics={Ellipse(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={170,213,255}), Text(
          extent={{-150,12},{150,-18}},
          lineColor={0,0,0},
          textString="V=%V")}),
  Documentation(info="<html>
<p>
Ideally mixed volume of constant size with two fluid ports and one medium model.
The flow properties are computed from the upstream quantities, pressures are equal in both nodes and the medium model if <code>use_portsData=false</code>.
Heat transfer through a thermal port is possible, it equals zero if the port remains unconnected.
A spherical shape is assumed for the heat transfer area, with V=4/3*pi*r^3, A=4*pi*r^2.
Ideal heat transfer is assumed per default; the thermal port temperature is equal to the medium temperature.
</p>
<p>
If <code>use_portsData=true</code>, the port pressures represent the pressures just after the outlet (or just before the inlet) in the attached pipe.
The hydraulic resistances <tt>portsData.zeta_in</tt> and <tt>portsData.zeta_out</tt> determine the dissipative pressure drop between volume and port depending on
the direction of mass flow. See <a href=\"Modelica://Modelica.Fluid.Vessels.BaseClasses.VesselPortsData\">VesselPortsData</a> and <i>[Idelchik, Handbook of Hydraulic Resistance, 2004]</i>.
</p>
<p>
<b>Note:</b> This model is identical to
<a href=\"Modelica://Modelica.Fluid.Vessels.ClosedVolume\">
Modelica.Fluid.Vessels.ClosedVolume</a>, except that is extends

<a href=\"Modelica://Buildings.Fluid.MixingVolumes.BaseClasses.PartialLumpedVessel\">
Buildings.Fluid.MixingVolumes.BaseClasses.PartialLumpedVessel</a> 
instead of
<a href=\"Modelica://Modelica.Fluid.Vessels.BaseClasses.PartialLumpedVessel\">
Modelica.Fluid.Vessels.BaseClasses.PartialLumpedVessel</a> to avoid an assert statement.
</p>
</html>", revisions="<html>
<ul>
<li><i>October 12, 2009</i> by Michael Wetter:<br>
Implemented first version in <code>Buildings</code> library,
based on <code>Modelica.Fluid 1.0</code>.
</li>
</ul>
</html>"),
  Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{100,
            100}}),
          graphics));
end ClosedVolume;
