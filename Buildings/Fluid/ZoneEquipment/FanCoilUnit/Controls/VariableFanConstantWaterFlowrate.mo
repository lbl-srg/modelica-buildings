within Buildings.Fluid.ZoneEquipment.FanCoilUnit.Controls;
block VariableFanConstantWaterFlowrate
  "Controller for fan coil system with constant water flow rates and variable speed fan"
  parameter .Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeCoo=Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of fan cooling loop controller"
    annotation (Dialog(group="Fan control parameters - Cooling mode"));
  parameter Real kCoo(
    final unit="1",
    displayUnit="1")=1
    "Gain of fan cooling loop controller"
    annotation(Dialog(group="Fan control parameters - Cooling mode"));
  parameter Modelica.Units.SI.Time TiCoo=0.5
    "Time constant of fan cooling loop integrator block"
    annotation(Dialog(group="Fan control parameters - Cooling mode",
      enable = controllerTypeCoo == Buildings.Controls.OBC.CDL.Types.SimpleController.PI or
      controllerTypeCoo == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Modelica.Units.SI.Time TdCoo=0.1
    "Time constant of fan cooling loop derivative block"
    annotation(Dialog(group="Fan control parameters - Cooling mode",
      enable = controllerTypeCoo == Buildings.Controls.OBC.CDL.Types.SimpleController.PD or
      controllerTypeCoo == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter .Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeHea=Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of fan heating loop controller"
    annotation (Dialog(group="Fan control parameters - Heating mode"));
  parameter Real kHea(
    final unit="1",
    displayUnit="1")=1
    "Gain of fan heating loop controller"
    annotation(Dialog(group="Fan control parameters - Heating mode"));
  parameter Modelica.Units.SI.Time TiHea=0.5
    "Time constant of fan heating loop integrator block"
    annotation(Dialog(group="Fan control parameters - Heating mode",
      enable = controllerTypeHea == Buildings.Controls.OBC.CDL.Types.SimpleController.PI or
      controllerTypeHea == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Modelica.Units.SI.Time TdHea=0.1
    "Time constant of fan heating loop derivative block"
    annotation(Dialog(group="Fan control parameters - Heating mode",
      enable = controllerTypeHea == Buildings.Controls.OBC.CDL.Types.SimpleController.PD or
      controllerTypeHea == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Real minFanSpe(
    final unit="1",
    displayUnit="1",
    final min=0,
    final max=1) = 0.4
    "Minimum fan speed"
    annotation(Dialog(group="System parameters"));
  parameter Modelica.Units.SI.Time tFanEnaDel = 30
    "Time period for fan enable delay"
    annotation(Dialog(group="System parameters"));
  parameter Modelica.Units.SI.Time tFanEna = 300
    "Minimum running time of the fan"
    annotation(Dialog(group="System parameters"));
  parameter Modelica.Units.SI.Time tValEna = 600
    "Minimum duration for which heating/cooling valve action is enabled"
    annotation(Dialog(group="System parameters"));
  parameter Modelica.Units.SI.Time tValDis = 300
    "Minimum duration for which heating/cooling valve action is disabled"
    annotation(Dialog(group="System parameters"));
  parameter Modelica.Units.SI.TemperatureDifference dTHys = 0.2
    "Temperature difference used for enabling coooling and heating mode"
    annotation(Dialog(tab="Advanced"));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uFan
    "Fan proven on signal"
    annotation (Placement(transformation(extent={{-180,80},{-140,120}}),
      iconTransformation(extent={{-140,60},{-100,100}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uOcc
    "Occupancy signal"
    annotation (Placement(transformation(extent={{-180,-100},{-140,-60}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon(
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature")
    "Measured zone temperature"
    annotation (Placement(transformation(extent={{-180,40},{-140,80}}),
      iconTransformation(extent={{-140,20},{-100,60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TCooSet(
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature")
    "Zone cooling temperature setpoint"
    annotation (Placement(transformation(extent={{-180,0},{-140,40}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaSet(
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature")
    "Zone heating temperature setpoint"
    annotation (Placement(transformation(extent={{-180,-40},{-140,0}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yFan
    "Fan enable signal"
    annotation (Placement(transformation(extent={{140,-100},{180,-60}}),
      iconTransformation(extent={{100,-80},{140,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yFanSpe(
    final unit="1",
    displayUnit="1")
    "Fan speed signal"
    annotation (Placement(transformation(extent={{140,-50},{180,-10}}),
      iconTransformation(extent={{100,-40},{140,0}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yCoo(
    final unit="1",
    displayUnit="1")
    "Cooling signal"
    annotation (Placement(transformation(extent={{140,40},{180,80}}),
      iconTransformation(extent={{100,40},{140,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yHea(
    final unit="1",
    displayUnit="1")
    "Heating signal"
    annotation (Placement(transformation(extent={{140,0},{180,40}}),
      iconTransformation(extent={{100,0},{140,40}})));

  Buildings.Controls.OBC.CDL.Reals.Subtract subCoo
    annotation (Placement(transformation(extent={{-110,60},{-90,80}})));
  Buildings.Controls.OBC.CDL.Reals.Hysteresis hysCoo(uLow=-dTHys, uHigh=0)
    "Enable cooling when zone temperature is higher than cooling setpoint"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  Buildings.Controls.OBC.CDL.Reals.PID conPIDCoo(
    controllerType=controllerTypeCoo,
    k=kCoo,
    Ti=TiCoo,
    Td=TdCoo,
    reverseActing=false) "PI Controller for fan speed in cooling mode"
    annotation (Placement(transformation(extent={{0,-20},{20,0}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract subHea
    "Find difference between zone temperature and heating setpoint"
    annotation (Placement(transformation(extent={{-110,10},{-90,30}})));
  Buildings.Controls.OBC.CDL.Reals.PID conPIDHea(
    controllerType=controllerTypeHea,
    k=kHea,
    Ti=TiHea,
    Td=TdHea,
    reverseActing=false) "PI controller for fan speed in heating mode"
    annotation (Placement(transformation(extent={{2,-60},{22,-40}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conZer(k=0)
    "Constant zero signal"
    annotation (Placement(transformation(extent={{-108,-20},{-88,0}})));
  Buildings.Controls.OBC.CDL.Reals.Hysteresis hysHea(uLow=-dTHys, uHigh=0)
    "Enable heating when zone temperature is lower than heating setpoint"
    annotation (Placement(transformation(extent={{-46,10},{-26,30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conMinFanSpe(k=minFanSpe)
    "Minimu fan speed signal"
    annotation (Placement(transformation(extent={{46,-16},{66,4}})));
  Buildings.Controls.OBC.CDL.Reals.Add addFanSpe
    "Pass sum of fan speed from heating and cooling controllers, one of which is always zero"
    annotation (Placement(transformation(extent={{44,-50},{64,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Max max
    "Ensure fan speed is always equal to or greater than minimum fan speed"
    annotation (Placement(transformation(extent={{96,-38},{116,-18}})));
protected
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHolCoo(
    final trueHoldDuration=tValEna,
    final falseHoldDuration=tValDis)
    "Ensure cooling is enabled and disabled for minimum time duration"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHolHea(
    final trueHoldDuration=tValEna,
    final falseHoldDuration=tValDis)
    "Ensure heating is enabled and disabled for minimum time durations"
    annotation (Placement(transformation(extent={{60,20},{80,40}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHolFanEna(
    final trueHoldDuration=tFanEna,
    final falseHoldDuration=0)
    "Keep fan enabled for minimum duration"
    annotation (Placement(transformation(extent={{108,-110},{128,-90}})));

  Buildings.Controls.OBC.CDL.Logical.Timer timFan(
    final t=tFanEnaDel)
    "Time delay for switching on the fan"
    annotation (Placement(transformation(extent={{30,-110},{50,-90}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToReaCoo
    "Boolean to Real conversion"
    annotation (Placement(transformation(extent={{100,60},{120,80}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToReaHea
    "Boolean to Real conversion"
    annotation (Placement(transformation(extent={{100,20},{120,40}})));

  Buildings.Controls.OBC.CDL.Logical.Or orHeaCoo
    "Enable fan in heating mode and cooling mode"
    annotation (Placement(transformation(extent={{0,-110},{20,-90}})));

  Buildings.Controls.OBC.CDL.Logical.Or orHeaCooOcc
    "Enable fan when zone is occupied or when setpoint is violated"
    annotation (Placement(transformation(extent={{80,-110},{100,-90}})));

  Buildings.Controls.OBC.CDL.Logical.And andCoo
    "Enable cooling coil valve only when fan is proven on"
    annotation (Placement(transformation(extent={{0,60},{20,80}})));

  Buildings.Controls.OBC.CDL.Logical.And andHea
    "Enable heating coil valve only when fan is proven on"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));

equation

  connect(booToReaCoo.y, yCoo) annotation (Line(points={{122,70},{130,70},{130,
          60},{160,60}},
                     color={0,0,127}));

  connect(booToReaHea.y, yHea) annotation (Line(points={{122,30},{130,30},{130,
          20},{160,20}},
                     color={0,0,127}));

  connect(orHeaCoo.y, timFan.u)
    annotation (Line(points={{22,-100},{28,-100}}, color={255,0,255}));
  connect(timFan.passed, orHeaCooOcc.u2)
    annotation (Line(points={{52,-108},{78,-108}}, color={255,0,255}));
  connect(uFan, andCoo.u2) annotation (Line(points={{-160,100},{-12,100},{-12,62},
          {-2,62}}, color={255,0,255}));
  connect(uFan, andHea.u2) annotation (Line(points={{-160,100},{-12,100},{-12,22},
          {-2,22}}, color={255,0,255}));
  connect(orHeaCooOcc.y, truFalHolFanEna.u)
    annotation (Line(points={{102,-100},{106,-100}}, color={255,0,255}));
  connect(truFalHolFanEna.y, yFan) annotation (Line(points={{130,-100},{134,-100},
          {134,-80},{160,-80}}, color={255,0,255}));

  connect(uOcc, orHeaCooOcc.u1) annotation (Line(points={{-160,-80},{72,-80},{
          72,-100},{78,-100}}, color={255,0,255}));
  connect(andCoo.y, truFalHolCoo.u)
    annotation (Line(points={{22,70},{58,70}}, color={255,0,255}));
  connect(truFalHolCoo.y, booToReaCoo.u)
    annotation (Line(points={{82,70},{98,70}}, color={255,0,255}));
  connect(andHea.y, truFalHolHea.u)
    annotation (Line(points={{22,30},{58,30}}, color={255,0,255}));
  connect(truFalHolHea.y, booToReaHea.u)
    annotation (Line(points={{82,30},{98,30}}, color={255,0,255}));
  connect(TCooSet, subCoo.u2) annotation (Line(points={{-160,20},{-138,20},{
          -138,50},{-118,50},{-118,64},{-112,64}}, color={0,0,127}));
  connect(TZon, subCoo.u1) annotation (Line(points={{-160,60},{-126,60},{-126,
          76},{-112,76}}, color={0,0,127}));
  connect(subCoo.y, hysCoo.u)
    annotation (Line(points={{-88,70},{-42,70}}, color={0,0,127}));
  connect(subCoo.y, conPIDCoo.u_m) annotation (Line(points={{-88,70},{-72,70},{
          -72,-30},{10,-30},{10,-22}}, color={0,0,127}));
  connect(THeaSet, subHea.u1) annotation (Line(points={{-160,-20},{-128,-20},{
          -128,26},{-112,26}}, color={0,0,127}));
  connect(TZon, subHea.u2) annotation (Line(points={{-160,60},{-134,60},{-134,
          52},{-114,52},{-114,36},{-120,36},{-120,14},{-112,14}}, color={0,0,
          127}));
  connect(conZer.y, conPIDCoo.u_s)
    annotation (Line(points={{-86,-10},{-2,-10}}, color={0,0,127}));
  connect(conZer.y, conPIDHea.u_s) annotation (Line(points={{-86,-10},{-30,-10},
          {-30,-50},{0,-50}}, color={0,0,127}));
  connect(subHea.y, conPIDHea.u_m) annotation (Line(points={{-88,20},{-84,20},{
          -84,16},{-78,16},{-78,-70},{12,-70},{12,-62}}, color={0,0,127}));
  connect(hysHea.y, orHeaCoo.u2) annotation (Line(points={{-24,20},{-24,-110},{
          -2,-110},{-2,-108}}, color={255,0,255}));
  connect(hysHea.y, andHea.u1) annotation (Line(points={{-24,20},{-14,20},{-14,
          30},{-2,30}}, color={255,0,255}));
  connect(hysCoo.y, orHeaCoo.u1) annotation (Line(points={{-18,70},{-10,70},{
          -10,-100},{-2,-100}}, color={255,0,255}));
  connect(subHea.y, hysHea.u)
    annotation (Line(points={{-88,20},{-48,20}}, color={0,0,127}));
  connect(conPIDCoo.y, addFanSpe.u1) annotation (Line(points={{22,-10},{32,-10},
          {32,-28},{28,-28},{28,-34},{42,-34}}, color={0,0,127}));
  connect(conPIDHea.y, addFanSpe.u2)
    annotation (Line(points={{24,-50},{24,-46},{42,-46}}, color={0,0,127}));
  connect(conMinFanSpe.y, max.u1) annotation (Line(points={{68,-6},{84,-6},{84,
          -22},{94,-22}}, color={0,0,127}));
  connect(addFanSpe.y, max.u2) annotation (Line(points={{66,-40},{84,-40},{84,
          -34},{94,-34}}, color={0,0,127}));
  connect(max.y, yFanSpe) annotation (Line(points={{118,-28},{134,-28},{134,-30},
          {160,-30}}, color={0,0,127}));
  annotation (defaultComponentName="conVarFanConWat",
    Icon(coordinateSystem(preserveAspectRatio=false,
      extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(
        extent={{-100,100},{100,-100}},
        lineColor={0,0,0},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Text(
        extent={{-100,100},{100,140}},
        textString="%name",
        textColor={0,0,255})}),
    Diagram(coordinateSystem(preserveAspectRatio=false,
      extent={{-140,-120},{140,120}})),
    Documentation(info="<html>
      This is a control module for the fan coil unit (FCU) system model designed as an 
      analogue to the <code>VariableFanConstantFlow</code> capacity control method 
      in EnergyPlus. The control logic is as described in the following section 
      and can also be seen in the logic chart.
      <br>
      <ul>
      <li>
      When the zone temperature <code>TZon</code> is above the cooling setpoint
      temperature <code>TCooSet</code>, the FCU enters cooling mode operation.
      The fan is enabled (<code>yFan = True</code>) and is run at a speed
      <code>yFanSpe</code> that regulates <code>TZon</code> at <code>TCooSet</code>. 
      The cooling valve signal <code>yCoo</code> is set to <code>1</code> to fully open the
      cooling coil valve.
      </li>
      <li>
      When <code>TZon</code> is below the heating setpoint temperature <code>THeaSet</code>, 
      the FCU enters heating mode operation. The fan is enabled (<code>yFan = True</code>)
      and is run at speed <code>yFanSpe</code> to regulate <code>TZon</code> at 
      <code>THeaSet</code>. The heating signal <code>yHea</code> is set to <code>1</code>
      to fully open the heating coil valve.
      </li>
      <li>
      When <code>TZon</code> is between <code>THeaSet</code> and <code>TCooSet</code>, 
      the FCU enters deadband mode. If the zone is occupied as per the occupancy schedule 
      (<code>conVarWatConFan.timTabOccSch.y = 1</code>), the fan is enabled (<code>yFan = True</code>) 
      and is run at the minimum speed
      (<code>yFanSpe = minFanSpe</code>). <code>yHea</code> and <code>yCoo</code> are set 
      to <code>zero</code>.
      </li>
      </ul>
      <p align=\"center\">
      <img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/ZoneEquipment/FanCoilUnit/Controls/constantFlowrateVariableFan.png\"/>
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
end VariableFanConstantWaterFlowrate;
