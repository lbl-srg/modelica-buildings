within Buildings.Templates.Plants.Controls.Pumps.Primary.Validation;
model EnableLeadHeadered
  "Validation model for the enabling logic of headered primary pumps"
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse u1ValIso[2](
    period=60 * {20, 30})
    "Isolation valve command"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Templates.Plants.Controls.Pumps.Primary.EnableLeadHeadered enaSerTwo(
    typCon=Buildings.Templates.Plants.Controls.Types.EquipmentConnection.Series,
    typValIso=Buildings.Templates.Plants.Controls.Types.Actuator.TwoPosition,
    nValIso=2)
    "Enable lead pump - Series piped equipment wth two-position isolation valves"
    annotation (Placement(transformation(extent={{50,-30},{70,-10}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea[2]
    "Convert to real"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  Buildings.Controls.OBC.CDL.Reals.LimitSlewRate uValIso[2](
    each raisingSlewRate=1 / 200)
    "Compute valve command"
    annotation (Placement(transformation(extent={{0,-50},{20,-30}})));
  Buildings.Templates.Plants.Controls.Pumps.Primary.EnableLeadHeadered enaSerMod(
    typCon=Buildings.Templates.Plants.Controls.Types.EquipmentConnection.Series,
    typValIso=Buildings.Templates.Plants.Controls.Types.Actuator.Modulating,
    nValIso=2)
    "Enable lead pump - Series piped equipment with modulating isolation valves"
    annotation (Placement(transformation(extent={{50,-70},{70,-50}})));

  Buildings.Templates.Plants.Controls.Pumps.Primary.EnableLeadHeadered enaParTwo(
    typCon=Buildings.Templates.Plants.Controls.Types.EquipmentConnection.Parallel,
    typValIso=Buildings.Templates.Plants.Controls.Types.Actuator.TwoPosition,
    nValIso=2)
    "Enable lead pump - Parallel piped equipment wth two-position isolation valves"
    annotation (Placement(transformation(extent={{52,50},{72,70}})));

  Buildings.Templates.Plants.Controls.Pumps.Primary.EnableLeadHeadered enaParMod(
    typCon=Buildings.Templates.Plants.Controls.Types.EquipmentConnection.Parallel,
    typValIso=Buildings.Templates.Plants.Controls.Types.Actuator.Modulating,
    nValIso=2)
    "Enable lead pump - Parallel piped equipment with modulating isolation valves"
    annotation (Placement(transformation(extent={{52,10},{72,30}})));

equation
  connect(u1ValIso.y, booToRea.u)
    annotation (Line(points={{-58,0},{-50,0},{-50,-40},{-42,-40}},color={255,0,255}));
  connect(booToRea.y, uValIso.u)
    annotation (Line(points={{-18,-40},{-2,-40}},color={0,0,127}));
  connect(u1ValIso.y, enaSerTwo.u1ValIso)
    annotation (Line(points={{-58,0},{40,0},{40,-16},{48,-16}},color={255,0,255}));
  connect(uValIso.y, enaSerMod.uValIso)
    annotation (Line(points={{22,-40},{40,-40},{40,-64},{48,-64}},color={0,0,127}));
  connect(u1ValIso.y, enaParTwo.u1ValIso)
    annotation (Line(points={{-58,0},{40,0},{40,64},{50,64}},color={255,0,255}));
  connect(uValIso.y, enaParMod.uValIso)
    annotation (Line(points={{22,-40},{30,-40},{30,16},{50,16}},color={0,0,127}));
  annotation (
    __Dymola_Commands(
      file=
        "modelica://Buildings/Resources/Scripts/Dymola/Templates/Plants/Controls/Pumps/Primary/Validation/EnableLeadHeadered.mos"
        "Simulate and plot"),
    experiment(
      StopTime=3000.0,
      Tolerance=1e-06),
    Documentation(
      info="<html>
<p>
This model validates
<a href=\"modelica://Buildings.Templates.Plants.Controls.Pumps.Primary.EnableLeadHeadered\">
Buildings.Templates.Plants.Controls.Pumps.Primary.EnableLeadHeadered</a>
in a configuration with two production units, either parallel piped
or series piped, with either two-position or modulating isolation valves.
</p>
<p>
The simulation of this model shows that
</p>
</html>",
      revisions="<html>
<ul>
<li>
FIXME, 2024, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(
      graphics={
        Ellipse(
          lineColor={75,138,73},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}),
        Polygon(
          lineColor={0,0,255},
          fillColor={75,138,73},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-36,60},{64,0},{-36,-60},{-36,60}})}),
    Diagram(
      graphics={
        Polygon(
          points={{214,66},{214,66}},
          lineColor={28,108,200})}));
end EnableLeadHeadered;
