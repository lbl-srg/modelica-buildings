within Buildings.Fluid.FixedResistances;
model Pipe "Pipe with finite volume discretization along flow path"
  extends Buildings.Fluid.FixedResistances.BaseClasses.Pipe(
   diameter=sqrt(4*m_flow_nominal/rho_default/v_nominal/Modelica.Constants.pi),
   dp_nominal=2*dpStraightPipe_nominal,
   preDro(dp(nominal=length*10)));
  // Because dp_nominal is a non-literal value, we set
  // dp.nominal=100 instead of the default dp.nominal=dp_nominal,
  // because the latter is ignored by Dymola 2012 FD 01.

  parameter Modelica.SIunits.Velocity v_nominal = 0.15
    "Velocity at m_flow_nominal (used to compute default diameter)";
  parameter Modelica.SIunits.Length roughness(min=0) = 2.5e-5
    "Absolute roughness of pipe, with a default for a smooth steel pipe (dummy if use_roughness = false)";
  final parameter Modelica.SIunits.PressureDifference dpStraightPipe_nominal(displayUnit="Pa")=
      Modelica.Fluid.Pipes.BaseClasses.WallFriction.Detailed.pressureLoss_m_flow(
      m_flow=m_flow_nominal,
      rho_a=rho_default,
      rho_b=rho_default,
      mu_a=mu_default,
      mu_b=mu_default,
      length=length,
      diameter=diameter,
      roughness=roughness,
      m_flow_small=m_flow_small)
    "Pressure loss of a straight pipe at m_flow_nominal";

  parameter Boolean useMultipleHeatPorts=false
    "= true to use one heat port for each segment of the pipe, false to use a single heat port for the entire pipe";

  Modelica.Thermal.HeatTransfer.Components.ThermalConductor conPipWal[nSeg](
      each G=2*Modelica.Constants.pi*lambdaIns*length/nSeg/Modelica.Math.log((
        diameter/2.0 + thicknessIns)/(diameter/2.0)))
    "Thermal conductance through pipe wall"
    annotation (Placement(transformation(extent={{-28,-38},{-8,-18}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector colAllToOne(m=nSeg) if
       not useMultipleHeatPorts
    "Connector to assign multiple heat ports to one heat port" annotation (
      Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=180,
        origin={-50,10})));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort if not
    useMultipleHeatPorts
    "Single heat port that connects to outside of pipe wall (default, enabled when useMultipleHeatPorts=false)"
    annotation (Placement(transformation(extent={{-10,40},{10,20}}),
        iconTransformation(extent={{-10,60},{10,40}})));
  Modelica.Fluid.Interfaces.HeatPorts_a heatPorts[nSeg] if
       useMultipleHeatPorts
    "Multiple heat ports that connect to outside of pipe wall (enabled if useMultipleHeatPorts=true)"
    annotation (Placement(transformation(extent={{-10,-70},{11,-50}}),
        iconTransformation(extent={{-30,-60},{30,-40}})));
equation
  connect(conPipWal.port_b, vol.heatPort) annotation (Line(
      points={{-8,-28},{-1,-28}},
      color={191,0,0},
      smooth=Smooth.None));
  if useMultipleHeatPorts then
    connect(heatPorts, conPipWal.port_a) annotation (Line(
        points={{0.5,-60},{-50,-60},{-50,-28},{-28,-28}},
        color={191,0,0},
        smooth=Smooth.None));
  else
    connect(colAllToOne.port_a, conPipWal.port_a) annotation (Line(
        points={{-50,4},{-50,-28},{-28,-28}},
        color={191,0,0},
        smooth=Smooth.None));
    connect(colAllToOne.port_b, heatPort) annotation (Line(
        points={{-50,16},{-50,30},{5.55112e-16,30}},
        color={191,0,0},
        smooth=Smooth.None));

  end if;
  annotation (
    defaultComponentName="pip",
    Documentation(info="<html>
<p>
Model of a pipe with flow resistance and optional heat exchange with environment.
</p>
<h4>Heat loss calculation</h4>
<p>
There are two possible configurations:
</p>
<ol>
<li>
If <code>useMultipleHeatPorts=false</code> (default option), the pipe uses a single heat port
for the heat exchange with the environment. Note that if the heat port
is unconnected, then all volumes are still connected through the heat conduction elements
<code>conPipWal</code>.
Therefore, they exchange a small amount of heat, which is not physical.
To avoid this, set <code>useMultipleHeatPorts=true</code>.
</li>
<li>
If <code>useMultipleHeatPorts=true</code>,
then one heat port for each segment of the pipe is
used for the heat exchange with the environment.
If the heat port is unconnected, then the pipe has no heat loss.
</li>
</ol>
<h4>Pressure drop calculation</h4>
<p>
The default value for the parameter <code>diameter</code> is computed such that the flow velocity
is equal to <code>v_nominal=0.15</code> for a mass flow rate of <code>m_flow_nominal</code>.
Both parameters, <code>diameter</code> and <code>v_nominal</code>, can be overwritten
by the user.
The default value for <code>dp_nominal</code> is two times the pressure drop that the pipe
would have if it were straight with no fittings.
The factor of two that takes into account the pressure loss of fittings can be overwritten.
These fittings could also be explicitly modeled outside of this component using models from
the package
<a href=\"modelica://Modelica.Fluid.Fittings\">
Modelica.Fluid.Fittings</a>.
For mass flow rates other than <code>m_flow_nominal</code>, the model
<a href=\"modelica://Buildings.Fluid.FixedResistances.PressureDrop\">
Buildings.Fluid.FixedResistances.PressureDrop</a> is used to
compute the pressure drop.
</p>
<p>
For a steady-state model of a flow resistance, use
<a href=\"modelica://Buildings.Fluid.FixedResistances.PressureDrop\">
Buildings.Fluid.FixedResistances.PressureDrop</a> instead of this model.
</p>
</html>", revisions="<html>
<ul>
<li>
January 22, 2016, by Michael Wetter:<br/>
Corrected type declaration of pressure difference.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/404\">#404</a>.
</li>
<li>
October 30, 2015, by Michael Wetter:<br/>
Improved documentation for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/455\">#455</a>.
</li>
<li>
February 5, 2015, by Michael Wetter:<br/>
Renamed <code>res</code> to <code>preDro</code> for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/292\">#292</a>.
</li>
<li>
September 13, 2013 by Michael Wetter:<br/>
Replaced <code>nominal</code> with <code>default</code> values
as they are computed using the default Medium values.
</li>
<li>
February 22, 2012 by Michael Wetter:<br/>
Renamed <code>useMultipleHeatPort</code> to <code>useMultipleHeatPorts</code> and
used heat port connector from <code>Modelica.Fluid</code> package for vector of heat ports.
</li>
<li>
February 15, 2012 by Michael Wetter:<br/>
Revised implementation and added default values.
</li>
<li>
February 12, 2012 by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"));
end Pipe;
