within Buildings.Templates.Components.Chillers;
model Compression "Compression chiller"
  extends Buildings.Templates.Components.Interfaces.PartialChiller;
  Fluid.Chillers.ElectricEIR chi(
    redeclare final package Medium1 = MediumCon,
    redeclare final package Medium2 = MediumChiWat,
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
    annotation (Placement(transformation(extent={{-10,-16},{10,4}})));
equation
  connect(port_a1, chi.port_a1) annotation (Line(points={{-100,60},{-20,60},{-20,
          0},{-10,0}}, color={0,127,255}));
  connect(chi.port_b1, port_b1) annotation (Line(points={{10,0},{20,0},{20,60},{
          100,60}}, color={0,127,255}));
  connect(port_b2, chi.port_b2) annotation (Line(points={{-100,-60},{-20,-60},{-20,
          -12},{-10,-12}}, color={0,127,255}));
  connect(chi.port_a2, port_a2) annotation (Line(points={{10,-12},{20,-12},{20,-60},
          {100,-60}}, color={0,127,255}));
  connect(bus.y1, chi.on) annotation (Line(
      points={{0,100},{0,40},{-40,40},{-40,-3},{-12,-3}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(bus.TChiWatSupSet, chi.TSet) annotation (Line(
      points={{0,100},{0,40},{-40,40},{-40,-9},{-12,-9}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
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
