within Buildings.Fluid.HeatPumps.ModularReversible.Controls.Safety;
model OperationalEnvelope
  "Indicates if the heat pump operation is within a defined envelope"
  extends BaseClasses.PartialOperationalEnvelope;
equation
  if use_TConOutHea then
    connect(bouMapHea.TUseSid, sigBus.TConOutMea) annotation (Line(points={{-81.4,
            54},{-104,54},{-104,-61},{-119,-61}},                       color={0,
            0,127}));
  else
    connect(bouMapHea.TUseSid, sigBus.TConInMea) annotation (Line(points={{-81.4,
            54},{-104,54},{-104,-61},{-119,-61}},                       color={0,
            0,127}));
  end if;
  if use_TEvaOutCoo then
    connect(bouMapCoo.TAmbSid, sigBus.TEvaOutMea) annotation (Line(points={{-81.6,
            -34},{-104,-34},{-104,-61},{-119,-61}},
                                                color={0,0,127}));
  else
    connect(bouMapCoo.TAmbSid, sigBus.TEvaInMea) annotation (Line(points={{-81.6,
            -34},{-104,-34},{-104,-61},{-119,-61}},
                                                color={0,0,127}));
  end if;
  if use_TEvaOutHea then
    connect(bouMapHea.TAmbSid, sigBus.TEvaOutMea) annotation (Line(points={{-81.6,
            46},{-104,46},{-104,-60},{-106,-60},{-106,-61},{-119,-61}},
                                                color={0,0,127}));
  else
    connect(bouMapHea.TAmbSid, sigBus.TEvaInMea) annotation (Line(points={{-81.6,
            46},{-104,46},{-104,-60},{-110,-60},{-110,-61},{-119,-61}},
                                                color={0,0,127}));
  end if;
  if use_TConOutCoo then
    connect(bouMapCoo.TUseSid, sigBus.TConOutMea) annotation (Line(points={{-81.4,
            -26},{-104,-26},{-104,-60},{-112,-60},{-112,-61},{-119,-61}},
                                                      color={0,0,127}));
  else
    connect(bouMapCoo.TUseSid, sigBus.TConInMea) annotation (Line(points={{-81.4,
            -26},{-104,-26},{-104,-60},{-112,-60},{-112,-61},{-119,-61}},
                                                      color={0,0,127}));
  end if;
  connect(swiHeaCoo.u2, sigBus.hea) annotation (Line(points={{-6,0},{-98,0},{
          -98,-60},{-108,-60},{-108,-61},{-119,-61}},
                            color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  annotation (Diagram(coordinateSystem(extent={{-120,-120},{120,120}})),
    Documentation(revisions="<html><ul>
  <li>
    <i>May 26, 2025</i> by Fabian Wuellhorst and Michael Wetter:<br/>
    Increase error counter only when device should turn on (see issue <a href=
    \"https://github.com/ibpsa/modelica-ibpsa/issues/2011\">IBPSA #2011</a>)
  </li>
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
