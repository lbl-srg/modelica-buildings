within Buildings.Applications.DHC.Networks.BaseClasses;
partial model PartialConnection2Pipe
  "Partial model for connecting an agent to a two-pipe distribution network"
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    "Medium model"
    annotation(choices(
      choice(redeclare package Medium = Buildings.Media.Water "Water"),
      choice(redeclare package Medium =
        Buildings.Media.Antifreeze.PropyleneGlycolWater (
          property_T=293.15, X_a=0.40) "Propylene glycol water, 40% mass fraction")));
  replaceable model PipeDisModel =
      Examples.FifthGeneration.Unidirectional.Networks.BaseClasses.PipeDistribution
    constrainedby PartialPipe(
    redeclare package Medium = Medium,
    m_flow_nominal=mDis_flow_nominal,
    allowFlowReversal=allowFlowReversal);
  replaceable model PipeConModel =
      Examples.FifthGeneration.Unidirectional.Networks.BaseClasses.PipeConnection
    constrainedby PartialPipe(
    redeclare package Medium = Medium,
    m_flow_nominal=mCon_flow_nominal,
    allowFlowReversal=allowFlowReversal);
  parameter Modelica.SIunits.MassFlowRate mDis_flow_nominal
    "Nominal mass flow rate in the distribution line"
    annotation(Dialog(tab="General", group="Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate mCon_flow_nominal
    "Nominal mass flow rate in the connection line"
    annotation(Dialog(tab="General", group="Nominal condition"));
  parameter Boolean allowFlowReversal = false
    "= true to allow flow reversal, false restricts to design direction (port_a -> port_b)"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);
  // IO CONNECTORS
  Modelica.Fluid.Interfaces.FluidPort_a port_aDisSup(
    redeclare package Medium = Medium,
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "Distribution supply inlet port"
    annotation (Placement(transformation(
          extent={{-110,-50},{-90,-30}}), iconTransformation(extent={{-110,-10},
            {-90,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_bDisSup(
    redeclare package Medium = Medium,
    m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "Distribution supply outlet port"
    annotation (Placement(transformation(
          extent={{90,-50},{110,-30}}), iconTransformation(extent={{90,-10},{
            110,10}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_aDisRet(
    redeclare package Medium = Medium,
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "Distribution return inlet port"
    annotation (Placement(transformation(
          extent={{90,-90},{110,-70}}), iconTransformation(extent={{90,-70},{
            110,-50}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_bDisRet(
    redeclare package Medium = Medium,
    m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "Distribution return outlet port"
    annotation (Placement(transformation(
          extent={{-110,-90},{-90,-70}}), iconTransformation(extent={{-110,-70},
            {-90,-50}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_bCon(
    redeclare package Medium = Medium,
    m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "Connection supply port"
    annotation (Placement(transformation(extent={{-30,110},{-10,130}}),
                              iconTransformation(extent={{-10,90},{10,110}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_aCon(
    redeclare package Medium = Medium,
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "Connection return port"
    annotation (Placement(transformation(extent={{10,110},{30,130}}),
                             iconTransformation(extent={{50,90},{70,110}})));
  Modelica.Blocks.Interfaces.RealOutput mCon_flow
    "Connection supply mass flow rate"
    annotation (Placement(transformation(
      extent={{100,20},{140,60}}),
      iconTransformation(extent={{100,50},{120, 70}})));
  Modelica.Blocks.Interfaces.RealOutput Q_flow
    "Heat flow rate transferred to the connected load (>=0 for heating)"
    annotation (Placement(transformation(extent={{100,60},{140,100}}),
      iconTransformation(extent={{100,70},{120,90}})));
  // COMPONENTS
  PipeDisModel pipDisSup
  "Distribution supply pipe"
  annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
  PipeDisModel pipDisRet
    "Distribution return pipe"
    annotation (Placement(transformation(extent={{-40,-90},{-60,-70}})));
  PipeConModel pipCon
    "Connection pipe"
    annotation (Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=90,
      origin={-20,-10})));
  Junction junConSup(
    redeclare package Medium = Medium,
    portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    m_flow_nominal={mDis_flow_nominal,-mDis_flow_nominal,-mCon_flow_nominal})
    "Junction with connection supply"
    annotation (Placement(transformation(extent={{-30,-30},{-10,-50}})));
  Junction junConRet(
    redeclare package Medium = Medium,
    portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    m_flow_nominal={mDis_flow_nominal,-mDis_flow_nominal,mCon_flow_nominal})
    "Junction with connection return"
    annotation (Placement(transformation(extent={{30,-70},{10,-90}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTConSup(
    allowFlowReversal=allowFlowReversal,
    redeclare package Medium=Medium,
    m_flow_nominal=mCon_flow_nominal)
    "Connection supply temperature (sensed)"
    annotation (Placement(transformation(
      extent={{10,10},{-10,-10}},
      rotation=-90,
      origin={-20,80})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTConRet(
    allowFlowReversal=allowFlowReversal,
    redeclare package Medium=Medium,
    m_flow_nominal=mCon_flow_nominal)
    "Connection return temperature (sensed)"
    annotation (Placement(transformation(
      extent={{-10,10},{10,-10}},
      rotation=-90,
      origin={20,80})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFloCon(
    redeclare package Medium=Medium,
    allowFlowReversal=allowFlowReversal)
    "Connection supply mass flow rate (sensed)"
    annotation (Placement(
      transformation(
      extent={{-10,10},{10,-10}},
      rotation=90,
      origin={-20,40})));
  Modelica.Blocks.Sources.RealExpression QCal_flow(
    y=(senTConSup.T - senTConRet.T) * cp_default * senMasFloCon.m_flow)
    "Calculation of heat flow rate transferred to the load"
    annotation (Placement(transformation(extent={{60,70},{80,90}})));
protected
  parameter Modelica.SIunits.SpecificHeatCapacity cp_default=
    Medium.specificHeatCapacityCp(Medium.setState_pTX(
      p = Medium.p_default,
      T = Medium.T_default,
      X = Medium.X_default))
    "Specific heat capacity of medium at default medium state";
equation
  connect(junConSup.port_3, pipCon.port_a)
    annotation (Line(points={{-20,-30},{-20,-20}}, color={0,127,255}));
  connect(pipDisSup.port_b, junConSup.port_1)
    annotation (Line(points={{-40,-40},{-30,-40}}, color={0,127,255}));
  connect(port_bCon, senTConSup.port_b)
    annotation (Line(points={{-20,120},{-20,90}}, color={0,127,255}));
  connect(junConRet.port_3, senTConRet.port_b)
    annotation (Line(points={{20,-70},{20,70}}, color={0,127,255}));
  connect(senTConRet.port_a, port_aCon)
    annotation (Line(points={{20,90},{20,120}}, color={0,127,255}));
  connect(senMasFloCon.port_b,senTConSup. port_a)
    annotation (Line(points={{-20,50},{-20,70}}, color={0,127,255}));
  connect(senMasFloCon.m_flow, mCon_flow)
    annotation (Line(points={{-9,40},{120,40}},  color={0,0,127}));
  connect(pipCon.port_b, senMasFloCon.port_a)
    annotation (Line(points={{-20,0},{-20,30}}, color={0,127,255}));
  connect(QCal_flow.y, Q_flow)
    annotation (Line(points={{81,80},{120,80}}, color={0,0,127}));
  connect(port_aDisSup, pipDisSup.port_a)
    annotation (Line(points={{-100,-40},{-60,-40}}, color={0,127,255}));
  connect(port_aDisRet, junConRet.port_1)
    annotation (Line(points={{100,-80},{30,-80}}, color={0,127,255}));
  connect(junConSup.port_2, port_bDisSup)
    annotation (Line(points={{-10,-40},{100,-40}}, color={0,127,255}));
  connect(junConRet.port_2, pipDisRet.port_a)
    annotation (Line(points={{10,-80},{-40,-80}}, color={0,127,255}));
  connect(pipDisRet.port_b, port_bDisRet)
    annotation (Line(points={{-60,-80},{-100,-80}}, color={0,127,255}));
  annotation (
    defaultComponentName="con",
    Icon(graphics={   Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,2},{100,-2}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-2,-2},{2,100}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),           Text(
        extent={{-152,-104},{148,-144}},
        textString="%name",
        lineColor={0,0,255}),
        Rectangle(
          extent={{-76,12},{-20,-12}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-25,8},{25,-8}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0},
          origin={0,45},
          rotation=90),
        Rectangle(
          extent={{58,6},{62,100}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-100,-58},{100,-62}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-76,-48},{-20,-72}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{58,-62},{62,-6}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-25.5,7.5},{25.5,-7.5}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0},
          origin={59.5,45.5},
          rotation=90)}),       Diagram(coordinateSystem(extent={{-100,-100},{100,
            120}})));
end PartialConnection2Pipe;
