within Buildings.Fluid.Air.BaseClasses;
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
    annotation(Dialog(enable=initType == Modelica.Blocks.Types.InitPID.InitialOutput, tab="Initialization",group="Valve Control"));
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
    annotation(Dialog(enable=initType == Modelica.Blocks.Types.InitPID.InitialOutput, tab="Initialization",group="Reheater Control"));


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
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
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
    final strict=strict,
    reverseAction=reverseAction,
    reset=Buildings.Types.Reset.Disabled)
                                       "COntrol electrical heater"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
  Modelica.Blocks.Interfaces.RealInput T_s "Temperature setpoint"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealInput T_m "Temperature measurement"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={0,-120})));
  Modelica.Blocks.Sources.RealExpression TSetEleHea(y=if conVal.y <= conVal.yMin
         and T_m < T_s - 0.1 then T_s else T_m)
    "Temperature setpoint for electric reheat"
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
  Modelica.Blocks.Interfaces.RealOutput yVal "Output signal for valve"
    annotation (Placement(transformation(extent={{100,20},{120,40}})));
  Modelica.Blocks.Interfaces.RealOutput yEleHea
    "Output signal for electric heater"
    annotation (Placement(transformation(extent={{100,-40},{120,-20}})));
equation
  connect(conVal.u_s, T_s) annotation (Line(points={{-42,30},{-80,30},{-80,0},{-120,
          0}}, color={0,0,127}));
  connect(conEleHea.u_m, T_m) annotation (Line(points={{30,-42},{30,-80},{0,-80},
          {0,-120}}, color={0,0,127}));
  connect(T_m, conVal.u_m) annotation (Line(points={{0,-120},{0,-80},{-30,-80},{
          -30,18}}, color={0,0,127}));
  connect(TSetEleHea.y, conEleHea.u_s)
    annotation (Line(points={{1,-30},{10,-30},{18,-30}}, color={0,0,127}));
  connect(conVal.y, yVal)
    annotation (Line(points={{-19,30},{110,30}}, color={0,0,127}));
  connect(conEleHea.y, yEleHea)
    annotation (Line(points={{41,-30},{110,-30}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(extent={{-100,100},{100,-100}}, lineColor={0,0,255}), Text(
          extent={{-114,136},{114,106}},
          lineColor={0,0,255},
          textString="%name")}),                                 Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end TemperatureControl;
