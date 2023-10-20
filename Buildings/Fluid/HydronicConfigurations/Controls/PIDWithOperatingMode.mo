within Buildings.Fluid.HydronicConfigurations.Controls;
block PIDWithOperatingMode "PID controller with operating mode input"

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerType=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller";
  parameter Real k(
    min=100*Buildings.Controls.OBC.CDL.Constants.eps)=1
    "Gain of controller"
    annotation (Dialog(group="Control gains"));
  parameter Real Ti(unit="s")=0.5
    "Time constant of integrator block"
    annotation (Dialog(group="Control gains",
    enable=controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PI or
      controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real Td(unit="s")=0.1
    "Time constant of derivative block"
    annotation (Dialog(group="Control gains",
    enable=controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PD or
      controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real r(
    min=100*Buildings.Controls.OBC.CDL.Constants.eps)=1
    "Typical range of control error, used for scaling the control error";
  parameter Real yMax=1
    "Upper limit of output"
    annotation (Dialog(group="Limits"));
  parameter Real yMin=0
    "Lower limit of output"
    annotation (Dialog(group="Limits"));
  parameter Real Ni(
    min=100*Buildings.Controls.OBC.CDL.Constants.eps)=0.9
    "Ni*Ti is time constant of anti-windup compensation"
    annotation (Dialog(tab="Advanced",group="Integrator anti-windup",
    enable=controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PI or
      controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real Nd(
    min=100*Buildings.Controls.OBC.CDL.Constants.eps)=10
    "The higher Nd, the more ideal the derivative block"
    annotation (Dialog(tab="Advanced",group="Derivative block",
    enable=controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PD or
      controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Boolean reverseActing=true
    "Set to true for reverse acting, or false for direct acting control action";
  parameter Real y_reset=y_neutral
    "Value to which the controller output is reset at enable time or change-over switch"
    annotation (Dialog(enable=controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    or controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PID,
    group="Integrator reset"));
  parameter Real y_neutral=0
    "Value to which the controller output is reset at disable time";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u_s
    "Connector of setpoint input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u_m
    "Connector of measurement input signal"
    annotation (Placement(transformation(origin={0,-120},extent={{20,-20},{-20,20}},rotation=270),
      iconTransformation(extent={{20,-20},{-20,20}},rotation=270,origin={0,-120})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y
    "Connector of actuator output signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput mode "Control mode"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-60,-120}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-60,-120})));
  Buildings.Controls.OBC.CDL.Reals.PIDWithReset conPID(
    final controllerType=controllerType,
    final k=k,
    final Ti=Ti,
    final Td=Td,
    final r=r,
    final yMax=yMax,
    final yMin=yMin,
    final Ni=Ni,
    final Nd=Nd,
    final xi_start=y_neutral,
    final yd_start=y_neutral,
    final reverseActing=reverseActing,
    final y_reset=y_reset)
    "Controller"
    annotation (Placement(transformation(extent={{10,-10},{30,10}})));
  Buildings.Controls.OBC.CDL.Integers.Change cha
    "Monitor change of signal value"
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply mulSet
    "Multiply input with mapping coefficient"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor extIndSig(final nin=3)
    "Select mapping coefficient based on operating mode"
    annotation (Placement(transformation(extent={{-30,70},{-10,90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant map_ms[3](k={0,1,-1})
    "Map set point and measured values depending on actual operating mode"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply mulMea
    "Multiply input with mapping coefficient"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={20,-50})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Buildings.Controls.OBC.CDL.Integers.LessEqualThreshold isDis(t=Controls.OperatingModes.disabled)
    "Returns true if disabled"
    annotation (Placement(transformation(extent={{10,20},{30,40}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant disVal(k=y_neutral)
    "Value when disabled"
    annotation (Placement(transformation(extent={{10,70},{30,90}})));
  Buildings.Controls.OBC.CDL.Integers.AddParameter addPar(final p=1)
    "Convert mode index to array index"
    annotation (Placement(transformation(extent={{-50,40},{-30,60}})));
equation
  connect(cha.y, conPID.trigger)
    annotation (Line(points={{2,-30},{14,-30},{14,-12}}, color={255,0,255}));
  connect(u_s, mulSet.u2) annotation (Line(points={{-120,0},{-80,0},{-80,-6},{-22,
          -6}}, color={0,0,127}));
  connect(extIndSig.y, mulSet.u1) annotation (Line(points={{-8,80},{0,80},{0,20},
          {-30,20},{-30,6},{-22,6}},
                       color={0,0,127}));
  connect(u_m, mulMea.u2) annotation (Line(points={{0,-120},{0,-80},{26,-80},{
          26,-62}},
                 color={0,0,127}));
  connect(extIndSig.y, mulMea.u1) annotation (Line(points={{-8,80},{0,80},{0,20},
          {-30,20},{-30,-70},{14,-70},{14,-62}},
                                   color={0,0,127}));
  connect(mulMea.y, conPID.u_m)
    annotation (Line(points={{20,-38},{20,-12}}, color={0,0,127}));
  connect(mulSet.y, conPID.u_s)
    annotation (Line(points={{2,0},{8,0}}, color={0,0,127}));
  connect(mode, cha.u) annotation (Line(points={{-60,-120},{-60,-30},{-22,-30}},
        color={255,127,0}));
  connect(swi.y, y) annotation (Line(points={{82,0},{120,0}}, color={0,0,127}));
  connect(conPID.y, swi.u3)
    annotation (Line(points={{32,0},{40,0},{40,-8},{58,-8}}, color={0,0,127}));
  connect(isDis.y, swi.u2) annotation (Line(points={{32,30},{46,30},{46,0},{58,
          0}}, color={255,0,255}));
  connect(mode, isDis.u)
    annotation (Line(points={{-60,-120},{-60,30},{8,30}}, color={255,127,0}));
  connect(disVal.y, swi.u1)
    annotation (Line(points={{32,80},{52,80},{52,8},{58,8}}, color={0,0,127}));
  connect(addPar.y, extIndSig.index)
    annotation (Line(points={{-28,50},{-20,50},{-20,68}}, color={255,127,0}));
  connect(mode, addPar.u) annotation (Line(points={{-60,-120},{-60,50},{-52,50}},
        color={255,127,0}));
  connect(map_ms.y, extIndSig.u)
    annotation (Line(points={{-58,80},{-32,80}}, color={0,0,127}));
  annotation (
    defaultComponentName="ctl",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          textColor={0,0,255}),
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-80,82},{-88,60},{-72,60},{-80,82}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-80,68},{-80,-100}},
          color={192,192,192}),
        Line(
          points={{-80,-22},{6,56}},
          color={0,0,0}),
        Text(
          visible=(controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PI),
          extent={{-26,-22},{74,-62}},
          lineColor={0,0,0},
          textString="PI",
          fillPattern=FillPattern.Solid,
          fillColor={175,175,175}),
        Polygon(
          points={{74,-80},{52,-72},{52,-88},{74,-80}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-90,-80},{70,-80}},
          color={192,192,192}),
        Line(
          points={{6,56},{68,56}},
          color={0,0,0})}),                                      Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This block adds the following features to 
<a href=\"modelica://Buildings.Controls.OBC.CDL.Reals.PIDWithReset\">
Buildings.Controls.OBC.CDL.Reals.PIDWithReset</a>.
</p>
<ul>
<li>
Based on the constants defined within  
<a href=\"modelica://Buildings.Fluid.HydronicConfigurations.Controls.OperatingModes\">
Buildings.Fluid.HydronicConfigurations.Controls.OperatingModes</a>
the block allows the controller to be either disabled or switched 
to a change-over mode.
</li>
<li>
When the controller is disabled, the controller output is forced to 
<code>y_neutral</code> and the tracking error is zeroed out to prevent windup.
Typically this neutral value should correspond to a condition that
applies the minimum control effect, i.e., valves/dampers closed, 
VFDs at minimum speed, etc.
</li>
<li>
When operated under the mode <code>enabled</code>
the controller behaves exactly as
<a href=\"modelica://Buildings.Controls.OBC.CDL.Reals.PIDWithReset\">
Buildings.Controls.OBC.CDL.Reals.PIDWithReset</a>.
Furthermore, the controller output is reset to <code>y_reset</code> at enable
time.
</li>
<li>
When operated under the mode <code>heating</code>
the controller behaves as
<a href=\"modelica://Buildings.Controls.OBC.CDL.Reals.PIDWithReset\">
Buildings.Controls.OBC.CDL.Reals.PIDWithReset</a>
except that the sign of the measured and set point variables is reversed
so that the controller may for instance provide a heating function if 
it was originally configured for a cooling function.
Furthermore, the controller output is reset to <code>y_reset</code> at 
the time the operating mode changes.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
June 30, 2022, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end PIDWithOperatingMode;
