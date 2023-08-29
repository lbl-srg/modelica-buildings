within Buildings.Templates.Components.Chillers;
model Compression "Compression chiller"
  extends Buildings.Templates.Components.Interfaces.PartialChiller;
  Buildings.Fluid.Chillers.ElectricEIR chi(
    redeclare final package Medium1=MediumCon,
    redeclare final package Medium2=MediumChiWat,
    final m1_flow_nominal=mCon_flow_nominal,
    final m2_flow_nominal=mChiWat_flow_nominal,
    final dp1_nominal=dpCon_nominal,
    final dp2_nominal=dpChiWat_nominal,
    final per=dat.per,
    final tau1=tau,
    final tau2=tau,
    final energyDynamics=energyDynamics,
    final allowFlowReversal1=allowFlowReversal1,
    final allowFlowReversal2=allowFlowReversal2)
    "Chiller"
    annotation (Placement(transformation(extent={{-10,10},{10,30}})));
  Controls.OBC.CDL.Logical.Pre pre
    "Compute chiller status and CHW request by delaying chiller on/off signal"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Controls.OBC.CDL.Logical.Pre preConWatReq
    if typ==Buildings.Templates.Components.Types.Chiller.WaterCooled
    "Compute CW request by delaying chiller on/off signal"
    annotation (Placement(transformation(extent={{40,-50},{60,-30}})));
equation
  connect(port_a1, chi.port_a1) annotation (Line(points={{-100,60},{-20,60},{-20,
          26},{-10,26}},
                       color={0,127,255}));
  connect(chi.port_b1, port_b1) annotation (Line(points={{10,26},{20,26},{20,60},
          {100,60}},color={0,127,255}));
  connect(port_b2, chi.port_b2) annotation (Line(points={{-100,-60},{-20,-60},{-20,
          14},{-10,14}}, color={0,127,255}));
  connect(chi.port_a2, port_a2) annotation (Line(points={{10,14},{20,14},{20,-60},
          {100,-60}}, color={0,127,255}));
  connect(bus.y1, chi.on) annotation (Line(
      points={{0,100},{0,40},{-40,40},{-40,23},{-12,23}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(bus.TChiWatSupSet, chi.TSet) annotation (Line(
      points={{0,100},{0,40},{-40,40},{-40,17},{-12,17}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(chi.on, pre.u) annotation (Line(points={{-12,23},{-16,23},{-16,0},{38,
          0}},   color={255,0,255}));
  connect(pre.y, bus.y1_actual) annotation (Line(points={{62,0},{80,0},{80,96},{
          0,96},{0,100}},      color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(pre.y, bus.y1ChiWatReq) annotation (Line(points={{62,0},{86,0},{86,96},
          {0,96},{0,100}}, color={255,0,255}));
  connect(chi.on, preConWatReq.u) annotation (Line(points={{-12,23},{-16,23},{-16,
          -40},{38,-40}}, color={255,0,255}));
  connect(preConWatReq.y, bus.y1ConWatReq) annotation (Line(points={{62,-40},{
          92,-40},{92,96},{0,96},{0,100}},
                                        color={255,0,255}));
  annotation(defaultComponentName="chi",
  Documentation(info="<html>
<p>
The chiller request commands to the CHW or CW isolation valves 
or dedicated pumps (yielded by the chiller built-in controller)
are assumed to be equal the to signal <code>y1_actual</code>
corresponding to the chiller status.
</p>
</html>", revisions="<html>
<ul>
<li>
November 18, 2022, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end Compression;
