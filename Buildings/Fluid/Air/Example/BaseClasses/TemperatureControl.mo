within Buildings.Fluid.Air.Example.BaseClasses;
model TemperatureControl "Controller for supply air temperature"

  parameter Modelica.Blocks.Types.SimpleController controllerType1=
         Modelica.Blocks.Types.SimpleController.PID "Type of controller"
         annotation(Dialog(group="Valve Control"));
  parameter Real k1(min=0, unit="1") = 1 "Gain of controller"
         annotation(Dialog(group="Valve Control"));
  parameter Modelica.SIunits.Time Ti1(min=Modelica.Constants.small)=0.5
    "Time constant of Integrator block" annotation (Dialog(enable=
          controllerType1 == Modelica.Blocks.Types.SimpleController.PI or
          controllerType1 == Modelica.Blocks.Types.SimpleController.PID,
          group="Valve Control"));
  parameter Modelica.SIunits.Time Td1(min=0)=0.1
    "Time constant of Derivative block" annotation (Dialog(enable=
          controllerType1 == Modelica.Blocks.Types.SimpleController.PD or
          controllerType1 == Modelica.Blocks.Types.SimpleController.PID,
          group="Valve Control"));
  parameter Real yMax1(start=1)=1 "Upper limit of output"
          annotation(Dialog(group="Valve Control"));
  parameter Real yMin1=0 "Lower limit of output"
          annotation(Dialog(group="Valve Control"));
  parameter Real wp1(min=0) = 1 "Set-point weight for Proportional block (0..1)"
          annotation(Dialog(group="Valve Control"));
  parameter Real wd1(min=0) = 0 "Set-point weight for Derivative block (0..1)"
       annotation(Dialog(enable=controllerType1==.Modelica.Blocks.Types.SimpleController.PD or
                                controllerType1==.Modelica.Blocks.Types.SimpleController.PID,
                                group="Valve Control"));
  parameter Real Ni1(min=100*Modelica.Constants.eps) = 0.9
    "Ni*Ti is time constant of anti-windup compensation"
     annotation(Dialog(enable=controllerType1==.Modelica.Blocks.Types.SimpleController.PI or
                              controllerType1==.Modelica.Blocks.Types.SimpleController.PID,
                              group="Valve Control"));
  parameter Real Nd1(min=100*Modelica.Constants.eps) = 10
    "The higher Nd, the more ideal the derivative block"
       annotation(Dialog(enable=controllerType1==.Modelica.Blocks.Types.SimpleController.PD or
                                controllerType1==.Modelica.Blocks.Types.SimpleController.PID,
                                group="Valve Control"));
  parameter Modelica.Blocks.Types.InitPID initType1= Modelica.Blocks.Types.InitPID.DoNotUse_InitialIntegratorState
    "Type of initialization (1: no init, 2: steady state, 3: initial state, 4: initial output)"
                                     annotation(Evaluate=true,
      Dialog(tab="Initialization",group="Valve Control"));
      // Removed as the Limiter block no longer uses this parameter.
      // parameter Boolean limitsAtInit = true
      //  "= false, if limits are ignored during initialization"
      // annotation(Evaluate=true, Dialog(group="Initialization"));
  parameter Real xi1_start=0
    "Initial or guess value value for integrator output (= integrator state)"
    annotation (Dialog(tab="Initialization",group="Valve Control",
                enable=controllerType1==.Modelica.Blocks.Types.SimpleController.PI or
                       controllerType1==.Modelica.Blocks.Types.SimpleController.PID));
  parameter Real xd1_start=0
    "Initial or guess value for state of derivative block"
    annotation (Dialog(tab="Initialization",group="Valve Control",
                         enable=controllerType1==.Modelica.Blocks.Types.SimpleController.PD or
                                controllerType1==.Modelica.Blocks.Types.SimpleController.PID));
  parameter Real y1_start=0 "Initial value of output"
    annotation(Dialog(enable=initType1 == Modelica.Blocks.Types.InitPID.InitialOutput,
    tab="Initialization",group="Valve Control"));
  parameter Boolean strict=true "= true, if strict limits with noEvent(..)"
    annotation (Evaluate=true, choices(checkBox=true), Dialog(tab="Advanced"));
  parameter Boolean reverseAction = false
    "Set to true for throttling the water flow rate through a cooling coil controller"
    annotation(Dialog(group="Valve Control"));
  // parameters for reheat control
  parameter Modelica.Blocks.Types.SimpleController controllerType2=
         Modelica.Blocks.Types.SimpleController.PID "Type of controller"
         annotation(Dialog(group="Reheater Control"));
  parameter Real k2(min=0, unit="1") = 1 "Gain of controller"
         annotation(Dialog(group="Reheater Control"));
  parameter Modelica.SIunits.Time Ti2(min=Modelica.Constants.small)=0.5
    "Time constant of Integrator block" annotation (Dialog(enable=
          controllerType2 == Modelica.Blocks.Types.SimpleController.PI or
          controllerType2 == Modelica.Blocks.Types.SimpleController.PID,
          group="Reheater Control"));
  parameter Modelica.SIunits.Time Td2(min=0)=0.1
    "Time constant of Derivative block" annotation (Dialog(enable=
          controllerType2 == Modelica.Blocks.Types.SimpleController.PD or
          controllerType2 == Modelica.Blocks.Types.SimpleController.PID,
          group="Reheater Control"));
  parameter Real yMax2(start=1)=1 "Upper limit of output"
          annotation(Dialog(group="Reheater Control"));
  parameter Real yMin2=0 "Lower limit of output"
          annotation(Dialog(group="Reheater Control"));
  parameter Real wp2(min=0) = 1 "Set-point weight for Proportional block (0..1)"
          annotation(Dialog(group="Reheater Control"));
  parameter Real wd2(min=0) = 0 "Set-point weight for Derivative block (0..1)"
       annotation(Dialog(enable=controllerType2==.Modelica.Blocks.Types.SimpleController.PD or
                                controllerType2==.Modelica.Blocks.Types.SimpleController.PID,
                                group="Reheater Control"));
  parameter Real Ni2(min=100*Modelica.Constants.eps) = 0.9
    "Ni*Ti is time constant of anti-windup compensation"
     annotation(Dialog(enable=controllerType2==.Modelica.Blocks.Types.SimpleController.PI or
                              controllerType2==.Modelica.Blocks.Types.SimpleController.PID,
                              group="Reheater Control"));
  parameter Real Nd2(min=100*Modelica.Constants.eps) = 10
    "The higher Nd, the more ideal the derivative block"
       annotation(Dialog(enable=controllerType2==.Modelica.Blocks.Types.SimpleController.PD or
                                controllerType2==.Modelica.Blocks.Types.SimpleController.PID,
                                group="Reheater Control"));
  parameter Modelica.Blocks.Types.InitPID initType2= Modelica.Blocks.Types.InitPID.DoNotUse_InitialIntegratorState
    "Type of initialization (1: no init, 2: steady state, 3: initial state, 4: initial output)"
                                     annotation(Evaluate=true,
      Dialog(tab="Initialization",group="Reheater Control"));
      // Removed as the Limiter block no longer uses this parameter.
      // parameter Boolean limitsAtInit = true
      //  "= false, if limits are ignored during initialization"
      // annotation(Evaluate=true, Dialog(group="Initialization"));
  parameter Real xi2_start=0
    "Initial or guess value value for integrator output (= integrator state)"
    annotation (Dialog(tab="Initialization",group="Reheater Control",
                enable=controllerType2==.Modelica.Blocks.Types.SimpleController.PI or
                       controllerType2==.Modelica.Blocks.Types.SimpleController.PID));
  parameter Real xd2_start=0
    "Initial or guess value for state of derivative block"
    annotation (Dialog(tab="Initialization",group="Reheater Control",
                         enable=controllerType2==.Modelica.Blocks.Types.SimpleController.PD or
                                controllerType2==.Modelica.Blocks.Types.SimpleController.PID));
  parameter Real y2_start=0 "Initial value of output"
    annotation(Dialog(enable=initType2 == Modelica.Blocks.Types.InitPID.InitialOutput,
                      tab="Initialization",group="Reheater Control"));
  Controls.Continuous.LimPID conVal(
    final reset=Buildings.Types.Reset.Disabled,
    final strict=strict,
    final controllerType=controllerType1,
    final k=k1,
    final Ti=Ti1,
    Td=Td1,
    yMax=yMax1,
    yMin=yMin1,
    wp=wp1,
    wd=wd1,
    Ni=Ni1,
    Nd=Nd1,
    initType=initType1,
    xi_start=xi1_start,
    xd_start=xd1_start,
    y_start=y1_start,
    final reverseAction=reverseAction)
    "Control valve"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  Controls.Continuous.LimPID conEleHea(
    controllerType=controllerType2,
    k=k2,
    Ti=Ti2,
    Td=Td2,
    yMax=yMax2,
    yMin=yMin2,
    wp=wp2,
    wd=wd2,
    Ni=Ni2,
    Nd=Nd2,
    initType=initType2,
    xi_start=xi2_start,
    xd_start=xd2_start,
    y_start=y2_start,
    final strict=strict) "Control electrical heater"
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
  Modelica.Blocks.Interfaces.RealInput T_s "Temperature setpoint"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealInput T_m "Temperature measurement"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={0,-120})));
  Modelica.Blocks.Sources.BooleanExpression booExp(y=conVal.y <= conVal.yMin
         and T_m < T_s)
    "Boolean expression to determine when to activate controller for reheat"
    annotation (Placement(transformation(extent={{-88,-10},{-68,10}})));
  Modelica.Blocks.Interfaces.RealOutput yVal "Output signal for valve"
    annotation (Placement(transformation(extent={{140,20},{160,40}})));
  Modelica.Blocks.Interfaces.RealOutput yEleHea
    "Output signal for electric heater"
    annotation (Placement(transformation(extent={{140,-50},{160,-30}})));
  Modelica.Blocks.Logical.Switch swi2 "Switch for reheat controller"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));
  Modelica.Blocks.Logical.Switch swi1 "Swich for valve controller"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Modelica.Blocks.Logical.Switch swi3 "Switch for reheat controller"
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));
protected
  Modelica.Blocks.Sources.Constant zer(final k=0) "Zero signal"
    annotation (Placement(transformation(extent={{40,-70},{60,-50}})));

