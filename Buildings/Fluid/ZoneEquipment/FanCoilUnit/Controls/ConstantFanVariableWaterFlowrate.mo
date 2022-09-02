within Buildings.Fluid.ZoneEquipment.FanCoilUnit.Controls;
block ConstantFanVariableWaterFlowrate
  "Controller for fan coil system with variable water flow rates and fixed speed fan"

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeCoo=Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of cooling loop controller"
    annotation (Dialog(group="Cooling mode control"));

  parameter Real kCoo(
    final unit="1",
    displayUnit="1",
    final min=0)=1
    "Gain of cooling loop controller"
    annotation(Dialog(group="Cooling mode control"));

  parameter Modelica.Units.SI.Time TiCoo=0.5
    "Time constant of cooling loop integrator block"
    annotation(Dialog(group="Cooling mode control",
      enable = controllerTypeCoo == Buildings.Controls.OBC.CDL.Types.SimpleController.PI or
      controllerTypeCoo == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Modelica.Units.SI.Time TdCoo=0.1
    "Time constant of cooling loop derivative block"
    annotation(Dialog(group="Cooling mode control",
      enable = controllerTypeCoo == Buildings.Controls.OBC.CDL.Types.SimpleController.PD or
      controllerTypeCoo == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeHea=Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of heating loop controller"
    annotation(Dialog(group="Heating mode control"));

  parameter Real kHea(
    final unit="1",
    displayUnit="1",
    final min=0)=1
    "Gain of heating loop controller"
    annotation(Dialog(group="Heating mode control"));

  parameter Modelica.Units.SI.Time TiHea=0.5
    "Time constant of heating loop integrator block"
    annotation(Dialog(group="Heating mode control",
      enable = controllerTypeHea == Buildings.Controls.OBC.CDL.Types.SimpleController.PI or
      controllerTypeHea == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Modelica.Units.SI.Time TdHea=0.1
    "Time constant of heating loop derivative block"
    annotation(Dialog(group="Heating mode control",
      enable = controllerTypeHea == Buildings.Controls.OBC.CDL.Types.SimpleController.PD or
      controllerTypeHea == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Integer nRowOccSch(
    final min = 2) = 4
    "Number of rows in the occupancy schedule table"
    annotation(Dialog(group="Occupancy schedule parameters"));

  parameter Modelica.Units.SI.Time tableOcc[nRowOccSch,2] = [0, 0; 6, 1; 18, 0; 24, 0]
    "Table matrix (time = first column) for the occupancy schedule"
    annotation(Dialog(group="Occupancy schedule parameters"));

  parameter Modelica.Units.SI.Time timeScaleOcc = 3600
    "Time scale of first table column. Set to 3600 if time in table is in hours"
    annotation(Dialog(group="Occupancy schedule parameters"));

  parameter Real minFanSpe(
    final unit="1",
    displayUnit="1",
    final min=0,
    final max=1) = 0.4
    "Minimum allowed fan speed"
    annotation(Dialog(group="System parameters"));

  parameter Modelica.Units.SI.Time tFanEnaDel = 30
    "Time period for delay between switching from deadband mode to heating/cooling mode"
    annotation(Dialog(group="System parameters"));

  parameter Modelica.Units.SI.Time tFanEna = 300
    "Minimum duration for which fan is enabled"
    annotation(Dialog(group="System parameters"));

  parameter Modelica.Units.SI.TemperatureDifference dTHys = 0.2
    "Temperature difference used for enabling cooling and heating mode"
    annotation(Dialog(tab="Advanced"));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uFan
    "Fan proven on signal"
    annotation (Placement(transformation(extent={{-160,40},{-120,80}}),
      iconTransformation(extent={{-140,40},{-100,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon(
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature")
    "Measured zone temperature"
    annotation (Placement(transformation(extent={{-160,-10},{-120,30}}),
      iconTransformation(extent={{-140,0},{-100,40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TCooSet(
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature")
    "Zone cooling temperature setpoint"
    annotation (Placement(transformation(extent={{-160,-50},{-120,-10}}),
      iconTransformation(extent={{-140,-40},{-100,0}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaSet(
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature")
    "Zone heating temperature setpoint"
    annotation (Placement(transformation(extent={{-160,-90},{-120,-50}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));

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

  Buildings.Controls.OBC.CDL.Continuous.Sources.TimeTable timTabOccSch(
    final table=tableOcc,
    final smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments,
    final timeScale=timeScaleOcc)
    "Table with occupancy schedule for the zone"
    annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Switch swi
    "Pass minimum fan speed if zone is occupied and is in deadband mode"
    annotation (Placement(transformation(extent={{110,-40},{130,-20}})));

  Buildings.Controls.OBC.CDL.Logical.And andDeaOcc
    "Check if zone is in deadband mode and is occupied"
    annotation (Placement(transformation(extent={{80,-40},{100,-20}})));

  Buildings.Controls.OBC.CDL.Logical.Not notHeaCoo
    "Check if zone is in deadband mode"
    annotation (Placement(transformation(extent={{30,-40},{50,-20}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conMinFanSpe(final k=
        minFanSpe) "Minimum fan speed signal"
    annotation (Placement(transformation(extent={{56,-20},{76,0}})));

  Buildings.Controls.OBC.CDL.Logical.Timer timFan(
    final t=tFanEnaDel)
    "Time delay for switching on fan"
    annotation (Placement(transformation(extent={{30,-110},{50,-90}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea
    "Convert fan proven on signal to real value"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));

  Buildings.Controls.OBC.CDL.Continuous.Multiply mulCoo
    "Enable cooling coil valve only when fan is proven on"
    annotation (Placement(transformation(extent={{60,50},{80,70}})));

  Buildings.Controls.OBC.CDL.Continuous.Multiply mulHea
    "Enable heating coil valve only when fan is proven on"
    annotation (Placement(transformation(extent={{60,10},{80,30}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hysCoo(final uLow=-dTHys,
      final uHigh=0)
    "Enable cooling mode when zone temperature is higher than cooling setpoint"
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));

  Buildings.Controls.OBC.CDL.Continuous.Subtract subCoo
    "Find difference between zone temperature and cooling setpoint"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));

  Buildings.Controls.OBC.CDL.Continuous.Subtract subHea
    "Find difference between zone temperature and heating setpoint"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hysHea(final uLow=-dTHys,
      final uHigh=0)
    "Enable heating mode when zone temperature is lower than heating setpoint"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToReaFanSpe
    "Boolean to Real conversion for fan speed in heating or cooling mode"
    annotation (Placement(transformation(extent={{100,-70},{120,-50}})));

  Buildings.Controls.OBC.CDL.Logical.Or orHeaCoo
    "Enable fan in heating mode and cooling mode"
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));

  Buildings.Controls.OBC.CDL.Continuous.PID conPIDCoo(
    final controllerType=controllerTypeCoo,
    final k=kCoo,
    final Ti=TiCoo,
    final Td=TdCoo,
    final reverseActing=false) "PI controller for fan speed in cooling mode"
    annotation (Placement(transformation(extent={{20,50},{40,70}})));

  Buildings.Controls.OBC.CDL.Continuous.PID conPIDHea(
    final controllerType=controllerTypeHea,
    final k=kHea,
    final Ti=TiHea,
    final Td=TdHea,
    final reverseActing=false) "PI controller for fan speed in heating mode"
    annotation (Placement(transformation(extent={{20,10},{40,30}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conZero(final k=0)
    "Constant zero signal"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));

  Buildings.Controls.OBC.CDL.Logical.Or or1
    "Enable fan when zone is occupied or when setpoints are exceeded"
    annotation (Placement(transformation(extent={{60,-90},{80,-70}})));

  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr[1](
    final t=fill(0.5, 1))
    "Check if zone is occupied"
    annotation (Placement(transformation(extent={{-10,-100},{10,-80}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol(
    final trueHoldDuration=tFanEna,
    final falseHoldDuration=0)
    "Keep fan enabled for minimum duration"
    annotation (Placement(transformation(extent={{100,-110},{120,-90}})));

equation
  connect(TZon, subCoo.u1) annotation (Line(points={{-140,10},{-114,10},{-114,26},
          {-82,26}}, color={0,0,127}));

  connect(TCooSet, subCoo.u2) annotation (Line(points={{-140,-30},{-110,-30},{-110,
          14},{-82,14}}, color={0,0,127}));

  connect(subCoo.y, hysCoo.u) annotation (Line(points={{-58,20},{-50,20},{-50,-20},
          {-42,-20}}, color={0,0,127}));

  connect(subHea.y, hysHea.u) annotation (Line(points={{-58,-30},{-54,-30},{-54,
          -60},{-42,-60}}, color={0,0,127}));

  connect(TZon, subHea.u2) annotation (Line(points={{-140,10},{-114,10},{-114,-36},
          {-82,-36}}, color={0,0,127}));

  connect(THeaSet, subHea.u1) annotation (Line(points={{-140,-70},{-108,-70},{-108,
          -24},{-82,-24}}, color={0,0,127}));

  connect(hysCoo.y, orHeaCoo.u1) annotation (Line(points={{-18,-20},{-16,-20},{-16,
          -40},{-12,-40}}, color={255,0,255}));

  connect(hysHea.y, orHeaCoo.u2) annotation (Line(points={{-18,-60},{-16,-60},{-16,
          -48},{-12,-48}}, color={255,0,255}));

  connect(subCoo.y, conPIDCoo.u_m) annotation (Line(points={{-58,20},{-50,20},{-50,
          40},{30,40},{30,48}}, color={0,0,127}));

  connect(subHea.y, conPIDHea.u_m) annotation (Line(points={{-58,-30},{-54,-30},
          {-54,0},{30,0},{30,8}}, color={0,0,127}));

  connect(conZero.y, conPIDCoo.u_s) annotation (Line(points={{-18,20},{-10,20},{
          -10,60},{18,60}}, color={0,0,127}));

  connect(conZero.y, conPIDHea.u_s)
    annotation (Line(points={{-18,20},{18,20}}, color={0,0,127}));

  connect(timTabOccSch.y, greThr.u) annotation (Line(points={{-58,-90},{-12,-90}},
                               color={0,0,127}));
  connect(greThr[1].y, or1.u1) annotation (Line(points={{12,-90},{26,-90},{26,-80},
          {58,-80}}, color={255,0,255}));
  connect(booToReaFanSpe.y, swi.u3) annotation (Line(points={{122,-60},{128,-60},
          {128,-44},{106,-44},{106,-38},{108,-38}}, color={0,0,127}));
  connect(andDeaOcc.y, swi.u2)
    annotation (Line(points={{102,-30},{108,-30}}, color={255,0,255}));
  connect(notHeaCoo.y, andDeaOcc.u1)
    annotation (Line(points={{52,-30},{78,-30}}, color={255,0,255}));
  connect(greThr[1].y, andDeaOcc.u2) annotation (Line(points={{12,-90},{26,-90},
          {26,-50},{64,-50},{64,-38},{78,-38}}, color={255,0,255}));
  connect(orHeaCoo.y, notHeaCoo.u) annotation (Line(points={{12,-40},{20,-40},{20,
          -30},{28,-30}}, color={255,0,255}));
  connect(swi.y, yFanSpe) annotation (Line(points={{132,-30},{138,-30},{138,-30},
          {160,-30}}, color={0,0,127}));
  connect(conMinFanSpe.y, swi.u1) annotation (Line(points={{78,-10},{106,-10},{106,
          -22},{108,-22}}, color={0,0,127}));
  connect(or1.y, booToReaFanSpe.u) annotation (Line(points={{82,-80},{90,-80},{90,
          -60},{98,-60}}, color={255,0,255}));
  connect(orHeaCoo.y, timFan.u) annotation (Line(points={{12,-40},{20,-40},{20,-100},
          {28,-100}}, color={255,0,255}));
  connect(timFan.passed, or1.u2) annotation (Line(points={{52,-108},{54,-108},{54,
          -88},{58,-88}}, color={255,0,255}));
  connect(uFan, booToRea.u) annotation (Line(points={{-140,60},{-100,60},{-100,80},
          {-82,80}}, color={255,0,255}));
  connect(conPIDCoo.y, mulCoo.u2) annotation (Line(points={{42,60},{50,60},{50,54},
          {58,54}}, color={0,0,127}));
  connect(booToRea.y, mulCoo.u1) annotation (Line(points={{-58,80},{52,80},{52,66},
          {58,66}}, color={0,0,127}));
  connect(mulCoo.y, yCoo)
    annotation (Line(points={{82,60},{160,60}}, color={0,0,127}));
  connect(mulHea.y, yHea)
    annotation (Line(points={{82,20},{160,20}}, color={0,0,127}));
  connect(conPIDHea.y, mulHea.u2) annotation (Line(points={{42,20},{50,20},{50,14},
          {58,14}}, color={0,0,127}));
  connect(booToRea.y, mulHea.u1) annotation (Line(points={{-58,80},{52,80},{52,26},
          {58,26}}, color={0,0,127}));
  connect(or1.y, truFalHol.u) annotation (Line(points={{82,-80},{90,-80},{90,-100},
          {98,-100}}, color={255,0,255}));
  connect(truFalHol.y, yFan) annotation (Line(points={{122,-100},{130,-100},{130,
          -80},{160,-80}}, color={255,0,255}));
  annotation (defaultComponentName="conVarWatConFan",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
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
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,-120},{140,
            100}})),
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
end ConstantFanVariableWaterFlowrate;
