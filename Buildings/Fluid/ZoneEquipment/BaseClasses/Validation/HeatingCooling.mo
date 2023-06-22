within Buildings.Fluid.ZoneEquipment.BaseClasses.Validation;
model HeatingCooling
  "Validation model for heating/cooling operation mode controller"
  extends Modelica.Icons.Example;

  Buildings.Fluid.ZoneEquipment.BaseClasses.HeatingCooling conCooMod(
    final conMod=false,
    final k=0.05,
    final Ti=60,
    final tCoiEna=200)
    "Cooling mode controller"
    annotation (Placement(transformation(extent={{32,38},{60,66}})));

  Buildings.Fluid.ZoneEquipment.BaseClasses.HeatingCooling conHeaMod(
    final conMod=true,
    final k=0.05,
    final Ti=60,
    final tCoiEna=200)
    "Heating mode controller"
    annotation (Placement(transformation(extent={{30,-64},{58,-36}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TZon(
    final height=8,
    final duration=1500,
    final offset=273.15 + 20)
    "Measured zone temperature"
    annotation (Placement(transformation(extent={{-40,58},{-26,72}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant heaSetPoi(
    final k=273.15+ 23)
    "Heating setpoint temperature"
    annotation (Placement(transformation(extent={{-40,-70},{-26,-56}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TSup(
    final height=-10,
    final duration=750,
    final offset=273.15 + 20,
    final startTime=700)
    "Measured supply air temperature"
    annotation (Placement(transformation(extent={{-40,6},{-26,20}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant cooSetPoi(
    final k=273.15 + 24)
    "Cooling setpoint temperature"
    annotation (Placement(transformation(extent={{-40,32},{-26,46}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TZon1(
    final height=-8,
    final duration=1500,
    final offset=273.15 + 28)
    "Measured zone temperature"
    annotation (Placement(transformation(extent={{-40,-44},{-26,-30}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse uFan(
    final period=150)
    "Fan proven on signal"
    annotation (Placement(transformation(extent={{-40,82},{-26,96}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse uFan1(
    final period=150)
    "Fan proven on signal"
    annotation (Placement(transformation(extent={{-40,-20},{-26,-6}})));

equation
  connect(TZon.y, conCooMod.TZon) annotation (Line(points={{-24.6,65},{0,65},{0,
          54.8},{29.2,54.8}}, color={0,0,127}));
  connect(cooSetPoi.y, conCooMod.TZonSet) annotation (Line(points={{-24.6,39},{0,
          39},{0,49.2},{29.2,49.2}}, color={0,0,127}));
  connect(TSup.y, conCooMod.TSup) annotation (Line(points={{-24.6,13},{12,13},{12,
          44},{30,44},{30,43.6},{29.2,43.6}}, color={0,0,127}));
  connect(TZon1.y, conHeaMod.TZon) annotation (Line(points={{-24.6,-37},{0,-37},
          {0,-47.2},{27.2,-47.2}}, color={0,0,127}));
  connect(heaSetPoi.y, conHeaMod.TZonSet) annotation (Line(points={{-24.6,-63},{
          0,-63},{0,-52.8},{27.2,-52.8}}, color={0,0,127}));
  connect(uFan1.y, conHeaMod.uFan) annotation (Line(points={{-24.6,-13},{10,-13},
          {10,-42},{27.2,-42},{27.2,-41.6}}, color={255,0,255}));
  connect(uFan.y, conCooMod.uFan) annotation (Line(points={{-24.6,89},{-24.6,88},
          {12,88},{12,60},{29.2,60},{29.2,60.4}}, color={255,0,255}));
  annotation(Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
    <p>
    This simulation model is used to validate 
    <a href=\"modelica://Buildings.Fluid.ZoneEquipment.BaseClasses.HeatingCooling\">
    Buildings.Fluid.ZoneEquipment.BaseClasses.HeatingCooling</a>. 
    </p>
    <p>
    It tests two instances of the class, <code>conCooMod</code> for cooling and 
    <code>conHeaMod</code> for heating. It has time-varying input signals for the 
    measured zone temperature, fan proven on signal and measured supply air temperature.
    The following observations can be made from the plots.
    <ul>
    <li>
    <code>conCooMod</code> enters cooling mode (<code>conCooMod.yMod = true</code>)
    when the zone temperature <code>conCooMod.TZon</code> rises above the cooling 
    setpoint <code>conCooMod.TZonSet</code>.
    </li>
    <li>
    It enables cooling (<code>conCooMod.yEna = true</code>) only when fan is proven 
    on (<code>uFan=true</code>), supply air temperature <code>TSup</code> is above 
    the nominal dewpoint temperature of zone air <code>TSupDew</code> and
    <code>conCooMod.yMod = true</code>.
    </li>
    <li>
    Similarly, it enters heating mode (<code>conHeaMod.yMod = true</code>) when 
    <code>TZon</code> is below <code>TZonSet</code>, and enables the heating 
    (<code>yEna=true</code>) when <code>uFan=true</code>.
    </li>
    </ul>
    </p>
    </html>",revisions="<html>
      <ul>
      <li>
      June 20, 2023, by Junke Wang and Karthik Devaprasad:<br/>
      First implementation.
      </li>
      </ul>
      </html>"),
    experiment(Tolerance=1e-06),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/ZoneEquipment/BaseClasses/Validation/HeatingCooling.mos"
        "Simulate and Plot"),
    Documentation(info="<html>
    <p>
    This is a validation model for the controller 
    <a href=\"modelica://Buildings.Fluid.ZoneEquipment.BaseClasses.HeatingCooling\">
    Buildings.Fluid.ZoneEquipment.BaseClasses.HeatingCooling</a>. The model comprises the controllers
    (<code>conCooMod</code> and <code>conHeaMod</code>), which receive input signals including zone temperatures 
    (<code>Tzon</code> and <code>Tzon1</code>), zone temperature setpoints (<code>heaSetPoi</code> and 
    <code>cooSetPoi</code>), supply air temperatures (<code>TSup</code> and <code>TSup1</code>), and 
    fan signals (<code>uFan</code> and <code>uFan1</code>) for cooling and heating modes, respectively. 
    </p>
    <p>
    Simulation results are observed as follows: 
    <ul>
    <li>
    When the measured zone temperature <code>TZon</code> exceeds the setpoint <code>TZonSet</code> 
    with a specific deadband and the fan is proven on (<code>uFan=true</code>), the cooling coil is enabled 
    (<code>conCooMod.yEna=true</code>). 
    </li>
    <li>
    When the measured zone temperature <code>TZon</code> is below the setpoint <code>TZonSet</code> 
    with a specific deadband and the fan is proven on (<code>uFan=true</code>), the heating coil is enabled 
    (<code>conHeaMod.yEna=true</code>). 
    </li>
    </ul>
    </p>
    </html>",revisions="<html>
    <ul>
    <li>
    June 21, 2023, by Junke Wang and Karthik Devaprasad:<br/>
    First implementation.
    </li>
    </ul>
    </html>"));
end HeatingCooling;
