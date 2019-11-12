within Buildings.Applications.DHC.EnergyTransferStations.BaseClasses;
partial model PartialCooling
  extends Buildings.Fluid.Interfaces.PartialFourPort(redeclare package Medium2 =
        Medium, redeclare package Medium1 = Medium);

 final package Medium = Buildings.Media.Water;

 parameter Modelica.SIunits.SpecificHeatCapacity cp=
   Medium.specificHeatCapacityCp(
      Medium.setState_pTX(Medium.p_default, Medium.T_default, Medium.X_default))
    "Default specific heat capacity of medium";

  // mass flow rate
  parameter Modelica.SIunits.MassFlowRate m1_flow_nominal(min=0,start=0.5)
    "Nominal mass flow rate of primary (district) district cooling side";

  Buildings.Fluid.Sensors.TemperatureTwoPort senTDisSup(
    redeclare package Medium = Medium,
    m_flow_nominal=m1_flow_nominal)
    "District-side (primary) supply temperature sensor"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-80,60})));

  Buildings.Fluid.Sensors.TemperatureTwoPort senTDisRet(
    redeclare package Medium = Medium,
    m_flow_nominal=m1_flow_nominal)
    "District-side (primary) return temperature sensor"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={80,60})));

  Modelica.Blocks.Sources.RealExpression powCal(y=senMasFlo.m_flow*cp*(
        senTDisRet.T - senTDisSup.T))
    "Calculated power demand"
    annotation (Placement(transformation(extent={{-100,-100},{-20,-80}})));

  Modelica.Blocks.Interfaces.RealOutput Q_flow(
    quantity="Power",
    unit="W",
    displayUnit="kW")
    "Measured power demand at the ETS"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={90,-130}), iconTransformation(
        extent={{-10,-10},{10,10}},
        origin={70,-110},
        rotation=-90)));

  Modelica.Blocks.Interfaces.RealOutput Q(
    quantity="Energy",
    unit="J",
    displayUnit="kWh")
    "Measured energy consumption at the ETS"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={50,-130}), iconTransformation(
        extent={{-10,-10},{10,10}},
        origin={30,-110},
        rotation=-90)));

  Modelica.Blocks.Continuous.Integrator int(k=1) "Integration"
    annotation (Placement(transformation(extent={{0,-120},{20,-100}})));

  Fluid.Sensors.MassFlowRate senMasFlo(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
equation
  connect(senTDisSup.port_a, port_a1)
    annotation (Line(points={{-90,60},{-100,60}}, color={0,127,255}));
  connect(port_b1, senTDisRet.port_b) annotation (Line(points={{100,60},{90,60}},
                            color={0,127,255}));
  connect(powCal.y, Q_flow) annotation (Line(points={{-16,-90},{90,-90},{90,
          -130}},
        color={0,0,127}));
  connect(int.y, Q)
    annotation (Line(points={{21,-110},{50,-110},{50,-130}}, color={0,0,127}));
  connect(powCal.y, int.u) annotation (Line(points={{-16,-90},{-10,-90},{-10,
          -110},{-2,-110}},
                      color={0,0,127}));
  connect(senTDisSup.port_b, senMasFlo.port_a)
    annotation (Line(points={{-70,60},{-60,60}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}),                                        graphics={
        Rectangle(
          extent={{-100,65},{101,55}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,-55},{101,-65}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
                              Rectangle(
          extent={{-80,80},{80,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid)}),                      Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-120},{100,100}})),
    Documentation(info="<html>
<p>
Partial model to implement cooling energy transfer station models. 
The \"meter\" in this model calculates the power demand and instantaneous
energy consumption. 
</p>
</html>", revisions="<html>
<ul>
<li>November 5, 2019, by Kathryn Hinkelman:<br>First implementation. </li>
</ul>
</html>"));
end PartialCooling;
