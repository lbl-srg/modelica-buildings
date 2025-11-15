within Buildings.Controls.OBC.Utilities;
block PIDWithEnable
  "PID controller with enable signal"
  extends Modelica.Blocks.Icons.Block;
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerType=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller";

  parameter Real k(
    min=100*Buildings.Controls.OBC.CDL.Constants.eps)=1
    "Gain of controller"
    annotation (Dialog(group="Control gains"));
  parameter Real Ti(
    final quantity="Time",
    final unit="s",
    min=100*Buildings.Controls.OBC.CDL.Constants.eps)=0.5
    "Time constant of integrator block"
    annotation (
      Dialog(
        group="Control gains",
        enable=controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PI or
          controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real Td(
    final quantity="Time",
    final unit="s",
    min=100*Buildings.Controls.OBC.CDL.Constants.eps)=0.1
    "Time constant of derivative block"
    annotation (
      Dialog(
        group="Control gains",
        enable=controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PD or
          controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));


  parameter Real yMax=1
    "Upper limit of output"
    annotation (Dialog(group="Limits"));
  parameter Real yMin=0
    "Lower limit of output"
    annotation (Dialog(group="Limits"));
  parameter Real Ni(
    min=100*Buildings.Controls.OBC.CDL.Constants.eps)=0.9
    "Ni*Ti is time constant of anti-windup compensation"
    annotation (
      Dialog(
      tab="Advanced",
      group="Integrator anti-windup",
      enable=controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PI or controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real Nd(
    min=100*Buildings.Controls.OBC.CDL.Constants.eps)=10
    "The higher Nd, the more ideal the derivative block"
    annotation (
      Dialog(tab="Advanced",
      group="Derivative block",
      enable=controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PD or controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Real r(
    min=100 * Buildings.Controls.OBC.CDL.Constants.eps)=1
    "Typical range of control error, used for scaling the control error";
  parameter Boolean reverseActing=true
    "Set to true for reverse acting, or false for direct acting control action";
  parameter Real y_reset=yMin
    "Value to which the controller output is reset if the boolean trigger has a rising edge";
  parameter Real y_neutral=y_reset
    "Value to which the controller output is reset when the controller is disabled";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u_s
    "Setpoint input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u_m
    "Measurement input signal"
    annotation (Placement(transformation(origin={0,-120},extent={{20,-20},{-20,20}},
      rotation=270),
      iconTransformation(extent={{20,-20},{-20,20}},rotation=270,origin={0,-120})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y
    "Connector of actuator output signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uEna
    "Actuator output signal"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},rotation=90,
      origin={-60,-120}),
      iconTransformation(extent={{-20,-20},{20,20}},rotation=90,origin={-40,-120})));
  Buildings.Controls.OBC.CDL.Reals.PIDWithReset conPID(
    final k=k,
    final Ti=Ti,
    final Td=Td,
    final r=r,
    final Ni=Ni,
    final Nd=Nd,
    final controllerType=controllerType,
    final yMin=yMin,
    final yMax=yMax,
    final reverseActing=reverseActing,
    final y_reset=y_reset)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swiInp
    "Switch to select input signal"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swiOut
    "Switch to select output signal"
    annotation (Placement(transformation(extent={{72,-10},{92,10}})));
protected
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant valDis(
    final k=y_neutral)
    "Value when disabled"
    annotation (Placement(transformation(extent={{30,-50},{50,-30}})));
equation
  connect(conPID.u_s, swiInp.y)
    annotation (Line(points={{-12,0},{-18,0}}, color={0,0,127}));
  connect(uEna, swiInp.u2) annotation (Line(points={{-60,-120},{-60,-21.5625},{-60,
          0},{-42,0}}, color={255,0,255}));
  connect(u_s, swiInp.u1) annotation (Line(points={{-120,0},{-80,0},{-80,8},{-42,
          8}}, color={0,0,127}));
  connect(u_m, swiInp.u3) annotation (Line(points={{0,-120},{0,-80},{-50,-80},{-50,
          -8},{-42,-8}}, color={0,0,127}));
  connect(uEna, conPID.trigger)
    annotation (Line(points={{-60,-120},{-60,-20},{-6,-20},{-6,-12}},color={255,0,255}));
  connect(u_m, conPID.u_m)
    annotation (Line(points={{0,-120},{0,-12}},color={0,0,127}));
  connect(conPID.y, swiOut.u1)
    annotation (Line(points={{12,0},{40,0},{40,8},{70,8}}, color={0,0,127}));
  connect(swiOut.y, y)
    annotation (Line(points={{94,0},{120,0}}, color={0,0,127}));
  connect(uEna, swiOut.u2) annotation (Line(points={{-60,-120},{-60,-20},{60,-20},
          {60,0},{70,0}}, color={255,0,255}));
  connect(valDis.y, swiOut.u3) annotation (Line(points={{52,-40},{64,-40},{64,-8},
          {70,-8}}, color={0,0,127}));
  annotation (
    defaultComponentName="conPID",
    Icon(
      coordinateSystem(
        extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(
          extent={{-6,40},{66,-6}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          visible=(controllerType==Buildings.Controls.OBC.CDL.Types.SimpleController.P),
          extent={{-30,64},{70,24}},
          textColor={0,0,0},
          textString="P",
          fillPattern=FillPattern.Solid,
          fillColor={175,175,175}),
        Text(
          visible=(controllerType==Buildings.Controls.OBC.CDL.Types.SimpleController.PI),
          extent={{-30,64},{70,24}},
          textColor={0,0,0},
          textString="PI",
          fillPattern=FillPattern.Solid,
          fillColor={175,175,175}),
        Text(
          visible=(controllerType==Buildings.Controls.OBC.CDL.Types.SimpleController.PD),
          extent={{-30,64},{70,24}},
          textColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={175,175,175},
          textString="P D"),
        Text(
          visible=(controllerType==Buildings.Controls.OBC.CDL.Types.SimpleController.PID),
          extent={{-30,64},{70,24}},
          textColor={0,0,0},
          textString="PID",
          fillPattern=FillPattern.Solid,
          fillColor={175,175,175}),
        Polygon(
          points={{-80,74},{-88,52},{-72,52},{-80,74}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-80,70},{-80,-4}},
          color={192,192,192}),
        Line(
          points={{-90,4},{36,4}},
          color={192,192,192}),
        Polygon(
          points={{46,4},{24,12},{24,-4},{46,4}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          textColor={0,0,255}),
        Rectangle(
          extent=DynamicSelect({{100,-100},{84,-100}},{{100,-100},{84,-100+(y-yMin)/(yMax-yMin)*200}}),
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Polygon(
          points={{-80,-10},{-88,-32},{-72,-32},{-80,-10}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{46,-82},{24,-74},{24,-90},{46,-82}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-90,-82},{36,-82}},
          color={192,192,192}),
        Line(
          points={{-80,-18},{-80,-90}},
          color={192,192,192}),
        Line(
          points={{-80,-54},{36,-54}},
          color={0,140,72},
          thickness=0.5,
          visible=not uEna),
        Line(
          points={{-80,4},{-80,10},{-18,66},{26,66}},
          color={0,140,72},
          thickness=0.5,
          visible=uEna)}),
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
</html>", revisions="<html>
<ul>
<li>
November 15, 2025, by Michael Wetter:<br/>
Moved to <code>Buildings.Controls.OBC.Utilities.PIDWithEnable</code> as there were
identical implementations in <code>Buildings.DHC</code> and in <code>Buildings.Templates</code>.
</li>
<li>
March 29, 2024, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end PIDWithEnable;
