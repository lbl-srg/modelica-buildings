within Buildings.Obsolete.Controls.Continuous;
model PIDHysteresisTimer
  "PID controller with anti-windup, hysteresis and timer to prevent short cycling"
  extends Modelica.Blocks.Interfaces.SVcontrol;
  extends Buildings.Obsolete.BaseClasses.ObsoleteModel;

  parameter Real minOffTime=600
    "Minimum time that devices needs to be off before it can run again"
      annotation (Dialog(group="On/off controller"));
  parameter Real eOn = 1
    "if off and control error > eOn, switch to set point tracking"
    annotation (Dialog(group="On/off controller"));
  parameter Real eOff = -eOn "if on and control error < eOff, set y=0"
    annotation (Dialog(group="On/off controller"));
  parameter Boolean pre_y_start=false
    "Value of hysteresis output at initial time"
    annotation (Dialog(group="On/off controller"));

  parameter Modelica.Blocks.Types.SimpleController controllerType=Modelica.Blocks.Types.SimpleController.PI
    "Type of controller"
      annotation (Dialog(group="Set point tracking"));
  parameter Real k=1 "Gain of controller"
      annotation (Dialog(group="Set point tracking"));
  parameter Modelica.Units.SI.Time Ti "Time constant of Integrator block"
    annotation (Dialog(group="Set point tracking"));
  parameter Modelica.Units.SI.Time Td "Time constant of Derivative block"
    annotation (Dialog(group="Set point tracking"));
  parameter Real yMax=1 "Upper limit of modulating output"
      annotation (Dialog(group="Set point tracking"));
  parameter Real yMin=0.3
    "Lower limit of modulating output (before switch to 0)"
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

  Modelica.Blocks.Interfaces.RealOutput tOn "Time since boiler switched on"
    annotation (Placement(transformation(extent={{100,70},{120,90}})));
  Modelica.Blocks.Interfaces.RealOutput tOff "Time since boiler switched off"
    annotation (Placement(transformation(extent={{100,30},{120,50}})));

  Buildings.Controls.Continuous.LimPID con(
    final controllerType=controllerType,
    final k=k,
    final Ti=Ti,
    final Td=Td,
    final wp=wp,
    final wd=wd,
    final Ni=Ni,
    final Nd=Nd,
    final initType=initType,
    final xi_start=xi_start,
    final xd_start=xd_start,
    final y_start=y_start,
    final yMin=yMin,
    final yMax=yMax,
    final reverseActing=reverseActing,
    final strict=strict) "Controller to track setpoint"
    annotation (Placement(transformation(extent={{-10,-60},{10,-40}})));
  Buildings.Controls.Continuous.OffTimer offHys
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
  Modelica.Blocks.Logical.Timer onTimer
    annotation (Placement(transformation(extent={{-20,70},{0,90}})));
  Modelica.Blocks.Logical.Timer offTimer
    annotation (Placement(transformation(extent={{20,30},{40,50}})));
         Modelica.Blocks.Interfaces.BooleanOutput on
    "Outputs true if boiler is on"        annotation (Placement(
        transformation(extent={{100,-90},{120,-70}})));
  Modelica.Blocks.Math.Feedback feeBac
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));
  Modelica.Blocks.Logical.Hysteresis hys(
    final pre_y_start=pre_y_start,
    final uLow=eOff,
    final uHigh=eOn) "Hysteresis element to switch controller on and off"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
