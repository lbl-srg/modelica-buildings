within Buildings.Obsolete.Controls.Continuous;
model PIDHysteresis
  "PID controller with anti-windup, output limiter and output hysteresis"
  extends Modelica.Blocks.Interfaces.SVcontrol;
  extends Buildings.Obsolete.BaseClasses.ObsoleteModel;

  parameter Real eOn = 1
    "if off and control error > eOn, switch to set point tracking"
    annotation (Dialog(group="Hysteresis"));
  parameter Real eOff = -eOn "if on and control error < eOff, set y=0"
    annotation (Dialog(group="Hysteresis"));
  parameter Boolean pre_y_start=false
    "Value of hysteresis output at initial time"
    annotation (Dialog(group="Hysteresis"));

  parameter Modelica.Blocks.Types.SimpleController controllerType=Modelica.Blocks.Types.SimpleController.PI
    "Type of controller"
    annotation (Dialog(group="Set point tracking"));
  parameter Real k=1 "Gain of controller"
    annotation (Dialog(group="Set point tracking"));
  parameter Modelica.Units.SI.Time Ti "Time constant of Integrator block"
    annotation (Dialog(group="Set point tracking"));
  parameter Modelica.Units.SI.Time Td "Time constant of Derivative block"
    annotation (Dialog(group="Set point tracking"));
  parameter Real yMax=1 "Upper limit of output"
    annotation (Dialog(group="Set point tracking"));
  parameter Real yMin=0 "Lower limit of output"
    annotation (Dialog(group="Set point tracking"));
  parameter Real wp=1 "Set-point weight for Proportional block (0..1)"
    annotation (Dialog(group="Set point tracking"));
  parameter Real wd=0 "Set-point weight for Derivative block (0..1)"
    annotation (Dialog(group="Set point tracking"));
  parameter Real Ni=0.9 "Ni*Ti is time constant of anti-windup compensation"
    annotation (Dialog(group="Set point tracking"));
  parameter Real Nd=10 "The higher Nd, the more ideal the derivative block"
    annotation (Dialog(group="Set point tracking"));
  parameter Boolean reverseActing = true
    "Set to true for reverse acting, or false for direct acting control action"
    annotation (Dialog(group="Set point tracking"));

  parameter Modelica.Blocks.Types.Init initType=Modelica.Blocks.Types.Init.InitialState
    "Type of initialization (1: no init, 2: steady state, 3: initial state, 4: initial output)"
    annotation (Dialog(group="Initialization"));
  parameter Real xi_start=0
    "Initial or guess value value for integrator output (= integrator state)"
    annotation (Dialog(group="Initialization"));
  parameter Real xd_start=0
    "Initial or guess value for state of derivative block"
    annotation (Dialog(group="Initialization"));
  parameter Real y_start=0 "Initial value of output"
    annotation (Dialog(group="Initialization"));

  parameter Boolean strict=true "= true, if strict limits with noEvent(..)"
    annotation (Evaluate=true, choices(checkBox=true), Dialog(tab="Advanced"));

  Buildings.Controls.Continuous.LimPID PID(
    final controllerType=controllerType,
    final k=k,
    final Ti=Ti,
    final yMax=yMax,
    final yMin=yMin,
    final wp=wp,
    final wd=wd,
    final Ni=Ni,
    final Nd=Nd,
    final initType=initType,
    final xi_start=xi_start,
    final xd_start=xd_start,
    final y_start=y_start,
    final Td=Td,
    final reverseActing=reverseActing,
    final strict=strict) "Controller for room temperature"
    annotation (Placement(transformation(extent={{-30,-2},{-10,18}})));
  Modelica.Blocks.Logical.Hysteresis hys(
    final pre_y_start=pre_y_start,
    final uLow=eOff,
    final uHigh=eOn) "Hysteresis element to switch controller on and off"
    annotation (Placement(transformation(extent={{-30,50},{-10,70}})));
  Modelica.Blocks.Math.Feedback feeBac
    annotation (Placement(transformation(extent={{-70,50},{-50,70}})));
protected
  Modelica.Blocks.Logical.Switch swi
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Modelica.Blocks.Sources.Constant zer(final k=0) "Zero signal"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
  Modelica.Blocks.Logical.Switch swi1
    annotation (Placement(transformation(extent={{40,50},{60,70}})));

