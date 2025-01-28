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

  Modelica.Blocks.Interfaces.RealInput V_rms(unit="V") "Prescribed RMS voltage"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-80,50}),
        iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-160,60})));
  Modelica.Blocks.Interfaces.RealInput f(final quantity="Frequency",
    final unit="Hz")
    "Controllable freuqency to the motor"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-160,0}),
        iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-160,0})));
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
        origin={-160,-60})));
  Modelica.Blocks.Interfaces.RealOutput tau_e(final quantity="Torque",
      final unit="N.m") "Electromagenetic torque of rotor" annotation (
      Placement(transformation(extent={{-20,-20},{20,20}}, origin={160,0}),
        iconTransformation(extent={{140,-20},{180,20}})));

  VoltageConversion volCon
    "Obtain the stator voltage values in q-axis and d-axis"
    annotation (Placement(transformation(extent={{-48,40},{-28,60}})));
  FrequencyConversion frequencyConversion
    annotation (Placement(transformation(extent={{-44,-10},{-24,10}})));
  MotorModel motMod(
    Lr=Lr,
    Ls=Ls,
    Rr=Rr,
    Lm=Lm,
    Rs=Rs) annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  TorqueBlock torBlo(
    P=P,
    Lm=Lm,
    J=J) annotation (Placement(transformation(extent={{38,-10},{58,10}})));
equation
  connect(volCon.v_qs, motMod.v_qs) annotation (Line(points={{-26.1,56.1},{-6,
          56.1},{-6,7.14286},{-1.42857,7.14286}},
                                            color={0,0,127},
      thickness=1));
  connect(volCon.v_ds, motMod.v_ds) annotation (Line(points={{-26.3,43.9},{-26,
          43.9},{-26,44},{-10,44},{-10,3.85714},{-1.42857,3.85714}},
                                                                  color={0,
          0,127},
      thickness=1));
  connect(volCon.V_rms, V_rms)
    annotation (Line(points={{-50,50},{-80,50}},  color={0,0,127},
      thickness=1));
  connect(frequencyConversion.f, f)
    annotation (Line(points={{-46,0},{-66,0},{-66,0},{-160,0}},
                                                color={0,0,127},
      thickness=1));
  connect(motMod.omega_r, omega_r) annotation (Line(points={{-1.42857,-6.71429},
          {-16,-6.71429},{-16,-50},{-80,-50}},
                                            color={0,0,127},
      thickness=1));
  connect(motMod.omega, frequencyConversion.omega) annotation (Line(
        points={{-1.42857,0},{-11.7643,0},{-11.7643,-0.1},{-22.1,-0.1}},
        color={0,0,127},
      thickness=1));
  connect(motMod.i_qs, torBlo.i_qs) annotation (Line(
      points={{21.4286,6.42857},{29.7643,6.42857},{29.7643,7.1},{36.1,7.1}},
      color={0,0,127},
      thickness=1));

  connect(motMod.i_ds, torBlo.i_ds) annotation (Line(
      points={{21.4286,3.57143},{29.7643,3.57143},{29.7643,2.9},{36.1,2.9}},
      color={0,0,127},
      thickness=1));

  connect(motMod.i_qr, torBlo.i_qr) annotation (Line(
      points={{21.4286,-2.85714},{21.4286,-3.1},{36.1,-3.1}},
      color={0,0,127},
      thickness=1));
  connect(motMod.i_dr, torBlo.i_dr) annotation (Line(
      points={{21.4286,-7.14286},{29.7643,-7.14286},{29.7643,-7.1},{36.1,-7.1}},
      color={0,0,127},
      thickness=1));
  connect(torBlo.tau_e, tau_e) annotation (Line(
      points={{60,0},{160,0}},
      color={0,0,127},
      thickness=1));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-140,-100},{100,80}}),
        graphics={Rectangle(
          extent={{-140,140},{140,-144}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid), Text(
          extent={{-58,170},{62,142}},
          textColor={0,0,255},
          textString="%name
")}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-100},{100,
            80}})),
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
