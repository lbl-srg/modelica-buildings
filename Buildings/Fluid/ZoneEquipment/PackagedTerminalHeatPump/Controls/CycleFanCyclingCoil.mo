within Buildings.Fluid.ZoneEquipment.PackagedTerminalHeatPump.Controls;
model CycleFanCyclingCoil
  "Controller for window AC with cycle fan and cycle coil"

  extends Buildings.Fluid.ZoneEquipment.BaseClasses.ControllerInterfaces(
    final sysTyp=Buildings.Fluid.ZoneEquipment.BaseClasses.Types.SystemTypes.windowAC,
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

  BaseClasses.HeatingCooling conOpeMod(conMod=false, tCoiEna=tCoiEna)
    annotation (Placement(transformation(extent={{-10,60},{10,80}})));

  BaseClasses.CyclingFan conFanCyc(tFanEnaDel=tFanEnaDel, tFanEna=tFanEna)
    annotation (Placement(transformation(extent={{72,-80},{100,-52}})));
  Modelica.Blocks.Interfaces.RealInput TSup(
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature") "Measured supply temperature"
    annotation (Placement(transformation(extent={{-180,-160},{-140,-120}}),
        iconTransformation(extent={{-220,-270},{-180,-230}})));
  parameter Modelica.Units.SI.Time tCoiEna=180
    "enable hold duration for DX cooling coil";
equation

  connect(uFan, conOpeMod.uFan) annotation (Line(points={{-160,100},{-60,100},{
          -60,75.7143},{-11.4286,75.7143}},
                             color={255,0,255}));
  connect(TZon, conOpeMod.TZon) annotation (Line(points={{-160,60},{-50,60},{
          -50,70},{-11.4286,70}},
                             color={0,0,127}));
  connect(uFan, conFanCyc.uFan) annotation (Line(points={{-160,100},{-60,100},{-60,
          -54},{70,-54}},     color={255,0,255}));
  connect(uAva, conFanCyc.uAva) annotation (Line(points={{-160,-60},{-60,-60},{-60,
          -70},{70,-70}},     color={255,0,255}));
  connect(fanOpeMod, conFanCyc.fanOpeMod) annotation (Line(points={{-160,-100},{
          -60,-100},{-60,-78},{70,-78}},  color={255,0,255}));
  connect(conFanCyc.yFan, yFan) annotation (Line(points={{102,-70},{120,-70},{120,
          -100},{160,-100}},   color={255,0,255}));
  connect(conFanCyc.yFanSpe, yFanSpe) annotation (Line(points={{102,-62},{110,-62},
          {110,-60},{160,-60}},      color={0,0,127}));
  connect(conOpeMod.yEna, yCooEna) annotation (Line(points={{11.4286,70},{100,
          70},{100,100},{160,100}},
                               color={255,0,255}));
  connect(conOpeMod.y, yCoo) annotation (Line(points={{11.4286,75.7143},{80,
          75.7143},{80,20},{160,20}},
                    color={0,0,127}));
  connect(TCooSet, conOpeMod.TZonSet) annotation (Line(points={{-160,20},{-20,
          20},{-20,64.2857},{-11.4286,64.2857}}, color={0,0,127}));
  connect(TSup, conOpeMod.TSup) annotation (Line(points={{-160,-140},{-40,-140},
          {-40,60},{-11.4286,60}}, color={0,0,127}));
  connect(conOpeMod.yMod, conFanCyc.heaCooOpe) annotation (Line(points={{11.4286,
          64.2857},{40,64.2857},{40,-62},{70,-62}},         color={255,0,255}));
  annotation (defaultComponentName="conVarWatConFan",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-180,-240},{180,240}}),
        graphics={Rectangle(
          extent={{-180,240},{180,-240}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-180,240},{180,280}},
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
end CycleFanCyclingCoil;
