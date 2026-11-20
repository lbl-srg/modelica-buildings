within Buildings.Fluid.Humidifiers.EvaporativeCoolers.RigidMediaPad;
model PadWithBasin "Rigid media pad and sink for blowdown"
  extends Buildings.Fluid.Humidifiers.EvaporativeCoolers.RigidMediaPad.RigidMediaPad;
  extends Buildings.Fluid.Humidifiers.EvaporativeCoolers.BaseClasses.WaterBasin;

  Controls.OBC.CDL.Interfaces.BooleanInput           evaCooAct
    "True: the evaporative cooling is active"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
      iconTransformation(extent={{-140,40},{-100,80}})));
  Controls.OBC.CDL.Interfaces.RealOutput           dmWat_flow(final unit="kg/s",
      final quantity="MassFlowRate")
    "Water vapor mass flow rate difference between inlet and outlet"
    annotation (Placement(transformation(origin={120,70}, extent={{-20,-20},{20,20}}),
      iconTransformation(origin={120,60},extent={{-20,-20},{20,20}})));
  Controls.OBC.CDL.Interfaces.RealInput           mRecPum_flow
    "Mass flow setpoint of the recirculation pump" annotation (Placement(
        transformation(extent={{-140,-280},{-100,-240}}),
                                                        iconTransformation(
          extent={{-140,-80},{-100,-40}})));
  Controls.OBC.CDL.Interfaces.RealOutput mMakUp_flow "Makeup water flow"
    annotation (Placement(transformation(extent={{100,-270},{140,-230}}),
        iconTransformation(extent={{100,-80},{140,-40}})));
  inner Modelica.Fluid.System system(p_ambient=101325, T_ambient=293.15)
    "System-wide properties"
    annotation (Placement(transformation(extent={{-100,-120},{-80,-100}})));
equation
  connect(evaCooAct, swiEvaCoo.u2) annotation (Line(points={{-120,-60},{-40,-60},
          {-40,-30},{58,-30}}, color={255,0,255}));
  connect(dmWat_flow, swiEvaCoo.y) annotation (Line(points={{120,70},{90,70},{90,
          -30},{82,-30}}, color={0,0,127}));
  connect(swiEvaCoo.y, gai2.u) annotation (Line(points={{82,-30},{90,-30},{90,-80},
          {40,-80},{40,-110},{58,-110}}, color={0,0,127}));
  connect(mov.m_flow_in, mRecPum_flow) annotation (Line(points={{-82,-240},{-90,
          -240},{-90,-260},{-120,-260}}, color={0,0,127}));
  connect(gai.y, mMakUp_flow) annotation (Line(points={{62,-310},{90,-310},{90,-250},
          {120,-250}}, color={0,0,127}));
  annotation (defaultComponentName="padWitBas",
    Icon(coordinateSystem(preserveAspectRatio=false,
    extent={{-100,-100},{100,100}},
    grid={2,2}), graphics={Rectangle(
      extent={{-100,-100},{100,100}},
      lineColor={0,0,0},
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid), Text(
      extent={{-100,140},{100,100}},
      textColor={0,0,255},
          textString="%name")}), Diagram(
    coordinateSystem(preserveAspectRatio=false,
    grid={2,2},
        extent={{-100,-340},{100,100}})),
    Documentation(info="<html>
<p>
This block selects the <code>nSel</code> largest values out of a total of
<code>nVal</code> values from the input vector <code>u</code>. The output is a
Boolean vector <code>y</code>, where <code>true</code> means that the value at the
corresponding index is one of the largest values, and <code>false</code> means
that it is not.
</p>
<p>
If the input vector <code>u</code> contains equal values, this block will
prioritize values that appear first in <code>u</code> when
selecting the <code>nSel</code> largest values.
</p>
<p>
Setting the disabled flag vector <code>disFla = true</code> serves to exclude certain
values in the input vector from the ranking of the largest values. These values will
have the Boolean output <code>y = false</code>. If the total number of values after
excluding is less than <code>nSel</code>, all non-excluded values will have the
Boolean output <code>y = true</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
June 11, 2026, by Weiping Huang:<br/>
First implementation.
</li>
</ul>
</html>"));
end PadWithBasin;
