within Buildings.Fluid.HeatPumps.ModularReversible.Examples.BaseClasses;
model OneRoomRadiatorHeatPumpControl
  "Helper model for the control of the system"
  parameter Boolean witCoo=true
    "=true to simulate cooling behaviour";
  parameter Modelica.Units.SI.Temperature TRooSetHea=293.15
    "Room set temperature for heating";
  parameter Modelica.Units.SI.Temperature TRooSetCoo=296.15
    "Room set temperature for cooling";
  parameter Modelica.Units.SI.Temperature TRadMinSup=290.15
    "Minimal radiator supply temperature to avoid condensation effects";
  parameter Modelica.Units.SI.TemperatureDifference dTHysRoo=2
    "Temperature hysteresis for room control";
  Modelica.Blocks.Logical.Hysteresis hysHea(
    final uLow=TRooSetHea - dTHysRoo,
    final uHigh=TRooSetHea + dTHysRoo,
    final pre_y_start=false)
    "Hysteresis controller for heating" annotation (Placement(transformation(
          extent={{-10,-10},{10,10}}, origin={-90,20})));
  Modelica.Blocks.Logical.Hysteresis hysCoo(
    final uLow=TRooSetCoo - dTHysRoo,
    final uHigh=TRooSetCoo + dTHysRoo,
    final pre_y_start=false)
    if witCoo
    "Hysteresis controller for cooling" annotation (Placement(transformation(
          extent={{-10,-10},{10,10}}, origin={-90,-10})));
  Modelica.Blocks.Sources.BooleanConstant conFal(final k=false)
                                                          if not witCoo
    "No cooling if witCoo=false"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Modelica.Blocks.Logical.Not heaIsOn
    "If lower than hysteresis, heating demand" annotation (Placement(
        transformation(extent={{-10,-10},{10,10}}, origin={-50,20})));
  Modelica.Blocks.Logical.Switch swiHeaCooYSet if witCoo
    "Switch ySet for heating and cooling" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        origin={30,70},
        rotation=0)));
  Modelica.Blocks.Continuous.LimPID PIDCoo(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=0.01,
    Ti=800,
    yMax=1,
    yMin=0.3,
    I(use_reset=true, reset=booPasThrCoo.y)) if witCoo
              "PI control for cooling, inverse"
    annotation (Placement(transformation(extent={{-20,60},{0,80}})));
  Modelica.Blocks.Continuous.LimPID PIDHea(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=0.01,
    Ti=800,
    yMax=1,
    yMin=0.3,
    I(use_reset=true, reset=hysHea.y))
              "PI control for heating"
    annotation (Placement(transformation(extent={{-60,80},{-40,100}})));
  Modelica.Blocks.Sources.Constant constTSetRooHea(final k=TRooSetHea)
    "Room set point temperature for heating"
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  Modelica.Blocks.Sources.Constant constTSetRooCoo(final k=TRooSetCoo) if witCoo
    "Room set point temperature for cooling"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Modelica.Blocks.Sources.Constant constYSetZer(final k=0) "ySet equals zero"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={30,-18})));
  Modelica.Blocks.Logical.Switch swiYSet "If no demand, switch heat pump off"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={70,50})));
  Modelica.Blocks.Logical.Switch swiSecForCoo
    "If in cooling mode, heat pump can't operate below condensing temperature of 15 °C"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={90,-10})));
  Modelica.Blocks.Logical.Hysteresis hysSecCoo(
    final uLow=TRadMinSup,
    final uHigh=TRadMinSup + 1,
    final pre_y_start=false)
            if witCoo
    "Hysteresis for avoiding temperatures below 15 °C when cooling"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        origin={-90,-70},
        rotation=0)));
  Modelica.Blocks.Sources.BooleanConstant conTru(final k=true)
                                                         if not witCoo
    "No cooling if witCoo=false, then no safety is necessary" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,-100})));
  Modelica.Blocks.Interfaces.RealInput TRooMea(unit="K", displayUnit="degC")
                                               "Room measurement temperature"
    annotation (Placement(transformation(extent={{-160,-20},{-120,20}})));
  Modelica.Blocks.Interfaces.RealInput TRadSup(displayUnit="degC", unit="K")
                                               "Radiator supply temperature"
    annotation (Placement(transformation(extent={{-160,-90},{-120,-50}})));
  Modelica.Blocks.Interfaces.RealOutput ySet "Heat pump set speed"
    annotation (Placement(transformation(extent={{120,30},{140,50}})));
  Modelica.Blocks.Interfaces.BooleanOutput hea if witCoo
    "Heat pump in normal mode"
    annotation (Placement(transformation(extent={{120,-70},{140,-50}})));
  Modelica.Blocks.Logical.Or heaOrCooIsOn "Heating or cooling is on"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}}, origin={-10,10})));

  Modelica.Blocks.Logical.Or cooValOrHea
    "Cooling safety control is used only when the device is not heating" annotation (
      Placement(transformation(extent={{-10,-10},{10,10}}, origin={-10,-90})));
  Modelica.Blocks.Routing.BooleanPassThrough booPasThrCoo "Used for reset of PID"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
