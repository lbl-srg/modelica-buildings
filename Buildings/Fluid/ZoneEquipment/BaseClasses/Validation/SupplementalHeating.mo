within Buildings.Fluid.ZoneEquipment.BaseClasses.Validation;
model SupplementalHeating
  "Validation model for supplemental heating controller"
  extends Modelica.Icons.Example;

  Buildings.Fluid.ZoneEquipment.BaseClasses.SupplementalHeating
    conSupHea(final TLocOut(displayUnit="K") = 271.15)
    "Instance of controller for cycling fan and cyling coil"
    annotation (Placement(transformation(extent={{12,-10},{32,10}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant uHeaMod(
    final k=true)
    "Heating mode signal"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse uHeaEna(
    final period=7200)
    "heating coil enable signal"
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TZon(
    final height=12,
    final duration=36000,
    final offset=273.15 + 15)
    "Measured zone temperature"
    annotation (Placement(transformation(extent={{-40,80},{-20,100}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant heaSetPoi(
    final k=273.15+ 21)
    "Heating setpoint temperature"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TOut(
    final height=-8,
    final duration=18000,
    final offset=273.15 + 3)
    "Outdoor air temperature"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));

equation
  connect(heaSetPoi.y, conSupHea.TSetHea) annotation (Line(points={{-18,60},{
          -10,60},{-10,8},{10,8}}, color={0,0,127}));
  connect(TZon.y, conSupHea.TZon)
    annotation (Line(points={{-18,90},{0,90},{0,4},{10,4}}, color={0,0,127}));
  connect(TOut.y, conSupHea.TOut) annotation (Line(points={{-18,30},{-14,30},{
          -14,0},{10,0}}, color={0,0,127}));
  connect(uHeaEna.y, conSupHea.uHeaEna) annotation (Line(points={{-18,-10},{-6,
          -10},{-6,-8},{10,-8}}, color={255,0,255}));
  connect(uHeaMod.y, conSupHea.uHeaMod) annotation (Line(points={{-18,-40},{-4,
          -40},{-4,-4},{10,-4}}, color={255,0,255}));
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
