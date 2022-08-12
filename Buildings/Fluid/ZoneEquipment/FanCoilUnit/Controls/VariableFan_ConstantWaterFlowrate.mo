within Buildings.Fluid.ZoneEquipment.FanCoilUnit.Controls;
block VariableFan_ConstantWaterFlowrate
  "Controller for fan coil system with constant water flow rates and variable speed fan"

  parameter .Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeCoo=Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller for fan in cooling mode"
    annotation (Dialog(group="Fan control parameters - Cooling mode"));

  parameter Real kCoo(
    final unit="1",
    displayUnit="1")=1
    "Gain of controller for fan in cooling mode"
    annotation(Dialog(group="Fan control parameters - Cooling mode"));

  parameter Real TiCoo(
    final unit="s",
    displayUnit="s",
    final quantity="Time")=0.5
    "Time constant of integrator block for fan in cooling mode"
    annotation(Dialog(group="Fan control parameters - Cooling mode",
      enable = controllerTypeCoo == Buildings.Controls.OBC.CDL.Types.SimpleController.PI or
      controllerTypeCoo == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Real TdCoo(
    final unit="s",
    displayUnit="s",
    final quantity="Time")=0.1
    "Time constant of derivative block for fan in cooling mode"
    annotation(Dialog(group="Fan control parameters - Cooling mode",
      enable = controllerTypeCoo == Buildings.Controls.OBC.CDL.Types.SimpleController.PD or
      controllerTypeCoo == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter .Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeHea=Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller for fan in heating mode"
    annotation (Dialog(group="Fan control parameters - Heating mode"));

  parameter Real kHea(
    final unit="1",
    displayUnit="1")=1
    "Gain of controller for fan in heating mode"
    annotation(Dialog(group="Fan control parameters - Heating mode"));

  parameter Real TiHea(
    final unit="s",
    displayUnit="s",
    final quantity="Time")=0.5
    "Time constant of integrator block for fan in heating mode"
    annotation(Dialog(group="Fan control parameters - Heating mode",
      enable = controllerTypeHea == Buildings.Controls.OBC.CDL.Types.SimpleController.PI or
      controllerTypeHea == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Real TdHea(
    final unit="s",
    displayUnit="s",
    final quantity="Time")=0.1
    "Time constant of derivative block for fan in heating mode"
    annotation(Dialog(group="Fan control parameters - Heating mode",
      enable = controllerTypeHea == Buildings.Controls.OBC.CDL.Types.SimpleController.PD or
      controllerTypeHea == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Integer nRowOccSch = 4
    "Number of rows in the occupancy schedule table"
    annotation(Dialog(group="Occupancy schedule parameters"));

  parameter Real tableOcc[nRowOccSch,2](
    final unit=fill("s",nRowOccSch,2),
    displayUnit=fill("s",nRowOccSch,2),
    final quantity=fill("Time",nRowOccSch,2)) = [0, 0; 6, 1; 18, 0; 24, 0]
    "Table matrix (time = first column) for the occupancy schedule"
    annotation(Dialog(group="Occupancy schedule parameters"));

  parameter Real timeScaleOcc(
    final unit="s",
    displayUnit="s",
    final quantity="Time") = 3600
    "Time scale of first table column. Set to 3600 if time in table is in hours"
    annotation(Dialog(group="Occupancy schedule parameters"));

  parameter Real minFanSpe(
    final unit="1",
    displayUnit="1",
    final min=0,
    final max=1) = 0.4
    "Minimum allowed fan speed"
    annotation(Dialog(group="System parameters"));

  parameter Real tDeaModOff(
    final unit="s",
    displayUnit="s",
    final quantity="Time",
    final min = 0) = 30
    "Time period for delay between switching from deadband mode to heating/cooling mode"
    annotation(Dialog(group="System parameters"));

  parameter Real dTHys(
    final unit="K",
    displayUnit="K",
    final quantity="TemperatureDifference") = 0.2
    "Temperature difference used for enabling coooling and heating mode"
    annotation(Dialog(tab="Advanced"));

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
    annotation (Placement(transformation(extent={{120,-100},{160,-60}}),
      iconTransformation(extent={{100,-80},{140,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yFanSpe(
    final unit="1",
    displayUnit="1")
    "Fan speed signal"
    annotation (Placement(transformation(extent={{120,-50},{160,-10}}),
      iconTransformation(extent={{100,-40},{140,0}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yCoo(
    final unit="1",
    displayUnit="1")
    "Cooling signal"
    annotation (Placement(transformation(extent={{120,40},{160,80}}),
      iconTransformation(extent={{100,40},{140,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yHea(
    final unit="1",
    displayUnit="1")
    "Heating signal"
    annotation (Placement(transformation(extent={{120,0},{160,40}}),
      iconTransformation(extent={{100,0},{140,40}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.TimeTable timTabOccSch(
    final table=tableOcc,
    final smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments,
    final timeScale=timeScaleOcc)
    "Table with occupancy schedule for the zone"
    annotation (Placement(transformation(extent={{-110,-100},{-90,-80}})));

// protected
  Buildings.Controls.OBC.CDL.Logical.Timer timCoo(
    final t=tDeaModOff)
    "Time delay for switching on cooling mode from deadband mode"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));

  Buildings.Controls.OBC.CDL.Logical.Timer timHea(
    final t=tDeaModOff)
    "Time delay for switching on heating mode from deadband mode"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys1(
    final uLow=-dTHys,
    final uHigh=0)
    "Enable cooling when zone temperature is higher than cooling setpoint"
    annotation (Placement(transformation(extent={{-70,60},{-50,80}})));

  Buildings.Controls.OBC.CDL.Continuous.Subtract sub2
    "Find difference between zone temperature and cooling setpoint"
    annotation (Placement(transformation(extent={{-110,60},{-90,80}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea
    "Boolean to Real conversion"
    annotation (Placement(transformation(extent={{10,60},{30,80}})));

  Buildings.Controls.OBC.CDL.Continuous.Subtract sub1
    "Find difference between zone temperature and heating setpoint"
    annotation (Placement(transformation(extent={{-110,10},{-90,30}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys2(
    final uLow=-dTHys,
    final uHigh=0)
    "Enable heating when zone temperature is lower than heating setpoint"
    annotation (Placement(transformation(extent={{-70,10},{-50,30}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1
    "Boolean to Real conversion"
    annotation (Placement(transformation(extent={{10,10},{30,30}})));

  Buildings.Controls.OBC.CDL.Logical.Or or2
    "Enable fan in heating mode and cooling mode"
    annotation (Placement(transformation(extent={{20,-110},{40,-90}})));

  Buildings.Controls.OBC.CDL.Continuous.PID conPID(
    final controllerType=controllerTypeCoo,
    final k=kCoo,
    final Ti=TiCoo,
    final Td=TdCoo,
    final reverseActing=false)
    "PI controller for fan speed in cooling mode"
    annotation (Placement(transformation(extent={{0,-20},{20,0}})));

  Buildings.Controls.OBC.CDL.Continuous.PID conPID1(
    final controllerType=controllerTypeHea,
    final k=kHea,
    final Ti=TiHea,
    final Td=TdHea,
    final reverseActing=false)
    "PI controller for fan speed in heating mode"
    annotation (Placement(transformation(extent={{0,-60},{20,-40}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(
    final k=0)
    "Constant zero signal"
    annotation (Placement(transformation(extent={{-110,-20},{-90,0}})));

  Buildings.Controls.OBC.CDL.Continuous.Add add3
    "Pass sum of fan speed from heating and cooling controllers, one of which is always zero"
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));

  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr[1](
    final t=fill(0.5, 1))
    "Check if zone is occupied"
    annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));

  Buildings.Controls.OBC.CDL.Logical.Or or1
    "Enable fan when zone is occupied or when setpoint is violated"
    annotation (Placement(transformation(extent={{80,-110},{100,-90}})));

  Buildings.Controls.OBC.CDL.Continuous.Switch swi
    "Pass minimum fan speed signal when the FCU is in deadband mode"
    annotation (Placement(transformation(extent={{80,-40},{100,-20}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con1(
    final k=minFanSpe)
    "Minimum fan speed signal"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));

  Buildings.Controls.OBC.CDL.Logical.And and2
    "Check if FCU is in deadband mode"
    annotation (Placement(transformation(extent={{80,-70},{100,-50}})));

  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Check if FCU is not in heating or cooling mode"
    annotation (Placement(transformation(extent={{40,-70},{60,-50}})));

equation
  connect(TZon,sub2. u1) annotation (Line(points={{-160,60},{-130,60},{-130,76},
          {-112,76}},
                    color={0,0,127}));

  connect(TCooSet,sub2. u2) annotation (Line(points={{-160,20},{-136,20},{-136,64},
          {-112,64}},color={0,0,127}));

  connect(sub2.y, hys1.u)
    annotation (Line(points={{-88,70},{-72,70}}, color={0,0,127}));

  connect(booToRea.y, yCoo) annotation (Line(points={{32,70},{80,70},{80,60},{140,
          60}},     color={0,0,127}));

  connect(sub1.y, hys2.u)
    annotation (Line(points={{-88,20},{-72,20}}, color={0,0,127}));

  connect(TZon,sub1. u2) annotation (Line(points={{-160,60},{-130,60},{-130,14},
          {-112,14}},
                    color={0,0,127}));

  connect(THeaSet,sub1. u1) annotation (Line(points={{-160,-20},{-120,-20},{-120,
          26},{-112,26}},color={0,0,127}));

  connect(booToRea1.y, yHea)
    annotation (Line(points={{32,20},{140,20}}, color={0,0,127}));

  connect(sub2.y, conPID.u_m) annotation (Line(points={{-88,70},{-80,70},{-80,-26},
          {10,-26},{10,-22}},      color={0,0,127}));

  connect(sub1.y, conPID1.u_m) annotation (Line(points={{-88,20},{-84,20},{-84,-68},
          {10,-68},{10,-62}},      color={0,0,127}));

  connect(con.y, conPID.u_s) annotation (Line(points={{-88,-10},{-2,-10}},
                          color={0,0,127}));

  connect(con.y, conPID1.u_s) annotation (Line(points={{-88,-10},{-20,-10},{-20,
          -50},{-2,-50}}, color={0,0,127}));

  connect(timTabOccSch.y, greThr.u)
    annotation (Line(points={{-88,-90},{-82,-90}}, color={0,0,127}));
  connect(or2.y, or1.u2) annotation (Line(points={{42,-100},{60,-100},{60,-108},
          {78,-108}},
                 color={255,0,255}));
  connect(greThr[1].y, or1.u1) annotation (Line(points={{-58,-90},{-40,-90},{-40,
          -116},{70,-116},{70,-100},{78,-100}},
                                              color={255,0,255}));
  connect(or1.y, yFan) annotation (Line(points={{102,-100},{110,-100},{110,-80},
          {140,-80}},
                 color={255,0,255}));
  connect(conPID1.y, add3.u2) annotation (Line(points={{22,-50},{30,-50},{30,-36},
          {38,-36}}, color={0,0,127}));
  connect(conPID.y, add3.u1) annotation (Line(points={{22,-10},{30,-10},{30,-24},
          {38,-24}}, color={0,0,127}));
  connect(swi.y, yFanSpe)
    annotation (Line(points={{102,-30},{140,-30}}, color={0,0,127}));
  connect(add3.y, swi.u3) annotation (Line(points={{62,-30},{70,-30},{70,-38},{78,
          -38}}, color={0,0,127}));
  connect(con1.y, swi.u1) annotation (Line(points={{62,0},{70,0},{70,-22},{78,-22}},
        color={0,0,127}));
  connect(or2.y, not1.u) annotation (Line(points={{42,-100},{60,-100},{60,-80},{
          30,-80},{30,-60},{38,-60}}, color={255,0,255}));
  connect(not1.y, and2.u2) annotation (Line(points={{62,-60},{66,-60},{66,-68},{
          78,-68}}, color={255,0,255}));
  connect(greThr[1].y, and2.u1) annotation (Line(points={{-58,-90},{-40,-90},{-40,
          -116},{70,-116},{70,-60},{78,-60}}, color={255,0,255}));
  connect(and2.y, swi.u2) annotation (Line(points={{102,-60},{110,-60},{110,-44},
          {74,-44},{74,-30},{78,-30}}, color={255,0,255}));
  connect(hys1.y, timCoo.u)
    annotation (Line(points={{-48,70},{-42,70}}, color={255,0,255}));
  connect(timCoo.passed, booToRea.u) annotation (Line(points={{-18,62},{0,62},{0,
          70},{8,70}}, color={255,0,255}));
  connect(timCoo.passed, or2.u1) annotation (Line(points={{-18,62},{-8,62},{-8,-100},
          {18,-100}}, color={255,0,255}));
  connect(hys2.y, timHea.u)
    annotation (Line(points={{-48,20},{-42,20}}, color={255,0,255}));
  connect(timHea.passed, booToRea1.u) annotation (Line(points={{-18,12},{-12,12},
          {-12,20},{8,20}}, color={255,0,255}));
  connect(timHea.passed, or2.u2) annotation (Line(points={{-18,12},{-12,12},{-12,
          -108},{18,-108}}, color={255,0,255}));
  annotation (defaultComponentName="conVarFanConWat",
    Icon(coordinateSystem(preserveAspectRatio=false,
      extent={{-140,-120},{120,120}}),
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
      extent={{-140,-120},{120,120}})),
    Documentation(info="<html>
      <p>
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
      (<code>yFanSpe = 1</code>). <code>yHea</code> and <code>yCoo</code> are set 
      to <code>zero</code>.
      </li>
      </ul>
      </p>
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
end VariableFan_ConstantWaterFlowrate;
