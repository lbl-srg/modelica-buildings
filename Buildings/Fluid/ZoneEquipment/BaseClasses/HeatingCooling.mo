within Buildings.Fluid.ZoneEquipment.BaseClasses;
model HeatingCooling
  "Subcontroller for managing variable heating/cooling elements"

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation(Dialog(group="PID control parameters"));

  parameter Boolean conMod=false
    "Mode being controlled: Select false for cooling and true for heating";

  parameter Real k(
    final unit="1",
    displayUnit="1",
    final min=0)=1
    "Gain of controller"
    annotation(Dialog(group="PID control parameters"));

  parameter Real TSupDew(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")=273.15 + 12
    "Supply air temperature limit under which condensation will be caused"
    annotation(Dialog(group="Setpoints limits setting"));

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
    "Temperature difference used for enabling cooling or heating mode";

  parameter Modelica.Units.SI.Time tCoiEna
    "Minimum time for which coil is enabled";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uFan
    "Fan proven on signal"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}),
      iconTransformation(extent={{-140,40},{-100,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon(
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature") "Measured zone temperature"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
      iconTransformation(extent={{-140,0},{-100,40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZonSet(
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature")
    "Zone temperature setpoint"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}}),
      iconTransformation(extent={{-140,-40},{-100,0}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSup(
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature") if not conMod
    "Measured supply temperature"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yMod
    "Heating/cooling mode enable signal"
    annotation (Placement(transformation(extent={{100,-80},{140,-40}}),
      iconTransformation(extent={{100,-60},{140,-20}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yEna
    "Heating/cooling component enable signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yCoi(
    final unit="1",
    displayUnit="1")
    "Heating/cooling signal"
    annotation (Placement(transformation(extent={{100,30},{140,70}}),
      iconTransformation(extent={{100,20},{140,60}})));

protected
  Buildings.Controls.OBC.CDL.Logical.And andHeaCooEna
    "Enable heating/cooling component only when fan is proven on"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea
    "Convert fan proven on signal to real value"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));

  Buildings.Controls.OBC.CDL.Continuous.Multiply mulSig
    "Pass heating/cooling signal only when fan is proven on"
    annotation (Placement(transformation(extent={{40,40},{60,60}})));

  Buildings.Controls.OBC.CDL.Continuous.Subtract TSub
    "Find difference between zone temperature and setpoint"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hysModCoo(
    final uLow=-dTHys,
    final uHigh=dTHys) if   not conMod
    "Enable cooling mode when zone temperature is not at setpoint"
    annotation (Placement(transformation(extent={{0,-50},{20,-30}})));

  Buildings.Controls.OBC.CDL.Continuous.PID conPID(
    final controllerType=controllerType,
    final k=k,
    final Ti=Ti,
    final Td=Td,
    final reverseActing=conMod)
    "PI controller for heating/cooling component"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conZero(
    final k=0)
    "Constant zero signal"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hysModHea(
    final uLow=-dTHys,
    final uHigh=dTHys) if conMod
    "Enable heating mode when zone temperature is not at setpoint"
    annotation (Placement(transformation(extent={{20,-90},{40,-70}})));

  Buildings.Controls.OBC.CDL.Logical.Not notHea if conMod
    "Pass true for heating mode signal when hysteresis becomes false"
    annotation (Placement(transformation(extent={{50,-90},{70,-70}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol(final
      trueHoldDuration=tCoiEna, falseHoldDuration=0)
    "Keep coil enabled for minimum time duration"
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));

  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr(
    final t=TSupDew) if not conMod
    "Check if supply temperature is greater than zone air dewpoint temperature"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));

  Buildings.Controls.OBC.CDL.Logical.And andTSupLow if not conMod
    "Enable heating/cooling component only when measured supply temperature is above dew point at thermal comfort level"
    annotation (Placement(transformation(extent={{54,-38},{74,-18}})));

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
  connect(mulSig.y, yCoi)
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
  connect(truFalHol.y, yEna) annotation (Line(points={{92,0},{120,0}},
                   color={255,0,255}));
  connect(TSup, greThr.u) annotation (Line(points={{-120,-80},{-82,-80}},
                           color={0,0,127}));
  connect(greThr.y, andTSupLow.u2) annotation (Line(points={{-58,-80},{-20,-80},
          {-20,-60},{40,-60},{40,-36},{52,-36}},color={255,0,255}));
  connect(andHeaCooEna.y, andTSupLow.u1) annotation (Line(points={{62,0},{64,0},
          {64,-12},{40,-12},{40,-28},{52,-28}}, color={255,0,255}));
  connect(andTSupLow.y, truFalHol.u) annotation (Line(points={{76,-28},{80,-28},
          {80,-12},{66,-12},{66,0},{68,0}}, color={255,0,255}));
  if conMod then
    connect(andHeaCooEna.y, truFalHol.u)
      annotation (Line(points={{62,0},{68,0}}, color={255,0,255}));
  end if;
  annotation (defaultComponentName="conOpeMod",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-140,140},{140,180}},
          textString="%name",
          textColor={0,0,255}),
        Text(
          extent={{-98,68},{-62,52}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uFan"),
        Text(
          extent={{-96,26},{-64,10}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TZon"),
        Text(
          extent={{-96,-52},{-64,-68}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TSup",
          enable=not conMod),
        Text(
          extent={{-94,-10},{-46,-34}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TZonSet"),
        Text(
          extent={{64,48},{96,32}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yCoi"),
        Text(
          extent={{62,8},{98,-8}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="yEna"),
        Text(
          extent={{62,-32},{98,-48}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="yMod")}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})),
    Documentation(info="<html>
      <p>
      This is a control module for the heating or cooling coil operation designed
      as an analogue to the control logic in EnergyPlus. The component is operated 
      as follows:
      <ul>
      <li>
      The coil is enabled (<code>yEna=true</code>) when the fan is proven on 
      (<code>uFan=true</code>) and the measured zone temperature <code>TZon</code> 
      exceeds the setpoint <code>TZonSet</code> in the appropriate direction.
      </li>
      <li>
      In cooling mode (<code>conMod=false</code>), there is an additional check 
      to make sure the measured supply temperature <code>TSup</code> is greater than
      the dewpoint temperature at ideal zone conditions <code>TSupDew</code>.
      </li>
      <li>
      Once the coil is enabled, it is held on for minimum time duration <code>tCoiEna</code>.
      If it has variable capacity, it is modulated to regulate <code>TZon</code>
      at <code>TZonSet</code> using the coil capacity output signal <code>yCoi</code>.
      </li>
      </ul>
      </p>
      <p align=\"center\">
      <img src=\"modelica://Buildings/Resources/Images/Fluid/ZoneEquipment/Baseclasses/variableHeatingCooling.png\"
           alt=\"variableHeatingCooling.png\" />
      </p>
      </html>
      ", revisions="<html>
      <ul>
      <li>
      June 21, 2023 by Karthik Devaprasad, Xing Lu, Junke Wang:<br/>
      First implementation.
      </li>
      </ul>
      </html>"));
end HeatingCooling;
