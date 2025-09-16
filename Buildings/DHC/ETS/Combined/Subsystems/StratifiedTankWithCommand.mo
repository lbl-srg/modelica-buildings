within Buildings.DHC.ETS.Combined.Subsystems;
model StratifiedTankWithCommand "Stratified buffer tank model"
  replaceable package Medium=Modelica.Media.Interfaces.PartialMedium
    "Medium model"
    annotation (choices(
      choice(redeclare package Medium=Buildings.Media.Water "Water"),
      choice(redeclare package Medium = Buildings.Media.Antifreeze.PropyleneGlycolWater (property_T=293.15,X_a=0.40)
        "Propylene glycol water, 40% mass fraction")));
  final parameter Boolean allowFlowReversal=true
    "= true to allow flow reversal, false restricts to design direction (port_a -> port_b)"
    annotation (Dialog(tab="Assumptions"),Evaluate=true);
  parameter Modelica.Units.SI.Volume VTan "Tank volume";
  parameter Modelica.Units.SI.Length hTan "Height of tank (without insulation)";
  parameter Modelica.Units.SI.Length dIns "Thickness of insulation";
  parameter Modelica.Units.SI.ThermalConductivity kIns=0.04
    "Specific heat conductivity of insulation";
  parameter Integer nSeg(
    min=2)=3
    "Number of volume segments";
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal
    "Nominal mass flow rate" annotation (Dialog(group="Nominal condition"));
  parameter Medium.Temperature T_start=Medium.T_default
    "Temperature start value"
    annotation(Dialog(tab = "Initialization"));
  parameter Boolean isHotWat
    "True if the tank supplies hot water, false for chilled water";
  parameter Modelica.Units.SI.TemperatureDifference dTOffSet=if tanCha.isHotWat
       then +1 else -1
    "Offset for set point to have a slightly higher (or lower) temperature than the required supply from the load";

  // IO CONNECTORS
  Modelica.Fluid.Interfaces.FluidPort_a port_genTop(
    redeclare final package Medium = Medium,
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "Tank top port on generation side" annotation (Placement(transformation(
          extent={{90,50},{110,70}}), iconTransformation(extent={{90,50},{110,
            70}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_genBot(
    redeclare final package Medium = Medium,
    m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "Tank bottom port on generation side" annotation (Placement(transformation(
          extent={{90,-70},{110,-50}}), iconTransformation(extent={{90,-70},{
            110,-50}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_loaBot(
    redeclare final package Medium = Medium,
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "Tank bottom port on load side" annotation (Placement(transformation(extent
          ={{-110,-70},{-90,-50}}), iconTransformation(extent={{-110,-70},{-90,
            -50}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_loaTop(
    redeclare final package Medium = Medium,
    m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "Tank top port on load side" annotation (Placement(transformation(extent={{
            -110,50},{-90,70}}), iconTransformation(extent={{-110,50},{-90,70}})));
  Modelica.Blocks.Interfaces.RealOutput Ql_flow(
    final unit="W")
    "Heat loss of tank (positive if heat flows from tank to ambient)"
    annotation (Placement(transformation(extent={{100,10},{140,50}}), iconTransformation(extent={{100,20},
            {120,40}})));
  Modelica.Blocks.Interfaces.RealOutput TTop(
    final unit="K",
    displayUnit="degC")
    "Fluid temperature at tank top"
    annotation (Placement(transformation(extent={{100,70},{140,110}}),
                                                                     iconTransformation(extent={{100,80},{120,100}})));
  Modelica.Blocks.Interfaces.RealOutput TBot(
    final unit="K",
    displayUnit="degC")
    "Fluid temperature at tank bottom"
    annotation (Placement(transformation(extent={{100,-110},{140,-70}}),
                                                                       iconTransformation(extent={{100,-100},{120,-80}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heaPorAmb
    "Heat port at interface with ambient (outside insulation)"
    annotation (Placement(transformation(extent={{-106,-6},{-94,6}})));
  // COMPONENTS
  Buildings.Fluid.Storage.Stratified tan(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    final VTan=VTan,
    final hTan=hTan,
    final dIns=dIns,
    final kIns=kIns,
    final nSeg=nSeg,
    final T_start=T_start) "Stratified tank"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor senTBot
    "Tank bottom temperature"
    annotation (Placement(transformation(extent={{30,-50},{50,-30}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor senTTop
    "Tank top temperature"
    annotation (Placement(transformation(extent={{30,30},{50,50}})));
  Buildings.DHC.ETS.Combined.Controls.TankChargingController tanCha(final
      dTOffSet=dTOffSet, final isHotWat=isHotWat) "Tank charging command"
    annotation (Placement(transformation(extent={{70,-40},{90,-20}})));
  Modelica.Blocks.Interfaces.RealInput TTanSet(
    final unit="K",
    displayUnit="degC")
    "Tank temperature set point, top for hot tank and bottom for cold tank"
    annotation (Placement(transformation(extent={{-140,70},{-100,110}}),
        iconTransformation(extent={{-120,80},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput charge
    "Outputs true if tank should be charged" annotation (Placement(
        transformation(extent={{100,-50},{140,-10}}),iconTransformation(extent={{100,-50},
            {140,-10}})));
  Buildings.Fluid.FixedResistances.Junction junTop(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=T_start,
    m_flow_nominal=m_flow_nominal*{1,-1,-1},
    dp_nominal=zeros(3)) "Fluid junction at top of tank"
    annotation (Placement(transformation(extent={{10,50},{-10,70}})));
  Buildings.Fluid.FixedResistances.Junction junBot(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=T_start,
    m_flow_nominal=m_flow_nominal*{1,-1,1},
    dp_nominal=zeros(3)) "Fluid junction at bottom of tank"
    annotation (Placement(transformation(extent={{-10,-50},{10,-70}})));
protected
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector theCol(
    m=3)
    "Connector to assign multiple heat ports to one heat port"
    annotation (Placement(transformation(extent={{-6,-6},{6,6}},rotation=-90,origin={-60,0})));
equation
  connect(tan.Ql_flow,Ql_flow)
    annotation (Line(points={{11,7.2},{80,7.2},{80,30},{120,30}},  color={0,0,127}));
  connect(tan.heaPorVol[nSeg],senTBot.port)
    annotation (Line(points={{0,0},{16,0},{16,-40},{30,-40}},color={191,0,0}));
  connect(tan.heaPorVol[1],senTTop.port)
    annotation (Line(points={{0,-0.2},{16,-0.2},{16,40},{30,40}},color={191,0,0}));
  connect(senTTop.T,TTop)
    annotation (Line(points={{51,40},{60,40},{60,90},{120,90}},color={0,0,127}));
  connect(senTBot.T,TBot)
    annotation (Line(points={{51,-40},{60,-40},{60,-90},{120,-90}},color={0,0,127}));
  connect(heaPorAmb,theCol.port_b)
    annotation (Line(points={{-100,0},{-66,0}},color={191,0,0}));
  connect(theCol.port_a[1],tan.heaPorTop)
    annotation (Line(points={{-54.2,0},{-26,0},{-26,7.4},{2,7.4}},color={191,0,0}));
  connect(theCol.port_a[2],tan.heaPorSid)
    annotation (Line(points={{-54,0},{5.6,0}},color={191,0,0}));
  connect(theCol.port_a[3],tan.heaPorBot)
    annotation (Line(points={{-53.8,0},{-26,0},{-26,-7.4},{2,-7.4}},color={191,0,0}));
  connect(senTTop.T, tanCha.TTanTop) annotation (Line(points={{51,40},{60,40},{
          60,-30},{68,-30}}, color={0,0,127}));
  connect(senTBot.T, tanCha.TTanBot) annotation (Line(points={{51,-40},{60,-40},
          {60,-38},{68,-38}}, color={0,0,127}));
  connect(tanCha.charge, charge)
    annotation (Line(points={{92,-30},{120,-30}}, color={255,0,255}));

  connect(junTop.port_3, tan.port_a)
    annotation (Line(points={{0,50},{0,10}}, color={0,127,255}));
  connect(tan.port_b, junBot.port_3)
    annotation (Line(points={{0,-10},{0,-50}}, color={0,127,255}));
  connect(port_loaBot, junBot.port_1)
    annotation (Line(points={{-100,-60},{-10,-60}}, color={0,127,255}));
  connect(junBot.port_2, port_genBot)
    annotation (Line(points={{10,-60},{100,-60}}, color={0,127,255}));
  connect(port_loaTop, junTop.port_2)
    annotation (Line(points={{-100,60},{-10,60}}, color={0,127,255}));
  connect(junTop.port_1, port_genTop)
    annotation (Line(points={{10,60},{100,60}}, color={0,127,255}));
  connect(TTanSet, tanCha.TTanSet) annotation (Line(points={{-120,90},{64,90},{64,
          -22},{69,-22}}, color={0,0,127}));
  annotation (
    Icon(
      coordinateSystem(
        extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-40,64},{40,20}},
          lineColor={255,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-40,-20},{40,-64}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-40,20},{40,-20}},
          lineColor={255,0,0},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.CrossDiag),
        Rectangle(
          extent={{50,68},{40,-66}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-40,66},{-50,-68}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-50,72},{50,64}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-50,-64},{50,-72}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-50,64},{-100,56}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{100,64},{50,56}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{100,-56},{50,-64}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-50,-56},{-100,-64}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-139,-106},{161,-146}},
          textColor={0,0,255},
          textString="%name"),
        Rectangle(
          extent={{100,4},{50,-4}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid)}),
    defaultComponentName="tan",
    Diagram(
      coordinateSystem(
        extent={{-100,-100},{100,100}})),
    Documentation(
      revisions="<html>
<ul>
<li>
July 31, 2020, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>",
      info="<html>
<p>
This is a four-port tank model based on
<a href=\"modelica://Buildings.Fluid.Storage.Stratified\">
Buildings.Fluid.Storage.Stratified</a>
which includes the following features.
</p>
<ul>
<li>
The two fluid ports suffixed with <code>Top</code> are connected
to the fluid volume at the top of the tank.
</li>
<li>
The two fluid ports suffixed with <code>Bot</code> are connected
to the fluid volume at the bottom of the tank.
</li>
<li>
A unique heat port is exposed as an external connector. It is
meant to provide a uniform temperature boundary condition at
the external surface of the tank (outside insulation).
</li>
<li>
The model outputs the temperature of the fluid volumes at the top
and at the bottom of the tank.
</li>
</ul>
<h4>ESTCP modification</h4>
<p>
A block is added to also report whether the tank requests charging.
</p>
</html>"));
end StratifiedTankWithCommand;
