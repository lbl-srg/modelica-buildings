within Buildings.Fluid.Storage.Ice.BaseClasses;
model OutletTemperatureControl "Storage outlet temperature control"
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller";
  parameter Real k(min=0) = 1 "Gain of controller";
  parameter Modelica.Units.SI.Time Ti(min=Modelica.Constants.small)=0.5
    "Time constant of Integrator block" annotation (Dialog(enable=
      controllerType==Buildings.Controls.OBC.CDL.Types.SimpleController.PI or
      controllerType==Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Modelica.Units.SI.Time Td(min=0)=0.1
    "Time constant of Derivative block" annotation (Dialog(
      enable=controllerType==Buildings.Controls.OBC.CDL.Types.SimpleController.PD or
             controllerType==Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Real Ni(min=100*Modelica.Constants.eps) = 0.9
    "Ni*Ti is time constant of anti-windup compensation"
     annotation(Dialog(enable=controllerType==Buildings.Controls.OBC.CDL.Types.SimpleController.PI or
                       controllerType==Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real Nd(min=100*Modelica.Constants.eps) = 10
    "The higher Nd, the more ideal the derivative block"
       annotation(Dialog(enable=controllerType==Buildings.Controls.OBC.CDL.Types.SimpleController.PI or
                       controllerType==Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real xi_start=0
    "Initial or guess value value for integrator output (= integrator state)"
    annotation (Dialog(group="Initialization",
                enable=controllerType==Buildings.Controls.OBC.CDL.Types.SimpleController.PI or
                       controllerType==Buildings.Controls.OBC.CDL.Types.SimpleController.PID));


  final parameter Real y_reset=xi_start
    "Value to which the controller output is reset if the boolean trigger has a rising edge"
    annotation(Dialog(group="Integrator reset",
                      enable=controllerType==Buildings.Controls.OBC.CDL.Types.SimpleController.PI or
                             controllerType==Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  Modelica.Blocks.Interfaces.IntegerInput u "Storage mode"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Logical.Switch swi1
                                     "Switch"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Buildings.Controls.OBC.CDL.Integers.Equal isDis "Is discharging"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  Modelica.Blocks.Sources.IntegerExpression disMod(y=Integer(Buildings.Fluid.Storage.Ice.Types.OperationModes.Discharging))
    "Discharging mode"
    annotation (Placement(transformation(extent={{-80,-58},{-60,-38}})));
  Modelica.Blocks.Logical.Switch swi2
                                     "Switch"
    annotation (Placement(transformation(extent={{20,-50},{40,-30}})));
  Controls.OBC.CDL.Continuous.PIDWithReset conPID(
    controllerType=controllerType,
    k=k,
    Ti=Ti,
    Td=Td,
    yMax=1,
    yMin=0,
    Ni=Ni,
    Nd=Nd,
    xi_start=xi_start,
    reverseActing=true,
    y_reset=y_reset)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealOutput y(
    final quantity="1",
    min=0,
    max=1) "Valve opening" annotation (Placement(transformation(extent={{100,-10},
            {120,10}}), iconTransformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealInput TOutSet "Outlet temperature setpoint"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealInput TOutMea
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));

  Buildings.Controls.OBC.CDL.Integers.Equal isDor "Is dormant"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  Modelica.Blocks.Sources.IntegerExpression dorMod(y=Integer(Buildings.Fluid.Storage.Ice.Types.OperationModes.Dormant))
    "Dormant mode"
    annotation (Placement(transformation(extent={{-80,22},{-60,42}})));
  Modelica.Blocks.Sources.Constant uti(k=1) "Utility"
    annotation (Placement(transformation(extent={{20,80},{40,100}})));
  Modelica.Blocks.Sources.Constant zer(k=0) "Zero"
    annotation (Placement(transformation(extent={{-10,-90},{10,-70}})));

equation
  connect(disMod.y,isDis. u2)
    annotation (Line(points={{-59,-48},{-42,-48}}, color={255,127,0}));
  connect(u,isDis. u1) annotation (Line(points={{-120,60},{-54,60},{-54,-40},{-42,
          -40}}, color={255,127,0}));
  connect(TOutSet, conPID.u_s) annotation (Line(points={{-120,0},{-12,0}},
                           color={0,0,127}));
  connect(TOutMea, conPID.u_m) annotation (Line(points={{-120,-60},{0,-60},{0,-12}},
                 color={0,0,127}));
  connect(dorMod.y, isDor.u2)
    annotation (Line(points={{-59,32},{-42,32}}, color={255,127,0}));
  connect(u, isDor.u1) annotation (Line(points={{-120,60},{-54,60},{-54,40},{-42,
          40}}, color={255,127,0}));
  connect(isDor.y, swi1.u2) annotation (Line(points={{-18,40},{40,40},{40,0},{58,
          0}}, color={255,0,255}));
  connect(uti.y, swi1.u1)
    annotation (Line(points={{41,90},{48,90},{48,8},{58,8}}, color={0,0,127}));
  connect(isDis.y, conPID.trigger)
    annotation (Line(points={{-18,-40},{-6,-40},{-6,-12}}, color={255,0,255}));
  connect(isDis.y, swi2.u2)
    annotation (Line(points={{-18,-40},{18,-40}}, color={255,0,255}));
  connect(conPID.y, swi2.u1) annotation (Line(points={{11,0},{14,0},{14,-32},{18,
          -32}}, color={0,0,127}));
  connect(zer.y, swi2.u3) annotation (Line(points={{11,-80},{14,-80},{14,-48},{18,
          -48}}, color={0,0,127}));
  connect(swi2.y, swi1.u3) annotation (Line(points={{41,-40},{48,-40},{48,-8},{58,
          -8}}, color={0,0,127}));
  connect(swi1.y, y)
    annotation (Line(points={{81,0},{110,0}}, color={0,0,127}));
  annotation (defaultComponentName="outTemCon",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid), Text(
        extent={{-148,150},{152,110}},
        textString="%name",
        lineColor={0,0,255})}), Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This model controls the outlet fluid temperature by regulating the associated valves.
<ul>
<li>For Dormant mode, the bypass valve 2 is fully open, and valve 1 is fully closed.</li>
<li>For Charging mode, the bypass valve 2 is fully closed, and valve 1 is fully open.</li>
<li>For Discharging mode, the bypass valve 2 is regulated to maintain a given outlet temperature setpoint using a PI controller.</li>
</ul>
</p>
</html>", revisions="<html>
<ul>
<li>
December 8, 2021, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end OutletTemperatureControl;
