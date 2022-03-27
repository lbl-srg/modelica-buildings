within Buildings.Controls.OBC.ASHRAE.FanCoilUnit.Subsequences;
block FanSpeed
  "Fan speed setpoint subsequence"

  parameter Boolean have_coolingCoil
    "Does the fan coil unit have a cooling coil?";

  parameter Boolean have_heatingCoil
    "Does the fan coil unit have a heating coil?";

  parameter Real deaSpe(
    final unit="1",
    displayUnit="1") = 0.1
    "Deadband mode fan speed"
    annotation(Dialog(group="Deadband parameters"));

  parameter Real heaSpeMin(
    final unit="1",
    displayUnit="1") = 0.1
    "Minimum heating mode fan speed"
    annotation(Dialog(group="Heating loop parameters",
      enable = have_heatingCoil));

  parameter Real heaPerMin(
    final unit="1",
    displayUnit="1") = 0.5
    "Minimum heating loop signal at which fan speed is modified"
    annotation(Dialog(group="Heating loop parameters",
      enable = have_heatingCoil));

  parameter Real heaSpeMax(
    final unit="1",
    displayUnit="1") = 0.6
    "Maximum heating mode fan speed"
    annotation(Dialog(group="Heating loop parameters",
      enable = have_heatingCoil));

  parameter Real heaPerMax(
    final unit="1",
    displayUnit="1") = 1
    "Maximum heating loop signal at which fan speed is modified"
    annotation(Dialog(group="Heating loop parameters",
      enable = have_heatingCoil));

  parameter Real cooSpeMin(
    final unit="1",
    displayUnit="1") = 0.2
    "Minimum cooling mode fan speed"
    annotation(Dialog(group="Cooling loop parameters",
      enable = have_coolingCoil));

  parameter Real cooPerMin(
    final unit="1",
    displayUnit="1") = 0.5
    "Minimum cooling loop signal at which fan speed is modified"
    annotation(Dialog(group="Cooling loop parameters",
      enable = have_coolingCoil));

  parameter Real cooSpeMax(
    final unit="1",
    displayUnit="1") = 1
    "Maximum cooling mode fan speed"
    annotation(Dialog(group="Cooling loop parameters",
      enable = have_coolingCoil));

  parameter Real cooPerMax(
    final unit="1",
    displayUnit="1") = 1
    "Maximum cooling loop signal at which fan speed is modified"
    annotation(Dialog(group="Cooling loop parameters",
      enable = have_coolingCoil));

  parameter Real heaDea(
    final unit="1",
    displayUnit="1") = 0.05
    "Heating loop signal limit at which deadband mode transitions to heating mode"
    annotation(Dialog(group="Transition parameters",
      enable = have_heatingCoil));

  parameter Real cooDea(
    final unit="1",
    displayUnit="1") = 0.05
    "Cooling loop signal limit at which deadband mode transitions to cooling mode"
    annotation(Dialog(group="Transition parameters",
      enable = have_coolingCoil));

  parameter Real deaHysLim(
    final unit="1",
    displayUnit="1") = 0.01
    "Hysteresis limits for deadband mode transitions"
    annotation(Dialog(tab="Advanced"));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uFanPro
    "Fan proven on signal"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput opeMod
    "System operating mode"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uHea(
    final unit="1",
    displayUnit="1") if have_heatingCoil
    "Heating loop signal"
    annotation (Placement(transformation(extent={{-140,-40},{-100,0}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCoo(
    final unit="1",
    displayUnit="1") if have_coolingCoil
    "Cooling loop signal"
    annotation (Placement(transformation(extent={{-140,-120},{-100,-80}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yFan
    "Fan enable signal"
    annotation (Placement(transformation(extent={{120,20},{160,60}}),
        iconTransformation(extent={{100,0},{140,40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yFanSpe(
    final unit="1",
    displayUnit="1")
    "Fan speed signal"
    annotation (Placement(transformation(extent={{120,-20},{160,20}}),
        iconTransformation(extent={{100,-40},{140,0}})));

protected
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu
    "Check if zone is unoccupied"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(
    final k=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.OperationModes.unoccupied)
    "Constant unoccupied mode signal"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));

  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Enable only if zone is not in unoccupied mode"
    annotation (Placement(transformation(extent={{-10,70},{10,90}})));

  Buildings.Controls.OBC.CDL.Continuous.Switch swi
    "Switch fan speed to maximum until the fan is proven ON"
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea
    "Convert fan enable signal to Real"
    annotation (Placement(transformation(extent={{50,-30},{70,-10}})));

  Buildings.Controls.OBC.CDL.Continuous.Line lin
    "Heating fan speed signal"
    annotation (Placement(transformation(extent={{-30,-30},{-10,-10}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con[2](
    final k={heaPerMin,heaPerMax})
    "Heating loop signal support points"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con1[2](
    final k={heaSpeMin,heaSpeMax})
    "Heating fan speed limit signals"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con2[2](
    final k={cooSpeMin,cooSpeMax})
    "Cooling fan speed limit signals"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));

  Buildings.Controls.OBC.CDL.Continuous.Line lin1
    "Cooling fan speed signal"
    annotation (Placement(transformation(extent={{-30,-110},{-10,-90}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con3[2](
    final k={cooPerMin,cooPerMax})
    "Cooling loop signal support points"
    annotation (Placement(transformation(extent={{-80,-130},{-60,-110}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con4(
    final k=deaSpe)
    "Deadband mode fan speed signal"
    annotation (Placement(transformation(extent={{-30,-70},{-10,-50}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys(
    final uLow=heaDea - deaHysLim,
    final uHigh=heaDea)
    "Hysteresis for switching between deadband mode and heating mode"
    annotation (Placement(transformation(extent={{0,-50},{20,-30}})));

  Buildings.Controls.OBC.CDL.Continuous.Switch swi1
    "Switch for turning on heating mode from deadband mode"
    annotation (Placement(transformation(extent={{30,-70},{50,-50}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys1(
    final uLow=cooDea - deaHysLim,
    final uHigh=cooDea)
    "Hysteresis for switching on cooling mode from deadband mode"
    annotation (Placement(transformation(extent={{0,-90},{20,-70}})));

  Buildings.Controls.OBC.CDL.Continuous.Switch swi2
    "Switch for turning on cooling mode from deadband mode"
    annotation (Placement(transformation(extent={{60,-110},{80,-90}})));

  Buildings.Controls.OBC.CDL.Continuous.Multiply mul
    "Multiply fan speed signal by fan enable signal"
    annotation (Placement(transformation(extent={{90,-50},{110,-30}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con6(
    final k=0) if not have_heatingCoil
    "Constant zero signal"
    annotation (Placement(transformation(extent={{-50,10},{-30,30}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con8(
    final k=0) if not have_coolingCoil
    "Constant zero signal"
    annotation (Placement(transformation(extent={{-40,-140},{-20,-120}})));

equation
  connect(conInt.y, intEqu.u2) annotation (Line(points={{-58,60},{-50,60},{-50,
          72},{-42,72}}, color={255,127,0}));

  connect(opeMod, intEqu.u1)
    annotation (Line(points={{-120,80},{-42,80}}, color={255,127,0}));

  connect(intEqu.y, not1.u)
    annotation (Line(points={{-18,80},{-12,80}}, color={255,0,255}));

  connect(not1.y, yFan) annotation (Line(points={{12,80},{40,80},{40,40},{140,
          40}}, color={255,0,255}));

  connect(uFanPro, swi.u2) annotation (Line(points={{-120,40},{30,40},{30,0},{
          78,0}}, color={255,0,255}));

  connect(not1.y, booToRea.u) annotation (Line(points={{12,80},{40,80},{40,-20},
          {48,-20}}, color={255,0,255}));

  connect(booToRea.y, swi.u3) annotation (Line(points={{72,-20},{74,-20},{74,-8},
          {78,-8}}, color={0,0,127}));

  connect(uHea, lin.u)
    annotation (Line(points={{-120,-20},{-32,-20}}, color={0,0,127}));

  connect(con[1].y, lin.x1) annotation (Line(points={{-58,-40},{-50,-40},{-50,
          -12},{-32,-12}}, color={0,0,127}));

  connect(con[2].y, lin.x2) annotation (Line(points={{-58,-40},{-50,-40},{-50,
          -24},{-32,-24}}, color={0,0,127}));

  connect(con1[1].y, lin.f1) annotation (Line(points={{-58,0},{-40,0},{-40,-16},
          {-32,-16}}, color={0,0,127}));

  connect(con1[2].y, lin.f2) annotation (Line(points={{-58,0},{-40,0},{-40,-28},
          {-32,-28}}, color={0,0,127}));

  connect(con3[2].y, lin1.x2) annotation (Line(points={{-58,-120},{-50,-120},{
          -50,-104},{-32,-104}}, color={0,0,127}));

  connect(con3[1].y, lin1.x1) annotation (Line(points={{-58,-120},{-50,-120},{
          -50,-92},{-32,-92}}, color={0,0,127}));

  connect(con2[2].y, lin1.f2) annotation (Line(points={{-58,-80},{-40,-80},{-40,
          -108},{-32,-108}}, color={0,0,127}));

  connect(con2[1].y, lin1.f1) annotation (Line(points={{-58,-80},{-40,-80},{-40,
          -96},{-32,-96}}, color={0,0,127}));

  connect(uCoo, lin1.u)
    annotation (Line(points={{-120,-100},{-32,-100}}, color={0,0,127}));

  connect(uHea, hys.u) annotation (Line(points={{-120,-20},{-44,-20},{-44,-40},
          {-2,-40}}, color={0,0,127}));

  connect(hys.y, swi1.u2) annotation (Line(points={{22,-40},{26,-40},{26,-60},{
          28,-60}}, color={255,0,255}));

  connect(con4.y, swi1.u3) annotation (Line(points={{-8,-60},{20,-60},{20,-68},
          {28,-68}}, color={0,0,127}));

  connect(lin.y, swi1.u1) annotation (Line(points={{-8,-20},{-4,-20},{-4,-52},{
          28,-52}}, color={0,0,127}));

  connect(hys1.y, swi2.u2) annotation (Line(points={{22,-80},{26,-80},{26,-100},
          {58,-100}}, color={255,0,255}));

  connect(uCoo, hys1.u) annotation (Line(points={{-120,-100},{-44,-100},{-44,-84},
          {-20,-84},{-20,-80},{-2,-80}},      color={0,0,127}));

  connect(lin1.y, swi2.u1) annotation (Line(points={{-8,-100},{20,-100},{20,-92},
          {58,-92}}, color={0,0,127}));

  connect(swi1.y, swi2.u3) annotation (Line(points={{52,-60},{54,-60},{54,-108},
          {58,-108}}, color={0,0,127}));

  connect(booToRea.y, mul.u1) annotation (Line(points={{72,-20},{74,-20},{74,
          -34},{88,-34}}, color={0,0,127}));

  connect(swi2.y, mul.u2) annotation (Line(points={{82,-100},{84,-100},{84,-46},
          {88,-46}}, color={0,0,127}));

  connect(mul.y, swi.u1) annotation (Line(points={{112,-40},{114,-40},{114,20},
          {74,20},{74,8},{78,8}}, color={0,0,127}));

  connect(swi.y, yFanSpe)
    annotation (Line(points={{102,0},{140,0}}, color={0,0,127}));

  connect(con6.y, lin.u) annotation (Line(points={{-28,20},{-20,20},{-20,4},{
          -44,4},{-44,-20},{-32,-20}}, color={0,0,127}));

  connect(con8.y, lin1.u) annotation (Line(points={{-18,-130},{-10,-130},{-10,
          -114},{-44,-114},{-44,-100},{-32,-100}}, color={0,0,127}));

  connect(con6.y, hys.u) annotation (Line(points={{-28,20},{-20,20},{-20,4},{
          -44,4},{-44,-40},{-2,-40}}, color={0,0,127}));

  connect(con8.y, hys1.u) annotation (Line(points={{-18,-130},{-10,-130},{-10,
          -114},{-44,-114},{-44,-84},{-20,-84},{-20,-80},{-2,-80}}, color={0,0,
          127}));

  annotation (defaultComponentName="fanSpe",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,140},{100,100}},
          textColor={0,0,255},
          textString="%name")}),
    Diagram(coordinateSystem(preserveAspectRatio=false,
        extent={{-100,-140},{120,100}})),
    Documentation(info="<html>
      <p>
      Block that outputs the fan enable signal and the fan speed signal based on
      the heating and cooling loop signals. The implemented sequence is based on
      ASHRAE Guideline 36, 2021, Part 5.22.4.
      </p>
      <p>
      The fan enable signal <code>yFan</code> is switched to <code>false</code>
      when the operating mode signal <code>opeMod</code> is <code>unoccupied</code>,
      and is set to <code>true</code> otherwise.
      <br>
      The fan speed signal <code>yFanSpe</code> is varied from 
      the minimum cooling mode fan speed <code>cooSpeMin</code> to the maximum
      cooling mode fan speed <code>cooSpeMax</code>,
      when the cooling loop signal <code>uCoo</code> varies from the minimum limit
      <code>cooPerMin</code> to the maximum limit <code>cooPerMax</code>.
      Similarly, <code>yFanSpe</code> is varied from the minimum heating mode fan speed
      <code>heaSpeMin</code> to the maximum heating mode fan speed <code>heaSpeMax</code>,
      when the heating loop signal <code>uHea</code> varies from the minimum limit
      <code>heaPerMin</code> to the maximum limit <code>heaPerMax</code>.
      The setpoint in deadband mode is equal to the deadband fan speed <code>deaSpe</code>. 
      </p>
      <p align=\"center\">
      <img alt=\"Fan speed setpoint control logic diagram\"
      src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/FanCoilUnit/Subsequences/FanSpeed.png\"/>
      </p>
      </html>", revisions="<html>
      <ul>
      <li>
      March 17, 2022, by Karthik Devaprasad:<br/>
      First implementation.
      </li>
      </ul>
      </html>"));
end FanSpeed;
