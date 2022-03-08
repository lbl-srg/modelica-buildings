within Buildings.Controls.OBC.ASHRAE.FanCoilUnit.Subsequences;
block SupplyAirTemperature
  "Subsequence for calculating supply air temperature setpoint"

  parameter Boolean have_coolingCoil
    "Does the fan coil unit have a cooling coil?";

  parameter Boolean have_heatingCoil
    "Does the fan coil unit have a heating coil?";

  parameter Real THeaSupAirLow(
    final unit="1",
    displayUnit="1") = 0.1
    "Supply air temperature setpoint at minimum heating loop signal"
    annotation(Dialog(group="Heating loop parameters",
      enable = have_heatingCoil));

  parameter Real heaPerMin(
    final unit="1",
    displayUnit="1") = 0.5
    "Minimum heating loop signal at which fan speed is modified"
    annotation(Dialog(group="Heating loop parameters",
      enable = have_heatingCoil));

  parameter Real THeaSupAirHi(
    final unit="1",
    displayUnit="1") = 0.6
    "Supply air temperature setpoint at maximum heating loop signal"
    annotation(Dialog(group="Heating loop parameters",
      enable = have_heatingCoil));

  parameter Real heaPerMax(
    final unit="1",
    displayUnit="1") = 1
    "Maximum heating loop signal at which fan speed is modified"
    annotation(Dialog(group="Heating loop parameters",
      enable = have_heatingCoil));

  parameter Real TCooSupAirLow(
    final unit="1",
    displayUnit="1") = 0.2
    "Supply air temperature setpoint at minimum cooling loop signal"
    annotation(Dialog(group="Cooling loop parameters",
      enable = have_coolingCoil));

  parameter Real cooPerMin(
    final unit="1",
    displayUnit="1") = 0.5
    "Minimum cooling loop signal at which fan speed is modified"
    annotation(Dialog(group="Cooling loop parameters",
      enable = have_coolingCoil));

  parameter Real TCooSupAirHi(
    final unit="1",
    displayUnit="1") = 1
    "Supply air temperature setpoint at maximum cooling loop signal"
    annotation(Dialog(group="Cooling loop parameters",
      enable = have_coolingCoil));

  parameter Real cooPerMax(
    final unit="1",
    displayUnit="1") = 1
    "Maximum cooling loop signal at which fan speed is modified"
    annotation(Dialog(group="Cooling loop parameters",
      enable = have_coolingCoil));

  CDL.Interfaces.RealInput uHea if have_heatingCoil "Heating loop signal"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  CDL.Interfaces.RealInput uCoo if have_coolingCoil
                                "Cooling loop signal"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  CDL.Interfaces.RealInput TAirSup
    "Measured supply air temperature"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  CDL.Interfaces.RealOutput yHeaCoi if have_heatingCoil
                                    "Heating coil signal"
    annotation (Placement(transformation(extent={{100,40},{140,80}})));
  CDL.Interfaces.RealOutput yCooCoi if have_coolingCoil
                                    "Heating coil signal"
    annotation (Placement(transformation(extent={{100,-80},{140,-40}})));
  CDL.Continuous.Line lin
    "Convert heating loop signal to supply air temperature setpoint"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
  CDL.Continuous.Line lin1
    "Convert cooling loop signal to supply air temperature setpoint"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));
  CDL.Continuous.Sources.Constant con1[2](k={THeaSupAirLow,THeaSupAirHi}) if
    have_heatingCoil "Heating supply air temperature setpoint limit signals"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  CDL.Continuous.Sources.Constant con2
                                     [2](k={heaPerMin,heaPerMax}) if
    have_heatingCoil
    "Heating loop signal support points"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  CDL.Continuous.Sources.Constant con3[2](k={TCooSupAirLow,TCooSupAirHi}) if
    have_coolingCoil "Cooling supply air temperature setpoint limit signals"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  CDL.Continuous.Sources.Constant con4[2](k={cooPerMin,cooPerMax}) if
    have_coolingCoil
    "Cooling loop signal support points"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
  CDL.Continuous.PID conPID
    annotation (Placement(transformation(extent={{40,50},{60,70}})));
  CDL.Continuous.PID conPID1
    annotation (Placement(transformation(extent={{60,-70},{80,-50}})));
  CDL.Continuous.Hysteresis hys(uLow=heaDea - deaHysLim, uHigh=heaDea)
    "Hysteresis for switching between deadband mode and heating mode"
    annotation (Placement(transformation(extent={{-20,90},{0,110}})));
  CDL.Continuous.Sources.Constant con6(k=0) if not have_heatingCoil
    "Constant zero signal"
    annotation (Placement(transformation(extent={{-50,90},{-30,110}})));
  CDL.Continuous.Switch swi1
    "Switch for turning on heating mode from deadband mode"
    annotation (Placement(transformation(extent={{0,50},{20,70}})));
  CDL.Continuous.Switch swi2
    "Switch for turning on cooling mode from deadband mode"
    annotation (Placement(transformation(extent={{20,-30},{40,-10}})));
  CDL.Continuous.Hysteresis hys1(uLow=cooDea - deaHysLim, uHigh=cooDea)
    "Hysteresis for switching on cooling mode from deadband mode"
    annotation (Placement(transformation(extent={{-20,-30},{0,-10}})));
  CDL.Continuous.Sources.Constant con8(k=0) if not have_coolingCoil
    "Constant zero signal"
    annotation (Placement(transformation(extent={{-20,-110},{0,-90}})));
  CDL.Continuous.Sources.Constant con5(k=0)
    "Constant zero signal"
    annotation (Placement(transformation(extent={{-30,10},{-10,30}})));
