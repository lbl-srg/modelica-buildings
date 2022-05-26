within Buildings.Fluid.HydronicConfigurations.Controls;
block PIDWithOperatingMode "PID controller with operating mode input"

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
    annotation (Dialog(group="Control gains",
    enable=controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PI or
      controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real Td(
    final quantity="Time",
    final unit="s",
    min=100*Buildings.Controls.OBC.CDL.Constants.eps)=0.1
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
  parameter Real y_reset=0
    "Value to which the controller output is reset if the boolean trigger has a rising edge"
    annotation (Dialog(enable=controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    or controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PID,group="Integrator reset"));
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
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput mod
    "Control mode"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},rotation=90,origin={-60,-120}),
      iconTransformation(extent={{-20,-20},{20,20}},rotation=90,origin={-60,-120})));
  Buildings.Controls.OBC.CDL.Continuous.PIDWithReset conPID(
    final controllerType=controllerType,
    final k=k,
    final Ti=Ti,
    final Td=Td,
    final r=r,
    final yMax=yMax,
    final yMin=yMin,
    final Ni=Ni,
    final Nd=Nd,
    final xi_start=y_reset,
    final yd_start=y_reset,
    final reverseActing=reverseActing,
    final y_reset=y_reset)
    "Controller"
    annotation (Placement(transformation(extent={{10,-10},{30,10}})));
  Buildings.Controls.OBC.CDL.Integers.Change cha
    "Monitor change of signal value"
    annotation (Placement(transformation(extent={{-20,-50},{0,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply mulSet
    "Multiply input with mapping coefficient"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor extIndSig(
    final nin=3)
    "Select mapping coefficient based on operating mode"
    annotation (Placement(transformation(extent={{-70,10},{-50,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant map[3](k={0,1,-1})
    "Map set point and measured values to actual operating mode"
    annotation (Placement(transformation(extent={{-70,50},{-50,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply mulMea
    "Multiply input with mapping coefficient"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={20,-60})));
equation
  connect(mod, cha.u) annotation (Line(points={{-60,-120},{-60,-40},{-22,-40}},
        color={255,127,0}));
  connect(cha.y, conPID.trigger)
    annotation (Line(points={{2,-40},{14,-40},{14,-12}}, color={255,0,255}));
  connect(mod, extIndSig.index)
    annotation (Line(points={{-60,-120},{-60,8}},  color={255,127,0}));
  connect(map.y, extIndSig.u) annotation (Line(points={{-48,60},{-40,60},{-40,40},
          {-80,40},{-80,20},{-72,20}}, color={0,0,127}));
  connect(u_s, mulSet.u2) annotation (Line(points={{-120,0},{-80,0},{-80,-6},{-22,
          -6}}, color={0,0,127}));
  connect(extIndSig.y, mulSet.u1) annotation (Line(points={{-48,20},{-40,20},{-40,
          6},{-22,6}}, color={0,0,127}));
  connect(u_m, mulMea.u2) annotation (Line(points={{0,-120},{0,-90},{26,-90},{26,
          -72}}, color={0,0,127}));
  connect(extIndSig.y, mulMea.u1) annotation (Line(points={{-48,20},{-40,20},{-40,
          -80},{14,-80},{14,-72}}, color={0,0,127}));
  connect(mulMea.y, conPID.u_m)
    annotation (Line(points={{20,-48},{20,-12}}, color={0,0,127}));
  connect(mulSet.y, conPID.u_s)
    annotation (Line(points={{2,0},{8,0}}, color={0,0,127}));
  connect(conPID.y, y)
    annotation (Line(points={{32,0},{120,0}}, color={0,0,127}));
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
To prevent windup, the tracking error is zeroed out 
when the control mode is equal to \"Disabled\".
When the control mode switches to \"Enabled\" the controller
is reset to a neutral value.
A control loop in neutral shall correspond to a condition that applies 
the minimum control effect, i.e., valves/dampers closed, VFDs at minimum speed, etc.
</p>
</html>"));
end PIDWithOperatingMode;
