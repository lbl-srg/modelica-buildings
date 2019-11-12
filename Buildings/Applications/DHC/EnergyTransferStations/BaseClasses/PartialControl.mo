within Buildings.Applications.DHC.EnergyTransferStations.BaseClasses;
partial model PartialControl
  "Partial temperature setpoint control model for energy transfer stations"

  // Controller parameters
  parameter Modelica.Blocks.Types.SimpleController controllerType=
    Modelica.Blocks.Types.SimpleController.PID
    "Type of controller"
    annotation(Dialog(tab="Controller"));
  parameter Real k(min=0, unit="1") = 1
    "Gain of controller"
    annotation(Dialog(tab="Controller"));
  parameter Modelica.SIunits.Time Ti(min=Modelica.Constants.small)=0.5
    "Time constant of integrator block"
     annotation (Dialog(tab="Controller"));
  parameter Modelica.SIunits.Time Td(min=0)=0.1
    "Time constant of derivative block"
     annotation (Dialog(tab="Controller"));
  parameter Real yMax(start=1)=1
   "Upper limit of output"
    annotation(Dialog(tab="Controller"));
  parameter Real yMin=0
   "Lower limit of output"
    annotation(Dialog(tab="Controller"));
  parameter Real wp(min=0) = 1
   "Set-point weight for Proportional block (0..1)"
    annotation(Dialog(tab="Controller"));
  parameter Real wd(min=0) = 0
   "Set-point weight for Derivative block (0..1)"
    annotation(Dialog(tab="Controller"));
  parameter Real Ni(min=100*Modelica.Constants.eps) = 0.9
    "Ni*Ti is time constant of anti-windup compensation"
    annotation(Dialog(tab="Controller"));
  parameter Real Nd(min=100*Modelica.Constants.eps) = 10
    "The higher Nd, the more ideal the derivative block"
    annotation(Dialog(tab="Controller"));
  parameter Modelica.Blocks.Types.InitPID initType=
    Modelica.Blocks.Types.InitPID.DoNotUse_InitialIntegratorState
    "Type of initialization (1: no init, 2: steady state, 3: initial state, 4: initial output)"
    annotation(Dialog(group="Initialization",tab="Controller"));
  parameter Real xi_start=0
    "Initial or guess value value for integrator output (= integrator state)"
    annotation (Dialog(group="Initialization",tab="Controller"));
  parameter Real xd_start=0
    "Initial or guess value for state of derivative block"
    annotation (Dialog(group="Initialization",tab="Controller"));
  parameter Real yCon_start=0
    "Initial value of output from the controller"
    annotation(Dialog(group="Initialization",tab="Controller"));
  parameter Boolean reverseAction = true
    "Set to true for throttling the water flow rate through a cooling coil controller"
    annotation(Dialog(tab="Controller"));

  Modelica.Blocks.Interfaces.RealInput TSet "Setpoint temperature"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
    Buildings.Controls.Continuous.LimPID con(
    controllerType=Modelica.Blocks.Types.SimpleController.PID,
    final k=k,
    Td=Td,
    final yMax=yMax,
    final yMin=yMin,
    final Ti=Ti,
    wp=wp,
    wd=wd,
    Ni=Ni,
    Nd=Nd,
    final initType=Modelica.Blocks.Types.InitPID.InitialOutput,
    xi_start=xi_start,
    xd_start=xd_start,
    final y_start=0,
    final reverseAction=reverseAction) "Controller"
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));

equation
  connect(con.u_s, TSet)
    annotation (Line(points={{-92,0},{-120,0}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>Partial model to implement temperature setpoint control for cooling energy transfer station models. </p>
</html>", revisions="<html>
<ul>
<li>November 5, 2019, by Kathryn Hinkelman:<br>First implementation. </li>
</ul>
</html>"));
end PartialControl;