equation
  connect(uHea, lin.u)
    annotation (Line(points={{-120,60},{-42,60}}, color={0,0,127}));
  connect(con1[1].y, lin.f1) annotation (Line(points={{-58,80},{-50,80},{-50,64},
          {-42,64}}, color={0,0,127}));
  connect(con1[2].y, lin.f2) annotation (Line(points={{-58,80},{-50,80},{-50,52},
          {-42,52}}, color={0,0,127}));
  connect(con2[1].y, lin.x1) annotation (Line(points={{-58,40},{-46,40},{-46,68},
          {-42,68}}, color={0,0,127}));
  connect(con2[2].y, lin.x2) annotation (Line(points={{-58,40},{-46,40},{-46,56},
          {-42,56}}, color={0,0,127}));
  connect(uCoo, lin1.u)
    annotation (Line(points={{-120,-60},{-42,-60}}, color={0,0,127}));
  connect(con3[1].y, lin1.f1) annotation (Line(points={{-58,-40},{-50,-40},{-50,
          -56},{-42,-56}}, color={0,0,127}));
  connect(con3[2].y, lin1.f2) annotation (Line(points={{-58,-40},{-50,-40},{-50,
          -68},{-42,-68}}, color={0,0,127}));
  connect(con4[1].y, lin1.x1) annotation (Line(points={{-58,-80},{-54,-80},{-54,
          -52},{-42,-52}}, color={0,0,127}));
  connect(con4[2].y, lin1.x2) annotation (Line(points={{-58,-80},{-54,-80},{-54,
          -64},{-42,-64}}, color={0,0,127}));
  connect(TAirSup, conPID.u_m)
    annotation (Line(points={{-120,0},{50,0},{50,48}}, color={0,0,127}));
  connect(conPID.y, yHeaCoi)
    annotation (Line(points={{62,60},{120,60}}, color={0,0,127}));
  connect(TAirSup, conPID1.u_m) annotation (Line(points={{-120,0},{50,0},{50,
          -90},{70,-90},{70,-72}}, color={0,0,127}));
  connect(conPID1.y, yCooCoi)
    annotation (Line(points={{82,-60},{120,-60}}, color={0,0,127}));
  connect(con5.y, swi1.u3) annotation (Line(points={{-8,20},{-6,20},{-6,52},{-2,
          52}}, color={0,0,127}));
  connect(lin.y, swi1.u1) annotation (Line(points={{-18,60},{-10,60},{-10,68},{
          -2,68}}, color={0,0,127}));
  connect(con6.y, hys.u)
    annotation (Line(points={{-28,100},{-22,100}}, color={0,0,127}));
  connect(con6.y, lin.u) annotation (Line(points={{-28,100},{-26,100},{-26,76},
          {-54,76},{-54,60},{-42,60}}, color={0,0,127}));
  connect(uHea, hys.u) annotation (Line(points={{-120,60},{-54,60},{-54,76},{
          -26,76},{-26,100},{-22,100}}, color={0,0,127}));
  connect(hys.y, swi1.u2) annotation (Line(points={{2,100},{10,100},{10,80},{-6,
          80},{-6,60},{-2,60}}, color={255,0,255}));
  connect(con8.y, lin1.u) annotation (Line(points={{2,-100},{10,-100},{10,-80},{
          -46,-80},{-46,-60},{-42,-60}}, color={0,0,127}));
  connect(hys1.y, swi2.u2)
    annotation (Line(points={{2,-20},{18,-20}}, color={255,0,255}));
  connect(uCoo, hys1.u) annotation (Line(points={{-120,-60},{-46,-60},{-46,-20},
          {-22,-20}}, color={0,0,127}));
  connect(con8.y, hys1.u) annotation (Line(points={{2,-100},{10,-100},{10,-80},{
          -46,-80},{-46,-20},{-22,-20}}, color={0,0,127}));
  connect(swi1.y, swi2.u3) annotation (Line(points={{22,60},{28,60},{28,40},{10,
          40},{10,-28},{18,-28}}, color={0,0,127}));
  connect(lin1.y, swi2.u1) annotation (Line(points={{-18,-60},{6,-60},{6,-12},{18,
          -12}}, color={0,0,127}));
  connect(swi2.y, conPID.u_s) annotation (Line(points={{42,-20},{44,-20},{44,40},
          {32,40},{32,60},{38,60}}, color={0,0,127}));
  connect(swi2.y, conPID1.u_s) annotation (Line(points={{42,-20},{44,-20},{44,-60},
          {58,-60}}, color={0,0,127}));
  annotation (defaultComponentName = "TSupAir",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}),                                   graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid)}), Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-120},{100,120}})));
end SupplyAirTemperature;
