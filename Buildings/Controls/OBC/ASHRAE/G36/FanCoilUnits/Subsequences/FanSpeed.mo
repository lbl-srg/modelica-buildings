within Buildings.Controls.OBC.ASHRAE.G36.FanCoilUnits.Subsequences;
block FanSpeed
  "Fan speed setpoint subsequence"

  parameter Boolean have_cooCoi
    "True if the unit has a cooling coil"
    annotation(__cdl(ValueInReference=false));

  parameter Boolean have_heaCoi
    "True if the unit has a heating coil"
    annotation(__cdl(ValueInReference=false));

  parameter Real deaSpe(
    final unit="1",
    displayUnit="1") = 0.1
    "Deadband mode fan speed"
    annotation(__cdl(ValueInReference=false), Dialog(group="Deadband"));

  parameter Real heaSpe_min(
    final unit="1",
    displayUnit="1") = 0.1
    "Minimum heating mode fan speed"
    annotation(__cdl(ValueInReference=false),
      Dialog(group="Heating loop", enable = have_heaCoi));

  parameter Real uHea_min(
    final unit="1",
    displayUnit="1") = 0.5
    "Minimum heating loop signal at which fan speed is modified"
    annotation(Dialog(group="Heating loop", enable = have_heaCoi));

  parameter Real heaSpe_max(
    final unit="1",
    displayUnit="1") = 0.6
    "Maximum heating mode fan speed"
    annotation(__cdl(ValueInReference=false),
      Dialog(group="Heating loop", enable = have_heaCoi));

  parameter Real uHea_max(
    final unit="1",
    displayUnit="1") = 1
    "Maximum heating loop signal at which fan speed is modified"
    annotation(Dialog(group="Heating loop", enable = have_heaCoi));

  parameter Real cooSpe_min(
    final unit="1",
    displayUnit="1") = 0.2
    "Minimum cooling mode fan speed"
    annotation(__cdl(ValueInReference=false),
      Dialog(group="Cooling loop", enable = have_cooCoi));

  parameter Real uCoo_min(
    final unit="1",
    displayUnit="1") = 0.5
    "Minimum cooling loop signal at which fan speed is modified"
    annotation(Dialog(group="Cooling loop", enable = have_cooCoi));

  parameter Real cooSpe_max(
    final unit="1",
    displayUnit="1") = 1
    "Maximum cooling mode fan speed"
    annotation(__cdl(ValueInReference=false),
      Dialog(group="Cooling loop", enable = have_cooCoi));

  parameter Real uCoo_max(
    final unit="1",
    displayUnit="1") = 1
    "Maximum cooling loop signal at which fan speed is modified"
    annotation(Dialog(group="Cooling loop", enable = have_cooCoi));

  parameter Real heaDea(
    final unit="1",
    displayUnit="1") = 0.05
    "Heating loop signal limit above which fan operation changes from deadband
    mode to heating mode"
    annotation(__cdl(ValueInReference=false),
      Dialog(group="Deadband", enable = have_heaCoi));

  parameter Real cooDea(
    final unit="1",
    displayUnit="1") = 0.05
    "Cooling loop signal limit above which fan operation changes from deadband
    mode to cooling mode"
    annotation(__cdl(ValueInReference=false),
      Dialog(group="Deadband", enable = have_cooCoi));

  parameter Real deaHysLim(
    final unit="1",
    displayUnit="1") = 0.01
    "Hysteresis limits for deadband mode transitions"
    annotation(__cdl(ValueInReference=false), Dialog(tab="Advanced"));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1FanPro
    "Fan proven on signal"
    annotation (Placement(transformation(extent={{-240,100},{-200,140}}),
      iconTransformation(extent={{-140,0},{-100,40}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput opeMod
    "System operating mode"
    annotation (Placement(transformation(extent={{-240,150},{-200,190}}),
      iconTransformation(extent={{-140,40},{-100,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uHea(
    final unit="1",
    displayUnit="1") if have_heaCoi
    "Heating loop signal"
    annotation (Placement(transformation(extent={{-240,10},{-200,50}}),
      iconTransformation(extent={{-140,-40},{-100,0}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCoo(
    final unit="1",
    displayUnit="1") if have_cooCoi
    "Cooling loop signal"
    annotation (Placement(transformation(extent={{-240,-120},{-200,-80}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1Fan
    "Fan command on status"
    annotation (Placement(transformation(extent={{200,150},{240,190}}),
      iconTransformation(extent={{100,0},{140,40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yFan(
    final unit="1",
    displayUnit="1")
    "Fan command speed"
    annotation (Placement(transformation(extent={{200,80},{240,120}}),
      iconTransformation(extent={{100,-40},{140,0}})));

protected
  Buildings.Controls.OBC.CDL.Integers.Equal isUnOcc
    "Check if zone is unoccupied"
    annotation (Placement(transformation(extent={{-120,160},{-100,180}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant unOccMod(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.unoccupied)
    "Constant unoccupied mode signal"
    annotation (Placement(transformation(extent={{-180,140},{-160,160}})));

  Buildings.Controls.OBC.CDL.Logical.Not notUno
    "Enable only if zone is not in unoccupied mode"
    annotation (Placement(transformation(extent={{-80,160},{-60,180}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea
    "Convert fan enable signal to Real"
    annotation (Placement(transformation(extent={{120,120},{140,140}})));

  Buildings.Controls.OBC.CDL.Reals.Line linHeaFanSpe if have_heaCoi
    "Heating fan speed signal"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conuHea_min(
    final k=uHea_min)
    "Minimum heating loop signal support point"
    annotation (Placement(transformation(extent={{-100,90},{-80,110}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conheaSpe_min(
    final k=heaSpe_min)
    "Minimum heating fan speed limit signal"
    annotation (Placement(transformation(extent={{-140,70},{-120,90}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant concooSpe_min(
    final k=cooSpe_min)
    "Minimum cooling fan speed limit signal"
    annotation (Placement(transformation(extent={{-110,-90},{-90,-70}})));

  Buildings.Controls.OBC.CDL.Reals.Line linCooFanSpe if have_cooCoi
    "Cooling fan speed signal"
    annotation (Placement(transformation(extent={{-52,-130},{-32,-110}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conuCoo_min(
    final k=uCoo_min)
    "Minimum cooling loop signal support point"
    annotation (Placement(transformation(extent={{-140,-70},{-120,-50}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conDeaFanSpe(
    final k=deaSpe)
    "Deadband mode fan speed signal"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));

  Buildings.Controls.OBC.CDL.Reals.Hysteresis hysDeaHea(
    final uLow=heaDea-deaHysLim,
    final uHigh=heaDea) if have_heaCoi
    "Hysteresis for switching between deadband mode and heating mode"
    annotation (Placement(transformation(extent={{-140,0},{-120,20}})));

  Buildings.Controls.OBC.CDL.Reals.Hysteresis hysDeaCoo(
    final uLow=cooDea-deaHysLim,
    final uHigh=cooDea) if have_cooCoi
    "Hysteresis for switching on cooling mode from deadband mode"
    annotation (Placement(transformation(extent={{-160,-200},{-140,-180}})));

  Buildings.Controls.OBC.CDL.Reals.Multiply mulFanSpe
    "Multiply fan speed signal by fan enable signal"
    annotation (Placement(transformation(extent={{170,90},{190,110}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conheaSpe_max(
    final k=heaSpe_max)
    "Maximum heating fan speed limit signal"
    annotation (Placement(transformation(extent={{-140,40},{-120,60}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conuHea_max(
    final k=uHea_max)
    "Maximum heating loop signal support point"
    annotation (Placement(transformation(extent={{-100,50},{-80,70}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant concooSpe_max(
    final k=cooSpe_max)
    "Maximum cooling fan speed limit signal"
    annotation (Placement(transformation(extent={{-140,-160},{-120,-140}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conuCoo_max(
    final k=uCoo_max)
    "Maximum cooling loop signal support point"
    annotation (Placement(transformation(extent={{-110,-140},{-90,-120}})));

  Buildings.Controls.OBC.CDL.Reals.Multiply mulHeaSpe if have_heaCoi
    "Multiply by heating mode fan speed signal"
    annotation (Placement(transformation(extent={{0,30},{20,50}})));

  Buildings.Controls.OBC.CDL.Reals.Multiply mulDeaSpe1 if have_heaCoi
    "Multiply by deadband mode fan speed signal"
    annotation (Placement(transformation(extent={{0,-60},{20,-40}})));

  Buildings.Controls.OBC.CDL.Reals.Multiply mulDeaSpe2 if have_cooCoi
    "Multiply by deadband mode fan speed signal"
    annotation (Placement(transformation(extent={{10,-220},{30,-200}})));

  Buildings.Controls.OBC.CDL.Reals.Multiply mulCooSpe if have_cooCoi
    "Multiply by cooling mode fan speed signal"
    annotation (Placement(transformation(extent={{10,-140},{30,-120}})));

  Buildings.Controls.OBC.CDL.Reals.Multiply mulFanSpe1
    "Multiply fan speed signal by fan proven on signal"
    annotation (Placement(transformation(extent={{90,100},{110,120}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea5
    "Convert fan proven on signal to Real"
    annotation (Placement(transformation(extent={{0,110},{20,130}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea6(
    final realTrue=0,
    final realFalse=1)
    "Convert fan proven on signal to Real"
    annotation (Placement(transformation(extent={{0,80},{20,100}})));

  Buildings.Controls.OBC.CDL.Reals.Multiply mulFanSpe2
    "Multiply fan speed signal by fan proven on signal"
    annotation (Placement(transformation(extent={{90,70},{110,90}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1 if have_heaCoi
    "Switch fan speed between heating mode and deadband mode"
    annotation (Placement(transformation(extent={{-90,0},{-70,20}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea2(
    final realTrue=0,
    final realFalse=1)
    if have_heaCoi
    "Switch fan speed between heating mode and deadband mode"
    annotation (Placement(transformation(extent={{-90,-50},{-70,-30}})));

  Buildings.Controls.OBC.CDL.Reals.Add addFanSpeHea if have_heaCoi
    "Add deadband mode and heating mode fan speed signals to get required fan speed"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea3 if have_cooCoi
    "Switch fan speed between cooling mode and deadband mode"
    annotation (Placement(transformation(extent={{-80,-200},{-60,-180}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea4(
    final realTrue=0,
    final realFalse=1) if have_cooCoi
    "Switch fan speed between cooling mode and deadband mode"
    annotation (Placement(transformation(extent={{-80,-240},{-60,-220}})));

  Buildings.Controls.OBC.CDL.Reals.Add addFanSpeCoo if have_cooCoi
    "Add deadband mode and cooling mode fan speed signals to get required fan speed"
    annotation (Placement(transformation(extent={{50,-170},{70,-150}})));

  Buildings.Controls.OBC.CDL.Reals.Add addFanSpe2
    "Add fan speed signals before and after fan is proven on"
    annotation (Placement(transformation(extent={{130,80},{150,100}})));

equation
  connect(unOccMod.y, isUnOcc.u2) annotation (Line(points={{-158,150},{-140,150},
          {-140,162},{-122,162}}, color={255,127,0}));
  connect(opeMod, isUnOcc.u1)
    annotation (Line(points={{-220,170},{-122,170}}, color={255,127,0}));
  connect(isUnOcc.y, notUno.u)
    annotation (Line(points={{-98,170},{-82,170}}, color={255,0,255}));
  connect(notUno.y, y1Fan) annotation (Line(points={{-58,170},{220,170}},
          color={255,0,255}));
  connect(notUno.y, booToRea.u) annotation (Line(points={{-58,170},{108,170},{108,
          130},{118,130}},
                     color={255,0,255}));
  connect(uHea, linHeaFanSpe.u)
    annotation (Line(points={{-220,30},{-50,30},{-50,50},{-42,50}},
                                                  color={0,0,127}));
  connect(uCoo, linCooFanSpe.u)
    annotation (Line(points={{-220,-100},{-80,-100},{-80,-120},{-54,-120}},
                                                      color={0,0,127}));
  connect(uHea, hysDeaHea.u) annotation (Line(points={{-220,30},{-152,30},{-152,
          10},{-142,10}},
                    color={0,0,127}));
  connect(uCoo, hysDeaCoo.u) annotation (Line(points={{-220,-100},{-172,-100},{-172,
          -190},{-162,-190}},
                            color={0,0,127}));
  connect(booToRea.y, mulFanSpe.u1) annotation (Line(points={{142,130},{158,130},
          {158,106},{168,106}},
                            color={0,0,127}));
  connect(conheaSpe_max.y, linHeaFanSpe.f2) annotation (Line(points={{-118,50},{
          -108,50},{-108,42},{-42,42}},
                                    color={0,0,127}));
  connect(conuHea_max.y, linHeaFanSpe.x2)
    annotation (Line(points={{-78,60},{-60,60},{-60,46},{-42,46}},   color={0,0,127}));
  connect(concooSpe_max.y, linCooFanSpe.f2) annotation (Line(points={{-118,-150},
          {-60,-150},{-60,-128},{-54,-128}}, color={0,0,127}));
  connect(conuCoo_max.y, linCooFanSpe.x2) annotation (Line(points={{-88,-130},{-70,
          -130},{-70,-124},{-54,-124}},color={0,0,127}));
  connect(conheaSpe_min.y, linHeaFanSpe.f1) annotation (Line(points={{-118,80},{
          -56,80},{-56,54},{-42,54}},   color={0,0,127}));
  connect(conuHea_min.y, linHeaFanSpe.x1) annotation (Line(points={{-78,100},{-50,
          100},{-50,58},{-42,58}},   color={0,0,127}));
  connect(conuCoo_min.y, linCooFanSpe.x1) annotation (Line(points={{-118,-60},{-60,
          -60},{-60,-112},{-54,-112}},      color={0,0,127}));
  connect(concooSpe_min.y, linCooFanSpe.f1) annotation (Line(points={{-88,-80},{
          -64,-80},{-64,-116},{-54,-116}},     color={0,0,127}));

  connect(hysDeaHea.y, booToRea1.u)
    annotation (Line(points={{-118,10},{-92,10}}, color={255,0,255}));
  connect(linHeaFanSpe.y, mulHeaSpe.u1) annotation (Line(points={{-18,50},{-10,50},
          {-10,46},{-2,46}}, color={0,0,127}));
  connect(booToRea1.y, mulHeaSpe.u2) annotation (Line(points={{-68,10},{-12,10},
          {-12,34},{-2,34}}, color={0,0,127}));
  connect(hysDeaHea.y, booToRea2.u) annotation (Line(points={{-118,10},{-110,10},
          {-110,-40},{-92,-40}}, color={255,0,255}));
  connect(booToRea2.y, mulDeaSpe1.u2) annotation (Line(points={{-68,-40},{-20,-40},
          {-20,-56},{-2,-56}}, color={0,0,127}));
  connect(conDeaFanSpe.y, mulDeaSpe1.u1) annotation (Line(points={{-38,-20},{-12,
          -20},{-12,-44},{-2,-44}}, color={0,0,127}));
  connect(mulHeaSpe.y, addFanSpeHea.u1)
    annotation (Line(points={{22,40},{30,40},{30,6},{38,6}}, color={0,0,127}));
  connect(mulDeaSpe1.y, addFanSpeHea.u2) annotation (Line(points={{22,-50},{30,-50},
          {30,-6},{38,-6}}, color={0,0,127}));
  connect(hysDeaCoo.y, booToRea3.u)
    annotation (Line(points={{-138,-190},{-82,-190}}, color={255,0,255}));
  connect(hysDeaCoo.y, booToRea4.u) annotation (Line(points={{-138,-190},{-90,-190},
          {-90,-230},{-82,-230}}, color={255,0,255}));
  connect(booToRea3.y, mulCooSpe.u2) annotation (Line(points={{-58,-190},{0,-190},
          {0,-136},{8,-136}}, color={0,0,127}));
  connect(linCooFanSpe.y, mulCooSpe.u1) annotation (Line(points={{-30,-120},{0,-120},
          {0,-124},{8,-124}}, color={0,0,127}));
  connect(booToRea4.y, mulDeaSpe2.u2) annotation (Line(points={{-58,-230},{-26,-230},
          {-26,-216},{8,-216}}, color={0,0,127}));
  connect(addFanSpeHea.y, mulDeaSpe2.u1) annotation (Line(points={{62,0},{70,0},
          {70,-80},{-12,-80},{-12,-204},{8,-204}}, color={0,0,127}));
  if not have_heaCoi then
  connect(conDeaFanSpe.y, mulDeaSpe2.u1) annotation (Line(points={{-38,-20},{-12,
          -20},{-12,-204},{8,-204}}, color={0,0,127}));
  end if;
  connect(mulDeaSpe2.y, addFanSpeCoo.u2) annotation (Line(points={{32,-210},{40,
          -210},{40,-166},{48,-166}}, color={0,0,127}));
  connect(mulCooSpe.y, addFanSpeCoo.u1) annotation (Line(points={{32,-130},{40,-130},
          {40,-154},{48,-154}}, color={0,0,127}));
  connect(mulFanSpe.y, yFan)
    annotation (Line(points={{192,100},{220,100}},
                                               color={0,0,127}));
  connect(u1FanPro, booToRea5.u)
    annotation (Line(points={{-220,120},{-2,120}},  color={255,0,255}));
  connect(booToRea5.y, mulFanSpe1.u1) annotation (Line(points={{22,120},{78,120},
          {78,116},{88,116}},
                          color={0,0,127}));
  connect(addFanSpeCoo.y, mulFanSpe1.u2) annotation (Line(points={{72,-160},{80,
          -160},{80,104},{88,104}}, color={0,0,127}));
  connect(addFanSpe2.y, mulFanSpe.u2) annotation (Line(points={{152,90},{160,90},
          {160,94},{168,94}},                     color={0,0,127}));
  connect(u1FanPro, booToRea6.u) annotation (Line(points={{-220,120},{-20,120},{
          -20,90},{-2,90}},  color={255,0,255}));
  connect(mulFanSpe2.y, addFanSpe2.u2) annotation (Line(points={{112,80},{120,80},
          {120,84},{128,84}},   color={0,0,127}));
  connect(mulFanSpe1.y, addFanSpe2.u1) annotation (Line(points={{112,110},{120,110},
          {120,96},{128,96}},   color={0,0,127}));
  connect(booToRea6.y, mulFanSpe2.u1) annotation (Line(points={{22,90},{78,90},{
          78,86},{88,86}},color={0,0,127}));
  connect(conDeaFanSpe.y, mulFanSpe2.u2) annotation (Line(points={{-38,-20},{76,
          -20},{76,74},{88,74}},   color={0,0,127}));
  if not have_cooCoi then
  connect(addFanSpeHea.y, mulFanSpe1.u2) annotation (Line(points={{62,0},{80,0},
          {80,104},{88,104}}, color={0,0,127}));
  end if;
  if not (have_cooCoi or have_heaCoi) then
  connect(conDeaFanSpe.y, mulFanSpe1.u2) annotation (Line(points={{-38,-20},{76,
          -20},{76,104},{88,104}}, color={0,0,127}));
  end if;
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
        extent={{-200,-260},{200,200}})),
Documentation(info="<html>
<p>
Block that outputs the fan enable signal and the fan speed signal based on
the heating and cooling loop signals. The implemented sequence is based on
ASHRAE Guideline 36, 2021, Part 5.22.4.
</p>
<p>
The fan enable signal <code>y1Fan</code> is set to <code>false</code>
when the operating mode signal <code>opeMod</code> is <code>unoccupied</code>,
and is set to <code>true</code> otherwise.
</p>
<p>
The fan speed signal <code>yFan</code> is varied from
the minimum cooling mode fan speed <code>cooSpe_min</code> to the maximum
cooling mode fan speed <code>cooSpe_max</code>,
when the cooling loop signal <code>uCoo</code> varies from the minimum limit
<code>uCoo_min</code> to the maximum limit <code>uCoo_max</code>.
Similarly, <code>yFan</code> is varied from the minimum heating mode fan speed
<code>heaSpe_min</code> to the maximum heating mode fan speed <code>heaSpe_max</code>,
when the heating loop signal <code>uHea</code> varies from the minimum limit
<code>uHea_min</code> to the maximum limit <code>uHea_max</code>.
The setpoint in deadband mode is equal to the deadband fan speed <code>deaSpe</code>.
</p>
<p align=\"center\">
<img alt=\"Fan speed setpoint control logic diagram\"
src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/G36/FanCoilUnits/Subsequences/FanSpeed.png\"/>
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
