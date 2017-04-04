within Buildings.Experimental.OpenBuildingControl.CDL.Continuous;
block LimPID
  "P, PI, PD, and PID controller with limited output, anti-windup compensation and setpoint weighting"
  import Buildings.Experimental.OpenBuildingControl.CDL.Types.Init;
  import Buildings.Experimental.OpenBuildingControl.CDL.Types.SimpleController;
  output Real controlError = u_s - u_m
    "Control error (set point - measurement)";

  parameter Buildings.Experimental.OpenBuildingControl.CDL.Types.SimpleController controllerType=
         Types.SimpleController.PID "Type of controller";
  parameter Real k(min=0, unit="1") = 1 "Gain of controller";
  parameter Modelica.SIunits.Time Ti(min=Constants.small)=0.5
    "Time constant of Integrator block" annotation (Dialog(enable=
          controllerType == Modelica.Blocks.Types.SimpleController.PI or
          controllerType == Modelica.Blocks.Types.SimpleController.PID));
  parameter Modelica.SIunits.Time Td(min=0)=0.1
    "Time constant of Derivative block" annotation (Dialog(enable=
          controllerType == Modelica.Blocks.Types.SimpleController.PD or
          controllerType == Modelica.Blocks.Types.SimpleController.PID));
  parameter Real yMax "Upper limit of output";
  parameter Real yMin=-yMax "Lower limit of output";
  parameter Real wp(min=0) = 1
    "Set-point weight for Proportional block (0..1)";
  parameter Real wd(min=0) = 0 "Set-point weight for Derivative block (0..1)"
       annotation(Dialog(enable=controllerType==Modelica.Blocks.Types.SimpleController.PD or
                                controllerType==Modelica.Blocks.Types.SimpleController.PID));
  parameter Real Ni(min=100*Constants.eps) = 0.9
    "Ni*Ti is time constant of anti-windup compensation"
     annotation(Dialog(enable=controllerType==Modelica.Blocks.Types.SimpleController.PI or
                              controllerType==Modelica.Blocks.Types.SimpleController.PID));
  parameter Real Nd(min=100*Constants.eps) = 10
    "The higher Nd, the more ideal the derivative block"
       annotation(Dialog(enable=controllerType==Modelica.Blocks.Types.SimpleController.PD or
                                controllerType==Modelica.Blocks.Types.SimpleController.PID));
  parameter Buildings.Experimental.OpenBuildingControl.CDL.Types.Init initType= Types.Init.InitialState
    "Type of initialization"         annotation(Evaluate=true,
      Dialog(group="Initialization"));
  parameter Boolean limitsAtInit = true
    "= false, if limits are ignored during initialization"
    annotation(Evaluate=true, Dialog(group="Initialization"));
  parameter Real xi_start=0
    "Initial or guess value value for integrator output (= integrator state)"
    annotation (Dialog(group="Initialization",
                enable=controllerType==Modelica.Blocks.Types.SimpleController.PI or
                       controllerType==Modelica.Blocks.Types.SimpleController.PID));
  parameter Real xd_start=0
    "Initial or guess value for state of derivative block"
    annotation (Dialog(group="Initialization",
                         enable=controllerType==Modelica.Blocks.Types.SimpleController.PD or
                                controllerType==Modelica.Blocks.Types.SimpleController.PID));
  parameter Real y_start=0 "Initial value of output"
    annotation(Dialog(enable=initType == Modelica.Blocks.Types.Init.InitialOutput, group=
          "Initialization"));

  constant Modelica.SIunits.Time unitTime=1 annotation (HideResult=true);

  Interfaces.RealInput u_s "Connector of setpoint input signal" annotation (Placement(
        transformation(extent={{-140,-20},{-100,20}})));
  Interfaces.RealInput u_m "Connector of measurement input signal" annotation (Placement(
        transformation(
        origin={0,-120},
        extent={{20,-20},{-20,20}},
        rotation=270)));
  Interfaces.RealOutput y "Connector of actuator output signal" annotation (Placement(
        transformation(extent={{100,-10},{120,10}})));

  Add addP(k1=wp, k2=-1)
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Add addD(k1=wd, k2=-1) if with_D
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Gain P(k=1)
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Continuous.IntegratorWithReset I(
    reset=Types.Reset.Disabled,
    k=unitTime/Ti,
    y_start=xi_start,
    initType=if initType == Init.SteadyState then Init.SteadyState else
        if initType == Init.InitialState
         then Init.InitialState else Init.NoInit) if with_I
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));
  Continuous.Derivative D(
    k=Td/unitTime,
    T=max([Td/Nd,1.e-14]),
    x_start=xd_start,
    initType=if initType == Init.SteadyState or initType == Init.InitialOutput
         then Init.SteadyState else if initType == Init.InitialState then
        Init.InitialState else Init.NoInit) if with_D
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Gain gainPID(k=k)
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  Add3 addPID
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Add3 addI(k2=-1) if with_I
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Add addSat(k1=+1, k2=-1) if with_I annotation (
      Placement(transformation(
        origin={80,-50},
        extent={{-10,-10},{10,10}},
        rotation=270)));
  Gain gainTrack(k=1/(k*Ni)) if with_I
    annotation (Placement(transformation(extent={{40,-80},{20,-60}})));
  Limiter limiter(
    uMax=yMax,
    uMin=yMin)
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));
protected
  parameter Boolean with_I = controllerType==SimpleController.PI or
                             controllerType==SimpleController.PID annotation(Evaluate=true, HideResult=true);
  parameter Boolean with_D = controllerType==SimpleController.PD or
                             controllerType==SimpleController.PID annotation(Evaluate=true, HideResult=true);
