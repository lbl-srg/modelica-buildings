within Buildings.Fluid.ZoneEquipment.BaseClasses;
block VariableFan
  "Controller for variable speed fan"

  parameter Boolean has_hea
    "The zonal HVAC system has a heating coil";

  parameter Boolean has_coo
    "The zonal HVAC system has a cooling coil";

  parameter .Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeCoo=Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of fan cooling loop controller"
    annotation (Dialog(group="Fan control parameters - Cooling mode",
      enable = has_coo));

  parameter Real kCoo(
    final unit="1",
    displayUnit="1")=1
    "Gain of fan cooling loop controller"
    annotation(Dialog(group="Fan control parameters - Cooling mode",
      enable = has_coo));

  parameter Modelica.Units.SI.Time TiCoo=0.5
    "Time constant of fan cooling loop integrator block"
    annotation(Dialog(group="Fan control parameters - Cooling mode",
      enable = (controllerTypeCoo == Buildings.Controls.OBC.CDL.Types.SimpleController.PI or
      controllerTypeCoo == Buildings.Controls.OBC.CDL.Types.SimpleController.PID) and
      has_coo));

  parameter Modelica.Units.SI.Time TdCoo=0.1
    "Time constant of fan cooling loop derivative block"
    annotation(Dialog(group="Fan control parameters - Cooling mode",
      enable = (controllerTypeCoo == Buildings.Controls.OBC.CDL.Types.SimpleController.PD or
      controllerTypeCoo == Buildings.Controls.OBC.CDL.Types.SimpleController.PID) and
      has_coo));

  parameter .Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeHea=Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of fan heating loop controller"
    annotation (Dialog(group="Fan control parameters - Heating mode",
    enable = has_hea));

  parameter Real kHea(
    final unit="1",
    displayUnit="1")=1
    "Gain of fan heating loop controller"
    annotation(Dialog(group="Fan control parameters - Heating mode",
      enable = has_hea));

  parameter Modelica.Units.SI.Time TiHea=0.5
    "Time constant of fan heating loop integrator block"
    annotation(Dialog(group="Fan control parameters - Heating mode",
      enable = (controllerTypeHea == Buildings.Controls.OBC.CDL.Types.SimpleController.PI or
      controllerTypeHea == Buildings.Controls.OBC.CDL.Types.SimpleController.PID) and
      has_hea));

  parameter Modelica.Units.SI.Time TdHea=0.1
    "Time constant of fan heating loop derivative block"
    annotation(Dialog(group="Fan control parameters - Heating mode",
      enable = (controllerTypeHea == Buildings.Controls.OBC.CDL.Types.SimpleController.PD or
      controllerTypeHea == Buildings.Controls.OBC.CDL.Types.SimpleController.PID) and
      has_hea));

  parameter Real minFanSpe(
    final unit="1",
    displayUnit="1",
    final min=0,
    final max=1)
    "Minimum fan speed"
    annotation(Dialog(group="System parameters"));

  parameter Modelica.Units.SI.Time tFanEnaDel = 30
    "Time period for fan enable delay"
    annotation(Dialog(group="System parameters"));

  parameter Modelica.Units.SI.Time tFanEna = 300
    "Minimum running time of the fan"
    annotation(Dialog(group="System parameters"));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uFan
    "Fan proven on signal"
    annotation (Placement(transformation(extent={{-180,80},{-140,120}}),
      iconTransformation(extent={{-160,80},{-120,120}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput heaCooOpe
    "Heating/cooling operation is enabled"
    annotation (Placement(transformation(extent={{-180,40},{-140,80}}),
      iconTransformation(extent={{-160,40},{-120,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uAva
    "Availability signal"
    annotation (Placement(transformation(extent={{-180,-100},{-140,-60}}),
      iconTransformation(extent={{-160,-120},{-120,-80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon(
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature")
    "Measured zone temperature"
    annotation (Placement(transformation(extent={{-180,10},{-140,50}}),
      iconTransformation(extent={{-160,0},{-120,40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TCooSet(
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature") if has_coo
    "Zone cooling temperature setpoint"
    annotation (Placement(transformation(extent={{-180,-30},{-140,10}}),
      iconTransformation(extent={{-160,-40},{-120,0}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaSet(
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature") if has_hea
    "Zone heating temperature setpoint"
    annotation (Placement(transformation(extent={{-180,-70},{-140,-30}}),
      iconTransformation(extent={{-160,-80},{-120,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yFan
    "Fan enable signal"
    annotation (Placement(transformation(extent={{140,-120},{180,-80}}),
      iconTransformation(extent={{120,-40},{160,0}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yFanSpe(
    final unit="1",
    displayUnit="1")
    "Fan speed signal"
    annotation (Placement(transformation(extent={{140,-50},{180,-10}}),
      iconTransformation(extent={{120,0},{160,40}})));

protected
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHolFanEna(
    final trueHoldDuration=tFanEna,
    final falseHoldDuration=0)
    "Keep fan enabled for minimum duration"
    annotation (Placement(transformation(extent={{40,-110},{60,-90}})));

  Buildings.Controls.OBC.CDL.Logical.Timer timFan(
    final t=tFanEnaDel)
    "Time delay for switching on the fan"
    annotation (Placement(transformation(extent={{-60,-110},{-40,-90}})));

  Buildings.Controls.OBC.CDL.Continuous.Subtract subCoo if has_coo
    "Find difference between zone temperature and cooling setpoint"
    annotation (Placement(transformation(extent={{-110,10},{-90,30}})));

  Buildings.Controls.OBC.CDL.Continuous.Subtract subHea if has_hea
    "Find difference between zone temperature and heating setpoint"
    annotation (Placement(transformation(extent={{-110,-20},{-90,0}})));

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
    annotation (Placement(transformation(extent={{-110,-50},{-90,-30}})));

  Buildings.Controls.OBC.CDL.Continuous.Add addFanSpe
    "Pass sum of fan speed from heating and cooling controllers, one of which is always zero"
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));

  Buildings.Controls.OBC.CDL.Logical.And andHeaCooOcc
    "Enable fan only when system is available"
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conMinFanSpe(
    final k=minFanSpe)
    "Minimum fan speed signal"
    annotation (Placement(transformation(extent={{50,60},{70,80}})));

  Buildings.Controls.OBC.CDL.Logical.And andFanPro
    "Pass true if fan is enabled but not yet proven on"
    annotation (Placement(transformation(extent={{50,20},{70,40}})));

  Buildings.Controls.OBC.CDL.Logical.Not notProOn
    "Pass true if fan is not proven on"
    annotation (Placement(transformation(extent={{-120,90},{-100,110}})));

  Buildings.Controls.OBC.CDL.Continuous.Switch swiFanSpe
    "Pass minimum fan speed signal when fan is not proven on"
    annotation (Placement(transformation(extent={{100,-40},{120,-20}})));

equation
  connect(TZon, subCoo.u1) annotation (Line(points={{-160,30},{-130,30},{-130,26},
          {-112,26}}, color={0,0,127}));

  connect(TCooSet, subCoo.u2) annotation (Line(points={{-160,-10},{-136,-10},{-136,
          14},{-112,14}}, color={0,0,127}));

  connect(TZon, subHea.u2) annotation (Line(points={{-160,30},{-130,30},{-130,-16},
          {-112,-16}},color={0,0,127}));

  connect(THeaSet, subHea.u1) annotation (Line(points={{-160,-50},{-120,-50},{-120,
          -4},{-112,-4}}, color={0,0,127}));

  connect(subCoo.y, conPIDCoo.u_m) annotation (Line(points={{-88,20},{-80,20},{-80,
          -26},{10,-26},{10,-22}}, color={0,0,127}));

  connect(subHea.y, conPIDHea.u_m) annotation (Line(points={{-88,-10},{-84,-10},
          {-84,-68},{10,-68},{10,-62}},
                                   color={0,0,127}));

  connect(conZer.y, conPIDCoo.u_s)
    annotation (Line(points={{-88,-40},{-46,-40},{-46,-10},{-2,-10}},
                                                  color={0,0,127}));

  connect(conZer.y, conPIDHea.u_s) annotation (Line(points={{-88,-40},{-20,-40},
          {-20,-50},{-2,-50}}, color={0,0,127}));

  connect(conPIDHea.y, addFanSpe.u2) annotation (Line(points={{22,-50},{30,-50},
          {30,-36},{38,-36}}, color={0,0,127}));
  connect(conPIDCoo.y, addFanSpe.u1) annotation (Line(points={{22,-10},{30,-10},
          {30,-24},{38,-24}}, color={0,0,127}));
  connect(timFan.passed, andHeaCooOcc.u2)
    annotation (Line(points={{-38,-108},{-12,-108}},
                                                   color={255,0,255}));
  connect(andHeaCooOcc.y, truFalHolFanEna.u)
    annotation (Line(points={{12,-100},{38,-100}},   color={255,0,255}));
  connect(truFalHolFanEna.y, yFan) annotation (Line(points={{62,-100},{160,-100}},
                                color={255,0,255}));

  connect(uAva, andHeaCooOcc.u1) annotation (Line(points={{-160,-80},{-20,-80},{
          -20,-100},{-12,-100}},
                               color={255,0,255}));
  connect(heaCooOpe, timFan.u) annotation (Line(points={{-160,60},{-70,60},{-70,
          -100},{-62,-100}}, color={255,0,255}));
  connect(uFan, notProOn.u)
    annotation (Line(points={{-160,100},{-122,100}}, color={255,0,255}));
  connect(andFanPro.y, swiFanSpe.u2) annotation (Line(points={{72,30},{80,30},{80,
          -30},{98,-30}}, color={255,0,255}));
  connect(conMinFanSpe.y, swiFanSpe.u1) annotation (Line(points={{72,70},{90,70},
          {90,-22},{98,-22}}, color={0,0,127}));
  connect(notProOn.y, andFanPro.u1) annotation (Line(points={{-98,100},{-20,100},
          {-20,30},{48,30}}, color={255,0,255}));
  connect(truFalHolFanEna.y, andFanPro.u2) annotation (Line(points={{62,-100},{70,
          -100},{70,0},{40,0},{40,22},{48,22}}, color={255,0,255}));
  connect(addFanSpe.y, swiFanSpe.u3) annotation (Line(points={{62,-30},{76,-30},
          {76,-38},{98,-38}}, color={0,0,127}));
  connect(swiFanSpe.y, yFanSpe)
    annotation (Line(points={{122,-30},{160,-30}}, color={0,0,127}));
  annotation (defaultComponentName="conVarFan",
    Icon(coordinateSystem(preserveAspectRatio=false,
      extent={{-120,-120},{120,120}}),
      graphics={  Rectangle(
          extent={{-120,120},{120,-120}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-140,140},{140,180}},
          textString="%name",
          textColor={0,0,255}),
        Text(
          extent={{-114,32},{-72,8}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TZon"),
        Text(
          extent={{-114,-2},{-46,-38}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TCooSet"),
        Text(
          extent={{-112,-44},{-44,-80}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="THeaSet"),
        Text(
          extent={{-110,-86},{-68,-112}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uAva"),
        Text(
          extent={{68,-10},{112,-34}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="yFan"),
        Text(
          extent={{46,46},{112,-2}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yFanSpe"),
        Text(
          extent={{-116,114},{-74,88}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uFan"),
        Text(
          extent={{-116,78},{-36,44}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="heaCooOpe")}),
    Diagram(coordinateSystem(preserveAspectRatio=false,
      extent={{-140,-120},{140,120}})),
    Documentation(info="<html>
      <p>
      This is a control module for the variable speed fan designed as an 
      analogue to the control logic in EnergyPlus. The components are operated 
      as follows:
      <ul>
      <li>
      The fan is enabled (<code>yFan=true</code>) when the cooling/heating mode signal
      <code>heaCooOpe</code> is held <code>true</code> for a minimum time duration
      <code>tFanEnaDel</code>.
      </li>
      <li>
      Once enabled, the fan is held enabled for minimum time duration <code>tFanEna</code>.
      </li>
      <li>
      The fan is run at minimum speed <code>minFanSpe</code> if it is not proven 
      on (<code>uFan=false</code>).
      </li>
      <li>
      Once the fan is proven on (<code>uFan=true</code>), the fan speed 
      <code>yFanSpe</code> is determined to regulate the measured zone temperature
      <code>TZon</code> between the heating temperature setpoint <code>THeaSet</code> 
      and cooling temperature setpoint <code>TCooSet</code>.
      </li>
      <li>
      The fan is not enabled if the availability signal <code>uAva</code> is set 
      to <code>false</code>.
      </li>
      </ul>
      </p>
      <p align=\"center\">
      <img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/ZoneEquipment/Baseclasses/variableFan.png\"/>
      </p>
      </html>
      ", revisions="<html>
      <ul>
      <li>
      June 21, 2023 by Karthik Devaprasad, Junke Wang:<br/>
      First implementation.
      </li>
      </ul>
      </html>"));
end VariableFan;
