within Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses;
model DynamicStartStop
  "Calculates dynamic start and stop values based on time constant "
  extends Modelica.Blocks.Interfaces.BlockIcon;
  parameter Modelica.SIunits.Time tauOn( min=Modelica.Constants.eps)
    "Equipment on time constant"
    annotation(Evaluate=true,
    Dialog(enable = not steadyStateOpe));
  parameter Modelica.SIunits.Time tauOff "Equipment off time constant"
    annotation(Evaluate=true,
    Dialog(enable = not steadyStateOpe));
  parameter Boolean steadyStateOpe = false
    "Boolean parameter for dynamic and steady state operation"
    annotation(Evaluate=true);
  output Real x "Intermidiate value";
  output Real m "Variable to avoid addition/rejection of heat at off condition"; //=if mode > 0 then 1 else 0;
  output Real tau "Time constant"; //= if mode > 0 then 1 else 0;

  Modelica.Blocks.Interfaces.RealInput u(
    quantity="Power",
    unit="W") "Input"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}},
        rotation=0)));

  Modelica.Blocks.Interfaces.RealOutput y(
    quantity="Power",
    unit="W") "Output"
    annotation (Placement(transformation(extent={{100,-10},{120,10}},
        rotation=0)));

  Modelica.Blocks.Interfaces.IntegerInput mode "On input signal"
    annotation (Placement(transformation(extent={{-140,80},{-100,120}},rotation=0)));
equation
  if steadyStateOpe then
    y=u;
    m=1;
    x=y;
    tau=0;
  else
   if mode>0 then
     m=1;
     tau=tauOn;
   else
     m=0;
     tau=tauOff;
   end if;
   tau*der(x)=u-x;
   y=x*m;
  end if;
  annotation (defaultComponentName="dynStaSto", Diagram(graphics), Documentation(info="<html>
<p>
This block is used in heat pump models for consideration of dynamic response of heat pumps and cycling losses.
When heat pump is switched on it takes time to develop pressure across evaporator and condenser. 
During this process heat pump heats up (or cools down if it is in cooling mode) to steady state value.
This leads to heat flow reduction during the start up process. 
This block assumes heat is completely lost to environment when heat pump is turned off. 
Therefore as the heat pump turns off no heat is added or extracted. 
</p>
</html>",
revisions="<html>
<ul>
<li>
Jan 17, 2013 by Kaustubh Phalak:<br>
First implementation. 
</li>
</ul>
</html>"),Icon(graphics={
        Line(
          points={{-76,-30},{-72,-6},{-66,4},{-56,12},{-44,16},{-30,18},{-28,8},
              {-22,0},{-16,-8},{-4,-14},{8,-16}},
          color={255,0,0},
          smooth=Smooth.None),
        Line(
          points={{8,-16},{8,-16},{12,-4},{20,6},{34,14},{50,16},{50,16},{50,16},
              {50,16},{50,16},{50,16}},
          color={255,0,0},
          smooth=Smooth.None),
        Line(
          points={{-76,-30},{-76,60}},
          color={0,0,255},
          smooth=Smooth.None,
          arrow={Arrow.None,Arrow.Open}),
        Line(
          points={{-76,-30},{74,-30},{76,-30},{80,-30}},
          color={0,0,255},
          smooth=Smooth.None,
          arrow={Arrow.None,Arrow.Open}),
        Line(
          points={{-30,32},{-30,-44}},
          color={0,0,255},
          smooth=Smooth.None,
          pattern=LinePattern.Dash),
        Line(
          points={{8,32},{8,-44}},
          color={0,0,255},
          smooth=Smooth.None,
          pattern=LinePattern.Dash),
        Text(
          extent={{-70,-32},{-40,-48}},
          lineColor={0,0,255},
          pattern=LinePattern.Dash,
          textString="On"),
        Text(
          extent={{-26,-32},{4,-48}},
          lineColor={0,0,255},
          pattern=LinePattern.Dash,
          textString="Off"),
        Line(
          points={{-76,-30},{-72,-6},{-66,4},{-56,12},{-44,16},{-30,18},{-30,8},
              {-30,0},{-30,-8},{-30,-16},{-30,-30}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{8,-16},{8,-16},{12,-4},{20,6},{34,14},{50,16},{50,16},{50,16},
              {50,16},{50,16},{50,16}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{8,-16},{8,-30}},
          color={0,0,255},
          smooth=Smooth.None)}),
                          Diagram(graphics));
end DynamicStartStop;
