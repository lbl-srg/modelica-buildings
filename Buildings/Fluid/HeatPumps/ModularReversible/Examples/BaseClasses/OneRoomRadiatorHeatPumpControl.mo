within Buildings.Fluid.HeatPumps.ModularReversible.Examples.BaseClasses;
model OneRoomRadiatorHeatPumpControl
  "Helper model for the control of the system"
  extends Modelica.Blocks.Icons.Block;
  parameter Boolean witCoo=true
    "=true to simulate cooling behaviour";
  parameter Modelica.Units.SI.Temperature TRooSetHea=293.15
    "Room set temperature for heating";
  parameter Modelica.Units.SI.Temperature TRooSetCoo=296.15
    "Room set temperature for heating";
  parameter Modelica.Units.SI.Temperature TRadMinSup=296.15
    "Minimal radiator supply temperature to avoid condensation effects";
  parameter Modelica.Units.SI.TemperatureDifference dTHysRoo=1
    "Room set temperature for heating";
  Modelica.Blocks.Logical.Hysteresis hysHea(
    final uLow=TRooSetHea - dTHysRoo,
    final uHigh=TRooSetHea + dTHysRoo,
    final pre_y_start=false)
    "Hysteresis controller for heating" annotation (Placement(transformation(
          extent={{-10,-10},{10,10}}, origin={-70,20})));
  Modelica.Blocks.Logical.Hysteresis hysCoo(
    final uLow=TRooSetCoo - dTHysRoo,
    final uHigh=TRooSetCoo + dTHysRoo,
    final pre_y_start=false)
    if witCoo
    "Hysteresis controller for cooling" annotation (Placement(transformation(
          extent={{-10,-10},{10,10}}, origin={-70,-10})));
  Modelica.Blocks.Sources.BooleanConstant conFal(final k=false)
                                                          if not witCoo
    "No cooling if witCoo=false"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Modelica.Blocks.Logical.Not heaIsOn
    "If lower than hysteresis, heating demand" annotation (Placement(
        transformation(extent={{-10,-10},{10,10}}, origin={-36,20})));
  Modelica.Blocks.Logical.Switch swiHeaCooYSet
    "Switch ySet for heating and cooling" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        origin={40,70},
        rotation=0)));
  Modelica.Blocks.Continuous.LimPID PIDCoo(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=0.03,
    Ti=400,
    yMax=1,
    yMin=0.3) "PI control for cooling, inverse"
    annotation (Placement(transformation(extent={{0,40},{20,60}})));
  Modelica.Blocks.Continuous.LimPID PIDHea(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=0.03,
    Ti=400,
    yMax=1,
    yMin=0.3) "PI control for heating"
    annotation (Placement(transformation(extent={{-4,70},{16,90}})));
  Modelica.Blocks.Sources.Constant constTSetRooHea(final k=TRooSetHea)
    "Room set point temperature for heating"
    annotation (Placement(transformation(extent={{-44,70},{-24,90}})));
  Modelica.Blocks.Sources.Constant constTSetRooCoo(final k=TRooSetCoo)
    "Room set point temperature for cooling"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Modelica.Blocks.Sources.Constant constYSetZer(final k=0) "ySet equals zero"
    annotation (Placement(transformation(extent={{0,-80},{20,-60}})));
  Modelica.Blocks.Logical.Switch swiYSet "If no demand, switch heat pump off"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={70,40})));
  Modelica.Blocks.Logical.Switch swiSecForCoo
    "If in cooling mode, heat pump can't operate below condensing temperature of 15 °C"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={82,10})));
  Modelica.Blocks.Logical.Hysteresis hysSecCoo(
    final uLow=TRadMinSup,
    final uHigh=TRadMinSup + 1,
    final pre_y_start=false)
            if witCoo
    "Hysteresis for avoiding temperatures below 15 °C when cooling"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        origin={-70,-60},
        rotation=0)));
  Modelica.Blocks.Sources.BooleanConstant conTru(final k=true)
                                                         if not witCoo
    "No cooling if witCoo=false, then no safety is necessary" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-42,-80})));
  Modelica.Blocks.Interfaces.RealInput TRooMea(unit="K", displayUnit="degC")
                                               "Room measurement temperature"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealInput TRadSup(displayUnit="degC", unit="K")
                                               "Radiator supply temperature"
    annotation (Placement(transformation(extent={{-140,-90},{-100,-50}})));
  Modelica.Blocks.Interfaces.RealOutput ySet "Heat pump set speed"
    annotation (Placement(transformation(extent={{100,30},{120,50}})));
  Modelica.Blocks.Interfaces.BooleanOutput hea if witCoo
    "Heat pump in normal mode"
    annotation (Placement(transformation(extent={{100,-70},{120,-50}})));
  Modelica.Blocks.Logical.Or heaOrCooIsOn "Heating or cooling is on"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}}, origin={10,10})));

  Modelica.Blocks.Logical.Or cooValOrHea
    "Cooling safety control is used only when the device is not heating" annotation (
      Placement(transformation(extent={{-10,-10},{10,10}}, origin={10,-40})));
