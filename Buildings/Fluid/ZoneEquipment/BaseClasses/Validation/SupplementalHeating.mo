within Buildings.Fluid.ZoneEquipment.BaseClasses.Validation;
model SupplementalHeating
  "Validation model for supplemental heating controller"
  extends Modelica.Icons.Example;

  Buildings.Fluid.ZoneEquipment.BaseClasses.SupplementalHeating conSupHea(
    final TLocOut(displayUnit="K") = 271.15)
    "Instance of controller for cycling fan and cyling coil"
    annotation (Placement(transformation(extent={{12,-10},{32,10}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant uHeaMod(
    final k=true)
    "Heating mode signal"
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse uHeaEna(
    final period=7200)
    "heating coil enable signal"
    annotation (Placement(transformation(extent={{-40,-46},{-20,-26}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TZon(
    final height=12,
    final duration=36000,
    final offset=273.15 + 15)
    "Measured zone temperature"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant heaSetPoi(
    final k=273.15+ 21)
    "Heating setpoint temperature"
    annotation (Placement(transformation(extent={{-40,24},{-20,44}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TOut(
    final height=-8,
    final duration=18000,
    final offset=273.15 + 3)
    "Outdoor air temperature"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));

equation
  connect(heaSetPoi.y,conSupHea.THeaSet)  annotation (Line(points={{-18,34},{
          -10,34},{-10,8},{10,8}}, color={0,0,127}));
  connect(TZon.y, conSupHea.TZon)
    annotation (Line(points={{-18,70},{0,70},{0,4},{10,4}}, color={0,0,127}));
  connect(TOut.y, conSupHea.TOut) annotation (Line(points={{-18,0},{10,0}},
                          color={0,0,127}));
  connect(uHeaEna.y, conSupHea.uHeaEna) annotation (Line(points={{-18,-36},{-10,
          -36},{-10,-8},{10,-8}},color={255,0,255}));
  connect(uHeaMod.y, conSupHea.uHeaMod) annotation (Line(points={{-18,-70},{0,
          -70},{0,-4},{10,-4}},  color={255,0,255}));
  annotation(Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
    <p>
    This simulation model is used to validate 
    <a href=\"modelica://Buildings.Fluid.ZoneEquipment.BaseClasses.SupplementalHeating\">
    Buildings.Fluid.ZoneEquipment.BaseClasses.SupplementalHeating</a>. 
    </p>
    </html>",revisions="<html>
      <ul>
      <li>
      April 10, 2023, by Xing Lu and Karthik Devaprasad:<br/>
      First implementation.
      </li>
      </ul>
      </html>"),
    experiment(Tolerance=1e-06),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/ZoneEquipment/BaseClasses/Validation/SupplementalHeating.mos"
        "Simulate and Plot"));
end SupplementalHeating;
