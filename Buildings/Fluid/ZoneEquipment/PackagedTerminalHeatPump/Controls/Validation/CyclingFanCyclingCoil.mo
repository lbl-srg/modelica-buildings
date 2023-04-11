within Buildings.Fluid.ZoneEquipment.PackagedTerminalHeatPump.Controls.Validation;
model CyclingFanCyclingCoil
  "Validation model for controller with cycling coil cycling fan"
  extends Modelica.Icons.Example;

  Buildings.Fluid.ZoneEquipment.PackagedTerminalHeatPump.Controls.CyclingFanCyclingCoil
    conVarWatConFan(
    final heaCoiTyp=Buildings.Fluid.ZoneEquipment.BaseClasses.Types.HeaSou.heaPum,
    final cooCoiTyp=Buildings.Fluid.ZoneEquipment.BaseClasses.Types.CooSou.eleDX,
    final tFanEnaDel=0,
    final tFanEna=0,
    dTHys=0.2) "Instance of controller with cycling fan and cyling coil"
    annotation (Placement(transformation(extent={{10,-10},{30,10}})));

protected
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(
    final delayTime=0)
    annotation (Placement(transformation(extent={{50,-10},{70,10}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse supFanOpeMod(
    final period=900) "Supply fan operating mode signal"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TZon(
    final height=10,
    final duration=36000,
    final offset=273.15 + 15)
    "Measured zone temperature"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant heaSetPoi(
    final k=273.15 + 23)
    "Heating setpoint temperature"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse uAva(
    final period=2700)
    "System availability signal"
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant cooSetPoi(
    final k=273.15 + 24)
    "Cooling setpoint temperature"
    annotation (Placement(transformation(extent={{-40,80},{-20,100}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TSup(
    final height=6,
    final duration=3600,
    final offset=273.15 + 35)
    "Measured supply air temperature"
    annotation (Placement(transformation(extent={{-40,-100},{-20,-80}})));

equation
  connect(heaSetPoi.y, conVarWatConFan.THeaSet) annotation (Line(points={{-18,20},
          {-10,20},{-10,0},{8,0}},color={0,0,127}));
  connect(TZon.y, conVarWatConFan.TZon)
    annotation (Line(points={{-18,60},{0,60},{0,5.71429},{8,5.71429}},
                                                           color={0,0,127}));
  connect(supFanOpeMod.y, conVarWatConFan.fanOpeMod) annotation (Line(points={{-18,-60},
          {0,-60},{0,-5.71429},{8,-5.71429}},            color={255,0,255}));
  connect(uAva.y, conVarWatConFan.uAva) annotation (Line(points={{-18,-20},{-10,
          -20},{-10,-2.85714},{8,-2.85714}},       color={255,0,255}));
  connect(conVarWatConFan.yFan, truDel.u) annotation (Line(points={{32,-7.14286},
          {40.5555,-7.14286},{40.5555,0},{48,0}},           color={255,0,255}));
  connect(truDel.y, conVarWatConFan.uFan) annotation (Line(points={{72,0},{80,0},
          {80,20},{4,20},{4,8.57143},{8,8.57143}},       color={255,0,255}));
  connect(cooSetPoi.y, conVarWatConFan.TCooSet) annotation (Line(points={{-18,90},
          {-4,90},{-4,2.85714},{8,2.85714}},           color={0,0,127}));
  connect(TSup.y, conVarWatConFan.TSup) annotation (Line(points={{-18,-90},{4,-90},
          {4,-8.57143},{8,-8.57143}},            color={0,0,127}));
  annotation(Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>This simulation model is used to validate <a href=\"modelica://Buildings.Fluid.ZoneEquipment.PackagedTerminalHeatPump.Controls.CyclingFanCyclingCoil\">Buildings.Fluid.ZoneEquipment.PackagedTerminalHeatPump.Controls.CyclingFanCyclingCoil</a>.  </p>
</html>",revisions="<html>
      <ul>
      <li>
      April 10, 2023 by Karthik Devaprasad and Xing Lu:<br/>
      First implementation.
      </li>
      </ul>
      </html>"),
    experiment(
      StopTime=86400,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"));
end CyclingFanCyclingCoil;
