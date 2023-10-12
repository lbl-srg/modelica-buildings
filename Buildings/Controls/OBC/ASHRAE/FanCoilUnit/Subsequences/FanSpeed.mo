within Buildings.Controls.OBC.ASHRAE.FanCoilUnit.Subsequences;
block FanSpeed
  "Fan speed setpoint subsequence"

  parameter Boolean have_cooCoi
    "Does the fan coil unit have a cooling coil? True: Yes, False: No";

  parameter Boolean have_heaCoi
    "Does the fan coil unit have a heating coil? True: Yes, False: No";

  parameter Real deaSpe(
    final unit="1",
    displayUnit="1") = 0.1
    "Deadband mode fan speed"
    annotation(Dialog(group="Deadband"));

  parameter Real heaSpe_min(
    final unit="1",
    displayUnit="1") = 0.1
    "Minimum heating mode fan speed"
    annotation(Dialog(group="Heating loop",
      enable = have_heaCoi));

  parameter Real uHea_min(
    final unit="1",
    displayUnit="1") = 0.5
    "Minimum heating loop signal at which fan speed is modified"
    annotation(Dialog(group="Heating loop",
      enable = have_heaCoi));

  parameter Real heaSpe_max(
    final unit="1",
    displayUnit="1") = 0.6
    "Maximum heating mode fan speed"
    annotation(Dialog(group="Heating loop",
      enable = have_heaCoi));

  parameter Real uHea_max(
    final unit="1",
    displayUnit="1") = 1
    "Maximum heating loop signal at which fan speed is modified"
    annotation(Dialog(group="Heating loop",
      enable = have_heaCoi));

  parameter Real cooSpe_min(
    final unit="1",
    displayUnit="1") = 0.2
    "Minimum cooling mode fan speed"
    annotation(Dialog(group="Cooling loop",
      enable = have_cooCoi));

  parameter Real uCoo_min(
    final unit="1",
    displayUnit="1") = 0.5
    "Minimum cooling loop signal at which fan speed is modified"
    annotation(Dialog(group="Cooling loop",
      enable = have_cooCoi));

  parameter Real cooSpe_max(
    final unit="1",
    displayUnit="1") = 1
    "Maximum cooling mode fan speed"
    annotation(Dialog(group="Cooling loop",
      enable = have_cooCoi));

  parameter Real uCoo_max(
    final unit="1",
    displayUnit="1") = 1
    "Maximum cooling loop signal at which fan speed is modified"
    annotation(Dialog(group="Cooling loop",
      enable = have_cooCoi));

  parameter Real heaDea(
    final unit="1",
    displayUnit="1") = 0.05
    "Heating loop signal limit above which fan operation changes from deadband mode to heating mode"
    annotation(Dialog(group="Deadband",
      enable = have_heaCoi));

  parameter Real cooDea(
    final unit="1",
    displayUnit="1") = 0.05
    "Cooling loop signal limit above which fan operation changes from deadband mode to cooling mode"
    annotation(Dialog(group="Deadband",
      enable = have_cooCoi));

  parameter Real deaHysLim(
    final unit="1",
    displayUnit="1") = 0.01
    "Hysteresis limits for deadband mode transitions"
    annotation(Dialog(tab="Advanced"));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1FanPro
    "Fan proven on signal"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}),
      iconTransformation(extent={{-140,0},{-100,40}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput opeMod
    "System operating mode"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}}),
      iconTransformation(extent={{-140,40},{-100,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uHea(
    final unit="1",
    displayUnit="1") if have_heaCoi
    "Heating loop signal"
    annotation (Placement(transformation(extent={{-140,-40},{-100,0}}),
      iconTransformation(extent={{-140,-40},{-100,0}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCoo(
    final unit="1",
    displayUnit="1") if have_cooCoi
    "Cooling loop signal"
    annotation (Placement(transformation(extent={{-140,-140},{-100,-100}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1Fan
    "Fan command on status"
    annotation (Placement(transformation(extent={{120,40},{160,80}}),
      iconTransformation(extent={{100,0},{140,40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yFan(
    final unit="1",
    displayUnit="1")
    "Fan command speed"
    annotation (Placement(transformation(extent={{120,-20},{160,20}}),
      iconTransformation(extent={{100,-40},{140,0}})));

protected
  Buildings.Controls.OBC.CDL.Integers.Equal isUnOcc
    "Check if zone is unoccupied"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant unOccMod(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.unoccupied)
    "Constant unoccupied mode signal"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));

  Buildings.Controls.OBC.CDL.Logical.Not notUno
    "Enable only if zone is not in unoccupied mode"
    annotation (Placement(transformation(extent={{-10,70},{10,90}})));

  Buildings.Controls.OBC.CDL.Continuous.Switch swiFanPro
    "Switch fan speed to deadband speed until the fan is proven ON"
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea
    "Convert fan enable signal to Real"
    annotation (Placement(transformation(extent={{30,-30},{50,-10}})));

  Buildings.Controls.OBC.CDL.Continuous.Line linHeaFanSpe
    "Heating fan speed signal"
    annotation (Placement(transformation(extent={{-30,-30},{-10,-10}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conuHea_min(
    final k=uHea_min)
    "Minimum heating loop signal support point"
    annotation (Placement(transformation(extent={{-90,-50},{-70,-30}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conheaSpe_min(
    final k=heaSpe_min)
    "Minimum heating fan speed limit signal"
    annotation (Placement(transformation(extent={{-90,10},{-70,30}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant concooSpe_min(
    final k=cooSpe_min)
    "Minimum cooling fan speed limit signal"
    annotation (Placement(transformation(extent={{-90,-110},{-70,-90}})));

  Buildings.Controls.OBC.CDL.Continuous.Line linCooFanSpe
    "Cooling fan speed signal"
    annotation (Placement(transformation(extent={{-30,-130},{-10,-110}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conuCoo_min(
    final k=uCoo_min)
    "Minimum cooling loop signal support point"
    annotation (Placement(transformation(extent={{-90,-150},{-70,-130}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conDeaFanSpe(
    final k=deaSpe)
    "Deadband mode fan speed signal"
    annotation (Placement(transformation(extent={{-30,-70},{-10,-50}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hysDeaHea(
    final uLow=heaDea-deaHysLim,
    final uHigh=heaDea)
    "Hysteresis for switching between deadband mode and heating mode"
    annotation (Placement(transformation(extent={{0,-50},{20,-30}})));

  Buildings.Controls.OBC.CDL.Continuous.Switch swiDeaHea
    "Switch for turning on heating mode from deadband mode"
    annotation (Placement(transformation(extent={{30,-70},{50,-50}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hysDeaCoo(
    final uLow=cooDea-deaHysLim,
    final uHigh=cooDea)
    "Hysteresis for switching on cooling mode from deadband mode"
    annotation (Placement(transformation(extent={{0,-110},{20,-90}})));

  Buildings.Controls.OBC.CDL.Continuous.Switch swiDeaCoo
    "Switch for turning on cooling mode from deadband mode"
    annotation (Placement(transformation(extent={{60,-110},{80,-90}})));

  Buildings.Controls.OBC.CDL.Continuous.Multiply mulFanSpe
    "Multiply fan speed signal by fan enable signal"
    annotation (Placement(transformation(extent={{90,-90},{110,-70}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conZerHeaMod(
    final k=0) if not have_heaCoi
    "Constant zero signal for heating mode"
    annotation (Placement(transformation(extent={{-90,-80},{-70,-60}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conZerCooMod(
    final k=0) if not have_cooCoi
    "Constant zero signal for cooling mode"
    annotation (Placement(transformation(extent={{-30,-160},{-10,-140}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conheaSpe_max(
    final k=heaSpe_max)
    "Maximum heating fan speed limit signal"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conuHea_max(
    final k=uHea_max)
    "Maximum heating loop signal support point"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant concooSpe_max(
    final k=cooSpe_max)
    "Maximum cooling fan speed limit signal"
    annotation (Placement(transformation(extent={{-60,-100},{-40,-80}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conuCoo_max(
    final k=uCoo_max)
    "Maximum cooling loop signal support point"
    annotation (Placement(transformation(extent={{-60,-160},{-40,-140}})));

  Buildings.Controls.OBC.CDL.Continuous.Multiply mulDeaSpe
    "Multiply deadband speed signal by fan enable signal"
    annotation (Placement(transformation(extent={{80,-40},{100,-20}})));

equation
  connect(unOccMod.y, isUnOcc.u2) annotation (Line(points={{-58,60},{-50,60},{-50,
          72},{-42,72}}, color={255,127,0}));

  connect(opeMod, isUnOcc.u1)
    annotation (Line(points={{-120,80},{-42,80}}, color={255,127,0}));

  connect(isUnOcc.y, notUno.u)
    annotation (Line(points={{-18,80},{-12,80}}, color={255,0,255}));

  connect(notUno.y, y1Fan) annotation (Line(points={{12,80},{20,80},{20,60},{140,
          60}}, color={255,0,255}));

  connect(u1FanPro, swiFanPro.u2) annotation (Line(points={{-120,40},{30,40},{30,
          0},{78,0}}, color={255,0,255}));

  connect(notUno.y, booToRea.u) annotation (Line(points={{12,80},{20,80},{20,-20},
          {28,-20}}, color={255,0,255}));

  connect(uHea, linHeaFanSpe.u)
    annotation (Line(points={{-120,-20},{-32,-20}}, color={0,0,127}));

  connect(uCoo, linCooFanSpe.u)
    annotation (Line(points={{-120,-120},{-32,-120}}, color={0,0,127}));

  connect(uHea, hysDeaHea.u) annotation (Line(points={{-120,-20},{-36,-20},{-36,
          -40},{-2,-40}}, color={0,0,127}));

  connect(hysDeaHea.y, swiDeaHea.u2) annotation (Line(points={{22,-40},{26,-40},
          {26,-60},{28,-60}}, color={255,0,255}));

  connect(conDeaFanSpe.y, swiDeaHea.u3) annotation (Line(points={{-8,-60},{20,-60},
          {20,-68},{28,-68}}, color={0,0,127}));

  connect(linHeaFanSpe.y, swiDeaHea.u1) annotation (Line(points={{-8,-20},{-4,-20},
          {-4,-52},{28,-52}}, color={0,0,127}));

  connect(hysDeaCoo.y, swiDeaCoo.u2)
    annotation (Line(points={{22,-100},{58,-100}}, color={255,0,255}));

  connect(uCoo, hysDeaCoo.u) annotation (Line(points={{-120,-120},{-34,-120},{-34,
          -100},{-2,-100}}, color={0,0,127}));

  connect(linCooFanSpe.y, swiDeaCoo.u1) annotation (Line(points={{-8,-120},{40,-120},
          {40,-92},{58,-92}}, color={0,0,127}));

  connect(swiDeaHea.y, swiDeaCoo.u3) annotation (Line(points={{52,-60},{54,-60},
          {54,-108},{58,-108}}, color={0,0,127}));

  connect(booToRea.y, mulFanSpe.u1) annotation (Line(points={{52,-20},{74,-20},{
          74,-74},{88,-74}}, color={0,0,127}));

  connect(swiDeaCoo.y, mulFanSpe.u2) annotation (Line(points={{82,-100},{84,-100},
          {84,-86},{88,-86}}, color={0,0,127}));

  connect(mulFanSpe.y, swiFanPro.u1) annotation (Line(points={{112,-80},{114,-80},
          {114,20},{74,20},{74,8},{78,8}}, color={0,0,127}));

  connect(swiFanPro.y, yFan)
    annotation (Line(points={{102,0},{140,0}}, color={0,0,127}));

  connect(conZerHeaMod.y, linHeaFanSpe.u) annotation (Line(points={{-68,-70},{-36,
          -70},{-36,-20},{-32,-20}}, color={0,0,127}));

  connect(conZerCooMod.y, linCooFanSpe.u) annotation (Line(points={{-8,-150},{-6,
          -150},{-6,-100},{-34,-100},{-34,-120},{-32,-120}}, color={0,0,127}));

  connect(conZerHeaMod.y, hysDeaHea.u) annotation (Line(points={{-68,-70},{-36,-70},
          {-36,-40},{-2,-40}}, color={0,0,127}));

  connect(conZerCooMod.y, hysDeaCoo.u) annotation (Line(points={{-8,-150},{-6,-150},
          {-6,-100},{-2,-100}}, color={0,0,127}));

  connect(conheaSpe_max.y, linHeaFanSpe.f2) annotation (Line(points={{-38,20},{-34,
          20},{-34,-28},{-32,-28}}, color={0,0,127}));
  connect(conuHea_max.y, linHeaFanSpe.x2)
    annotation (Line(points={{-38,-40},{-38,-24},{-32,-24}}, color={0,0,127}));
  connect(concooSpe_max.y, linCooFanSpe.f2) annotation (Line(points={{-38,-90},{-36,
          -90},{-36,-128},{-32,-128}}, color={0,0,127}));
  connect(conuCoo_max.y, linCooFanSpe.x2) annotation (Line(points={{-38,-150},{
          -34,-150},{-34,-124},{-32,-124}}, color={0,0,127}));
  connect(conheaSpe_min.y, linHeaFanSpe.f1) annotation (Line(points={{-68,20},{-66,
          20},{-66,-16},{-32,-16}}, color={0,0,127}));
  connect(conuHea_min.y, linHeaFanSpe.x1) annotation (Line(points={{-68,-40},{-64,
          -40},{-64,-12},{-32,-12}}, color={0,0,127}));
  connect(conuCoo_min.y, linCooFanSpe.x1) annotation (Line(points={{-68,-140},{
          -66,-140},{-66,-112},{-32,-112}}, color={0,0,127}));
  connect(concooSpe_min.y, linCooFanSpe.f1) annotation (Line(points={{-68,-100},{
          -64,-100},{-64,-116},{-32,-116}}, color={0,0,127}));
  connect(mulDeaSpe.y, swiFanPro.u3) annotation (Line(points={{102,-30},{108,-30},
          {108,-14},{74,-14},{74,-8},{78,-8}}, color={0,0,127}));
  connect(booToRea.y, mulDeaSpe.u1) annotation (Line(points={{52,-20},{74,-20},{
          74,-24},{78,-24}}, color={0,0,127}));
  connect(conDeaFanSpe.y, mulDeaSpe.u2) annotation (Line(points={{-8,-60},{20,-60},
          {20,-74},{60,-74},{60,-36},{78,-36}}, color={0,0,127}));
  annotation (defaultComponentName="fanSpe",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                               graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,140},{100,100}},
          textColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-98,32},{-36,12}},
          textColor={255,0,255},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="u1FanPro"),
        Text(
          extent={{48,32},{94,12}},
          textColor={255,0,255},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="y1Fan"),
        Text(
          extent={{-100,70},{-36,50}},
          textColor={255,127,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="opeMod"),
        Text(
          extent={{-100,-10},{-52,-32}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="uHea",
          visible=have_heaCoi),
        Text(
          extent={{-100,-50},{-52,-72}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="uCoo",
          visible=have_cooCoi),
        Text(
          extent={{46,-8},{100,-30}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yFan")}),
    Diagram(coordinateSystem(preserveAspectRatio=false,
        extent={{-100,-180},{120,120}})),
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
      the minimum cooling mode fan speed <code>cooSpe_min</code> to the maximum
      cooling mode fan speed <code>cooSpe_max</code>,
      when the cooling loop signal <code>uCoo</code> varies from the minimum limit
      <code>uCoo_min</code> to the maximum limit <code>uCoo_max</code>.
      Similarly, <code>yFanSpe</code> is varied from the minimum heating mode fan speed
      <code>heaSpe_min</code> to the maximum heating mode fan speed <code>heaSpe_max</code>,
      when the heating loop signal <code>uHea</code> varies from the minimum limit
      <code>uHea_min</code> to the maximum limit <code>uHea_max</code>.
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
