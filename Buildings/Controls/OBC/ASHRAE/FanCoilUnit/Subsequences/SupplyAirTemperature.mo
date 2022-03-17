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

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uHea if have_heatingCoil
    "Heating loop signal"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}),
        iconTransformation(extent={{-140,20},{-100,60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCoo if have_coolingCoil
    "Cooling loop signal"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TAirSup
    "Measured supply air temperature"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZonSetHea if
                                   have_heatingCoil
    "Zone heating temperature setpoint" annotation (Placement(transformation(
          extent={{-140,60},{-100,100}}), iconTransformation(extent={{-140,60},{
            -100,100}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZonSetCoo if
                                   have_coolingCoil
    "Zone cooling temperature setpoint" annotation (Placement(transformation(
          extent={{-140,-120},{-100,-80}}), iconTransformation(extent={{-140,-100},
            {-100,-60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yHeaCoi if have_heatingCoil
    "Heating coil signal"
    annotation (Placement(transformation(extent={{100,40},{140,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yCooCoi if have_coolingCoil
                                    "Heating coil signal"
    annotation (Placement(transformation(extent={{100,-80},{140,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TAirSupSet
    "Supply air temperature setpoint"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Continuous.Line lin
    "Convert heating loop signal to supply air temperature setpoint"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));

  Buildings.Controls.OBC.CDL.Continuous.Line lin1
    "Convert cooling loop signal to supply air temperature setpoint"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con1(k=THeaSupAirHi)
    "Heating supply air temperature setpoint limit signals"
    annotation (Placement(transformation(extent={{-90,90},{-70,110}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con2
                                     [2](k={heaPerMin,heaPerMax})
    "Heating loop signal support points"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con3(k=TCooSupAirHi)
    "Cooling supply air temperature setpoint limit signals"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con4[2](k={cooPerMin,cooPerMax})
    "Cooling loop signal support points"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));

  Buildings.Controls.OBC.CDL.Continuous.PID conPID(
    controllerType=controllerTypeHeaCoi,
    k=kHeaCoi,
    Ti=TiHeaCoi,
    Td=TdHeaCoi)
    annotation (Placement(transformation(extent={{40,50},{60,70}})));

  Buildings.Controls.OBC.CDL.Continuous.PID conPID1(
    controllerType=controllerTypeCooCoi,
    k=kCooCoi,
    Ti=TiCooCoi,
    Td=TdCooCoi,             reverseActing=false)
    annotation (Placement(transformation(extent={{60,-70},{80,-50}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys(uLow=heaDea - deaHysLim, uHigh=heaDea)
    "Hysteresis for switching between deadband mode and heating mode"
    annotation (Placement(transformation(extent={{-20,90},{0,110}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con6(k=0) if not have_heatingCoil
    "Constant zero signal"
    annotation (Placement(transformation(extent={{-50,90},{-30,110}})));

  Buildings.Controls.OBC.CDL.Continuous.Switch swi1
    "Switch for turning on heating mode from deadband mode"
    annotation (Placement(transformation(extent={{0,50},{20,70}})));

  Buildings.Controls.OBC.CDL.Continuous.Switch swi2
    "Switch for turning on cooling mode from deadband mode"
    annotation (Placement(transformation(extent={{20,-30},{40,-10}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys1(uLow=cooDea - deaHysLim, uHigh=cooDea)
    "Hysteresis for switching on cooling mode from deadband mode"
    annotation (Placement(transformation(extent={{-20,-30},{0,-10}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con8(k=0) if not have_coolingCoil
    "Constant zero signal"
    annotation (Placement(transformation(extent={{-20,-110},{0,-90}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea
    "Convert Boolean to Real"
    annotation (Placement(transformation(extent={{20,90},{40,110}})));

  Buildings.Controls.OBC.CDL.Continuous.Multiply mul
    "Output heating coil signal only when heating mode is enabled"
    annotation (Placement(transformation(extent={{74,50},{94,70}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1
    "Convert Boolean to Real"
    annotation (Placement(transformation(extent={{20,-80},{40,-60}})));

  Buildings.Controls.OBC.CDL.Continuous.Multiply mul1
    "Output cooling coil signal only when cooling mode is enabled"
    annotation (Placement(transformation(extent={{74,-112},{94,-92}})));



equation
  connect(uHea, lin.u)
    annotation (Line(points={{-120,40},{-82,40},{-82,60},{-42,60}},
                                                  color={0,0,127}));

  connect(con2[1].y, lin.x1) annotation (Line(points={{-58,20},{-46,20},{-46,68},
          {-42,68}}, color={0,0,127}));

  connect(con2[2].y, lin.x2) annotation (Line(points={{-58,20},{-46,20},{-46,56},
          {-42,56}}, color={0,0,127}));

  connect(uCoo, lin1.u)
    annotation (Line(points={{-120,-40},{-82,-40},{-82,-60},{-42,-60}},
                                                    color={0,0,127}));

  connect(con4[1].y, lin1.x1) annotation (Line(points={{-58,-80},{-54,-80},{-54,
          -52},{-42,-52}}, color={0,0,127}));

  connect(con4[2].y, lin1.x2) annotation (Line(points={{-58,-80},{-54,-80},{-54,
          -64},{-42,-64}}, color={0,0,127}));

  connect(TAirSup, conPID.u_m)
    annotation (Line(points={{-120,0},{50,0},{50,48}}, color={0,0,127}));

  connect(TAirSup, conPID1.u_m) annotation (Line(points={{-120,0},{50,0},{50,
          -78},{70,-78},{70,-72}}, color={0,0,127}));

  connect(lin.y, swi1.u1) annotation (Line(points={{-18,60},{-10,60},{-10,68},{
          -2,68}}, color={0,0,127}));

  connect(con6.y, hys.u)
    annotation (Line(points={{-28,100},{-22,100}}, color={0,0,127}));

  connect(con6.y, lin.u) annotation (Line(points={{-28,100},{-26,100},{-26,76},
          {-54,76},{-54,60},{-42,60}}, color={0,0,127}));

  connect(uHea, hys.u) annotation (Line(points={{-120,40},{-54,40},{-54,76},{-26,
          76},{-26,100},{-22,100}},     color={0,0,127}));

  connect(hys.y, swi1.u2) annotation (Line(points={{2,100},{10,100},{10,80},{-6,
          80},{-6,60},{-2,60}}, color={255,0,255}));

  connect(con8.y, lin1.u) annotation (Line(points={{2,-100},{10,-100},{10,-80},{
          -46,-80},{-46,-60},{-42,-60}}, color={0,0,127}));

  connect(hys1.y, swi2.u2)
    annotation (Line(points={{2,-20},{18,-20}}, color={255,0,255}));

  connect(uCoo, hys1.u) annotation (Line(points={{-120,-40},{-46,-40},{-46,-20},
          {-22,-20}}, color={0,0,127}));

  connect(con8.y, hys1.u) annotation (Line(points={{2,-100},{10,-100},{10,-80},{
          -46,-80},{-46,-20},{-22,-20}}, color={0,0,127}));

  connect(swi1.y, swi2.u3) annotation (Line(points={{22,60},{28,60},{28,40},{10,
          40},{10,-28},{18,-28}}, color={0,0,127}));

  connect(lin1.y, swi2.u1) annotation (Line(points={{-18,-60},{6,-60},{6,-12},{18,
          -12}}, color={0,0,127}));

  connect(swi2.y, conPID.u_s) annotation (Line(points={{42,-20},{56,-20},{56,40},
          {32,40},{32,60},{38,60}}, color={0,0,127}));

  connect(swi2.y, conPID1.u_s) annotation (Line(points={{42,-20},{56,-20},{56,-60},
          {58,-60}}, color={0,0,127}));

  connect(con1.y, lin.f2) annotation (Line(points={{-68,100},{-60,100},{-60,52},
          {-42,52}}, color={0,0,127}));

  connect(con3.y, lin1.f2) annotation (Line(points={{-58,-20},{-50,-20},{-50,-68},
          {-42,-68}}, color={0,0,127}));

  connect(TZonSetHea, lin.f1) annotation (Line(points={{-120,80},{-56,80},{-56,64},
          {-42,64}}, color={0,0,127}));

  connect(TZonSetCoo, lin1.f1) annotation (Line(points={{-120,-100},{-52,-100},{
          -52,-56},{-42,-56}}, color={0,0,127}));

  connect(TAirSup, swi1.u3) annotation (Line(points={{-120,0},{-10,0},{-10,52},{
          -2,52}}, color={0,0,127}));

  connect(con6.y, lin.f1) annotation (Line(points={{-28,100},{-26,100},{-26,76},
          {-54,76},{-54,64},{-42,64}}, color={0,0,127}));

  connect(con8.y, lin1.f1) annotation (Line(points={{2,-100},{10,-100},{10,-80},
          {-46,-80},{-46,-56},{-42,-56}}, color={0,0,127}));

  connect(hys.y, booToRea.u)
    annotation (Line(points={{2,100},{18,100}}, color={255,0,255}));

  connect(yHeaCoi, mul.y)
    annotation (Line(points={{120,60},{96,60}}, color={0,0,127}));

  connect(conPID.y, mul.u2) annotation (Line(points={{62,60},{68,60},{68,54},{
          72,54}}, color={0,0,127}));

  connect(booToRea.y, mul.u1) annotation (Line(points={{42,100},{68,100},{68,66},
          {72,66}}, color={0,0,127}));

  connect(hys1.y, booToRea1.u) annotation (Line(points={{2,-20},{14,-20},{14,
          -70},{18,-70}}, color={255,0,255}));

  connect(booToRea1.y, mul1.u2) annotation (Line(points={{42,-70},{46,-70},{46,
          -108},{72,-108}}, color={0,0,127}));

  connect(conPID1.y, mul1.u1) annotation (Line(points={{82,-60},{84,-60},{84,
          -86},{68,-86},{68,-96},{72,-96}}, color={0,0,127}));

  connect(mul1.y, yCooCoi) annotation (Line(points={{96,-102},{98,-102},{98,-60},
          {120,-60}}, color={0,0,127}));

  connect(swi2.y, TAirSupSet) annotation (Line(points={{42,-20},{56,-20},{56,0},
          {120,0}}, color={0,0,127}));

  annotation (defaultComponentName =
    "TSupAir",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}),                                   graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid)}), Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-120},{100,120}})));

end SupplyAirTemperature;
