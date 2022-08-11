within Buildings.Fluid.ZoneEquipment.FanCoilUnit.Controls;
block ConstantFan_VariableWaterFlowrate
  "Controller for fan coil system with variable water flow rates and fixed speed fan"

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeCoo=Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller for cooling loop signal"
    annotation (Dialog(group="Cooling mode control"));

  parameter Real kCoo(
    final unit="1",
    displayUnit="1",
    final min=0)=1
    "Gain of controller for cooling loop signal"
    annotation(Dialog(group="Cooling mode control"));

  parameter Real TiCoo(
    final unit="s",
    displayUnit="s",
    final quantity="Time",
    final min=0)=0.5
    "Time constant of integrator block for cooling loop signal"
    annotation(Dialog(group="Cooling mode control",
      enable = controllerTypeCoo == Buildings.Controls.OBC.CDL.Types.SimpleController.PI or
      controllerTypeCoo == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Real TdCoo(
    final unit="s",
    displayUnit="s",
    final quantity="Time",
    final min=0)=0.1
    "Time constant of derivative block for cooling loop signal"
    annotation(Dialog(group="Cooling mode control",
      enable = controllerTypeCoo == Buildings.Controls.OBC.CDL.Types.SimpleController.PD or
      controllerTypeCoo == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeHea=Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller for heating loop signal"
    annotation(Dialog(group="Heating mode control"));

  parameter Real kHea(
    final unit="1",
    displayUnit="1",
    final min=0)=1
    "Gain of controller for heating loop signal"
    annotation(Dialog(group="Heating mode control"));

  parameter Real TiHea(
    final unit="s",
    displayUnit="s",
    final quantity="Time",
    final min=0)=0.5
    "Time constant of integrator block for heating loop signal"
    annotation(Dialog(group="Heating mode control",
      enable = controllerTypeHea == Buildings.Controls.OBC.CDL.Types.SimpleController.PI or
      controllerTypeHea == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Real TdHea(
    final unit="s",
    displayUnit="s",
    final quantity="Time",
    final min=0)=0.1
    "Time constant of derivative block for heating loop signal"
    annotation(Dialog(group="Heating mode control",
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
    final quantity="TemperatureDifference",
    final min=0) = 0.2
    "Temperature difference used for enabling cooling and heating mode"
    annotation(Dialog(tab="Advanced"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon(
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature")
    "Measured zone temperature"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
      iconTransformation(extent={{-140,20},{-100,60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TCooSet(
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature")
    "Zone cooling temperature setpoint"
    annotation (Placement(transformation(extent={{-140,0},{-100,40}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaSet(
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature")
    "Zone heating temperature setpoint"
    annotation (Placement(transformation(extent={{-140,-40},{-100,0}}),
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
    annotation (Placement(transformation(extent={{-90,-60},{-70,-40}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys1(
    final uLow=-dTHys,
    final uHigh=0)
    "Enable cooling when zone temperature is higher than cooling setpoint"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));

  Buildings.Controls.OBC.CDL.Continuous.Subtract sub2
    "Find difference between zone temperature and cooling setpoint"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));

  Buildings.Controls.OBC.CDL.Continuous.Subtract sub1
    "Find difference between zone temperature and heating setpoint"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys2(
    final uLow=-dTHys,
    final uHigh=0)
    "Enable heating when zone temperature is lower than heating setpoint"
    annotation (Placement(transformation(extent={{-40,-90},{-20,-70}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1
    "Boolean to Real conversion"
    annotation (Placement(transformation(extent={{70,-40},{90,-20}})));

  Buildings.Controls.OBC.CDL.Logical.Or or2
    "Enable fan in heating mode and cooling mode"
    annotation (Placement(transformation(extent={{0,-70},{20,-50}})));

  Buildings.Controls.OBC.CDL.Continuous.PID conPID(
    final controllerType=controllerTypeCoo,
    final k=kCoo,
    final Ti=TiCoo,
    final Td=TdCoo,
    final reverseActing=false)
    "PI controller for fan speed in cooling mode"
    annotation (Placement(transformation(extent={{20,50},{40,70}})));

  Buildings.Controls.OBC.CDL.Continuous.PID conPID1(
    final controllerType=controllerTypeHea,
    final k=kHea,
    final Ti=TiHea,
    final Td=TdHea,
    final reverseActing=false)
    "PI controller for fan speed in heating mode"
    annotation (Placement(transformation(extent={{20,10},{40,30}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(
    final k=0)
    "Constant zero signal"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));

  Buildings.Controls.OBC.CDL.Logical.Or or1
    "Enable fan when zone is occupied or when setpoints are exceeded"
    annotation (Placement(transformation(extent={{40,-50},{60,-30}})));

  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr[1](
    final t=fill(0.5, 1))
    "Check if zone is occupied"
    annotation (Placement(transformation(extent={{0,-30},{20,-10}})));

equation
  connect(TZon,sub2. u1) annotation (Line(points={{-120,60},{-94,60},{-94,76},{
          -82,76}}, color={0,0,127}));

  connect(TCooSet,sub2. u2) annotation (Line(points={{-120,20},{-90,20},{-90,64},
          {-82,64}}, color={0,0,127}));

  connect(sub2.y, hys1.u)
    annotation (Line(points={{-58,70},{-50,70},{-50,-40},{-42,-40}},
                                                 color={0,0,127}));

  connect(sub1.y, hys2.u)
    annotation (Line(points={{-58,20},{-54,20},{-54,-80},{-42,-80}},
                                                 color={0,0,127}));

  connect(TZon,sub1. u2) annotation (Line(points={{-120,60},{-94,60},{-94,14},{
          -82,14}}, color={0,0,127}));

  connect(THeaSet,sub1. u1) annotation (Line(points={{-120,-20},{-88,-20},{-88,
          26},{-82,26}}, color={0,0,127}));

  connect(hys1.y, or2.u1) annotation (Line(points={{-18,-40},{-10,-40},{-10,-60},
          {-2,-60}}, color={255,0,255}));

  connect(hys2.y, or2.u2) annotation (Line(points={{-18,-80},{-10,-80},{-10,-68},
          {-2,-68}}, color={255,0,255}));

  connect(sub2.y, conPID.u_m) annotation (Line(points={{-58,70},{-50,70},{-50,40},
          {30,40},{30,48}},        color={0,0,127}));

  connect(sub1.y, conPID1.u_m) annotation (Line(points={{-58,20},{-54,20},{-54,0},
          {30,0},{30,8}},          color={0,0,127}));

  connect(con.y, conPID.u_s) annotation (Line(points={{-18,70},{-10,70},{-10,60},
          {18,60}},       color={0,0,127}));

  connect(con.y, conPID1.u_s) annotation (Line(points={{-18,70},{-10,70},{-10,20},
          {18,20}},       color={0,0,127}));

  connect(booToRea1.y, yFanSpe)
    annotation (Line(points={{92,-30},{120,-30}}, color={0,0,127}));
  connect(conPID1.y, yHea)
    annotation (Line(points={{42,20},{120,20}}, color={0,0,127}));
  connect(conPID.y, yCoo)
    annotation (Line(points={{42,60},{120,60}}, color={0,0,127}));
  connect(timTabOccSch.y, greThr.u) annotation (Line(points={{-68,-50},{-60,-50},
          {-60,-20},{-2,-20}}, color={0,0,127}));
  connect(greThr[1].y, or1.u1) annotation (Line(points={{22,-20},{30,-20},{30,-40},
          {38,-40}}, color={255,0,255}));
  connect(or2.y, or1.u2) annotation (Line(points={{22,-60},{30,-60},{30,-48},{38,
          -48}}, color={255,0,255}));
  connect(or1.y, booToRea1.u) annotation (Line(points={{62,-40},{66,-40},{66,-30},
          {68,-30}}, color={255,0,255}));
  connect(or1.y, yFan) annotation (Line(points={{62,-40},{66,-40},{66,-80},{120,
          -80}}, color={255,0,255}));
  annotation (defaultComponentName="conVarWatConFan",
    Icon(coordinateSystem(preserveAspectRatio=false),
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
    Diagram(coordinateSystem(preserveAspectRatio=false)),
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
end ConstantFan_VariableWaterFlowrate;
