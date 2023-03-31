within Buildings.Fluid.ZoneEquipment.BaseClasses;
model HeatingCooling
  "Subcontroller for managing variable heating/cooling elements"

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation(Dialog(group="PID control parameters"));

  parameter Real k(
    final unit="1",
    displayUnit="1",
    final min=0)=1
    "Gain of controller"
    annotation(Dialog(group="PID control parameters"));

  parameter Modelica.Units.SI.Time Ti=0.5
    "Time constant of integrator block"
    annotation(Dialog(group="PID control parameters",
      enable = controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PI or
      controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Modelica.Units.SI.Time Td=0.1
    "Time constant of derivative block"
    annotation(Dialog(group="PID control parameters",
      enable = controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PD or
      controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Modelica.Units.SI.TemperatureDifference dTHys = 0.2
    "Temperature difference used for enabling cooling and heating mode"
    annotation(Dialog(tab="Advanced"));

  Modelica.Blocks.Interfaces.RealInput TZon(
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature") "Measured zone temperature"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-180,-20},{-140,20}})));
  Modelica.Blocks.Interfaces.RealInput TZonSet(
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature")
    "Zone temperature setpoint" annotation (Placement(transformation(extent={{-140,
            -60},{-100,-20}}), iconTransformation(extent={{-180,-100},{-140,-60}})));
  Modelica.Blocks.Interfaces.BooleanInput uFan "Fan proven on signal"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}),
        iconTransformation(extent={{-180,60},{-140,100}})));
  Modelica.Blocks.Interfaces.RealOutput y(final unit="1", displayUnit="1")
                                "Heating/cooling signal" annotation (Placement(
        transformation(extent={{100,30},{140,70}}), iconTransformation(extent={{140,60},
            {180,100}})));
  Modelica.Blocks.Interfaces.BooleanOutput yMod
    "Heating/cooling mode enable signal"
    annotation (Placement(transformation(extent={{100,-80},{140,-40}}),
      iconTransformation(extent={{140,-100},{180,-60}})));

  parameter Boolean conMod=false
    "Mode being controlled: Select false for cooling and true for heating";
  Modelica.Blocks.Interfaces.BooleanOutput yEna
    "Heating/cooling component enable signal" annotation (Placement(
        transformation(extent={{100,-20},{140,20}}), iconTransformation(extent={
            {140,-20},{180,20}})));
  Controls.OBC.CDL.Logical.And andHeaCooEna
    "Enable heating/cooling component only when fan is proven on"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
// protected
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea
    "Convert fan proven on signal to real value"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));

  Buildings.Controls.OBC.CDL.Continuous.Multiply mulSig
    "Pass heating/cooling signal only when fan is proven on"
    annotation (Placement(transformation(extent={{40,40},{60,60}})));

  Buildings.Controls.OBC.CDL.Continuous.Subtract TSub
    "Find difference between zone temperature and setpoint"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hysModCoo(final uLow=-dTHys,
      final uHigh=0) if not conMod
    "Enable cooling mode when zone temperature is not at setpoint"
    annotation (Placement(transformation(extent={{0,-50},{20,-30}})));

  Buildings.Controls.OBC.CDL.Continuous.PID conPID(
    final controllerType=controllerType,
    final k=k,
    final Ti=Ti,
    final Td=Td,
    final reverseActing=conMod) "PI controller for heating/cooling component"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conZero(
    final k=0)
    "Constant zero signal"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));

  Controls.OBC.CDL.Continuous.Hysteresis hysModHea(final uLow=-dTHys, final
      uHigh=0) if conMod
    "Enable heating mode when zone temperature is not at setpoint"
    annotation (Placement(transformation(extent={{20,-90},{40,-70}})));
  Controls.OBC.CDL.Logical.Not notHea if conMod
    "Pass tru for heating mode signal when hysteresis becomes false"
    annotation (Placement(transformation(extent={{50,-90},{70,-70}})));
  Controls.OBC.CDL.Logical.TrueFalseHold truFalHol(trueHoldDuration=tCoiEna,
      falseHoldDuration=0)
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));
  Modelica.Blocks.Interfaces.RealInput TSup(
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature") "Measured supply temperature"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}}),
        iconTransformation(extent={{-180,-160},{-140,-120}})));
  Controls.OBC.CDL.Continuous.GreaterThreshold greThr(t=273.15 + 15)
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Controls.OBC.CDL.Logical.And andTSupLow
    "Enable heating/cooling component only when measured supply temperature is above dew point at thermal comfort level"
    annotation (Placement(transformation(extent={{54,-38},{74,-18}})));
  parameter Modelica.Units.SI.Time tCoiEna "true hold duration";
