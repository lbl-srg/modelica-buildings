within Buildings.Fluid.ZoneEquipment.BaseClasses;
model ModularController
  extends Buildings.Fluid.ZoneEquipment.BaseClasses.ControllerInterfaces;

  parameter Modelica.Units.SI.Time tFanEnaDel = 30
    "Time period for delay between switching from deadband mode to heating/cooling mode"
    annotation(Dialog(group="System parameters"));

  parameter Modelica.Units.SI.Time tFanEna = 300
    "Minimum duration for which fan is enabled"
    annotation(Dialog(group="System parameters"));

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
    "Gain of cooling loop controller"
    annotation(Dialog(group="Heating mode control"));

  parameter Modelica.Units.SI.Time TiHea=0.5
    "Time constant of cooling loop integrator block"
    annotation(Dialog(group="Heating mode control",
      enable = controllerTypeHea == Buildings.Controls.OBC.CDL.Types.SimpleController.PI or
      controllerTypeHea == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Modelica.Units.SI.Time TdHea=0.1
    "Time constant of cooling loop derivative block"
    annotation(Dialog(group="Heating mode control",
      enable = controllerTypeHea == Buildings.Controls.OBC.CDL.Types.SimpleController.PD or
      controllerTypeHea == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Modelica.Blocks.Types.SimpleController controllerType=Modelica.Blocks.Types.SimpleController.PI
    "Type of supplementary heating controller"
    annotation (Dialog(group="Supplementary heating control"));

  parameter Real k=1
    "Gain of supplementary heating controller"
    annotation (Dialog(group="Supplementary heating control"));

  parameter Modelica.Units.SI.Time Ti=120
    "Time constant of Integrator block for supplementary heating"
    annotation (Dialog(group="Supplementary heating control"));

  parameter Modelica.Units.SI.Time Td=0.1
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

  Buildings.Fluid.ZoneEquipment.BaseClasses.VariableFan conVarFanConWat(has_hea=has_hea, has_coo=has_coo,
    controllerTypeCoo=controllerTypeCoo,
    kCoo=kCoo,
    TiCoo=TiCoo,
    TdCoo=TdCoo,
    controllerTypeHea=controllerTypeHea,
    kHea=kHea,
    TiHea=TiHea,
    TdHea=TdHea) if has_varFan
    annotation (Placement(transformation(extent={{16,-74},{44,-46}})));

  Buildings.Fluid.ZoneEquipment.BaseClasses.CyclingFan conFanCyc(
    tFanEnaDel=tFanEnaDel, tFanEna=tFanEna) if has_conFan
                                            "Cycling fan control"
    annotation (Placement(transformation(extent={{16,-36},{44,-8}})));

  Buildings.Fluid.ZoneEquipment.BaseClasses.MultispeedFan conMulSpeFanConWat(has_hea=has_hea, has_coo=has_coo,
    controllerTypeCoo=controllerTypeCoo,
    kCoo=kCoo,
    TiCoo=TiCoo,
    TdCoo=TdCoo,
    controllerTypeHea=controllerTypeHea,
    kHea=kHea,
    TiHea=TiHea,
    TdHea=TdHea) if has_mulFan
    annotation (Placement(transformation(extent={{16,-134},{44,-106}})));

  Buildings.Fluid.ZoneEquipment.BaseClasses.HeatingCooling conCooMod(
    controllerType=controllerTypeCoo,
    k=kCoo,
    TSupDew=TSupDew,
    Ti=TiCoo,
    Td=TdCoo,
    dTHys=dTHys,
    conMod=false,
    tCoiEna=tFanEna)              if has_coo "Cooling mode controller"
    annotation (Placement(transformation(extent={{-84,106},{-56,134}})));

  Buildings.Fluid.ZoneEquipment.BaseClasses.HeatingCooling conHeaMod(
    controllerType=controllerTypeHea,
    k=kHea,
    TSupDew=TSupDew,
    Ti=TiHea,
    Td=TdHea,
    dTHys=dTHys,
    conMod=true,
    tCoiEna=tFanEna)           if has_hea "Heating mode controller"
    annotation (Placement(transformation(extent={{-84,66},{-56,94}})));

  Buildings.Fluid.ZoneEquipment.BaseClasses.SupplementalHeating conSupHea(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=k,
    Ti=Ti,
    Td=Td,
    TLocOut=TLocOut,
    dTHeaSet=dTHeaSet) if has_supHea "Supplementary heating controller"
    annotation (Placement(transformation(extent={{34,6},{62,34}})));

  Buildings.Controls.OBC.CDL.Logical.Or orFanEna
    "Enable fan when system enters heating mode or cooling mode"
    annotation (Placement(transformation(extent={{-28,36},{-8,56}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant conCoo(k=false) if not has_coo
    "Constant false signal if cooling mode is not available"
    annotation (Placement(transformation(extent={{-90,36},{-70,56}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant conHea(k=false) if not has_hea
    "Constant false signal if heating mode is not available"
    annotation (Placement(transformation(extent={{-90,-6},{-70,14}})));

equation
  connect(fanOpeMod, conFanCyc.fanOpeMod) annotation (Line(points={{-160,-94},{-40,
          -94},{-40,-30.4},{13.2,-30.4}},color={255,0,255}));
  connect(fanOpeMod, conMulSpeFanConWat.fanOpeMod) annotation (Line(points={{-160,
          -94},{-40,-94},{-40,-132},{14,-132}},   color={255,0,255}));
  connect(uAva, conFanCyc.uAva) annotation (Line(points={{-160,-56},{-60,-56},{-60,
          -24.8},{13.2,-24.8}},
                          color={255,0,255}));
  connect(uAva, conVarFanConWat.uAva) annotation (Line(points={{-160,-56},{-60,-56},
          {-60,-72},{14,-72}}, color={255,0,255}));
  connect(uAva, conMulSpeFanConWat.uAva) annotation (Line(points={{-160,-56},{-60,
          -56},{-60,-126},{14,-126}}, color={255,0,255}));
  connect(conFanCyc.yFanSpe, yFanSpe) annotation (Line(points={{46.8,-19.2},{
          100,-19.2},{100,-80},{160,-80}},
                                color={0,0,127}));
  connect(conVarFanConWat.yFanSpe, yFanSpe) annotation (Line(points={{46,-56},{
          100,-56},{100,-80},{160,-80}},
                                     color={0,0,127}));
  connect(conMulSpeFanConWat.yFanSpe, yFanSpe) annotation (Line(points={{46,-116},
          {100,-116},{100,-80},{160,-80}}, color={0,0,127}));
  connect(conFanCyc.yFan, yFan) annotation (Line(points={{46.8,-24.8},{120,
          -24.8},{120,-120},{160,-120}},
                             color={255,0,255}));
  connect(conVarFanConWat.yFan, yFan) annotation (Line(points={{46,-64},{120,
          -64},{120,-120},{160,-120}},
                                  color={255,0,255}));
  connect(conMulSpeFanConWat.yFan, yFan) annotation (Line(points={{46,-124},{
          120,-124},{120,-120},{160,-120}},
                                        color={255,0,255}));
  connect(TZon, conVarFanConWat.TZon) annotation (Line(points={{-160,94},{-100,94},
          {-100,-48},{14,-48}}, color={0,0,127}));
  connect(TZon, conMulSpeFanConWat.TZon) annotation (Line(points={{-160,94},{-100,
          94},{-100,-108},{14,-108}}, color={0,0,127}));
  connect(TCooSet, conVarFanConWat.TCooSet) annotation (Line(points={{-160,56},{
          -110,56},{-110,-56},{14,-56}}, color={0,0,127}));
  connect(TCooSet, conMulSpeFanConWat.TCooSet) annotation (Line(points={{-160,56},
          {-110,56},{-110,-114},{14,-114}}, color={0,0,127}));
  connect(THeaSet, conVarFanConWat.THeaSet) annotation (Line(points={{-160,20},{
          -120,20},{-120,-64},{14,-64}},   color={0,0,127}));
  connect(THeaSet, conMulSpeFanConWat.THeaSet) annotation (Line(points={{-160,20},
          {-120,20},{-120,-120},{14,-120}},  color={0,0,127}));
  connect(uFan, conCooMod.uFan) annotation (Line(points={{-160,130},{-130,130},{
          -130,128.4},{-86.8,128.4}},
                                color={255,0,255}));
  connect(uFan, conHeaMod.uFan) annotation (Line(points={{-160,130},{-130,130},{
          -130,88.4},{-86.8,88.4}},
                              color={255,0,255}));
  connect(TZon, conCooMod.TZon) annotation (Line(points={{-160,94},{-100,94},{-100,
          122.8},{-86.8,122.8}},
                           color={0,0,127}));
  connect(TZon, conHeaMod.TZon) annotation (Line(points={{-160,94},{-100,94},{-100,
          82.8},{-86.8,82.8}},
                         color={0,0,127}));
  connect(TCooSet, conCooMod.TZonSet) annotation (Line(points={{-160,56},{-110,56},
          {-110,117.2},{-86.8,117.2}},
                                 color={0,0,127}));
  connect(THeaSet, conHeaMod.TZonSet) annotation (Line(points={{-160,20},{-120,20},
          {-120,77.2},{-86.8,77.2}},color={0,0,127}));
  connect(uFan, conFanCyc.uFan) annotation (Line(points={{-160,130},{-130,130},{
          -130,-13.6},{13.2,-13.6}},
                             color={255,0,255}));
  connect(conCooMod.yEna, yCooEna) annotation (Line(points={{-53.2,120},{120,
          120},{120,120},{160,120}},
                                color={255,0,255}));
  if not has_supHea then
                         connect(conHeaMod.yEna, yHeaEna) annotation (Line(points={{-53.2,
            80},{120,80},{120,80},{160,80}},
                         color={255,0,255})); end if;
  connect(conCooMod.yMod, orFanEna.u1) annotation (Line(points={{-53.2,114.4},{-40,
          114.4},{-40,46},{-30,46}},
                              color={255,0,255}));
  connect(conHeaMod.yMod, orFanEna.u2) annotation (Line(points={{-53.2,74.4},{-48,
          74.4},{-48,38},{-30,38}},
                              color={255,0,255}));
  connect(orFanEna.y, conFanCyc.heaCooOpe) annotation (Line(points={{-6,46},{0,46},
          {0,-19.2},{13.2,-19.2}},
                             color={255,0,255}));
  connect(conCoo.y, orFanEna.u1)
    annotation (Line(points={{-68,46},{-30,46}}, color={255,0,255}));
  connect(conHea.y, orFanEna.u2) annotation (Line(points={{-68,4},{-48,4},{-48,38},
          {-30,38}},     color={255,0,255}));
  connect(conHeaMod.yCoi, yHea) annotation (Line(points={{-53.2,85.6},{114,85.6},
          {114,-40},{160,-40}}, color={0,0,127}));
  connect(conCooMod.yCoi, yCoo) annotation (Line(points={{-53.2,125.6},{108,
          125.6},{108,0},{160,0}},
                                color={0,0,127}));
  connect(TSup, conCooMod.TSup) annotation (Line(points={{-160,-130},{-94,-130},
          {-94,111.6},{-86.8,111.6}}, color={0,0,127}));
  connect(conHeaMod.TSup, TSup) annotation (Line(points={{-86.8,71.6},{-86.8,72},
          {-94,72},{-94,-130},{-160,-130}}, color={0,0,127}));
  connect(conSupHea.THeaSet, THeaSet) annotation (Line(points={{31.2,31.2},{-120,
          31.2},{-120,20},{-160,20}}, color={0,0,127}));
  connect(TZon, conSupHea.TZon) annotation (Line(points={{-160,94},{-100,94},{-100,
          26},{32,26},{32,25.6},{31.2,25.6}}, color={0,0,127}));
  connect(conSupHea.TOut, TOut) annotation (Line(points={{31.2,20},{-20,20},{-20,
          -20},{-160,-20}}, color={0,0,127}));
  connect(conSupHea.ySupHea, ySupHea) annotation (Line(points={{64.8,22.8},{118,
          22.8},{118,40},{160,40}},
                                  color={0,0,127}));
  connect(conSupHea.yHeaEna, yHeaEna) annotation (Line(points={{64.8,17.2},{78,
          17.2},{78,80},{160,80}},
                             color={255,0,255}));
  connect(conHeaMod.yEna, conSupHea.uHeaEna) annotation (Line(points={{-53.2,80},
          {10,80},{10,8.8},{31.2,8.8}}, color={255,0,255}));
  connect(conSupHea.uHeaMod, conHeaMod.yMod) annotation (Line(points={{31.2,
          14.4},{20,14.4},{20,74.4},{-53.2,74.4}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
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
