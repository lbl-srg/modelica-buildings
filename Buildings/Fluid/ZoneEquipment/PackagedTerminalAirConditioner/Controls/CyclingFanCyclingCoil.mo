within Buildings.Fluid.ZoneEquipment.PackagedTerminalAirConditioner.Controls;
model CyclingFanCyclingCoil
  "Controller for PTAC with cycling fan and cycling coil"

  extends Buildings.Fluid.ZoneEquipment.BaseClasses.ControllerInterfaces(final
      sysTyp=Buildings.Fluid.ZoneEquipment.BaseClasses.Types.SystemTypes.ptac,
      final has_fanOpeMod=true);

  parameter Modelica.Units.SI.Time tFanEnaDel = 30
    "Time period for delay between switching from deadband mode to heating/cooling mode"
    annotation(Dialog(group="System parameters"));

  parameter Modelica.Units.SI.Time tFanEna = 300
    "Minimum duration for which fan is enabled"
    annotation(Dialog(group="System parameters"));

  parameter Modelica.Units.SI.TemperatureDifference dTHys
    "Temperature difference used for enabling cooling and heating mode"
    annotation(Dialog(tab="Advanced"));

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeHea=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller for heating"
    annotation(Dialog(group="Heating control"));

  parameter Real kHea=1
    "Gain of controller for heating"
    annotation(Dialog(group="Heating control"));

  parameter Modelica.Units.SI.Time TiHea=0.5
    "Time constant of integrator block for heating"
    annotation(Dialog(group="Heating control"));

  parameter Modelica.Units.SI.Time TdHea=0.1
    "Time constant of derivative block for heating"
    annotation(Dialog(group="Heating control"));

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeCoo=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller for cooling"
    annotation(Dialog(group="Cooling control"));

  parameter Real kCoo=1
    "Gain of controller for cooling"
    annotation(Dialog(group="Cooling control"));

  parameter Modelica.Units.SI.Time TiCoo=0.5
    "Time constant of integrator block for cooling"
    annotation(Dialog(group="Cooling control"));

  parameter Modelica.Units.SI.Time TdCoo=0.1
    "Time constant of derivative block for cooling"
    annotation(Dialog(group="Cooling control"));

  parameter Real TSupDew(
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature")=273.15 + 12
    "Supply air temperature limit under which condensation will be caused"
    annotation(Dialog(tab="Advanced"));

protected
  Buildings.Fluid.ZoneEquipment.BaseClasses.HeatingCooling conHea(
    final controllerType=controllerTypeHea,
    final k=kHea,
    final TSupDew=TSupDew,
    final Ti=TiHea,
    final Td=TdHea,
    final dTHys=dTHys,
    final conMod=true,
    final tCoiEna=tFanEna) "Heating coil control"
    annotation (Placement(transformation(extent={{-12,50},{8,70}})));

  Buildings.Fluid.ZoneEquipment.BaseClasses.CyclingFan conFanCyc(final
      tFanEnaDel=tFanEnaDel, final tFanEna=tFanEna) "Cycling fan control"
    annotation (Placement(transformation(extent={{80,-120},{100,-100}})));

  Buildings.Fluid.ZoneEquipment.BaseClasses.HeatingCooling conCoo(
    final controllerType=controllerTypeCoo,
    final k=kCoo,
    final Ti=TiCoo,
    final Td=TdCoo,
    final dTHys=dTHys,
    final conMod=false,
    final tCoiEna=tFanEna)
    "Cooling coil control"
    annotation (Placement(transformation(extent={{-8,-90},{12,-70}})));

  Buildings.Controls.OBC.CDL.Logical.Or or2
    "Enable fan when eithor cooling or heating mode is enabled"
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));

