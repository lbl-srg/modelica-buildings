within Buildings.Fluid.ZoneEquipment.BaseClasses.Validation;
model CyclingFan "Validation model for cycling fan controller"
  extends Modelica.Icons.Example;

  Buildings.Fluid.ZoneEquipment.BaseClasses.CyclingFan conFanCyc
    "Instance of controller with constant speed fan"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant uAva(
    final k=true)
    "Availability signal"
    annotation (Placement(transformation(extent={{-40,-36},{-20,-16}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse uFan(
    final period=900) "Fan proven on signal"
    annotation (Placement(transformation(extent={{-40,64},{-20,84}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse heaCooOpe(
    final period=900)
    "Fan proven on signal"
    annotation (Placement(transformation(extent={{-40,24},{-20,44}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse fanOpeMod(
    final period=21600) "Fan opearating mode"
    annotation (Placement(transformation(extent={{-40,-76},{-20,-56}})));

equation
  connect(conFanCyc.uAva, uAva.y) annotation (Line(points={{38,-2},{0,-2},{0,-26},
          {-18,-26}},      color={255,0,255}));
  connect(conFanCyc.uFan, uFan.y) annotation (Line(points={{38,6},{20,6},{20,74},
          {-18,74}}, color={255,0,255}));
  connect(heaCooOpe.y, conFanCyc.heaCooOpe) annotation (Line(points={{-18,34},{0,
          34},{0,2},{38,2}}, color={255,0,255}));
  connect(fanOpeMod.y, conFanCyc.fanOpeMod) annotation (Line(points={{-18,-66},{
          20,-66},{20,-6},{38,-6}}, color={255,0,255}));
  annotation(Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
    <p>
    This simulation model is used to validate 
    <a href=\"modelica://Buildings.Fluid.ZoneEquipment.BaseClasses.CyclingFan\">
    Buildings.Fluid.ZoneEquipment.BaseClasses.CyclingFan</a>. 
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
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/ZoneEquipment/BaseClasses/Validation/CyclingFan.mos"
        "Simulate and Plot"));
end CyclingFan;
