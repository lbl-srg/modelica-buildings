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
    annotation (Placement(transformation(extent={{-160,40},{-120,80}}),
      iconTransformation(extent={{-140,20},{-100,60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TCooSet(
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature")
    "Zone cooling temperature setpoint"
    annotation (Placement(transformation(extent={{-160,0},{-120,40}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaSet(
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature")
    "Zone heating temperature setpoint"
    annotation (Placement(transformation(extent={{-160,-40},{-120,0}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yFan
    "Fan enable signal"
    annotation (Placement(transformation(extent={{100,-100},{140,-60}}),
      iconTransformation(extent={{100,-80},{140,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yFanSpe(
    final unit="1",
    displayUnit="1")
    "Fan speed signal"
    annotation (Placement(transformation(extent={{100,-50},{140,-10}}),
      iconTransformation(extent={{100,-40},{140,0}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yCoo(
    final unit="1",
    displayUnit="1")
    "Cooling signal"
    annotation (Placement(transformation(extent={{100,40},{140,80}}),
      iconTransformation(extent={{100,40},{140,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yHea(
    final unit="1",
    displayUnit="1")
    "Heating signal"
    annotation (Placement(transformation(extent={{100,0},{140,40}}),
      iconTransformation(extent={{100,0},{140,40}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.TimeTable timTabOccSch(
    final table=tableOcc,
    final smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments,
    final timeScale=timeScaleOcc)
    "Table with occupancy schedule for the zone"
    annotation (Placement(transformation(extent={{-110,-100},{-90,-80}})));

protected
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea2
    "Convert fan enable signal to real value for manipulating fan speed"
    annotation (Placement(transformation(extent={{40,-70},{60,-50}})));

  Buildings.Controls.OBC.CDL.Continuous.Multiply mul
    "Pass non-zero fan speed signal only when it is enabled"
    annotation (Placement(transformation(extent={{70,-40},{90,-20}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys1(
    final uLow=-dTHys,
    final uHigh=0)
    "Enable cooling when zone temperature is higher than cooling setpoint"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));

  Buildings.Controls.OBC.CDL.Continuous.Subtract sub2
    "Find difference between zone temperature and cooling setpoint"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea
    "Boolean to Real conversion"
    annotation (Placement(transformation(extent={{0,60},{20,80}})));

  Buildings.Controls.OBC.CDL.Continuous.Subtract sub1
    "Find difference between zone temperature and heating setpoint"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys2(
    final uLow=-dTHys,
    final uHigh=0)
    "Enable heating when zone temperature is lower than heating setpoint"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1
    "Boolean to Real conversion"
    annotation (Placement(transformation(extent={{0,10},{20,30}})));

  Buildings.Controls.OBC.CDL.Logical.Or or2
    "Enable fan in heating mode and cooling mode"
    annotation (Placement(transformation(extent={{0,-100},{20,-80}})));

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
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));

  Buildings.Controls.OBC.CDL.Continuous.Add add3
    "Pass sum of fan speed from heating and cooling controllers, one of which is always zero"
    annotation (Placement(transformation(extent={{30,-40},{50,-20}})));

  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr[1](
    final t=fill(0.5, 1))
    "Check if zone is occupied"
    annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));

  Buildings.Controls.OBC.CDL.Logical.Or or1
    "Enable fan when zone is occupied or when setpoint is violated"
    annotation (Placement(transformation(extent={{40,-100},{60,-80}})));

equation
  connect(TZon,sub2. u1) annotation (Line(points={{-140,60},{-100,60},{-100,76},
          {-82,76}},color={0,0,127}));

  connect(TCooSet,sub2. u2) annotation (Line(points={{-140,20},{-110,20},{-110,64},
          {-82,64}}, color={0,0,127}));

  connect(sub2.y, hys1.u)
    annotation (Line(points={{-58,70},{-42,70}}, color={0,0,127}));

  connect(hys1.y, booToRea.u)
    annotation (Line(points={{-18,70},{-2,70}}, color={255,0,255}));

  connect(booToRea.y, yCoo) annotation (Line(points={{22,70},{60,70},{60,60},{
          120,60}}, color={0,0,127}));

  connect(sub1.y, hys2.u)
    annotation (Line(points={{-58,20},{-42,20}}, color={0,0,127}));

  connect(hys2.y, booToRea1.u)
    annotation (Line(points={{-18,20},{-2,20}}, color={255,0,255}));

  connect(TZon,sub1. u2) annotation (Line(points={{-140,60},{-100,60},{-100,14},
          {-82,14}},color={0,0,127}));

  connect(THeaSet,sub1. u1) annotation (Line(points={{-140,-20},{-90,-20},{-90,26},
          {-82,26}},     color={0,0,127}));

  connect(booToRea1.y, yHea)
    annotation (Line(points={{22,20},{120,20}}, color={0,0,127}));

  connect(hys1.y, or2.u1) annotation (Line(points={{-18,70},{-10,70},{-10,-90},{
          -2,-90}},  color={255,0,255}));

  connect(hys2.y, or2.u2) annotation (Line(points={{-18,20},{-14,20},{-14,-98},{
          -2,-98}},  color={255,0,255}));

  connect(sub2.y, conPID.u_m) annotation (Line(points={{-58,70},{-50,70},{-50,
          -26},{10,-26},{10,-22}}, color={0,0,127}));

  connect(sub1.y, conPID1.u_m) annotation (Line(points={{-58,20},{-54,20},{-54,-68},
          {10,-68},{10,-62}},      color={0,0,127}));

  connect(con.y, conPID.u_s) annotation (Line(points={{-58,-10},{-2,-10}},
                          color={0,0,127}));

  connect(con.y, conPID1.u_s) annotation (Line(points={{-58,-10},{-20,-10},{-20,
          -50},{-2,-50}}, color={0,0,127}));

  connect(conPID.y, add3.u1) annotation (Line(points={{22,-10},{26,-10},{26,-24},
          {28,-24}}, color={0,0,127}));

  connect(conPID1.y, add3.u2) annotation (Line(points={{22,-50},{26,-50},{26,-36},
          {28,-36}},      color={0,0,127}));

  connect(timTabOccSch.y, greThr.u)
    annotation (Line(points={{-88,-90},{-82,-90}}, color={0,0,127}));
  connect(or2.y, or1.u2) annotation (Line(points={{22,-90},{26,-90},{26,-98},{38,
          -98}}, color={255,0,255}));
  connect(greThr[1].y, or1.u1) annotation (Line(points={{-58,-90},{-40,-90},{-40,
          -110},{30,-110},{30,-90},{38,-90}}, color={255,0,255}));
  connect(or1.y, yFan) annotation (Line(points={{62,-90},{80,-90},{80,-80},{120,
          -80}}, color={255,0,255}));
  connect(or1.y, booToRea2.u) annotation (Line(points={{62,-90},{80,-90},{80,-74},
          {30,-74},{30,-60},{38,-60}}, color={255,0,255}));
  connect(mul.y, yFanSpe)
    annotation (Line(points={{92,-30},{120,-30}}, color={0,0,127}));
  connect(booToRea2.y, mul.u2) annotation (Line(points={{62,-60},{66,-60},{66,-36},
          {68,-36}}, color={0,0,127}));
  connect(add3.y, mul.u1) annotation (Line(points={{52,-30},{60,-30},{60,-24},{68,
          -24}}, color={0,0,127}));
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
      extent={{-120,-120},{100,100}})),
    Documentation(info="<html>
      <p>
      This is a control module for the fan coil unit (FCU) system model designed as an 
      analogue to the <code>ConstantFanVariableFlow</code> capacity control method 
      in EnergyPlus. The control logic is as described in the following section 
      and can also be seen in the logic chart.
      <br>
      <ul>
      <li>
      When the zone temperature <code>TZon</code> is above the cooling setpoint
      temperature <code>TCooSet</code>, the FCU enters cooling mode operation.
      The fan is enabled (<code>yFan = True</code>) and is run at the maximum speed
      (<code>yFanSpe = 1</code>). The cooling signal <code>yCoo</code> is used to
      regulate <code>TZon</code> at <code>TCooSet</code>.
      </li>
      <li>
      When <code>TZon</code> is below the heating setpoint
      temperature <code>THeaSet</code>, the FCU enters heating mode operation.
      The fan is enabled (<code>yFan = True</code>) and is run at the maximum speed
      (<code>yFanSpe = 1</code>). The heating signal <code>yHea</code> is used to
      regulate <code>TZon</code> at <code>THeaSet</code>.
      </li>
      <li>
      When the zone temperature <code>TZon</code> is between <code>THeaSet</code>
      and <code>TCooSet</code>, the FCU enters deadband mode. If the zone is occupied 
      as per the occupancy schedule (<code>conVarWatConFan.timTabOccSch.y = 1</code>),
      the fan is enabled (<code>yFan = True</code>) and is run at the maximum speed
      (<code>yFanSpe = 1</code>). <code>yHea</code> and <code>yCoo</code> are set 
      to <code>zero</code>.
      </li>
      </ul>
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
