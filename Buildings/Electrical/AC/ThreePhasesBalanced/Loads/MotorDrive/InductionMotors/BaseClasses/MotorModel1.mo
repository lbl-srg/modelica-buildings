within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors1.BaseClasses;
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
  InductionMotors1.BaseClasses.RotorCurrent_q i_qr_block(
    final Lr=Lr,
    final Rr=Rr,
    final Lm=Lm) annotation (Placement(transformation(extent={{-10,-10},{10,10}},
          origin={20,-40})));
  Modelica.Blocks.Continuous.Integrator int_qr annotation (Placement(
        transformation(extent={{-10,-10},{10,10}}, origin={60,-40})));
  InductionMotors1.BaseClasses.RotorCurrent_d i_dr_block(
    final Lr=Lr,
    final Rr=Rr,
    final Lm=Lm) annotation (Placement(transformation(extent={{-10,-10},{10,10}},
          origin={20,-100})));
  Modelica.Blocks.Continuous.Integrator int_dr annotation (Placement(
        transformation(extent={{-10,-10},{10,10}}, origin={60,-100})));
  Modelica.Blocks.Sources.Constant v_dr(k=0)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}}, origin={-108,-70})));
  InductionMotors1.BaseClasses.StatorCurrent_q i_qs_block(
    final Lr=Lr,
    final Ls=Ls,
    final Rr=Rr,
    final Lm=Lm,
    final Rs=Rs) annotation (Placement(transformation(extent={{-10,-10},{10,10}},
          origin={20,90})));
  Modelica.Blocks.Continuous.Integrator int_qs annotation (Placement(
        transformation(extent={{-10,-10},{10,10}}, origin={60,90})));
  InductionMotors1.BaseClasses.StatorCurrent_d i_ds_block(
    final Lr=Lr,
    final Ls=Ls,
    final Rr=Rr,
    final Lm=Lm,
    final Rs=Rs) annotation (Placement(transformation(extent={{-10,-10},{10,10}},
          origin={20,50})));
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
")}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-140},{140,
            140}})));
end MotorModel1;
