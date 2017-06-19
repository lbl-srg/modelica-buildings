within Buildings.Experimental.ScalableModels.ThermalZones.BaseClasses;
model ThermalZoneFluctuatingIHG_WithPorts "Thermal zone model"
  extends
    Buildings.Experimental.ScalableModels.ThermalZones.BaseClasses.ThermalZoneFluctuatingIHG(      roo(
    nPorts=4));

  replaceable package MediumA = Modelica.Media.Interfaces.PartialMedium
    "Medium model";

  Modelica.Fluid.Vessels.BaseClasses.VesselFluidPorts_b portsInOut[2](
      redeclare package Medium = MediumA) "Fluid inlets and outlets"
    annotation (Placement(transformation(extent={{-88,16},{-48,32}}),
        iconTransformation(extent={{-88,16},{-48,32}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor rooAirTem
    "Air temperature sensor"  annotation (Placement(transformation(extent={{66,30},
            {78,42}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort supAirTem(redeclare package Medium =
                       MediumA, m_flow_nominal=1,
    tau=30)
    "Supply air temperature sensor"  annotation (Placement(transformation(extent={{-24,9},
            {-12,21}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort retAirTem(redeclare package Medium =
                       MediumA, m_flow_nominal=1,
    tau=30)
    "Return air temperature sensor"  annotation (Placement(transformation(extent={{-12,26},
            {-24,38}})));
  Buildings.Fluid.Sensors.MassFlowRate supplyAirFlow(redeclare package Medium =
               MediumA)
    annotation (Placement(transformation(extent={{-44,10},{-34,20}})));

  Modelica.Blocks.Interfaces.RealOutput TRooAir "Room air temperatures"
    annotation (Placement(transformation(extent={{92,26},{112,46}}),
        iconTransformation(extent={{92,26},{112,46}})));
  Modelica.Blocks.Sources.RealExpression PowerCalc(y=supplyAirFlow.m_flow*1005*(
        supAirTem.T - TRooAir))     "Cooling negative, heating positive"
    annotation (Placement(transformation(extent={{54,46},{74,66}})));
  Modelica.Blocks.Interfaces.RealOutput heaCooPow "HVAC power"
    annotation (Placement(transformation(extent={{92,46},{112,66}})));
equation

  connect(supAirTem.port_a,supplyAirFlow.port_b) annotation (Line(
      points={{-24,15},{-34,15}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(portsInOut[1],supplyAirFlow.port_a) annotation (Line(
      points={{-78,24},{-50,24},{-50,15},{-44,15}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(portsInOut[2],retAirTem.port_b) annotation (Line(
      points={{-58,24},{-50,24},{-50,32},{-24,32}},
      color={0,127,255},
      smooth=Smooth.None));

  connect(rooAirTem.T, TRooAir) annotation (Line(points={{78,36},{84,36},{102,36}},
                    color={0,0,127}));
  connect(PowerCalc.y, heaCooPow)
    annotation (Line(points={{75,56},{102,56}}, color={0,0,127}));
  connect(supAirTem.port_b, roo.ports[3]) annotation (Line(points={{-12,15},{14,
          15},{14,-8.5},{39.75,-8.5}}, color={0,127,255}));
  connect(retAirTem.port_a, roo.ports[4]) annotation (Line(points={{-12,32},{14,
          32},{14,-8.5},{39.75,-8.5}}, color={0,127,255}));
  connect(roo.heaPorAir, rooAirTem.port)
    annotation (Line(points={{50.25,-1},{50.25,36},{66,36}}, color={191,0,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100, 100}}), graphics={
        Rectangle(
          extent={{-46,-46},{46,46}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid,
          origin={0,0},
          rotation=90),
        Text(
          extent={{-84,8},{-64,-6}},
          lineColor={0,0,255},
          textString="Wall"),
        Text(
          extent={{66,8},{86,-6}},
          lineColor={0,0,255},
          textString="Wall"),
        Text(
          extent={{-8,-74},{12,-88}},
          lineColor={0,0,255},
          textString="Floor"),
        Text(
          extent={{-10,88},{10,74}},
          lineColor={0,0,255},
          textString="Ceiling"),
        Rectangle(
          extent={{-40,40},{40,-40}},
          pattern=LinePattern.None,
          lineColor={117,148,176},
          fillColor={170,213,255},
          fillPattern=FillPattern.Sphere)}),
     Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{280,180}})),
     Documentation(info="<html>
<p>
This model consist a building enveloped model which is extented from 
<a href=\"modelica://Buildings.ThermalZones.Detailed.MixedAir\">
Buildings.ThermalZones.Detailed.MixedAir</a>.
</p>
<p>
Internal heat gain which includes radiative heat gain <code>qRadGai_flow</code>,
convective heat gain <code>qConGai_flow</code>, and latent heat gain 
<code>qLatGai_flow</code> are referenced from ASHRAE Handbook fundamental. 
The factor <code>gainFactor</code> is used to scale down the heat gain.
The gain schdule is specified by <code>intLoad</code>.
Air infiltration from outside is assumed to be 0.5 ACH.
</p>
</html>", revisions="<html>
<ul>
<li>
April 10, 2016, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end ThermalZoneFluctuatingIHG_WithPorts;
