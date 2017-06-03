within Buildings.ChillerWSE.BaseClasses;
partial model PartialControllerInterface
  "Partial interface model for waterside economizer temperature controller"
 // Controller
  parameter Modelica.Blocks.Types.SimpleController controllerType=
         Modelica.Blocks.Types.SimpleController.PID "Type of controller"
    annotation(Dialog(tab="Controller"));
  parameter Real k(min=0, unit="1") = 1 "Gain of controller"
    annotation(Dialog(tab="Controller"));
  parameter Modelica.SIunits.Time Ti(min=Modelica.Constants.small)=0.5
    "Time constant of Integrator block" annotation (Dialog(enable=
          controllerType == Modelica.Blocks.Types.SimpleController.PI or
          controllerType == Modelica.Blocks.Types.SimpleController.PID,tab="Controller"));
  parameter Modelica.SIunits.Time Td(min=0)=0.1
    "Time constant of Derivative block" annotation (Dialog(enable=
          controllerType == Modelica.Blocks.Types.SimpleController.PD or
          controllerType == Modelica.Blocks.Types.SimpleController.PID,tab="Controller"));
  parameter Real yMax(start=1)=1 "Upper limit of output"
    annotation(Dialog(tab="Controller"));
  parameter Real yMin=0 "Lower limit of output"
    annotation(Dialog(tab="Controller"));
  parameter Real wp(min=0) = 1 "Set-point weight for Proportional block (0..1)"
    annotation(Dialog(tab="Controller"));
  parameter Real wd(min=0) = 0 "Set-point weight for Derivative block (0..1)"
    annotation(Dialog(enable=controllerType==.Modelica.Blocks.Types.SimpleController.PD or
       controllerType==.Modelica.Blocks.Types.SimpleController.PID,tab="Controller"));
  parameter Real Ni(min=100*Modelica.Constants.eps) = 0.9
    "Ni*Ti is time constant of anti-windup compensation"
    annotation(Dialog(enable=controllerType==.Modelica.Blocks.Types.SimpleController.PI or
     controllerType==.Modelica.Blocks.Types.SimpleController.PID,tab="Controller"));
  parameter Real Nd(min=100*Modelica.Constants.eps) = 10
    "The higher Nd, the more ideal the derivative block"
    annotation(Dialog(enable=controllerType==.Modelica.Blocks.Types.SimpleController.PD or
     controllerType==.Modelica.Blocks.Types.SimpleController.PID,tab="Controller"));
  parameter Modelica.Blocks.Types.InitPID initType= Modelica.Blocks.Types.InitPID.DoNotUse_InitialIntegratorState
    "Type of initialization (1: no init, 2: steady state, 3: initial state, 4: initial output)"
  annotation(Evaluate=true,Dialog(group="Initialization",tab="Controller"));
  parameter Real xi_start=0
    "Initial or guess value value for integrator output (= integrator state)"
    annotation (Dialog(group="Initialization",tab="Controller",
                enable=controllerType==.Modelica.Blocks.Types.SimpleController.PI or
                       controllerType==.Modelica.Blocks.Types.SimpleController.PID));
  parameter Real xd_start=0
    "Initial or guess value for state of derivative block"
    annotation (Dialog(group="Initialization",tab="Controller",
                enable=controllerType==.Modelica.Blocks.Types.SimpleController.PD or
                controllerType==.Modelica.Blocks.Types.SimpleController.PID));
  parameter Real y_startController=0 "Initial value of output from the controller"
    annotation(Dialog(enable=initType == Modelica.Blocks.Types.InitPID.InitialOutput, group=
          "Initialization",tab="Controller"));
  parameter Boolean reverseAction = false
    "Set to true for throttling the water flow rate through a cooling coil controller"
    annotation(Dialog(tab="Controller"));
  parameter Buildings.Types.Reset reset = Buildings.Types.Reset.Disabled
    "Type of controller output reset"
    annotation(Evaluate=true, Dialog(group="Integrator reset",tab="Controller"));
  parameter Real y_reset=xi_start
    "Value to which the controller output is reset if the boolean trigger has a rising edge, used if reset == Buildings.Types.Reset.Parameter"
    annotation(Dialog(enable=reset == Buildings.Types.Reset.Parameter,group="Integrator reset",tab="Controller"));

 Modelica.Blocks.Interfaces.BooleanInput trigger if
       reset <> Buildings.Types.Reset.Disabled
    "Resets the controller output when trigger becomes true"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-60,-100}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-60,-100})));
  Modelica.Blocks.Interfaces.RealInput y_reset_in if
       reset == Buildings.Types.Reset.Input
    "Input signal for state to which integrator is reset, enabled if reset = Buildings.Types.Reset.Input"
    annotation (Placement(transformation(extent={{-140,-70},{-100,-30}}),
        iconTransformation(extent={{-140,-70},{-100,-30}})));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-80},
            {100,80}})),                                         Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-80},{100,80}})),
    __Dymola_Commands,
    Documentation(info="<html>
<p>This module simulates a heat exchanger with bypass used to modulate water flow rate.</p>
</html>", revisions="<html>
<ul>
<li>
September 08, 2016, by Yangyang Fu:<br>
Delete parameter: nominal flowrate of temperaure sensors. 
</li>
</ul>
<ul>
<li>
July 30, 2016, by Yangyang Fu:<br>
First implementation.
</li>
</ul>
</html>"));
end PartialControllerInterface;
