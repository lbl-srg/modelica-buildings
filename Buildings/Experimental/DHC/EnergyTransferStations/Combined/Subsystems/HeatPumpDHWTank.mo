within Buildings.Experimental.DHC.EnergyTransferStations.Combined.Subsystems;
model HeatPumpDHWTank
  "Base subsystem with water-to-water heat pump with storage tank for domestic hot water"
  extends
    Buildings.Experimental.DHC.EnergyTransferStations.Combined.Subsystems.BaseClasses.PartialHeatPump(
      heaPum(
        QCon_flow_nominal=QHotWat_flow_nominal,
        QCon_flow_max=QHotWat_flow_nominal));
  parameter Loads.HotWater.Data.GenericDomesticHotWaterWithHeatExchanger
    datWatHea "Performance data"
    annotation (Placement(transformation(extent={{140,100},{160,120}})));
  parameter Modelica.Units.SI.HeatFlowRate QHotWat_flow_nominal(min=0)
    "Nominal capacity of heat pump condenser for hot water production system (>=0)"
    annotation (Dialog(group="Nominal condition"));
  // IO CONNECTORS
  // COMPONENTS

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal floCon(realTrue=
        mCon_flow_nominal) "Condenser mass flow rate"
    annotation (Placement(transformation(extent={{-80,110},{-60,130}})));
  Loads.HotWater.StorageTankWithExternalHeatExchanger heaPumTan(
    redeclare package MediumDom = Medium1,
    redeclare package MediumHea = Medium2,                      final dat=
        datWatHea)
    "Heat pump with storage tank for domestic hot water"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant THotSouSet(k=datWatHea.TDom_nominal)
    "Set point of water in hot water tank"
    annotation (Placement(transformation(extent={{-180,0},{-160,20}})));
  Fluid.Sources.Boundary_pT preRef(
    redeclare package Medium = Medium2,
    p(displayUnit="bar"),
    nPorts=1) "Reference pressure for loop" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-60,-20})));
  Fluid.Sensors.TemperatureTwoPort senTemHeaPumRet(
    redeclare package Medium = Medium1,
    m_flow_nominal=mCon_flow_nominal,
    tau=0)
    annotation (Placement(transformation(extent={{-140,-64},{-120,-44}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter
                                      addPar(p=dT_nominal)
                                                  "dT for heater"
    annotation (Placement(transformation(extent={{-120,-40},{-100,-20}})));
  Modelica.Blocks.Math.Add addPPum1
                                   "Electricity use for pumps"
    annotation (Placement(transformation(extent={{170,-8},{190,12}})));
equation
  connect(THotSouSet.y, heaPumTan.TDomSet) annotation (Line(points={{-158,10},{-140,
          10},{-140,20},{-81,20}}, color={0,0,127}));
  connect(heaPumTan.charge, floCon.u) annotation (Line(points={{-58,11},{-56,11},
          {-56,12},{-54,12},{-54,0},{-100,0},{-100,120},{-82,120}}, color={255,
          0,255}));
  connect(preRef.ports[1], heaPumTan.port_bHea) annotation (Line(points={{-70,-20},
          {-92,-20},{-92,14},{-80,14}}, color={0,127,255}));
  connect(heaPumTan.port_bHea, senTemHeaPumRet.port_a) annotation (Line(points={
          {-80,14},{-120,14},{-120,0},{-140,0},{-140,-54}}, color={0,127,255}));
  connect(senTemHeaPumRet.T, addPar.u) annotation (Line(points={{-130,-43},{-130,
          -30},{-122,-30}}, color={0,0,127}));
  connect(floCon.y, pumCon.m_flow_in)
    annotation (Line(points={{-58,120},{-30,120},{-30,26}}, color={0,0,127}));
  connect(floEva.u, floCon.u) annotation (Line(points={{-82,90},{-100,90},{-100,
          120},{-82,120}}, color={255,0,255}));
  connect(heaPumTan.port_aHea, pumCon.port_b)
    annotation (Line(points={{-60,14},{-40,14}}, color={0,127,255}));
  connect(senTemHeaPumRet.port_b, heaPum.port_a1)
    annotation (Line(points={{-120,-54},{-82,-54}}, color={0,127,255}));
  connect(addPPum.y, addPPum1.u1)
    annotation (Line(points={{161,70},{168,70},{168,8}}, color={0,0,127}));
  connect(heaPumTan.PEle, addPPum1.u2) annotation (Line(points={{-59,20},{-50,
          20},{-50,56},{164,56},{164,-4},{168,-4}}, color={0,0,127}));
  connect(addPPum1.y, PPum)
    annotation (Line(points={{191,2},{191,0},{220,0}}, color={0,0,127}));
  connect(conPI.trigger, floCon.u) annotation (Line(points={{124,8},{124,0},{
          110,0},{110,106},{-100,106},{-100,120},{-82,120}}, color={255,0,255}));
  connect(addPar.y, heaPum.TSet) annotation (Line(points={{-98,-30},{-92,-30},{
          -92,-51},{-84,-51}}, color={0,0,127}));
  connect(heaPumTan.port_bDom, port_b1) annotation (Line(points={{-60,26},{-54,
          26},{-54,60},{-200,60}}, color={0,127,255}));
  connect(port_a1, heaPumTan.port_aDom) annotation (Line(points={{-200,-60},{
          -190,-60},{-190,26},{-80,26}}, color={0,127,255}));
  annotation (
  defaultComponentName="heaPum",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-12,0},{60,-78}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{2,-60},{48,-68}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{8,-38},{4,-46},{12,-46},{8,-38}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{8,-38},{4,-30},{12,-30},{8,-38}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{38,-20},{42,-60}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{32,-32},{50,-50}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{40,-32},{32,-44},{50,-44},{40,-32}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{6,-46},{10,-60}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{6,-20},{10,-30}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{0,-12},{46,-20}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-74,52},{-60,28}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-68,68},{-66,52}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-1.5,9.5},{1.5,-9.5}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          origin={-57.5,66.5},
          rotation=90),
        Rectangle(
          extent={{-68,28},{-66,18}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-1.5,9.5},{1.5,-9.5}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          origin={-57.5,18.5},
          rotation=90),
        Rectangle(
          extent={{-1.5,5.5},{1.5,-5.5}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          origin={-11.5,18.5},
          rotation=90),
        Rectangle(
          extent={{-1.5,34.5},{1.5,-34.5}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          origin={17.5,66.5},
          rotation=90),
        Rectangle(
          extent={{-48,70},{-16,14}},
          pattern=LinePattern.None,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-48,70},{-16,42}},
          pattern=LinePattern.None,
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-6,20},{-4,0}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{52,68},{50,0}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid)}), Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-200,-140},{200,140}})),
    Documentation(info="<html>
<p>
This model represents a water-to-water heat pump with storage tank and an evaporator water pump.
The heat pump model with storage tank is described in
<a href=\"modelica://Buildings.Experimental.DHC.Loads.HotWater.HeatPumpWithTank\">
Buildings.Experimental.DHC.Loads.HotWater.HeatPumpWithTank</a>.
The evaporator hydronics and control are described in
<a href=\"modelica://Buildings.Experimental.DHC.EnergyTransferStations.Combined.Subsystems.BaseClasses.PartialHeatPump\">
Buildings.Experimental.DHC.EnergyTransferStations.Combined.Subsystems.BaseClasses.PartialHeatPump</a>.
</p>
<h4>Condenser Controls</h4>
<p>
The system is enabled when the tank charge control signal switches to
<code>true</code>.
When enabled, 
</p>
<ul>
<li>
the condenser pump is commanded on and supplies the nominal mass flow rate
to the tank and domestic hot water system,
</li>
<li>
the heat pump condenser supplies a constant temperature increase from the return to
the supply equal to <code>dT_nominal</code>.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
November 28, 2023, by David Blum:<br/>
Changed to extend partial base class with added condenser hydronics and control.
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
end HeatPumpDHWTank;
