within Buildings.Fluid.ZoneEquipment.BaseClasses;
model CyclingFan
  "Controller for unit heater system with variable heating rate and fixed speed fan"

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

  Buildings.Controls.OBC.CDL.Logical.And andAva
    "Enable the fan only when availability signal is true"
    annotation (Placement(transformation(extent={{40,-80},{60,-60}})));

  Buildings.Controls.OBC.CDL.Logical.And andFanPro
    "Pass true if fan is enabled but not yet proven on"
    annotation (Placement(transformation(extent={{0,30},{20,50}})));

  Buildings.Controls.OBC.CDL.Continuous.Switch swi
    annotation (Placement(transformation(extent={{40,30},{60,50}})));

  Buildings.Controls.OBC.CDL.Logical.Not notProOn
    "Pass true if fan is not proven on"
    annotation (Placement(transformation(extent={{-110,60},{-90,80}})));

  Modelica.Blocks.Interfaces.BooleanInput uFan "Fan proven on signal"
    annotation (Placement(transformation(extent={{-180,50},{-140,90}}),
        iconTransformation(extent={{-180,100},{-140,140}})));
  Modelica.Blocks.Interfaces.BooleanInput uAva "Availability signal"
    annotation (Placement(transformation(extent={{-180,-80},{-140,-40}}),
        iconTransformation(extent={{-180,-60},{-140,-20}})));
  Modelica.Blocks.Interfaces.BooleanInput fanOpeMod
    "Supply fan operating mode signal" annotation (Placement(transformation(
          extent={{-180,-118},{-140,-78}}), iconTransformation(extent={{-180,-140},
            {-140,-100}})));
  Modelica.Blocks.Interfaces.RealOutput yFanSpe(final unit="1", displayUnit="1")
    "Fan speed signal" annotation (Placement(transformation(extent={{140,20},{180,
            60}}), iconTransformation(extent={{140,20},{180,60}})));
  Modelica.Blocks.Interfaces.BooleanOutput yFan "Fan enable signal" annotation (
     Placement(transformation(extent={{140,-90},{180,-50}}), iconTransformation(
          extent={{140,-60},{180,-20}})));
  Modelica.Blocks.Interfaces.BooleanInput heaCooOpe
    "Heating/cooling operation is enabled" annotation (Placement(transformation(
          extent={{-180,-10},{-140,30}}),iconTransformation(extent={{-180,20},{-140,
            60}})));
protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conMinFanSpe(
    final k=minFanSpe)
    "Minimum fan speed signal"
    annotation (Placement(transformation(extent={{0,70},{20,90}})));

  Buildings.Controls.OBC.CDL.Logical.Timer timFan(
    final t=tFanEnaDel)
    "Time delay for switching on fan"
    annotation (Placement(transformation(extent={{-110,0},{-90,20}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToReaFanSpe
    "Boolean to Real conversion for fan speed in heating or cooling mode"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));

  Buildings.Controls.OBC.CDL.Logical.Or orHeaCooOpe
    "Enable fan when operating mode signal is true or when heating load is present"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFanEnaHol(final
      trueHoldDuration=tFanEna, final falseHoldDuration=0)
    "Keep fan enabled for minimum duration"
    annotation (Placement(transformation(extent={{0,-80},{20,-60}})));

equation

  connect(orHeaCooOpe.y, booToReaFanSpe.u) annotation (Line(points={{-38,0},{-2,
          0}},                        color={255,0,255}));
  connect(orHeaCooOpe.y, truFanEnaHol.u)
    annotation (Line(points={{-38,0},{-20,0},{-20,-70},{-2,-70}},
                                                 color={255,0,255}));
  connect(timFan.passed,orHeaCooOpe. u1) annotation (Line(points={{-88,2},{-80,2},
          {-80,0},{-62,0}},   color={255,0,255}));
  connect(fanOpeMod, orHeaCooOpe.u2) annotation (Line(points={{-160,-98},{-70,-98},
          {-70,-8},{-62,-8}}, color={255,0,255}));
  connect(uAva, andAva.u2) annotation (Line(points={{-160,-60},{-120,-60},{-120,
          -50},{32,-50},{32,-78},{38,-78}},    color={255,0,255}));
  connect(truFanEnaHol.y, andAva.u1) annotation (Line(points={{22,-70},{38,-70}},
                               color={255,0,255}));
  connect(andAva.y, yFan)
    annotation (Line(points={{62,-70},{160,-70}},  color={255,0,255}));
  connect(conMinFanSpe.y, swi.u1) annotation (Line(points={{22,80},{30,80},{30,48},
          {38,48}},  color={0,0,127}));
  connect(booToReaFanSpe.y, swi.u3) annotation (Line(points={{22,0},{30,0},{30,32},
          {38,32}},          color={0,0,127}));
  connect(andFanPro.y, swi.u2)
    annotation (Line(points={{22,40},{38,40}},   color={255,0,255}));
  connect(swi.y, yFanSpe)
    annotation (Line(points={{62,40},{160,40}},    color={0,0,127}));
  connect(uFan, notProOn.u) annotation (Line(points={{-160,70},{-112,70}},
                     color={255,0,255}));
  connect(heaCooOpe, timFan.u)
    annotation (Line(points={{-160,10},{-112,10}},   color={255,0,255}));
  connect(notProOn.y, andFanPro.u1) annotation (Line(points={{-88,70},{-30,70},{
          -30,40},{-2,40}},  color={255,0,255}));
  connect(andAva.y, andFanPro.u2) annotation (Line(points={{62,-70},{70,-70},{70,
          -100},{-30,-100},{-30,32},{-2,32}},  color={255,0,255}));
  annotation (defaultComponentName="conFanCyc",
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
end CyclingFan;
