within Buildings.Fluid.ZoneEquipment.BaseClasses;
block VariableFan
  "Controller for variable speed fan"

  parameter Boolean has_hea
    "The zonal HVAC system has a heating coil";

  parameter Boolean has_coo
    "The zonal HVAC system has a cooling coil";

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
  parameter Modelica.Units.SI.TemperatureDifference dTHys = 0.2
    "Temperature difference used for enabling coooling and heating mode"
    annotation(Dialog(tab="Advanced"));

  Modelica.Blocks.Interfaces.BooleanInput uAva "Availability signal"
    annotation (Placement(transformation(extent={{-180,-100},{-140,-60}}),
      iconTransformation(extent={{-180,-140},{-140,-100}})));

  Modelica.Blocks.Interfaces.RealInput TZon(
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature")
    "Measured zone temperature"
    annotation (Placement(transformation(extent={{-180,40},{-140,80}}),
      iconTransformation(extent={{-180,100},{-140,140}})));

  Modelica.Blocks.Interfaces.RealInput TCooSet(
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature") if has_coo
    "Zone cooling temperature setpoint"
    annotation (Placement(transformation(extent={{-180,0},{-140,40}}),
      iconTransformation(extent={{-180,20},{-140,60}})));

  Modelica.Blocks.Interfaces.RealInput THeaSet(
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature") if has_hea
    "Zone heating temperature setpoint"
    annotation (Placement(transformation(extent={{-180,-40},{-140,0}}),
      iconTransformation(extent={{-180,-60},{-140,-20}})));

  Modelica.Blocks.Interfaces.BooleanOutput yFan
    "Fan enable signal"
    annotation (Placement(transformation(extent={{140,-100},{180,-60}}),
      iconTransformation(extent={{140,-60},{180,-20}})));

  Modelica.Blocks.Interfaces.RealOutput yFanSpe(
    final unit="1",
    displayUnit="1")
    "Fan speed signal"
    annotation (Placement(transformation(extent={{140,-50},{180,-10}}),
      iconTransformation(extent={{140,20},{180,60}})));

  Controls.OBC.CDL.Logical.Sources.Constant conHea(k=false) if not has_hea
    "Constant false signal if heating mode is not available"
    annotation (Placement(transformation(extent={{-130,-110},{-110,-90}})));
  Controls.OBC.CDL.Logical.Sources.Constant conCoo(k=false) if not has_coo
    "Constant false signal if cooling mode is not available"
    annotation (Placement(transformation(extent={{-130,-60},{-110,-40}})));
protected
  Buildings.Controls.OBC.CDL.Continuous.Max max
    "Ensure fan speed is always equal to or greater than minimum fan speed"
    annotation (Placement(transformation(extent={{100,-40},{120,-20}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHolFanEna(
    final trueHoldDuration=tFanEna,
    final falseHoldDuration=0)
    "Keep fan enabled for minimum duration"
    annotation (Placement(transformation(extent={{108,-110},{128,-90}})));

  Buildings.Controls.OBC.CDL.Logical.Timer timFan(
    final t=tFanEnaDel)
    "Time delay for switching on the fan"
    annotation (Placement(transformation(extent={{30,-110},{50,-90}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hysCoo(
    final uLow=-dTHys,
    final uHigh=0) if has_coo
    "Enable cooling when zone temperature is higher than cooling setpoint"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));

  Buildings.Controls.OBC.CDL.Continuous.Subtract subCoo if has_coo
    "Find difference between zone temperature and cooling setpoint"
    annotation (Placement(transformation(extent={{-110,60},{-90,80}})));

  Buildings.Controls.OBC.CDL.Continuous.Subtract subHea if has_hea
    "Find difference between zone temperature and heating setpoint"
    annotation (Placement(transformation(extent={{-110,10},{-90,30}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hysHea(
    final uLow=-dTHys,
    final uHigh=0) if has_hea
    "Enable heating when zone temperature is lower than heating setpoint"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));

  Buildings.Controls.OBC.CDL.Logical.Or orHeaCoo
    "Enable fan in heating mode and cooling mode"
    annotation (Placement(transformation(extent={{0,-110},{20,-90}})));

  Buildings.Controls.OBC.CDL.Continuous.PID conPIDCoo(
    final controllerType=controllerTypeCoo,
    final k=kCoo,
    final Ti=TiCoo,
    final Td=TdCoo,
    final reverseActing=false) "PI controller for fan speed in cooling mode"
    annotation (Placement(transformation(extent={{0,-20},{20,0}})));

  Buildings.Controls.OBC.CDL.Continuous.PID conPIDHea(
    final controllerType=controllerTypeHea,
    final k=kHea,
    final Ti=TiHea,
    final Td=TdHea,
    final reverseActing=false) "PI controller for fan speed in heating mode"
    annotation (Placement(transformation(extent={{0,-60},{20,-40}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conZer(
    final k=0)
    "Constant zero signal"
    annotation (Placement(transformation(extent={{-110,-20},{-90,0}})));

  Buildings.Controls.OBC.CDL.Continuous.Add addFanSpe
    "Pass sum of fan speed from heating and cooling controllers, one of which is always zero"
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));

  Buildings.Controls.OBC.CDL.Logical.And andHeaCooOcc
    "Enable fan only when system is available"
    annotation (Placement(transformation(extent={{80,-110},{100,-90}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conMinFanSpe(
    final k=minFanSpe)
    "Minimum fan speed signal"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));

equation
  connect(TZon, subCoo.u1) annotation (Line(points={{-160,60},{-130,60},{-130,76},
          {-112,76}}, color={0,0,127}));

  connect(TCooSet, subCoo.u2) annotation (Line(points={{-160,20},{-136,20},{-136,
          64},{-112,64}}, color={0,0,127}));

  connect(subCoo.y, hysCoo.u)
    annotation (Line(points={{-88,70},{-42,70}}, color={0,0,127}));

  connect(subHea.y, hysHea.u)
    annotation (Line(points={{-88,20},{-42,20}}, color={0,0,127}));

  connect(TZon, subHea.u2) annotation (Line(points={{-160,60},{-130,60},{-130,14},
          {-112,14}}, color={0,0,127}));

  connect(THeaSet, subHea.u1) annotation (Line(points={{-160,-20},{-120,-20},{-120,
          26},{-112,26}}, color={0,0,127}));

  connect(subCoo.y, conPIDCoo.u_m) annotation (Line(points={{-88,70},{-80,70},{-80,
          -26},{10,-26},{10,-22}}, color={0,0,127}));

  connect(subHea.y, conPIDHea.u_m) annotation (Line(points={{-88,20},{-84,20},{-84,
          -68},{10,-68},{10,-62}}, color={0,0,127}));

  connect(conZer.y, conPIDCoo.u_s)
    annotation (Line(points={{-88,-10},{-2,-10}}, color={0,0,127}));

  connect(conZer.y, conPIDHea.u_s) annotation (Line(points={{-88,-10},{-20,-10},
          {-20,-50},{-2,-50}}, color={0,0,127}));

  connect(conPIDHea.y, addFanSpe.u2) annotation (Line(points={{22,-50},{30,-50},
          {30,-36},{38,-36}}, color={0,0,127}));
  connect(conPIDCoo.y, addFanSpe.u1) annotation (Line(points={{22,-10},{30,-10},
          {30,-24},{38,-24}}, color={0,0,127}));
  connect(orHeaCoo.y, timFan.u)
    annotation (Line(points={{22,-100},{28,-100}}, color={255,0,255}));
  connect(timFan.passed, andHeaCooOcc.u2)
    annotation (Line(points={{52,-108},{78,-108}}, color={255,0,255}));
  connect(hysCoo.y, orHeaCoo.u1) annotation (Line(points={{-18,70},{-6,70},{-6,-100},
          {-2,-100}}, color={255,0,255}));
  connect(hysHea.y, orHeaCoo.u2) annotation (Line(points={{-18,20},{-14,20},{-14,
          -108},{-2,-108}}, color={255,0,255}));
  connect(andHeaCooOcc.y, truFalHolFanEna.u)
    annotation (Line(points={{102,-100},{106,-100}}, color={255,0,255}));
  connect(truFalHolFanEna.y, yFan) annotation (Line(points={{130,-100},{134,-100},
          {134,-80},{160,-80}}, color={255,0,255}));

  connect(uAva, andHeaCooOcc.u1) annotation (Line(points={{-160,-80},{72,-80},{
          72,-100},{78,-100}}, color={255,0,255}));
  connect(max.y, yFanSpe)
    annotation (Line(points={{122,-30},{160,-30}}, color={0,0,127}));
  connect(conMinFanSpe.y, max.u1) annotation (Line(points={{62,0},{80,0},{80,
          -24},{98,-24}}, color={0,0,127}));
  connect(addFanSpe.y, max.u2) annotation (Line(points={{62,-30},{80,-30},{80,
          -36},{98,-36}}, color={0,0,127}));
  connect(conCoo.y, orHeaCoo.u1) annotation (Line(points={{-108,-50},{-92,-50},{
          -92,-100},{-2,-100}}, color={255,0,255}));
  connect(conHea.y, orHeaCoo.u2) annotation (Line(points={{-108,-100},{-100,-100},
          {-100,-108},{-2,-108}}, color={255,0,255}));
  annotation (defaultComponentName="conVarFanConWat",
    Icon(coordinateSystem(preserveAspectRatio=false,
      extent={{-140,-140},{140,140}}),
      graphics={  Rectangle(
          extent={{-140,140},{140,-140}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-140,140},{140,180}},
          textString="%name",
          textColor={0,0,255}),
        Text(
          extent={{-134,132},{-92,108}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TZon"),
        Text(
          extent={{-134,58},{-66,22}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TCooSet"),
        Text(
          extent={{-132,-24},{-64,-60}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="THeaSet"),
        Text(
          extent={{-130,-106},{-88,-132}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uAva"),
        Text(
          extent={{88,-30},{132,-54}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="yFan"),
        Text(
          extent={{66,66},{132,18}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yFanSpe")}),
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
end VariableFan;
