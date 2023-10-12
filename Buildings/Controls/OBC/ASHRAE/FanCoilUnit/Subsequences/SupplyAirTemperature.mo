within Buildings.Controls.OBC.ASHRAE.FanCoilUnit.Subsequences;
block SupplyAirTemperature
  "Subsequence for calculating supply air temperature setpoint"

  parameter Boolean have_cooCoi
    "Does the fan coil unit have a cooling coil? True: Yes, False: No";

  parameter Boolean have_heaCoi
    "Does the fan coil unit have a heating coil? True: Yes, False: No";

  parameter Real uHea_min(
    final unit="1",
    displayUnit="1") = heaDea
    "Minimum heating loop signal at which supply air temperature is modified"
    annotation(Dialog(group="Heating loop",
      enable = have_heaCoi));

  parameter Real TSupSet_max(
    final unit="K",
    displayUnit="degC") = 273.15 + 32
    "Supply air temperature setpoint at maximum heating loop signal"
    annotation(Dialog(group="Heating loop",
      enable = have_heaCoi));

  parameter Real uHea_max(
    final unit="1",
    displayUnit="1") = 0.5
    "Maximum heating loop signal at which supply air temperature is modified"
    annotation(Dialog(group="Heating loop",
      enable = have_heaCoi));

  parameter Real uCoo_min(
    final unit="1",
    displayUnit="1") = cooDea
    "Minimum cooling loop signal at which supply air temperature is modified"
    annotation(Dialog(group="Cooling loop",
      enable = have_cooCoi));

  parameter Real TSupSet_min(
    final unit="K",
    displayUnit="degC") = 273.15+12.8
    "Supply air temperature setpoint at maximum cooling loop signal"
    annotation(Dialog(group="Cooling loop",
      enable = have_cooCoi));

  parameter Real uCoo_max(
    final unit="1",
    displayUnit="1") = 0.5
    "Maximum cooling loop signal at which supply air temperature is modified"
    annotation(Dialog(group="Cooling loop",
      enable = have_cooCoi));

  parameter Real heaDea(
    final unit="1",
    displayUnit="1") = 0.05
    "Heating loop signal limit above which setpoint operation changes from deadband mode to heating mode"
    annotation(Dialog(group="Deadband",
      enable = have_heaCoi));

  parameter Real cooDea(
    final unit="1",
    displayUnit="1") = 0.05
    "Cooling loop signal limit above which setpoint operation changes from deadband mode to cooling mode"
    annotation(Dialog(group="Deadband",
      enable = have_cooCoi));

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeCooCoi=Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of cooling coil controller"
    annotation(Dialog(tab="PID controller parameters", group="Cooling coil"));

  parameter Real kCooCoi(
    final unit="1",
    displayUnit="1")=1
    "Controller gain"
    annotation(Dialog(tab="PID controller parameters", group="Cooling coil"));

  parameter Real TiCooCoi(
    final unit="s",
    displayUnit="s",
    final quantity="time")=0.5
    "Integrator time constant"
    annotation(Dialog(tab="PID controller parameters", group="Cooling coil",
      enable = controllerTypeCooCoi == Buildings.Controls.OBC.CDL.Types.SimpleController.PI or
      controllerTypeCooCoi == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Real TdCooCoi(
    final unit="s",
    displayUnit="s",
    final quantity="time")=0.1
    "Derivative block time constant"
    annotation(Dialog(tab="PID controller parameters", group="Cooling coil",
      enable = controllerTypeCooCoi == Buildings.Controls.OBC.CDL.Types.SimpleController.PD or
      controllerTypeCooCoi == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeHeaCoi=Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of heating coil controller"
    annotation(Dialog(tab="PID controller parameters", group="Heating coil"));

  parameter Real kHeaCoi(
    final unit="1",
    displayUnit="1")=1
    "Controller gain"
    annotation(Dialog(tab="PID controller parameters", group="Heating coil"));

  parameter Real TiHeaCoi(
    final unit="s",
    displayUnit="s",
    final quantity="time")=0.5
    "Integrator block time constant"
    annotation(Dialog(tab="PID controller parameters", group="Heating coil",
      enable = controllerTypeHeaCoi == Buildings.Controls.OBC.CDL.Types.SimpleController.PI or
      controllerTypeHeaCoi == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Real TdHeaCoi(
    final unit="s",
    displayUnit="s",
    final quantity="time")=0.1
    "Derivative block time constant"
    annotation(Dialog(tab="PID controller parameters", group="Heating coil",
      enable = controllerTypeHeaCoi == Buildings.Controls.OBC.CDL.Types.SimpleController.PD or
      controllerTypeHeaCoi == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Real deaHysLim(
    final unit="1",
    displayUnit="1") = 0.01
    "Hysteresis limits for deadband mode transitions"
    annotation(Dialog(tab="Advanced"));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Fan
    "Fan proven on signal"
    annotation (Placement(transformation(extent={{-160,120},{-120,160}}),
      iconTransformation(extent={{-140,80},{-100,120}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uHea(
    final unit="1",
    displayUnit="1") if have_heaCoi
    "Heating loop signal"
    annotation (Placement(transformation(extent={{-160,20},{-120,60}}),
      iconTransformation(extent={{-140,0},{-100,40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCoo(
    final unit="1",
    displayUnit="1") if have_cooCoi
    "Cooling loop signal"
    annotation (Placement(transformation(extent={{-160,-60},{-120,-20}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TAirSup(
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature")
    "Measured supply air temperature"
    annotation (Placement(transformation(extent={{-160,-20},{-120,20}}),
      iconTransformation(extent={{-140,-40},{-100,0}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZonHeaSet(
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature") if have_heaCoi
    "Zone heating temperature setpoint"
    annotation (Placement(transformation(extent={{-160,60},{-120,100}}),
      iconTransformation(extent={{-140,40},{-100,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZonCooSet(
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature") if have_cooCoi
    "Zone cooling temperature setpoint"
    annotation (Placement(transformation(extent={{-160,-140},{-120,-100}}),
      iconTransformation(extent={{-140,-120},{-100,-80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yHeaCoi(
    final unit="1",
    displayUnit="1") if have_heaCoi
    "Heating coil signal"
    annotation (Placement(transformation(extent={{120,40},{160,80}}),
      iconTransformation(extent={{100,40},{140,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yCooCoi(
    final unit="1",
    displayUnit="1") if have_cooCoi
    "Cooling coil signal"
    annotation (Placement(transformation(extent={{120,-80},{160,-40}}),
      iconTransformation(extent={{100,-80},{140,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TSupSet(
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature")
    "Supply air temperature setpoint"
    annotation (Placement(transformation(extent={{120,-20},{160,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Switch swiDeaCoo
    "Switch for turning on cooling mode from deadband mode"
    annotation (Placement(transformation(extent={{0,-30},{20,-10}})));

  Buildings.Controls.OBC.CDL.Continuous.Switch swiCooCoi
    "Switch cooling coil signal to zero in deadband mode"
    annotation (Placement(transformation(extent={{70,-110},{90,-90}})));

  Buildings.Controls.OBC.CDL.Continuous.Switch swiHeaCoi
    "Switch heating coil signal to zero in deadband mode"
    annotation (Placement(transformation(extent={{50,80},{70,100}})));

  Buildings.Controls.OBC.CDL.Continuous.Line linTHeaSupAir
    "Convert heating loop signal to supply air temperature setpoint"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));

  Buildings.Controls.OBC.CDL.Continuous.Line linTCooSupAir
    "Convert cooling loop signal to supply air temperature setpoint"
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conTSupSet_max(
    final k=TSupSet_max)
    "Maximum heating supply air temperature setpoint limit signal"
    annotation (Placement(transformation(extent={{-110,90},{-90,110}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conUHea_min(
    final k=uHea_min)
    "Minimum heating loop signal support point"
    annotation (Placement(transformation(extent={{-110,10},{-90,30}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conTSupSet_min(
    final k=TSupSet_min)
    "Minimum cooling supply air temperature setpoint limit signal"
    annotation (Placement(transformation(extent={{-110,-30},{-90,-10}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conUCoo_min(
    final k=uCoo_min)
    "Minimum cooling loop signal support point"
    annotation (Placement(transformation(extent={{-110,-70},{-90,-50}})));

  Buildings.Controls.OBC.CDL.Continuous.PID conPIDHea(
    final controllerType=controllerTypeHeaCoi,
    final k=kHeaCoi,
    final Ti=TiHeaCoi,
    final Td=TdHeaCoi) "PID controller for heating coil"
    annotation (Placement(transformation(extent={{20,50},{40,70}})));

  Buildings.Controls.OBC.CDL.Continuous.PID conPIDCoo(
    final controllerType=controllerTypeCooCoi,
    final k=kCooCoi,
    final Ti=TiCooCoi,
    final Td=TdCooCoi,
    final reverseActing=false) "PID controller for cooling coil"
    annotation (Placement(transformation(extent={{40,-70},{60,-50}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hysDeaHea(
    final uLow=heaDea-deaHysLim,
    final uHigh=heaDea)
    "Hysteresis for switching between deadband mode and heating mode"
    annotation (Placement(transformation(extent={{-40,90},{-20,110}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conZerHeaMod(
    final k=0) if not have_heaCoi
    "Constant zero signal for heating mode"
    annotation (Placement(transformation(extent={{-70,90},{-50,110}})));

  Buildings.Controls.OBC.CDL.Continuous.Switch swiDeaHea
    "Switch for turning on heating mode from deadband mode"
    annotation (Placement(transformation(extent={{-20,50},{0,70}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hysDeaCoo(
    final uLow=cooDea-deaHysLim,
    final uHigh=cooDea)
    "Hysteresis for switching on cooling mode from deadband mode"
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conZerCooMod(
    final k=0) if not have_cooCoi
    "Constant zero signal for cooling mode"
    annotation (Placement(transformation(extent={{-100,-150},{-80,-130}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea2
    "Boolean to Real conversion"
    annotation (Placement(transformation(extent={{60,130},{80,150}})));

  Buildings.Controls.OBC.CDL.Continuous.Multiply mul2
    "Output heating coil signal only when fan is proven on"
    annotation (Placement(transformation(extent={{90,50},{110,70}})));

  Buildings.Controls.OBC.CDL.Continuous.Multiply mul3
    "Output cooling coil signal only when fan is proven on"
    annotation (Placement(transformation(extent={{90,-70},{110,-50}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conUHea_max(
    final k=uHea_max)
    "Maximum heating loop signal support point"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conUCoo_max(
    final k=uCoo_max)
    "Maximum cooling loop signal support point"
    annotation (Placement(transformation(extent={{-110,-110},{-90,-90}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conZer(
    final k=0)
    "Constant zero signal"
    annotation (Placement(transformation(extent={{0,10},{20,30}})));

equation
  connect(uHea, linTHeaSupAir.u) annotation (Line(points={{-140,40},{-74,40},{-74,
          60},{-62,60}}, color={0,0,127}));

  connect(uCoo, linTCooSupAir.u) annotation (Line(points={{-140,-40},{-66,-40},{
          -66,-60},{-62,-60}}, color={0,0,127}));

  connect(TAirSup, conPIDHea.u_m)
    annotation (Line(points={{-140,0},{30,0},{30,48}}, color={0,0,127}));

  connect(TAirSup, conPIDCoo.u_m) annotation (Line(points={{-140,0},{30,0},{30,-78},
          {50,-78},{50,-72}}, color={0,0,127}));

  connect(linTHeaSupAir.y, swiDeaHea.u1) annotation (Line(points={{-38,60},{-30,
          60},{-30,68},{-22,68}}, color={0,0,127}));

  connect(conZerHeaMod.y, hysDeaHea.u)
    annotation (Line(points={{-48,100},{-42,100}}, color={0,0,127}));

  connect(conZerHeaMod.y, linTHeaSupAir.u) annotation (Line(points={{-48,100},{-46,
          100},{-46,76},{-74,76},{-74,60},{-62,60}}, color={0,0,127}));

  connect(uHea, hysDeaHea.u) annotation (Line(points={{-140,40},{-74,40},{-74,76},
          {-46,76},{-46,100},{-42,100}}, color={0,0,127}));

  connect(hysDeaHea.y, swiDeaHea.u2) annotation (Line(points={{-18,100},{-10,100},
          {-10,80},{-26,80},{-26,60},{-22,60}}, color={255,0,255}));

  connect(conZerCooMod.y, linTCooSupAir.u) annotation (Line(points={{-78,-140},{
          -66,-140},{-66,-60},{-62,-60}}, color={0,0,127}));

  connect(hysDeaCoo.y, swiDeaCoo.u2)
    annotation (Line(points={{-18,-20},{-2,-20}}, color={255,0,255}));

  connect(uCoo, hysDeaCoo.u) annotation (Line(points={{-140,-40},{-66,-40},{-66,
          -20},{-42,-20}}, color={0,0,127}));

  connect(conZerCooMod.y, hysDeaCoo.u) annotation (Line(points={{-78,-140},{-66,
          -140},{-66,-20},{-42,-20}}, color={0,0,127}));

  connect(swiDeaHea.y, swiDeaCoo.u3) annotation (Line(points={{2,60},{8,60},{8,40},
          {-10,40},{-10,-28},{-2,-28}}, color={0,0,127}));

  connect(linTCooSupAir.y, swiDeaCoo.u1) annotation (Line(points={{-38,-60},{-14,
          -60},{-14,-12},{-2,-12}}, color={0,0,127}));

  connect(swiDeaCoo.y, conPIDHea.u_s) annotation (Line(points={{22,-20},{36,-20},
          {36,40},{12,40},{12,60},{18,60}}, color={0,0,127}));

  connect(swiDeaCoo.y, conPIDCoo.u_s) annotation (Line(points={{22,-20},{36,-20},
          {36,-60},{38,-60}}, color={0,0,127}));

  connect(conTSupSet_max.y, linTHeaSupAir.f2) annotation (Line(points={{-88,100},
          {-80,100},{-80,52},{-62,52}}, color={0,0,127}));

  connect(conTSupSet_min.y, linTCooSupAir.f2) annotation (Line(points={{-88,-20},
          {-70,-20},{-70,-68},{-62,-68}}, color={0,0,127}));

  connect(TZonHeaSet, linTHeaSupAir.f1) annotation (Line(points={{-140,80},{-74,
          80},{-74,64},{-62,64}}, color={0,0,127}));

  connect(TZonCooSet, linTCooSupAir.f1) annotation (Line(points={{-140,-120},{-64,
          -120},{-64,-56},{-62,-56}}, color={0,0,127}));

  connect(TAirSup, swiDeaHea.u3) annotation (Line(points={{-140,0},{-30,0},{-30,
          52},{-22,52}}, color={0,0,127}));

  connect(conZerHeaMod.y, linTHeaSupAir.f1) annotation (Line(points={{-48,100},{
          -46,100},{-46,76},{-74,76},{-74,64},{-62,64}}, color={0,0,127}));

  connect(conZerCooMod.y, linTCooSupAir.f1) annotation (Line(points={{-78,-140},
          {-66,-140},{-66,-56},{-62,-56}}, color={0,0,127}));

  connect(swiDeaCoo.y, TSupSet) annotation (Line(points={{22,-20},{36,-20},{36,0},
          {140,0}}, color={0,0,127}));

  connect(u1Fan, booToRea2.u)
    annotation (Line(points={{-140,140},{58,140}}, color={255,0,255}));
  connect(yHeaCoi, mul2.y)
    annotation (Line(points={{140,60},{112,60}}, color={0,0,127}));
  connect(booToRea2.y, mul2.u1) annotation (Line(points={{82,140},{86,140},{86,66},
          {88,66}},     color={0,0,127}));
  connect(mul3.y, yCooCoi) annotation (Line(points={{112,-60},{124,-60},{124,-60},
          {140,-60}}, color={0,0,127}));
  connect(booToRea2.y, mul3.u1) annotation (Line(points={{82,140},{86,140},{86,-54},
          {88,-54}},      color={0,0,127}));
  connect(conUHea_max.y, linTHeaSupAir.x2) annotation (Line(points={{-58,20},{-52,
          20},{-52,40},{-68,40},{-68,56},{-62,56}}, color={0,0,127}));
  connect(conUHea_min.y, linTHeaSupAir.x1) annotation (Line(points={{-88,20},{-84,
          20},{-84,68},{-62,68}}, color={0,0,127}));
  connect(conUCoo_min.y, linTCooSupAir.x1) annotation (Line(points={{-88,-60},{
          -86,-60},{-86,-52},{-62,-52}}, color={0,0,127}));
  connect(conUCoo_max.y, linTCooSupAir.x2) annotation (Line(points={{-88,-100},
          {-80,-100},{-80,-64},{-62,-64}}, color={0,0,127}));
  connect(conPIDCoo.y, swiCooCoi.u1) annotation (Line(points={{62,-60},{66,-60},
          {66,-92},{68,-92}}, color={0,0,127}));
  connect(swiCooCoi.y, mul3.u2) annotation (Line(points={{92,-100},{100,-100},{100,
          -80},{86,-80},{86,-66},{88,-66}}, color={0,0,127}));
  connect(hysDeaCoo.y, swiCooCoi.u2) annotation (Line(points={{-18,-20},{-6,-20},
          {-6,-100},{68,-100}}, color={255,0,255}));
  connect(swiHeaCoi.y, mul2.u2) annotation (Line(points={{72,90},{80,90},{80,54},
          {88,54}}, color={0,0,127}));
  connect(conPIDHea.y, swiHeaCoi.u1) annotation (Line(points={{42,60},{44,60},{44,
          98},{48,98}}, color={0,0,127}));
  connect(hysDeaHea.y, swiHeaCoi.u2) annotation (Line(points={{-18,100},{-10,100},
          {-10,90},{48,90}}, color={255,0,255}));
  connect(conZer.y, swiHeaCoi.u3) annotation (Line(points={{22,20},{46,20},{46,82},
          {48,82}}, color={0,0,127}));
  connect(conZer.y, swiCooCoi.u3) annotation (Line(points={{22,20},{46,20},{46,-40},
          {64,-40},{64,-108},{68,-108}}, color={0,0,127}));
  annotation (defaultComponentName="TSupAir",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-120},{100,120}}),
                                                      graphics={
        Rectangle(
        extent={{-100,-120},{100,120}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-110,160},{110,120}},
          textString="%name",
          textColor={0,0,255}),
        Text(
          extent={{-96,110},{-50,90}},
          textColor={255,0,255},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="u1Fan"),
        Text(
          extent={{-96,70},{-20,48}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TZonHeaSet",
          visible=have_heaCoi),
        Text(
          extent={{-100,30},{-52,10}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="uHea",
          visible=have_heaCoi),
        Text(
          extent={{-96,-10},{-46,-28}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TAirSup"),
        Text(
          extent={{-100,-50},{-52,-70}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="uCoo",
          visible=have_cooCoi),
        Text(
          extent={{38,70},{96,50}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yHeaCoi",
          visible=have_heaCoi),
        Text(
          extent={{-96,-90},{-20,-112}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TZonCooSet",
          visible=have_cooCoi),
        Text(
          extent={{20,12},{96,-10}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TSupSet"),
        Text(
          extent={{38,-50},{96,-70}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yCooCoi",
          visible=have_cooCoi)}),        Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-120,-160},{120,160}})),
  Documentation(info="<html>
<p>Block that outputs the supply air temperature setpoint, as well as the control signals for the cooling and heating coils in a fan coil unit system. 
The implemented sequence is based on ASHRAE Guideline 36, 2021, Part 5.22.4. </p>
<p>The supply air temperature 
<span style=\"font-family: Courier New;\">TSupSet</span> is varied from the zone cooling setpoint temperature 
<span style=\"font-family: Courier New;\">TZonCooSet</span> to the minimum supply air temperature for cooling 
<span style=\"font-family: Courier New;\">TSupSet_min</span>, when the cooling loop signal 
<span style=\"font-family: Courier New;\">uCoo</span> varies from the minimum limit 
<span style=\"font-family: Courier New;\">uCoo_min</span> to the maximum limit 
<span style=\"font-family: Courier New;\">uCoo_max</span>. 
Similarly, <span style=\"font-family: Courier New;\">TSupSet</span> is varied from the zone heating setpoint temperature 
<span style=\"font-family: Courier New;\">TZonHeaSet</span> to the maximum supply air temperature for heating 
<span style=\"font-family: Courier New;\">TSupSet_max</span>, when the heating loop signal 
<span style=\"font-family: Courier New;\">uHea</span> varies from the minimum limit 
<span style=\"font-family: Courier New;\">uHea_min</span> to the maximum limit 
<span style=\"font-family: Courier New;\">uHea_max</span>. The setpoint in deadband mode is equal to the current measured supply air temperature 
<span style=\"font-family: Courier New;\">TAirSup</span>. 
<span style=\"font-family: Courier New;\">yCooCoi</span> and <span style=\"font-family: Courier New;\">yHeaCoi</span> are set to zero when the fan proven on signal 
<span style=\"font-family: Courier New;\">uFan</span> is <span style=\"font-family: Courier New;\">false</span>. </p>
<p align=\"center\"><img src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/FanCoilUnit/Subsequences/SupplyAirTemperature.png\" alt=\"Supply air temperature setpoint control logic diagram\"/> </p>
</html>",     revisions="<html>
    <ul>
    <li>
    March 17, 2022, by Karthik Devaprasad:<br/>
    First implementation.
    </li>
    </ul>
    </html>"));
end SupplyAirTemperature;
