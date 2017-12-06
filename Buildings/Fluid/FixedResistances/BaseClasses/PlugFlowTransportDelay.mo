within Buildings.Fluid.FixedResistances.BaseClasses;
model PlugFlowTransportDelay "Delay time for given normalized velocity"

  parameter Modelica.SIunits.Length length "Pipe length";
  parameter Modelica.SIunits.Length dh
    "Hydraulic diameter (assuming a round cross section area)";
  parameter Modelica.SIunits.Density rho "Standard density of fluid";
  parameter Boolean initDelay=false
    "Initialize delay for a constant m_flow_start if true, otherwise start from 0"
    annotation (Dialog(group="Initialization"));
  parameter Modelica.SIunits.MassFlowRate m_flow_start=0
    "Initialization of mass flow rate to calculate initial time delay"
    annotation (Dialog(group="Initialization", enable=initDelay));

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal(min=0)
    "Nominal mass flow rate" annotation (Dialog(group="Nominal condition"));

  final parameter Modelica.SIunits.Time t_in_start=
    if initDelay and (abs(m_flow_start) > 1E-10*m_flow_nominal)
      then min(length/m_flow_start*(rho*dh^2/4*Modelica.Constants.pi), 0) else 0
    "Initial value of input time at inlet";
  final parameter Modelica.SIunits.Time t_out_start=
    if initDelay and (abs(m_flow_start) > 1E-10*m_flow_nominal)
     then min(-length/m_flow_start*(rho*dh^2/4*Modelica.Constants.pi), 0) else 0
    "Initial value of input time at outlet";

  Modelica.SIunits.Time time_out_rev "Reverse flow direction output time";
  Modelica.SIunits.Time time_out_des "Design flow direction output time";

  Real x(start=0) "Spatial coordinate for spatialDistribution operator";
  Modelica.SIunits.Frequency u "Normalized fluid velocity (1/s)";

  Modelica.Blocks.Interfaces.RealInput m_flow "Mass flow of fluid" annotation (
      Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));

  Modelica.Blocks.Interfaces.RealOutput tau
    "Time delay for design flow direction"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}})));
  Modelica.Blocks.Interfaces.RealOutput tauRev "Time delay for reverse flow"
    annotation (Placement(transformation(extent={{100,30},{120,50}})));

initial equation
  x = 0;
equation
  u = m_flow/(rho*(dh^2)/4*Modelica.Constants.pi)/length;

  der(x) = u;
  (time_out_rev, time_out_des) = spatialDistribution(
    time,
    time,
    x,
    u >= 0,
    {0.0,1.0},
    {time + t_in_start,time + t_out_start});

  tau = time - time_out_des;
  tauRev = time - time_out_rev;

  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-92,0},{-80.7,34.2},{-73.5,53.1},{-67.1,66.4},{-61.4,74.6},{-55.8,
              79.1},{-50.2,79.8},{-44.6,76.6},{-38.9,69.7},{-33.3,59.4},{-26.9,44.1},
              {-18.83,21.2},{-1.9,-30.8},{5.3,-50.2},{11.7,-64.2},{17.3,-73.1},{
              23,-78.4},{28.6,-80},{34.2,-77.6},{39.9,-71.5},{45.5,-61.9},{51.9,
              -47.2},{60,-24.8},{68,0}},
          color={0,0,127},
          smooth=Smooth.Bezier),
        Line(points={{-64,0},{-52.7,34.2},{-45.5,53.1},{-39.1,66.4},{-33.4,74.6},
              {-27.8,79.1},{-22.2,79.8},{-16.6,76.6},{-10.9,69.7},{-5.3,59.4},{1.1,
              44.1},{9.17,21.2},{26.1,-30.8},{33.3,-50.2},{39.7,-64.2},{45.3,-73.1},
              {51,-78.4},{56.6,-80},{62.2,-77.6},{67.9,-71.5},{73.5,-61.9},{79.9,
              -47.2},{88,-24.8},{96,0}}, smooth=Smooth.Bezier),
        Text(
          extent={{20,100},{82,30}},
          lineColor={0,0,255},
          textString="PDE"),
        Text(
          extent={{-82,-30},{-20,-100}},
          lineColor={0,0,255},
          textString="tau"),
        Text(
          extent={{-100,140},{100,100}},
          lineColor={0,0,255},
          textString="%name")}),
    Documentation(info="<html>
<p>
Calculates time delay at both sides of the pipe as the difference between the
current simulation time and the inlet time of the fluid at both ends of the pipe.
</p>
<h4>Main equation</h4>
<p align=\"center\">
<i>&part;z(x,t)/&part;t + v(t) &part;z(x,t)/&part;x = 0,</i>
</p>
<p>
where <i>z(x,t)</i> is the spatial distribution as a function of time of any
property <i>z</i> of the fluid. For the inlet time propagation, <i>z</i> will
be replaced by the inlet time of the fluid <i>t<sub>in</sub></i>.
</p>
<h4>Implementation</h4>
<p>
The inlet time is approached as a fluid property and its propagation follows
the one-dimensional wave equation, implemented using the spatialDistribution
function. This components requires the mass flow through the pipe and the pipe
dimensions in order to derive information about the fluid propagation.
</p>
<p>
The component calculates the delay time at both in/outlet ports of the pipe
and therefore has two outlets. During forward flow, only the forward
<a href=\"modelica://Buildings.Fluid.PlugFlowPipes.BaseClasses.HeatLossPipeDelay\">
Buildings.Fluid.PlugFlowPipes.BaseClasses.HeatLossPipeDelay</a> component in
<a href=\"modelica://Buildings.Fluid.PlugFlowPipes.BaseClasses.PipeCore\">
Buildings.Fluid.PlugFlowPipes.BaseClasses.PipeCore</a>
will be active and uses the forward output of PlugFlowTransportDelay.
During reverse, the opposite is true and only the reverse output is used.
</p>
<h4>Assumption</h4>
<p>It is assumed that no axial mixing takes place in the pipe. </p>
</html>", revisions="<html>
<ul>
<li>
September 9, 2016 by Bram van der Heijde:<br/>
Rename from PDETime_massFlowMod to PlugFlowTransportDelayMod</li>
<li>
December 2015 by Carles Ribas Tugores:<br/>
Modification in delay calculation to fix issues.</li>
<li>
November 6, 2015 by Bram van der Heijde:<br/>
Adapted flow parameter to mass flow rate instead of velocity.
This change should also fix the reverse and zero flow issues.</li>
<li>
October 13, 2015 by Marcus Fuchs:<br/>
Use <code>abs()</code> of normalized velocity input in order to avoid negative
delay times. </li>
<li>
July 2015 by Arnout Aertgeerts:<br/>
First implementation.
</li>
</ul>
</html>"));
end PlugFlowTransportDelay;
