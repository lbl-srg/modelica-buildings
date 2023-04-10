within Buildings.Fluid.ZoneEquipment.FanCoilUnit.Controls;
block ConstantFanVariableWaterFlowrate_submodules
  "Controller for fan coil system with variable water flow rates and constant fan speed"
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
    "Minimum running time of the fan"
    annotation(Dialog(group="System parameters"));
  parameter Modelica.Units.SI.TemperatureDifference dTHys = 0.2
    "Temperature difference used for enabling cooling and heating mode"
    annotation(Dialog(tab="Advanced"));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uFan
    "Fan proven on signal"
    annotation (Placement(transformation(extent={{-160,60},{-120,100}}),
      iconTransformation(extent={{-160,80},{-120,120}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uAva "Availability signal"
    annotation (Placement(transformation(extent={{-160,-120},{-120,-80}}),
      iconTransformation(extent={{-160,-80},{-120,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon(
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature")
    "Measured zone temperature"
    annotation (Placement(transformation(extent={{-160,-10},{-120,30}}),
      iconTransformation(extent={{-160,40},{-120,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TCooSet(
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature")
    "Zone cooling temperature setpoint"
    annotation (Placement(transformation(extent={{-160,-50},{-120,-10}}),
      iconTransformation(extent={{-160,0},{-120,40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaSet(
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature")
    "Zone heating temperature setpoint"
    annotation (Placement(transformation(extent={{-160,-90},{-120,-50}}),
      iconTransformation(extent={{-160,-40},{-120,0}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yFan
    "Fan enable signal"
    annotation (Placement(transformation(extent={{140,-100},{180,-60}}),
      iconTransformation(extent={{120,-80},{160,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yFanSpe(
    final unit="1",
    displayUnit="1")
    "Fan speed signal"
    annotation (Placement(transformation(extent={{140,-50},{180,-10}}),
      iconTransformation(extent={{120,-40},{160,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yCoo(
    final unit="1",
    displayUnit="1")
    "Cooling signal"
    annotation (Placement(transformation(extent={{140,40},{180,80}}),
      iconTransformation(extent={{120,40},{160,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yHea(
    final unit="1",
    displayUnit="1")
    "Heating signal"
    annotation (Placement(transformation(extent={{140,0},{180,40}}),
      iconTransformation(extent={{120,0},{160,40}})));

  BaseClasses.HeatingCooling cooMod(
    controllerType=controllerTypeCoo,
    k=kCoo,
    Ti=TiCoo,
    Td=TdCoo,
    dTHys=dTHys) "Cooling mode controller"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  BaseClasses.HeatingCooling heaMod(
    controllerType=controllerTypeHea,
    k=kHea,
    Ti=TiHea,
    Td=TdHea,
    dTHys=dTHys,
    conMod=true) "Heating mode controller"
    annotation (Placement(transformation(extent={{-70,20},{-50,40}})));

  BaseClasses.CyclingFan conFan(
    minFanSpe=minFanSpe,
    tFanEnaDel=tFanEnaDel,
    tFanEna=tFanEna) "Fan controller"
    annotation (Placement(transformation(extent={{34,-60},{62,-32}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput fanOpeMod
    "Fan operating mode signal" annotation (Placement(transformation(extent={{
            -160,-160},{-120,-120}}), iconTransformation(extent={{-160,-120},{
            -120,-80}})));
protected
  Buildings.Controls.OBC.CDL.Logical.Or orHeaCoo
    "Enable fan in heating mode and cooling mode"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));

equation

  connect(uFan, cooMod.uFan) annotation (Line(points={{-140,80},{-90,80},{-90,
          78},{-82,78}}, color={255,0,255}));
  connect(uFan, heaMod.uFan) annotation (Line(points={{-140,80},{-90,80},{-90,
          38},{-72,38}}, color={255,0,255}));
  connect(TZon, cooMod.TZon) annotation (Line(points={{-140,10},{-110,10},{-110,
          70},{-82,70}}, color={0,0,127}));
  connect(TZon, heaMod.TZon) annotation (Line(points={{-140,10},{-110,10},{-110,
          30},{-72,30}}, color={0,0,127}));
  connect(TCooSet, cooMod.TZonSet) annotation (Line(points={{-140,-30},{-100,
          -30},{-100,62},{-82,62}}, color={0,0,127}));
  connect(THeaSet, heaMod.TZonSet) annotation (Line(points={{-140,-70},{-80,-70},
          {-80,22},{-72,22}}, color={0,0,127}));
  connect(cooMod.y, yCoo) annotation (Line(points={{-58,74},{80,74},{80,60},{
          160,60}}, color={0,0,127}));
  connect(heaMod.y, yHea) annotation (Line(points={{-48,34},{80,34},{80,20},{
          160,20}}, color={0,0,127}));
  connect(cooMod.yMod, orHeaCoo.u1) annotation (Line(points={{-58,66},{-40,66},
          {-40,50},{-22,50}}, color={255,0,255}));
  connect(heaMod.yMod, orHeaCoo.u2) annotation (Line(points={{-48,26},{-40,26},
          {-40,42},{-22,42}}, color={255,0,255}));
  connect(conFan.yFanSpe, yFanSpe) annotation (Line(points={{64,-42},{80,-42},{
          80,-30},{160,-30}}, color={0,0,127}));
  connect(conFan.yFan, yFan) annotation (Line(points={{64,-50},{80,-50},{80,-80},
          {160,-80}}, color={255,0,255}));
  connect(uFan, conFan.uFan) annotation (Line(points={{-140,80},{-90,80},{-90,
          -34},{32,-34}}, color={255,0,255}));
  connect(orHeaCoo.y, conFan.heaCooOpe) annotation (Line(points={{2,50},{10,50},
          {10,-42},{32,-42}}, color={255,0,255}));
  connect(uAva, conFan.uAva) annotation (Line(points={{-140,-100},{20,-100},{20,
          -50},{32,-50}}, color={255,0,255}));
  connect(fanOpeMod, conFan.fanOpeMod) annotation (Line(points={{-140,-140},{26,
          -140},{26,-58},{32,-58}}, color={255,0,255}));
  annotation (defaultComponentName="conVarWatConFan",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-120,-160},{140,
            100}}),
      graphics={
        Rectangle(
          extent={{-120,120},{120,-120}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-120,120},{120,160}},
          textString="%name",
          textColor={0,0,255})}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,-160},{
            140,100}})),
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
end ConstantFanVariableWaterFlowrate_submodules;
