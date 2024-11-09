within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors1.BaseClasses;
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

  InductionMotors1.BaseClasses.MotorModel1 motMod(
    final Lr=Lr,
    final Ls=Ls,
    final Rr=Rr,
    final Lm=Lm,
    final Rs=Rs) annotation (Placement(transformation(extent={{-10,-10},{10,10}},
          origin={12,0})));
  InductionMotors1.BaseClasses.TorqueBlock torBlo(
    final P=P,
    final Lm=Lm,
    final J=J) annotation (Placement(transformation(extent={{-10,-10},{10,10}},
          origin={48,0})));
  InductionMotors1.BaseClasses.VoltageConversion volCon
    "Obtain the stator voltage values in q-axis and d-axis" annotation (
      Placement(transformation(extent={{-10,-10},{10,10}}, origin={-38,50})));

  InductionMotors1.BaseClasses.FrequencyConversion frequencyConversion
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
      points={{23.4286,-7.14286},{29.7643,-7.14286},{29.7643,-7.1},{36.1,-7.1}},
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