equation
  connect(hysHea.y, heaIsOn.u)
    annotation (Line(points={{-79,20},{-62,20}}, color={255,0,255}));
  connect(swiHeaCooYSet.u2, hysCoo.y)
    annotation (Line(points={{18,70},{10,70},{10,-10},{-79,-10}},
                                                          color={255,0,255}));
  connect(swiYSet.u2, heaOrCooIsOn.y) annotation (Line(points={{58,50},{44,50},{44,
          10},{1,10}},     color={255,0,255}));
  connect(heaIsOn.y, heaOrCooIsOn.u1) annotation (Line(points={{-39,20},{-30,20},{
          -30,10},{-22,10}},  color={255,0,255}));
  connect(PIDHea.u_s,constTSetRooHea. y)
    annotation (Line(points={{-62,90},{-79,90}},  color={0,0,127}));
  connect(PIDHea.y, swiHeaCooYSet.u3) annotation (Line(points={{-39,90},{18,90},{18,
          78}},             color={0,0,127}));
  connect(constTSetRooCoo.y,PIDCoo. u_m) annotation (Line(points={{-39,50},{-10,50},
          {-10,58}},                         color={0,0,127}));
  connect(swiSecForCoo.u3, constYSetZer.y) annotation (Line(points={{78,-18},{
          41,-18}},              color={0,0,127}));
  connect(constYSetZer.y, swiYSet.u3) annotation (Line(points={{41,-18},{50,-18},
          {50,42},{58,42}}, color={0,0,127}));
  connect(hysCoo.u, TRooMea) annotation (Line(points={{-102,-10},{-108,-10},{-108,
          0},{-140,0}},        color={0,0,127}));
  connect(TRooMea, hysHea.u) annotation (Line(points={{-140,0},{-108,0},{-108,20},
          {-102,20}},                                  color={0,0,127}));
  connect(swiSecForCoo.y, ySet) annotation (Line(points={{101,-10},{110,-10},{110,
          40},{130,40}},
                     color={0,0,127}));
  connect(hysSecCoo.u, TRadSup)
    annotation (Line(points={{-102,-70},{-140,-70}},color={0,0,127}));
  connect(swiYSet.y, swiSecForCoo.u1) annotation (Line(points={{81,50},{86,50},{86,
          26},{58,26},{58,-2},{78,-2}},    color={0,0,127}));
  connect(PIDCoo.u_s, TRooMea) annotation (Line(points={{-22,70},{-30,70},{-30,66},
          {-108,66},{-108,0},{-140,0}},
                                      color={0,0,127}));
  connect(PIDHea.u_m, TRooMea) annotation (Line(points={{-50,78},{-50,66},{-108,66},
          {-108,0},{-140,0}},color={0,0,127}));
  connect(PIDCoo.y, swiHeaCooYSet.u1) annotation (Line(points={{1,70},{6,70},{6,62},
          {18,62}},         color={0,0,127}));
  connect(swiHeaCooYSet.y, swiYSet.u1) annotation (Line(points={{41,70},{50,70},{50,
          58},{58,58}},                     color={0,0,127}));
  connect(heaOrCooIsOn.u2, conFal.y) annotation (Line(points={{-22,2},{-26,2},{-26,
          -10},{-50,-10},{-50,-40},{-59,-40}},
                           color={255,0,255}));
  connect(hysCoo.y, heaOrCooIsOn.u2) annotation (Line(points={{-79,-10},{-26,-10},
          {-26,2},{-22,2}},color={255,0,255}));
  connect(heaIsOn.y, hea) annotation (Line(points={{-39,20},{-30,20},{-30,-60},{130,
          -60}},                        color={255,0,255}));
  connect(cooValOrHea.y, swiSecForCoo.u2) annotation (Line(points={{1,-90},{70,
          -90},{70,-10},{78,-10}},
                                 color={255,0,255}));
  connect(cooValOrHea.u2, conTru.y) annotation (Line(points={{-22,-98},{-32,-98},{
          -32,-100},{-39,-100}},          color={255,0,255}));
  connect(cooValOrHea.u2, hysSecCoo.y) annotation (Line(points={{-22,-98},{-32,-98},
          {-32,-70},{-79,-70}},      color={255,0,255}));
  connect(heaIsOn.y, cooValOrHea.u1) annotation (Line(points={{-39,20},{-30,20},{-30,
          -90},{-22,-90}},     color={255,0,255}));
  if not witCoo then
    connect(PIDHea.y, swiYSet.u1) annotation (Line(
      points={{-39,90},{50,90},{50,58},{58,58}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  end if;
  connect(hysCoo.y, booPasThrCoo.u) annotation (Line(points={{-79,-10},{-49.5,-10},
          {-49.5,-30},{-42,-30}}, color={255,0,255}));
  connect(conFal.y, booPasThrCoo.u) annotation (Line(points={{-59,-40},{-50,-40},{
          -50,-30},{-42,-30}}, color={255,0,255}));
  annotation (                                                   Diagram(
        coordinateSystem(extent={{-120,-120},{120,120}})),
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
</html>"),
    Icon(coordinateSystem(extent={{-120,-120},{120,120}}), graphics={
      Text(
          extent={{-153,163},{147,123}},
          textColor={0,0,255},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255},
          textString="%name"),
        Rectangle(
          extent={{-120,120},{120,-120}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}));
end OneRoomRadiatorHeatPumpControl;
