within Buildings.Fluid.ZoneEquipment.BaseClasses.Validation;
model CyclingFan "Validation model for cycling fan controller"
  extends Modelica.Icons.Example;

  Buildings.Fluid.ZoneEquipment.BaseClasses.CyclingFan conFanCyc(
    final minFanSpe=0.1)
    "Instance of controller with constant speed fan"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant uAva(
    final k=true)
    "Availability signal"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse uFan(
    final period=450)
    "Fan proven on signal"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse heaCooOpe(
    final period=900)
    "Heating-cooling operation signal"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse fanOpeMod(
    final period=1800)
    "Fan opearating mode"
    annotation (Placement(transformation(extent={{-40,-76},{-20,-56}})));

equation
  connect(conFanCyc.uAva, uAva.y) annotation (Line(points={{38,-2},{0,-2},{0,-30},
          {-18,-30}},      color={255,0,255}));
  connect(conFanCyc.uFan, uFan.y) annotation (Line(points={{38,6},{20,6},{20,70},
          {-18,70}}, color={255,0,255}));
  connect(heaCooOpe.y, conFanCyc.heaCooOpe) annotation (Line(points={{-18,30},{0,
          30},{0,2},{38,2}}, color={255,0,255}));
  connect(fanOpeMod.y, conFanCyc.fanOpeMod) annotation (Line(points={{-18,-66},{
          20,-66},{20,-6},{38,-6}}, color={255,0,255}));
  annotation(Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
    <p>
    This is a validation model for the controller 
    <a href=\"modelica://Buildings.Fluid.ZoneEquipment.BaseClasses.CyclingFan\">
    Buildings.Fluid.ZoneEquipment.BaseClasses.CyclingFan</a>.
    </p>
    <p>
    This model tests an instance <code>conFanCyc</code> of the controller, with 
    time-varying input signals for the heating-cooling operation <code>heaCooOpe</code>,
    fan proven on signal <code>uFan</code> and fan operating mode <code>fanOpeMod</code>.
    The following observations can be made from the plots.
    <ul>
    <li>
    The fan runs in continuous mode when <code>fanOpeMod</code> is <code>true</code>,
    and runs in cycling mode when <code>fanOpeMod</code> is <code>false</code>.
    In cycling mode, the fan is only enabled (<code>yFan=true</code>) when 
    <code>heaCooOpe</code> is <code>true</code>.
    </li>
    <li>
    When the fan is enabled (<code>yFan=true</code>), the fan speed <code>yFanSpe</code>
    is set to minimum <code>minFanSpe</code> when the fan is not proven on 
    (<code>uFan=false</code>). When the fan is proven on (<code>uFan=true</code>),
    <code>yFanSpe</code> is set to 100%.
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
    </html>"),
    experiment(Tolerance=1e-6));
end CyclingFan;
