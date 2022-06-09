within Buildings.Controls.OBC.Utilities.PIDWithAutotuning.BaseClasses;
partial block PIDWithRelay
  "A PID controller that is coupled with a Relay controller for automatic parameter tuning"
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller";
  parameter Real k_start(
    min=100*Buildings.Controls.OBC.CDL.Constants.eps)=1
    "Start value of the gain of controller"
    annotation (Dialog(group="Control gains"));
  parameter Real Ti_start(
    final quantity="Time",
    final unit="s",
    min=100*Buildings.Controls.OBC.CDL.Constants.eps)=0.5
    "Start value of the time constant of integrator block"
    annotation (Dialog(group="Control gains",enable=controllerType == CDL.Types.SimpleController.PI or controllerType == CDL.Types.SimpleController.PID));
  parameter Real Td_start(
    final quantity="Time",
    final unit="s",
    min=100*Buildings.Controls.OBC.CDL.Constants.eps)=0.1
    "Start value of the time constant of derivative block"
    annotation (Dialog(group="Control gains",enable=controllerType == CDL.Types.SimpleController.PD or controllerType == CDL.Types.SimpleController.PID));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u_s
    "Connector for setpoint input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u_m
    "Connector for measurement input signal"
    annotation (Placement(transformation(origin={0,-120},extent={{20,-20},{-20,20}},rotation=270),iconTransformation(extent={{20,-20},{-20,20}},rotation=270,origin={0,-120})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput trigger
    "Resets the controller output when trigger becomes true"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},rotation=90,origin={-60,-120}), iconTransformation(extent={{-20,-20},{20,20}},rotation=90,origin={-60,-120})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y
    "Connector for actuator output signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.Control relay(
    yHig=1,
    yLow=0.1,
    deaBan=0.2)
    "A relay controller"
    annotation (Placement(transformation(extent={{22,20},{42,40}})));
  Buildings.Controls.OBC.Utilities.PIDWithInputGains pid(
     controllerType=controllerType)
    annotation (Placement(transformation(extent={{22,-40},{42,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi
    "Switch between a PID controller and a relay controller"
    annotation (Placement(transformation(extent={{62,10},{82,-10}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler samk(y_start=k_start)
    "Recording the control gain"
    annotation (Placement(transformation(extent={{-40,-10},{-20,-30}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler samTi(y_start=Ti_start) if with_I
    "Recording the integral time"
    annotation (Placement(transformation(extent={{-80,-38},{-60,-58}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler samTd(y_start=Td_start) if with_D
    "Recording the derivative time"
    annotation (Placement(transformation(extent={{-40,-60},{-20,-80}})));

protected
  final parameter Boolean with_I=controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PI or controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PID
    "Boolean flag to enable integral action"
    annotation (Evaluate=true,HideResult=true);
  final parameter Boolean with_D=controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PD or controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PID
    "Boolean flag to enable derivative action"
    annotation (Evaluate=true,HideResult=true);

equation
  connect(pid.u_s, u_s) annotation (Line(points={{20,-30},{8,-30},{8,0},{-120,0}},
        color={0,0,127}));
  connect(relay.u_s, u_s) annotation (Line(points={{20,30},{-80,30},{-80,0},{-120,
          0}}, color={0,0,127}));
  connect(pid.trigger, trigger) annotation (Line(points={{26,-42},{26,-92},{-60,
          -92},{-60,-120}}, color={255,0,255}));
  connect(swi.y, y) annotation (Line(points={{84,0},{96,0},{96,0},{120,0}},
                                                              color={0,0,127}));
  connect(samk.y,pid. k) annotation (Line(points={{-18,-20},{-16,-20},{-16,-22},
          {20,-22}}, color={0,0,127}));
  connect(pid.Ti, samTi.y) annotation (Line(points={{20,-26},{-14,-26},{-14,-48},
          {-58,-48}}, color={0,0,127}));
  connect(samTd.y,pid. Td) annotation (Line(points={{-18,-70},{14,-70},{14,-34},
          {20,-34}}, color={0,0,127}));
  connect(relay.u_m, u_m) annotation (Line(points={{32,18},{32,6},{46,6},{46,-80},
          {0,-80},{0,-120}}, color={0,0,127}));
  connect(pid.u_m, u_m) annotation (Line(points={{32,-42},{32,-80},{0,-80},{0,-120}},
        color={0,0,127}));
  connect(swi.u3, relay.y)
    annotation (Line(points={{60,8},{52,8},{52,36},{43,36}}, color={0,0,127}));
  connect(swi.u1, pid.y) annotation (Line(points={{60,-8},{54,-8},{54,-30},{44,
          -30}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-152,144},{148,104}},
          textString="%name",
          textColor={0,0,255})}),                                Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>
June 1, 2022, by Sen Huang:<br/>
First implementation<br/>
</li>
</ul>
</html>", info="<html>
<p>
This blocks is designed as a generic form for implementing automatic tuning methods for PID controllers, 
</p>
<p>
based on response from a relay controller.
</p>
</html>"));
end PIDWithRelay;
