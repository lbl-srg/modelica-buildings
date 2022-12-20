within Buildings.Fluid.ZoneEquipment.UnitHeater.Controls.Subsequences;
model Cooling
  "Controller for unit heater system with variable heating rate and fixed speed fan"

  extends Buildings.Fluid.ZoneEquipment.BaseClasses.ControllerInterfaces(
    final sysTyp=Buildings.Fluid.ZoneEquipment.BaseClasses.Types.SystemTypes.unitHeater,
    final has_fanOpeMod=true);

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

  Buildings.Controls.OBC.CDL.Logical.And andAva
    "Enable the fan only when availability signal is true"
    annotation (Placement(transformation(extent={{110,-70},{130,-50}})));

  Buildings.Controls.OBC.CDL.Logical.And andProOnPro
    "Pass true if fan is enabled but not yet proven on"
    annotation (Placement(transformation(extent={{30,-30},{50,-10}})));

  Buildings.Controls.OBC.CDL.Continuous.Switch swi
    annotation (Placement(transformation(extent={{100,-30},{120,-10}})));

  Buildings.Controls.OBC.CDL.Logical.Not notProOn
    "Pass true if fan is not proven on"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conMinFanSpe(
    final k=minFanSpe)
    "Minimum fan speed signal"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));

  Buildings.Controls.OBC.CDL.Logical.Timer timFan(
    final t=tFanEnaDel)
    "Time delay for switching on fan"
    annotation (Placement(transformation(extent={{-30,-70},{-10,-50}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea
    "Convert fan proven on signal to real value"
    annotation (Placement(transformation(extent={{0,90},{20,110}})));

  Buildings.Controls.OBC.CDL.Continuous.Multiply mulHea
    "Enable heating coil valve only when fan is proven on"
    annotation (Placement(transformation(extent={{40,50},{60,70}})));

  Buildings.Controls.OBC.CDL.Continuous.Subtract subHea
    "Find difference between zone temperature and heating setpoint"
    annotation (Placement(transformation(extent={{-100,-30},{-80,-10}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hysHea(
    final uLow=-dTHys,
    final uHigh=0)
    "Enable heating mode when zone temperature is lower than heating setpoint"
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToReaFanSpe
    "Boolean to Real conversion for fan speed in heating or cooling mode"
    annotation (Placement(transformation(extent={{60,-50},{80,-30}})));

  Buildings.Controls.OBC.CDL.Continuous.PID conPIDHea(
    final controllerType=controllerTypeHea,
    final k=kHea,
    final Ti=TiHea,
    final Td=TdHea,
    final reverseActing=false) "PI controller for fan speed in heating mode"
    annotation (Placement(transformation(extent={{0,40},{20,60}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conZero(
    final k=0)
    "Constant zero signal"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));

  Buildings.Controls.OBC.CDL.Logical.Or orHeaCooOpe
    "Enable fan when operating mode signal is true or when heating load is present"
    annotation (Placement(transformation(extent={{0,-80},{20,-60}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFanEnaHol(final
      trueHoldDuration=tFanEna, final falseHoldDuration=0)
    "Keep fan enabled for minimum duration"
    annotation (Placement(transformation(extent={{60,-80},{80,-60}})));

equation

  connect(subHea.y, hysHea.u) annotation (Line(points={{-78,-20},{-70,-20},{-70,
          -60},{-62,-60}}, color={0,0,127}));

  connect(subHea.y, conPIDHea.u_m) annotation (Line(points={{-78,-20},{10,-20},{
          10,38}},                color={0,0,127}));

  connect(conZero.y, conPIDHea.u_s)
    annotation (Line(points={{-18,50},{-2,50}}, color={0,0,127}));

  connect(orHeaCooOpe.y, booToReaFanSpe.u) annotation (Line(points={{22,-70},{30,
          -70},{30,-40},{58,-40}},    color={255,0,255}));
  connect(conPIDHea.y, mulHea.u2) annotation (Line(points={{22,50},{30,50},{30,54},
          {38,54}}, color={0,0,127}));
  connect(booToRea.y, mulHea.u1) annotation (Line(points={{22,100},{30,100},{30,
          66},{38,66}},
                    color={0,0,127}));
  connect(orHeaCooOpe.y, truFanEnaHol.u)
    annotation (Line(points={{22,-70},{58,-70}}, color={255,0,255}));
  connect(hysHea.y, timFan.u)
    annotation (Line(points={{-38,-60},{-32,-60}}, color={255,0,255}));
  connect(timFan.passed,orHeaCooOpe. u1) annotation (Line(points={{-8,-68},{-4,-68},
          {-4,-70},{-2,-70}}, color={255,0,255}));
  connect(THeaSet, subHea.u1) annotation (Line(points={{-160,-20},{-120,-20},{-120,
          -14},{-102,-14}},     color={0,0,127}));
  connect(TZon, subHea.u2) annotation (Line(points={{-160,60},{-110,60},{-110,-26},
          {-102,-26}},color={0,0,127}));
  connect(mulHea.y, yHea) annotation (Line(points={{62,60},{120,60},{120,20},{160,
          20}},     color={0,0,127}));
  connect(uFan, booToRea.u)
    annotation (Line(points={{-160,100},{-2,100}},color={255,0,255}));
  connect(fanOpeMod, orHeaCooOpe.u2) annotation (Line(points={{-160,-100},{-4,-100},
          {-4,-78},{-2,-78}}, color={255,0,255}));
  connect(uAva, andAva.u2) annotation (Line(points={{-160,-60},{-100,-60},{-100,
          -90},{100,-90},{100,-68},{108,-68}}, color={255,0,255}));
  connect(truFanEnaHol.y, andAva.u1) annotation (Line(points={{82,-70},{90,-70},
          {90,-60},{108,-60}}, color={255,0,255}));
  connect(andAva.y, yFan)
    annotation (Line(points={{132,-60},{160,-60}}, color={255,0,255}));
  connect(conMinFanSpe.y, swi.u1) annotation (Line(points={{82,0},{90,0},{90,-12},
          {98,-12}}, color={0,0,127}));
  connect(booToReaFanSpe.y, swi.u3) annotation (Line(points={{82,-40},{90,-40},{
          90,-28},{98,-28}}, color={0,0,127}));
  connect(andProOnPro.y, swi.u2)
    annotation (Line(points={{52,-20},{98,-20}}, color={255,0,255}));
  connect(swi.y, yFanSpe)
    annotation (Line(points={{122,-20},{160,-20}}, color={0,0,127}));
  connect(andAva.y, andProOnPro.u1) annotation (Line(points={{132,-60},{134,-60},
          {134,40},{24,40},{24,-20},{28,-20}}, color={255,0,255}));
  connect(uFan, notProOn.u) annotation (Line(points={{-160,100},{-90,100},{-90,30},
          {-82,30}}, color={255,0,255}));
  connect(notProOn.y, andProOnPro.u2) annotation (Line(points={{-58,30},{-40,30},
          {-40,-28},{28,-28}}, color={255,0,255}));
  annotation (defaultComponentName="conVarWatConFan",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-180,-180},{180,180}}),
        graphics={Rectangle(
          extent={{-180,180},{180,-180}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-180,180},{180,220}},
          textString="%name",
          textColor={0,0,255})}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-120},{
            140,120}})),
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
end Cooling;
