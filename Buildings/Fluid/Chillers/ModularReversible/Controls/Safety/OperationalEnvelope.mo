within Buildings.Fluid.Chillers.ModularReversible.Controls.Safety;
model OperationalEnvelope
  "Indicates if the chiller operation is within a defined envelope"
  extends
    HeatPumps.ModularReversible.Controls.Safety.BaseClasses.PartialOperationalEnvelope;
  Modelica.Blocks.Logical.Not notCoo "=true for heating" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,0})));
equation
  if use_TAmbSidOut then
    connect(bouMapCoo.TAmbSid, sigBus.TConOutMea) annotation (Line(points={{-84.8,
            -62},{-116,-62},{-116,-61},{-119,-61}},
                                              color={0,0,127}));
    connect(bouMapHea.TAmbSid, sigBus.TConOutMea) annotation (Line(points={{-84.8,
            58},{-104,58},{-104,-60},{-112,-60},{-112,-61},{-119,-61}},
                                                                color={0,0,127}));
  else
    connect(bouMapCoo.TAmbSid, sigBus.TConInMea) annotation (Line(points={{-84.8,
            -62},{-118,-62},{-118,-61},{-119,-61}},
                                              color={0,0,127}));
    connect(bouMapHea.TAmbSid, sigBus.TConInMea) annotation (Line(points={{-84.8,
            58},{-104,58},{-104,-60},{-112,-60},{-112,-61},{-119,-61}},
                                                                color={0,0,127}));
  end if;
  if use_TUseSidOut then
    connect(bouMapHea.TUseSid, sigBus.TEvaOutMea) annotation (Line(points={{-84.2,
            82},{-104,82},{-104,-60},{-112,-60},{-112,-61},{-119,-61}},
                                                  color={0,0,127}));
    connect(bouMapCoo.TUseSid, sigBus.TEvaOutMea) annotation (Line(points={{-84.2,
            -38},{-104,-38},{-104,-60},{-112,-60},{-112,-61},{-119,-61}},
                                                    color={0,0,127}));
  else
    connect(bouMapHea.TUseSid, sigBus.TEvaInMea) annotation (Line(points={{-84.2,
            82},{-104,82},{-104,-60},{-112,-60},{-112,-61},{-119,-61}},
                                                  color={0,0,127}));
    connect(bouMapCoo.TUseSid, sigBus.TEvaInMea) annotation (Line(points={{-84.2,
            -38},{-104,-38},{-104,-60},{-112,-60},{-112,-61},{-119,-61}},
                                                    color={0,0,127}));
  end if;
  connect(notCoo.y, swiHeaCoo.u2)
    annotation (Line(points={{-39,0},{-6,0}}, color={255,0,255}));
  connect(notCoo.u, sigBus.coo) annotation (Line(points={{-62,0},{-70,0},{-70,
          -8},{-104,-8},{-104,-60},{-112,-60},{-112,-61},{-119,-61}},
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
  Model to check if the operating conditions of a chiller are inside
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
