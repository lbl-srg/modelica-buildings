within Buildings.Fluid.ZoneEquipment.BaseClasses.Validation;
model VariableFan
  "Validation model for variable fan controller"
  extends Modelica.Icons.Example;

  Buildings.Fluid.ZoneEquipment.BaseClasses.VariableFan conVarFan(
    final has_hea=true,
    final has_coo=true,
    kCoo=0.05,
    TiCoo=60,
    kHea=0.05,
    TiHea=60,
    final minFanSpe=0.1) "Instance of controller with variable speed fan"
    annotation (Placement(transformation(extent={{66,-14},{94,14}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse uFan(
    final period=21600,
    final shift=10800)
    "Fan proven on signal"
    annotation (Placement(transformation(extent={{-90,70},{-70,90}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TZon(
    final height=12,
    final duration=36000,
    final offset=273.15 + 16)
    "Measured zone temperature"
    annotation (Placement(transformation(extent={{-90,10},{-70,30}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant heaSetPoi(
    final k=273.15 + 21)
    "Heating setpoint temperature"
    annotation (Placement(transformation(extent={{-90,-60},{-70,-40}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant cooSetPoi(
    final k=273.15 + 23)
    "Cooling setpoint temperature"
    annotation (Placement(transformation(extent={{-90,-30},{-70,-10}})));

  Buildings.Controls.OBC.CDL.Continuous.Greater greCooSet
    "Check if zone temperature is greater than cooling setpoint"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));

  Buildings.Controls.OBC.CDL.Continuous.Less lesHeaSet
    "Check if zone temperature is lower than heating setpoint"
    annotation (Placement(transformation(extent={{-20,10},{0,30}})));

  Buildings.Controls.OBC.CDL.Logical.Or orHeaCooOpe
    "Enable heating-cooling operation if temperature setpoints are exceeded"
    annotation (Placement(transformation(extent={{20,30},{40,50}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant uAva(
    final k=true)
    "Availability signal"
    annotation (Placement(transformation(extent={{-90,-90},{-70,-70}})));

equation
  connect(TZon.y, conVarFan.TZon) annotation (Line(points={{-68,20},{-50,20},{
          -50,2.33333},{63.6667,2.33333}},
                                       color={0,0,127}));
  connect(conVarFan.TCooSet, cooSetPoi.y) annotation (Line(points={{63.6667,
          -2.33333},{-40,-2.33333},{-40,-20},{-68,-20}},
                                               color={0,0,127}));
  connect(conVarFan.THeaSet, heaSetPoi.y) annotation (Line(points={{63.6667,-7},
          {-30,-7},{-30,-50},{-68,-50}}, color={0,0,127}));
  connect(uFan.y, conVarFan.uFan) annotation (Line(points={{-68,80},{60,80},{60,
          11.6667},{63.6667,11.6667}}, color={255,0,255}));
  connect(uAva.y, conVarFan.uAva) annotation (Line(points={{-68,-80},{26,-80},{
          26,-11.6667},{63.6667,-11.6667}},
                                         color={255,0,255}));
  connect(TZon.y, greCooSet.u1) annotation (Line(points={{-68,20},{-50,20},{-50,
          50},{-22,50}}, color={0,0,127}));
  connect(cooSetPoi.y, greCooSet.u2) annotation (Line(points={{-68,-20},{-40,-20},
          {-40,42},{-22,42}}, color={0,0,127}));
  connect(TZon.y, lesHeaSet.u1)
    annotation (Line(points={{-68,20},{-22,20}}, color={0,0,127}));
  connect(heaSetPoi.y, lesHeaSet.u2) annotation (Line(points={{-68,-50},{-30,-50},
          {-30,12},{-22,12}}, color={0,0,127}));
  connect(greCooSet.y, orHeaCooOpe.u1) annotation (Line(points={{2,50},{10,50},{
          10,40},{18,40}}, color={255,0,255}));
  connect(lesHeaSet.y, orHeaCooOpe.u2) annotation (Line(points={{2,20},{10,20},{
          10,32},{18,32}}, color={255,0,255}));
  connect(orHeaCooOpe.y, conVarFan.heaCooOpe) annotation (Line(points={{42,40},
          {50,40},{50,7},{63.6667,7}},color={255,0,255}));
  annotation(Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
    <p>
    This simulation model is used to validate 
    <a href=\"modelica://Buildings.Fluid.ZoneEquipment.BaseClasses.VariableFan\">
    Buildings.Fluid.ZoneEquipment.BaseClasses.VariableFan</a>. 
    </p>
    <p>
    This model tests an instance <code>conVarFan</code> of the controller, with 
    time-varying input signals for the fan proven on <code>uFan</code> and the 
    measured zone temperature <code>TZon</code>. The heating-cooling operation signal 
    <code>heaCooOpe</code> is also derived from <code>TZon</code> and the temperature 
    setpoints <code>TCooSet</code> and <code>THeaSet</code>. The following observations 
    can be made from the plot.
    <ul>
    <li>
    the fan is enabled (<code>yFan=true</code>) when <code>TZon &gt; TCooSet</code>
    or <code>TZon &lt; THeaSet</code>, which sets <code>heaCooOpe</code> to 
    <code>true</code>.
    </li>
    <li>
    When <code>yFan=true</code>, the fan speed <code>yFanSpe</code> is set to 
    minimum fan speed <code>minFanSpe</code> when <code>uFan=false</code>. When 
    <code>uFan=true</code>, <code>yFanSpe</code> is controlled to regulate 
    <code>TZon</code> between <code>TCooSet</code> and <code>THeaSet</code>.
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
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/ZoneEquipment/BaseClasses/Validation/VariableFan.mos"
        "Simulate and Plot"),
    Documentation(info="<html>
    <p>
    This is a validation model for the controller 
    <a href=\"modelica://Buildings.Fluid.ZoneEquipment.BaseClasses.VariableFan\">
    Buildings.Fluid.ZoneEquipment.BaseClasses.VariableFan</a>. The model comprises the controller
    (<code>conVarFanConWat</code>), which receives input signals including zone temperature 
    (<code>TZon</code>), heating/cooling setpoint temperature (<code>cooSetPoi</code> or <code>HeaSetPoi</code>), 
    and occupancy availability (<code>uAve</code>).
    </p>
    <p>
    Simulation results are observed as follows: 
    <ul>
    <li>
    When the zone temperature (<code>TZon</code>) is below the heating setpoint
    (<code>THeaSet</code>) or exceeds the cooling setpoint
    (<code>TCooSet</code>), the fan is enabled (<code>conVarFanConWat.yFan</code>) 
    operating at a maximum speed.
    </li>
    <li>
    When the zone temperature (<code>TZon</code>) is between the cooling setpoint
    (<code>TCooSet</code>) and heating setpoint(<code>THeaSet</code>), 
    the fan is run at a minimum speed if the occupancy availability signal is true (
    <code>uAva=ture</code>) and is disabled if the occupancy availability signal is false (
    <code>uAva=false</code>).
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
end VariableFan;
