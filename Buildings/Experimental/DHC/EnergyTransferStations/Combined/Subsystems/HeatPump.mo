within Buildings.Experimental.DHC.EnergyTransferStations.Combined.Subsystems;
model HeatPump "Base subsystem with water-to-water heat pump"
  extends
    Buildings.Experimental.DHC.EnergyTransferStations.Combined.Subsystems.BaseClasses.PartialHeatPump(
        heaPum(QCon_flow_nominal=Q1_flow_nominal));
  parameter Boolean have_varFloCon = true
    "Set to true for a variable condenser flow"
    annotation(Evaluate=true);
  parameter Modelica.Units.SI.HeatFlowRate Q1_flow_nominal(min=0)
    "Heating heat flow rate" annotation (Dialog(group="Nominal condition"));
  // IO CONNECTORS
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uEna(start=false)
    "Enable signal"
    annotation (
      Placement(transformation(extent={{-240,100},{-200,140}}),
        iconTransformation(extent={{-140,70},{-100,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSupSet(
    final unit="K",
    displayUnit="degC")
    "Supply temperature set point"
    annotation (Placement(transformation(extent={{-240,-40},{-200,0}}),
      iconTransformation(extent={{-140,10},{-100,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput m1_flow(
    final unit="kg/s") if have_varFloCon
    "Condenser mass flow rate"
    annotation (Placement(transformation(extent={{-240,60},{-200,100}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  // COMPONENTS
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant floConNom(
    final k=mCon_flow_nominal) if not have_varFloCon
    "Nominal flow rate"
    annotation (Placement(transformation(extent={{-100,80},{-120,100}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea
    annotation (Placement(transformation(extent={{-180,110},{-160,130}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply floCon
    "Zero flow rate if not enabled"
    annotation (Placement(transformation(extent={{-120,110},{-100,130}})));
equation
  connect(uEna, booToRea.u)
    annotation (Line(points={{-220,120},{-182,120}}, color={255,0,255}));
  connect(booToRea.y, floCon.u1) annotation (Line(points={{-158,120},{-140,120},
          {-140,126},{-122,126}}, color={0,0,127}));
  connect(m1_flow, floCon.u2) annotation (Line(points={{-220,80},{-140,80},{-140,
          114},{-122,114}}, color={0,0,127}));
  connect(floConNom.y, floCon.u2) annotation (Line(points={{-122,90},{-130,90},{
          -130,114},{-122,114}}, color={0,0,127}));
  connect(port_a1, heaPum.port_a1) annotation (Line(points={{-200,60},{-120,60},
          {-120,-54},{-82,-54}},      color={0,127,255}));
  connect(pumCon.port_b, port_b1) annotation (Line(points={{-40,14},{-60,14},{
          -60,60},{200,60}},   color={0,127,255}));
  connect(TSupSet, heaPum.TSet) annotation (Line(points={{-220,-20},{-100,-20},
          {-100,-51},{-84,-51}}, color={0,0,127}));
  connect(uEna, floEva.u) annotation (Line(points={{-220,120},{-190,120},{-190,
          136},{-90,136},{-90,90},{-82,90}}, color={255,0,255}));
  connect(floCon.y, pumCon.m_flow_in)
    annotation (Line(points={{-98,120},{-30,120},{-30,26}}, color={0,0,127}));
  connect(conPI.trigger, floEva.u) annotation (Line(points={{124,8},{124,-2},{
          110,-2},{110,136},{-90,136},{-90,90},{-82,90}}, color={255,0,255}));
  connect(addPPum.y, PPum) annotation (Line(points={{161,110},{174,110},{174,0},
          {220,0}},color={0,0,127}));
  annotation (
  defaultComponentName="heaPum",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{92,-58},{18,-60}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{18,-38},{20,-60}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-14,-38},{-12,-60}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-1,42},{1,-42}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          origin={-54,-59},
          rotation=90),
        Rectangle(
          extent={{-14,62},{-12,40}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{18,62},{20,40}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-1,42},{1,-42}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          origin={-54,61},
          rotation=90),
        Rectangle(
          extent={{92,62},{18,60}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid)}), Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-200,-140},{200,140}})),
    Documentation(info="<html>
<p>
This model represents a water-to-water heat pump, an evaporator water pump,
and a condenser water pump.
The heat pump model is described in
<a href=\"modelica://Buildings.Fluid.HeatPumps.Carnot_TCon\">
Buildings.Fluid.HeatPumps.Carnot_TCon</a>.
By default, a variable speed condenser pump is considered, but a constant speed
pump may also be represented by setting <code>have_varFloCon</code> to <code>false</code>.
The evaporator hydronics and control are described in
<a href=\"modelica://Buildings.Experimental.DHC.EnergyTransferStations.Combined.Subsystems.BaseClasses.PartialHeatPump\">
Buildings.Experimental.DHC.EnergyTransferStations.Combined.Subsystems.BaseClasses.PartialHeatPump</a>.
</p>
<h4>Condenser Controls</h4>
<p>
The system is enabled when the input control signal <code>uEna</code> switches to
<code>true</code>.
When enabled, on the condenser side,
</p>
<ul>
<li>
the condenser water pumps are commanded on and supply either
the condenser mass flow rate set point provided as an input in the case of the variable speed condenser pump,
or the nominal mass flow rate in the case of the constant speed condenser pump,
</li>
<li>
the heat pump controller—idealized in this model—tracks the
supply temperature set point at the condenser outlet.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
November 15, 2023, by David Blum:<br/>
Changed to extend partial base class with added condenser hydronics and control.
</li>
<li>
May 3, 2023, by David Blum:<br/>
Assigned <code>dp_nominal</code> to condenser pump.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3379\">
issue 3379</a>.
</li>
<li>
November 16, 2022, by Michael Wetter:<br/>
Set <code>pumEva.dp_nominal</code> to correct value.
</li>
<li>
February 23, 2021, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end HeatPump;