equation
  connect(conVal.y, yVal)
    annotation (Line(points={{41,30},{41,30},{150,30}},
                                                 color={0,0,127}));
  connect(booExp.y, swi2.u2) annotation (Line(points={{-67,0},{-60,0},{-60,-60},
          {-42,-60}}, color={255,0,255}));
  connect(T_s, swi2.u1) annotation (Line(points={{-120,0},{-94,0},{-94,-52},{-42,
          -52}}, color={0,0,127}));
  connect(swi2.y, conEleHea.u_s) annotation (Line(points={{-19,-60},{-10,-60},
          {-10,-30},{-2,-30}}, color={0,0,127}));
  connect(T_m, conEleHea.u_m) annotation (Line(points={{0,-120},{0,-120},{0,-80},
          {10,-80},{10,-42}}, color={0,0,127}));
  connect(T_m, swi2.u3) annotation (Line(points={{0,-120},{0,-120},{0,-80},{-52,
          -80},{-52,-68},{-42,-68}}, color={0,0,127}));
  connect(T_m, conVal.u_m) annotation (Line(points={{0,-120},{0,-80},{30,-80},
          {30,18}}, color={0,0,127}));
  connect(booExp.y, swi1.u2) annotation (Line(points={{-67,0},{-64,0},{-60,0},
          {-60,50},{-42,50}}, color={255,0,255}));
  connect(T_m, swi1.u1) annotation (Line(points={{0,-120},{0,-120},{0,-80},{-52,
          -80},{-52,58},{-42,58}}, color={0,0,127}));
  connect(T_s, swi1.u3) annotation (Line(points={{-120,0},{-94,0},{-94,42},{-42,
          42}}, color={0,0,127}));
  connect(swi1.y, conVal.u_s) annotation (Line(points={{-19,50},{-6,50},{4,50},
          {4,30},{18,30}}, color={0,0,127}));
  connect(booExp.y, swi3.u2)
    annotation (Line(points={{-67,0},{-2,0},{78,0}}, color={255,0,255}));
  connect(conEleHea.y, swi3.u1) annotation (Line(points={{21,-30},{40,-30},{40,
          8},{78,8}}, color={0,0,127}));
  connect(swi3.y, yEleHea) annotation (Line(points={{101,0},{101,0},{120,0},{120,
          -40},{150,-40}}, color={0,0,127}));
  connect(zer.y, swi3.u3) annotation (Line(points={{61,-60},{68,-60},{68,-20},
          {68,-8},{78,-8}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {140,100}}),                                        graphics={
          Rectangle(extent={{-100,100},{140,-100}}, lineColor={0,0,127}), Text(
          extent={{-114,136},{114,106}},
          lineColor={0,0,255},
          textString="%name")}),                                 Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{140,100}})),
    Documentation(info="<html>
<p>
This is a temperature controller designed for 
<a href= modelica://Buildings.Fluid.Air.Example.AirHandlingUnitControl>Buildings.Fluid.Air.Example.AirHandlingUnitControl</a>.
</p>
<p>
There are two controllers designed to control the supply air temperature in the air handler. 
One named <code>conVal</code> can manipulate the water-side valve to adjust the water flowrate in order to maintain the air-side outlet temperature.
The other one,<code>conEleHea</code> controls the air-side outlet temperature by adjusting the heat flow generated from the electric heater. 
These two controllers are not working at the same time. <code>conEleHea</code> will be activated only when the following conditions are met:
</p>
<ul>
<li>
The valve postion isn't larger than the minimum position and the supply air temperature is lower than the setpoint.
</li>
</ul>
<p>
When <code>conVal</code> is activated, the output control signal for the reheater is 0. 
</p>
</html>", revisions="<html>
<ul>
<li>
April 11, 2017 by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end TemperatureControl;
