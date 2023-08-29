within Buildings.Templates.Components.Coolers;
model CoolingTower "Cooling tower model using Merkel method"
  extends Buildings.Templates.Components.Interfaces.PartialCooler;

  Buildings.Fluid.HeatExchangers.CoolingTowers.Merkel tow(
    redeclare final package Medium = MediumConWat,
    final m_flow_nominal=mConWat_flow_nominal,
    final ratWatAir_nominal=mConWat_flow_nominal/mAir_flow_nominal,
    final TAirInWB_nominal=dat.TWetBulEnt_nominal,
    final TWatIn_nominal=dat.TConWatRet_nominal,
    final TWatOut_nominal=dat.TConWatSup_nominal,
    final PFan_nominal=dat.PFan_nominal,
    final dp_nominal=dpConWatFri_nominal,
    final fraPFan_nominal=dat.PFan_nominal/mConWat_flow_nominal,
    final show_T=show_T,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_small=m_flow_small,
    final energyDynamics=energyDynamics,
    final tau=tau)
    "Cooling tower (single cell)"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Controls.OBC.CDL.Continuous.Multiply sigCon
    "Resulting control signal"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-20,30})));
  Controls.OBC.CDL.Conversions.BooleanToReal sigSta
    "Start/stop signal"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-26,62})));
  Controls.OBC.CDL.Logical.Pre pre
    "Compute chiller status by delaying chiller on/off signal"
    annotation (Placement(transformation(extent={{20,64},{40,84}})));
equation
  connect(tow.port_b, port_b)
    annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
  connect(sigCon.u2, sigSta.y)
    annotation (Line(points={{-26,42},{-26,50}},          color={0,0,127}));
  connect(bus.y1, sigSta.u) annotation (Line(
      points={{0,100},{0,80},{-26,80},{-26,74}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(sigCon.y, tow.y) annotation (Line(points={{-20,18},{-20,8},{-12,8}},
               color={0,0,127}));
  connect(busWea.TWetBul, tow.TAir) annotation (Line(
      points={{-60,100},{-60,4},{-12,4}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(bus.y, sigCon.u1) annotation (Line(
      points={{0,100},{0,52},{-14,52},{-14,42}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(sigSta.u, pre.u) annotation (Line(points={{-26,74},{18,74}},
                color={255,0,255}));
  connect(pre.y, bus.y1_actual) annotation (Line(points={{42,74},{60,74},{60,96},
          {0,96},{0,100}}, color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(port_a, tow.port_a)
    annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
  annotation (
  defaultComponentName="coo",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-40,-60},{40,-100}},
          lineColor={28,108,200},
          pattern=LinePattern.None,
          fillColor={239,239,239},
          fillPattern=FillPattern.Solid),
    Text( extent={{-60,-60},{60,-100}},
          textColor={0,0,0},
          textString="CT"),
    Rectangle(
          extent={{40,60},{-40,-100}},
          lineColor={0,0,0},
          lineThickness=1),
    Bitmap(extent={{-20,60},{20,100}}, fileName=
              "modelica://Buildings/Resources/Images/Templates/Components/Actuators/VFD.svg"),
        Bitmap(
          extent={{-33,-30},{33,30}},
          fileName="modelica://Buildings/Resources/Images/Templates/Components/Fans/Propeller.svg",
          origin={0,41},
          rotation=-90)}),
    Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>
November 18, 2022, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end CoolingTower;
