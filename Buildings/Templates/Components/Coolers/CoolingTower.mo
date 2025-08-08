within Buildings.Templates.Components.Coolers;
model CoolingTower "Cooling tower model using Merkel method"
  extends Buildings.Templates.Components.Interfaces.PartialCooler(
    final typ=if typTow==Buildings.Templates.Components.Types.CoolingTower.Open then
      Buildings.Templates.Components.Types.Cooler.CoolingTowerOpen
      elseif typTow==Buildings.Templates.Components.Types.CoolingTower.Closed then
        Buildings.Templates.Components.Types.Cooler.CoolingTowerOpen
      else Buildings.Templates.Components.Types.Cooler.None);

  parameter Buildings.Templates.Components.Types.CoolingTower typTow
    "Cooling tower type"
    annotation(Evaluate=true, Dialog(group="Configuration"));

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
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply yCom "Commanded speed" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-20,-20})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal y1Rea
    "Convert start/stop signal into real" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-40,20})));
  Controls.StatusEmulator y1_actual "Compute cooling tower status"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=90,
      origin={40,70})));
equation
  connect(tow.port_b, port_b)
    annotation (Line(points={{10,-60},{80,-60},{80,0},{100,0}},
                                              color={0,127,255}));
  connect(yCom.u2, y1Rea.y) annotation (Line(points={{-26,-8},{-26,0},{-40,0},{
          -40,8}}, color={0,0,127}));
  connect(bus.y1, y1Rea.u) annotation (Line(
      points={{0,100},{0,60},{-40,60},{-40,32}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(yCom.y, tow.y)
    annotation (Line(points={{-20,-32},{-20,-52},{-12,-52}}, color={0,0,127}));
  connect(busWea.TWetBul, tow.TAir) annotation (Line(
      points={{-59.9,100.1},{-59.9,-56},{-12,-56}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(bus.y, yCom.u1) annotation (Line(
      points={{0,100},{0,0},{-14,0},{-14,-8}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(port_a, tow.port_a)
    annotation (Line(points={{-100,0},{-80,0},{-80,-60},{-10,-60}},
                                                color={0,127,255}));
  connect(y1Rea.u, y1_actual.y1) annotation (Line(points={{-40,32},{-40,40},{40,
          40},{40,58}}, color={255,0,255}));
  connect(y1_actual.y1_actual, bus.y1_actual) annotation (Line(points={{40,82},
          {40,96},{6,96},{6,100},{0,100}}, color={255,0,255}));
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
April 17, 2025, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This is a model of a single cooling tower cell with a variable speed fan.
The model is a wrapper for
<a href=\"modelica://Buildings.Fluid.HeatExchangers.CoolingTowers.Merkel\">
Buildings.Fluid.HeatExchangers.CoolingTowers.Merkel</a>
and uses Merkel's method to calculate the cooling heat flow rate of the condenser water.
</p>
<p>
The user may refer to the documentation of the above model for the modeling assumptions.
Both open-circuit and closed-circuit cooling towers are supported.
Note that the tower basin is not modeled, nor is the spray pump,
and only friction pressure losses are accounted for.
</p>
<h4>Control points</h4>
<p>
The following input and output points are available.
</p>
<ul>
<li>
Start command: <code>y1</code>, DO signal
</li>
<li>
<li>
Fan speed command (VFD speed): <code>y</code>, AO signal
</li>
<li>
Fan status (VFD status): <code>y1_actual</code>, DI signal
</li>
</ul>
<h4>Model parameters</h4>
<p>
The design parameters are specified with an instance of
<a href=\"modelica://Buildings.Templates.Components.Data.Cooler\">
Buildings.Templates.Components.Data.Cooler</a>.
Despite the fact that only friction pressure losses are accounted for,
the parameter record includes the elevation head for 
open-circuit cooling towers. This parameter is used to size the condenser 
water pumps and to prepare for future support.
</p>
</html>"));
end CoolingTower;
