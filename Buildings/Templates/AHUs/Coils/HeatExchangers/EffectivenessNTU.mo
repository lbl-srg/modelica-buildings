within Buildings.Experimental.Templates.AHUs.Coils.HeatExchangers;
model EffectivenessNTU
  extends Interfaces.HeatExchanger(
    final m1_flow_nominal=dat.mWat_flow_nominal,
    final m2_flow_nominal=dat.mAir_flow_nominal,
    final typ=Types.HeatExchanger.EffectivenessNTU);

  outer parameter Buildings.Experimental.Templates.AHUs.Coils.Data.WaterBased
    dat annotation (Placement(transformation(extent={{-10,-98},{10,-78}})));

  Fluid.HeatExchangers.DryCoilEffectivenessNTU hex(
    redeclare final package Medium1 = Medium1,
    redeclare final package Medium2 = Medium2,
    final m1_flow_nominal=m1_flow_nominal,
    final m2_flow_nominal=m2_flow_nominal,
    final dp1_nominal=dat.dpWat_nominal,
    final dp2_nominal=dat.dpAir_nominal,
    final use_Q_flow_nominal=true,
    final configuration=dat.datHex.configuration,
    final Q_flow_nominal=dat.datHex.Q_flow_nominal,
    final T_a1_nominal=dat.datHex.T_a1_nominal,
    final T_a2_nominal=dat.datHex.T_a2_nominal)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  connect(port_b2, hex.port_b2) annotation (Line(points={{-100,-60},{-20,-60},{-20,
          -6},{-10,-6}}, color={0,127,255}));
  connect(hex.port_a1, port_a1) annotation (Line(points={{-10,6},{-20,6},{-20,60},
          {-100,60}}, color={0,127,255}));
  connect(hex.port_b1, port_b1) annotation (Line(points={{10,6},{20,6},{20,60},{
          100,60}}, color={0,127,255}));
  connect(hex.port_a2, port_a2) annotation (Line(points={{10,-6},{20,-6},{20,-60},
          {100,-60}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end EffectivenessNTU;
