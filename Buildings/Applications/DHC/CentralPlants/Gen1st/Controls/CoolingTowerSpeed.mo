within Buildings.Applications.DHC.CentralPlants.Gen1st.Controls;
model CoolingTowerSpeed
  "Controller for the fan speed in cooling towers"
  extends Modelica.Blocks.Icons.Block;

  parameter Modelica.Blocks.Types.SimpleController controllerType=
    Modelica.Blocks.Types.SimpleController.PID
    "Type of controller"
    annotation(Dialog(tab="Controller"));
  parameter Real k(min=0, unit="1") = 1
    "Gain of controller"
    annotation(Dialog(tab="Controller"));
  parameter Modelica.SIunits.Time Ti(min=Modelica.Constants.small)=0.5
    "Time constant of integrator block"
     annotation (Dialog(enable=
          (controllerType == Modelica.Blocks.Types.SimpleController.PI or
          controllerType == Modelica.Blocks.Types.SimpleController.PID),tab="Controller"));
  parameter Modelica.SIunits.Time Td(min=0)=0.1
    "Time constant of derivative block"
     annotation (Dialog(enable=
          (controllerType == Modelica.Blocks.Types.SimpleController.PD or
          controllerType == Modelica.Blocks.Types.SimpleController.PID),tab="Controller"));
  parameter Real yMax(start=1)=1
   "Upper limit of output"
    annotation(Dialog(tab="Controller"));
  parameter Real yMin=0
   "Lower limit of output"
    annotation(Dialog(tab="Controller"));
  parameter Boolean reverseAction = true
    "Set to true for throttling the water flow rate through a cooling coil controller"
    annotation(Dialog(tab="Controller"));
  Modelica.Blocks.Interfaces.RealOutput y
    "Speed signal for cooling tower fans"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  Buildings.Controls.Continuous.LimPID conPID(
    reverseAction=true,
    controllerType=Modelica.Blocks.Types.SimpleController.PID,
    k=GaiPi,
    Ti=tIntPi,
    reset=Buildings.Types.Reset.Disabled)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealInput TCWSet
    "Temperature setpoint of the condenser water"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
  Modelica.Blocks.Interfaces.RealInput TCWMea
    "Temperature measurement of the condenser water"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));
equation
  connect(TCWSet, conPID.u_s) annotation (Line(points={{-120,40},{-80,40},{-80,0},
          {-12,0}}, color={0,0,127}));
  connect(TCWMea, conPID.u_m)
    annotation (Line(points={{-120,-40},{0,-40},{0,-12}}, color={0,0,127}));
  connect(conPID.y, y)
    annotation (Line(points={{11,0},{110,0}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),    Documentation(info="<html>
<p>This model describes a simple cooling tower speed controller for
a chilled water system with integrated waterside economizers.
</p>
<p>The control logics are described in the following:</p>
<ul>
<li>When the system is in Fully Mechanical Cooling (FMC) mode,
the cooling tower fan speed is controlled to maintain the condener water supply temperature (CWST)
at or around the setpoint.
</li>
<li>When the system is in Partially Mechanical Cooling (PMC) mode,
the cooling tower fan speed is set as 100% to make condenser water
as cold as possible and maximize the waterside economzier output.
</li>
<li>When the system is in Free Cooling (FC) mode,
the cooling tower fan speed is controlled to maintain the chilled water supply temperature (CHWST)
at or around its setpoint.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
July 30, 2017, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end CoolingTowerSpeed;
