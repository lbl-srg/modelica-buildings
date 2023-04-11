within Buildings.Fluid.ZoneEquipment.PackagedTerminalHeatPump1.Controls.Validation;
model SupplementalHeating
  "Validation model for controller with supplemental heating"
  extends Modelica.Icons.Example;

  Buildings.Fluid.ZoneEquipment.PackagedTerminalHeatPump1.Controls.SupplementalHeating
    uSupHea(TDryCom_min=271.15)
    "Instance of controller with cycling fan and cyling coil"
    annotation (Placement(transformation(extent={{10,-10},{30,10}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant uHeaMod(k=true)
    "Heating mode signal"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
protected
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse uHeaEna(final period=7200)
    "heating coil enable signal"
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TZon(
    final height=12,
    final duration=36000,
    final offset=273.15 + 15) "Measured zone temperature"
    annotation (Placement(transformation(extent={{-40,80},{-20,100}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant heaSetPoi(final k=273.15
         + 21)       "Heating setpoint temperature"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TOut(
    final height=-8,
    final duration=18000,
    final offset=273.15 + 3) "Outdoor air temperature"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
protected
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse uFan(final period=3600)
    "Fan enable signal"
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));
equation
  connect(heaSetPoi.y, uSupHea.THeaSet) annotation (Line(points={{-18,60},{-10,60},
          {-10,4},{8,4}}, color={0,0,127}));
  connect(TZon.y, uSupHea.TZon)
    annotation (Line(points={{-18,90},{0,90},{0,8},{8,8}}, color={0,0,127}));
  connect(TOut.y, uSupHea.TOut) annotation (Line(points={{-18,30},{-14,30},{-14,
          0},{8,0}}, color={0,0,127}));
  connect(uHeaEna.y, uSupHea.uHeaEna) annotation (Line(points={{-18,-10},{-6,-10},
          {-6,-3},{9,-3}}, color={255,0,255}));
  connect(uHeaMod.y, uSupHea.uHeaMod) annotation (Line(points={{-18,-40},{-4,-40},
          {-4,-6},{9,-6}}, color={255,0,255}));
  connect(uFan.y, uSupHea.uFan) annotation (Line(points={{-18,-70},{0,-70},{0,-9},
          {9,-9}}, color={255,0,255}));
  annotation(Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>This simulation model is used to validate <a href=\"modelica://Buildings.Fluid.ZoneEquipment.PackagedTerminalHeatPump.Controls.SupplementalHeating\">Buildings.Fluid.ZoneEquipment.PackagedTerminalHeatPump.Controls.SupplementalHeating</a>.  </p>
</html>",revisions="<html>
      <ul>
      <li>
      Mar 30, 2023 by Karthik Devaprasad, Xing Lu:<br/>
      First implementation.
      </li>
      </ul>
      </html>"),
    experiment(
      StopTime=86400,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"),
    __Dymola_Commands(file="Resources/Scripts/Dymola/Fluid/ZoneEquipment/PackagedTerminalHeatPump/Controls/Validation/SupplementalHeating.mos"
        "Simulate and Plot"));
end SupplementalHeating;
