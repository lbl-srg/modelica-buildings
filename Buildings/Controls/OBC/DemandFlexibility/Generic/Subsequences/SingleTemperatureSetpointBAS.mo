within Buildings.Controls.OBC.DemandFlexibility.Generic.Subsequences;
block SingleTemperatureSetpointBAS "Single temperature setpoint in a BAS"

  parameter Real TRes(unit="K")=1
    "Temperature setpoint resolution";
  parameter Real T_start(unit="K",displayUnit="degC",quantity="ThermodynamicTemperature")=293.15
    "Starting temperature";
  parameter Real setChaDel(quantity="Time",unit="s",min=1E-3) = 10
    "Setpoint change delay";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uTSet(unit="K",displayUnit="degC",quantity="ThermodynamicTemperature") "Temperature setpoint input"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yTSet(unit="K",displayUnit="degC",quantity="ThermodynamicTemperature") "Temperature setpoint output"
    annotation (Placement(
      transformation(extent={{100,-20},{140,20}}), iconTransformation(extent={
        {100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Discrete.UnitDelay uniDel(samplePeriod=setChaDel, y_start=
        T_start)                                                                               "Small time delay"
    annotation (Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=0,
      origin={24,0})));
  Buildings.Controls.OBC.DemandFlexibility.Generic.Subsequences.TemperatureSetpointResolution
    thermostatSetpointResolution(TRes=TRes) "Thermostat setpoint resolution"
    annotation (Placement(transformation(extent={{-66,-10},{-46,10}})));

equation
  connect(uTSet, thermostatSetpointResolution.uTSet)
    annotation (Line(points={{-120,0},{-67.6,0}}, color={0,0,127}));
  connect(thermostatSetpointResolution.yTSet, uniDel.u)
    annotation (Line(points={{-44.4,0},{12,0}}, color={0,0,127}));
  connect(uniDel.y, yTSet)
    annotation (Line(points={{36,0},{120,0}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>This block is used to represent how a temperature setpoint in a typical 
Building Automation System (BAS) changes.</p>
<p>First, a temperature setpoint can only fall into specific resolution 
intervals. The parameter <code>TRes</code> specifies the temperature resolution 
interval, which can be <code>0.5K</code>, <code>1K</code>, etc. when using 
temperature in Kelvin or Celsius units, or <code>0.5556K</code>, <code>0.2778K</code>, etc. when using temperature in the Fehrenheit unit. 
While the input variable <code>uTSet</code> can take on any temperature value, 
the output variable <code>yTSet</code> needs to be equal to an integer multiple 
of <code>TRes</code> plus the base temperature of <code>273.15 + 20 K</code> 
that is the closest value to <code>uTSet</code>.</p>

<p>Second, when changing the temperature setpoint, the BAS likely has a small 
time delay before the actual temperature setpoint is successfully changed. 
This time delay is specified from the setpoint change delay parameter <code>setChaDel</code>, 
which can be around 10 seconds, for example. In this block, this is implemented 
such that with a change of value for the input variable <code>uTSet</code>, the output variable 
<code>yTSet</code> will be changed a delay of <code>setChaDel</code> later. This functionality also serves 
to prevent close-loop short-circuiting when performing a continuous Modelica simulation.</p>

</html>",
        revisions="<html>
<ul>
<li>
April 03, 2026, by Weiping Huang:<br/>
First implementation.
</li>

</ul>
</html>"));
end SingleTemperatureSetpointBAS;
