within Buildings.Applications.DHC.Examples.Combined.Generation5.Unidirectional.Distribution.BaseClasses;
model ConnectionParallel "Model for connecting an agent to the DHC system"
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium "Medium model"
    annotation (__Dymola_choicesAllMatching=true);
  parameter Boolean haveBypFloSen = false
    "Set to true to sense the bypass mass flow rate"
    annotation(Evaluate=true);
  parameter Modelica.SIunits.MassFlowRate mDis_flow_nominal
    "Nominal mass flow rate in the distribution line";
  parameter Modelica.SIunits.MassFlowRate mCon_flow_nominal
    "Nominal mass flow rate in the connection line";
  parameter Modelica.SIunits.Length lDis
    "Length of the distribution pipe before the connection";
  parameter Modelica.SIunits.Length lCon
    "Length of the connection pipe (supply only, not counting return line)";
  parameter Modelica.SIunits.Length dhDis
    "Hydraulic diameter of the distribution pipe";
  parameter Modelica.SIunits.Length dhCon
    "Hydraulic diameter of the connection pipe";
  parameter Boolean allowFlowReversal = false
    "= true to allow flow reversal, false restricts to design direction (port_a -> port_b)"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);
  // IO CONNECTORS
  Modelica.Fluid.Interfaces.FluidPort_a port_disSupInl(
    redeclare package Medium = Medium,
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "Distribution supply inlet port" annotation (Placement(transformation(
          extent={{-110,-50},{-90,-30}}), iconTransformation(extent={{-110,-10},
            {-90,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_disSupOut(
    redeclare package Medium = Medium,
    m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "Distribution supply outlet port" annotation (Placement(transformation(
          extent={{90,-50},{110,-30}}), iconTransformation(extent={{90,-10},{
            110,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_conSup(
    redeclare package Medium=Medium,
    m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    h_outflow(start = Medium.h_default, nominal = Medium.h_default))
    "Connection supply port"
    annotation (Placement(transformation(
      extent={{-50,110},{-30,130}}), iconTransformation(extent={{-10,90},{10,110}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_conRet(
    redeclare package Medium=Medium,
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    h_outflow(start = Medium.h_default, nominal = Medium.h_default))
    "Connection return port"
    annotation (Placement(transformation(
      extent={{30,110},{50,130}}),
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
  BaseClasses.Junction junConSup(
    redeclare final package Medium=Medium,
    portFlowDirection_1=Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    m_flow_nominal={mDis_flow_nominal,-mDis_flow_nominal,-mCon_flow_nominal})
    "Junction with connection supply"
    annotation (Placement(transformation(extent={{-50,-30},{-30,-50}})));
  BaseClasses.Junction junConRet(
    redeclare final package Medium=Medium,
    portFlowDirection_1=Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=Modelica.Fluid.Types.PortFlowDirection.Entering,
    m_flow_nominal={mDis_flow_nominal,-mDis_flow_nominal,mCon_flow_nominal})
    "Junction with connection return"
    annotation (Placement(transformation(extent={{50,-70},{30,-90}})));
  replaceable PipeDistribution pipDisSup(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mDis_flow_nominal,
    dh=dhDis,
    length=lDis) "Distribution supply pipe"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  replaceable PipeConnection pipCon(
    redeclare package Medium=Medium,
    m_flow_nominal=mCon_flow_nominal,
    length=2*lCon,
    dh=dhCon)
    "Connection pipe"
    annotation (Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=90,
      origin={-40,-10})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTConSup(
    allowFlowReversal=allowFlowReversal,
    redeclare final package Medium=Medium,
    m_flow_nominal=mCon_flow_nominal)
    "Connection supply temperature (measured)"
    annotation (Placement(transformation(
      extent={{10,10},{-10,-10}},
      rotation=-90,
      origin={-40,80})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTConRet(
    allowFlowReversal=allowFlowReversal,
    redeclare final package Medium=Medium,
    m_flow_nominal=mCon_flow_nominal)
    "Connection return temperature (measured)"
    annotation (Placement(transformation(
      extent={{-10,10},{10,-10}},
      rotation=-90,
      origin={40,80})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFloCon(
    redeclare package Medium=Medium,
    allowFlowReversal=allowFlowReversal)
    "Connection supply mass flow rate (measured)"
    annotation (Placement(
      transformation(
      extent={{-10,10},{10,-10}},
      rotation=90,
      origin={-40,40})));
  Modelica.Blocks.Sources.RealExpression QCal_flow(
    y=(senTConSup.T - senTConRet.T) * cp_default * senMasFloCon.m_flow)
    "Calculation of heat flow rate transferred to the load"
    annotation (Placement(transformation(extent={{60,70},{80,90}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_disRetInl(
    redeclare package Medium = Medium,
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "Distribution return inlet port" annotation (Placement(transformation(
          extent={{90,-90},{110,-70}}), iconTransformation(extent={{90,-70},{
            110,-50}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_disRetOut(
    redeclare package Medium = Medium,
    m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "Distribution return outlet port" annotation (Placement(transformation(
          extent={{-110,-90},{-90,-70}}), iconTransformation(extent={{-110,-70},
            {-90,-50}})));
  replaceable PipeDistribution pipDisRet(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mDis_flow_nominal,
    dh=dhDis,
    length=lDis) "Distribution return pipe"
    annotation (Placement(transformation(extent={{-60,-90},{-80,-70}})));
protected
  parameter Modelica.SIunits.SpecificHeatCapacity cp_default=
    Medium.specificHeatCapacityCp(Medium.setState_pTX(
      p = Medium.p_default,
      T = Medium.T_default,
      X = Medium.X_default))
    "Specific heat capacity of medium at default medium state";
equation
  connect(junConSup.port_3, pipCon.port_a)
    annotation (Line(points={{-40,-30},{-40,-20}}, color={0,127,255}));
  connect(pipDisSup.port_b, junConSup.port_1)
    annotation (Line(points={{-60,-40},{-50,-40}}, color={0,127,255}));
  connect(port_conSup,senTConSup. port_b)
    annotation (Line(points={{-40,120},{-40,90}}, color={0,127,255}));
  connect(junConRet.port_3, senTConRet.port_b)
    annotation (Line(points={{40,-70},{40,70}}, color={0,127,255}));
  connect(senTConRet.port_a, port_conRet)
    annotation (Line(points={{40,90},{40,120}}, color={0,127,255}));
  connect(senMasFloCon.port_b,senTConSup. port_a)
    annotation (Line(points={{-40,50},{-40,70}}, color={0,127,255}));
  connect(senMasFloCon.m_flow, mCon_flow)
    annotation (Line(points={{-29,40},{120,40}}, color={0,0,127}));
  connect(pipCon.port_b, senMasFloCon.port_a)
    annotation (Line(points={{-40,0},{-40,30}}, color={0,127,255}));
  connect(QCal_flow.y, Q_flow)
    annotation (Line(points={{81,80},{120,80}}, color={0,0,127}));
  connect(port_disSupInl, pipDisSup.port_a)
    annotation (Line(points={{-100,-40},{-80,-40}}, color={0,127,255}));
  if haveBypFloSen then
  else
  end if;
  connect(port_disRetInl, junConRet.port_1)
    annotation (Line(points={{100,-80},{50,-80}}, color={0,127,255}));
  connect(junConSup.port_2, port_disSupOut)
    annotation (Line(points={{-30,-40},{100,-40}}, color={0,127,255}));
  connect(junConRet.port_2, pipDisRet.port_a)
    annotation (Line(points={{30,-80},{-60,-80}}, color={0,127,255}));
  connect(pipDisRet.port_b, port_disRetOut)
    annotation (Line(points={{-80,-80},{-100,-80}}, color={0,127,255}));
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
          rotation=90)}),       Diagram(coordinateSystem(extent={{-100,-100},{
            100,120}})));
end ConnectionParallel;