equation
  connect(uFan, conHea.uFan) annotation (Line(points={{-160,120},{-60,120},{-60,
          66},{-14,66}},                color={255,0,255}));
  connect(TZon, conHea.TZon) annotation (Line(points={{-160,80},{-48,80},{-48,62},
          {-14,62}},          color={0,0,127}));
  connect(uFan, conFanCyc.uFan) annotation (Line(points={{-160,120},{-60,120},{-60,
          -104},{78,-104}},   color={255,0,255}));
  connect(uAva, conFanCyc.uAva) annotation (Line(points={{-160,-40},{-80,-40},{-80,
          -112},{78,-112}},   color={255,0,255}));
  connect(fanOpeMod, conFanCyc.fanOpeMod) annotation (Line(points={{-160,-80},{-70,
          -80},{-70,-116},{78,-116}},     color={255,0,255}));
  connect(conFanCyc.yFan, yFan) annotation (Line(points={{102,-112},{132,-112},
          {132,-140},{160,-140}},
                               color={255,0,255}));
  connect(conFanCyc.yFanSpe, yFanSpe) annotation (Line(points={{102,-108},{122,
          -108},{122,-100},{160,-100}},
                                     color={0,0,127}));
  connect(TSup, conHea.TSup) annotation (Line(points={{-160,-120},{-40,-120},{-40,
          54},{-14,54}},          color={0,0,127}));
  connect(THeaSet, conHea.TZonSet) annotation (Line(points={{-160,0},{-30,0},{-30,
          58},{-14,58}},                     color={0,0,127}));
  connect(TZon, conCoo.TZon) annotation (Line(points={{-160,80},{-48,80},{-48,-78},
          {-10,-78}},           color={0,0,127}));
  connect(uFan, conCoo.uFan) annotation (Line(points={{-160,120},{-60,120},{-60,
          -74},{-10,-74}},                color={255,0,255}));
  connect(TCooSet, conCoo.TZonSet) annotation (Line(points={{-160,40},{-20,40},{
          -20,-82},{-10,-82}},                 color={0,0,127}));
  connect(TSup, conCoo.TSup) annotation (Line(points={{-160,-120},{-20,-120},{-20,
          -86},{-10,-86}},          color={0,0,127}));
  connect(conCoo.yEna, yCooEna) annotation (Line(points={{14,-80},{100,-80},{
          100,60},{160,60}},    color={255,0,255}));
  connect(conHea.yCoi, yHea) annotation (Line(points={{10,64},{90,64},{90,-60},
          {160,-60}},color={0,0,127}));
  connect(conCoo.yCoi, yCoo) annotation (Line(points={{14,-76},{80,-76},{80,-20},
          {160,-20}},color={0,0,127}));
  connect(conHea.yMod, or2.u1) annotation (Line(points={{10,56},{20,56},{20,-50},
          {38,-50}},        color={255,0,255}));
  connect(conCoo.yMod, or2.u2) annotation (Line(points={{14,-84},{30,-84},{30,-58},
          {38,-58}},        color={255,0,255}));
  connect(or2.y, conFanCyc.heaCooOpe) annotation (Line(points={{62,-50},{70,-50},
          {70,-108},{78,-108}},
                             color={255,0,255}));
  connect(conHea.yEna, yHeaEna) annotation (Line(points={{10,60},{86,60},{86,20},
          {160,20}},        color={255,0,255}));
  connect(conHea.yMod, yHeaMod) annotation (Line(points={{10,56},{20,56},{20,
          100},{160,100}}, color={255,0,255}));
  connect(conCoo.yMod, yCooMod) annotation (Line(points={{14,-84},{30,-84},{30,
          140},{160,140}}, color={255,0,255}));
  annotation (defaultComponentName="conCycFanCycCoi",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-140},{100,140}})),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-160},{140,
            140}})),
    Documentation(info="<html>
    <p>
    This is a control module for the PTAC system model designed as an analogue 
    to the control logic in EnergyPlus. The components are as follows:
    <ul>
    <li>
    Heating coil controller <code>conHea</code>: 
    <a href=\"Buildings.Fluid.ZoneEquipment.BaseClasses.HeatingCooling\">
    Buildings.Fluid.ZoneEquipment.BaseClasses.HeatingCooling</a>
    </li>
    <li>
    Cooling coil controller <code>conCoo</code>:
    <a href=\"Buildings.Fluid.ZoneEquipment.BaseClasses.HeatingCooling\">
    Buildings.Fluid.ZoneEquipment.BaseClasses.HeatingCooling</a>
    </li>
    <li>
    Cycling fan controller <code>conFanCyc</code>:
    <a href=\"Buildings.Fluid.ZoneEquipment.BaseClasses.CyclingFan\">
    Buildings.Fluid.ZoneEquipment.BaseClasses.CyclingFan</a>
    </li>
    </ul>
    </html>
", revisions="<html>
    <ul>
    <li>
    April 10, 2023 by Karthik Devaprasad and Xing Lu:<br/>
    First implementation.
    </li>
    </ul>
    </html>"),
    __Dymola_Commands(file="Resources/Scripts/Dymola/Fluid/ZoneEquipment/PackagedTerminalAirConditioner/Controls/Validation/CyclingFanCyclingCoil.mos"
        "Simulate and Plot"));
end CyclingFanCyclingCoil;
