within Buildings.Fluid.ZoneEquipment.FCUControls;
block Controller_MultiSpeedCyclingFan_ConstantWaterFlowrate
  Controls.OBC.CDL.Interfaces.RealInput TZon "Measured zone temperature"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  Controls.OBC.CDL.Interfaces.RealInput TCooSet "Measured zone temperature"
    annotation (Placement(transformation(extent={{-140,0},{-100,40}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Controls.OBC.CDL.Interfaces.RealInput THeaSet "Measured zone temperature"
    annotation (Placement(transformation(extent={{-140,-40},{-100,0}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
  Controls.OBC.CDL.Interfaces.RealOutput yCoo
    annotation (Placement(transformation(extent={{100,40},{140,80}}),
        iconTransformation(extent={{100,40},{140,80}})));
  Controls.OBC.CDL.Interfaces.RealOutput yHea
    annotation (Placement(transformation(extent={{100,0},{140,40}}),
        iconTransformation(extent={{100,0},{140,40}})));
  Controls.OBC.CDL.Interfaces.RealOutput yFanSpe annotation (Placement(
        transformation(extent={{100,-40},{140,0}}), iconTransformation(extent={
            {100,-40},{140,0}})));
  Controls.OBC.CDL.Interfaces.BooleanOutput yFan annotation (Placement(
        transformation(extent={{100,-80},{140,-40}}), iconTransformation(extent=
           {{100,-80},{140,-40}})));
  Controls.OBC.CDL.Continuous.Hysteresis hys1(uLow=-0.5, uHigh=0)
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  Controls.OBC.CDL.Continuous.Add add2(k2=-1)
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Controls.OBC.CDL.Conversions.BooleanToReal booToRea
    annotation (Placement(transformation(extent={{0,60},{20,80}})));
  Controls.OBC.CDL.Continuous.Add add1(k2=-1)
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Controls.OBC.CDL.Continuous.Hysteresis hys2(uLow=-0.5, uHigh=0)
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
  Controls.OBC.CDL.Conversions.BooleanToReal booToRea1
    annotation (Placement(transformation(extent={{0,10},{20,30}})));
  Controls.OBC.CDL.Logical.Or or2
    annotation (Placement(transformation(extent={{60,-70},{80,-50}})));
  Controls.OBC.CDL.Continuous.PID conPID(reverseActing=false)
    annotation (Placement(transformation(extent={{0,-20},{20,0}})));
  Controls.OBC.CDL.Continuous.PID conPID1(reverseActing=false)
    annotation (Placement(transformation(extent={{0,-50},{20,-30}})));
  Controls.OBC.CDL.Continuous.Sources.Constant con(k=0)
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
  Controls.OBC.CDL.Continuous.Add add3
    annotation (Placement(transformation(extent={{30,-30},{50,-10}})));
equation
  connect(TZon, add2.u1) annotation (Line(points={{-120,60},{-94,60},{-94,76},{
          -82,76}}, color={0,0,127}));
  connect(TCooSet, add2.u2) annotation (Line(points={{-120,20},{-90,20},{-90,64},
          {-82,64}}, color={0,0,127}));
  connect(add2.y, hys1.u)
    annotation (Line(points={{-58,70},{-42,70}}, color={0,0,127}));
  connect(hys1.y, booToRea.u)
    annotation (Line(points={{-18,70},{-2,70}}, color={255,0,255}));
  connect(booToRea.y, yCoo) annotation (Line(points={{22,70},{60,70},{60,60},{
          120,60}}, color={0,0,127}));
  connect(add1.y, hys2.u)
    annotation (Line(points={{-58,20},{-42,20}}, color={0,0,127}));
  connect(hys2.y, booToRea1.u)
    annotation (Line(points={{-18,20},{-2,20}}, color={255,0,255}));
  connect(TZon, add1.u2) annotation (Line(points={{-120,60},{-94,60},{-94,14},{
          -82,14}}, color={0,0,127}));
  connect(THeaSet, add1.u1) annotation (Line(points={{-120,-20},{-88,-20},{-88,
          26},{-82,26}}, color={0,0,127}));
  connect(booToRea1.y, yHea)
    annotation (Line(points={{22,20},{120,20}}, color={0,0,127}));
  connect(hys1.y, or2.u1) annotation (Line(points={{-18,70},{-10,70},{-10,-60},
          {58,-60}}, color={255,0,255}));
  connect(hys2.y, or2.u2) annotation (Line(points={{-18,20},{-14,20},{-14,-68},
          {58,-68}}, color={255,0,255}));
  connect(or2.y, yFan)
    annotation (Line(points={{82,-60},{120,-60}}, color={255,0,255}));
  connect(add2.y, conPID.u_m) annotation (Line(points={{-58,70},{-50,70},{-50,
          -26},{10,-26},{10,-22}}, color={0,0,127}));
  connect(add1.y, conPID1.u_m) annotation (Line(points={{-58,20},{-54,20},{-54,
          -56},{10,-56},{10,-52}}, color={0,0,127}));
  connect(con.y, conPID.u_s) annotation (Line(points={{-58,-80},{-20,-80},{-20,
          -10},{-2,-10}}, color={0,0,127}));
  connect(con.y, conPID1.u_s) annotation (Line(points={{-58,-80},{-20,-80},{-20,
          -40},{-2,-40}}, color={0,0,127}));
  connect(add3.y, yFanSpe)
    annotation (Line(points={{52,-20},{120,-20}}, color={0,0,127}));
  connect(conPID.y, add3.u1) annotation (Line(points={{22,-10},{26,-10},{26,-14},
          {28,-14}}, color={0,0,127}));
  connect(conPID1.y, add3.u2) annotation (Line(points={{22,-40},{26,-40},{26,
          -26},{28,-26}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}), Diagram(coordinateSystem(
          preserveAspectRatio=false)));
end Controller_MultiSpeedCyclingFan_ConstantWaterFlowrate;