protected
  Modelica.Blocks.Sources.Constant zer(final k=0) "Zero signal"
    annotation (Placement(transformation(extent={{20,-80},{40,-60}})));
  Modelica.Blocks.Logical.Switch switch2
    annotation (Placement(transformation(extent={{62,-50},{82,-30}})));
  Modelica.Blocks.Logical.GreaterEqualThreshold greaterEqualThreshold(threshold=
       minOffTime)
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
  Modelica.Blocks.Logical.And and3
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Modelica.Blocks.Logical.Not not1
    annotation (Placement(transformation(extent={{-20,30},{0,50}})));
  Modelica.Blocks.Logical.Switch switch1
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));
equation
  connect(u_m, con.u_m) annotation (Line(
      points={{-1.11022e-15,-120},{-1.11022e-15,-105.5},{-6.66131e-16,-105.5},{
          -6.66131e-16,-91},{4.44089e-16,-91},{4.44089e-16,-62}},
      color={0,0,127}));
  connect(zer.y,switch2. u3) annotation (Line(
      points={{41,-70},{50,-70},{50,-48},{60,-48}},
      color={0,0,127}));
  connect(switch2.y, y) annotation (Line(
      points={{83,-40},{96,-40},{96,5.55112e-16},{110,5.55112e-16}},
      color={0,0,127}));
  connect(and3.y,switch2. u2) annotation (Line(
      points={{81,6.10623e-16},{90,6.10623e-16},{90,-20},{52,-20},{52,-40},{60,
          -40}},
      color={255,0,255}));
  connect(greaterEqualThreshold.y, and3.u1) annotation (Line(
      points={{41,10},{50,10},{50,6.66134e-16},{58,6.66134e-16}},
      color={255,0,255}));
  connect(offHys.y, greaterEqualThreshold.u)   annotation (Line(
      points={{1,10},{18,10}},
      color={0,0,127}));
  connect(con.y,switch2. u1) annotation (Line(
      points={{11,-50},{46,-50},{46,-32},{60,-32}},
      color={0,0,127}));
  connect(onTimer.y, tOn) annotation (Line(
      points={{1,80},{110,80}},
      color={0,0,127}));
  connect(offTimer.y, tOff) annotation (Line(
      points={{41,40},{110,40}},
      color={0,0,127}));
  connect(and3.y, on) annotation (Line(
      points={{81,6.10623e-16},{90,6.10623e-16},{90,-80},{110,-80}},
      color={255,0,255}));
  connect(and3.y, onTimer.u) annotation (Line(
      points={{81,6.10623e-16},{90,6.10623e-16},{90,60},{-40,60},{-40,80},{-22,
          80}},
      color={255,0,255}));
  connect(and3.y, not1.u) annotation (Line(
      points={{81,6.10623e-16},{90,6.10623e-16},{90,60},{-40,60},{-40,40},{-22,
          40}},
      color={255,0,255}));
  connect(not1.y, offTimer.u) annotation (Line(
      points={{1,40},{18,40}},
      color={255,0,255}));
  connect(and3.y, switch1.u2) annotation (Line(
      points={{81,6.10623e-16},{90,6.10623e-16},{90,-20},{-60,-20},{-60,-50},{
          -42,-50}},
      color={255,0,255}));
  connect(u_s, switch1.u1) annotation (Line(
      points={{-120,1.11022e-15},{-92,1.11022e-15},{-92,-42},{-42,-42}},
      color={0,0,127}));
  connect(u_m, switch1.u3) annotation (Line(
      points={{-1.11022e-15,-120},{-1.11022e-15,-90},{-80,-90},{-80,-58},{-42,
          -58}},
      color={0,0,127}));
  connect(switch1.y, con.u_s) annotation (Line(
      points={{-19,-50},{-12,-50}},
      color={0,0,127}));
  connect(u_s, feeBac.u1) annotation (Line(
      points={{-120,1.11022e-15},{-112,1.11022e-15},{-112,1.77635e-15},{-104,
          1.77635e-15},{-104,6.66134e-16},{-88,6.66134e-16}},
      color={0,0,127}));
  connect(u_m, feeBac.u2) annotation (Line(
      points={{-1.11022e-15,-120},{-1.11022e-15,-90},{-80,-90},{-80,-8}},
      color={0,0,127}));
  connect(feeBac.y, hys.u) annotation (Line(
      points={{-71,6.10623e-16},{-68.75,6.10623e-16},{-68.75,1.27676e-15},{
          -66.5,1.27676e-15},{-66.5,6.66134e-16},{-62,6.66134e-16}},
      color={0,0,127}));
  connect(hys.y, offHys.u) annotation (Line(
      points={{-39,6.10623e-16},{-30,6.10623e-16},{-30,10},{-22,10}},
      color={255,0,255}));
  connect(hys.y, and3.u2) annotation (Line(
      points={{-39,6.10623e-16},{-30,6.10623e-16},{-30,-8},{58,-8}},
      color={255,0,255}));
  annotation ( Icon(graphics={
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
        Line(points={{-80,84},{-80,-84}}, color={192,192,192}),
        Line(points={{-80,-76},{-48,-76},{-48,30},{2,40},{54,-42},{54,-76},{64,
              -76}}, color={0,0,127})}),
defaultComponentName="conPID",
obsolete = "Obsolete model - use Buildings.Controls.Continuous.LimPID instead",
Documentation(
info="<html>
<p>
Block of a controller for set point tracking with a hysteresis element that switches the controller on and off, and a timer that prevents the
controller to short cycle.
</p>
<p>
The controller is similar to
<a href=\"modelica://Buildings.Obsolete.Controls.Continuous.PIDHysteresis\">
Buildings.Obsolete.Controls.Continuous.PIDHysteresis</a> but in addition,
it has a timer that prevents the controller from switching to on
too fast. When the controller switches off, the timer starts and
avoids the controller from switching on until <code>minOffTime</code> seconds elapsed.
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
</li>
<li>
February 9, 2009, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end PIDHysteresisTimer;
