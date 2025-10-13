within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors;
model SquirrelCageDrive
  "Squirrel cage type induction motor with electrical interface and closed loop built-in speed control"
  extends Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.BaseClasses.PartialSquirrelCage(
    have_speCon=true,
    redeclare final Modelica.Blocks.Math.Product conVol "Controlled voltage");

  parameter Boolean reverseActing=true
    "Default: Set to true in heating and set to false in cooling mode"
    annotation(Dialog(enable=have_speCon,group="Controller", tab="Advanced"));
  parameter Real r=1
    "Typical range of control error, used for scaling the control error"
    annotation(Dialog(enable=have_speCon,group="Controller", tab="Advanced"));
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerType=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation (Dialog(tab="Advanced", group="Controller", enable=have_speCon));
  parameter Real k(min=0) = 1
    "Gain of controller"
    annotation (Dialog(tab="Advanced", group="Controller", enable=have_speCon));
  parameter Modelica.Units.SI.Time Ti(min=Modelica.Constants.small)=1
    "Time constant of Integrator block"
    annotation (Dialog(tab="Advanced", group="Controller",
                       enable=have_speCon and
                              controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
                              or controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Modelica.Units.SI.Time Td(min=0) = 0.1
    "Time constant of Derivative block"
    annotation (Dialog(tab="Advanced", group="Controller",
                       enable=have_speCon and
                              controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
                              or controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real yMax(start=1)=1
    "Upper limit of output"
     annotation (Dialog(tab="Advanced", group="Controller", enable=have_speCon));
  parameter Real yMin=0
    "Lower limit of output"
    annotation (Dialog(tab="Advanced", group="Controller", enable=have_speCon));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput setPoi if have_speCon
    "Set point of control target"
    annotation (Placement(transformation(extent={{-200,40},{-160,80}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mea if have_speCon
    "Measured value of control target"
    annotation (Placement(transformation(extent={{-200,10},{-160,50}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput tau_m(
    final unit="N.m")
    "Load torque"
    annotation (Placement(transformation(extent={{-200,-100},{-160,-60}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));

  Buildings.Controls.OBC.CDL.Reals.PID speCon(
    final controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    final Td=Td,
    final r=r,
    final yMax=yMax,
    final yMin=yMin,
    final k=k,
    final Ti=Ti,
    final reverseActing=reverseActing) if have_speCon
    "PI controller as variable frequency drive"
    annotation (Placement(transformation(extent={{-140,50},{-120,70}})));
  Modelica.Blocks.Math.Product conFre "Controlled frequency"
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai(
    final k=1/(2*Modelica.Constants.pi)) "Convert rad/s to Hz"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply mul "Controlled frequency in rad/s"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con(final k=1) if not have_speCon
    "Constant one"
    annotation (Placement(transformation(extent={{-140,-10},{-120,10}})));

equation
  connect(int.y, curBlo.wt) annotation (Line(points={{41,80},{50,80},{50,48},{58,
          48}}, color={0,0,127}));
  connect(torSpe.i_ds, curBlo.i_ds)
    annotation (Line(points={{42,6},{50,6},{50,40},{58,40}}, color={0,0,127}));
  connect(torSpe.i_qs, curBlo.i_qs)
    annotation (Line(points={{42,0},{54,0},{54,32},{58,32}}, color={0,0,127}));
  connect(speBlo.omega_r, torSpe.omega_r) annotation (Line(points={{2,-74},{10,-74},
          {10,-6},{18,-6}}, color={0,0,127}));
  connect(torSpe.tau_e, speBlo.tau_e) annotation (Line(points={{42,-6},{50,-6},
          {50,-40},{-30,-40},{-30,-74},{-22,-74}}, color={0,0,127}));
  connect(speBlo.omega_r1, spe.w_ref) annotation (Line(points={{2,-80},{60,-80},
          {60,0},{70,0}}, color={0,0,127}));
  connect(spe.flange, shaft)
    annotation (Line(points={{92,0},{100,0}}, color={0,0,0}));
  connect(tau_m, speBlo.tau_m)
    annotation (Line(points={{-180,-80},{-22,-80}},
          color={0,0,127}));
  connect(conFre.y, torSpe.f)
    annotation (Line(points={{-19,-10},{-10,-10},{-10,0},{18,0}}, color={0,0,127}));
  connect(conVol.y, torSpe.V_rms) annotation (Line(points={{-19,30},{10,30},{10,
          6},{18,6}}, color={0,0,127}));
  connect(rmsVol.y, conVol.u1) annotation (Line(points={{-59,50},{-50,50},{-50,36},
          {-42,36}}, color={0,0,127}));
  connect(gai.y, conFre.u2) annotation (Line(points={{-58,-30},{-50,-30},{-50,-16},
          {-42,-16}},color={0,0,127}));
  connect(volAngFre.y, gai.u) annotation (Line(points={{-19,80},{-10,80},{-10,60},
          {-100,60},{-100,-30},{-82,-30}}, color={0,0,127}));
  connect(setPoi, speCon.u_s) annotation (Line(points={{-180,60},{-142,60}},
                          color={0,0,127}));
  connect(mea, speCon.u_m)
    annotation (Line(points={{-180,30},{-130,30},{-130,48}}, color={0,0,127}));
  connect(volAngFre.y, mul.u2) annotation (Line(points={{-19,80},{-10,80},{-10,60},
          {-100,60},{-100,-66},{-82,-66}}, color={0,0,127}));
  connect(mul.y, int.u) annotation (Line(points={{-58,-60},{0,-60},{0,80},{18,80}},
        color={0,0,127}));
  connect(mul.y, speBlo.omega) annotation (Line(points={{-58,-60},{-40,-60},{-40,
          -86},{-22,-86}}, color={0,0,127}));
  connect(volPhaAng.y, volAngFre.u)
    annotation (Line(points={{-59,80},{-42,80}}, color={0,0,127}));
  connect(speCon.y, conVol.u2) annotation (Line(points={{-118,60},{-110,60},{-110,
          24},{-42,24}}, color={0,0,127}));
  connect(conFre.u1, speCon.y) annotation (Line(points={{-42,-4},{-60,-4},{-60,24},
          {-110,24},{-110,60},{-118,60}}, color={0,0,127}));
  connect(mul.u1, speCon.y) annotation (Line(points={{-82,-54},{-110,-54},{-110,
          60},{-118,60}},                 color={0,0,127}));
  connect(con.y, conVol.u2) annotation (Line(points={{-118,0},{-110,0},{-110,24},
          {-42,24}}, color={0,0,127}));
  connect(con.y, conFre.u1) annotation (Line(points={{-118,0},{-110,0},{-110,24},
          {-60,24},{-60,-4},{-42,-4}}, color={0,0,127}));
  connect(con.y, mul.u1) annotation (Line(points={{-118,0},{-110,0},{-110,-54},{
          -82,-54}}, color={0,0,127}));
 annotation(defaultComponentName="motDri",
    Documentation(info="<html>
<p>
This block implements a dynamic model of a three-phase squirrel-cage induction motor
with a built-in closed-loop speed control. It adjusts the applied electrical frequency
to track the given speed or frequency setpoint while driving a mechanical load
(<i>&tau;<sub>m</sub></i>).
</p>
<p>
<b>
The model extends
<a href=\"modelica://Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.BaseClasses.PartialSquirrelCage\">
PartialSquirrelCage</a> with <code>have_speCon = true</code> and includes
an internal PI-based variable frequency drive (VFD) controller that regulates
the electrical input frequency and voltage to maintain the desired rotor speed.
</b>
</p>
<p>
<b>Inputs:</b> Setpoint (<i>&omega;<sub>ref</sub></i> or speed) [rad/s],
Measured speed (<i>&omega;<sub>r</sub></i>) [rad/s], Load torque (<i>&tau;<sub>m</sub></i>) [N·m] &nbsp; | &nbsp;
<b>Outputs:</b> Rotor speed (<i>&omega;<sub>r</sub></i>) [rad/s],
Electromagnetic torque (<i>&tau;<sub>e</sub></i>) [N·m],
Stator currents (<i>i<sub>ds</sub></i>, <i>i<sub>qs</sub></i>) [A]
</p>
</html>", revisions="<html>
<ul>
<li>
May 07, 2024, by Viswanathan Ganesh and Zhanwei He:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-160,-100},{100,100}})));
end SquirrelCageDrive;
