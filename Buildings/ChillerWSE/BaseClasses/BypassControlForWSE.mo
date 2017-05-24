within Buildings.ChillerWSE.BaseClasses;
model BypassControlForWSE "PID controlled used for WSE bypass"

  parameter Real GaiPi "Gain of the PID controller and negative for bypass control in WSE";
  parameter Real tIntPi "Integration time of the PID controller";

  Buildings.Controls.Continuous.LimPID conPID(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=GaiPi,
    Ti=tIntPi,
    reverseAction=true,
    initType=Modelica.Blocks.Types.InitPID.InitialState)
               annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealInput TSet
    "Connector of setpoint input signal" annotation (Placement(transformation(
          extent={{-124,-12},{-100,12}}),iconTransformation(extent={{-120,-8},{
            -100,12}})));
  Modelica.Blocks.Interfaces.RealInput T
    "Connector of measurement input signal" annotation (Placement(
        transformation(extent={{-14,-14},{14,14}},
        rotation=90,
        origin={0,-114}),                             iconTransformation(extent={{-10,-10},
            {10,10}},
        rotation=90,
        origin={0,-110})));
  Modelica.Blocks.Interfaces.RealOutput y "Connector of actuator output signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}}),
        iconTransformation(extent={{100,-10},{120,10}})));
equation
  connect(conPID.u_s,TSet)  annotation (Line(points={{-12,0},{-62,0},{-112,0}},
                      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(conPID.y, y) annotation (Line(points={{11,0},{60,0},{110,0}},
        color={0,0,127},
      pattern=LinePattern.Dash));
  connect(T, conPID.u_m) annotation (Line(
      points={{1.77636e-015,-114},{1.77636e-015,-64},{0,-64},{0,-12}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-142,114},{128,146}},
          lineColor={0,0,255},
          textString="%name")}), Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>A PI controller is used to generate control signals for bypass.</p>
</html>", revisions="<html>
<ul>
<li>Jul 30, 2016, by Yangyang Fu:<br/>
First Implementation.
</li>
</ul>
</html>"));
end BypassControlForWSE;
