within Buildings.Fluid.Sensors.BaseClasses;
partial model PartialDynamicFlowSensor
  "Partial component to model sensors that measure flow properties using a dynamic model"
  extends PartialFlowSensor;

  parameter Modelica.Units.SI.Time tau(min=0) = 1
    "Time constant at nominal flow rate (use tau=0 for steady-state sensor, but see user guide for potential problems)";
  parameter Modelica.Blocks.Types.Init initType = Modelica.Blocks.Types.Init.InitialState
    "Type of initialization (InitialState and InitialOutput are identical)"
  annotation(Evaluate=true, Dialog(group="Initialization"));
protected
  Real k(start=1)
    "Gain to take flow rate into account for sensor time constant";
  final parameter Boolean dynamic = tau > 1E-10 or tau < -1E-10
    "Flag, true if the sensor is a dynamic sensor"
    annotation(Evaluate=true);
  Real mNor_flow "Normalized mass flow rate";
  final parameter Real tauInv(final unit="s-1")= if dynamic then 1/tau else 0
    "Inverse of tau";
equation
  if dynamic then
    mNor_flow = port_a.m_flow/m_flow_nominal;
    k = Modelica.Fluid.Utilities.regStep(x=port_a.m_flow,
                                         y1= mNor_flow,
                                         y2=-mNor_flow,
                                         x_small=m_flow_small);
  else
    mNor_flow = 1;
    k = 1;
  end if;
  annotation (Icon(graphics={
        Line(visible=(tau <> 0),
        points={{52,60},{58,74},{66,86},{76,92},{88,96},{98,96}}, color={0,
              0,127})}), Documentation(info="<html>
<p>
Partial component to model a sensor that measures any intensive properties
of a flow, e.g., to get temperature or density in the flow
between fluid connectors.</p>
<p>
The sensor computes a gain that is zero at zero mass flow rate.
This avoids fast transients if the flow is close to zero, thereby
improving the numerical efficiency.
</p>
</html>", revisions="<html>
<ul>
<li>
August 9, 2016, by Michael Wetter:<br/>
Improved documentation for <code>tau</code>.
</li>
<li>
January 12, 2016, by Filip Jorissen:<br/>
Added optional parameter <code>tauInv</code>.
</li>
<li>
May 29, 2014, by Michael Wetter:<br/>
Removed undesirable annotation <code>Evaluate=true</code>.
</li>
<li>
March 29, 2013, by Michael Wetter:<br/>
Changed the parameter <code>initType</code> to
<code>Modelica.Blocks.Types.Init.InitialState</code>.
This allows a pedantic model check in Dymola 2014 of models that instanciate sensors
but do not set this parameter. It also ensures that different Modelica simulators solve
the same initialization problem.
</li>
<li>
July 7, 2011, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialDynamicFlowSensor;
