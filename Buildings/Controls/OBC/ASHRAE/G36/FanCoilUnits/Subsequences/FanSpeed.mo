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
    unit="1",
    displayUnit="1")=0.1
    "Deadband mode fan speed"
    annotation(__cdl(ValueInReference=false), Dialog(group="Deadband"));

  parameter Real heaSpe_min(
    unit="1",
    displayUnit="1")=0.1
    "Minimum heating mode fan speed"
    annotation(__cdl(ValueInReference=false),
      Dialog(group="Heating loop", enable = have_heaCoi));

  parameter Real uHea_min(
    unit="1",
    displayUnit="1")=0.5
    "Minimum heating loop signal at which fan speed is modified"
    annotation(Dialog(group="Heating loop", enable = have_heaCoi));

  parameter Real heaSpe_max(
    unit="1",
    displayUnit="1")=0.6
    "Maximum heating mode fan speed"
    annotation(__cdl(ValueInReference=false),
      Dialog(group="Heating loop", enable = have_heaCoi));

  parameter Real uHea_max(
    unit="1",
    displayUnit="1")=1
    "Maximum heating loop signal at which fan speed is modified"
    annotation(Dialog(group="Heating loop", enable = have_heaCoi));

  parameter Real cooSpe_min(
    unit="1",
    displayUnit="1")=0.2
    "Minimum cooling mode fan speed"
    annotation(__cdl(ValueInReference=false),
      Dialog(group="Cooling loop", enable = have_cooCoi));

  parameter Real uCoo_min(
    unit="1",
    displayUnit="1")=0.5
    "Minimum cooling loop signal at which fan speed is modified"
    annotation(Dialog(group="Cooling loop", enable = have_cooCoi));

  parameter Real cooSpe_max(
    unit="1",
    displayUnit="1")=1
    "Maximum cooling mode fan speed"
    annotation(__cdl(ValueInReference=false),
      Dialog(group="Cooling loop", enable = have_cooCoi));

  parameter Real uCoo_max(
    unit="1",
    displayUnit="1")=1
    "Maximum cooling loop signal at which fan speed is modified"
    annotation(Dialog(group="Cooling loop", enable = have_cooCoi));

  parameter Real heaDea(
    unit="1",
    displayUnit="1")=0.1
    "Heating loop signal limit above which fan operation changes from deadband
    mode to heating mode"
    annotation(__cdl(ValueInReference=false),
      Dialog(group="Deadband", enable = have_heaCoi));

  parameter Real cooDea(
    unit="1",
    displayUnit="1")=0.1
    "Cooling loop signal limit above which fan operation changes from deadband
    mode to cooling mode"
    annotation(__cdl(ValueInReference=false),
      Dialog(group="Deadband", enable = have_cooCoi));

  parameter Real deaHysLim(
    unit="1",
    displayUnit="1")=0.05
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
    annotation (Placement(transformation(extent={{-240,-150},{-200,-110}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1Fan
    "Fan command on status"
    annotation (Placement(transformation(extent={{200,150},{240,190}}),
      iconTransformation(extent={{100,0},{140,40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yFan(
    final unit="1",
    displayUnit="1")
    "Fan command speed"
    annotation (Placement(transformation(extent={{200,20},{240,60}}),
      iconTransformation(extent={{100,-40},{140,0}})));

  Buildings.Controls.OBC.CDL.Integers.Equal isUnOcc
    "Check if zone is unoccupied"
    annotation (Placement(transformation(extent={{-120,160},{-100,180}})));

  Buildings.Controls.OBC.CDL.Logical.Not notUno
    "Enable only if zone is not in unoccupied mode"
    annotation (Placement(transformation(extent={{-80,160},{-60,180}})));

  Buildings.Controls.OBC.CDL.Reals.Switch swiFanPro
    "Switch fan speed to deadband speed until the fan is proven ON"
    annotation (Placement(transformation(extent={{160,30},{180,50}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea
    "Convert fan enable signal to Real"
    annotation (Placement(transformation(extent={{40,70},{60,90}})));

  Buildings.Controls.OBC.CDL.Reals.Line linHeaFanSpe if have_heaCoi
    "Heating fan speed signal"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));

  Buildings.Controls.OBC.CDL.Reals.Line linCooFanSpe if have_cooCoi
    "Cooling fan speed signal"
    annotation (Placement(transformation(extent={{-60,-140},{-40,-120}})));

  Buildings.Controls.OBC.CDL.Reals.Hysteresis hysDeaHea(
    final uLow=heaDea-deaHysLim,
    final uHigh=heaDea) if have_heaCoi
    "Hysteresis for switching between deadband mode and heating mode"
    annotation (Placement(transformation(extent={{-160,-10},{-140,10}})));

  Buildings.Controls.OBC.CDL.Reals.Switch swiDeaHea if have_heaCoi
    "Switch for turning on heating mode from deadband mode"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));

  Buildings.Controls.OBC.CDL.Reals.Hysteresis hysDeaCoo(
    final uLow=cooDea-deaHysLim,
    final uHigh=cooDea) if have_cooCoi
    "Hysteresis for switching on cooling mode from deadband mode"
    annotation (Placement(transformation(extent={{-160,-170},{-140,-150}})));

  Buildings.Controls.OBC.CDL.Reals.Switch swiDeaCoo
    "Switch for turning on cooling mode from deadband mode"
    annotation (Placement(transformation(extent={{60,-170},{80,-150}})));

  Buildings.Controls.OBC.CDL.Reals.Multiply mulFanSpe
    "Multiply fan speed signal by fan enable signal"
    annotation (Placement(transformation(extent={{100,-150},{120,-130}})));

  Buildings.Controls.OBC.CDL.Reals.Multiply mulDeaSpe
    "Multiply deadband speed signal by fan enable signal"
    annotation (Placement(transformation(extent={{100,0},{120,20}})));

  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai(
    final k=1) if not have_heaCoi "Dummy gain"
    annotation (Placement(transformation(extent={{0,-70},{20,-50}})));

  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai1(
    final k=1) if not have_cooCoi "Dummy gain"
    annotation (Placement(transformation(extent={{0,-110},{20,-90}})));

protected
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant unOccMod(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.unoccupied)
    "Constant unoccupied mode signal"
    annotation (Placement(transformation(extent={{-180,140},{-160,160}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(
    final k=false) if not have_cooCoi
    "Constant false"
    annotation (Placement(transformation(extent={{-60,-190},{-40,-170}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conuCoo_max(
    final k=uCoo_max) if have_cooCoi
    "Maximum cooling loop signal support point"
    annotation (Placement(transformation(extent={{-120,-60},{-100,-40}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant concooSpe_max(
    final k=cooSpe_max) if have_cooCoi
    "Maximum cooling fan speed limit signal"
    annotation (Placement(transformation(extent={{-120,-100},{-100,-80}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conheaSpe_max(
    final k=heaSpe_max) if have_heaCoi
    "Maximum heating fan speed limit signal"
    annotation (Placement(transformation(extent={{-120,50},{-100,70}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conuHea_max(
    final k=uHea_max) if have_heaCoi
    "Maximum heating loop signal support point"
    annotation (Placement(transformation(extent={{-120,90},{-100,110}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conuCoo_min(
    final k=uCoo_min) if have_cooCoi
    "Minimum cooling loop signal support point"
    annotation (Placement(transformation(extent={{-180,-60},{-160,-40}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conDeaFanSpe(
    final k=deaSpe)
    "Deadband mode fan speed signal"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conuHea_min(
    final k=uHea_min) if have_heaCoi
    "Minimum heating loop signal support point"
    annotation (Placement(transformation(extent={{-180,90},{-160,110}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conheaSpe_min(
    final k=heaSpe_min) if have_heaCoi
    "Minimum heating fan speed limit signal"
    annotation (Placement(transformation(extent={{-180,50},{-160,70}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant concooSpe_min(
    final k=cooSpe_min) if have_cooCoi
    "Minimum cooling fan speed limit signal"
    annotation (Placement(transformation(extent={{-180,-100},{-160,-80}})));

equation
  connect(unOccMod.y, isUnOcc.u2) annotation (Line(points={{-158,150},{-140,150},
          {-140,162},{-122,162}}, color={255,127,0}));
  connect(opeMod, isUnOcc.u1)
    annotation (Line(points={{-220,170},{-122,170}}, color={255,127,0}));
  connect(isUnOcc.y, notUno.u)
    annotation (Line(points={{-98,170},{-82,170}}, color={255,0,255}));
  connect(notUno.y, y1Fan) annotation (Line(points={{-58,170},{220,170}},
          color={255,0,255}));
  connect(u1FanPro, swiFanPro.u2) annotation (Line(points={{-220,120},{130,120},
          {130,40},{158,40}},  color={255,0,255}));
  connect(notUno.y, booToRea.u) annotation (Line(points={{-58,170},{0,170},{0,80},
          {38,80}},  color={255,0,255}));
  connect(uHea, linHeaFanSpe.u)
    annotation (Line(points={{-220,30},{-62,30}}, color={0,0,127}));
  connect(uCoo, linCooFanSpe.u)
    annotation (Line(points={{-220,-130},{-62,-130}}, color={0,0,127}));
  connect(uHea, hysDeaHea.u) annotation (Line(points={{-220,30},{-180,30},{-180,
          0},{-162,0}}, color={0,0,127}));
  connect(hysDeaHea.y, swiDeaHea.u2) annotation (Line(points={{-138,0},{18,0}},
          color={255,0,255}));
  connect(conDeaFanSpe.y, swiDeaHea.u3) annotation (Line(points={{-38,-30},{-20,
          -30},{-20,-8},{18,-8}}, color={0,0,127}));
  connect(linHeaFanSpe.y, swiDeaHea.u1) annotation (Line(points={{-38,30},{-20,30},
          {-20,8},{18,8}},color={0,0,127}));
  connect(hysDeaCoo.y, swiDeaCoo.u2)
    annotation (Line(points={{-138,-160},{58,-160}}, color={255,0,255}));
  connect(uCoo, hysDeaCoo.u) annotation (Line(points={{-220,-130},{-180,-130},{-180,
          -160},{-162,-160}}, color={0,0,127}));
  connect(linCooFanSpe.y, swiDeaCoo.u1) annotation (Line(points={{-38,-130},{40,
          -130},{40,-152},{58,-152}}, color={0,0,127}));
  connect(swiDeaHea.y, swiDeaCoo.u3) annotation (Line(points={{42,0},{50,0},{50,
          -168},{58,-168}}, color={0,0,127}));
  connect(booToRea.y, mulFanSpe.u1) annotation (Line(points={{62,80},{90,80},{90,
          -134},{98,-134}}, color={0,0,127}));
  connect(swiDeaCoo.y, mulFanSpe.u2) annotation (Line(points={{82,-160},{90,-160},
          {90,-146},{98,-146}}, color={0,0,127}));
  connect(mulFanSpe.y, swiFanPro.u1) annotation (Line(points={{122,-140},{140,-140},
          {140,48},{158,48}}, color={0,0,127}));
  connect(swiFanPro.y, yFan)
    annotation (Line(points={{182,40},{220,40}}, color={0,0,127}));
  connect(conheaSpe_max.y, linHeaFanSpe.f2) annotation (Line(points={{-98,60},{-90,
          60},{-90,22},{-62,22}},   color={0,0,127}));
  connect(conuHea_max.y, linHeaFanSpe.x2)
    annotation (Line(points={{-98,100},{-80,100},{-80,26},{-62,26}}, color={0,0,127}));
  connect(concooSpe_max.y, linCooFanSpe.f2) annotation (Line(points={{-98,-90},{
          -90,-90},{-90,-138},{-62,-138}},   color={0,0,127}));
  connect(conuCoo_max.y, linCooFanSpe.x2) annotation (Line(points={{-98,-50},{-80,
          -50},{-80,-134},{-62,-134}}, color={0,0,127}));
  connect(conheaSpe_min.y, linHeaFanSpe.f1) annotation (Line(points={{-158,60},{
          -140,60},{-140,34},{-62,34}}, color={0,0,127}));
  connect(conuHea_min.y, linHeaFanSpe.x1) annotation (Line(points={{-158,100},{-130,
          100},{-130,38},{-62,38}},  color={0,0,127}));
  connect(conuCoo_min.y, linCooFanSpe.x1) annotation (Line(points={{-158,-50},{-130,
          -50},{-130,-122},{-62,-122}},     color={0,0,127}));
  connect(concooSpe_min.y, linCooFanSpe.f1) annotation (Line(points={{-158,-90},
          {-140,-90},{-140,-126},{-62,-126}},  color={0,0,127}));
  connect(mulDeaSpe.y, swiFanPro.u3) annotation (Line(points={{122,10},{150,10},
          {150,32},{158,32}}, color={0,0,127}));
  connect(booToRea.y, mulDeaSpe.u1) annotation (Line(points={{62,80},{90,80},{90,
          16},{98,16}}, color={0,0,127}));
  connect(conDeaFanSpe.y, mulDeaSpe.u2) annotation (Line(points={{-38,-30},{80,-30},
          {80,4},{98,4}}, color={0,0,127}));
  connect(conDeaFanSpe.y, gai.u) annotation (Line(points={{-38,-30},{-20,-30},{-20,
          -60},{-2,-60}}, color={0,0,127}));
  connect(gai.y, swiDeaCoo.u3) annotation (Line(points={{22,-60},{50,-60},{50,-168},
          {58,-168}}, color={0,0,127}));
  connect(con.y, swiDeaCoo.u2) annotation (Line(points={{-38,-180},{-20,-180},{-20,
          -160},{58,-160}}, color={255,0,255}));
  connect(conDeaFanSpe.y, gai1.u) annotation (Line(points={{-38,-30},{-20,-30},{
          -20,-100},{-2,-100}}, color={0,0,127}));
  connect(gai1.y, swiDeaCoo.u1) annotation (Line(points={{22,-100},{40,-100},{40,
          -152},{58,-152}}, color={0,0,127}));
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
        extent={{-200,-200},{200,200}})),
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
