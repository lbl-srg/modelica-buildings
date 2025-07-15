within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors;
model SquirrelCageDrive
  "Squirrel cage type induction motor with electrical interface and closed loop built-in speed control"
  extends Buildings.Electrical.Interfaces.PartialOnePort(
    redeclare package PhaseSystem = Buildings.Electrical.PhaseSystems.OnePhase,
    redeclare replaceable Interfaces.Terminal_n terminal);

  replaceable parameter Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.Data.Generic per
    constrainedby Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.Data.Generic
    "Record with Induction Machine performance data"
    annotation (choicesAllMatching=true, Placement(transformation(extent={{60,64},{80,84}})));
  parameter Boolean reverseActing = true
  "Default: Set to true for reverseActing in heating and set to false in cooling mode";
  parameter Boolean have_controller = true
    "Set to true for enable PID control, False for simple speed control";
  parameter Modelica.Blocks.Types.SimpleController controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation (Dialog(tab="Advanced", group="Controller"));
  parameter Real k(min=0) = 1
    "Gain of controller"
    annotation (Dialog(tab="Advanced", group="Controller"));
  parameter Modelica.Units.SI.Time Ti(min=Modelica.Constants.small)=1
    "Time constant of Integrator block"
    annotation (Dialog(tab="Advanced", group="Controller",
                       enable=controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
                              or controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Modelica.Units.SI.Time Td(min=0) = 0.1
    "Time constant of Derivative block"
    annotation (Dialog(tab="Advanced", group="Controller",
                       enable=controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
                              or controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real yMax(start=1)=1
    "Upper limit of output"
     annotation (Dialog(tab="Advanced", group="Controller"));
  parameter Real yMin=0
    "Lower limit of output"
    annotation (Dialog(tab="Advanced", group="Controller"));

  Real v_rms "RMS voltage";
  Modelica.Units.SI.Angle theta_s "Supply voltage phase angel";
  Modelica.Units.SI.AngularVelocity omega "Supply voltage angular frequency";
  Modelica.Units.SI.Voltage v[:] = terminal.v "Voltage vector";
  Modelica.Units.SI.Current i[:] = terminal.i "Current vector";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput setPoi
    "Set point of control target"
    annotation (Placement(transformation(extent={{-180,50},{-140,90}}),
        iconTransformation(extent={{-180,60},{-140,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mea
    "Measured value of control target"
    annotation (Placement(transformation(extent={{-180,-20},{-140,20}}),
        iconTransformation(extent={{-180,-20},{-140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput tau_m(
    final unit="N.m")
    "Load torque"
    annotation (Placement(transformation(extent={{-180,-90},{-140,-50}}),
        iconTransformation(extent={{-180,-100},{-140,-60}})));

  Modelica.Blocks.Sources.RealExpression Vrms(
    y=v_rms)
    "RMS voltage"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Modelica.Blocks.Sources.RealExpression fre(
    y=omega/(2*Modelica.Constants.pi))
    "Supply voltage frequency"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Modelica.Blocks.Math.Product conFre "Controlled frequency"
    annotation (Placement(transformation(extent={{-20,-20},{0,0}})));
  Modelica.Blocks.Math.Product conVol "Controlled voltage"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  Modelica.Blocks.Continuous.Integrator int
    annotation (Placement(transformation(extent={{0,60},{20,80}})));
  Modelica.Blocks.Sources.RealExpression angFre(y=swi.y*omega)
    "Supply voltage angular frequency" annotation (Placement(transformation(
          extent={{-10,-10},{10,10}}, origin={-70,-90})));
  Modelica.Mechanics.Rotational.Interfaces.Flange_b shaft
    "Mechanical connector"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Modelica.Mechanics.Rotational.Sources.Speed spe(
    useSupport=false,
    exact=true,
    phi(fixed=true)) "Speed connector"
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));
  Modelica.Blocks.Sources.RealExpression angFre1(y=swi.y*omega)
    "Supply voltage angular frequency" annotation (Placement(transformation(
          extent={{-10,-10},{10,10}}, origin={-70,70})));
  Modelica.Blocks.Math.Gain vfdEquFre(final k=per.P/120)
    "VFD equivalent frequency"
    annotation (Placement(transformation(extent={{-120,60},{-100,80}})));
  Buildings.Controls.OBC.CDL.Reals.PID VFD(
    final controllerType=Modelica.Blocks.Types.SimpleController.PI,
    final Td=Td*2,
    final yMax=yMax,
    final yMin=yMin,
    final k=k,
    final Ti=Ti,
    final reverseActing=reverseActing)
    "PI controller as variable frequency drive"
    annotation (Placement(transformation(extent={{-120,10},{-100,30}})));
  Modelica.Blocks.Logical.Switch swi
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  Modelica.Blocks.Sources.BooleanExpression havCon(y=have_controller)
    "Have controller"
    annotation (Placement(transformation(extent={{-120,-20},{-100,0}})));
  Modelica.Blocks.Sources.RealExpression realExpression(
    y=setPoi/(120*per.Freq/per.P))
    annotation (Placement(transformation(extent={{-120,-40},{-100,-20}})));
  Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.BaseClasses.CurrentBlock curBlo
    "Calculates current of induction machine rotor"
    annotation (Placement(transformation(extent={{60,30},{80,50}})));
  Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.BaseClasses.MotorMachineInterface torSpe(
    final P=per.P,
    final J=per.J,
    final Lr=per.Lr,
    final Ls=per.Ls,
    final Rr=per.Rr,
    final Lm=per.Lm,
    final Rs=per.Rs)
    "Calculates Electromagnetic torque of induction machine"
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  BaseClasses.SpeedBlock speBlo(J=per.J, P=per.P)
   "Calculates Speed of induction machine rotor"
   annotation (Placement(transformation(extent={{-20,-80},{0,-60}})));

equation
  // Assign values for motor model calculation from electrical interface
  theta_s = PhaseSystem.thetaRef(terminal.theta);
  omega = der(theta_s);
  v_rms=Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.BaseClasses.RMS_Voltage(v[1],v[2]); // Equations to calculate current
  i[1] =Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.BaseClasses.CurrentCalculationD_VFD(torSpe.motMod.i_ds,conVol.y,v_rms);
  i[2] =Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.BaseClasses.CurrentCalculationQ_VFD(torSpe.motMod.i_qs,conVol.y,v_rms);

  connect(Vrms.y,conVol. u1) annotation (Line(points={{-59,40},{-50,40},{-50,36},
          {-22,36}}, color={0,0,127}));
  connect(torSpe.V_rms,conVol. y) annotation (Line(points={{18,-4},{10,-4},{10,
          30},{1,30}},   color={0,0,127}));
  connect(torSpe.f,conFre. y)
    annotation (Line(points={{18,-10},{1,-10}},   color={0,0,127}));
  connect(speBlo.tau_m, tau_m) annotation (Line(points={{-22,-70},{-160,-70}},
          color={0,0,127}));
  connect(angFre1.y, int.u)
    annotation (Line(points={{-59,70},{-2,70}}, color={0,0,127}));
  connect(speBlo.omega, angFre.y) annotation (Line(points={{-22,-76},{-30,-76},
          {-30,-90},{-59,-90}},color={0,0,127}));
  connect(vfdEquFre.u, setPoi)
    annotation (Line(points={{-122,70},{-160,70}}, color={0,0,127}));
  connect(VFD.u_s, setPoi) annotation (Line(points={{-122,20},{-130,20},{-130,70},
          {-160,70}}, color={0,0,127}));
  connect(VFD.u_m, mea) annotation (Line(points={{-110,8},{-110,0},{-160,0}},
          color={0,0,127}));
  connect(spe.flange, shaft)
    annotation (Line(points={{90,0},{100,0}}, color={0,0,0}));
  connect(torSpe.omega_r, speBlo.omega_r) annotation (Line(points={{18,-16},{10,
          -16},{10,-64},{2,-64}}, color={0,0,127}));
  connect(speBlo.omega_r1, spe.w_ref) annotation (Line(points={{2,-70},{60,-70},
          {60,0},{68,0}}, color={0,0,127}));
  connect(fre.y,conFre. u2)
    annotation (Line(points={{-59,-50},{-40,-50},{-40,-16},{-22,-16}},
         color={0,0,127}));
  connect(conFre.u1,conVol. u2) annotation (Line(points={{-22,-4},{-40,-4},{-40,
          24},{-22,24}}, color={0,0,127}));
  connect(torSpe.tau_e, speBlo.tau_e) annotation (Line(points={{42,-10},{50,-10},
          {50,-40},{-30,-40},{-30,-64},{-22,-64}},
        color={0,0,127}));
  connect(swi.y, conVol.u2) annotation (Line(points={{-59,-10},{-40,-10},{-40,
          24},{-22,24}}, color={0,0,127}));
  connect(swi.u1, VFD.y) annotation (Line(points={{-82,-2},{-90,-2},{-90,20},{-98,
          20}}, color={0,0,127}));
  connect(havCon.y, swi.u2)
    annotation (Line(points={{-99,-10},{-82,-10}}, color={255,0,255}));
  connect(realExpression.y, swi.u3) annotation (Line(points={{-99,-30},{-90,-30},
          {-90,-18},{-82,-18}}, color={0,0,127}));
  connect(int.y, curBlo.wt) annotation (Line(points={{21,70},{46,70},{46,48},{
          58,48}}, color={0,0,127}));
  connect(torSpe.i_ds, curBlo.i_ds) annotation (Line(points={{42,-2},{46,-2},{46,
          40},{58,40}}, color={0,0,127}));
  connect(torSpe.i_qs, curBlo.i_qs) annotation (Line(points={{42,-5},{52,-5},{52,
          32},{58,32}}, color={0,0,127}));
 annotation(Icon(coordinateSystem(preserveAspectRatio=true,
        extent={{-140,-100},{100,100}}), graphics={
        Rectangle(
          origin={0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          extent={{-80,-60},{80,60}}),
        Rectangle(
          origin={0,0},
          fillColor={128,128,128},
          fillPattern=FillPattern.HorizontalCylinder,
          extent={{-80,-60},{-60,60}}),
        Rectangle(
          origin={20,0},
          fillColor={95,95,95},
          fillPattern=FillPattern.HorizontalCylinder,
          extent={{60,-10},{80,10}}),
        Rectangle(
          origin={0.626262,-10},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid,
          extent={{-60.6263,50},{20.2087,70}}),
        Polygon(
          origin={2.835,0},
          fillPattern=FillPattern.Solid,
          points={{-70,-90},{-60,-90},{-30,-20},{20,-20},{50,-90},{60,-90},
          {60,-100},{-70,-100},{-70,-90}}),
        Text(
          extent={{-82,162},{82,116}},
          textColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.None,
          textString="%name")}),
        defaultComponentName="motDri",
    Documentation(info="<html>
<p>
This model implements an induction motor model with a built-in idealized 
frequency control that tracks the set point and adjust the input frequency of 
motor.
</p>
<p>
The model is identical to 
<a href=\"modelica://Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors1.SquirrelCage\">
Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors1.
SquirrelCage</a>, except that it takes the set point, as an input and adjust 
the motor torque output to meet the set point. This set point is maintained 
if the motor allows sufficient torque to meet the load requirement. The built-in 
control is an ideal speed controller, implemented using a PI controller. 
The controller adjusts the torque output of the motor to meet the set point 
within its work area.
</p>
</html>", revisions="<html>
<ul>
<li>
May 07, 2024, by Viswanathan Ganesh and Zhanwei He:<br>
First Implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-140,-100},{100,100}})));
end SquirrelCageDrive;
