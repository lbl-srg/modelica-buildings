within Buildings.Fluid.HeatPumps.ModularReversible.Controls.Safety;
model OperationalEnvelope
  "Indicates if the heat pump operation is within a defined envelope"
  extends BaseClasses.PartialOperationalEnvelope;
equation

  connect(swiHeaCoo.u2, sigBus.hea) annotation (Line(points={{-6,0},{-20,0},{
          -20,-4},{-104,-4},{-104,-60},{-112,-60},{-112,-61},{-119,-61}},
                            color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  annotation (Diagram(coordinateSystem(extent={{-120,-120},{120,120}})),
    Documentation(revisions="<html><ul>
  <li>
    <i>November 26, 2018</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/577\">AixLib #577</a>)
  </li>
</ul>
</html>", info="<html>
<p>
  Model to check if the operating conditions of a heat pump are inside
  the given boundaries. If not, the heat pump or chiller will switch off.
</p>
<p>
  Read the documentation of
  <a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible.Controls.Safety.BaseClasses.PartialOperationalEnvelope\">
  Buildings.Fluid.HeatPumps.ModularReversible.Controls.Safety.BaseClasses.PartialOperationalEnvelope</a>
  for more information.
</p>

</html>"));
end OperationalEnvelope;
