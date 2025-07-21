within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.BaseClasses;
model MotorMachineInterface
  "Calculates the electromagnetic torque based on voltage and frequency"

  parameter Integer P=4 "Number of poles";

  parameter Real J "Moment of Inertia [Kg/m2]";
  parameter Real Lr "Rotor Inductance [H]";
  parameter Real Ls "Stator Inductance [H]";
  parameter Real Rr "Rotor Resistance [ohm]";
  parameter Real Lm "Mutual Inductance [H]";
  parameter Real Rs "Stator Resistance [ohm]";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput V_rms(unit="V")
    "Prescribed RMS voltage"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput f(
    final quantity="Frequency",
    final unit="Hz")
    "Controllable freuqency to the motor"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput omega_r(
    final quantity="AngularVelocity",
    final unit="rad/s")
    "Prescribed rotational speed of rotor"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput i_qs
    annotation (Placement(transformation(extent={{100,30},{140,70}}),
        iconTransformation(extent={{100,30},{140,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput i_ds
    annotation (Placement(transformation(extent={{100,60},{140,100}}),
        iconTransformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput tau_e(
    final quantity="Torque",
    final unit="N.m")
    "Electromagenetic torque of rotor"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

  Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.BaseClasses.VoltageConversion volCon
    "Obtain the stator voltage values in q-axis and d-axis"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.BaseClasses.FrequencyConversion
    freCon "Convert the frequency from Hertz to radians per second"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.BaseClasses.MotorModel motMod(
    final Lr=Lr,
    final Ls=Ls,
    final Rr=Rr,
    final Lm=Lm,
    final Rs=Rs)
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.BaseClasses.TorqueBlock torBlo(
    final P=P,
    final Lm=Lm,
    final J=J)
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));

equation
  connect(volCon.v_qs, motMod.v_qs) annotation (Line(points={{-58,66},{-30,66},{
          -30,8},{-22,8}}, color={0,0,127}));
  connect(volCon.v_ds, motMod.v_ds) annotation (Line(points={{-58,54},{-40,54},{
          -40,3},{-22,3}},color={0,0,127}));
  connect(volCon.V_rms, V_rms)
    annotation (Line(points={{-82,60},{-120,60}}, color={0,0,127}));
  connect(freCon.f, f)
    annotation (Line(points={{-82,0},{-120,0}}, color={0,0,127}));
  connect(motMod.omega_r, omega_r) annotation (Line(points={{-22,-8},{-30,-8},{-30,
          -60},{-120,-60}}, color={0,0,127}));
  connect(motMod.omega, freCon.omega) annotation (Line(points={{-22,-3},{
          -39.7643,-3},{-39.7643,-0.1},{-58.1,-0.1}},
                                             color={0,0,127}));
  connect(motMod.i_qs, torBlo.i_qs) annotation (Line(
      points={{2,8},{58,8}},  color={0,0,127}));
  connect(motMod.i_ds, torBlo.i_ds) annotation (Line(
      points={{2,4},{58,4}},  color={0,0,127}));
  connect(motMod.i_qr, torBlo.i_qr) annotation (Line(
      points={{2,-4},{58,-4}},  color={0,0,127}));
  connect(motMod.i_dr, torBlo.i_dr) annotation (Line(
      points={{2,-8},{58,-8}},  color={0,0,127}));
  connect(torBlo.tau_e, tau_e) annotation (Line(
      points={{82,0},{120,0}}, color={0,0,127}));
  connect(motMod.i_qs, i_qs)
    annotation (Line(points={{2,8},{40,8},{40,50},{120,50}}, color={0,0,127}));
  connect(motMod.i_ds, i_ds)
    annotation (Line(points={{2,4},{30,4},{30,80},{120,80}}, color={0,0,127}));
  annotation (defaultComponentName="motMacInt",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,140},{100,100}},
          textString="%name",
          textColor={0,0,255})}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})),
    Documentation(info="<html>

</html>", revisions="<html>
<ul>
<li>
January, 2025, by Viswanathan Ganesh:<br/>
Updated Icon Layer.
</li>
<li>
May 07, 2024, by Viswanathan Ganesh and Zhanwei He:<br/>
First Implementation.
</li>
</ul>
</html>"));
end MotorMachineInterface;
