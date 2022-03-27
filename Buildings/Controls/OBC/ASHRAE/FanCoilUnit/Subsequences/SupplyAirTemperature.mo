within Buildings.Controls.OBC.ASHRAE.FanCoilUnit.Subsequences;
block SupplyAirTemperature
  "Subsequence for calculating supply air temperature setpoint"

  parameter Boolean have_coolingCoil
    "Does the fan coil unit have a cooling coil?";

  parameter Boolean have_heatingCoil
    "Does the fan coil unit have a heating coil?";

  parameter Real heaPerMin(
    final unit="1",
    displayUnit="1") = heaDea
    "Minimum heating loop signal at which supply air temperature is modified"
    annotation(Dialog(group="Heating loop parameters",
      enable = have_heatingCoil));

  parameter Real THeaSupAirHi(
    final unit="K",
    displayUnit="degC") = 273.15 + 32
    "Supply air temperature setpoint at maximum heating loop signal"
    annotation(Dialog(group="Heating loop parameters",
      enable = have_heatingCoil));

  parameter Real heaPerMax(
    final unit="1",
    displayUnit="1") = 0.5
    "Maximum heating loop signal at which supply air temperature is modified"
    annotation(Dialog(group="Heating loop parameters",
      enable = have_heatingCoil));

  parameter Real cooPerMin(
    final unit="1",
    displayUnit="1") = cooDea
    "Minimum cooling loop signal at which supply air temperature is modified"
    annotation(Dialog(group="Cooling loop parameters",
      enable = have_coolingCoil));

  parameter Real TCooSupAirHi(
    final unit="K",
    displayUnit="degC") = 273.15+12.8
    "Supply air temperature setpoint at maximum cooling loop signal"
    annotation(Dialog(group="Cooling loop parameters",
      enable = have_coolingCoil));

  parameter Real cooPerMax(
    final unit="1",
    displayUnit="1") = 0.5
    "Maximum cooling loop signal at which supply air temperature is modified"
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

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeCooCoi=Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Controller type"
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
    "Controller type"
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

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uFan
    "Fan proven on signal"
    annotation (Placement(transformation(extent={{-160,120},{-120,160}}),
      iconTransformation(extent={{-140,80},{-100,120}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uHea(
    final unit="1",
    displayUnit="1") if have_heatingCoil
    "Heating loop signal"
    annotation (Placement(transformation(extent={{-160,20},{-120,60}}),
      iconTransformation(extent={{-140,0},{-100,40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCoo(
    final unit="1",
    displayUnit="1") if have_coolingCoil
    "Cooling loop signal"
    annotation (Placement(transformation(extent={{-160,-60},{-120,-20}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TAirSup(
    final unit="K",
    displayUnit="K",
    quantity="ThermodynamicTemperature")
    "Measured supply air temperature"
    annotation (Placement(transformation(extent={{-160,-20},{-120,20}}),
      iconTransformation(extent={{-140,-40},{-100,0}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZonSetHea(
    final unit="K",
    displayUnit="K",
    quantity="ThermodynamicTemperature") if have_heatingCoil
    "Zone heating temperature setpoint"
    annotation (Placement(transformation(extent={{-160,60},{-120,100}}),
      iconTransformation(extent={{-140,40},{-100,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZonSetCoo(
    final unit="K",
    displayUnit="K",
    quantity="ThermodynamicTemperature") if have_coolingCoil
    "Zone cooling temperature setpoint"
    annotation (Placement(transformation(extent={{-160,-120},{-120,-80}}),
      iconTransformation(extent={{-140,-120},{-100,-80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yHeaCoi(
    final unit="1",
    displayUnit="1") if have_heatingCoil
    "Heating coil signal"
    annotation (Placement(transformation(extent={{120,40},{160,80}}),
      iconTransformation(extent={{100,40},{140,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yCooCoi(
    final unit="1",
    displayUnit="1") if have_coolingCoil
    "Cooling coil signal"
    annotation (Placement(transformation(extent={{120,-80},{160,-40}}),
      iconTransformation(extent={{100,-80},{140,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TAirSupSet(
    final unit="K",
    displayUnit="K",
    quantity="ThermodynamicTemperature")
    "Supply air temperature setpoint"
    annotation (Placement(transformation(extent={{120,-20},{160,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Continuous.Switch swi2
    "Switch for turning on cooling mode from deadband mode"
    annotation (Placement(transformation(extent={{0,-30},{20,-10}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Line lin
    "Convert heating loop signal to supply air temperature setpoint"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));

  Buildings.Controls.OBC.CDL.Continuous.Line lin1
    "Convert cooling loop signal to supply air temperature setpoint"
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con1(
    final k=THeaSupAirHi)
    "Heating supply air temperature setpoint limit signals"
    annotation (Placement(transformation(extent={{-110,90},{-90,110}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con2[2](
    final k={heaPerMin,heaPerMax})
    "Heating loop signal support points"
    annotation (Placement(transformation(extent={{-100,10},{-80,30}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con3(
    final k=TCooSupAirHi)
    "Cooling supply air temperature setpoint limit signals"
    annotation (Placement(transformation(extent={{-100,-30},{-80,-10}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con4[2](
    final k={cooPerMin,cooPerMax})
    "Cooling loop signal support points"
    annotation (Placement(transformation(extent={{-100,-90},{-80,-70}})));

  Buildings.Controls.OBC.CDL.Continuous.PID conPID(
    final controllerType=controllerTypeHeaCoi,
    final k=kHeaCoi,
    final Ti=TiHeaCoi,
    final Td=TdHeaCoi)
    "PID controller for heating coil"
    annotation (Placement(transformation(extent={{20,50},{40,70}})));

  Buildings.Controls.OBC.CDL.Continuous.PID conPID1(
    final controllerType=controllerTypeCooCoi,
    final k=kCooCoi,
    final Ti=TiCooCoi,
    final Td=TdCooCoi,
    final reverseActing=false)
    "PID controller for cooling coil"
    annotation (Placement(transformation(extent={{40,-70},{60,-50}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys(
    final uLow=heaDea - deaHysLim,
    final uHigh=heaDea)
    "Hysteresis for switching between deadband mode and heating mode"
    annotation (Placement(transformation(extent={{-40,90},{-20,110}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con6(
    final k=0) if not have_heatingCoil
    "Constant zero signal"
    annotation (Placement(transformation(extent={{-70,90},{-50,110}})));

  Buildings.Controls.OBC.CDL.Continuous.Switch swi1
    "Switch for turning on heating mode from deadband mode"
    annotation (Placement(transformation(extent={{-20,50},{0,70}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys1(
    final uLow=cooDea - deaHysLim,
    final uHigh=cooDea)
    "Hysteresis for switching on cooling mode from deadband mode"
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con8(
    final k=0) if not have_coolingCoil
    "Constant zero signal"
    annotation (Placement(transformation(extent={{-100,-130},{-80,-110}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea
    "Convert Boolean to Real"
    annotation (Placement(transformation(extent={{0,90},{20,110}})));

  Buildings.Controls.OBC.CDL.Continuous.Multiply mul
    "Output heating coil signal only when heating mode is enabled"
    annotation (Placement(transformation(extent={{60,50},{80,70}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1
    "Convert Boolean to Real"
    annotation (Placement(transformation(extent={{0,-80},{20,-60}})));

  Buildings.Controls.OBC.CDL.Continuous.Multiply mul1
    "Output cooling coil signal only when cooling mode is enabled"
    annotation (Placement(transformation(extent={{60,-110},{80,-90}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea2
    "Boolean to Real conversion"
    annotation (Placement(transformation(extent={{-100,130},{-80,150}})));

  Buildings.Controls.OBC.CDL.Continuous.Multiply mul2
    "Output heating coil signal only when fan is proven on"
    annotation (Placement(transformation(extent={{90,50},{110,70}})));

  Buildings.Controls.OBC.CDL.Continuous.Multiply mul3
    "Output cooling coil signal only when fan is proven on"
    annotation (Placement(transformation(extent={{90,-70},{110,-50}})));

equation
  connect(uHea, lin.u)
    annotation (Line(points={{-140,40},{-102,40},{-102,60},{-62,60}},
                                                  color={0,0,127}));

  connect(con2[1].y, lin.x1) annotation (Line(points={{-78,20},{-66,20},{-66,68},
          {-62,68}}, color={0,0,127}));

  connect(con2[2].y, lin.x2) annotation (Line(points={{-78,20},{-66,20},{-66,56},
          {-62,56}}, color={0,0,127}));

  connect(uCoo, lin1.u)
    annotation (Line(points={{-140,-40},{-102,-40},{-102,-60},{-62,-60}},
                                                    color={0,0,127}));

  connect(con4[1].y, lin1.x1) annotation (Line(points={{-78,-80},{-74,-80},{-74,
          -52},{-62,-52}}, color={0,0,127}));

  connect(con4[2].y, lin1.x2) annotation (Line(points={{-78,-80},{-74,-80},{-74,
          -64},{-62,-64}}, color={0,0,127}));

  connect(TAirSup, conPID.u_m)
    annotation (Line(points={{-140,0},{30,0},{30,48}}, color={0,0,127}));

  connect(TAirSup, conPID1.u_m) annotation (Line(points={{-140,0},{30,0},{30,-78},
          {50,-78},{50,-72}},      color={0,0,127}));

  connect(lin.y, swi1.u1) annotation (Line(points={{-38,60},{-30,60},{-30,68},{-22,
          68}},    color={0,0,127}));

  connect(con6.y, hys.u)
    annotation (Line(points={{-48,100},{-42,100}}, color={0,0,127}));

  connect(con6.y, lin.u) annotation (Line(points={{-48,100},{-46,100},{-46,76},{
          -74,76},{-74,60},{-62,60}},  color={0,0,127}));

  connect(uHea, hys.u) annotation (Line(points={{-140,40},{-74,40},{-74,76},{-46,
          76},{-46,100},{-42,100}},     color={0,0,127}));

  connect(hys.y, swi1.u2) annotation (Line(points={{-18,100},{-10,100},{-10,80},
          {-26,80},{-26,60},{-22,60}},
                                color={255,0,255}));

  connect(con8.y, lin1.u) annotation (Line(points={{-78,-120},{-66,-120},{-66,-60},
          {-62,-60}},                    color={0,0,127}));

  connect(hys1.y, swi2.u2)
    annotation (Line(points={{-18,-20},{-2,-20}},
                                                color={255,0,255}));

  connect(uCoo, hys1.u) annotation (Line(points={{-140,-40},{-66,-40},{-66,-20},
          {-42,-20}}, color={0,0,127}));

  connect(con8.y, hys1.u) annotation (Line(points={{-78,-120},{-66,-120},{-66,-20},
          {-42,-20}},                    color={0,0,127}));

  connect(swi1.y, swi2.u3) annotation (Line(points={{2,60},{8,60},{8,40},{-10,40},
          {-10,-28},{-2,-28}},    color={0,0,127}));

  connect(lin1.y, swi2.u1) annotation (Line(points={{-38,-60},{-14,-60},{-14,-12},
          {-2,-12}},
                 color={0,0,127}));

  connect(swi2.y, conPID.u_s) annotation (Line(points={{22,-20},{36,-20},{36,40},
          {12,40},{12,60},{18,60}}, color={0,0,127}));

  connect(swi2.y, conPID1.u_s) annotation (Line(points={{22,-20},{36,-20},{36,-60},
          {38,-60}}, color={0,0,127}));

  connect(con1.y, lin.f2) annotation (Line(points={{-88,100},{-80,100},{-80,52},
          {-62,52}}, color={0,0,127}));

  connect(con3.y, lin1.f2) annotation (Line(points={{-78,-20},{-70,-20},{-70,-68},
          {-62,-68}}, color={0,0,127}));

  connect(TZonSetHea, lin.f1) annotation (Line(points={{-140,80},{-76,80},{-76,64},
          {-62,64}}, color={0,0,127}));

  connect(TZonSetCoo, lin1.f1) annotation (Line(points={{-140,-100},{-72,-100},{
          -72,-56},{-62,-56}}, color={0,0,127}));

  connect(TAirSup, swi1.u3) annotation (Line(points={{-140,0},{-30,0},{-30,52},{
          -22,52}},color={0,0,127}));

  connect(con6.y, lin.f1) annotation (Line(points={{-48,100},{-46,100},{-46,76},
          {-74,76},{-74,64},{-62,64}}, color={0,0,127}));

  connect(con8.y, lin1.f1) annotation (Line(points={{-78,-120},{-66,-120},{-66,-56},
          {-62,-56}},                     color={0,0,127}));

  connect(hys.y, booToRea.u)
    annotation (Line(points={{-18,100},{-2,100}},
                                                color={255,0,255}));

  connect(conPID.y, mul.u2) annotation (Line(points={{42,60},{48,60},{48,54},{58,
          54}},    color={0,0,127}));

  connect(booToRea.y, mul.u1) annotation (Line(points={{22,100},{48,100},{48,66},
          {58,66}}, color={0,0,127}));

  connect(hys1.y, booToRea1.u) annotation (Line(points={{-18,-20},{-6,-20},{-6,-70},
          {-2,-70}},      color={255,0,255}));

  connect(booToRea1.y, mul1.u2) annotation (Line(points={{22,-70},{26,-70},{26,-106},
          {58,-106}},       color={0,0,127}));

  connect(conPID1.y, mul1.u1) annotation (Line(points={{62,-60},{64,-60},{64,-86},
          {48,-86},{48,-94},{58,-94}},      color={0,0,127}));

  connect(swi2.y, TAirSupSet) annotation (Line(points={{22,-20},{36,-20},{36,0},
          {140,0}}, color={0,0,127}));

  connect(uFan, booToRea2.u)
    annotation (Line(points={{-140,140},{-102,140}}, color={255,0,255}));
  connect(yHeaCoi, mul2.y)
    annotation (Line(points={{140,60},{112,60}}, color={0,0,127}));
  connect(mul.y, mul2.u2) annotation (Line(points={{82,60},{84,60},{84,54},{88,54}},
        color={0,0,127}));
  connect(booToRea2.y, mul2.u1) annotation (Line(points={{-78,140},{86,140},{86,
          66},{88,66}}, color={0,0,127}));
  connect(mul3.y, yCooCoi) annotation (Line(points={{112,-60},{124,-60},{124,-60},
          {140,-60}}, color={0,0,127}));
  connect(mul1.y, mul3.u2) annotation (Line(points={{82,-100},{84,-100},{84,-66},
          {88,-66}}, color={0,0,127}));
  connect(booToRea2.y, mul3.u1) annotation (Line(points={{-78,140},{86,140},{86,
          -54},{88,-54}}, color={0,0,127}));
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
          textColor={0,0,255})}),         Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-120,-160},{120,160}})),
  Documentation(info="<html>
    <p>
    Block that outputs the supply air temperature setpoint, as well as the control
    signals for the cooling and heating coils in a fan coil unit system. The implemented 
    sequence is based on ASHRAE Guideline 36, 2021, Part 5.22.4.
    </p>
    <p>
    The supply air temperature <code>TAirSupSet</code> is varied from the zone cooling setpoint temperature
    <code>TZonSetCoo</code> to the minimum supply air temperature for cooling<code>TCooSupAirHi</code>,
    when the cooling loop signal <code>uCoo</code> varies from the minimum limit
    <code>cooPerMin</code> to the maximum limit <code>cooPerMax</code>.
    Similarly,<code>TAirSupSet</code> is varied from the zone heating setpoint temperature
    <code>TZonSetHea</code> to the maximum supply air temperature for heating<code>THeaSupAirHi</code>,
    when the heating loop signal <code>uHea</code> varies from the minimum limit
    <code>heaPerMin</code> to the maximum limit <code>heaPerMax</code>.
    The setpoint in deadband mode is equal to the current measured supply air
    temperature <code>TAirSup</code>. <code>uCoo</code> and <code>uHea</code> are
    set to zero when the fan proven on signal <code>uFan</code> is <code>false</code>.
    </p>
    <p align=\"center\">
    <img alt=\"Supply air temperature setpoint control logic diagram\"
    src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/FanCoilUnit/Subsequences/SupplyAirTemperature.png\"/>
    </p>
    </html>", revisions="<html>
    <ul>
    <li>
    March 17, 2022, by Karthik Devaprasad:<br/>
    First implementation.
    </li>
    </ul>
    </html>"));
end SupplyAirTemperature;