public
  Constant Dzero(k=0) if not with_D
    annotation (Placement(transformation(extent={{-30,20},{-20,30}})));
  Constant Izero(k=0) if not with_I
    annotation (Placement(transformation(extent={{10,-55},{0,-45}})));
initial equation
  if initType==Init.InitialOutput then
     gainPID.y = y_start;
  end if;
equation
  if initType == Init.InitialOutput and (y_start < yMin or y_start > yMax) then
      Modelica.Utilities.Streams.error("LimPID: Start value y_start (=" + String(y_start) +
         ") is outside of the limits of yMin (=" + String(yMin) +") and yMax (=" + String(yMax) + ")");
  end if;

  connect(u_s, addP.u1) annotation (Line(points={{-120,0},{-96,0},{-96,56},{
          -82,56}}, color={0,0,127}));
  connect(u_s, addD.u1) annotation (Line(points={{-120,0},{-96,0},{-96,6},{
          -82,6}}, color={0,0,127}));
  connect(u_s, addI.u1) annotation (Line(points={{-120,0},{-96,0},{-96,-42},{
          -82,-42}}, color={0,0,127}));
  connect(addP.y, P.u) annotation (Line(points={{-59,50},{-42,50}}, color={0,
          0,127}));
  connect(addD.y, D.u)
    annotation (Line(points={{-59,0},{-42,0}}, color={0,0,127}));
  connect(addI.y, I.u) annotation (Line(points={{-59,-50},{-42,-50}}, color={
          0,0,127}));
  connect(P.y, addPID.u1) annotation (Line(points={{-19,50},{-10,50},{-10,8},
          {-2,8}}, color={0,0,127}));
  connect(D.y, addPID.u2)
    annotation (Line(points={{-19,0},{-2,0}}, color={0,0,127}));
  connect(I.y, addPID.u3) annotation (Line(points={{-19,-50},{-10,-50},{-10,
          -8},{-2,-8}}, color={0,0,127}));
  connect(addPID.y, gainPID.u)
    annotation (Line(points={{21,0},{28,0}}, color={0,0,127}));
  connect(gainPID.y, addSat.u2) annotation (Line(points={{51,0},{60,0},{60,
          -20},{74,-20},{74,-38}}, color={0,0,127}));
  connect(gainPID.y, limiter.u)
    annotation (Line(points={{51,0},{68,0}}, color={0,0,127}));
  connect(limiter.y, addSat.u1) annotation (Line(points={{91,0},{94,0},{94,
          -20},{86,-20},{86,-38}}, color={0,0,127}));
  connect(limiter.y, y)
    annotation (Line(points={{91,0},{110,0}}, color={0,0,127}));
  connect(addSat.y, gainTrack.u) annotation (Line(points={{80,-61},{80,-70},{
          42,-70}}, color={0,0,127}));
  connect(gainTrack.y, addI.u3) annotation (Line(points={{19,-70},{-88,-70},{
          -88,-58},{-82,-58}}, color={0,0,127}));
  connect(u_m, addP.u2) annotation (Line(
      points={{0,-120},{0,-92},{-92,-92},{-92,44},{-82,44}},
      color={0,0,127},
      thickness=0.5));
  connect(u_m, addD.u2) annotation (Line(
      points={{0,-120},{0,-92},{-92,-92},{-92,-6},{-82,-6}},
      color={0,0,127},
      thickness=0.5));
  connect(u_m, addI.u2) annotation (Line(
      points={{0,-120},{0,-92},{-92,-92},{-92,-50},{-82,-50}},
      color={0,0,127},
      thickness=0.5));
  connect(Dzero.y, addPID.u2) annotation (Line(points={{-19.5,25},{-14,25},{
          -14,0},{-2,0}}, color={0,0,127}));
  connect(Izero.y, addPID.u3) annotation (Line(points={{-0.5,-50},{-10,-50},{
          -10,-8},{-2,-8}}, color={0,0,127}));
  annotation (defaultComponentName="pid",
    Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}), graphics={
                                        Text(
        extent={{-150,150},{150,110}},
        textString="%name",
        lineColor={0,0,255}),   Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Line(points={{-80,78},{-80,-90}}, color={192,192,192}),
        Polygon(
          points={{-80,90},{-88,68},{-72,68},{-80,90}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-90,-80},{82,-80}}, color={192,192,192}),
        Polygon(
          points={{90,-80},{68,-72},{68,-88},{90,-80}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-80,-80},{-80,-20},{30,60},{80,60}}, color={0,0,127}),
        Text(
          extent={{-20,-20},{80,-60}},
          lineColor={192,192,192},
          textString="%controllerType"),
        Line(
          points={{30,60},{81,60}},
          color={255,0,0})}),
    Documentation(info="<html>
    <p>
Via parameter <code>controllerType</code> either <code>P</code>, <code>PI</code>, <code>PD</code>,
or <code>PID</code> can be selected. If, e.g., PI is selected, all components belonging to the
D-part are removed from the block (via conditional declarations).
The example model
<a href=\"modelica://Buildings.Experimental.OpenBuildingControl.CDL.Continuous.LimPID\">Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Validation.LimPID</a>
demonstrates the usage of this controller.
Several practical aspects of PID controller design are incorporated
according to chapter 3 of the book:
</p>

<dl>
<dt>&Aring;str&ouml;m K.J., and H&auml;gglund T.:</dt>
<dd> <code>PID Controllers: Theory, Design, and Tuning</code>.
     Instrument Society of America, 2nd edition, 1995.
</dd>
</dl>

<p>
Besides the additive <code>proportional, integral</code> and <code>derivative</code>
part of this controller, the following features are present:
</p>
<ul>
<li> The output of this controller is limited. If the controller is
     in its limits, anti-windup compensation is activated to drive
     the integrator state to zero. </li>
<li> The high-frequency gain of the derivative part is limited
     to avoid excessive amplification of measurement noise.</li>
<li> Setpoint weighting is present, which allows to weight
     the setpoint in the proportional and the derivative part
     independently from the measurement. The controller will respond
     to load disturbances and measurement noise independently of this setting
     (parameters wp, wd). However, setpoint changes will depend on this
     setting. For example, it is useful to set the setpoint weight wd
     for the derivative part to zero, if steps may occur in the
     setpoint signal.</li>
</ul>

<p>
The parameters of the controller can be manually adjusted by performing
simulations of the closed loop system (= controller + plant connected
together) and using the following strategy:
</p>

<ol>
<li> Set very large limits, e.g., yMax = Constants.inf</li>
<li> Select a <code>P</code>-controller and manually enlarge parameter <code>k</code>
     (the total gain of the controller) until the closed-loop response
     cannot be improved any more.</li>
<li> Select a <code>PI</code>-controller and manually adjust parameters
     <code>k</code> and <code>Ti</code> (the time constant of the integrator).
     The first value of Ti can be selected, such that it is in the
     order of the time constant of the oscillations occurring with
     the P-controller. If, e.g., vibrations in the order of T=10 ms
     occur in the previous step, start with Ti=0.01 s.</li>
<li> If you want to make the reaction of the control loop faster
     (but probably less robust against disturbances and measurement noise)
     select a <code>PID</code>-Controller and manually adjust parameters
     <code>k</code>, <code>Ti</code>, <code>Td</code> (time constant of derivative block).</li>
<li> Set the limits yMax and yMin according to your specification.</li>
<li> Perform simulations such that the output of the PID controller
     goes in its limits. Tune <code>Ni</code> (Ni*Ti is the time constant of
     the anti-windup compensation) such that the input to the limiter
     block (= limiter.u) goes quickly enough back to its limits.
     If Ni is decreased, this happens faster. If Ni=infinity, the
     anti-windup compensation is switched off and the controller works bad.</li>
</ol>

<p>
<code>Initialization</code>
</p>

<p>
This block can be initialized in different
ways controlled by parameter <code>initType</code>. The possible
values of initType are defined in
<a href=\"modelica://Buildings.Experimental.OpenBuildingControl.CDL.Types.Init\">
Buildings.Experimental.OpenBuildingControl.CDL.Types.Init</a>.
</p>

<p>
Based on the setting of initType, the integrator (I) and derivative (D)
blocks inside the PID controller are initialized according to the following table:
</p>

<table border=1 cellspacing=0 cellpadding=2 summary=\"Initialization options\">
  <tr><td valign=\"top\"><code>initType</code></td>
      <td valign=\"top\"><code>I.initType</code></td>
      <td valign=\"top\"><code>D.initType</code></td></tr>

  <tr><td valign=\"top\"><code>NoInit</code></td>
      <td valign=\"top\">NoInit</td>
      <td valign=\"top\">NoInit</td></tr>

  <tr><td valign=\"top\"><code>SteadyState</code></td>
      <td valign=\"top\">SteadyState</td>
      <td valign=\"top\">SteadyState</td></tr>

  <tr><td valign=\"top\"><code>InitialState</code></td>
      <td valign=\"top\">InitialState</td>
      <td valign=\"top\">InitialState</td></tr>

  <tr><td valign=\"top\"><code>InitialOutput</code><br/>
          and initial equation: y = y_start</td>
      <td valign=\"top\">NoInit</td>
      <td valign=\"top\">SteadyState</td></tr>

</table>

<p>
In many cases, the most useful initial condition is
<code>SteadyState</code> because initial transients are then no longer
present. If initType = Init.SteadyState, then in some
cases difficulties might occur. The reason is the
equation of the integrator:
</p>

<pre>
   <code>der</code>(y) = k*u;
</pre>

<p>
The steady state equation <code>der(x)=0</code> leads to the condition that the input u to the
integrator is zero. If the input u is already (directly or indirectly) defined
by another initial condition, then the initialization problem is <code>singular</code>
(has none or infinitely many solutions). This situation occurs often
for mechanical systems, where, e.g., u = desiredSpeed - measuredSpeed and
since speed is both a state and a derivative, it is natural to
initialize it with zero. As sketched this is, however, not possible.
The solution is to not initialize u_m or the variable that is used
to compute u_m by an algebraic equation.
</p>

</html>", revisions="<html>
<ul>
<li>
March 24, 2017, by Jianjun Hu:<br/>
Updated the block, for CDL implementation.
</li>
<li>
January 3, 2017, by Michael Wetter:<br/>
First implementation, based on the implementation of the
Modelica Standard Library.
</li>
</ul>
</html>"));
end LimPID;
