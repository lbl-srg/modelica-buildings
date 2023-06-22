within Buildings.Fluid.ZoneEquipment.BaseClasses.Validation;
model VariableFan "Validation model for variable fan controller"
  extends Modelica.Icons.Example;

  Buildings.Fluid.ZoneEquipment.BaseClasses.VariableFan conVarFanConWat(
    has_hea=true,
    has_coo=true)
    "Instance of controller with variable speed fan"
    annotation (Placement(transformation(extent={{32,-14},{60,14}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse uAva(
    final period=21600,
    shift=10800)
    "Availability signal"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TZon(
    final height=12,
    final duration=36000,
    final offset=273.15 + 16)
    "Measured zone temperature"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant heaSetPoi(
    final k=273.15 + 21)
    "Heating setpoint temperature"
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant cooSetPoi(
    final k=273.15 + 23)
    "Cooling setpoint temperature"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));

equation
  connect(conVarFanConWat.uAva, uAva.y) annotation (Line(points={{30,-12},{20,-12},
          {20,-60},{-18,-60}}, color={255,0,255}));
  connect(TZon.y, conVarFanConWat.TZon) annotation (Line(points={{-18,60},{20,60},
          {20,12},{30,12}}, color={0,0,127}));
  connect(conVarFanConWat.TCooSet, cooSetPoi.y)
    annotation (Line(points={{30,4},{0,4},{0,20},{-18,20}}, color={0,0,127}));
  connect(conVarFanConWat.THeaSet, heaSetPoi.y) annotation (Line(points={{30,-4},
          {0,-4},{0,-20},{-18,-20}}, color={0,0,127}));
  annotation(Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
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
