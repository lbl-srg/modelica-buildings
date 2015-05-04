within Buildings.Fluid.Delays;
model DelayFirstOrder
  "Delay element, approximated by a first order differential equation"
  extends Buildings.Fluid.MixingVolumes.MixingVolume(final V=V_nominal,
                                                   final mSenFac=1);

  parameter Modelica.SIunits.Time tau = 60 "Time constant at nominal flow"
    annotation (Dialog(tab="Dynamics", group="Nominal condition"));

protected
   parameter Modelica.SIunits.Volume V_nominal = m_flow_nominal*tau/rho_default
    "Volume of delay element";
  annotation (    Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{100,
            100}}), graphics={Ellipse(
          extent={{-100,98},{100,-102}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={170,213,255}), Text(
          extent={{-72,22},{68,-18}},
          lineColor={0,0,0},
          textString="tau=%tau")}),
defaultComponentName="del",
    Documentation(info="<html>
<p>
This model approximates a transport delay using a first order differential equations.
</p>
<p>
The model consists of a mixing volume with two ports. The size of the
mixing volume is such that at the nominal mass flow rate
<code>m_flow_nominal</code>,
the time constant of the volume is equal to the parameter <code>tau</code>.
</p>
<p>
The heat flux connector is optional, it need not be connnected.
</p>
</html>",
revisions="<html>
<ul>
<li>
September 14, 2013, by Michael Wetter:<br/>
Renamed <code>V0</code> to <code>V_nominal</code> to use consistent notation.
</li>
<li>
September 24, 2008, by Michael Wetter:<br/>
Changed base class from <code>Modelica.Fluid</code> to <code>Buildings</code> library.
This was done to track the auxiliary species flow <code>mC_flow</code>.
</li>
<li>
September 4, 2008, by Michael Wetter:<br/>
Fixed bug in assignment of parameter <code>sta0</code>.
The earlier implementation
required temperature to be a state, which is not always the case.
</li>
<li>
March 17, 2008, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end DelayFirstOrder;
