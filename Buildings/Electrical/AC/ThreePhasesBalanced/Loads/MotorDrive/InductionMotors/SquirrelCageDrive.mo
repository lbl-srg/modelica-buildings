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
    annotation (Placement(transformation(extent={{-180,-10},{-140,30}}),
        iconTransformation(extent={{-180,-20},{-140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput tau_m(
    final unit="N.m")
    "Load torque"
    annotation (Placement(transformation(extent={{-180,-90},{-140,-50}}),
        iconTransformation(extent={{-180,-100},{-140,-60}})));

  Modelica.Blocks.Sources.RealExpression Vrms(
    y=v_rms)
    "RMS voltage"
    annotation (Placement(transformation(extent={{-76,46},{-56,66}})));
  Modelica.Blocks.Sources.RealExpression fre(
    y=omega/(2*Modelica.Constants.pi))
    "Supply voltage frequency"
    annotation (Placement(transformation(extent={{-70,-60},{-50,-40}})));
  Modelica.Blocks.Math.Product VFDfre "Controlled frequency"
    annotation (Placement(transformation(extent={{-20,-20},{0,0}})));
  Modelica.Blocks.Math.Product VFDvol "Controlled voltage"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  Modelica.Blocks.Continuous.Integrator integrator
    annotation (Placement(transformation(extent={{-2,60},{18,80}})));
  Modelica.Blocks.Sources.RealExpression i_ds(
    y=torSpe.motMod.i_ds)
    annotation (Placement(transformation(extent={{-10,-12},{10,12}}, origin={30,40})));
  Modelica.Blocks.Sources.RealExpression i_qs(
    y=torSpe.motMod.i_qs)
    annotation (Placement(transformation(extent={{-10,-12},{10,12}}, origin={30,24})));
  Modelica.Blocks.Sources.RealExpression angFre(
    y=switch1.y*omega)
    "Supply voltage angular frequency"
    annotation (Placement(transformation(extent={{-10,-12},{10,12}}, origin={-24,-88})));
  Modelica.Mechanics.Rotational.Interfaces.Flange_b shaft
    "Mechanical connector"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Modelica.Mechanics.Rotational.Sources.Speed speed(
    useSupport=false,
    exact=true,
    phi(fixed=true))
    "Speed connector"
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));
  Modelica.Blocks.Sources.RealExpression angFre1(
    y=switch1.y*omega)
    "Supply voltage angular frequency"
    annotation (Placement(transformation(extent={{-10,-12},{10,12}}, origin={-66,70})));
  Modelica.Blocks.Math.Gain VFD_Equivalent_Freq(k=per.P/120)
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
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  Modelica.Blocks.Logical.Switch switch1
    annotation (Placement(transformation(extent={{-60,-14},{-40,6}})));
  Modelica.Blocks.Sources.BooleanExpression booleanExpression(
    y=have_controller)
    annotation (Placement(transformation(extent={{-118,-14},{-98,6}})));
  Modelica.Blocks.Sources.RealExpression realExpression(
    y=setPoi/(120*per.Freq/per.P))
    annotation (Placement(transformation(extent={{-120,-28},{-100,-8}})));
  BaseClasses.CurrentBlock current_Block
    "Calculates current of induction machine rotor"
    annotation (Placement(transformation(extent={{60,30},{80,50}})));
  BaseClasses.MotorMachineInterface torSpe(
    P=per.P,
    J=per.J,
    Lr=per.Lr,
    Ls=per.Ls,
    Rr=per.Rr,
    Lm=per.Lm,
    Rs=per.Rs)
    "Calculates Electromagnetic torque of induction machine"
    annotation (Placement(transformation(extent={{18,-14},{32,0}})));
  BaseClasses.SpeedBlock speBlo(J=per.J, P=per.P)
   "Calculates Speed of induction machine rotor"
   annotation (Placement(transformation(extent={{26,-80},{46,-60}})));

equation
  // Assign values for motor model calculation from electrical interface
  theta_s = PhaseSystem.thetaRef(terminal.theta);
  omega = der(theta_s);
  v_rms=Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.BaseClasses.RMS_Voltage(v[1],v[2]); // Equations to calculate current
  i[1] =Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.BaseClasses.CurrentCalculationD_VFD(torSpe.motMod.i_ds,VFDvol.y,v_rms);
  i[2] =Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.BaseClasses.CurrentCalculationQ_VFD(torSpe.motMod.i_qs,VFDvol.y,v_rms);

  connect(Vrms.y, VFDvol.u1) annotation (Line(points={{-55,56},{-28,56},{-28,36},
          {-22,36}}, color={0,0,127}));
  connect(torSpe.V_rms, VFDvol.y) annotation (Line(points={{16.6,-2.8},{16.6,30},
          {1,30}},       color={0,0,127}));
  connect(torSpe.f, VFDfre.y)
    annotation (Line(points={{16.6,-7},{10.0714,-7},{10.0714,-10},{1,-10}},
                                               color={0,0,127}));
  connect(speBlo.tau_m, tau_m) annotation (Line(points={{24,-70},{-160,-70}},
                            color={0,0,127}));
  connect(angFre1.y, integrator.u) annotation (Line(points={{-55,70},{-4,70}},
                                 color={0,0,127}));
  connect(speBlo.omega, angFre.y) annotation (Line(points={{24,-76},{-8,-76},{-8,
          -88},{-13,-88}},                    color={0,0,127}));
  connect(VFD_Equivalent_Freq.u, setPoi)
    annotation (Line(points={{-122,70},{-160,70}}, color={0,0,127}));
  connect(VFD.u_s, setPoi) annotation (Line(points={{-102,30},{-130,30},{-130,70},
          {-160,70}},          color={0,0,127}));
  connect(VFD.u_m, mea) annotation (Line(points={{-90,18},{-90,10},{-160,10}},
                                color={0,0,127}));
  connect(speed.flange, shaft)
    annotation (Line(points={{90,0},{100,0}}, color={0,0,0}));
  connect(torSpe.omega_r, speBlo.omega_r) annotation (Line(points={{16.6,-11.2},
          {4,-11.2},{4,-26},{52,-26},{52,-64},{48,-64}}, color={0,0,127}));
  connect(speBlo.omega_r1, speed.w_ref) annotation (Line(points={{48,-70},{60,
          -70},{60,0},{68,0}},                          color={0,0,127}));
  connect(fre.y, VFDfre.u2)
    annotation (Line(points={{-49,-50},{-28,-50},{-28,-16},{-22,-16}},
                                                 color={0,0,127}));
  connect(VFDfre.u1, VFDvol.u2) annotation (Line(points={{-22,-4},{-28,-4},{-28,
          24},{-22,24}},
                     color={0,0,127}));
  connect(torSpe.tau_e, speBlo.tau_e) annotation (Line(points={{33.4,-7},{50,-7},
          {50,-42},{16,-42},{16,-64},{24,-64}},
        color={0,0,127}));
  connect(switch1.y, VFDvol.u2) annotation (Line(points={{-39,-4},{-28,-4},{-28,
          24},{-22,24}}, color={0,0,127}));
  connect(switch1.u1, VFD.y) annotation (Line(points={{-62,4},{-74,4},{-74,30},{
          -78,30}}, color={0,0,127}));
  connect(booleanExpression.y, switch1.u2)
    annotation (Line(points={{-97,-4},{-62,-4}}, color={255,0,255}));
  connect(realExpression.y, switch1.u3) annotation (Line(points={{-99,-18},{-72,
          -18},{-72,-12},{-62,-12}}, color={0,0,127}));
  connect(integrator.y, current_Block.wt) annotation (Line(points={{19,70},{46,
          70},{46,48},{58,48}}, color={0,0,127}));
  connect(i_ds.y, current_Block.i_ds)
    annotation (Line(points={{41,40},{58,40}}, color={0,0,127}));
  connect(i_qs.y, current_Block.i_qs) annotation (Line(points={{41,24},{52,24},
          {52,32},{58,32}}, color={0,0,127}));
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
<li>May 07, 2024, by Viswanathan Ganesh and Zhanwei He:<br>First Implementation. </li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-140,-100},{100,100}})));
end SquirrelCageDrive;
