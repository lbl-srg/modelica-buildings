within Buildings.DHC.ETS.Combined.Subsystems;
model HeatPumpDHWTank
  "Base subsystem with water-to-water heat pump with storage tank for domestic hot water"
  extends
    Buildings.DHC.ETS.Combined.Subsystems.BaseClasses.PartialHeatPump(
      heaPum(
        QCon_flow_nominal=QHotWat_flow_nominal,
        QCon_flow_max=QHotWat_flow_nominal));
  parameter Buildings.DHC.Loads.HotWater.Data.GenericDomesticHotWaterWithHeatExchanger
    datWatHea "Performance data"
    annotation (Placement(transformation(extent={{140,100},{160,120}})));
  parameter Modelica.Units.SI.HeatFlowRate QHotWat_flow_nominal(min=0)
    "Nominal capacity of heat pump condenser for hot water production system (>=0)"
    annotation (Dialog(group="Nominal condition"));
  // IO CONNECTORS
  // COMPONENTS

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal floCon(realTrue=
        mCon_flow_nominal) "Condenser mass flow rate"
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  Buildings.DHC.Loads.HotWater.StorageTankWithExternalHeatExchanger heaPumTan(
    redeclare package MediumDom = Medium1,
    redeclare package MediumHea = Medium2,                      final dat=
        datWatHea)
    "Heat pump with storage tank for domestic hot water"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant THotSouSet(k=datWatHea.TDom_nominal)
    "Set point of water in hot water tank"
    annotation (Placement(transformation(extent={{-180,10},{-160,30}})));
  Buildings.Fluid.Sources.Boundary_pT preRef(
    redeclare package Medium = Medium2,
    p(displayUnit="bar"),
    nPorts=1) "Reference pressure for loop" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-60,-20})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemHeaPumRet(
    redeclare package Medium = Medium1,
    m_flow_nominal=mCon_flow_nominal,
    tau=0)
    annotation (Placement(transformation(extent={{-140,-60},{-120,-40}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter
                                      addPar(p=dT_nominal)
                                                  "dT for heater"
    annotation (Placement(transformation(extent={{-120,-40},{-100,-20}})));
  Modelica.Blocks.Math.Add addPPum1
                                   "Electricity use for pumps"
    annotation (Placement(transformation(extent={{170,-8},{190,12}})));
  Buildings.Controls.OBC.CDL.Logical.And and2
    annotation (Placement(transformation(extent={{-140,110},{-120,130}})));
equation
  connect(THotSouSet.y, heaPumTan.TDomSet) annotation (Line(points={{-158,20},{
          -81,20}},                color={0,0,127}));
  connect(preRef.ports[1], heaPumTan.port_bHea) annotation (Line(points={{-70,-20},
          {-92,-20},{-92,14},{-80,14}}, color={0,127,255}));
  connect(heaPumTan.port_bHea, senTemHeaPumRet.port_a) annotation (Line(points={{-80,14},
          {-120,14},{-120,0},{-140,0},{-140,-50}},          color={0,127,255}));
  connect(senTemHeaPumRet.T, addPar.u) annotation (Line(points={{-130,-39},{
          -130,-30},{-122,-30}},
                            color={0,0,127}));
  connect(floCon.y, pumCon.m_flow_in)
    annotation (Line(points={{-58,90},{-4,90},{-4,0},{-14,0},{-14,-3.55271e-15}},
                                                            color={0,0,127}));
  connect(heaPumTan.port_aHea, pumCon.port_b)
    annotation (Line(points={{-60,14},{-26,14},{-26,10}},
                                                 color={0,127,255}));
  connect(senTemHeaPumRet.port_b, heaPum.port_a1)
    annotation (Line(points={{-120,-50},{-100,-50},{-100,-66},{-80,-66}},
                                                    color={0,127,255}));
  connect(addPPum.y, addPPum1.u1)
    annotation (Line(points={{161,80},{168,80},{168,8}}, color={0,0,127}));
  connect(heaPumTan.PEle, addPPum1.u2) annotation (Line(points={{-59,20},{-50,
          20},{-50,56},{164,56},{164,-4},{168,-4}}, color={0,0,127}));
  connect(addPPum1.y, PPum)
    annotation (Line(points={{191,2},{191,0},{220,0}}, color={0,0,127}));
  connect(addPar.y, heaPum.TSet) annotation (Line(points={{-98,-30},{-92,-30},{
          -92,-63},{-82,-63}}, color={0,0,127}));
  connect(heaPumTan.port_bDom, port_b1) annotation (Line(points={{-60,26},{-54,
          26},{-54,60},{200,60}},  color={0,127,255}));
  connect(port_a1, heaPumTan.port_aDom) annotation (Line(points={{-200,60},{
          -120,60},{-120,26},{-80,26}},  color={0,127,255}));
  connect(uEna, and2.u1)
    annotation (Line(points={{-220,120},{-142,120}}, color={255,0,255}));
  connect(heaPumTan.charge, and2.u2) annotation (Line(points={{-58,11},{-56,11},
          {-56,12},{-54,12},{-54,0},{-100,0},{-100,80},{-160,80},{-160,112},{
          -142,112}}, color={255,0,255}));
  connect(and2.y, floEva.u)
    annotation (Line(points={{-118,120},{-82,120}}, color={255,0,255}));
  connect(and2.y, floCon.u) annotation (Line(points={{-118,120},{-100,120},{
          -100,90},{-82,90}}, color={255,0,255}));
  connect(and2.y, conPI.trigger) annotation (Line(points={{-118,120},{-100,120},
          {-100,106},{110,106},{110,0},{124,0},{124,8}}, color={255,0,255}));
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
          extent={{-60,54},{-40,28}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-46,68},{-44,54}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-1,9},{1,-9}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid,
          origin={-37,67},
          rotation=90),
        Rectangle(
          extent={{-46,28},{-44,18}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-1,9},{1,-9}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          origin={-37,19},
          rotation=90),
        Rectangle(
          extent={{-1.5,13.5},{1.5,-13.5}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          origin={-3.5,18.5},
          rotation=90),
        Rectangle(
          extent={{-1.5,29.5},{1.5,-29.5}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid,
          origin={12.5,66.5},
          rotation=90),
        Rectangle(
          extent={{-30,70},{2,14}},
          pattern=LinePattern.None,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-30,70},{2,42}},
          pattern=LinePattern.None,
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{8,20},{10,0}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{42,68},{40,0}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-56,84},{-54,54}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={102,44,145},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-56,28},{-54,18}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,140,72},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{96,-60},{74,-62}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{8,-78},{10,-88}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-1,30},{1,-30}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          origin={-20,-87},
          rotation=90),
        Rectangle(
          extent={{-50,-60},{-48,-88}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-1,22},{1,-22}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          origin={-70,-59},
          rotation=90),
        Rectangle(
          extent={{40,-78},{42,-88}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-1,17},{1,-17}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          origin={57,-87},
          rotation=90),
        Rectangle(
          extent={{72,-60},{74,-88}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-1,64},{1,-64}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={102,44,145},
          fillPattern=FillPattern.Solid,
          origin={8,83},
          rotation=90),
        Rectangle(
          extent={{70,84},{72,60}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={102,44,145},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{92,62},{70,60}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={102,44,145},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-1,10},{1,-10}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,140,72},
          fillPattern=FillPattern.Solid,
          origin={-64,19},
          rotation=90),
        Rectangle(
          extent={{-74,62},{-72,20}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,140,72},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-72,62},{-90,60}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,140,72},
          fillPattern=FillPattern.Solid)}), Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-200,-140},{200,140}})),
    Documentation(info="<html>
<p>
Model of a water-to-water heat pump with temperature control on evaporator side, with the heat pump
being connected to a domestic hot water tank with fresh water stations.
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/DHC/ETS/Combined/Subsystems/HeatPumpDHWTank.png\"
  alt=\"Heat pump with domestic hot water tank\"/>
</p>
<p>
The heat pump model with storage tank is described in
<a href=\"modelica://Buildings.DHC.Loads.HotWater.StorageTankWithExternalHeatExchanger\">
Buildings.DHC.Loads.HotWater.StorageTankWithExternalHeatExchanger</a>.
The evaporator hydronics and control are described in
<a href=\"modelica://Buildings.DHC.ETS.Combined.Subsystems.BaseClasses.PartialHeatPump\">
Buildings.DHC.ETS.Combined.Subsystems.BaseClasses.PartialHeatPump</a>.
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
the heat pump evaporator supplies a constant temperature increase from the return to
the supply equal to <code>dT_nominal</code>.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
November 28, 2023, by David Blum:<br/>
First implementation, extended from partial base class with added
condenser hydronics and control.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3063\">
issue 3063</a>.
</li>
</ul>
</html>"));
end HeatPumpDHWTank;
