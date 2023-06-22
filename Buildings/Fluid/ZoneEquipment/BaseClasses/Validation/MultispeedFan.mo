within Buildings.Fluid.ZoneEquipment.BaseClasses.Validation;
model MultispeedFan
  "Validation model for multiple speed fan controller"
  extends Modelica.Icons.Example;

  Buildings.Fluid.ZoneEquipment.BaseClasses.MultispeedFan conMulSpeFan(
    final has_hea=true,
    final has_coo=true,
    final nSpe=4,
    final fanSpe={0.25,0.5,0.75,1},
    final kCoo=0.05,
    final TiCoo=60,
    final kHea=0.05,
    final TiHea=60)
    "Instance of controller for multiple speed fan"
    annotation (Placement(transformation(extent={{64,-14},{92,14}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant uAva(
    final k=true)
    "Availability signal"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TZon(
    final height=6,
    final duration=36000,
    final offset=273.15 + 19)
    "Measured zone temperature"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant heaSetPoi(
    final k=273.15 + 21)
    "Heating setpoint temperature"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant cooSetPoi(
    final k=273.15 + 23)
    "Cooling setpoint temperature"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse fanOpeMod(
    final period=21600,
    final shift=21600)
    "Fan operating mode"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));

  Buildings.Controls.OBC.CDL.Continuous.Greater greCooSet
    "Check if zone temperature is greater than cooling setpoint"
    annotation (Placement(transformation(extent={{-20,50},{0,70}})));

  Buildings.Controls.OBC.CDL.Logical.Or orHeaCooOpe
    "Enable heating-cooling operation if temperature setpoints are exceeded"
    annotation (Placement(transformation(extent={{20,40},{40,60}})));

  Buildings.Controls.OBC.CDL.Continuous.Less lesHeaSet
    "Check if zone temperature is lower than heating setpoint"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));

equation
  connect(conMulSpeFan.TZon, TZon.y) annotation (Line(points={{61.6667,7},{-30,
          7},{-30,60},{-58,60}},
                              color={0,0,127}));
  connect(conMulSpeFan.TCooSet, cooSetPoi.y) annotation (Line(points={{61.6667,
          2.33333},{-50,2.33333},{-50,20},{-58,20}},
                                            color={0,0,127}));
  connect(conMulSpeFan.THeaSet, heaSetPoi.y) annotation (Line(points={{61.6667,
          -2.33333},{-40,-2.33333},{-40,-20},{-58,-20}},
                                               color={0,0,127}));
  connect(fanOpeMod.y, conMulSpeFan.fanOpeMod) annotation (Line(points={{-58,-80},
          {20,-80},{20,-12},{22,-12},{22,-11.6667},{61.6667,-11.6667}}, color={255,
          0,255}));
  connect(heaSetPoi.y, lesHeaSet.u2) annotation (Line(points={{-58,-20},{-40,-20},
          {-40,22},{-22,22}}, color={0,0,127}));
  connect(TZon.y, lesHeaSet.u1) annotation (Line(points={{-58,60},{-30,60},{-30,
          30},{-22,30}}, color={0,0,127}));
  connect(TZon.y, greCooSet.u1)
    annotation (Line(points={{-58,60},{-22,60}}, color={0,0,127}));
  connect(cooSetPoi.y, greCooSet.u2) annotation (Line(points={{-58,20},{-50,20},
          {-50,52},{-22,52}}, color={0,0,127}));
  connect(greCooSet.y, orHeaCooOpe.u1) annotation (Line(points={{2,60},{10,60},{
          10,50},{18,50}}, color={255,0,255}));
  connect(lesHeaSet.y, orHeaCooOpe.u2) annotation (Line(points={{2,30},{10,30},{
          10,42},{18,42}}, color={255,0,255}));
  connect(orHeaCooOpe.y, conMulSpeFan.heaCooOpe) annotation (Line(points={{42,50},
          {50,50},{50,11.6667},{61.6667,11.6667}}, color={255,0,255}));
  connect(uAva.y, conMulSpeFan.uAva) annotation (Line(points={{-58,-50},{0,-50},
          {0,-7},{61.6667,-7}}, color={255,0,255}));
  annotation(Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
    <p>
    This simulation model is used to validate 
    <a href=\"modelica://Buildings.Fluid.ZoneEquipment.BaseClasses.MultispeedFan\">
    Buildings.Fluid.ZoneEquipment.BaseClasses.MultispeedFan</a>. 
    </p>
    <p>
    This model tests an instance <code>conMulSpeFan</code> of the controller, with 
    time-varying input signals for the fan operating mode <code>fanOpeMod</code> 
    and the measured zone temperature <code>TZon</code>. The heating-cooling operation 
    signal <code>heaCooOpe</code> is also derived from <code>TZon</code> and the 
    temperature setpoints <code>TCooSet</code> and <code>THeaSet</code>. The 
    following observations can be made from the plot.
    <ul>
    <li>
    the fan is enabled (<code>yFan=true</code>) when <code>TZon &gt; TCooSet</code>
    or <code>TZon &lt; THeaSet</code>, which sets <code>heaCooOpe</code> to 
    <code>true</code>. Also, <code>yFan=true</code> when <code>fanOpeMod</code>
    is <code>true</code>.
    </li>
    <li>
    When <code>yFan=true</code>, the fan speed <code>yFanSpe</code> is set to 
    minimum fan speed <code>fanSpe[1]</code> when <code>uFan=false</code>. When 
    <code>uFan=true</code>, <code>yFanSpe</code> is controlled to regulate 
    <code>TZon</code> between <code>TCooSet</code> and <code>THeaSet</code>. 
    <code>yFanSpe</code> is set to the next lowest available speed in <code>fanSpe</code>
    compared to the value calculated by the PID regulator.
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
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/ZoneEquipment/BaseClasses/Validation/MultispeedFan.mos"
        "Simulate and Plot"));
end MultispeedFan;
