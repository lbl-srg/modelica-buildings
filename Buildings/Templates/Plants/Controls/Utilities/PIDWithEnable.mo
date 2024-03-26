within Buildings.Templates.Plants.Controls.Utilities;
block PIDWithEnable
  "PID controller with enable signal"
  extends Modelica.Blocks.Icons.Block;
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerType=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller";
  parameter Real k(
    min=0)=1
    "Gain of controller";
  parameter Modelica.Units.SI.Time Ti(
    min=Buildings.Controls.OBC.CDL.Constants.small)=0.5
    "Time constant of integrator block"
    annotation (Dialog(enable=controllerType==Buildings.Controls.OBC.CDL.Types.SimpleController.PI
      or controllerType==Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Modelica.Units.SI.Time Td(
    min=0)=0.1
    "Time constant of derivative block"
    annotation (Dialog(enable=controllerType==Buildings.Controls.OBC.CDL.Types.SimpleController.PD
      or controllerType==Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real r(
    min=100 * Modelica.Constants.eps)=1
    "Typical range of control error, used for scaling the control error";
  parameter Real yMin=0
    "Lower limit of output";
  parameter Real yMax=1
    "Upper limit of output";
  parameter Boolean reverseActing=true
    "Set to true for reverse acting, or false for direct acting control action";
  parameter Real y_reset=yMin
    "Value to which the controller output is reset if the boolean trigger has a rising edge";
  parameter Real y_neutral=y_reset
    "Value to which the controller output is reset when the controller is disabled";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u_s
    "Connector of setpoint input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u_m
    "Connector of measurement input signal"
    annotation (Placement(transformation(origin={0,-120},extent={{20,-20},{-20,20}},
      rotation=270),
      iconTransformation(extent={{20,-20},{-20,20}},rotation=270,origin={0,-120})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y
    "Connector of actuator output signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uEna
    "Enable signal"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},rotation=90,
      origin={-60,-120}),
      iconTransformation(extent={{-20,-20},{20,20}},rotation=90,origin={-40,-120})));
  Buildings.Controls.OBC.CDL.Reals.PIDWithReset conPID(
    final k=k,
    final Ti=Ti,
    final Td=Td,
    final r=r,
    final controllerType=controllerType,
    final yMin=yMin,
    final yMax=yMax,
    final reverseActing=reverseActing,
    final y_reset=y_reset)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi1
    annotation (Placement(transformation(extent={{72,-10},{92,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant valDis(
    final k=y_neutral)
    "Value when disabled"
    annotation (Placement(transformation(extent={{30,-50},{50,-30}})));
equation
  connect(conPID.u_s, swi.y)
    annotation (Line(points={{-12,0},{-18,0}},color={0,0,127}));
  connect(uEna, swi.u2)
    annotation (Line(points={{-60,-120},{-60,-21.5625},{-60,0},{-42,0}},color={255,0,255}));
  connect(u_s, swi.u1)
    annotation (Line(points={{-120,0},{-80,0},{-80,8},{-42,8}},color={0,0,127}));
  connect(u_m, swi.u3)
    annotation (Line(points={{0,-120},{0,-80},{-50,-80},{-50,-8},{-42,-8}},color={0,0,127}));
  connect(uEna, conPID.trigger)
    annotation (Line(points={{-60,-120},{-60,-20},{-6,-20},{-6,-12}},color={255,0,255}));
  connect(u_m, conPID.u_m)
    annotation (Line(points={{0,-120},{0,-12}},color={0,0,127}));
  connect(conPID.y, swi1.u1)
    annotation (Line(points={{12,0},{40,0},{40,8},{70,8}},color={0,0,127}));
  connect(swi1.y, y)
    annotation (Line(points={{94,0},{120,0}},color={0,0,127}));
  connect(uEna, swi1.u2)
    annotation (Line(points={{-60,-120},{-60,-20},{60,-20},{60,0},{70,0}},color={255,0,255}));
  connect(valDis.y, swi1.u3)
    annotation (Line(points={{52,-40},{64,-40},{64,-8},{70,-8}},color={0,0,127}));
  annotation (
    defaultComponentName="conPID",
    defaultComponentName="conPID",
    Icon(
      coordinateSystem(
        extent={{-100,-100},{100,100}}),
      graphics={
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
          visible=(controllerType==Buildings.Controls.OBC.CDL.Types.SimpleController.P),
          extent={{-32,-22},{68,-62}},
          textColor={0,0,0},
          textString="P",
          fillPattern=FillPattern.Solid,
          fillColor={175,175,175}),
        Text(
          visible=(controllerType==Buildings.Controls.OBC.CDL.Types.SimpleController.PI),
          extent={{-26,-22},{74,-62}},
          textColor={0,0,0},
          textString="PI",
          fillPattern=FillPattern.Solid,
          fillColor={175,175,175}),
        Text(
          visible=(controllerType==Buildings.Controls.OBC.CDL.Types.SimpleController.PD),
          extent={{-16,-22},{88,-62}},
          textColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={175,175,175},
          textString="P D"),
        Text(
          visible=(controllerType==Buildings.Controls.OBC.CDL.Types.SimpleController.PID),
          extent={{-14,-22},{86,-62}},
          textColor={0,0,0},
          textString="PID",
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
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          textColor={0,0,255}),
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
          extent=DynamicSelect({{100,-100},{84,-100}},{{100,-100},{84,-100+(y-yMin)/(yMax-yMin)*200}}),
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0})}),
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false)),
    Documentation(
      info="<html>
<p>
This is an update of
<a href=\"modelica://Buildings.Controls.OBC.CDL.Reals.PIDWithReset\">
Buildings.Controls.OBC.CDL.Reals.PIDWithReset</a>
with an additional enable signal provided as a Boolean input.
</p>
<ul>
<li>
When enabled, the output of the controller is identical to
<a href=\"modelica://Buildings.Controls.OBC.CDL.Reals.PIDWithReset\">
Buildings.Controls.OBC.CDL.Reals.PIDWithReset</a>,
and the integral term is reset to <code>y_reset</code> at
enable time.
</li>
<li>
When disabled, the output of the controller is set to <code>y_neutral</code>
and the setpoint is overridden by the measurement signal in order to avoid
time integration of the control error.
</li>
</ul>
</html>"));
end PIDWithEnable;
