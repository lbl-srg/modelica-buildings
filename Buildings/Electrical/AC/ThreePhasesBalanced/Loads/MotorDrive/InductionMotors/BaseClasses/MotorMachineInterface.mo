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
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput tau_e(
    final quantity="Torque",
    final unit="N.m")
    "Electromagenetic torque of rotor"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

  VoltageConversion volCon
    "Obtain the stator voltage values in q-axis and d-axis"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  FrequencyConversion frequencyConversion
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  MotorModel motMod(
    final Lr=Lr,
    final Ls=Ls,
    final Rr=Rr,
    final Lm=Lm,
    final Rs=Rs)
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  TorqueBlock torBlo(
    final P=P,
    final Lm=Lm,
    final J=J)
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
equation
  connect(volCon.v_qs, motMod.v_qs) annotation (Line(points={{-38,66},{0,66},{0,
          8},{18,8}}, color={0,0,127}));
  connect(volCon.v_ds, motMod.v_ds) annotation (Line(points={{-38,54},{-10,54},{
          -10,2},{18,2}}, color={0,0,127}));
  connect(volCon.V_rms, V_rms)
    annotation (Line(points={{-62,60},{-120,60}}, color={0,0,127}));
  connect(frequencyConversion.f, f)
    annotation (Line(points={{-62,0},{-120,0}}, color={0,0,127}));
  connect(motMod.omega_r, omega_r) annotation (Line(points={{18,-8},{0,-8},{0,-60},
          {-120,-60}},                      color={0,0,127}));
  connect(motMod.omega, frequencyConversion.omega) annotation (Line(
        points={{18,-2},{-19.7643,-2},{-19.7643,-0.1},{-38.1,-0.1}},
        color={0,0,127}));
  connect(motMod.i_qs, torBlo.i_qs) annotation (Line(
      points={{42,8},{58,8}},
      color={0,0,127}));
  connect(motMod.i_ds, torBlo.i_ds) annotation (Line(
      points={{42,4},{58,4}},
      color={0,0,127}));
  connect(motMod.i_qr, torBlo.i_qr) annotation (Line(
      points={{42,-4},{58,-4}},
      color={0,0,127}));
  connect(motMod.i_dr, torBlo.i_dr) annotation (Line(
      points={{42,-8},{58,-8}},
      color={0,0,127}));
  connect(torBlo.tau_e, tau_e) annotation (Line(
      points={{82,0},{120,0}},
      color={0,0,127}));
  annotation (
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
<ul>
<li>
January, 2025, by Viswanathan Ganesh:<br/>
Updated Icon Layer.
<li>
September, 2023, by Zhanwei He:<br/>
First implementation.
</li>
</ul>

</html>"));
end MotorMachineInterface;
