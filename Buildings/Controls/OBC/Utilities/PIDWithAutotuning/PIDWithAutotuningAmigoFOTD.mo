within Buildings.Controls.OBC.Utilities.PIDWithAutotuning;
block PIDWithAutotuningAmigoFOTD
  "A autotuning PID controller with an Amigo tuner and a first order time delayed system model"
  parameter Real setPoint(min=1E-6) = 0.8
    "Setpoint for the tuning process";
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
  parameter Real yHig(min=1E-6) = 1
    "Higher value for the output";
  parameter Real yLow(min=1E-6) = 0.5
    "Lower value for the output";
  parameter Real deaBan(min=1E-6) = 0.5
    "Deadband for holding the output value";
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
  Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.Controller relay(
    yHig=yHig,
    yLow=yLow,
    deaBan=deaBan)
    "A relay controller"
    annotation (Placement(transformation(extent={{22,20},{42,40}})));
  Buildings.Controls.OBC.Utilities.PIDWithInputGains pid(
     controllerType=controllerType) "A pid controller"
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
  Buildings.Controls.OBC.Utilities.PIDWithAutotuning.SystemIdentification.FirstOrderTimedelayed.ControlProcessModel
    controlProcessModel(
    yHig=yHig - setPoint,
    yLow=setPoint + yLow,
    deaBan=deaBan)
    "A block to approximate the control process"
    annotation (Placement(transformation(extent={{-20,40},{-40,60}})));
  Buildings.Controls.OBC.Utilities.PIDWithAutotuning.AutoTuner.Amigo.PI piParameters
    if not with_D "A block to calculates the parameters of a PI controller"
    annotation (Placement(transformation(extent={{-60,70},{-80,90}})));
  Buildings.Controls.OBC.Utilities.PIDWithAutotuning.AutoTuner.Amigo.PID pidParameters
    if with_D "A block to calculates the parameters of a PID controller"
    annotation (Placement(transformation(extent={{-60,40},{-80,60}})));
  Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.ResponseProcess responseProcess(yHig=yHig
         - setPoint, yLow=setPoint + yLow)
    "A block to process the response from the relay controller"
    annotation (Placement(transformation(extent={{20,40},{0,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.ModelTime modTim
    "Simulation time"
    annotation (Placement(transformation(extent={{80,60},{60,80}})));

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
  connect(responseProcess.triggerEnd, swi.u2) annotation (Line(points={{-1,42},{-1,
          10},{48,10},{48,0},{60,0}}, color={255,0,255}));
  connect(samk.trigger, swi.u2) annotation (Line(points={{-30,-8},{-30,10},{48,10},
          {48,0},{60,0}}, color={255,0,255}));
  connect(samTi.trigger, swi.u2) annotation (Line(points={{-70,-36},{-70,10},{48,
          10},{48,0},{60,0}}, color={255,0,255}));
  connect(samTd.trigger, swi.u2) annotation (Line(points={{-30,-58},{-30,-42},{-56,
          -42},{-56,10},{48,10},{48,0},{60,0}}, color={255,0,255}));
  connect(responseProcess.On, relay.On) annotation (Line(points={{22,44},{26,44},
          {26,52},{58,52},{58,22},{43,22}}, color={255,0,255}));
  connect(modTim.y, responseProcess.tim) annotation (Line(points={{58,70},{28,70},
          {28,56},{22,56}}, color={0,0,127}));
  connect(responseProcess.tau, controlProcessModel.tau) annotation (Line(
        points={{-1,50},{-12,50},{-12,42},{-18,42}}, color={0,0,127}));
  connect(controlProcessModel.tOff, responseProcess.tOff) annotation (Line(
        points={{-18,46},{-14,46},{-14,54},{-1,54}}, color={0,0,127}));
  connect(responseProcess.tOn, controlProcessModel.tOn) annotation (Line(points=
         {{-1,58},{-8,58},{-8,56},{-16,56},{-16,54},{-18,54}}, color={0,0,127}));
  connect(relay.yErr, controlProcessModel.u) annotation (Line(points={{43,30},{50,
          30},{50,72},{-10,72},{-10,58},{-18,58}}, color={0,0,127}));
  connect(pidParameters.kp, controlProcessModel.k)
    annotation (Line(points={{-58,56},{-41,56}}, color={0,0,127}));
  connect(pidParameters.T, controlProcessModel.T)
    annotation (Line(points={{-58,50},{-41,50}}, color={0,0,127}));
  connect(pidParameters.L, controlProcessModel.L) annotation (Line(points={{-58,
          44},{-44,44},{-44,42},{-41,42}}, color={0,0,127}));
  connect(pidParameters.k, samk.u) annotation (Line(points={{-81,56},{-94,56},{-94,
          -20},{-42,-20}}, color={0,0,127}));
  connect(pidParameters.Ti, samTi.u) annotation (Line(points={{-81,50},{-88,50},
          {-88,-48},{-82,-48}}, color={0,0,127}));
  connect(samTd.u, pidParameters.Td) annotation (Line(points={{-42,-70},{-48,-70},
          {-48,34},{-82,34},{-82,44},{-81,44}}, color={0,0,127}));
  connect(piParameters.kp, controlProcessModel.k) annotation (Line(points={{-58,
          86},{-50,86},{-50,56},{-41,56}}, color={0,0,127}));
  connect(piParameters.T, controlProcessModel.T) annotation (Line(points={{-58,80},
          {-52,80},{-52,50},{-41,50}}, color={0,0,127}));
  connect(piParameters.L, controlProcessModel.L) annotation (Line(points={{-58,74},
          {-54,74},{-54,44},{-44,44},{-44,42},{-41,42}}, color={0,0,127}));
  connect(piParameters.k, samk.u) annotation (Line(points={{-81,86},{-94,86},{-94,
          -20},{-42,-20}}, color={0,0,127}));
  connect(piParameters.Ti, samTi.u) annotation (Line(points={{-81,76},{-88,76},{
          -88,-48},{-82,-48}}, color={0,0,127}));
  connect(responseProcess.triggerEnd, controlProcessModel.triggerEnd)
    annotation (Line(points={{-1,42},{-8,42},{-8,32},{-36,32},{-36,38}}, color={
          255,0,255}));
  connect(responseProcess.triggerStart, controlProcessModel.triggerStart)
    annotation (Line(points={{-1,46},{-10,46},{-10,34},{-24,34},{-24,38}},
        color={255,0,255}));
  annotation (Documentation(info="<html>
<p>
This blocks implements a AMIGO PID tuning method and the control process is approximated with a first order delay process.
</p>
<p>
Noted that this block can only support a PI controller or a PID controller.
</p>
</html>", revisions="<html>
<ul>
<li>
June 1, 2022, by Sen Huang:<br/>
First implementation<br/>
</li>
</ul>
</html>"),
        defaultComponentName = "pIDWithAutotuningAmigoFOTD",
        Icon(graphics={
        Text(
          extent={{-158,144},{142,104}},
          textString="%name",
          textColor={0,0,255}),
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-6,-20},{66,-66}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          visible=(controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PI),
          extent={{-26,-22},{74,-62}},
          lineColor={0,0,0},
          textString="PI",
          fillPattern=FillPattern.Solid,
          fillColor={175,175,175}),
        Polygon(
          points={{-80,82},{-88,60},{-72,60},{-80,82}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-80,68},{-80,-100}},
          color={192,192,192}),
        Line(
          points={{-90,-80},{70,-80}},
          color={192,192,192}),
        Polygon(
          points={{74,-80},{52,-72},{52,-88},{74,-80}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-80,-80},{-80,-22}},
          color={0,0,0}),
        Line(
          points={{-80,-22},{6,56}},
          color={0,0,0}),
        Line(
          points={{6,56},{68,56}},
          color={0,0,0}),
        Rectangle(
          extent={{100,-100},{84,-100}},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0})}));
end PIDWithAutotuningAmigoFOTD;
