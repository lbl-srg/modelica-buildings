within Buildings.Experimental.Templates.AHUs.Economizers;
model DedicatedDamperTandem
  "Separate dedicated OA damper - Dampers actuated in tandem"
  extends Interfaces.Economizer(
    final typ=Types.Economizer.DedicatedDamperTandem);

  Fluid.Actuators.Dampers.MixingBoxMinimumFlow mix(
    redeclare final package Medium = Medium,
    final mOut_flow_nominal=dat.mOut_flow_nominal,
    final mOutMin_flow_nominal=dat.mOutMin_flow_nominal,
    final mRec_flow_nominal=dat.mRec_flow_nominal,
    final mExh_flow_nominal=dat.mExh_flow_nominal,
    final dpDamExh_nominal=dat.dpDamExh_nominal,
    final dpDamOut_nominal=dat.dpDamOut_nominal,
    final dpDamOutMin_nominal=dat.dpDamOutMin_nominal,
    final dpDamRec_nominal=dat.dpDamRec_nominal)
    annotation (Placement(transformation(extent={{-10,-12},{10,8}})));

equation
  connect(port_OutMin, mix.port_OutMin) annotation (Line(points={{-100,0},{-60,0},
          {-60,8},{-10,8}}, color={0,127,255}));
  connect(port_Out, mix.port_Out) annotation (Line(points={{-100,-60},{-20,-60},
          {-20,4},{-10,4}}, color={0,127,255}));
  connect(mix.port_Sup, port_Sup) annotation (Line(points={{10,4},{20,4},{20,-60},
          {100,-60}}, color={0,127,255}));
  connect(mix.port_Ret, port_Ret) annotation (Line(points={{10,-8},{40,-8},{40,
          60},{100,60}}, color={0,127,255}));
  connect(port_Exh, mix.port_Exh) annotation (Line(points={{-100,60},{-40,60},{-40,
          -8},{-10,-8}}, color={0,127,255}));
  connect(ahuBus.ahuO.yEcoOut, mix.y) annotation (Line(
      points={{0.1,100.1},{0.1,56},{0,56},{0,10}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(ahuBus.ahuO.yEcoOutMin, mix.yOutMin) annotation (Line(
      points={{0.1,100.1},{-6,100.1},{-6,10}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  annotation (
  defaultComponentName="eco",
  Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end DedicatedDamperTandem;