equation
  connect(hysHea.y, heaIsOn.u)
    annotation (Line(points={{-59,20},{-48,20}}, color={255,0,255}));
  connect(swiHeaCooYSet.u2, hysCoo.y)
    annotation (Line(points={{28,70},{28,-10},{-59,-10}}, color={255,0,255}));
  connect(swiYSet.u2, heaOrCooIsOn.y) annotation (Line(points={{58,40},{24,40},{
          24,10},{21,10}}, color={255,0,255}));
  connect(heaIsOn.y, heaOrCooIsOn.u1) annotation (Line(points={{-25,20},{-2,20},
          {-2,10}},           color={255,0,255}));
  connect(PIDHea.u_s,constTSetRooHea. y)
    annotation (Line(points={{-6,80},{-23,80}},   color={0,0,127}));
  connect(PIDHea.y, swiHeaCooYSet.u3) annotation (Line(points={{17,80},{18,80},{
          18,78},{28,78}},  color={0,0,127}));
  connect(constTSetRooCoo.y,PIDCoo. u_m) annotation (Line(points={{-39,50},{-14,
          50},{-14,32},{10,32},{10,38}},     color={0,0,127}));
  connect(swiSecForCoo.u3, constYSetZer.y) annotation (Line(points={{70,2},{50,2},
          {50,-70},{21,-70}},    color={0,0,127}));
  connect(constYSetZer.y, swiYSet.u3) annotation (Line(points={{21,-70},{50,-70},
          {50,32},{58,32}}, color={0,0,127}));
  connect(hysCoo.u, TRooMea) annotation (Line(points={{-82,-10},{-88,-10},{-88,0},
          {-120,0}},           color={0,0,127}));
  connect(TRooMea, hysHea.u) annotation (Line(points={{-120,0},{-88,0},{-88,20},
          {-82,20}},                                   color={0,0,127}));
  connect(swiSecForCoo.y, ySet) annotation (Line(points={{93,10},{96,10},{96,40},
          {110,40}}, color={0,0,127}));
  connect(hysSecCoo.u, TRadSup)
    annotation (Line(points={{-82,-60},{-92,-60},{-92,-70},{-120,-70}},
                                                    color={0,0,127}));
  connect(swiYSet.y, swiSecForCoo.u1) annotation (Line(points={{81,40},{86,40},{
          86,26},{58,26},{58,18},{70,18}}, color={0,0,127}));
  connect(PIDCoo.u_s, TRooMea) annotation (Line(points={{-2,50},{-6,50},{-6,66},{
          -94,66},{-94,0},{-120,0}},  color={0,0,127}));
  connect(PIDHea.u_m, TRooMea) annotation (Line(points={{6,68},{6,66},{-94,66},{
          -94,0},{-120,0}},  color={0,0,127}));
  connect(PIDCoo.y, swiHeaCooYSet.u1) annotation (Line(points={{21,50},{21,54},
          {28,54},{28,62}}, color={0,0,127}));
  connect(swiHeaCooYSet.y, swiYSet.u1) annotation (Line(points={{51,70},{56,70},
          {56,52},{54,52},{54,48},{58,48}}, color={0,0,127}));
  connect(heaOrCooIsOn.u2, conFal.y) annotation (Line(points={{-2,2},{-28,2},{-28,
          -30},{-39,-30}}, color={255,0,255}));
  connect(hysCoo.y, heaOrCooIsOn.u2) annotation (Line(points={{-59,-10},{-28,-10},
          {-28,2},{-2,2}}, color={255,0,255}));
  connect(heaIsOn.y, hea) annotation (Line(points={{-25,20},{-16,20},{-16,-30},
          {80,-30},{80,-60},{110,-60}}, color={255,0,255}));
  connect(cooValOrHea.y, swiSecForCoo.u2) annotation (Line(points={{21,-40},{36,
          -40},{36,10},{70,10}}, color={255,0,255}));
  connect(cooValOrHea.u2, conTru.y) annotation (Line(points={{-2,-48},{-16,-48},{
          -16,-80},{-31,-80}},            color={255,0,255}));
  connect(cooValOrHea.u2, hysSecCoo.y) annotation (Line(points={{-2,-48},{-16,-48},
          {-16,-60},{-59,-60}},      color={255,0,255}));
  connect(heaIsOn.y, cooValOrHea.u1) annotation (Line(points={{-25,20},{-16,20},
          {-16,-40},{-2,-40}}, color={255,0,255}));
  connect(conFal.y, swiHeaCooYSet.u2) annotation (Line(points={{-39,-30},{-28,-30},
          {-28,-10},{28,-10},{28,70}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),                      Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
  Helper control model for the example
  <a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible.Examples.BaseClasses.PartialOneRoomRadiator\">
  Buildings.Fluid.HeatPumps.ModularReversible.Examples.BaseClasses.PartialOneRoomRadiator</a>
  The control enables a PI control of the heat pumps compressor
  speed for both heating and cooling. Depending on a hysteresis,
  the heating or cooling mode is selected.
  If the radiator supply temperature drops below a critical
  value, the heat pump will turn to heating mode. This prohibits
  possible freezing or water condensation.
</p>
</html>", revisions="<html>
<ul>
<li>
  <i>October 2, 2022</i> by Fabian Wuellhorst:<br/>
  First implementation (see issue <a href=
  \"https://github.com/ibpsa/modelica-ibpsa/issues/1576\">#1576</a>)
</li>
</ul>
</html>"));
end OneRoomRadiatorHeatPumpControl;
