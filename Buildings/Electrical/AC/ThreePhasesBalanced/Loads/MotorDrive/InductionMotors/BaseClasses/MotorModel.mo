within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.BaseClasses;
model MotorModel "Induction Machine Model"
  parameter Modelica.Units.SI.Reactance Lr;
  parameter Modelica.Units.SI.Reactance Ls;
  parameter Modelica.Units.SI.Resistance Rr;
  parameter Modelica.Units.SI.Reactance Lm;
  parameter Modelica.Units.SI.Reactance Rs;

  Buildings.Controls.OBC.CDL.Interfaces.RealInput v_ds
    annotation (Placement(transformation(extent={{-180,40},{-140,80}}),
        iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput v_qs
    annotation (Placement(transformation(extent={{-180,80},{-140,120}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput omega
    annotation (Placement(transformation(extent={{-180,-20},{-140,20}}),
        iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput omega_r
    annotation (Placement(transformation(extent={{-180,-140},{-140,-100}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput i_qs
    annotation (Placement(transformation(extent={{140,70},{180,110}}),
        iconTransformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput i_ds
    annotation (Placement(transformation(extent={{140,30},{180,70}}),
        iconTransformation(extent={{100,20},{140,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput i_qr
    annotation (Placement(transformation(extent={{140,-60},{180,-20}}),
        iconTransformation(extent={{100,-60},{140,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput i_dr
    annotation (Placement(transformation(extent={{140,-120},{180,-80}}),
        iconTransformation(extent={{100,-100},{140,-60}})));

  Modelica.Blocks.Continuous.Integrator int_qr annotation (Placement(
        transformation(extent={{-10,-10},{10,10}}, origin={110,-40})));
  Modelica.Blocks.Continuous.Integrator int_dr annotation (Placement(
        transformation(extent={{-10,-10},{10,10}}, origin={110,-100})));
  Modelica.Blocks.Sources.Constant v_dr(k=0)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}}, origin={-70,-76})));
  Modelica.Blocks.Continuous.Integrator int_qs annotation (Placement(
        transformation(extent={{-10,-10},{10,10}}, origin={110,90})));
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
  StatorCurrent_q i_qs_block(
    Lr=Lr,
    Rr=Rr,
    Lm=Lm,
    Rs=Rs,
    Ls=Ls)
          "Calculates Q-axis current of stator" annotation (Placement(transformation(extent={{60,80},
            {80,100}})));
  StatorCurrent_d i_ds_block(
    Lr=Lr,
    Rr=Rr,
    Lm=Lm,
    Rs=Rs,
    Ls=Ls) "Calculates D-axis current of stator" annotation (Placement(transformation(extent={{60,40},
            {80,60}})));
  RotorCurrent_d i_dr_block(
    Lr=Lr,
    Rr=Rr,
    Lm=Lm) "Calculates D-axis current of rotor" annotation (Placement(transformation(extent={{62,-110},{82,-90}})));
  RotorCurrent_q i_qr_block(
    Lr=Lr,
    Rr=Rr,
    Lm=Lm) "Calculates Q-axis current of rotor" annotation (Placement(transformation(extent={{62,-50},{82,-30}})));
equation
  connect(i_qr_block.der_i_qr, int_qr.u)
    annotation (Line(points={{84,-40},{98,-40}}, color={0,0,127}));
  connect(v_dr.y, i_dr_block.v_dr) annotation (Line(points={{-59,-76},{52,-76},
          {52,-90},{60,-90}}, color={0,0,127}));

  connect(i_ds, int_ds.y)
    annotation (Line(points={{160,50},{121,50}}, color={0,0,127}));
  connect(i_qr, int_qr.y)
    annotation (Line(points={{160,-40},{121,-40}}, color={0,0,127}));
  connect(i_dr, i_dr)
    annotation (Line(points={{160,-100},{160,-100}},
                                                   color={0,0,127}));
  connect(int_dr.y, i_dr) annotation (Line(points={{121,-100},{160,-100}},
                      color={0,0,127}));
  connect(I_qs.y, i_qs_block.i_qs) annotation (Line(points={{-59,110},{0,110},{0,
          95.8},{58,95.8}},         color={0,0,127}));

  connect(I_dr.y, i_qs_block.i_dr) annotation (Line(points={{-59,-128},{40,-128},
          {40,84},{58,84}},       color={0,0,127}));
  connect(I_ds.y, i_qs_block.i_ds) annotation (Line(points={{-59,-12},{20,-12},{
          20,80},{58,80}},  color={0,0,127}));
  connect(i_ds_block.der_i_ds, int_ds.u) annotation (Line(points={{82.7,50.1},{92,
          50.1},{92,50},{98,50}},           color={0,0,127}));
  connect(v_ds, i_ds_block.v_ds) annotation (Line(
      points={{-160,60},{58,60}},
      color={0,0,127},
      pattern=LinePattern.Dash,
      thickness=0.5));
  connect(i_dr_block.der_i_dr, int_dr.u) annotation (Line(points={{84.1,-100.1},
          {91.05,-100.1},{91.05,-100},{98,-100}},   color={0,0,127}));
  connect(i_ds_block.i_ds, i_qs_block.i_ds) annotation (Line(points={{58,56},{20,
          56},{20,80},{58,80}},     color={0,0,127}));
  connect(i_qr_block.i_ds, i_qs_block.i_ds) annotation (Line(points={{60,-50},{20,
          -50},{20,80},{58,80}},     color={0,0,127}));
  connect(i_qr_block.i_dr, i_qs_block.i_dr) annotation (Line(points={{60,-46.2},
          {40,-46.2},{40,84},{58,84}}, color={0,0,127}));
  connect(i_dr_block.i_dr, I_dr.y) annotation (Line(points={{60,-94},{40,-94},{
          40,-128},{-59,-128}},  color={0,0,127}));
  connect(i_qr_block.v_qr, v_qr.y) annotation (Line(points={{60,-30},{32,-30},{
          32,12},{-59,12}},
                          color={0,0,127}));
  connect(i_ds_block.der_i_dr, Der_i_dr.y) annotation (Line(points={{58,52.2},{-50,
          52.2},{-50,44},{-59,44}},            color={0,0,127}));
  connect(i_dr_block.der_i_ds, Der_i_ds.y) annotation (Line(points={{60,-98},{
          -52,-98},{-52,-108},{-59,-108}},  color={0,0,127}));
  connect(i_ds_block.i_qs, I_qs.y) annotation (Line(points={{58,40},{58,34},{0,34},
          {0,110},{-59,110}}, color={0,0,127}));
  connect(i_dr_block.i_qs, I_qs.y) annotation (Line(points={{60,-110},{0,-110},
          {0,110},{-59,110}}, color={0,0,127}));
  connect(Der_i_qs.y, i_qr_block.der_i_qs) annotation (Line(points={{-59,-52},{
          46,-52},{46,-38.2},{60,-38.2}},    color={0,0,127}));
  connect(I_qr.y, i_qr_block.i_qr) annotation (Line(points={{-59,-30},{-12,-30},
          {-12,-34.2},{60,-34.2}},      color={0,0,127}));
  connect(i_dr_block.i_qr, I_qr.y) annotation (Line(points={{60,-106},{38,-106},
          {38,-34},{-12,-34},{-12,-30},{-59,-30}},
                                      color={0,0,127}));
  connect(i_ds_block.i_qr, i_qr_block.i_qr) annotation (Line(points={{58,43.6},{
          -12,43.6},{-12,-34.2},{60,-34.2}},        color={0,0,127}));
  connect(Der_i_qr.y, i_qs_block.der_i_qr) annotation (Line(points={{-59,84},{-50,
          84},{-50,91.8},{58,91.8}},      color={0,0,127}));
  connect(int_qs.y, i_qs)
    annotation (Line(points={{121,90},{160,90}}, color={0,0,127}));
  connect(int_qs.u, i_qs_block.der_i_qs) annotation (Line(points={{98,90},{91.35,
          90},{91.35,89.9},{82.7,89.9}},       color={0,0,127}));
  connect(v_qs, i_qs_block.v_qs)
    annotation (Line(points={{-160,100},{50,100},{50,99.8},{58,99.8}},
                                                             color={0,0,127}));
  connect(omega, i_ds_block.omega) annotation (Line(points={{-160,0},{-120,0},{-120,
          68},{-40,68},{-40,47.8},{58,47.8}}, color={0,0,127}));
  connect(omega, i_qs_block.omega) annotation (Line(points={{-160,0},{-120,0},{-120,
          68},{-40,68},{-40,87.8},{58,87.8}}, color={0,0,127}));
  connect(omega_r, i_qr_block.omega_r) annotation (Line(points={{-160,-120},{-20,
          -120},{-20,-42.4},{60,-42.4}}, color={0,0,127}));
  connect(omega_r, i_dr_block.omega_r) annotation (Line(points={{-160,-120},{-20,
          -120},{-20,-102},{60,-102}}, color={0,0,127}));
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
