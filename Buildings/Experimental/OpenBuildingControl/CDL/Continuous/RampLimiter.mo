within Buildings.Experimental.OpenBuildingControl.CDL.Continuous;
block RampLimiter "Limit the increase or decrease rate of input"

  parameter Real increase "Increase amount of the input";
  parameter Real decrease "Decrease amount of the input";

  parameter Modelica.SIunits.Time  incDelTim(min=100*Constants.eps) = 1.0
    "Amount of time between increases of input";
  parameter Modelica.SIunits.Time  decDelTim(min=100*Constants.eps) = 1.0
    "Amount of time between decreases of input";

  parameter Modelica.SIunits.Time Td(min=Constants.eps) = 0.001
    "Derivative time constant";

  parameter Boolean limitsOn = true
    "= false, if limits are off.";

  Interfaces.RealInput u "Connector of Real input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));

  Interfaces.RealOutput y "Connector of Real output signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

protected
  Real rising = increase/incDelTim "Increase rate limit";
  Real falling = -decrease/decDelTim "Decrease rate limit";
  Real val = (u-y)/Td;

initial equation
    y = u;

equation
  if limitsOn then
    der(y) = if val<falling then falling else if val>rising then rising else val;
  else
    y = u;
  end if;
   annotation (
Documentation(info="<html>
<p>
The block limits the increase/decrease rate of its input signal in the range of <code>[falling, rising]</code>, where:
</p>
<pre>
    falling = -decrease/decDelTim; rising = increase/incDelTim;
</pre>
    
<p>
To ensure this for arbitrary inputs and in order to produce a differential output, the input is numerically differentiated
with derivative time constant <code>Td</code>. Smaller time constant <code>Td</code> means nearer ideal derivative.
</p>

</html>", revisions="<html>
<ul>
<li>
March 29, 2017, by Jianjun Hu:<br/>
First implementation, based on the implementation of the
Modelica Standard Library.
</li>
</ul>
</html>"), Icon(coordinateSystem(
    preserveAspectRatio=true,
    extent={{-100,-100},{100,100}}), graphics={
        Text(
          lineColor={0,0,255},
          extent={{-150,110},{150,150}},
          textString="%name"),
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
    Line(points={{0,-90},{0,68}}, color={192,192,192}),
    Polygon(
      points={{0,90},{-8,68},{8,68},{0,90}},
      lineColor={192,192,192},
      fillColor={192,192,192},
      fillPattern=FillPattern.Solid),
    Line(points={{-90,0},{68,0}}, color={192,192,192}),
    Polygon(
      points={{90,0},{68,-8},{68,8},{90,0}},
      lineColor={192,192,192},
      fillColor={192,192,192},
      fillPattern=FillPattern.Solid),
    Text(
      extent={{-150,150},{150,110}},
      textString="%name",
      lineColor={0,0,255}),
    Line(
      points={{-50,-70},{50,70}})}),
    Diagram(coordinateSystem(
    preserveAspectRatio=true,
    extent={{-100,-100},{100,100}})));
end RampLimiter;
