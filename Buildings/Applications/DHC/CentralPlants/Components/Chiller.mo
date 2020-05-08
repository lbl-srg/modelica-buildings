within Buildings.Applications.DHC.CentralPlants.Components;
model Chiller "Chiller model"
  replaceable package MediumCHW =
     Buildings.Media.Water
    "Medium in the chilled water side";
  replaceable package MediumCW =
     Buildings.Media.Water
    "Medium in the condenser water side";
  parameter Modelica.SIunits.Pressure dPCHW_nominal
    "Pressure difference at the chilled water side";
  parameter Modelica.SIunits.Pressure dPCW_nominal
    "Pressure difference at the condenser water wide";
  parameter Modelica.SIunits.MassFlowRate mCHW_flow_nominal
    "Nominal mass flow rate at the chilled water side";
  parameter Modelica.SIunits.MassFlowRate mCW_flow_nominal
    "Nominal mass flow rate at the condenser water wide";
  parameter Modelica.SIunits.Temperature TCW_start
    "The start temperature of condenser water side";
  parameter Modelica.SIunits.Temperature TCHW_start
    "The start temperature of chilled water side";

   parameter Buildings.Fluid.Chillers.Data.ElectricEIR.Generic per
    "Performance data"
    annotation (choicesAllMatching = true,
                Placement(transformation(extent={{40,80},{60,100}})));

  Buildings.Fluid.Chillers.ElectricEIR
                                  chi(
    redeclare package Medium1 = MediumCW,
    redeclare package Medium2 = MediumCHW,
    m1_flow_nominal=mCW_flow_nominal,
    m2_flow_nominal=mCHW_flow_nominal,
    dp1_nominal=0,
    dp2_nominal=0,
    allowFlowReversal1=true,
    allowFlowReversal2=true,
    tau1=300,
    tau2=300,
    T1_start=TCW_start,
    T2_start=TCHW_start,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    per=per)       annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-40})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a_CW(redeclare package Medium =
        MediumCW)
    "Fluid connector a1 (positive design flow direction is from port_a1 to port_b1)"
    annotation (Placement(transformation(extent={{-110,-90},{-90,-70}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b_CW(redeclare package Medium =
        MediumCW)
    "Fluid connector b1 (positive design flow direction is from port_a1 to port_b1)"
    annotation (Placement(transformation(extent={{-110,70},{-90,90}}),
        iconTransformation(extent={{-110,70},{-90,90}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b_CHW(redeclare package Medium =
        MediumCHW)
    "Fluid connector b2 (positive design flow direction is from port_a2 to port_b2)"
    annotation (Placement(transformation(extent={{90,-90},{110,-70}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a_CHW(redeclare package Medium =
        MediumCHW)
    "Fluid connector a2 (positive design flow direction is from port_a2 to port_b2)"
    annotation (Placement(transformation(extent={{90,70},{110,90}}),
        iconTransformation(extent={{90,70},{110,90}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTCHWLea(
    redeclare package Medium = MediumCHW,
    m_flow_nominal=mCHW_flow_nominal,
    T_start=TCHW_start)
    annotation (Placement(transformation(extent={{20,-90},{40,-70}})));
  Buildings.Fluid.Actuators.Valves.TwoWayLinear valCW(
    redeclare package Medium = MediumCW,
    m_flow_nominal=mCW_flow_nominal,
    allowFlowReversal=false,
    dpValve_nominal=dPCW_nominal)
    annotation (Placement(transformation(extent={{-60,90},{-80,70}})));
  Buildings.Fluid.Actuators.Valves.TwoWayLinear valCHW(
    redeclare package Medium = MediumCHW,
    m_flow_nominal=mCHW_flow_nominal,
    dpValve_nominal=dPCHW_nominal)
    annotation (Placement(transformation(extent={{60,-90},{80,-70}})));
  Modelica.Blocks.Interfaces.RealInput On(min=0,max=1)
    "True to enable compressor to operate, or false to disable the operation of the compressor"
    annotation (Placement(transformation(extent={{-118,-50},{-100,-30}}),
        iconTransformation(extent={{-140,-70},{-100,-30}})));
  Modelica.Blocks.Interfaces.RealInput TCHWSet
    "Temperature setpoint of chilled water"
    annotation (Placement(transformation(extent={{-118,30},{-100,50}}),
        iconTransformation(extent={{-140,10},{-100,50}})));
  Modelica.Blocks.Interfaces.RealOutput P
    "Electric power consumed by compressor"
    annotation (Placement(transformation(extent={{100,30},{120,50}}),
        iconTransformation(extent={{100,30},{120,50}})));

  Modelica.Blocks.Math.RealToBoolean realToBoolean
    annotation (Placement(transformation(extent={{-56,-66},{-42,-52}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTCWLea(
    allowFlowReversal=true,
    redeclare package Medium = MediumCW,
    m_flow_nominal=mCW_flow_nominal) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-40,0})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTCWEnt(
    allowFlowReversal=true,
    redeclare package Medium = MediumCW,
    m_flow_nominal=mCW_flow_nominal) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-40,-80})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTCHWEnt(
    allowFlowReversal=true,
    redeclare package Medium = MediumCHW,
    m_flow_nominal=mCHW_flow_nominal) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={30,0})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFloCHW(redeclare package Medium =
        MediumCHW)
    annotation (Placement(transformation(extent={{72,-10},{54,10}})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFloCW(redeclare package Medium =
        MediumCHW)
    annotation (Placement(transformation(extent={{-78,-90},{-60,-70}})));
  Buildings.Fluid.Sensors.Pressure senPreCHWEnt(redeclare package Medium =
        MediumCHW)
    annotation (Placement(transformation(extent={{2,10},{22,30}})));
  Buildings.Fluid.Sensors.Pressure senPreCHWLea(redeclare package Medium =
        MediumCHW)
    annotation (Placement(transformation(extent={{78,-50},{98,-30}})));
  Buildings.Fluid.Sensors.Pressure senPreCWLea(redeclare package Medium =
        MediumCHW)
    annotation (Placement(transformation(extent={{-76,68},{-96,48}})));
  Buildings.Fluid.Sensors.Pressure senPreCWEnt(redeclare package Medium =
        MediumCHW)
    annotation (Placement(transformation(extent={{-96,-70},{-76,-50}})));
equation
  connect(chi.port_b2, senTCHWLea.port_a) annotation (Line(
      points={{6,-50},{6,-80},{20,-80}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=1));
  connect(chi.P, P) annotation (Line(
      points={{-9,-29},{-9,40},{110,40}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(senTCHWLea.port_b, valCHW.port_a) annotation (Line(
      points={{40,-80},{60,-80}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=1));
  connect(valCHW.port_b, port_b_CHW) annotation (Line(
      points={{80,-80},{100,-80}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=1));
  connect(valCW.port_b, port_b_CW) annotation (Line(
      points={{-80,80},{-100,80}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=1));
  connect(TCHWSet, chi.TSet) annotation (Line(
      points={{-109,40},{-20,40},{-20,-74},{3,-74},{3,-52}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(realToBoolean.y, chi.on) annotation (Line(
      points={{-41.3,-59},{-3,-59},{-3,-52}},
      color={255,0,255},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(On, valCW.y) annotation (Line(
      points={{-109,-40},{-90,-40},{-80,-40},{-80,-26},{-70,-26},{-70,68}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(valCHW.y, valCW.y) annotation (Line(
      points={{70,-68},{70,-26},{-70,-26},{-70,68}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(realToBoolean.u, valCW.y) annotation (Line(
      points={{-57.4,-59},{-72,-59},{-72,-40},{-72,-26},{-70,-26},{-70,68}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(chi.port_b1, senTCWLea.port_a) annotation (Line(
      points={{-6,-30},{-6,0},{-30,0}},
      color={0,127,255},
      thickness=1));
  connect(senTCWLea.port_b, valCW.port_a) annotation (Line(
      points={{-50,0},{-50,0},{-54,0},{-54,80},{-60,80}},
      color={0,127,255},
      thickness=1));
  connect(senTCWEnt.port_b, chi.port_a1) annotation (Line(
      points={{-30,-80},{-6,-80},{-6,-50}},
      color={0,127,255},
      thickness=1));
  connect(senTCHWEnt.port_b, chi.port_a2) annotation (Line(
      points={{20,0},{6,0},{6,-30}},
      color={0,127,255},
      thickness=1));
  connect(senPreCHWEnt.port, chi.port_a2) annotation (Line(
      points={{12,10},{12,0},{6,0},{6,-30}},
      color={0,127,255},
      thickness=1));
  connect(senPreCHWLea.port, port_b_CHW) annotation (Line(
      points={{88,-50},{88,-50},{88,-80},{100,-80}},
      color={0,127,255},
      thickness=1));
  connect(senPreCWLea.port, port_b_CW) annotation (Line(
      points={{-86,68},{-86,80},{-100,80}},
      color={0,127,255},
      thickness=1));
  connect(senMasFloCHW.port_b, senTCHWEnt.port_a) annotation (Line(
      points={{54,0},{47,0},{40,0}},
      color={0,127,255},
      thickness=1));
  connect(senMasFloCHW.port_a, port_a_CHW) annotation (Line(
      points={{72,0},{80,0},{80,80},{100,80}},
      color={0,127,255},
      thickness=1));
  connect(senMasFloCW.port_b, senTCWEnt.port_a) annotation (Line(
      points={{-60,-80},{-55,-80},{-50,-80}},
      color={0,127,255},
      thickness=1));
  connect(senMasFloCW.port_a, port_a_CW) annotation (Line(
      points={{-78,-80},{-100,-80}},
      color={0,127,255},
      thickness=1));
  connect(senPreCWEnt.port, port_a_CW) annotation (Line(
      points={{-86,-70},{-86,-80},{-100,-80}},
      color={0,127,255},
      thickness=1));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),           Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
        Text(
          extent={{-44,-144},{50,-112}},
          lineColor={0,0,255},
          textString="%name"),
        Rectangle(
          extent={{-101,82},{100,72}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-95,-76},{106,-86}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-54,50},{60,32}},
          lineColor={0,128,255},
          fillColor={170,170,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-52,-50},{62,-68}},
          lineColor={0,128,255},
          fillColor={170,170,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-101,82},{100,72}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{0,72},{100,82}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-95,-76},{106,-86}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-102,-86},{-2,-76}},
          lineColor={0,0,127},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-32,-10},{-42,-22},{-22,-22},{-32,-10}},
          lineColor={0,128,255},
          fillColor={170,170,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-32,-10},{-42,0},{-22,0},{-32,-10}},
          lineColor={0,128,255},
          fillColor={170,170,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-34,32},{-30,0}},
          lineColor={0,128,255},
          fillColor={170,170,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-34,-22},{-30,-50}},
          lineColor={0,128,255},
          fillColor={170,170,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{34,32},{38,-50}},
          lineColor={0,128,255},
          fillColor={170,170,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{14,10},{58,-32}},
          lineColor={0,128,255},
          fillColor={170,170,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{36,10},{18,-22},{54,-22},{36,10}},
          lineColor={0,128,255},
          fillColor={170,170,255},
          fillPattern=FillPattern.Solid)}),
    Documentation(revisions="<html>
<ul>
<li>
March 19, 2014 by Sen Huang:<br/>
First implementation.
</li>
</ul>
</html>"));
end Chiller;
