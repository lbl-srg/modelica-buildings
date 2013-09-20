within Buildings.Fluid.Sensors;
model RelativeHumidityTwoPort "Ideal two port relative humidity sensor"
  extends Buildings.Fluid.Sensors.BaseClasses.PartialDynamicFlowSensor;
  extends Modelica.Icons.RotationalSensor;
  Modelica.Blocks.Interfaces.RealOutput phi(unit="1",
                                            min=0,
                                            start=phi_start)
    "Relative humidity of the passing fluid"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
          rotation=90,
        origin={1,110})));
  parameter Real phi_start(unit="1", min=0, max=1)=0.5
    "Initial or guess value of output (= state)"
    annotation (Dialog(group="Initialization"));

protected
  Real phiMed(unit="1", min=0, start=phi_start)
    "Relative humidity to which the sensor is exposed to";
  Medium.BaseProperties med_a_inflow
    "Medium state of inflowing fluid at port a";
  Medium.BaseProperties med_b_inflow
    "Medium state of inflowing fluid at port b";
initial equation
  if dynamic then
    if initType == Modelica.Blocks.Types.Init.SteadyState then
      der(phi) = 0;
    elseif initType == Modelica.Blocks.Types.Init.InitialState or
           initType == Modelica.Blocks.Types.Init.InitialOutput then
      phi = phi_start;
    end if;
  end if;
equation
  med_a_inflow.p  = port_a.p;
  med_a_inflow.h  = port_b.h_outflow;
  med_a_inflow.Xi = port_b.Xi_outflow;
  med_b_inflow.p  = port_b.p;
  med_b_inflow.h  = port_a.h_outflow;
  med_b_inflow.Xi = port_a.Xi_outflow;
  if allowFlowReversal then
    phiMed = Modelica.Fluid.Utilities.regStep(
               x=port_a.m_flow,
               y1=med_a_inflow.phi,
               y2=med_b_inflow.phi,
               x_small=m_flow_small);
  else
    phiMed = med_a_inflow.phi;
  end if;
  // Output signal of sensor
  if dynamic then
    der(phi) = (phiMed-phi)*k/tau;
  else
    phi = phiMed;
  end if;
annotation (defaultComponentName="senRelHum",
  Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{
            100,100}},
        grid={1,1}),    graphics),
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}},
        grid={1,1}), graphics={
        Text(
          extent={{102,124},{6,95}},
          lineColor={0,0,0},
          textString="phi"),
        Line(points={{0,100},{0,70}}, color={0,0,127}),
        Line(points={{-100,0},{-70,0}}, color={0,128,255}),
        Line(points={{70,0},{100,0}}, color={0,128,255})}),
  Documentation(info="<html>
<p>
This model outputs the relative humidity of the fluid flowing from 
<code>port_a</code> to <code>port_b</code>. 
The sensor is ideal, i.e., it does not influence the fluid.
</p>
<p>
Note that this sensor can only be used with media that contain the variable <code>phi</code>,
which is typically the case for moist air models.
</p>
<p>
If the parameter <code>tau</code> is non-zero, then its output
is computed using a first order differential equation. 
Setting <code>tau=0</code> is <i>not</i> recommend. See
<a href=\"modelica://Buildings.Fluid.Sensors.UsersGuide\">
Buildings.Fluid.Sensors.UsersGuide</a> for an explanation.
</p>
</html>
", revisions="<html>
<ul>
<li>
June 3, 2011 by Michael Wetter:<br/>
Revised implementation to add dynamics in such a way that 
the time constant increases as the mass flow rate tends to zero.
This significantly improves the numerics.
</li>
<li>
Feb. 5, 2011 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end RelativeHumidityTwoPort;
