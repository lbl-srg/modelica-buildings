within Buildings.Fluid.Delays;
model DelayFirstOrder
  "Delay element, approximated by a first order differential equation"
  extends Buildings.Fluid.MixingVolumes.MixingVolume(
    final V=V_nominal,
    final massDynamics=energyDynamics,
    final mSenFac=1);

  parameter Modelica.Units.SI.Time tau=60 "Time constant at nominal flow"
    annotation (Dialog(tab="Dynamics", group="Nominal condition"));

protected
  parameter Modelica.Units.SI.Volume V_nominal=m_flow_nominal*tau/rho_default
    "Volume of delay element";
  annotation (    Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{100,
            100}}), graphics={      Text(
          extent={{-70,-26},{70,-66}},
          textColor={255,255,255},
          textString="tau=%tau")}),
defaultComponentName="del",
    Documentation(info="<html>
<p>
This model approximates a transport delay using first order differential equations.
</p>
<p>
The model consists of a mixing volume with two ports. The size of the
mixing volume is such that at the nominal mass flow rate
<code>m_flow_nominal</code>,
the time constant of the volume is equal to the parameter <code>tau</code>.
</p>
<p>
The heat flux connector is optional and need not be connnected.
</p>
</html>",
revisions="<html>
<ul>
<li>
March 7, 2022, by Michael Wetter:<br/>
Set <code>final massDynamics=energyDynamics</code>.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1542\">#1542</a>.
</li>
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