equation

  connect(TSub.y, hysModCoo.u) annotation (Line(points={{-38,-20},{-10,-20},{
          -10,-40},{-2,-40}},
                          color={0,0,127}));

  connect(TSub.y, conPID.u_m)
    annotation (Line(points={{-38,-20},{-10,-20},{-10,18}},
                                                          color={0,0,127}));

  connect(conZero.y, conPID.u_s)
    annotation (Line(points={{-38,30},{-22,30}},color={0,0,127}));

  connect(conPID.y,mulSig. u2) annotation (Line(points={{2,30},{30,30},{30,44},{
          38,44}},  color={0,0,127}));
  connect(booToRea.y,mulSig. u1) annotation (Line(points={{-38,70},{30,70},{30,56},
          {38,56}}, color={0,0,127}));
  connect(mulSig.y, y)
    annotation (Line(points={{62,50},{120,50}}, color={0,0,127}));
  connect(uFan, booToRea.u)
    annotation (Line(points={{-120,40},{-80,40},{-80,70},{-62,70}},
                                                  color={255,0,255}));
  connect(TZon, TSub.u1) annotation (Line(points={{-120,0},{-90,0},{-90,-14},{-62,
          -14}},
               color={0,0,127}));
  connect(TZonSet, TSub.u2) annotation (Line(points={{-120,-40},{-90,-40},{-90,-26},
          {-62,-26}},color={0,0,127}));
  connect(hysModCoo.y, yMod) annotation (Line(points={{22,-40},{92,-40},{92,-60},
          {120,-60}}, color={255,0,255}));
  connect(TSub.y, hysModHea.u) annotation (Line(points={{-38,-20},{-10,-20},{-10,
          -80},{18,-80}}, color={0,0,127}));
  connect(hysModHea.y, notHea.u)
    annotation (Line(points={{42,-80},{48,-80}}, color={255,0,255}));
  connect(notHea.y, yMod) annotation (Line(points={{72,-80},{92,-80},{92,-60},{120,
          -60}}, color={255,0,255}));
  connect(hysModCoo.y, andHeaCooEna.u2) annotation (Line(points={{22,-40},{30,
          -40},{30,-8},{38,-8}},
                            color={255,0,255}));
  connect(notHea.y, andHeaCooEna.u2) annotation (Line(points={{72,-80},{92,-80},
          {92,-40},{30,-40},{30,-8},{38,-8}}, color={255,0,255}));
  connect(uFan, andHeaCooEna.u1) annotation (Line(points={{-120,40},{-80,40},{
          -80,0},{38,0}},
                      color={255,0,255}));
  connect(truFalHol.y, yEna) annotation (Line(points={{92,0},{100,0},{100,0},{
          120,0}}, color={255,0,255}));
  connect(TSup, greThr.u) annotation (Line(points={{-120,-80},{-90,-80},{-90,
          -70},{-82,-70}}, color={0,0,127}));
  connect(greThr.y, andTSupLow.u2) annotation (Line(points={{-58,-70},{10,-70},
          {10,-60},{40,-60},{40,-36},{52,-36}}, color={255,0,255}));
  connect(andHeaCooEna.y, andTSupLow.u1) annotation (Line(points={{62,0},{64,0},
          {64,-12},{40,-12},{40,-28},{52,-28}}, color={255,0,255}));
  connect(andTSupLow.y, truFalHol.u) annotation (Line(points={{76,-28},{80,-28},
          {80,-12},{66,-12},{66,0},{68,0}}, color={255,0,255}));
  annotation (defaultComponentName="conOpeMod",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-140,-140},{140,140}}),
        graphics={Rectangle(
          extent={{-140,140},{140,-140}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-140,140},{140,180}},
          textString="%name",
          textColor={0,0,255})}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})),
    Documentation(info="<html>
      <p>
      This is a control module for the unit heater system model designed as an 
      analogue to the control logic in EnergyPlus. The components are operated 
      as follows.
      <br>
      <ul>
      <li>
      
      </li>
      <li>
      When <code>TZon</code> is below the heating setpoint temperature
      <code>THeaSet</code>, the FCU enters heating mode operation. The fan is 
      enabled (<code>yFan = True</code>) and is run at the maximum speed
      (<code>yFanSpe = 1</code>). The heating signal <code>yHea</code> is used to
      regulate <code>TZon</code> at <code>THeaSet</code>.
      </li>
      <li>
      When the zone temperature <code>TZon</code> is between <code>THeaSet</code>
      and <code>TCooSet</code>, the FCU enters deadband mode. If the zone is occupied 
      as per the occupancy schedule (<code>conVarWatConFan.timTabOccSch.y = 1</code>),
      the fan is enabled (<code>yFan = True</code>) and is run at the minimum speed
      (<code>yFanSpe = minFanSpe</code>). <code>yHea</code> and <code>yCoo</code> are set 
      to <code>zero</code>.
      </li>
      </ul>
      </p>
      <p align=\"center\">
      <img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/ZoneEquipment/FanCoilUnit/Controls/constantFanVariableFlowrate.png\"/>
      </p>
      </html>
      ", revisions="<html>
      <ul>
      <li>
      August 03, 2022 by Karthik Devaprasad:<br/>
      First implementation.
      </li>
      </ul>
      </html>"));
end HeatingCooling;
