within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive;
package InductionMotors
  model SquirrelCage
    "Squirrel cage type induction motor with electrical interface"
    extends Buildings.Electrical.Interfaces.PartialOnePort(
     redeclare package PhaseSystem =
          Buildings.Electrical.PhaseSystems.OnePhase,
     redeclare replaceable Interfaces.Terminal_n terminal);
     replaceable parameter
      Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.Data.Generic
      per constrainedby
      Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.Data.Generic
      "Record with performance data" annotation (choicesAllMatching=true,
        Placement(transformation(extent={{52,60},{72,80}})));
    parameter Integer P=per.P "Number of poles";
    parameter Real J=per.J "Moment of inertia";
    parameter Real Lr=per.Lr "Rotor inductance [H]";
    parameter Real Ls=per.Ls "Stator inductance [H]";
    parameter Real Lm=per.Lm "Mutual inductance [H]";
    parameter Real Rr=per.Rr "Rotor resistance [ohm]";
    parameter Real Rs=per.Rs "Stator resistance [ohm]";
              Real i_rms "RMS current";
              Real v_rms "RMS voltage";
              Real pow_gap "Power gap";

    Modelica.Units.SI.Angle theta_s
      "Supply voltage phase angel";
    Modelica.Units.SI.AngularVelocity omega
      "Supply voltage angular frequency";

    Modelica.Units.SI.Voltage v[:] = terminal.v
      "Voltage vector";
    Modelica.Units.SI.Current i[:] = terminal.i
      "Current vector";
    final Modelica.Blocks.Sources.RealExpression Vrms(y=v_rms) "RMS voltage"
      annotation (Placement(transformation(extent={{-60,10},{-40,30}})));

    final Modelica.Blocks.Sources.RealExpression fre(y=omega/(2*Modelica.Constants.pi))
      "Supply voltage frequency"
      annotation (Placement(transformation(extent={{-64,-10},{-44,10}})));

    Modelica.Blocks.Interfaces.RealInput tau_m(unit="N.m")
      "Load torque"
      annotation (Placement(transformation(
          extent={{-20,-20},{20,20}},
          rotation=0,
          origin={-120,-80}),
          iconTransformation(
          extent={{-20,-20},{20,20}},
          rotation=0,
          origin={-120,-80})));

    InductionMotors.BaseClasses.CurrentBlock current_Block
      annotation (Placement(transformation(extent={{60,30},{80,50}})));
    InductionMotors.BaseClasses.SpeedBlock speBlo(final J=J, final P=P)
      annotation (Placement(transformation(extent={{-10,-66},{10,-44}})));
    Modelica.Blocks.Continuous.Integrator integrator
      annotation (Placement(transformation(extent={{-2,60},{18,80}})));
    Modelica.Blocks.Sources.RealExpression i_ds(y=torSpe.motMod.i_ds)
      annotation (
        Placement(transformation(extent={{-10,-12},{10,12}}, origin={30,40})));
    Modelica.Blocks.Sources.RealExpression i_qs(y=torSpe.motMod.i_qs)
      annotation (
        Placement(transformation(extent={{-10,-12},{10,12}}, origin={30,24})));
    Modelica.Blocks.Sources.RealExpression eleTor(y=torSpe.tau_e)
      annotation (
        Placement(transformation(extent={{-10,-12},{10,12}}, origin={-32,-42})));
    Modelica.Blocks.Sources.RealExpression angFre(y=omega)
      "Supply voltage angular frequency" annotation (Placement(transformation(
            extent={{-10,-12},{10,12}}, origin={-32,-68})));
    InductionMotors.BaseClasses.MotorMachineInterface torSpe(
      final P=P,
      final Lm=Lm,
      final J=J,
      final Lr=Lr,
      final Ls=Ls,
      final Rr=Rr,
      final Rs=Rs)
      annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
    Modelica.Blocks.Sources.RealExpression angFre1(y=omega)
      "Supply voltage angular frequency" annotation (Placement(transformation(
            extent={{-10,-12},{10,12}}, origin={-30,70})));
    Modelica.Mechanics.Rotational.Sources.Speed speed(exact=true)
      "Speed connector"
      annotation (Placement(transformation(extent={{64,-8},{80,8}})));
    Modelica.Mechanics.Rotational.Interfaces.Flange_b shaft
      "Mechanical connector"
      annotation (Placement(transformation(extent={{90,-10},{110,10}})));

  equation
    // Assign values for motor model calculation from electrical interface
    theta_s = PhaseSystem.thetaRef(terminal.theta) "phase angle";
    omega = der(theta_s);
    v_rms=sqrt(v[1]^2+v[2]^2);
    pow_gap = speBlo.N/9.55*torSpe.tau_e;
    // Equations to calculate current
    i[1] = 2*(sqrt(2)/sqrt(3))*torSpe.motMod.i_ds;
    i[2] =(sqrt(3)/sqrt(2))*torSpe.motMod.i_qs;
    i_rms=sqrt(i[1]^2+i[2]^2);
    connect(integrator.y,current_Block. wt) annotation (Line(points={{19,70},{50,70},
            {50,48},{58,48}},        color={0,0,127}));
    connect(i_ds.y, current_Block.i_ds) annotation (Line(points={{41,40},{58,40}},
                          color={0,0,127}));
    connect(i_qs.y, current_Block.i_qs)
      annotation (Line(points={{41,24},{50,24},{50,32},{58,32}},
                                                 color={0,0,127}));
    connect(integrator.u, angFre1.y) annotation (Line(points={{-4,70},{-19,70}},
                           color={0,0,127}));
    connect(speBlo.tau_e, eleTor.y) annotation (Line(points={{-12,-48.4},{-21,-48.4},
            {-21,-42}},           color={0,0,127}));
    connect(speBlo.tau_m, tau_m) annotation (Line(points={{-12,-55},{-60,-55},{-60,
            -80},{-120,-80}}, color={0,0,127}));
    connect(speBlo.omega, angFre.y) annotation (Line(points={{-12,-61.6},{-16,-61.6},
            {-16,-68},{-21,-68}},           color={0,0,127}));
    connect(torSpe.omega_r, speBlo.omega_r) annotation (Line(points={{-18.5714,
            -10},{-40,-10},{-40,-18},{18,-18},{18,-48.29},{11.9,-48.29}},
                                                               color={0,0,127}));
    connect(fre.y, torSpe.f)
      annotation (Line(points={{-43,0},{-26,0},{-26,-1.42857},{-12.8571,
            -1.42857}},                          color={0,0,127}));
    connect(Vrms.y, torSpe.V_rms) annotation (Line(points={{-39,20},{-18,20},{
            -18,7.14286},{-18.5714,7.14286}},
                         color={0,0,127}));
    connect(speed.flange, shaft)
      annotation (Line(points={{80,0},{100,0}}, color={0,0,0}));
    connect(speed.w_ref, speBlo.omega_r) annotation (Line(points={{62.4,0},{40,0},
            {40,-48},{26,-48},{26,-48.29},{11.9,-48.29}}, color={0,0,127}));
   annotation(Icon(coordinateSystem(preserveAspectRatio=true,
          extent={{-100,-100},{100,100}}), graphics={
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
<p>This model implements an induction motor model. The model takes the set point of load torque, 
as an input and simulates a transient simulation when the motor is operating in its rated speed and setpoint load torque. </p>
</html>",   revisions="<html>
<ul>
<li>May 07, 2024, by Viswanathan Ganesh and Zhanwei He:<br>First Implementation. </li>
</ul>
</html>
"));
  end SquirrelCage;

  model SquirrelCageDrive
    "Squirrel cage type induction motor with electrical interface and closed loop built-in speed control"
    extends Buildings.Electrical.Interfaces.PartialOnePort(
     redeclare package PhaseSystem =
          Buildings.Electrical.PhaseSystems.OnePhase,
     redeclare replaceable Interfaces.Terminal_n terminal);
       replaceable parameter
      Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.Data.Generic
      per constrainedby
      Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.Data.Generic
      "Record with performance data" annotation (choicesAllMatching=true,
        Placement(transformation(extent={{52,60},{72,80}})));
    parameter Integer P=per.P "Number of poles";
    parameter Real J=per.J "Moment of inertia";
    parameter Real Lr=per.Lr "Rotor inductance [H]";
    parameter Real Ls=per.Ls "Stator inductance [H]";
    parameter Real Lm=per.Lm "Mutual inductance [H]";
    parameter Real Rr=per.Rr "Rotor resistance [ohm]";
    parameter Real Rs=per.Rs "Stator resistance [ohm]";

    //-----------------------------------------------
    // parameter Integer P=4      "Number of poles";
    //parameter Real J=0.17    "Moment of inetia";
    //parameter Real Lr=0.1458    "Rotor inductance [H]";
    //parameter Real Ls=0.1457    "Stator inductance [H]";
    //parameter Real Rr=1.145   "Rotor resistance [ohm]";
    //parameter Real Lm=0.1406   "Mutual inductance [H]";
    //parameter Real Rs=1   "Stator resistance [ohm]";
    //-------------------------------------------------

    parameter Boolean have_controller = true
      "Set to true for enable PID control, False for simple speed control";
    parameter Boolean reverseActing=true
       "Set to true for reverseActing in heating and set to false in cooling mode";
    parameter Modelica.Blocks.Types.SimpleController
    controllerType=Modelica.Blocks.Types.SimpleController.PI
       "Type of controller"
        annotation (Dialog(tab="Advanced",
                           group="Controller",
                           enable=true));
    parameter Real k(min=0) = 1
       "Gain of controller"
        annotation (Dialog(tab="Advanced",
                           group="Controller",
                           enable=true));
    parameter Modelica.Units.SI.Time Ti(min=Modelica.Constants.small)=0.5
       "Time constant of Integrator block"
        annotation (Dialog(tab="Advanced",
                           group="Controller",
                           enable=true and
    controllerType == Modelica.Blocks.Types.SimpleController.PI or
    controllerType == Modelica.Blocks.Types.SimpleController.PID));
    parameter Modelica.Units.SI.Time Td(min=0) = 0.1
       "Time constant of Derivative block"
        annotation (Dialog(tab="Advanced",
                           group="Controller",
                           enable=true and
    controllerType == Modelica.Blocks.Types.SimpleController.PD or
    controllerType == Modelica.Blocks.Types.SimpleController.PID));
    parameter Real yMax(start=1)=1
      "Upper limit of output"
       annotation (Dialog(tab="Advanced",
                         group="Controller",
                         enable=true));
    parameter Real yMin=0
      "Lower limit of output"
       annotation (Dialog(tab="Advanced",
                         group="Controller",
                         enable=true));

    Real v_rms "RMS voltage";
    Real i_rms "RMS current";
    Real  pow_gap;
    Modelica.Units.SI.Angle theta_s "Supply voltage phase angel";
    Modelica.Units.SI.AngularVelocity omega "Supply voltage angular frequency";
    Modelica.Units.SI.Voltage v[:] = terminal.v "Voltage vector";
    Modelica.Units.SI.Current i[:] = terminal.i "Current vector";

    final Modelica.Blocks.Sources.RealExpression Vrms(y=v_rms) "RMS voltage"
      annotation (Placement(transformation(extent={{-76,46},{-56,66}})));
    final Modelica.Blocks.Sources.RealExpression fre(y=omega/(2*Modelica.Constants.pi))
      "Supply voltage frequency"
      annotation (Placement(transformation(extent={{-70,-60},{-50,-40}})));
    Modelica.Blocks.Math.Product VFDfre "Controlled frequency"
      annotation (Placement(transformation(extent={{-20,-20},{0,0}})));
    Modelica.Blocks.Math.Product VFDvol "Controlled voltage"
      annotation (Placement(transformation(extent={{-20,20},{0,40}})));

    Modelica.Blocks.Interfaces.RealInput setPoi "Set point of control target"
      annotation (Placement(transformation(
          extent={{-20,-20},{20,20}},
          rotation=0,
          origin={-158,70}),
          iconTransformation(
          extent={{-20,-20},{20,20}},
          rotation=0,
          origin={-158,80})));
    Modelica.Blocks.Interfaces.RealInput mea "Measured value of control target"
      annotation (Placement(transformation(
          extent={{-20,-20},{20,20}},
          rotation=0,
          origin={-158,20}),
          iconTransformation(
          extent={{-20,-20},{20,20}},
          rotation=0,
          origin={-158,20})));
    Modelica.Blocks.Interfaces.RealInput tau_m(unit="N.m")
      "Load torque"
      annotation (Placement(transformation(
          extent={{-20,-20},{20,20}},
          rotation=0,
          origin={-158,-80}),
          iconTransformation(
          extent={{-20,-20},{20,20}},
          rotation=0,
          origin={-158,-80})));

    InductionMotors.BaseClasses.CurrentBlock current_Block
      annotation (Placement(transformation(extent={{60,30},{80,50}})));
    InductionMotors.BaseClasses.SpeedBlock speBlo(final J=J, final P=P)
      annotation (Placement(transformation(extent={{24,-80},{44,-58}})));
    Modelica.Blocks.Continuous.Integrator integrator
      annotation (Placement(transformation(extent={{-2,60},{18,80}})));
    Modelica.Blocks.Sources.RealExpression i_ds(y=torSpe.motMod.i_ds)
                                                               annotation (
        Placement(transformation(extent={{-10,-12},{10,12}}, origin={30,40})));
    Modelica.Blocks.Sources.RealExpression i_qs(y=torSpe.motMod.i_qs)
                                                               annotation (
        Placement(transformation(extent={{-10,-12},{10,12}}, origin={30,24})));
    Modelica.Blocks.Sources.RealExpression angFre(y=switch1.y*omega)
      "Supply voltage angular frequency" annotation (Placement(transformation(
            extent={{-10,-12},{10,12}}, origin={-24,-88})));
    InductionMotors.BaseClasses.MotorMachineInterface torSpe(
      final P=P,
      final J=J,
      final Lr=Lr,
      final Ls=Ls,
      final Rr=Rr,
      final Lm=Lm,
      final Rs=Rs)
      annotation (Placement(transformation(extent={{22,-18},{42,2}})));
    Modelica.Mechanics.Rotational.Interfaces.Flange_b shaft
      "Mechanical connector"
      annotation (Placement(transformation(extent={{90,-10},{110,10}})));
    Modelica.Mechanics.Rotational.Sources.Speed speed(
      useSupport=false,                               exact=true,
      phi(fixed=true))
      "Speed connector"
      annotation (Placement(transformation(extent={{64,-8},{80,8}})));
    Modelica.Blocks.Sources.RealExpression angFre1(y=switch1.y*omega)
      "Supply voltage angular frequency" annotation (Placement(transformation(
            extent={{-10,-12},{10,12}}, origin={-66,70})));

    Modelica.Blocks.Math.Gain VFD_Equivalent_Freq(k=P/120)
      annotation (Placement(transformation(extent={{-120,60},{-100,80}})));
    Controls.Continuous.LimPID VFD(
      final controllerType=Modelica.Blocks.Types.SimpleController.PI,
      final Td=Td*2,
      final yMax=yMax,
      final yMin=yMin,
      final k=20*k,
      final Ti=2*Ti,
      initType=Modelica.Blocks.Types.Init.SteadyState,
      final reverseActing=reverseActing)
      "PI controller as variable frequency drive"
      annotation (Placement(transformation(extent={{-102,14},{-82,34}})));
    Modelica.Blocks.Logical.Switch switch1
      annotation (Placement(transformation(extent={{-62,-14},{-42,6}})));
    Modelica.Blocks.Sources.BooleanExpression booleanExpression(y=have_controller)
      annotation (Placement(transformation(extent={{-118,-14},{-98,6}})));
    Modelica.Blocks.Sources.RealExpression realExpression(y=setPoi/(120*per.Freq/
          per.P))
      annotation (Placement(transformation(extent={{-120,-28},{-100,-8}})));
  equation
    // Assign values for motor model calculation from electrical interface
    theta_s = PhaseSystem.thetaRef(terminal.theta);
    omega = der(theta_s);
    v_rms=sqrt(v[1]^2+v[2]^2); // Equations to calculate current
    i[1] = 2*(sqrt(2)/sqrt(3))*torSpe.motMod.i_ds;
    i[2] =(sqrt(3)/sqrt(2))*torSpe.motMod.i_qs;
    i_rms=sqrt(i[1]^2+i[2]^2);
    pow_gap = speBlo.N/9.55*torSpe.tau_e;

    connect(integrator.y,current_Block. wt) annotation (Line(points={{19,70},{50,70},
            {50,48},{58,48}},        color={0,0,127}));
    connect(i_ds.y, current_Block.i_ds) annotation (Line(points={{41,40},{58,40}},
                          color={0,0,127}));
    connect(i_qs.y, current_Block.i_qs)
      annotation (Line(points={{41,24},{50,24},{50,32},{58,32}},
                                                 color={0,0,127}));
    connect(Vrms.y, VFDvol.u1) annotation (Line(points={{-55,56},{-28,56},{-28,36},
            {-22,36}}, color={0,0,127}));
    connect(torSpe.V_rms, VFDvol.y) annotation (Line(points={{13.4286,-0.857143},
            {12,-0.857143},{12,30},{1,30}},
                           color={0,0,127}));
    connect(torSpe.f, VFDfre.y)
      annotation (Line(points={{19.1429,-9.42857},{10.0714,-9.42857},{10.0714,
            -10},{1,-10}},                       color={0,0,127}));
    connect(speBlo.tau_m, tau_m) annotation (Line(points={{22,-69},{-132,-69},{-132,
            -80},{-158,-80}}, color={0,0,127}));
    connect(angFre1.y, integrator.u) annotation (Line(points={{-55,70},{-4,70}},
                                   color={0,0,127}));
    connect(speBlo.omega, angFre.y) annotation (Line(points={{22,-75.6},{22,-74},{
            -8,-74},{-8,-88},{-13,-88}},        color={0,0,127}));
    connect(VFD_Equivalent_Freq.u, setPoi)
      annotation (Line(points={{-122,70},{-158,70}}, color={0,0,127}));
    connect(VFD.u_s, setPoi) annotation (Line(points={{-104,24},{-132,24},{
            -132,70},{-158,70}}, color={0,0,127}));
    connect(VFD.u_m, mea) annotation (Line(points={{-92,12},{-92,6},{-132,6},
            {-132,20},{-158,20}}, color={0,0,127}));
    connect(speed.flange, shaft)
      annotation (Line(points={{80,0},{100,0}}, color={0,0,0}));
    connect(torSpe.omega_r, speBlo.omega_r) annotation (Line(points={{13.4286,
            -18},{4,-18},{4,-26},{52,-26},{52,-62.29},{45.9,-62.29}},
                                                           color={0,0,127}));
    connect(speBlo.omega_r1, speed.w_ref) annotation (Line(points={{45.9,-69.33},{
            45.9,-68},{56,-68},{56,0},{62.4,0}},          color={0,0,127}));
    connect(fre.y, VFDfre.u2)
      annotation (Line(points={{-49,-50},{-28,-50},{-28,-16},{-22,-16}},
                                                   color={0,0,127}));
    connect(VFDfre.u1, VFDvol.u2) annotation (Line(points={{-22,-4},{-28,-4},{-28,
            24},{-22,24}},
                       color={0,0,127}));
    connect(torSpe.tau_e, speBlo.tau_e) annotation (Line(points={{44.8571,
            -9.42857},{44.8571,-8},{50,-8},{50,-42},{16,-42},{16,-62.4},{22,
            -62.4}},
          color={0,0,127}));
    connect(switch1.y, VFDvol.u2) annotation (Line(points={{-41,-4},{-28,-4},{-28,
            24},{-22,24}}, color={0,0,127}));
    connect(switch1.u1, VFD.y) annotation (Line(points={{-64,4},{-74,4},{-74,24},{
            -81,24}}, color={0,0,127}));
    connect(booleanExpression.y, switch1.u2)
      annotation (Line(points={{-97,-4},{-64,-4}}, color={255,0,255}));
    connect(realExpression.y, switch1.u3) annotation (Line(points={{-99,-18},{-72,
            -18},{-72,-12},{-64,-12}}, color={0,0,127}));
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
</html>",   revisions="<html>
<ul>
<li>May 07, 2024, by Viswanathan Ganesh and Zhanwei He:<br>First Implementation. </li>
</ul>
</html>"),
      Diagram(coordinateSystem(extent={{-140,-100},{100,100}})));
  end SquirrelCageDrive;

  model SquirrelCageDrive_OnOff
    "Squirrel cage type induction motor with electrical interface and closed loop built-in speed control"
    extends Buildings.Electrical.Interfaces.PartialOnePort(
     redeclare package PhaseSystem =
          Buildings.Electrical.PhaseSystems.OnePhase,
     redeclare replaceable Interfaces.Terminal_n terminal);
       replaceable parameter
      Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.Data.Generic
      per constrainedby
      Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.Data.Generic
      "Record with performance data" annotation (choicesAllMatching=true,
        Placement(transformation(extent={{52,60},{72,80}})));
    parameter Integer P=per.P "Number of poles";
    parameter Real J=per.J "Moment of inertia";
    parameter Real Lr=per.Lr "Rotor inductance [H]";
    parameter Real Ls=per.Ls "Stator inductance [H]";
    parameter Real Lm=per.Lm "Mutual inductance [H]";
    parameter Real Rr=per.Rr "Rotor resistance [ohm]";
    parameter Real Rs=per.Rs "Stator resistance [ohm]";

    //-----------------------------------------------
    // parameter Integer P=4      "Number of poles";
    //parameter Real J=0.17    "Moment of inetia";
    //parameter Real Lr=0.1458    "Rotor inductance [H]";
    //parameter Real Ls=0.1457    "Stator inductance [H]";
    //parameter Real Rr=1.145   "Rotor resistance [ohm]";
    //parameter Real Lm=0.1406   "Mutual inductance [H]";
    //parameter Real Rs=1   "Stator resistance [ohm]";
    //-------------------------------------------------

    parameter Boolean have_controller = true
      "Set to true for enable PID control, False for simple speed control";
    parameter Boolean reverseActing=true
       "Set to true for reverseActing in heating and set to false in cooling mode";
    parameter Modelica.Blocks.Types.SimpleController
    controllerType=Modelica.Blocks.Types.SimpleController.PI
       "Type of controller"
        annotation (Dialog(tab="Advanced",
                           group="Controller",
                           enable=true));
    parameter Real k(min=0) = 1
       "Gain of controller"
        annotation (Dialog(tab="Advanced",
                           group="Controller",
                           enable=true));
    parameter Modelica.Units.SI.Time Ti(min=Modelica.Constants.small)=0.5
       "Time constant of Integrator block"
        annotation (Dialog(tab="Advanced",
                           group="Controller",
                           enable=true and
    controllerType == Modelica.Blocks.Types.SimpleController.PI or
    controllerType == Modelica.Blocks.Types.SimpleController.PID));
    parameter Modelica.Units.SI.Time Td(min=0) = 0.1
       "Time constant of Derivative block"
        annotation (Dialog(tab="Advanced",
                           group="Controller",
                           enable=true and
    controllerType == Modelica.Blocks.Types.SimpleController.PD or
    controllerType == Modelica.Blocks.Types.SimpleController.PID));
    parameter Real yMax(start=1)=1
      "Upper limit of output"
       annotation (Dialog(tab="Advanced",
                         group="Controller",
                         enable=true));
    parameter Real yMin=0
      "Lower limit of output"
       annotation (Dialog(tab="Advanced",
                         group="Controller",
                         enable=true));

    Real v_rms "RMS voltage";
    Real i_rms "RMS current";
    Real  pow_gap;
    Modelica.Units.SI.Angle theta_s "Supply voltage phase angel";
    Modelica.Units.SI.AngularVelocity omega "Supply voltage angular frequency";
    Modelica.Units.SI.Voltage v[:] = terminal.v "Voltage vector";
    Modelica.Units.SI.Current i[:] = terminal.i "Current vector";

    final Modelica.Blocks.Sources.RealExpression Vrms(y=v_rms) "RMS voltage"
      annotation (Placement(transformation(extent={{-76,46},{-56,66}})));
    final Modelica.Blocks.Sources.RealExpression fre(y=omega/(2*Modelica.Constants.pi))
      "Supply voltage frequency"
      annotation (Placement(transformation(extent={{-74,-50},{-54,-30}})));
    Modelica.Blocks.Math.Product VFDfre "Controlled frequency"
      annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
    Modelica.Blocks.Math.Product VFDvol "Controlled voltage"
      annotation (Placement(transformation(extent={{-40,40},{-20,60}})));

    Modelica.Blocks.Interfaces.RealInput setPoi "Set point of control target"
      annotation (Placement(transformation(
          extent={{-20,-20},{20,20}},
          rotation=0,
          origin={-158,70}),
          iconTransformation(
          extent={{-20,-20},{20,20}},
          rotation=0,
          origin={-160,80})));
    Modelica.Blocks.Interfaces.RealInput mea "Measured value of control target"
      annotation (Placement(transformation(
          extent={{-20,-20},{20,20}},
          rotation=0,
          origin={-160,20}),
          iconTransformation(
          extent={{-20,-20},{20,20}},
          rotation=0,
          origin={-160,20})));
    Modelica.Blocks.Interfaces.RealInput tau_m(unit="N.m")
      "Load torque"
      annotation (Placement(transformation(
          extent={{-20,-20},{20,20}},
          rotation=0,
          origin={-160,-80}),
          iconTransformation(
          extent={{-20,-20},{20,20}},
          rotation=0,
          origin={-160,-80})));

    InductionMotors.BaseClasses.CurrentBlock current_Block
      annotation (Placement(transformation(extent={{60,30},{80,50}})));
    InductionMotors.BaseClasses.SpeedBlock speBlo(final J=J, final P=P)
      annotation (Placement(transformation(extent={{38,-80},{58,-58}})));
    Modelica.Blocks.Continuous.Integrator integrator
      annotation (Placement(transformation(extent={{-2,60},{18,80}})));
    Modelica.Blocks.Sources.RealExpression i_ds(y=torSpe.motMod.i_ds)
                                                               annotation (
        Placement(transformation(extent={{-10,-12},{10,12}}, origin={30,40})));
    Modelica.Blocks.Sources.RealExpression i_qs(y=torSpe.motMod.i_qs)
                                                               annotation (
        Placement(transformation(extent={{-10,-12},{10,12}}, origin={30,24})));
    Modelica.Blocks.Sources.RealExpression angFre(y=switch1.y*omega)
      "Supply voltage angular frequency" annotation (Placement(transformation(
            extent={{-10,-12},{10,12}}, origin={-4,-84})));
    InductionMotors.BaseClasses.MotorMachineInterface torSpe(
      final P=P,
      final J=J,
      final Lr=Lr,
      final Ls=Ls,
      final Rr=Rr,
      final Lm=Lm,
      final Rs=Rs)
      annotation (Placement(transformation(extent={{18,-34},{38,-14}})));
    Modelica.Mechanics.Rotational.Interfaces.Flange_b shaft
      "Mechanical connector"
      annotation (Placement(transformation(extent={{90,-10},{110,10}})));
    Modelica.Mechanics.Rotational.Sources.Speed speed(
      useSupport=false,                               exact=true,
      phi(fixed=true))
      "Speed connector"
      annotation (Placement(transformation(extent={{72,-8},{88,8}})));
    Modelica.Blocks.Sources.RealExpression angFre1(y=switch1.y*omega)
      "Supply voltage angular frequency" annotation (Placement(transformation(
            extent={{-10,-12},{10,12}}, origin={-66,70})));

    Modelica.Blocks.Math.Gain VFD_Equivalent_Freq(k=P/120)
      annotation (Placement(transformation(extent={{-120,60},{-100,80}})));
    Controls.Continuous.LimPID VFD(
      final controllerType=Modelica.Blocks.Types.SimpleController.PI,
      final Td=Td*2,
      final yMax=yMax,
      final yMin=yMin,
      final k=k*0.00385,
      final Ti=Ti*1.5,
      initType=Modelica.Blocks.Types.Init.SteadyState,
      final reverseActing=reverseActing)
      "PI controller as variable frequency drive"
      annotation (Placement(transformation(extent={{-114,16},{-94,36}})));
    Modelica.Blocks.Interfaces.BooleanInput u
      annotation (Placement(transformation(extent={{-180,-60},{-140,-20}}),
          iconTransformation(extent={{-180,-60},{-140,-20}})));
    Modelica.Blocks.Math.BooleanToReal booToReaPum1(realTrue=1, y(start=0))
      "Pump signal" annotation (Placement(transformation(
          extent={{10,-10},{-10,10}},
          rotation=180,
          origin={-110,-40})));
    Modelica.Blocks.Logical.Switch switch1
      annotation (Placement(transformation(extent={{-74,-4},{-54,16}})));
    Modelica.Blocks.Sources.BooleanExpression booleanExpression(y=have_controller)
      annotation (Placement(transformation(extent={{-128,-10},{-108,10}})));
    Modelica.Blocks.Sources.RealExpression realExpression(y=(setPoi*booToReaPum1.y)
          /(120*per.Freq/per.P))
      annotation (Placement(transformation(extent={{-128,-26},{-108,-6}})));
  equation
    // Assign values for motor model calculation from electrical interface
    theta_s = PhaseSystem.thetaRef(terminal.theta);
    omega = der(theta_s);
    v_rms=sqrt(v[1]^2+v[2]^2); // Equations to calculate current
    i[1] = 2*(sqrt(2)/sqrt(3))*torSpe.motMod.i_ds;
    i[2] =(sqrt(3)/sqrt(2))*torSpe.motMod.i_qs;
    i_rms=sqrt(i[1]^2+i[2]^2);
    pow_gap = speBlo.N/9.55*torSpe.tau_e;

    connect(integrator.y,current_Block. wt) annotation (Line(points={{19,70},{50,70},
            {50,48},{58,48}},        color={0,0,127}));
    connect(i_ds.y, current_Block.i_ds) annotation (Line(points={{41,40},{58,40}},
                          color={0,0,127}));
    connect(i_qs.y, current_Block.i_qs)
      annotation (Line(points={{41,24},{50,24},{50,32},{58,32}},
                                                 color={0,0,127}));
    connect(Vrms.y, VFDvol.u1) annotation (Line(points={{-55,56},{-42,56}},
                       color={0,0,127}));
    connect(torSpe.V_rms, VFDvol.y) annotation (Line(points={{9.42857,-16.8571},
            {-14,-16.8571},{-14,8},{-16,8},{-16,44},{-14,44},{-14,50},{-19,50}},
                           color={0,0,127}));
    connect(torSpe.f, VFDfre.y)
      annotation (Line(points={{15.1429,-25.4286},{-19,-25.4286},{-19,0}},
                                                 color={0,0,127}));
    connect(speBlo.tau_m, tau_m) annotation (Line(points={{36,-69},{-28,-69},{-28,
            -84},{-132,-84},{-132,-80},{-160,-80}},
                              color={0,0,127}));
    connect(angFre1.y, integrator.u) annotation (Line(points={{-55,70},{-4,70}},
                                   color={0,0,127}));
    connect(speBlo.omega, angFre.y) annotation (Line(points={{36,-75.6},{36,-74},{
            12,-74},{12,-84},{7,-84}},          color={0,0,127}));
    connect(VFD_Equivalent_Freq.u, setPoi)
      annotation (Line(points={{-122,70},{-158,70}}, color={0,0,127}));
    connect(VFD.u_s, setPoi) annotation (Line(points={{-116,26},{-132,26},{-132,
            70},{-158,70}},      color={0,0,127}));
    connect(VFD.u_m, mea) annotation (Line(points={{-104,14},{-104,6},{-132,6},{-132,
            20},{-160,20}},       color={0,0,127}));
    connect(speed.flange, shaft)
      annotation (Line(points={{88,0},{100,0}}, color={0,0,0}));
    connect(torSpe.omega_r, speBlo.omega_r) annotation (Line(points={{9.42857,-34},
            {8,-34},{8,-42},{64,-42},{64,-62.29},{59.9,-62.29}},
                                                           color={0,0,127}));
    connect(speBlo.omega_r1, speed.w_ref) annotation (Line(points={{59.9,-69.33},{
            59.9,-68},{66,-68},{66,0},{70.4,0}},          color={0,0,127}));
    connect(fre.y, VFDfre.u2)
      annotation (Line(points={{-53,-40},{-48,-40},{-48,-6},{-42,-6}},
                                                   color={0,0,127}));
    connect(torSpe.tau_e, speBlo.tau_e) annotation (Line(points={{40.8571,
            -25.4286},{40.8571,-24},{46,-24},{46,-54},{30,-54},{30,-62.4},{36,
            -62.4}},
          color={0,0,127}));
    connect(booToReaPum1.u, u)
      annotation (Line(points={{-122,-40},{-160,-40}}, color={255,0,255}));
    connect(switch1.y, VFDfre.u1)
      annotation (Line(points={{-53,6},{-42,6}}, color={0,0,127}));
    connect(switch1.u1, VFD.y) annotation (Line(points={{-76,14},{-86,14},{-86,26},
            {-93,26}}, color={0,0,127}));
    connect(booleanExpression.y, switch1.u2) annotation (Line(points={{-107,0},{-84,
            0},{-84,6},{-76,6}}, color={255,0,255}));
    connect(realExpression.y, switch1.u3) annotation (Line(points={{-107,-16},{-84,
            -16},{-84,-2},{-76,-2}}, color={0,0,127}));
    connect(VFDvol.u2, VFDfre.u1) annotation (Line(points={{-42,44},{-46,44},{
            -46,6},{-42,6}}, color={0,0,127}));
    annotation (
      Icon(coordinateSystem(preserveAspectRatio=true,
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
</html>",   revisions="<html>
<ul>
<li>May 07, 2024, by Viswanathan Ganesh and Zhanwei He:<br>First Implementation. </li>
</ul>
</html>"),
      Diagram(coordinateSystem(extent={{-140,-100},{100,100}})));
  end SquirrelCageDrive_OnOff;

  package Examples
   extends Modelica.Icons.ExamplesPackage;
    model SquirrelCageDrive
      "This example shows how to use the squirrel cage induction motor with closed loop built-in speed control"

      extends Modelica.Icons.Example;

      Sources.Grid                                             sou(f=50, V=220*1.414)
        "Voltage source"
        annotation (Placement(transformation(extent={{0,40},{20,60}})));
      Modelica.Blocks.Sources.RealExpression mea(y=motDri.speBlo.N)
        "Measured value of control target"
        annotation (Placement(transformation(extent={{-60,-36},{-40,-16}})));
      Modelica.Blocks.Sources.Step Speed_ref(
        height=650,
        offset=800,
        startTime=2.5) "Set point of control target"
        annotation (Placement(transformation(extent={{-60,8},{-40,28}})));
      Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.SquirrelCageDrive
        motDri(have_controller=true)
        annotation (Placement(transformation(extent={{-4,0},{20,20}})));
      Real Efficiency,Loss,slip,Ns;
      Modelica.Blocks.Sources.Constant Tau_m(k=26) "Load Torque"
        annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
    equation
     Ns = (120*sou.f)/motDri.P;
     slip =((Ns-motDri.speBlo.N)/Ns);
     Loss = abs(sou.P.real - motDri.pow_gap);
    if (sou.P.real) <=0 then
       Efficiency = 0;
    else
       Efficiency = ((motDri.pow_gap)/(sou.P.real))*100;
    end if;

      connect(motDri.terminal, sou.terminal)
        annotation (Line(points={{10,20},{10,40}}, color={0,120,120}));
      connect(Speed_ref.y, motDri.setPoi)
        annotation (Line(points={{-39,18},{-5.8,18}}, color={0,0,127}));
      connect(mea.y, motDri.mea) annotation (Line(points={{-39,-26},{-28,-26},{-28,12},
              {-5.8,12}}, color={0,0,127}));
      connect(Tau_m.y, motDri.tau_m) annotation (Line(points={{-39,-50},{-10,
              -50},{-10,2},{-5.8,2}}, color={0,0,127}));
      annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
            coordinateSystem(preserveAspectRatio=false)),
        experiment(
          StopTime=4,
          Interval=0.02,
          __Dymola_Algorithm="Dassl"),
        Documentation(revisions="<html>
<ul>
<li>May 07, 2024, by Viswanathan Ganesh and Zhanwei He:<br>First Implementation. </li>
</ul>
</html>", info="<html>
An example of induction motor drive with closed loop variable speed controller.
</html>"));
    end SquirrelCageDrive;

    model SquirrelCageDrive_OnOff
      "This example shows how to use the squirrel cage induction motor with closed loop built-in speed control with boolean control"

      extends Modelica.Icons.Example;

      Sources.Grid                                             sou(f=50, V=220*1.414)
        "Voltage source"
        annotation (Placement(transformation(extent={{0,40},{20,60}})));
      Modelica.Blocks.Sources.RealExpression mea(y=motDri.speBlo.N)
        "Measured value of control target"
        annotation (Placement(transformation(extent={{-60,-18},{-40,2}})));
      Modelica.Blocks.Sources.Step Speed_ref(
        height=650,
        offset=800,
        startTime=2.5) "Set point of control target"
        annotation (Placement(transformation(extent={{-60,8},{-40,28}})));
      Real Efficiency,Loss,slip,Ns;
      Modelica.Blocks.Sources.Constant Tau_m(k=0) "Load Torque"
        annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
      Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.SquirrelCageDrive_OnOff
        motDri(have_controller=false)
        annotation (Placement(transformation(extent={{-2,0},{22,20}})));
      Modelica.Blocks.Sources.BooleanConstant booleanConstant(k=true)
        annotation (Placement(transformation(extent={{-86,-36},{-66,-16}})));
    equation
     Ns = (120*sou.f)/motDri.P;
     slip =((Ns-motDri.speBlo.N)/Ns);
     Loss = abs(sou.P.real - motDri.pow_gap);
    if (sou.P.real) <=0 then
       Efficiency = 0;
    else
       Efficiency = ((motDri.pow_gap)/(sou.P.real))*100;
    end if;

      connect(motDri.terminal, sou.terminal)
        annotation (Line(points={{12,20},{10,20},{10,40}}, color={0,120,120}));
      connect(motDri.setPoi, Speed_ref.y)
        annotation (Line(points={{-4,18},{-39,18}}, color={0,0,127}));
      connect(mea.y, motDri.mea) annotation (Line(points={{-39,-8},{-32,-8},{
              -32,12},{-4,12}}, color={0,0,127}));
      connect(Tau_m.y, motDri.tau_m) annotation (Line(points={{-39,-50},{-10,
              -50},{-10,2},{-4,2}}, color={0,0,127}));
      connect(booleanConstant.y, motDri.u) annotation (Line(points={{-65,-26},{
              -12,-26},{-12,6},{-4,6}}, color={255,0,255}));
      annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
            coordinateSystem(preserveAspectRatio=false)),
        experiment(
          StopTime=4,
          Interval=0.02,
          __Dymola_Algorithm="Dassl"),
        Documentation(revisions="<html>
<ul>
<li>May 07, 2024, by Viswanathan Ganesh and Zhanwei He:<br>First Implementation. </li>
</ul>
</html>", info="<html>
An example of induction motor drive with closed loop variable speed controller.
</html>"));
    end SquirrelCageDrive_OnOff;

    model SquirrelCageStartUp
        extends Modelica.Icons.Example;
      Real Efficiency;
      Real Loss,slip,Ns;
      Modelica.Blocks.Sources.RealExpression loaTor(y=26.5) "Load torque"
        annotation (Placement(transformation(extent={{-54,-28},{-34,-8}})));
      Sources.Grid                                             sou(f=50, V=220*
            1.414)
        "Voltage source"
        annotation (Placement(transformation(extent={{-20,20},{0,40}})));
      InductionMotors.SquirrelCage motDri
        annotation (Placement(transformation(extent={{-20,-20},{0,0}})));
    equation
     Ns = (120*sou.f)/motDri.P;
     slip =((Ns-motDri.speBlo.N)/Ns);
     Loss = abs(sou.P.real - motDri.pow_gap);
    if (sou.P.real) <=0 then
       Efficiency = 0;
     else
       Efficiency = ((motDri.pow_gap)/(sou.P.real))*100;
     end if;

      connect(loaTor.y, motDri.tau_m)
        annotation (Line(points={{-33,-18},{-22,-18}}, color={0,0,127}));
      connect(sou.terminal, motDri.terminal) annotation (Line(points={{-10,20},{-10,
              8.88178e-16}}, color={0,120,120}));
      annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
            coordinateSystem(preserveAspectRatio=false)),
        experiment(Interval=0.002, __Dymola_Algorithm="Dassl"),
        Documentation(revisions="<html>
<ul>
<li>May 07, 2024, by Viswanathan Ganesh and Zhanwei He:<br>First Implementation. </li>
</ul>
</html>", info="<html>
An example of induction motor start up sequence.
</html>"));
    end SquirrelCageStartUp;
  end Examples;

  package BaseClasses
    model StatorCurrent_d "d-axis stator current calculation block"
      extends Modelica.Blocks.Icons.Block;
       parameter Real Lr;
       parameter Real Rr;
       parameter Real Lm;
       parameter Real Rs;
       parameter Real Ls;
      Modelica.Blocks.Interfaces.RealInput v_ds
        annotation (Placement(transformation(extent={{-140,80},{-100,120}}),
            iconTransformation(extent={{-140,80},{-100,120}})));
      Modelica.Blocks.Interfaces.RealInput i_ds
        annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
            iconTransformation(extent={{-140,40},{-100,80}})));
      Modelica.Blocks.Interfaces.RealInput der_i_dr annotation (Placement(
            transformation(extent={{-140,2},{-100,42}}),  iconTransformation(extent={{-140,2},
                {-100,42}})));
      Modelica.Blocks.Interfaces.RealInput omega annotation (Placement(transformation(
              extent={{-140,-42},{-100,-2}}),  iconTransformation(extent={{-140,-42},
                {-100,-2}})));
      Modelica.Blocks.Interfaces.RealInput i_qr
        annotation (Placement(transformation(extent={{-140,-84},{-100,-44}}),
            iconTransformation(extent={{-140,-84},{-100,-44}})));
      Modelica.Blocks.Interfaces.RealInput i_qs annotation (Placement(
            transformation(extent={{-140,-120},{-100,-80}}),  iconTransformation(
              extent={{-140,-120},{-100,-80}})));
      Modelica.Blocks.Interfaces.RealOutput der_i_ds annotation (Placement(
            transformation(extent={{100,-26},{154,28}}),iconTransformation(extent={{100,-26},
                {154,28}})));

    equation
      der_i_ds =(((v_ds)/Ls)-((Rs*i_ds)/Ls)-((der_i_dr*Lm)/Ls)+(omega*i_qs)+((omega*Lm*i_qr)/Ls));
      annotation (
        Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
        Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
                100}})));
    end StatorCurrent_d;

    model StatorCurrent_q "q-axis stator current calculation block"
      extends Modelica.Blocks.Icons.Block;
      parameter Real Lr;
      parameter Real Rr;
      parameter Real Lm;
      parameter Real Rs;
      parameter Real Ls;
      Modelica.Blocks.Interfaces.RealInput v_qs
        annotation (Placement(transformation(extent={{-140,78},{-100,118}}),
            iconTransformation(extent={{-140,78},{-100,118}})));
      Modelica.Blocks.Interfaces.RealInput i_qs
        annotation (Placement(transformation(extent={{-140,38},{-100,78}}),
            iconTransformation(extent={{-140,38},{-100,78}})));
      Modelica.Blocks.Interfaces.RealInput der_i_qr annotation (Placement(
            transformation(extent={{-140,-2},{-100,38}}), iconTransformation(extent={{-140,-2},
                {-100,38}})));
      Modelica.Blocks.Interfaces.RealInput omega annotation (Placement(transformation(
              extent={{-140,-42},{-100,-2}}),  iconTransformation(extent={{-140,-42},
                {-100,-2}})));
      Modelica.Blocks.Interfaces.RealInput i_dr
        annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
            iconTransformation(extent={{-140,-80},{-100,-40}})));
      Modelica.Blocks.Interfaces.RealInput i_ds
        annotation (Placement(transformation(extent={{-140,-120},{-100,-80}}),
            iconTransformation(extent={{-140,-120},{-100,-80}})));
      Modelica.Blocks.Interfaces.RealOutput der_i_qs annotation (Placement(
            transformation(extent={{100,-28},{154,26}}),iconTransformation(extent={{100,-28},
                {154,26}})));

    equation
      der_i_qs =(((v_qs)/Ls)-((Rs*i_qs)/Ls)-((der_i_qr*Lm)/Ls)-(omega*i_ds)-((omega*Lm*i_dr)/Ls));
      annotation (
        Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
        Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
                100}})));
    end StatorCurrent_q;

    model RotorCurrent_d "d-axis rotor current calculation blck"
      extends Modelica.Blocks.Icons.Block;
        parameter Real Lr;
        parameter Real Rr;
        parameter Real Lm;
      Modelica.Blocks.Interfaces.RealInput v_dr
        annotation (Placement(transformation(extent={{-140,80},{-100,120}}),
            iconTransformation(extent={{-140,80},{-100,120}})));
      Modelica.Blocks.Interfaces.RealInput i_qr
        annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
            iconTransformation(extent={{-140,-80},{-100,-40}})));
      Modelica.Blocks.Interfaces.RealInput der_i_ds
        annotation (Placement(transformation(extent={{-140,0},{-100,40}}),
            iconTransformation(extent={{-140,0},{-100,40}})));
      Modelica.Blocks.Interfaces.RealInput omega_r
        annotation (Placement(transformation(extent={{-140,-40},{-100,0}}),
            iconTransformation(extent={{-140,-40},{-100,0}})));
      Modelica.Blocks.Interfaces.RealInput i_dr
        annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
            iconTransformation(extent={{-140,40},{-100,80}})));
      Modelica.Blocks.Interfaces.RealInput i_qs
        annotation (Placement(transformation(extent={{-140,-120},{-100,-80}}),
            iconTransformation(extent={{-140,-120},{-100,-80}})));
      Modelica.Blocks.Interfaces.RealOutput der_i_dr annotation (Placement(
            transformation(extent={{100,-22},{142,20}}),iconTransformation(extent={{100,-22},
                {142,20}})));

    initial equation
    equation
      der_i_dr = (((v_dr)/Lr)-((Rr*i_dr)/Lr)-((der_i_ds*Lm)/Lr)+(omega_r*i_qr)+((omega_r*Lm*i_qs)/Lr));
      annotation (
        Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
        Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
                100}})));
    end RotorCurrent_d;

    model RotorCurrent_q "q-axis rotor current calculation blck"
      extends Modelica.Blocks.Icons.Block;
       parameter Real Lr;
       parameter Real Rr;
       parameter Real Lm;
      Modelica.Blocks.Interfaces.RealInput v_qr
        annotation (Placement(transformation(extent={{-140,80},{-100,120}}),
            iconTransformation(extent={{-140,80},{-100,120}})));
      Modelica.Blocks.Interfaces.RealInput i_qr
        annotation (Placement(transformation(extent={{-140,38},{-100,78}}),
            iconTransformation(extent={{-140,38},{-100,78}})));
      Modelica.Blocks.Interfaces.RealInput der_i_qs
        annotation (Placement(transformation(extent={{-140,-2},{-100,38}}),
            iconTransformation(extent={{-140,-2},{-100,38}})));
      Modelica.Blocks.Interfaces.RealInput omega_r
        annotation (Placement(transformation(extent={{-140,-44},{-100,-4}}),
            iconTransformation(extent={{-140,-44},{-100,-4}})));
      Modelica.Blocks.Interfaces.RealInput i_dr
        annotation (Placement(transformation(extent={{-140,-82},{-100,-42}}),
            iconTransformation(extent={{-140,-82},{-100,-42}})));
      Modelica.Blocks.Interfaces.RealInput i_ds
        annotation (Placement(transformation(extent={{-140,-120},{-100,-80}}),
            iconTransformation(extent={{-140,-120},{-100,-80}})));
      Modelica.Blocks.Interfaces.RealOutput der_i_qr annotation (Placement(
            transformation(extent={{100,-20},{140,20}}),iconTransformation(extent={{100,-20},
                {140,20}})));
    equation
      der_i_qr = (((v_qr)/Lr)-((Rr*i_qr)/Lr)-((der_i_qs*Lm)/Lr)-(omega_r*i_dr)-((omega_r*Lm*i_ds)/Lr));
      annotation (
        Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
        Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
                100}})));
    end RotorCurrent_q;

    model SpeedBlock
      extends Modelica.Blocks.Icons.Block;
      Modelica.Blocks.Interfaces.RealInput tau_e annotation (Placement(transformation(
              extent={{-140,40},{-100,80}}),iconTransformation(extent={{-140,40},{-100,
                80}})));
      Modelica.Blocks.Interfaces.RealInput tau_m annotation (Placement(transformation(
              extent={{-140,-20},{-100,20}}),iconTransformation(extent={{-140,-20},{
                -100,20}})));
      Modelica.Blocks.Interfaces.RealInput omega annotation (Placement(transformation(
              extent={{-140,-80},{-100,-40}}),iconTransformation(extent={{-140,-80},
                {-100,-40}})));
      Modelica.Blocks.Interfaces.RealOutput omega_r annotation (Placement(transformation(
              extent={{100,42},{138,80}}),iconTransformation(extent={{100,42},{138,80}})));
      Modelica.Blocks.Interfaces.RealOutput N annotation (Placement(transformation(
              extent={{102,-78},{138,-42}}),iconTransformation(extent={{100,-80},
                {138,-42}})));

    parameter Real J( start=0.0131, fixed=true);
    parameter Integer P( start=4, fixed=true);
      Modelica.Blocks.Math.Feedback feedback
        annotation (Placement(transformation(extent={{-70,22},{-50,42}})));
      Modelica.Blocks.Math.Gain gain(k=P/(2*J))
        annotation (Placement(transformation(extent={{-22,-10},{-2,10}})));
      Modelica.Blocks.Continuous.Integrator integrator
        annotation (Placement(transformation(extent={{12,-10},{32,10}})));
      Modelica.Blocks.Math.Gain gain1(k=(2/P)*(60/(2*Modelica.Constants.pi)))
        annotation (Placement(transformation(extent={{50,-10},{70,10}})));
      Modelica.Blocks.Math.Feedback feedback1
        annotation (Placement(transformation(extent={{-70,-70},{-50,-90}})));
      Modelica.Blocks.Interfaces.RealOutput omega_r1
                                                    annotation (Placement(transformation(
              extent={{100,-22},{138,16}}),
                                          iconTransformation(extent={{100,-22},
                {138,16}})));
    equation
      connect(feedback.u1, tau_e) annotation (Line(points={{-68,32},{-80,32},{-80,
              60},{-120,60}},
                         color={0,0,127}));
      connect(feedback.u2, tau_m)
        annotation (Line(points={{-60,24},{-60,0},{-120,0}},color={0,0,127}));
      connect(feedback.y, gain.u)
        annotation (Line(points={{-51,32},{-42,32},{-42,0},{-24,0}},
                                                     color={0,0,127}));
      connect(gain.y, integrator.u)
        annotation (Line(points={{-1,0},{10,0}},  color={0,0,127}));
      connect(integrator.y, gain1.u)
        annotation (Line(points={{33,0},{48,0}},   color={0,0,127}));
      connect(gain1.y, N) annotation (Line(points={{71,0},{80,0},{80,-60},{120,
              -60}},
            color={0,0,127}));
      connect(feedback1.u1, omega) annotation (Line(points={{-68,-80},{-80,-80},{-80,-60},
              {-120,-60}},     color={0,0,127}));
      connect(feedback1.u2, gain1.u) annotation (Line(points={{-60,-72},{42,
              -72},{42,0},{48,0}},
                               color={0,0,127}));
      connect(N, N)
        annotation (Line(points={{120,-60},{120,-60}}, color={0,0,127}));
      connect(feedback1.y, omega_r) annotation (Line(points={{-51,-80},{88,
              -80},{88,61},{119,61}},
                             color={0,0,127}));
      connect(omega_r1, integrator.y) annotation (Line(points={{119,-3},{106,
              -3},{106,-4},{94,-4},{94,-40},{36,-40},{36,0},{33,0}}, color={0,
              0,127}));
      annotation (
        Icon(coordinateSystem(preserveAspectRatio=false)),
        Diagram(coordinateSystem(preserveAspectRatio=false)));
    end SpeedBlock;

    model TorqueBlock
      extends Modelica.Blocks.Icons.Block;
      parameter Integer P=4 "Number of pole pairs";
      parameter Real Lm( start=0.5, fixed=true);
      parameter Real J( start=0.0131, fixed=true);
      Modelica.Blocks.Interfaces.RealInput i_qs
        annotation (Placement(transformation(extent={{-138,52},{-100,90}}),
            iconTransformation(extent={{-138,52},{-100,90}})));
      Modelica.Blocks.Interfaces.RealInput i_ds
        annotation (Placement(transformation(extent={{-138,10},{-100,48}}),
            iconTransformation(extent={{-138,10},{-100,48}})));
      Modelica.Blocks.Interfaces.RealInput i_qr
        annotation (Placement(transformation(extent={{-138,-50},{-100,-12}}),
            iconTransformation(extent={{-138,-50},{-100,-12}})));
      Modelica.Blocks.Interfaces.RealInput i_dr
        annotation (Placement(transformation(extent={{-138,-90},{-100,-52}}),
            iconTransformation(extent={{-138,-90},{-100,-52}})));
      Modelica.Blocks.Interfaces.RealOutput tau_e annotation (Placement(
            transformation(extent={{100,-20},{140,20}}),iconTransformation(extent={{100,-20},
                {140,20}})));
    equation
      tau_e = ((i_qs*i_dr)-(i_ds*i_qr))*(3/2)*(P/(2))*Lm;
      annotation (
        Icon(coordinateSystem(preserveAspectRatio=false)),
        Diagram(coordinateSystem(preserveAspectRatio=false)));
    end TorqueBlock;

    model CurrentBlock
      extends Modelica.Blocks.Icons.Block;
      Modelica.Blocks.Interfaces.RealInput i_ds
        annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
            iconTransformation(extent={{-140,-20},{-100,20}})));
      Modelica.Blocks.Interfaces.RealInput i_qs
        annotation (Placement(transformation(extent={{-140,-100},{-100,-60}}),
            iconTransformation(extent={{-140,-100},{-100,-60}})));
      Modelica.Blocks.Interfaces.RealInput wt
        annotation (Placement(transformation(extent={{-140,60},{-100,100}}),
            iconTransformation(extent={{-140,60},{-100,100}})));
      Modelica.Blocks.Interfaces.RealOutput I_a
        annotation (Placement(transformation(extent={{100,60},{140,100}}),
            iconTransformation(extent={{100,60},{140,100}})));
      Modelica.Blocks.Interfaces.RealOutput I_b
        annotation (Placement(transformation(extent={{100,-20},{140,20}}),
            iconTransformation(extent={{100,-20},{140,20}})));
      Modelica.Blocks.Interfaces.RealOutput I_c
        annotation (Placement(transformation(extent={{100,-100},{140,-60}}),
            iconTransformation(extent={{100,-100},{140,-60}})));
    equation
      I_a = sin(wt)*i_ds+cos(wt)*i_qs;
      I_b = sin(wt-2.0933)*i_ds+cos(wt-2.0933)*i_qs;
      I_c = sin(wt+2.0933)*i_ds+cos(wt+2.0933)*i_qs;
      annotation (
        Icon(coordinateSystem(preserveAspectRatio=false)),
        Diagram(coordinateSystem(preserveAspectRatio=false)));
    end CurrentBlock;

    model MotorModel
      parameter Modelica.Units.SI.Reactance Lr;
      parameter Modelica.Units.SI.Reactance Ls;
      parameter Modelica.Units.SI.Resistance Rr;
      parameter Modelica.Units.SI.Reactance Lm;
      parameter Modelica.Units.SI.Reactance Rs;

      Modelica.Blocks.Interfaces.RealInput v_ds annotation (Placement(
            transformation(extent={{-20,-20},{20,20}}, origin={-160,54}),
                                                         iconTransformation(extent={{-180,34},
                {-140,74}})));
      Modelica.Blocks.Interfaces.RealInput v_qs annotation (Placement(
            transformation(extent={{-20,-20},{20,20}}, origin={-160,100}),
                                                        iconTransformation(extent={{-180,80},
                {-140,120}})));
      Modelica.Blocks.Interfaces.RealInput omega annotation (Placement(transformation(
              extent={{-20,-20},{20,20}}, origin={-160,0}),
                                            iconTransformation(extent={{-180,
                -20},{-140,20}})));
      Modelica.Blocks.Interfaces.RealInput omega_r annotation (Placement(transformation(
              extent={{-20,-20},{20,20}}, origin={-160,-94}),
                                              iconTransformation(extent={{-180,
                -114},{-140,-74}})));
      Modelica.Blocks.Interfaces.RealOutput i_qs annotation (Placement(
            transformation(extent={{-20,-20},{20,20}}, origin={160,90}),
                                                       iconTransformation(extent={{140,70},
                {180,110}})));
      Modelica.Blocks.Interfaces.RealOutput i_ds annotation (Placement(
            transformation(extent={{-20,-20},{20,20}}, origin={160,50}),
                                                      iconTransformation(extent={{140,30},
                {180,70}})));
      Modelica.Blocks.Interfaces.RealOutput i_qr annotation (Placement(
            transformation(extent={{-20,-20},{20,20}}, origin={160,-40}),
                                                       iconTransformation(extent={{140,-60},
                {180,-20}})));
      Modelica.Blocks.Interfaces.RealOutput i_dr annotation (Placement(
            transformation(extent={{-20,-20},{20,20}}, origin={160,-100}),
                                                         iconTransformation(extent={{140,
                -120},{180,-80}})));
      InductionMotors.BaseClasses.RotorCurrent_q i_qr_block(
        final Lr=Lr,
        final Rr=Rr,
        final Lm=Lm) annotation (Placement(transformation(extent={{-10,-10},{10,
                10}}, origin={70,-40})));
      Modelica.Blocks.Continuous.Integrator int_qr annotation (Placement(
            transformation(extent={{-10,-10},{10,10}}, origin={110,-40})));
      InductionMotors.BaseClasses.RotorCurrent_d i_dr_block(
        final Lr=Lr,
        final Rr=Rr,
        final Lm=Lm) annotation (Placement(transformation(extent={{-10,-10},{10,
                10}}, origin={70,-100})));
      Modelica.Blocks.Continuous.Integrator int_dr annotation (Placement(
            transformation(extent={{-10,-10},{10,10}}, origin={110,-100})));
      Modelica.Blocks.Sources.Constant v_dr(k=0)
        annotation (Placement(transformation(extent={{-10,-10},{10,10}}, origin={-70,-76})));
      InductionMotors.BaseClasses.StatorCurrent_q i_qs_block(
        final Lr=Lr,
        final Ls=Ls,
        final Rr=Rr,
        final Lm=Lm,
        final Rs=Rs) annotation (Placement(transformation(extent={{-10,-10},{10,
                10}}, origin={70,90})));
      Modelica.Blocks.Continuous.Integrator int_qs annotation (Placement(
            transformation(extent={{-10,-10},{10,10}}, origin={110,90})));
      InductionMotors.BaseClasses.StatorCurrent_d i_ds_block(
        final Lr=Lr,
        final Ls=Ls,
        final Rr=Rr,
        final Lm=Lm,
        final Rs=Rs) annotation (Placement(transformation(extent={{-10,-10},{10,
                10}}, origin={70,50})));
      Modelica.Blocks.Continuous.Integrator int_ds annotation (Placement(
            transformation(extent={{-10,-10},{10,10}}, origin={110,50})));
      Modelica.Blocks.Sources.RealExpression I_qs(y=i_qs) annotation (Placement(
            transformation(extent={{-10,-12},{10,12}}, origin={-70,110})));
      Modelica.Blocks.Sources.RealExpression Der_i_qr(y=i_qr_block.der_i_qr)
        annotation (Placement(transformation(extent={{-10,-12},{10,12}}, origin={-70,84})));
      Modelica.Blocks.Sources.RealExpression I_dr(y=i_dr) annotation (Placement(
            transformation(extent={{-10,-12},{10,12}}, origin={-70,-128})));
      Modelica.Blocks.Sources.RealExpression I_ds(y=i_ds) annotation (Placement(
            transformation(extent={{-10,-12},{10,12}}, origin={-70,-12})));
      Modelica.Blocks.Sources.Constant v_qr(k=0) annotation (Placement(
            transformation(extent={{-10,-10},{10,10}}, origin={-70,12})));
      Modelica.Blocks.Sources.RealExpression I_qr(y=i_qr) annotation (Placement(
            transformation(extent={{-10,-12},{10,12}}, origin={-70,-30})));
      Modelica.Blocks.Sources.RealExpression Der_i_qs(y=i_qs_block.der_i_qs)
        annotation (Placement(transformation(extent={{-10,-12},{10,12}}, origin={-70,-52})));
      Modelica.Blocks.Sources.RealExpression Der_i_ds(y=i_ds_block.der_i_ds)
        annotation (Placement(transformation(extent={{-10,-12},{10,12}}, origin={-70,-108})));
      Modelica.Blocks.Sources.RealExpression Der_i_dr(y=i_dr_block.der_i_dr)
        annotation (Placement(transformation(extent={{-10,-12},{10,12}}, origin={-70,44})));
    equation
      connect(i_qr_block.der_i_qr, int_qr.u)
        annotation (Line(points={{82,-40},{98,-40}}, color={0,0,127}));
      connect(v_dr.y, i_dr_block.v_dr) annotation (Line(points={{-59,-76},{34,
              -76},{34,-90},{58,-90}},
                                  color={0,0,127}));

      connect(i_ds, int_ds.y)
        annotation (Line(points={{160,50},{121,50}}, color={0,0,127}));
      connect(i_qr, int_qr.y)
        annotation (Line(points={{160,-40},{121,-40}}, color={0,0,127}));
      connect(i_dr, i_dr)
        annotation (Line(points={{160,-100},{160,-100}},
                                                       color={0,0,127}));
      connect(int_dr.y, i_dr) annotation (Line(points={{121,-100},{160,-100}},
                          color={0,0,127}));
      connect(I_qs.y, i_qs_block.i_qs) annotation (Line(points={{-59,110},{0,
              110},{0,95.8},{58,95.8}}, color={0,0,127}));
      connect(v_qs, i_qs_block.v_qs) annotation (Line(
          points={{-160,100},{-51,100},{-51,99.8},{58,99.8}},
          color={0,0,127},
          pattern=LinePattern.Dash,
          thickness=0.5));
      connect(omega, i_qs_block.omega) annotation (Line(
          points={{-160,0},{-100,0},{-100,36},{-40,36},{-40,88},{10,88},{10,
              87.8},{58,87.8}},
          color={244,125,35},
          pattern=LinePattern.Dash,
          thickness=0.5));

      connect(I_dr.y, i_qs_block.i_dr) annotation (Line(points={{-59,-128},{
              40,-128},{40,84},{58,84}},
                                      color={0,0,127}));
      connect(I_ds.y, i_qs_block.i_ds) annotation (Line(points={{-59,-12},{20,
              -12},{20,80},{58,80}},
                                color={0,0,127}));
      connect(i_ds_block.der_i_ds, int_ds.u) annotation (Line(points={{82.7,
              50.1},{92,50.1},{92,50},{98,50}}, color={0,0,127}));
      connect(v_ds, i_ds_block.v_ds) annotation (Line(
          points={{-160,54},{-52,54},{-52,60},{58,60}},
          color={0,0,127},
          pattern=LinePattern.Dash,
          thickness=0.5));
      connect(i_qs_block.der_i_qs, int_qs.u) annotation (Line(points={{82.7,
              89.9},{89.35,89.9},{89.35,90},{98,90}}, color={0,0,127}));
      connect(i_dr_block.der_i_dr, int_dr.u) annotation (Line(points={{82.1,-100.1},
              {90.155,-100.1},{90.155,-100},{98,-100}}, color={0,0,127}));
      connect(i_ds_block.i_ds, i_qs_block.i_ds) annotation (Line(points={{58,56},
              {20,56},{20,80},{58,80}}, color={0,0,127}));
      connect(i_qr_block.i_ds, i_qs_block.i_ds) annotation (Line(points={{58,-50},
              {20,-50},{20,80},{58,80}}, color={0,0,127}));
      connect(i_qr_block.i_dr, i_qs_block.i_dr) annotation (Line(points={{58,-46.2},
              {40,-46.2},{40,84},{58,84}}, color={0,0,127}));
      connect(i_dr_block.i_dr, I_dr.y) annotation (Line(points={{58,-94},{40,
              -94},{40,-128},{-59,-128}},
                                     color={0,0,127}));
      connect(i_qr_block.v_qr, v_qr.y) annotation (Line(points={{58,-30},{32,
              -30},{32,12},{-59,12}},
                              color={0,0,127}));
      connect(i_ds_block.omega, omega) annotation (Line(
          points={{58,47.8},{58,46},{-40,46},{-40,36},{-100,36},{-100,0},{-160,
              0}},
          color={244,125,35},
          pattern=LinePattern.Dash,
          thickness=0.5));

      connect(i_dr_block.omega_r, omega_r) annotation (Line(
          points={{58,-102},{-14,-102},{-14,-94},{-160,-94}},
          color={0,140,72},
          pattern=LinePattern.Dash,
          thickness=0.5));
      connect(i_qr_block.omega_r, omega_r) annotation (Line(
          points={{58,-42.4},{-14,-42.4},{-14,-94},{-160,-94}},
          color={0,140,72},
          thickness=0.5,
          pattern=LinePattern.Dash));
      connect(i_ds_block.der_i_dr, Der_i_dr.y) annotation (Line(points={{58,52.2},
              {-50,52.2},{-50,44},{-59,44}},       color={0,0,127}));
      connect(i_dr_block.der_i_ds, Der_i_ds.y) annotation (Line(points={{58,-98},
              {-18,-98},{-18,-108},{-59,-108}}, color={0,0,127}));
      connect(i_ds_block.i_qs, I_qs.y) annotation (Line(points={{58,40},{58,
              34},{0,34},{0,110},{-59,110}},
                                  color={0,0,127}));
      connect(i_dr_block.i_qs, I_qs.y) annotation (Line(points={{58,-110},{0,
              -110},{0,110},{-59,110}},
                                  color={0,0,127}));
      connect(Der_i_qs.y, i_qr_block.der_i_qs) annotation (Line(points={{-59,-52},
              {46,-52},{46,-38.2},{58,-38.2}},   color={0,0,127}));
      connect(I_qr.y, i_qr_block.i_qr) annotation (Line(points={{-59,-30},{
              -12,-30},{-12,-34.2},{58,-34.2}},
                                            color={0,0,127}));
      connect(i_dr_block.i_qr, I_qr.y) annotation (Line(points={{58,-106},{
              -12,-106},{-12,-30},{-59,-30}},
                                          color={0,0,127}));
      connect(i_ds_block.i_qr, i_qr_block.i_qr) annotation (Line(points={{58,
              43.6},{-12,43.6},{-12,-34.2},{58,-34.2}}, color={0,0,127}));
      connect(Der_i_qr.y, i_qs_block.der_i_qr) annotation (Line(points={{-59,84},
              {-50,84},{-50,91.8},{58,91.8}}, color={0,0,127}));
      connect(int_qs.y, i_qs)
        annotation (Line(points={{121,90},{160,90}}, color={0,0,127}));
      annotation (
        Icon(coordinateSystem(preserveAspectRatio=false, extent={{-140,-140},{140,140}}),
            graphics={Rectangle(
              extent={{-140,140},{140,-144}},
              lineColor={0,0,0},
              lineThickness=0.5,
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid), Text(
              extent={{-58,170},{62,142}},
              textColor={0,0,255},
              textString="%name
")}),   Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-140},{140,
                140}})));
    end MotorModel;

    model MotorMachineInterface
      "Calculates the electromagnetic torque based on voltage and frequency"

      parameter Integer P=4 "Number of poles";

      parameter Real J;
      parameter Real Lr;
      parameter Real Ls;
      parameter Real Rr;
      parameter Real Lm;
      parameter Real Rs;

      Modelica.Blocks.Interfaces.RealInput V_rms(unit="V") "Prescribed RMS voltage"
        annotation (Placement(transformation(
            extent={{-20,-20},{20,20}},
            rotation=0,
            origin={-80,50}),
            iconTransformation(
            extent={{-20,-20},{20,20}},
            rotation=0,
            origin={-120,60})));
      Modelica.Blocks.Interfaces.RealInput f(final quantity="Frequency",
        final unit="Hz")
        "Controllable freuqency to the motor"
        annotation (Placement(transformation(
            extent={{-20,-20},{20,20}},
            rotation=0,
            origin={-80,0}),
            iconTransformation(
            extent={{-20,-20},{20,20}},
            rotation=0,
            origin={-80,0})));
      Modelica.Blocks.Interfaces.RealInput omega_r(final quantity="AngularVelocity",
        final unit="rad/s")
        "Prescribed rotational speed of rotor"
        annotation (Placement(transformation(
            extent={{-20,-20},{20,20}},
            rotation=0,
            origin={-80,-50}),
            iconTransformation(
            extent={{-20,-20},{20,20}},
            rotation=0,
            origin={-120,-60})));
      Modelica.Blocks.Interfaces.RealOutput tau_e(final quantity="Torque",
          final unit="N.m") "Electromagenetic torque of rotor" annotation (
          Placement(transformation(extent={{-20,-20},{20,20}}, origin={100,0}),
            iconTransformation(extent={{80,-20},{120,20}})));

      InductionMotors.BaseClasses.MotorModel1 motMod(
        final Lr=Lr,
        final Ls=Ls,
        final Rr=Rr,
        final Lm=Lm,
        final Rs=Rs) annotation (Placement(transformation(extent={{-10,-10},{10,
                10}}, origin={12,0})));
      InductionMotors.BaseClasses.TorqueBlock torBlo(
        final P=P,
        final Lm=Lm,
        final J=J) annotation (Placement(transformation(extent={{-10,-10},{10,
                10}}, origin={48,0})));
      InductionMotors.BaseClasses.VoltageConversion volCon
        "Obtain the stator voltage values in q-axis and d-axis" annotation (
          Placement(transformation(extent={{-10,-10},{10,10}}, origin={-38,50})));

      InductionMotors.BaseClasses.FrequencyConversion frequencyConversion
        annotation (Placement(transformation(extent={{-48,-10},{-28,10}})));
    equation
      connect(volCon.v_qs, motMod.v_qs) annotation (Line(points={{-26.1,56.1},{
              -18,56.1},{-18,56},{-10,56},{-10,7.14286},{0.571429,7.14286}},
                                                color={0,0,127},
          thickness=1));
      connect(volCon.v_ds, motMod.v_ds) annotation (Line(points={{-26.3,43.9},{
              -26.3,44},{-16,44},{-16,3.85714},{0.571429,3.85714}},   color={0,
              0,127},
          thickness=1));
      connect(volCon.V_rms, V_rms)
        annotation (Line(points={{-50,50},{-80,50}},  color={0,0,127},
          thickness=1));
      connect(frequencyConversion.f, f)
        annotation (Line(points={{-50,0},{-80,0}},  color={0,0,127},
          thickness=1));
      connect(motMod.omega_r, omega_r) annotation (Line(points={{0.571429,
              -6.71429},{-16,-6.71429},{-16,-50},{-80,-50}},
                                                color={0,0,127},
          thickness=1));
      connect(motMod.omega, frequencyConversion.omega) annotation (Line(
            points={{0.571429,0},{-12.7643,0},{-12.7643,-0.1},{-26.1,-0.1}},
            color={0,0,127},
          thickness=1));
      connect(motMod.i_qs, torBlo.i_qs) annotation (Line(
          points={{23.4286,6.42857},{29.7643,6.42857},{29.7643,7.1},{36.1,7.1}},
          color={0,0,127},
          thickness=1));

      connect(motMod.i_ds, torBlo.i_ds) annotation (Line(
          points={{23.4286,3.57143},{29.7643,3.57143},{29.7643,2.9},{36.1,2.9}},
          color={0,0,127},
          thickness=1));

      connect(motMod.i_qr, torBlo.i_qr) annotation (Line(
          points={{23.4286,-2.85714},{23.4286,-3.1},{36.1,-3.1}},
          color={0,0,127},
          thickness=1));
      connect(motMod.i_dr, torBlo.i_dr) annotation (Line(
          points={{23.4286,-7.14286},{29.7643,-7.14286},{29.7643,-7.1},{36.1,
              -7.1}},
          color={0,0,127},
          thickness=1));
      connect(torBlo.tau_e, tau_e) annotation (Line(
          points={{60,0},{100,0}},
          color={0,0,127},
          thickness=1));
      annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-60,
                -60},{80,80}}),                                    graphics={
              Rectangle(
              extent={{-100,100},{100,-100}},
              lineColor={0,0,127},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid),
              Text(
              extent={{-82,162},{82,116}},
              textColor={0,0,255},
              fillColor={255,255,255},
              fillPattern=FillPattern.None,
              textString="%name")}),
              defaultComponentName="torSpe",
        Documentation(info="<html>
<ul>
<li>
September, 2023, by Zhanwei He:<br/>
First implementation.
</li>
</ul>
</html>"),
        Diagram(coordinateSystem(extent={{-60,-60},{80,80}})));
    end MotorMachineInterface;

    block VoltageConversion
      "Convert the stator voltage from its root mean square (RMS) value into q-axis and d-axis voltages"
      extends Modelica.Blocks.Icons.Block;
      Modelica.Blocks.Interfaces.RealInput V_rms annotation (Placement(transformation(
              extent={{-140,-20},{-100,20}}),
                                            iconTransformation(extent={{-140,-20},{-100,
                20}})));
      Modelica.Blocks.Interfaces.RealOutput v_qs annotation (Placement(transformation(
              extent={{100,42},{138,80}}),iconTransformation(extent={{100,42},{138,80}})));
      Modelica.Blocks.Interfaces.RealOutput v_ds annotation (Placement(transformation(
              extent={{100,-78},{136,-42}}),iconTransformation(extent={{98,-80},{136,
                -42}})));

    algorithm
      v_ds:= V_rms;
    algorithm
      v_qs:= 0;

       // annotation (Line(points={{120,-60},{120,-60}}, color={0,0,127}),
       // Icon(coordinateSystem(preserveAspectRatio=false)),
       // Diagram(coordinateSystem(preserveAspectRatio=false)));
    end VoltageConversion;

    block SimVFD
        extends Modelica.Blocks.Icons.Block;
      Modelica.Blocks.Interfaces.RealInput N_ref
        annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
            iconTransformation(extent={{-140,40},{-100,80}})));
        parameter Integer f( start=50,fixed) "Nominal Frequency in Hz";
        parameter Integer p(start=4,fixed) " Number of Pole pairs ";
        parameter Real N_s( start=1500,fixed) "Synchronous Speed in RPM";
      Modelica.Blocks.Math.Gain Equivalent_Freq(k=p/(120))
        annotation (Placement(transformation(extent={{-64,50},{-44,70}})));
      Modelica.Blocks.Math.Division VFD_Ratio
        annotation (Placement(transformation(extent={{-20,40},{0,60}})));
      Modelica.Blocks.Sources.RealExpression realExpression(y=N_s*p/120)
        annotation (Placement(transformation(extent={{-60,8},{-40,30}})));
      Modelica.Blocks.Interfaces.RealInput V_in annotation (Placement(
            transformation(extent={{-140,-20},{-100,20}}),iconTransformation(extent={{-140,
                -20},{-100,20}})));
      Modelica.Blocks.Interfaces.RealInput Freq annotation (Placement(
            transformation(extent={{-140,-80},{-100,-40}}),iconTransformation(
              extent={{-140,-80},{-100,-40}})));
      Modelica.Blocks.Interfaces.RealOutput V_out annotation (Placement(
            transformation(extent={{100,-58},{136,-22}}), iconTransformation(extent={{100,-58},
                {136,-22}})));
      Modelica.Blocks.Math.Product product1
        annotation (Placement(transformation(extent={{20,-50},{40,-30}})));
      Modelica.Blocks.Math.Product product2
        annotation (Placement(transformation(extent={{20,30},{40,50}})));
      Modelica.Blocks.Math.Gain gain(k=2*Modelica.Constants.pi)
        annotation (Placement(transformation(extent={{60,30},{80,50}})));
      Modelica.Blocks.Interfaces.RealOutput Freq_out annotation (Placement(
            transformation(extent={{100,22},{136,58}}), iconTransformation(
              extent={{100,22},{136,58}})));
    equation
      connect(Equivalent_Freq.u, N_ref)
        annotation (Line(points={{-66,60},{-120,60}}, color={0,0,127}));
      connect(Equivalent_Freq.y, VFD_Ratio.u1)
        annotation (Line(points={{-43,60},{-38,60},{-38,56},{-22,56}},
                                                   color={0,0,127}));
      connect(product1.u2, VFD_Ratio.y) annotation (Line(points={{18,-46},{6,
              -46},{6,50},{1,50}},
                                color={0,0,127}));
      connect(product1.y, V_out) annotation (Line(points={{41,-40},{118,-40}},
                          color={0,0,127}));
      connect(product2.u1, VFD_Ratio.y)
        annotation (Line(points={{18,46},{6,46},{6,50},{1,50}},
                                                   color={0,0,127}));
      connect(product2.u2, Freq) annotation (Line(points={{18,34},{0,34},{0,
              -60},{-120,-60}},
                          color={0,0,127}));
      connect(gain.u, product2.y)
        annotation (Line(points={{58,40},{41,40}}, color={0,0,127}));
      connect(V_in, product1.u1) annotation (Line(points={{-120,0},{12,0},{12,
              -34},{18,-34}}, color={0,0,127}));
      connect(VFD_Ratio.u2, realExpression.y) annotation (Line(points={{-22,
              44},{-34,44},{-34,19},{-39,19}}, color={0,0,127}));
      connect(Freq_out, Freq_out)
        annotation (Line(points={{118,40},{118,40}}, color={0,0,127}));
      connect(gain.y, Freq_out)
        annotation (Line(points={{81,40},{118,40}}, color={0,0,127}));
     // annotation (
        //Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
         //       {100,100}})),
       // Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
         //       -100},{100,100}})),
       // uses(Modelica(version="4.0.0")));
    end SimVFD;

    model MotorModel1
      parameter Modelica.Units.SI.Reactance Lr;
      parameter Modelica.Units.SI.Reactance Ls;
      parameter Modelica.Units.SI.Resistance Rr;
      parameter Modelica.Units.SI.Reactance Lm;
      parameter Modelica.Units.SI.Reactance Rs;

      Modelica.Blocks.Interfaces.RealInput v_ds annotation (Placement(
            transformation(extent={{-20,-20},{20,20}}, origin={-160,54}),
                                                         iconTransformation(extent={{-180,34},
                {-140,74}})));
      Modelica.Blocks.Interfaces.RealInput v_qs annotation (Placement(
            transformation(extent={{-20,-20},{20,20}}, origin={-160,100}),
                                                        iconTransformation(extent={{-180,80},
                {-140,120}})));
      Modelica.Blocks.Interfaces.RealInput omega annotation (Placement(transformation(
              extent={{-20,-20},{20,20}}, origin={-160,0}),
                                            iconTransformation(extent={{-180,
                -20},{-140,20}})));
      Modelica.Blocks.Interfaces.RealInput omega_r annotation (Placement(transformation(
              extent={{-20,-20},{20,20}}, origin={-160,-94}),
                                              iconTransformation(extent={{-180,
                -114},{-140,-74}})));
      Modelica.Blocks.Interfaces.RealOutput i_qs annotation (Placement(
            transformation(extent={{-20,-20},{20,20}}, origin={160,90}),
                                                       iconTransformation(extent={{140,70},
                {180,110}})));
      Modelica.Blocks.Interfaces.RealOutput i_ds annotation (Placement(
            transformation(extent={{-20,-20},{20,20}}, origin={160,50}),
                                                      iconTransformation(extent={{140,30},
                {180,70}})));
      Modelica.Blocks.Interfaces.RealOutput i_qr annotation (Placement(
            transformation(extent={{-20,-20},{20,20}}, origin={160,-40}),
                                                       iconTransformation(extent={{140,-60},
                {180,-20}})));
      Modelica.Blocks.Interfaces.RealOutput i_dr annotation (Placement(
            transformation(extent={{-20,-20},{20,20}}, origin={160,-100}),
                                                         iconTransformation(extent={{140,
                -120},{180,-80}})));
      InductionMotors.BaseClasses.RotorCurrent_q i_qr_block(
        final Lr=Lr,
        final Rr=Rr,
        final Lm=Lm) annotation (Placement(transformation(extent={{-10,-10},{10,
                10}}, origin={20,-40})));
      Modelica.Blocks.Continuous.Integrator int_qr annotation (Placement(
            transformation(extent={{-10,-10},{10,10}}, origin={60,-40})));
      InductionMotors.BaseClasses.RotorCurrent_d i_dr_block(
        final Lr=Lr,
        final Rr=Rr,
        final Lm=Lm) annotation (Placement(transformation(extent={{-10,-10},{10,
                10}}, origin={20,-100})));
      Modelica.Blocks.Continuous.Integrator int_dr annotation (Placement(
            transformation(extent={{-10,-10},{10,10}}, origin={60,-100})));
      Modelica.Blocks.Sources.Constant v_dr(k=0)
        annotation (Placement(transformation(extent={{-10,-10},{10,10}}, origin={-108,-70})));
      InductionMotors.BaseClasses.StatorCurrent_q i_qs_block(
        final Lr=Lr,
        final Ls=Ls,
        final Rr=Rr,
        final Lm=Lm,
        final Rs=Rs) annotation (Placement(transformation(extent={{-10,-10},{10,
                10}}, origin={20,90})));
      Modelica.Blocks.Continuous.Integrator int_qs annotation (Placement(
            transformation(extent={{-10,-10},{10,10}}, origin={60,90})));
      InductionMotors.BaseClasses.StatorCurrent_d i_ds_block(
        final Lr=Lr,
        final Ls=Ls,
        final Rr=Rr,
        final Lm=Lm,
        final Rs=Rs) annotation (Placement(transformation(extent={{-10,-10},{10,
                10}}, origin={20,50})));
      Modelica.Blocks.Continuous.Integrator int_ds annotation (Placement(
            transformation(extent={{-10,-10},{10,10}}, origin={60,50})));
      Modelica.Blocks.Sources.Constant v_qr(k=0) annotation (Placement(
            transformation(extent={{-10,-10},{10,10}}, origin={-108,-30})));
    equation
      connect(i_qr_block.der_i_qr, int_qr.u)
        annotation (Line(points={{32,-40},{48,-40}}, color={238,46,47}));

      connect(i_dr, i_dr)
        annotation (Line(points={{160,-100},{160,-100}},
                                                       color={0,0,127}));
      connect(v_qs, i_qs_block.v_qs) annotation (Line(
          points={{-160,100},{-101,100},{-101,99.8},{8,99.8}},
          color={0,0,127},
          thickness=0.5));
      connect(omega, i_qs_block.omega) annotation (Line(
          points={{-160,0},{-80,0},{-80,88},{-40,88},{-40,87.8},{8,87.8}},
          color={244,125,35},
          thickness=0.5));

      connect(v_ds, i_ds_block.v_ds) annotation (Line(
          points={{-160,54},{-120,54},{-120,60},{8,60}},
          color={0,0,127},
          thickness=0.5));
      connect(i_qs_block.der_i_qs, int_qs.u) annotation (Line(points={{32.7,
              89.9},{39.35,89.9},{39.35,90},{48,90}}, color={238,46,47}));
      connect(i_dr_block.der_i_dr, int_dr.u) annotation (Line(points={{32.1,
              -100.1},{40.155,-100.1},{40.155,-100},{48,-100}},
                                                        color={238,46,47}));
      connect(i_ds_block.i_ds, i_qs_block.i_ds) annotation (Line(points={{8,56},{
              0,56},{0,80},{8,80}},     color={28,108,200}));
      connect(i_ds_block.omega, omega) annotation (Line(
          points={{8,47.8},{8,48},{-80,48},{-80,0},{-160,0}},
          color={244,125,35},
          thickness=0.5));

      connect(i_dr_block.der_i_ds, int_ds.u) annotation (Line(points={{8,-98},{
              -40,-98},{-40,32},{40,32},{40,50},{48,50}}, color={238,46,47}));
      connect(i_dr_block.omega_r, omega_r) annotation (Line(
          points={{8,-102},{-80,-102},{-80,-94},{-160,-94}},
          color={0,140,72},
          thickness=0.5));
      connect(i_qr_block.omega_r, omega_r) annotation (Line(
          points={{8,-42.4},{-80,-42.4},{-80,-94},{-160,-94}},
          color={0,140,72},
          thickness=0.5));
      connect(int_ds.y, i_qs_block.i_ds) annotation (Line(points={{71,50},{80,
              50},{80,70},{0,70},{0,80},{8,80}}, color={28,108,200}));
      connect(i_qr_block.i_ds, i_qs_block.i_ds) annotation (Line(points={{8,-50},
              {0,-50},{0,80},{8,80}}, color={28,108,200}));
      connect(i_dr_block.i_qs, i_qs_block.i_qs) annotation (Line(points={{8,
              -110},{-10,-110},{-10,96},{8,96},{8,95.8}}, color={28,108,200}));
      connect(int_qs.y, i_qs_block.i_qs) annotation (Line(points={{71,90},{80,
              90},{80,114},{-10,114},{-10,96},{8,96},{8,95.8}}, color={28,108,
              200}));
      connect(i_qr_block.i_qr, i_dr_block.i_qr) annotation (Line(points={{8,
              -34.2},{-30,-34.2},{-30,-106},{8,-106}}, color={28,108,200}));
      connect(i_ds_block.i_qr, i_dr_block.i_qr) annotation (Line(points={{8,
              43.6},{8,44},{-30,44},{-30,-106},{8,-106}}, color={28,108,200}));
      connect(int_qr.y, i_dr_block.i_qr) annotation (Line(points={{71,-40},{80,
              -40},{80,0},{-30,0},{-30,-106},{8,-106}}, color={28,108,200}));
      connect(i_qr_block.i_dr, i_dr_block.i_dr) annotation (Line(points={{8,
              -46.2},{8,-46},{-20,-46},{-20,-94},{8,-94}}, color={28,108,200}));
      connect(i_qs_block.i_dr, i_dr_block.i_dr) annotation (Line(points={{8,84},
              {-20,84},{-20,-94},{8,-94}}, color={28,108,200}));
      connect(int_dr.y, i_dr_block.i_dr) annotation (Line(points={{71,-100},{80,
              -100},{80,-120},{-20,-120},{-20,-94},{8,-94}}, color={28,108,200}));
      connect(i_qr_block.der_i_qr, i_qs_block.der_i_qr) annotation (Line(points=
             {{32,-40},{40,-40},{40,-20},{-68,-20},{-68,91.8},{8,91.8}}, color=
              {238,46,47}));
      connect(i_ds_block.der_i_dr, int_dr.u) annotation (Line(points={{8,52.2},
              {8,52},{-60,52},{-60,-80},{40,-80},{40,-100.1},{38.155,-100.1},{
              38.155,-100},{48,-100}}, color={238,46,47}));
      connect(i_qr_block.der_i_qs, int_qs.u) annotation (Line(points={{8,-38.2},
              {6,-38.2},{6,-38},{-48,-38},{-48,108},{40,108},{40,90},{48,90}},
            color={238,46,47}));
      connect(v_qr.y, i_qr_block.v_qr) annotation (Line(
          points={{-97,-30},{8,-30}},
          color={0,0,0},
          thickness=0.5));
      connect(v_dr.y, i_dr_block.v_dr) annotation (Line(
          points={{-97,-70},{-32,-70},{-32,-90},{8,-90}},
          color={0,0,0},
          thickness=0.5));
      connect(int_qs.y, i_qs)
        annotation (Line(points={{71,90},{160,90}},  color={28,108,200},
          thickness=0.5));
      connect(i_ds, int_ds.y)
        annotation (Line(points={{160,50},{71,50}},  color={28,108,200},
          thickness=0.5));
      connect(i_qr, int_qr.y)
        annotation (Line(points={{160,-40},{71,-40}},  color={28,108,200},
          thickness=0.5));
      connect(int_dr.y, i_dr) annotation (Line(points={{71,-100},{160,-100}},
                          color={28,108,200},
          thickness=0.5));
      connect(i_ds_block.der_i_ds, int_ds.u) annotation (Line(points={{32.7,
              50.1},{34,50.1},{34,50},{48,50}}, color={238,46,47}));
      connect(i_ds_block.i_qs, i_qs_block.i_qs) annotation (Line(points={{8,40},
              {-10,40},{-10,96},{8,96},{8,95.8}}, color={28,108,200}));
      annotation (
        Icon(coordinateSystem(preserveAspectRatio=false, extent={{-140,-140},{140,140}}),
            graphics={Rectangle(
              extent={{-140,140},{140,-144}},
              lineColor={0,0,0},
              lineThickness=0.5,
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid), Text(
              extent={{-58,170},{62,142}},
              textColor={0,0,255},
              textString="%name
")}),   Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-140},{140,
                140}})));
    end MotorModel1;

    block FrequencyConversion
      "Convert the frequency from Hertz to radians per second"
       extends Modelica.Blocks.Icons.Block;
        Modelica.Blocks.Interfaces.RealInput f "Value in hertz" annotation (Placement(transformation(
              extent={{-140,-20},{-100,20}}),
                                            iconTransformation(extent={{-140,-20},{-100,
                20}})));
      Modelica.Blocks.Interfaces.RealOutput omega "Value in radian per second" annotation (Placement(transformation(
              extent={{100,-20},{138,18}}),
                                          iconTransformation(extent={{100,-20},
                {138,18}})));

    algorithm
      omega := 2*Modelica.Constants.pi*f;

    end FrequencyConversion;
  end BaseClasses;

  package Data
    extends Modelica.Icons.MaterialPropertiesPackage;
    record Generic "Generic record of induction machine parameters"
      extends Modelica.Icons.Record;
      parameter Integer P = 4 "Number of Poles";
      parameter Real J = 0.17 "Moment of Inertia [kg/m²]";
      parameter Real Lr = 0.1458 "Rotor Inductance [H]";
      parameter Real Ls = 0.1457 "Stator Inductance [H]";
      parameter Real Lm = 0.1406 "Mutual Inductance [H]";
      parameter Real Rs = 1 "Stator Resistance [ohm]";
      parameter Real Rr = 1.145 "Rotor Resistance [ohm]";
      parameter Real Freq = 50 "Standard Frequency [Hz]";
      parameter Real Voltage = 400 "Standard Voltage [V]";
      annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
      coordinateSystem(preserveAspectRatio=false)));
    end Generic;

    record IM_5HP_400V_50Hz =
      Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.Data.Generic
        (
        P=4,
        J=0.0131,
        Lr=0.178039,
        Ls=0.178039,
        Lm=0.1722,
        Rs=1.405,
        Rr=1.395,
        Freq=50,
        Voltage=400)   "Generic 5hp motor operating at 400V and 50Hz"
      annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
      coordinateSystem(preserveAspectRatio=false)));
    record IM_10HP_400V_50Hz =
      Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.Data.Generic
        (
        P=4,
        J=0.0343 "Moment of Inertia [kg/m2]",
        Lr=0.127145 "Rotor Inductance [H]",
        Ls=0.127145 "Stator Inductance [H]",
        Lm=0.1241 "Mutual Inductance [H]",
        Rs=0.7384 "Stator Resistance [ohm]",
        Rr=0.7402 "Rotor Resistance [ohm]",
        Freq=50 "Standard Frequency [Hz]",
        Voltage=400)     "Generic 10hp motor operating at 400V and 50Hz"
      annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
    record IM_20HP_400V_50Hz =
      Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.Data.Generic
        (
        P=4,
        J=0.102,
        Lr=0.065181,
        Ls=0.065181,
        Lm=0.06419,
        Rs=0.2147,
        Rr=0.2205,
        Freq=50,
        Voltage=400)   "Generic 20hp motor operating at 400V and 50Hz"
      annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
      coordinateSystem(preserveFARAspectio=false)));
    record IM_50HP_400V_50Hz =
      Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.Data.Generic
        (
        P=4,
        J=0.37,
        Lr=0.027834,
        Ls=0.027834,
        Lm=0.02711,
        Rs=0.08233,
        Rr=0.0503,
        Freq=50,
        Voltage=400)   "Generic 50hp motor operating at 400V and 50Hz"
      annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
      coordinateSystem(preserveAspectRatio=false)));
    record IM_100HP_400V_50Hz =
      Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.Data.Generic
        (
        P=4,
        J=1.25,
        Lr=0.015435,
        Ls=0.015435,
        Lm=0.0151,
        Rs=0.03552,
        Rr=0.02092,
        Freq=50,
        Voltage=400)   "Generic 100hp motor operating at 400V and 50Hz"
      annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
      coordinateMenuSystem(preserveAspectRatio=false)));
    record IM_150HP_400V_50Hz =
      Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.Data.Generic
        (
        P=4,
        J=2.3,
        Lr=0.010606,
        Ls=0.010606,
        Lm=0.01038,
        Rs=0.02155,
        Rr=0.01231,
        Freq=50,
        Voltage=400)   "Generic 150hp motor operating at 400V and 50Hz"
      annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
      coordinateSystem(preserveAspectRatio=false)));
    record IM_200HP_400V_50Hz =
      Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.Data.Generic
        (
        P=4,
        J=2.9,
        Lr=0.007842,
        Ls=0.007842,
        Lm=0.00769,
        Rs=0.01379,
        Rr=0.007728,
        Freq=50,
        Voltage=400)   "Generic 200hp motor operating at 400V and 50Hz"
      annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
      coordinateSystem(preserveAspectRatio=false)));
    record IM_5HP_460V_60Hz =
      Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.Data.Generic
        (
        P=4,
        J=0.02,
        Lr=0.209674,
        Ls=0.209674,
        Lm=0.2037,
        Rs=1.115,
        Rr=1.083,
        Freq=60,
        Voltage=460)   "Generic 5hp motor operating at 460V and 60Hz"
      annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
      coordinateSystem(preserveAspectRatio=false)));
    record IM_10HP_460V_60Hz =
      Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.Data.Generic
        (
        P=4,
        J=0.05,
        Lr=0.152752,
        Ls=0.152752,
        Lm=0.1486,
        Rs=0.6837,
        Rr=0.451,
        Freq=60,
        Voltage=460)   "Generic 10hp motor operating at 460V and 60Hz"
      annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
      coordinateSystem(preserveAspectRatio=false)));
    record IM_20HP_460V_60Hz =
      Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.Data.Generic
        (
        P=4,
        J=0.1,
        Lr=0.078331,
        Ls=0.078331,
        Lm=0.07614,
        Rs=0.2761,
        Rr=0.1645,
        Freq=60,
        Voltage=460)   "Generic 20hp motor operating at 460V and 60Hz"
      annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
      coordinateSystem(preserveAspectRatio=false)));
    record IM_50HP_460V_60Hz =
      Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.Data.Generic
        (
        P=4,
        J=0.4,
        Lr=0.031257,
        Ls=0.031257,
        Lm=0.03039,
        Rs=0.09961,
        Rr=0.05837,
        Freq=60,
        Voltage=460)   "Generic 50hp motor operating at 460V and 60Hz"
      annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
      coordinateSystem(preserveAspectRatio=false)));
    record IM_100HP_460V_60Hz =
      Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.Data.Generic
        (
        P=4,
        J=1.3,
        Lr=0.017029,
        Ls=0.017029,
        Lm=0.01664,
        Rs=0.03957,
        Rr=0.02215,
        Freq=60,
        Voltage=460)   "Generic 100hp motor operating at 460V and 60Hz"
      annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
      coordinateSystem(preserveAspectRatio=false)));
    record IM_150HP_460V_60Hz =
      Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.Data.Generic
        (
        P=4,
        J=2,
        Lr=0.011233,
        Ls=0.011233,
        Lm=0.01095,
        Rs=0.0302,
        Rr=0.01721,
        Freq=60,
        Voltage=460)   "Generic 150hp motor operating at 460V and 60Hz"
      annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
      coordinateSystem(preserveAspectRatio=false)));
    record IM_200HP_460V_60Hz =
      Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.Data.Generic
        (
        P=4,
        J=2.6,
        Lr=0.009605,
        Ls=0.009605,
        Lm=0.009415,
        Rs=0.01818,
        Rr=0.009956,
        Freq=60,
        Voltage=460)   "Generic 200hp motor operating at 460V and 60Hz"
      annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
      coordinateSystem(preserveAspectRatio=false)));
  end Data;
end InductionMotors;
