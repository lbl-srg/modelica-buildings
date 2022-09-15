within Buildings.Templates.Components.Chillers;
model Compression "Compression chiller"
  extends Buildings.Templates.Components.Interfaces.PartialChiller;
  Buildings.Fluid.Chillers.ElectricEIR chi(
    redeclare final package Medium1=MediumCon,
    redeclare final package Medium2=MediumChiWat,
    final m1_flow_nominal=mConWat_flow_nominal,
    final m2_flow_nominal=mChiWat_flow_nominal,
    final dp1_nominal=dpConWat_nominal,
    final dp2_nominal=dpChiWat_nominal,
    final per=dat.per,
    final tau1=tau,
    final tau2=tau,
    final energyDynamics=energyDynamics,
    final allowFlowReversal1=allowFlowReversal1,
    final allowFlowReversal2=allowFlowReversal2)
    "Chiller"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Controls.OBC.CDL.Logical.Pre pre
    "Compute chiller status by delaying chiller on/off signal"
    annotation (Placement(transformation(extent={{40,-30},{60,-10}})));
equation
  connect(port_a1, chi.port_a1) annotation (Line(points={{-100,60},{-20,60},{-20,
          6},{-10,6}}, color={0,127,255}));
  connect(chi.port_b1, port_b1) annotation (Line(points={{10,6},{20,6},{20,60},{
          100,60}}, color={0,127,255}));
  connect(port_b2, chi.port_b2) annotation (Line(points={{-100,-60},{-20,-60},{-20,
          -6},{-10,-6}}, color={0,127,255}));
  connect(chi.port_a2, port_a2) annotation (Line(points={{10,-6},{20,-6},{20,-60},
          {100,-60}}, color={0,127,255}));
  connect(bus.y1, chi.on) annotation (Line(
      points={{0,100},{0,20},{-40,20},{-40,3},{-12,3}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(bus.TChiWatSupSet, chi.TSet) annotation (Line(
      points={{0,100},{0,20},{-40,20},{-40,-3},{-12,-3}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(chi.on, pre.u) annotation (Line(points={{-12,3},{-16,3},{-16,-20},{38,
          -20}}, color={255,0,255}));
  connect(pre.y, bus.y1_actual) annotation (Line(points={{62,-20},{80,-20},{80,
          96},{0,96},{0,100}}, color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  annotation(defaultComponentName="chi");
end Compression;