equation
  assert(eOff < eOn, "Wrong controller parameters. Require eOff < eOn.");
  connect(zer.y, swi.u3) annotation (Line(
      points={{41,-30},{48,-30},{48,-8},{58,-8}},
      color={0,0,127}));
  connect(swi.y, y) annotation (Line(
      points={{81,6.10623e-16},{88.25,6.10623e-16},{88.25,1.16573e-15},{95.5,
          1.16573e-15},{95.5,5.55112e-16},{110,5.55112e-16}},
      color={0,0,127}));
  connect(u_m, PID.u_m) annotation (Line(
      points={{-1.11022e-15,-120},{-1.11022e-15,-80},{-20,-80},{-20,-4}},
      color={0,0,127}));
  connect(hys.y, swi.u2) annotation (Line(
      points={{-9,60},{20,60},{20,6.66134e-16},{58,6.66134e-16}},
      color={255,0,255}));
  connect(PID.y, swi.u1) annotation (Line(
      points={{-9,8},{24.5,8},{58,8}},
      color={0,0,127}));
  connect(u_s, feeBac.u1) annotation (Line(
      points={{-120,1.11022e-15},{-80,1.11022e-15},{-80,60},{-68,60}},
      color={0,0,127}));
  connect(u_m, feeBac.u2) annotation (Line(
      points={{-1.11022e-15,-120},{-1.11022e-15,-80},{-60,-80},{-60,52}},
      color={0,0,127}));
  connect(feeBac.y, hys.u) annotation (Line(
      points={{-51,60},{-32,60}},
      color={0,0,127}));
  connect(u_s, swi1.u1) annotation (Line(
      points={{-120,1.11022e-15},{-80,1.11022e-15},{-80,80},{20,80},{20,68},{38,
          68}},
      color={0,0,127}));
  connect(hys.y, swi1.u2) annotation (Line(
      points={{-9,60},{38,60}},
      color={255,0,255}));
  connect(u_m, swi1.u3) annotation (Line(
      points={{-1.11022e-15,-120},{-1.11022e-15,52},{38,52}},
      color={0,0,127}));
  connect(swi1.y, PID.u_s) annotation (Line(
      points={{61,60},{70,60},{70,30},{-50,30},{-50,8},{-32,8}},
      color={0,0,127}));
     annotation (Dialog(group="Set point tracking"),
               Icon(graphics={
        Polygon(
          points={{-80,94},{-88,72},{-72,72},{-80,94}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{90,-76},{68,-68},{68,-84},{90,-76}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-90,-76},{82,-76}}, color={192,192,192}),
        Text(
          extent={{-20,-16},{80,-56}},
          textColor={192,192,192},
          textString="PID"),
        Line(points={{-80,84},{-80,-84}}, color={192,192,192}),
        Line(points={{-80,-76},{-36,-76},{-36,-30},{36,12},{64,12}}, color={0,0,
              127}),
        Line(points={{-12,73},{-22,68},{-12,63}}),
        Line(points={{-42,68},{28,68}}),
        Line(points={{-22,39},{-12,34},{-22,29}}),
        Line(points={{-42,68},{-42,34}}),
        Line(points={{12,68},{12,34}}),
        Line(points={{-60,34},{12,34}})}),
defaultComponentName="conPID",
obsolete = "Obsolete model - use Buildings.Controls.Continuous.LimPID instead",
Documentation(info="<html>
<p>
Block of a controller for set point tracking with a hysteresis element that switches the
controller on and off.
</p>
<p>
If the controller is off, and the control error becomes larger than <code>eOn</code>, then
the controller switches to on and remains on until the control error is smaller than <code>eOff</code>.
When the controller is on, the set point tracking can be done using a P-, PI-, or PID-controller.
In its off-mode, the control output is zero. Thus, the parameters <code>yMin</code> and <code>yMax</code> are
used to constrain the output of the controller during its on mode only. This can be used, for
example, to modulate a device between 0.3 and 1.0, and switch it to off when the control error
is small enough.
</p>
</html>", revisions="<html>
<ul>
<li>
June 1, 2020, by Michael Wetter:<br/>
Corrected wrong convention of reverse and direct action.<br/>
Changed default configuration from PID to PI.<br/>
This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1365\">issue 1365</a>.
</li>
<li>
September 29, 2016, by Michael Wetter:<br/>
Removed parameter <code>limitsAtInit</code> because it is no longer
used in the PID controller.
</li>
<li>
April 13, 2016, by Michael Wetter:<br/>
Set <code>zer(final k=0)</code> and made swi, zer and zer1 protected
which they are also for
<a href=\"modelica://Buildings.Obsolete.Controls.Continuous.PIDHysteresis\">
Buildings.Obsolete.Controls.Continuous.PIDHysteresis</a>.
These changes are not backwards compatible.
</li>
<li>
March 15, 2016, by Michael Wetter:<br/>
Changed the default value to <code>strict=true</code>
in order to avoid events when the controller saturates.
Also assigned propogated values to be <code>final</code>.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/433\">issue 433</a>.
</li>
<li>
February 24, 2010, by Michael Wetter:<br/>
Changed PID controller from Modelica Standard Library to
PID controller from Buildings library to allow reverse control action.
</li>
<li>
October 2, 2009, by Michael Wetter:<br/>
Fixed error in default parameter <code>eOn</code>.
Fixed error by introducing parameter <code>Td</code>,
which used to be hard-wired in the PID controller.
</li>
<li>
February 14, 2009, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end PIDHysteresis;
