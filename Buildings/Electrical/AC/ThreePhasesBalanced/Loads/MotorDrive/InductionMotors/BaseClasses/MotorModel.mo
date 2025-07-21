within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.BaseClasses;
model MotorModel "Induction Machine Model"
  parameter Modelica.Units.SI.Reactance Lr "Rotor Inductance";
  parameter Modelica.Units.SI.Reactance Ls "Stator Inductance";
  parameter Modelica.Units.SI.Resistance Rr "Rotor Resistance";
  parameter Modelica.Units.SI.Reactance Lm "Mutual Inductance";
  parameter Modelica.Units.SI.Reactance Rs "Stator Resistance";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput v_ds "D-axis stator voltage"
    annotation (Placement(transformation(extent={{-180,50},{-140,90}}),
        iconTransformation(extent={{-140,10},{-100,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput v_qs "Q-axis stator voltage"
    annotation (Placement(transformation(extent={{-180,90},{-140,130}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput omega "Fundamental frequency"
    annotation (Placement(transformation(extent={{-180,10},{-140,50}}),
        iconTransformation(extent={{-140,-50},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput omega_r "Rotor frequency"
    annotation (Placement(transformation(extent={{-180,-140},{-140,-100}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput i_qs "Q-axis stator current"
    annotation (Placement(transformation(extent={{140,70},{180,110}}),
        iconTransformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput i_ds "D-axis stator current"
    annotation (Placement(transformation(extent={{140,30},{180,70}}),
        iconTransformation(extent={{100,20},{140,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput i_qr "Q-axis rotor current"
    annotation (Placement(transformation(extent={{140,-60},{180,-20}}),
        iconTransformation(extent={{100,-60},{140,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput i_dr "D-axis rotor current"
    annotation (Placement(transformation(extent={{140,-120},{180,-80}}),
        iconTransformation(extent={{100,-100},{140,-60}})));

  Modelica.Blocks.Continuous.Integrator int_qr
    annotation (Placement(transformation(extent={{-10,-10},{10,10}}, origin={110,-40})));
  Modelica.Blocks.Continuous.Integrator int_dr
    annotation (Placement(transformation(extent={{-10,-10},{10,10}}, origin={110,-100})));
  Modelica.Blocks.Sources.Constant v_dr(k=0)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}}, origin={-70,-80})));
  Modelica.Blocks.Continuous.Integrator int_qs
    annotation (Placement(transformation(extent={{-10,-10},{10,10}}, origin={110,90})));
  Modelica.Blocks.Continuous.Integrator int_ds
    annotation (Placement(transformation(extent={{-10,-10},{10,10}}, origin={110,50})));
  Modelica.Blocks.Sources.RealExpression I_qs(y=i_qs)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}}, origin={-70,120})));
  Modelica.Blocks.Sources.RealExpression I_dr(y=i_dr)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}}, origin={-70,-130})));
  Modelica.Blocks.Sources.RealExpression I_ds(y=i_ds)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}}, origin={-70,-10})));
  Modelica.Blocks.Sources.RealExpression I_qr(y=i_qr)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}}, origin={-70,-30})));
  Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.BaseClasses.StatorCurrent_q i_qs_block(
    final Lr=Lr,
    final Rr=Rr,
    final Lm=Lm,
    final Rs=Rs,
    final Ls=Ls)
    "Calculates Q-axis current of stator"
    annotation (Placement(transformation(extent={{60,80},{80,100}})));
  Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.BaseClasses.StatorCurrent_d i_ds_block(
    final Lr=Lr,
    final Rr=Rr,
    final Lm=Lm,
    final Rs=Rs,
    final Ls=Ls)
    "Calculates D-axis current of stator"
    annotation (Placement(transformation(extent={{60,40},{80,60}})));
  Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.BaseClasses.RotorCurrent_d i_dr_block(
    final Lr=Lr,
    final Rr=Rr,
    final Lm=Lm)
    "Calculates D-axis current of rotor"
    annotation (Placement(transformation(extent={{60,-110},{80,-90}})));
  Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.BaseClasses.RotorCurrent_q i_qr_block(
    final Lr=Lr,
    final Rr=Rr,
    final Lm=Lm)
    "Calculates Q-axis current of rotor"
    annotation (Placement(transformation(extent={{60,-50},{80,-30}})));
equation
  connect(i_qr_block.der_i_qr, int_qr.u)
    annotation (Line(points={{82,-40},{98,-40}}, color={0,0,127}));
  connect(v_dr.y, i_dr_block.v_dr)
    annotation (Line(points={{-59,-80},{20,-80},{20,-91},{58,-91}},  color={0,0,127}));
  connect(i_ds, int_ds.y)
    annotation (Line(points={{160,50},{121,50}}, color={0,0,127}));
  connect(i_qr, int_qr.y)
    annotation (Line(points={{160,-40},{121,-40}}, color={0,0,127}));
  connect(i_dr, i_dr)
    annotation (Line(points={{160,-100},{160,-100}}, color={0,0,127}));
  connect(int_dr.y, i_dr) annotation (Line(points={{121,-100},{160,-100}},
         color={0,0,127}));
  connect(I_qs.y, i_qs_block.i_qs) annotation (Line(points={{-59,120},{-10,120},
          {-10,96},{58,96}}, color={0,0,127}));
  connect(I_dr.y, i_qs_block.i_dr) annotation (Line(points={{-59,-130},{40,-130},
          {40,84},{58,84}}, color={0,0,127}));
  connect(I_ds.y, i_qs_block.i_ds) annotation (Line(points={{-59,-10},{10,-10},{
          10,81},{58,81}},  color={0,0,127}));
  connect(i_ds_block.der_i_ds, int_ds.u) annotation (Line(points={{82,50},{92,50},
          {92,50},{98,50}}, color={0,0,127}));
  connect(v_ds, i_ds_block.v_ds) annotation (Line(points={{-160,70},{-20,70},{-20,59},{58,59}},
      color={0,0,127}, pattern=LinePattern.Dash, thickness=0.5));
  connect(i_dr_block.der_i_dr, int_dr.u) annotation (Line(points={{82,-100},{98,
          -100}}, color={0,0,127}));
  connect(i_qr_block.i_dr, i_qs_block.i_dr) annotation (Line(points={{58,-46},{
          40,-46},{40,84},{58,84}}, color={0,0,127}));
  connect(i_dr_block.i_dr, I_dr.y) annotation (Line(points={{58,-94},{40,-94},{
          40,-130},{-59,-130}}, color={0,0,127}));
  connect(i_dr_block.i_qs, I_qs.y) annotation (Line(points={{58,-109},{-10,-109},
          {-10,120},{-59,120}}, color={0,0,127}));
  connect(I_qr.y, i_qr_block.i_qr) annotation (Line(points={{-59,-30},{-20,-30},
          {-20,-34},{58,-34}}, color={0,0,127}));
  connect(i_dr_block.i_qr, I_qr.y) annotation (Line(points={{58,-106},{-20,-106},
          {-20,-30},{-59,-30}}, color={0,0,127}));
  connect(int_qs.y, i_qs)
    annotation (Line(points={{121,90},{160,90}}, color={0,0,127}));
  connect(int_qs.u, i_qs_block.der_i_qs) annotation (Line(points={{98,90},{91.35,
          90},{91.35,90},{82,90}}, color={0,0,127}));
  connect(v_qs, i_qs_block.v_qs)
    annotation (Line(points={{-160,110},{50,110},{50,99},{58,99}}, color={0,0,127}));
  connect(omega, i_ds_block.omega) annotation (Line(points={{-160,30},{-40,30},
          {-40,48},{58,48}}, color={0,0,127}));
  connect(omega, i_qs_block.omega) annotation (Line(points={{-160,30},{-40,30},
          {-40,88},{58,88}}, color={0,0,127}));
  connect(omega_r, i_qr_block.omega_r) annotation (Line(points={{-160,-120},{
          -30,-120},{-30,-42},{58,-42}}, color={0,0,127}));
  connect(omega_r, i_dr_block.omega_r) annotation (Line(points={{-160,-120},{
          -30,-120},{-30,-102},{58,-102}}, color={0,0,127}));
  connect(I_qr.y, i_ds_block.i_qr) annotation (Line(points={{-59,-30},{-20,-30},
          {-20,44},{58,44}}, color={0,0,127}));
  connect(I_qs.y, i_ds_block.i_qs) annotation (Line(points={{-59,120},{-10,120},
          {-10,41},{58,41}}, color={0,0,127}));
  connect(I_ds.y, i_ds_block.i_ds) annotation (Line(points={{-59,-10},{10,-10},{
          10,56},{58,56}}, color={0,0,127}));
  connect(I_ds.y, i_qr_block.i_ds) annotation (Line(points={{-59,-10},{10,-10},
          {10,-49},{58,-49}},color={0,0,127}));
  connect(i_qr_block.der_i_qr, i_qs_block.der_i_qr) annotation (Line(points={{
          82,-40},{90,-40},{90,-10},{20,-10},{20,92},{58,92}}, color={0,0,127}));
  connect(i_dr_block.der_i_dr, i_ds_block.der_i_dr) annotation (Line(points={{
          82,-100},{90,-100},{90,-60},{30,-60},{30,52},{58,52}}, color={0,0,127}));
  connect(i_qs_block.der_i_qs, i_qr_block.der_i_qs) annotation (Line(points={{
          82,90},{90,90},{90,70},{50,70},{50,-38},{58,-38}}, color={0,0,127}));
  connect(i_ds_block.der_i_ds, i_dr_block.der_i_ds) annotation (Line(points={{
          82,50},{90,50},{90,20},{0,20},{0,-98},{58,-98}}, color={0,0,127}));
  connect(v_dr.y, i_qr_block.v_qr) annotation (Line(points={{-59,-80},{20,-80},
          {20,-31},{58,-31}}, color={0,0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid), Text(
          extent={{-100,140},{100,100}},
          textColor={0,0,255},
          textString="%name")}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-140},{140,
            140}})),
    Documentation(revisions="<html>
<ul>
<li>
November 10, 2023, by Viswanathan Ganesh:<br/>
Initial Implementation.
</li>
</ul>
</html>", info="<html>
<p>
Induction Machine Model
</p>
</html>"));
end MotorModel;
