within Buildings.Fluid.ZoneEquipment.BaseClasses.Validation;
model ModularController
  "Validation model for controller with constant speed fan and DX coils"
  extends Modelica.Icons.Example;

  Buildings.Fluid.ZoneEquipment.BaseClasses.ModularController modCon(
    final sysTyp=Buildings.Fluid.ZoneEquipment.BaseClasses.Types.SystemTypes.pthp,
    final fanTyp=Buildings.Fluid.ZoneEquipment.BaseClasses.Types.FanTypes.conSpeFan,
    final has_fanOpeMod=true,
    final tFanEna=0,
    final dTHys=0.2)
    "Instance of packaged terminal heat pump controller"
    annotation (Placement(transformation(extent={{12,54},{24,66}})));

  Buildings.Fluid.ZoneEquipment.BaseClasses.ModularController modCon1(
    final sysTyp=Buildings.Fluid.ZoneEquipment.BaseClasses.Types.SystemTypes.windowAC,
    final fanTyp=Buildings.Fluid.ZoneEquipment.BaseClasses.Types.FanTypes.conSpeFan,
    final has_fanOpeMod=true,
    final tFanEna=0,
    final dTHys=0.2)
    "Instance of window air conditioner controller"
    annotation (Placement(transformation(extent={{-48,-48},{-36,-36}})));

  Buildings.Fluid.ZoneEquipment.BaseClasses.ModularController modCon2(
    final sysTyp=Buildings.Fluid.ZoneEquipment.BaseClasses.Types.SystemTypes.ptac,
    final fanTyp=Buildings.Fluid.ZoneEquipment.BaseClasses.Types.FanTypes.conSpeFan,
    final has_fanOpeMod=true,
    final tFanEna=0,
    final dTHys=0.2)
    "Instance of packaged terminal air conditioner"
    annotation (Placement(transformation(extent={{52,-44},{64,-32}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(
    final delayTime=10)
    "Artificial delay for proven on signal"
    annotation (Placement(transformation(extent={{40,50},{50,60}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse supFanOpeMod(
    final period=900)
    "Supply fan operating mode signal"
    annotation (Placement(transformation(extent={{-28,16},{-20,24}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TZon(
    final height=10,
    final duration=36000,
    final offset=273.15 + 15) "Measured zone temperature"
    annotation (Placement(transformation(extent={{-28,86},{-20,94}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant heaSetPoi(
    final k=273.15 + 23)
    "Heating setpoint temperature"
    annotation (Placement(transformation(extent={{-28,58},{-20,66}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse uAva(
    final period=2700)
    "System availability signal"
    annotation (Placement(transformation(extent={{-28,30},{-20,38}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant cooSetPoi(
    final k=273.15 + 24)
    "Cooling setpoint temperature"
    annotation (Placement(transformation(extent={{-28,72},{-20,80}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TSup(
    final height=6,
    final duration=3600,
    final offset=273.15 + 35)
    "Measured supply air temperature"
    annotation (Placement(transformation(extent={{-28,2},{-20,10}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TOut(
    final height=5,
    final duration=36000,
    final offset=273.15 + 0) "Outdoor air temperature"
    annotation (Placement(transformation(extent={{-28,44},{-20,52}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel1(
    final delayTime=10)
    "Artificial delay for proven on signal"
    annotation (Placement(transformation(extent={{-20,-52},{-10,-42}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse supFanOpeMod1(
    final period=900)
    "Supply fan operating mode signal"
    annotation (Placement(transformation(extent={{-88,-74},{-80,-66}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TZon1(
    final height=10,
    final duration=36000,
    final offset=273.15 + 15) "Measured zone temperature"
    annotation (Placement(transformation(extent={{-88,-18},{-80,-10}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse uAva1(
    final period=2700)
    "System availability signal"
    annotation (Placement(transformation(extent={{-88,-56},{-80,-48}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant cooSetPoi1(
    final k=273.15 + 24)
    "Cooling setpoint temperature"
    annotation (Placement(transformation(extent={{-88,-38},{-80,-30}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TSup1(
    final height=6,
    final duration=3600,
    final offset=273.15 + 35)
    "Measured supply air temperature"
    annotation (Placement(transformation(extent={{-88,-92},{-80,-84}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel2(
    final delayTime=10)
    "Artificial delay for proven on signal"
    annotation (Placement(transformation(extent={{80,-48},{90,-38}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse supFanOpeMod2(
    final period=900)
    "Supply fan operating mode signal"
    annotation (Placement(transformation(extent={{12,-80},{20,-72}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TZon2(
    final height=10,
    final duration=36000,
    final offset=273.15 + 15) "Measured zone temperature"
    annotation (Placement(transformation(extent={{12,-12},{20,-4}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant heaSetPoi2(
    final k=273.15 + 23)
    "Heating setpoint temperature"
    annotation (Placement(transformation(extent={{12,-48},{20,-40}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse uAva2(
    final period=2700)
    "System availability signal"
    annotation (Placement(transformation(extent={{12,-64},{20,-56}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant cooSetPoi2(
    final k=273.15 + 24)
    "Cooling setpoint temperature"
    annotation (Placement(transformation(extent={{12,-30},{20,-22}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TSup2(
    final height=6,
    final duration=3600,
    final offset=273.15 + 35)
    "Measured supply air temperature"
    annotation (Placement(transformation(extent={{12,-96},{20,-88}})));

equation
  connect(heaSetPoi.y, modCon.THeaSet) annotation (Line(points={{-19.2,62},{-4,
          62},{-4,60.8571},{10.8,60.8571}},
                                        color={0,0,127}));
  connect(TZon.y, modCon.TZon) annotation (Line(points={{-19.2,90},{10.8,90},{
          10.8,64.0286}},
                     color={0,0,127}));
  connect(supFanOpeMod.y, modCon.fanOpeMod) annotation (Line(points={{-19.2,20},
          {4,20},{4,55.9714},{10.8,55.9714}}, color={255,0,255}));
  connect(uAva.y, modCon.uAva) annotation (Line(points={{-19.2,34},{0,34},{0,
          57.4286},{10.8,57.4286}},
                           color={255,0,255}));
  connect(modCon.yFan, truDel.u) annotation (Line(points={{25.2,54.8571},{25.2,
          55},{39,55}},
                    color={255,0,255}));
  connect(truDel.y, modCon.uFan) annotation (Line(points={{51,55},{54,55},{54,
          72},{4,72},{4,65.5714},{10.8,65.5714}},
                                              color={255,0,255}));
  connect(cooSetPoi.y, modCon.TCooSet) annotation (Line(points={{-19.2,76},{0,
          76},{0,62.4857},{10.8,62.4857}},
                                       color={0,0,127}));
  connect(TSup.y, modCon.TSup) annotation (Line(points={{-19.2,6},{8,6},{8,54},
          {10.8,54},{10.8,54.4286}},color={0,0,127}));
  connect(TOut.y, modCon.TOut) annotation (Line(points={{-19.2,48},{-4,48},{-4,
          59.1429},{10.8,59.1429}},
                           color={0,0,127}));
  connect(TZon1.y, modCon1.TZon) annotation (Line(points={{-79.2,-14},{-49.2,
          -14},{-49.2,-37.9714}},
                             color={0,0,127}));
  connect(supFanOpeMod1.y, modCon1.fanOpeMod) annotation (Line(points={{-79.2,
          -70},{-60,-70},{-60,-46.0286},{-49.2,-46.0286}},
                                                      color={255,0,255}));
  connect(uAva1.y, modCon1.uAva) annotation (Line(points={{-79.2,-52},{-66,-52},
          {-66,-44.5714},{-49.2,-44.5714}}, color={255,0,255}));
  connect(modCon1.yFan, truDel1.u) annotation (Line(points={{-34.8,-47.1429},{
          -34.8,-47},{-21,-47}},
                           color={255,0,255}));
  connect(truDel1.y, modCon1.uFan) annotation (Line(points={{-9,-47},{-8,-47},{
          -8,-30},{-60,-30},{-60,-36.4286},{-49.2,-36.4286}},
                                                           color={255,0,255}));
  connect(cooSetPoi1.y, modCon1.TCooSet) annotation (Line(points={{-79.2,-34},{
          -66,-34},{-66,-39.5143},{-49.2,-39.5143}},
                                                 color={0,0,127}));
  connect(TSup1.y, modCon1.TSup) annotation (Line(points={{-79.2,-88},{-54,-88},
          {-54,-48},{-49.2,-48},{-49.2,-47.5714}}, color={0,0,127}));
  connect(heaSetPoi2.y, modCon2.THeaSet) annotation (Line(points={{20.8,-44},{
          32,-44},{32,-37.1429},{50.8,-37.1429}},
                                               color={0,0,127}));
  connect(TZon2.y, modCon2.TZon) annotation (Line(points={{20.8,-8},{50.8,-8},{
          50.8,-33.9714}},
                      color={0,0,127}));
  connect(supFanOpeMod2.y, modCon2.fanOpeMod) annotation (Line(points={{20.8,
          -76},{40,-76},{40,-42.0286},{50.8,-42.0286}},
                                                   color={255,0,255}));
  connect(uAva2.y, modCon2.uAva) annotation (Line(points={{20.8,-60},{36,-60},{
          36,-40.5714},{50.8,-40.5714}},
                                      color={255,0,255}));
  connect(modCon2.yFan, truDel2.u) annotation (Line(points={{65.2,-43.1429},{
          65.2,-43},{79,-43}},
                          color={255,0,255}));
  connect(truDel2.y, modCon2.uFan) annotation (Line(points={{91,-43},{92,-43},{
          92,-26},{36,-26},{36,-32.4286},{50.8,-32.4286}},
                                                        color={255,0,255}));
  connect(cooSetPoi2.y, modCon2.TCooSet) annotation (Line(points={{20.8,-26},{
          32,-26},{32,-35.5143},{50.8,-35.5143}},
                                               color={0,0,127}));
  connect(TSup2.y, modCon2.TSup) annotation (Line(points={{20.8,-92},{46,-92},{
          46,-44},{50.8,-44},{50.8,-43.5714}},
                                            color={0,0,127}));
  annotation(Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
    <p>
    This simulation model is used to validate 
    <a href=\"modelica://Buildings.Fluid.ZoneEquipment.BaseClasses.ModularController\">
    Buildings.Fluid.ZoneEquipment.BaseClasses.ModularController</a>.  
    </p>
</html>",revisions="<html>
      <ul>
      <li>
      June 20, 2023 by Junke Wang and Karthik Devaprasad:<br/>
      First implementation.
      </li>
      </ul>
      </html>"),
    experiment(Tolerance=1e-06),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/ZoneEquipment/BaseClasses/Validation/ModularController.mos"
        "Simulate and plot"));
end ModularController;
