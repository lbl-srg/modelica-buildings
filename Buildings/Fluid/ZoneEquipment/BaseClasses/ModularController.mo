within Buildings.Fluid.ZoneEquipment.BaseClasses;
model ModularController
  "Modular controller for zonal HVAC systems"
  extends Buildings.Fluid.ZoneEquipment.BaseClasses.ControllerInterfaces;

  parameter Real minFanSpe(
    final unit="1",
    displayUnit="1",
    final min=0)
    "Minimum allowed fan speed"
    annotation(Dialog(group="Fan parameters",
      enable= not has_mulFan_new));

  parameter Modelica.Units.SI.Time tFanEnaDel = 30
    "Time period for delay between switching from deadband mode to heating/cooling mode"
    annotation(Dialog(group="Fan parameters"));

  parameter Modelica.Units.SI.Time tFanEna = 300
    "Minimum duration for which fan is enabled"
    annotation(Dialog(group="Fan parameters"));

  parameter Integer nSpe(
    final min=2) = 2
    "Number of fan speeds"
    annotation(Dialog(group="Fan parameters",
      enable=has_mulFan_new));

  parameter Real fanSpe[nSpe](
    final min=fill(0, nSpe),
    final max=fill(1, nSpe),
    final unit=fill("1", nSpe),
    displayUnit=fill("1", nSpe)) = {0,1}
    "Fan speed values"
    annotation(Dialog(group="Fan parameters",
      enable=has_mulFan_new));

  parameter Modelica.Units.SI.Time tSpe=180
    "Minimum amount of time for which calculated speed exceeds preset value for 
    speed to be changed"
    annotation(Dialog(group="Fan parameters",
      enable=has_mulFan_new));

  parameter Modelica.Units.SI.TemperatureDifference dTHys = 0.2
    "Temperature difference used for enabling cooling and heating mode"
    annotation(Dialog(tab="Advanced"));

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

  parameter Real TSupDew(
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature")=273.15 + 12
    "Supply air temperature limit under which condensation will be caused"
    annotation(Dialog(tab="Advanced"));

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeHea=Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of heating loop controller"
    annotation (Dialog(group="Heating mode control"));

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

  parameter Modelica.Blocks.Types.SimpleController controllerTypeSupHea=Modelica.Blocks.Types.SimpleController.PI
    "Type of supplementary heating controller"
    annotation (Dialog(group="Supplementary heating control"));

  parameter Real kSupHea(
    final unit="1",
    displayUnit="1",
    final min=0)=1
    "Gain of supplementary heating controller"
    annotation (Dialog(group="Supplementary heating control"));

  parameter Modelica.Units.SI.Time TiSupHea=120
    "Time constant of Integrator block for supplementary heating"
    annotation (Dialog(group="Supplementary heating control"));

  parameter Modelica.Units.SI.Time TdSupHea=0.1
    "Time constant of Derivative block for supplementary heating"
    annotation (Dialog(group="Supplementary heating control"));

  parameter Real TLocOut(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")=273.15-8
    "Minimum outdoor dry-bulb temperature for compressor operation";

  parameter Real dTHeaSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")=-2
    "Constant value to reduce heating setpoint for supplementary heating"
    annotation(Dialog(group="Setpoint adjustment"));

  Buildings.Fluid.ZoneEquipment.BaseClasses.VariableFan conVarFan(
    final has_hea=has_hea,
    final has_coo=has_coo,
    final controllerTypeCoo=controllerTypeCoo,
    final kCoo=kCoo,
    final TiCoo=TiCoo,
    final TdCoo=TdCoo,
    final controllerTypeHea=controllerTypeHea,
    final kHea=kHea,
    final TiHea=TiHea,
    final TdHea=TdHea,
    final minFanSpe=minFanSpe,
    final tFanEnaDel=tFanEnaDel,
    final tFanEna=tFanEna) if has_varFan
    "Variable-speed fan controller"
    annotation (Placement(transformation(extent={{36,-74},{60,-50}})));

  Buildings.Fluid.ZoneEquipment.BaseClasses.CyclingFan conFanCyc(
    final minFanSpe=minFanSpe,
    final tFanEnaDel=tFanEnaDel,
    final tFanEna=tFanEna) if has_conFan
    "Cycling fan control"
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));

  Buildings.Fluid.ZoneEquipment.BaseClasses.MultispeedFan conMulSpeFan(
    final has_hea=has_hea,
    final has_coo=has_coo,
    final nSpe=nSpe,
    final fanSpe=fanSpe,
    final tSpe=tSpe,
    final controllerTypeCoo=controllerTypeCoo,
    final kCoo=kCoo,
    final TiCoo=TiCoo,
    final TdCoo=TdCoo,
    final controllerTypeHea=controllerTypeHea,
    final kHea=kHea,
    final TiHea=TiHea,
    final TdHea=TdHea,
    final tFanEnaDel=tFanEnaDel,
    final tFanEna=tFanEna) if has_mulFan
    "Multi-speed fan controller"
    annotation (Placement(transformation(extent={{36,-118},{60,-94}})));

  Buildings.Fluid.ZoneEquipment.BaseClasses.HeatingCooling conCooMod(
    final controllerType=controllerTypeCoo,
    final k=kCoo,
    final TSupDew=TSupDew,
    final Ti=TiCoo,
    final Td=TdCoo,
    final dTHys=dTHys,
    final conMod=false,
    final tCoiEna=tFanEna) if has_coo
    "Cooling mode controller"
    annotation (Placement(transformation(extent={{-80,110},{-60,130}})));

  Buildings.Fluid.ZoneEquipment.BaseClasses.HeatingCooling conHeaMod(
    final controllerType=controllerTypeHea,
    final k=kHea,
    final TSupDew=TSupDew,
    final Ti=TiHea,
    final Td=TdHea,
    final dTHys=dTHys,
    final conMod=true,
    final tCoiEna=tFanEna) if has_hea
    "Heating mode controller"
    annotation (Placement(transformation(extent={{-80,66},{-60,86}})));

  Buildings.Fluid.ZoneEquipment.BaseClasses.SupplementalHeating conSupHea(
    final dTHys=dTHys,
    final controllerType=controllerTypeSupHea,
    final k=kSupHea,
    final Ti=TiSupHea,
    final Td=TdSupHea,
    final TLocOut=TLocOut,
    final dTHeaSet=dTHeaSet) if has_supHea
    "Supplementary heating controller"
    annotation (Placement(transformation(extent={{40,12},{60,32}})));

  Buildings.Controls.OBC.CDL.Logical.Or orFanEna
    "Enable fan when system enters heating mode or cooling mode"
    annotation (Placement(transformation(extent={{-30,40},{-10,60}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant conCoo(
    final k=false) if not has_coo
    "Constant false signal if cooling mode is not available"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant conHea(
    final k=false) if not has_hea
    "Constant false signal if heating mode is not available"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));

  parameter Boolean has_mulFan_new = has_mulFan
    "Does the zone equipment have multiple speed fan?"
    annotation(Dialog(enable=false, tab="Non-configurable"));

equation
  connect(fanOpeMod, conFanCyc.fanOpeMod) annotation (Line(points={{-160,-94},{
          -40,-94},{-40,-36},{38,-36}},  color={255,0,255}));
  connect(fanOpeMod, conMulSpeFan.fanOpeMod) annotation (Line(points={{-160,-94},
          {-40,-94},{-40,-116},{34,-116}}, color={255,0,255}));
  connect(uAva, conFanCyc.uAva) annotation (Line(points={{-160,-56},{-80,-56},{
          -80,-32},{38,-32}},
                          color={255,0,255}));
  connect(uAva, conVarFan.uAva) annotation (Line(points={{-160,-56},{-80,-56},{
          -80,-72},{34,-72}},
                          color={255,0,255}));
  connect(uAva, conMulSpeFan.uAva) annotation (Line(points={{-160,-56},{-80,-56},
          {-80,-112},{34,-112}}, color={255,0,255}));
  connect(conFanCyc.yFanSpe, yFanSpe) annotation (Line(points={{62,-28},{100,
          -28},{100,-80},{160,-80}},
                                color={0,0,127}));
  connect(conVarFan.yFanSpe, yFanSpe) annotation (Line(points={{62,-60},{100,
          -60},{100,-80},{160,-80}},
                                color={0,0,127}));
  connect(conMulSpeFan.yFanSpe, yFanSpe) annotation (Line(points={{62,-104},{
          100,-104},{100,-80},{160,-80}},
                                      color={0,0,127}));
  connect(conFanCyc.yFan, yFan) annotation (Line(points={{62,-32},{120,-32},{
          120,-120},{160,-120}},
                             color={255,0,255}));
  connect(conVarFan.yFan, yFan) annotation (Line(points={{62,-64},{120,-64},{
          120,-120},{160,-120}},
                             color={255,0,255}));
  connect(conMulSpeFan.yFan, yFan) annotation (Line(points={{62,-108},{100,-108},
          {100,-120},{160,-120}}, color={255,0,255}));
  connect(TZon, conVarFan.TZon) annotation (Line(points={{-160,94},{-100,94},{
          -100,-60},{34,-60}},
                          color={0,0,127}));
  connect(TZon, conMulSpeFan.TZon) annotation (Line(points={{-160,94},{-100,94},
          {-100,-100},{34,-100}}, color={0,0,127}));
  connect(TCooSet, conVarFan.TCooSet) annotation (Line(points={{-160,56},{-110,
          56},{-110,-64},{34,-64}},
                                color={0,0,127}));
  connect(TCooSet, conMulSpeFan.TCooSet) annotation (Line(points={{-160,56},{
          -110,56},{-110,-104},{34,-104}},
                                      color={0,0,127}));
  connect(THeaSet, conVarFan.THeaSet) annotation (Line(points={{-160,20},{-120,
          20},{-120,-68},{34,-68}},
                                color={0,0,127}));
  connect(THeaSet, conMulSpeFan.THeaSet) annotation (Line(points={{-160,20},{
          -120,20},{-120,-108},{34,-108}},
                                      color={0,0,127}));
  connect(uFan, conCooMod.uFan) annotation (Line(points={{-160,130},{-130,130},{
          -130,126},{-82,126}}, color={255,0,255}));
  connect(uFan, conHeaMod.uFan) annotation (Line(points={{-160,130},{-130,130},{
          -130,82},{-82,82}}, color={255,0,255}));
  connect(TZon, conCooMod.TZon) annotation (Line(points={{-160,94},{-100,94},{-100,
          122},{-82,122}}, color={0,0,127}));
  connect(TZon, conHeaMod.TZon) annotation (Line(points={{-160,94},{-100,94},{-100,
          78},{-82,78}}, color={0,0,127}));
  connect(TCooSet, conCooMod.TZonSet) annotation (Line(points={{-160,56},{-110,56},
          {-110,118},{-82,118}}, color={0,0,127}));
  connect(THeaSet, conHeaMod.TZonSet) annotation (Line(points={{-160,20},{-120,20},
          {-120,74},{-82,74}},      color={0,0,127}));
  connect(uFan, conFanCyc.uFan) annotation (Line(points={{-160,130},{-130,130},
          {-130,-24},{38,-24}},
                             color={255,0,255}));
  connect(conCooMod.yEna, yCooEna) annotation (Line(points={{-58,120},{160,120}},
                                color={255,0,255}));
  if not has_supHea then
                         connect(conHeaMod.yEna, yHeaEna) annotation (Line(points={{-58,76},
            {120,76},{120,80},{160,80}},
                         color={255,0,255})); end if;
  connect(conCooMod.yMod, orFanEna.u1) annotation (Line(points={{-58,116},{-40,116},
          {-40,50},{-32,50}}, color={255,0,255}));
  connect(conHeaMod.yMod, orFanEna.u2) annotation (Line(points={{-58,72},{-48,72},
          {-48,42},{-32,42}}, color={255,0,255}));
  connect(orFanEna.y, conFanCyc.heaCooOpe) annotation (Line(points={{-8,50},{0,
          50},{0,-28},{38,-28}},
                             color={255,0,255}));
  connect(conCoo.y, orFanEna.u1)
    annotation (Line(points={{-58,50},{-32,50}}, color={255,0,255}));
  connect(conHea.y, orFanEna.u2) annotation (Line(points={{-58,10},{-48,10},{-48,
          42},{-32,42}}, color={255,0,255}));
  connect(conHeaMod.yCoi, yHea) annotation (Line(points={{-58,80},{114,80},{114,
          -40},{160,-40}},      color={0,0,127}));
  connect(conCooMod.yCoi, yCoo) annotation (Line(points={{-58,124},{108,124},{108,
          0},{160,0}},          color={0,0,127}));
  connect(TSup, conCooMod.TSup) annotation (Line(points={{-160,-130},{-94,-130},
          {-94,114},{-82,114}},       color={0,0,127}));
  connect(conSupHea.THeaSet, THeaSet) annotation (Line(points={{38,30},{-120,30},
          {-120,20},{-160,20}},       color={0,0,127}));
  connect(TZon, conSupHea.TZon) annotation (Line(points={{-160,94},{-100,94},{-100,
          26},{38,26}},                       color={0,0,127}));
  connect(conSupHea.TOut, TOut) annotation (Line(points={{38,22},{-20,22},{-20,-20},
          {-160,-20}},      color={0,0,127}));
  connect(conSupHea.ySupHea, ySupHea) annotation (Line(points={{62,24},{118,24},
          {118,40},{160,40}},     color={0,0,127}));
  connect(conSupHea.yHeaEna, yHeaEna) annotation (Line(points={{62,20},{120,20},
          {120,80},{160,80}},color={255,0,255}));
  connect(conHeaMod.yEna, conSupHea.uHeaEna) annotation (Line(points={{-58,76},{
          10,76},{10,14},{38,14}},      color={255,0,255}));
  connect(conSupHea.uHeaMod, conHeaMod.yMod) annotation (Line(points={{38,18},{20,
          18},{20,72},{-58,72}},                   color={255,0,255}));
  connect(uFan, conVarFan.uFan) annotation (Line(points={{-160,130},{-130,130},
          {-130,-52},{34,-52}},color={255,0,255}));
  connect(orFanEna.y, conVarFan.heaCooOpe) annotation (Line(points={{-8,50},{0,
          50},{0,-56},{34,-56}},
                             color={255,0,255}));
  connect(orFanEna.y, conMulSpeFan.heaCooOpe) annotation (Line(points={{-8,50},
          {0,50},{0,-96},{34,-96}},  color={255,0,255}));
  annotation (defaultComponentName="conMod",
    Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
    <p>
    This is a control module for the HVAC zone equipment models designed as an analogue 
    to the control logic in EnergyPlus. The components are as follows:
    <ul>
    <li>
    Heating and cooling coil controller <code>conHea</code>: 
    <a href=\"Buildings.Fluid.ZoneEquipment.BaseClasses.HeatingCooling\">
    Buildings.Fluid.ZoneEquipment.BaseClasses.HeatingCooling</a>
    </li>
    <li>
    Cycling fan controller <code>conFanCyc</code>:
    <a href=\"Buildings.Fluid.ZoneEquipment.BaseClasses.CyclingFan\">
    Buildings.Fluid.ZoneEquipment.BaseClasses.CyclingFan</a>
    </li>
    <li>
    Variable fan controller <code>conVarFanConWat</code>:
    <a href=\"Buildings.Fluid.ZoneEquipment.BaseClasses.VariableFan\">
    Buildings.Fluid.ZoneEquipment.BaseClasses.VariableFan</a>
    </li>
    <li>
    Variable fan controller <code>conMulSpeFanConWat</code>:
    <a href=\"Buildings.Fluid.ZoneEquipment.BaseClasses.MultispeedFan\">
    Buildings.Fluid.ZoneEquipment.BaseClasses.MultispeedFan</a>
    </li>
    <li>
    Supplemental heating controller <code>conSupHea</code>:
    <a href=\"Buildings.Fluid.ZoneEquipment.BaseClasses.SupplementalHeating\">
    Buildings.Fluid.ZoneEquipment.BaseClasses.SupplementalHeating</a>
    </li>
    </ul>
    </html>
", revisions="<html>
    <ul>
    <li>
    June 15, 2023 by Karthik Devaprasad, Xing Lu, and Junke Wang:<br/>
    First implementation.
    </li>
    </ul>
    </html>"));
end ModularController;
