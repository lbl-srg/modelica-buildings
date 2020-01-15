within Buildings.Applications.DHC.Examples.FifthGeneration.UnidirectionalSeries.Networks;
model UnidirectionalDistributionSeries
  "Partial model for an element for a distribution leg"

  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium "Medium model"
    annotation (__Dymola_choicesAllMatching=true);
  parameter Modelica.SIunits.TemperatureDifference dTHex(min=0)
    "Temperature difference over substation heat exchanger";
  parameter Modelica.SIunits.MassFlowRate mDis_flow_nominal
    "Nominal mass flow rate distribution line";
  parameter Modelica.SIunits.MassFlowRate mSub_flow_nominal
    "Nominal mass flow rate substation line";

  parameter Modelica.SIunits.Length lDis
    "Length of the distribution pipe (only counting warm or cold line, but not sum)";
  parameter Modelica.SIunits.Length lSub
    "Length of the pipe to the substation (only counting warm or cold line, but not sum)";
  parameter Modelica.SIunits.PressureDifference dp_nominal=50000
    "Nominal pressure difference";

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput PPum(unit="W")
    "Electrical power consumed"
    annotation (Placement(transformation(extent={{100,68},{120,88}}),
        iconTransformation(extent={{100,70},{120,90}})));
  Modelica.Fluid.Interfaces.FluidPort_a subSup(
     redeclare final package Medium = Medium) "Substation supply"
    annotation (Placement(transformation(extent={{-30,110},{-10,130}}),
        iconTransformation(extent={{10,90},{30,110}})));
  Modelica.Fluid.Interfaces.FluidPort_b subRet(
    redeclare final package Medium = Medium) "Substation return"
    annotation (Placement(transformation(extent={{10,110},{30,130}}),
        iconTransformation(extent={{50,90},{70,110}})));
  Modelica.Fluid.Interfaces.FluidPort_a disSup_a(
    redeclare final package Medium = Medium) "Distribution supply line"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}}),
        iconTransformation(extent={{-110,-10},{-90,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b disSup_b(
    redeclare final package Medium = Medium) "Distribution return line"
    annotation (Placement(transformation(extent={{90,-10},{110,10}}),
        iconTransformation(extent={{90,-10},{110,10}})));

  Junction junSup(redeclare final package Medium = Medium, m_flow_nominal={
        mDis_flow_nominal,mDis_flow_nominal,mSub_flow_nominal})
    "Junction in supply line"
    annotation (Placement(transformation(extent={{-30,10},{-10,-10}})));

  Junction junRet(redeclare final package Medium = Medium, m_flow_nominal={
        mDis_flow_nominal,mDis_flow_nominal,mSub_flow_nominal})
    "Junction in return line"
    annotation (Placement(transformation(extent={{10,10},{30,-10}})));

  SidewalkQuayside.Distribution.BaseClasses.MainPipe maiPipSup(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mDis_flow_nominal,
    final length=lDis) "Distribution pipe"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  SidewalkQuayside.Distribution.BaseClasses.PipeToSubstation pipToSub(
    redeclare package Medium = Medium,
    m_flow_nominal=mSub_flow_nominal,
    length=2*lSub,
    dh=dhSub) "Pipe to substation" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-20,30})));
  parameter Modelica.SIunits.Length dhSub
    "Hydraulic diameter of pipe to substation";
  Buildings.Fluid.Movers.FlowControlled_m_flow disPum(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    addPowerToMedium=false,
    nominalValuesDefineDefaultPressureCurve=true,
    riseTime=10,
    m_flow_nominal=mSub_flow_nominal,
    per(pressure(dp={2*dp_nominal,0}, V_flow={0,2*mSub_flow_nominal/1000})),
    use_inputFilter=false)
    "Pump (or valve) that forces the flow rate to be set to the control signal"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90, origin={-20,58})));
  Buildings.Fluid.Sensors.TemperatureTwoPort supTem(
    allowFlowReversal=false,
    redeclare final package Medium = Medium,
    m_flow_nominal=mSub_flow_nominal)
    annotation (Placement(transformation(extent={{10,10},{-10,-10}},
        rotation=-90, origin={-20,84})));
  Buildings.Fluid.Sensors.TemperatureTwoPort retTem(
    allowFlowReversal=false,
    redeclare final package Medium = Medium,
    m_flow_nominal=mSub_flow_nominal)
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},
        rotation=-90, origin={20,100})));
  SidewalkQuayside.Distribution.BaseClasses.SubstationPumpControl con(dT=dTHex,
      m_flow_nominal=mSub_flow_nominal)
    annotation (Placement(transformation(extent={{-80,48},{-60,68}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput modInd "Mode index"
    annotation (Placement(transformation(extent={{-140,46},{-100,86}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Modelica.Blocks.Interfaces.RealOutput m_flow(unit="kg/s") "Mass flow rate"
    annotation (Placement(transformation(extent={{100,34},{120,54}}),
        iconTransformation(extent={{100,-70},{120,-50}})));

equation
  connect(disSup_a, maiPipSup.port_a)
    annotation (Line(points={{-100,0},{-80,0}},   color={0,127,255}));
  connect(junSup.port_3, pipToSub.port_a)
    annotation (Line(points={{-20,10},{-20,20}},
                                               color={0,127,255}));
  connect(maiPipSup.port_b, junSup.port_1)
    annotation (Line(points={{-60,0},{-30,0}}, color={0,127,255}));
  connect(junSup.port_2, junRet.port_1)
    annotation (Line(points={{-10,0},{10,0}}, color={0,127,255}));
  connect(junRet.port_2, disSup_b)
    annotation (Line(points={{30,0},{100,0}}, color={0,127,255}));
  connect(disPum.port_a, pipToSub.port_b)
    annotation (Line(points={{-20,48},{-20,40}}, color={0,127,255}));
  connect(subSup, supTem.port_b)
    annotation (Line(points={{-20,120},{-20,94}}, color={0,127,255}));
  connect(supTem.port_a, disPum.port_b)
    annotation (Line(points={{-20,74},{-20,68}}, color={0,127,255}));
  connect(junRet.port_3, retTem.port_b)
    annotation (Line(points={{20,10},{20,90}}, color={0,127,255}));
  connect(retTem.port_a, subRet)
    annotation (Line(points={{20,110},{20,110},{20,120}}, color={0,127,255}));
  connect(con.yPum, disPum.m_flow_in) annotation (Line(points={{-59,58},{-32,58}},
                              color={0,0,127}));
  connect(supTem.T, con.TSup) annotation (Line(points={{-31,84},{-90,84},{-90,58},
          {-82,58}}, color={0,0,127}));
  connect(retTem.T, con.TRet) annotation (Line(points={{9,100},{-94,100},{-94,50},
          {-82,50}}, color={0,0,127}));
  connect(modInd, con.modInd)
    annotation (Line(points={{-120,66},{-82,66}}, color={255,127,0}));
  connect(disPum.m_flow_actual, m_flow) annotation (Line(points={{-25,69},{-25,
          76},{80,76},{80,44},{110,44}}, color={0,0,127}));
  connect(disPum.P, PPum) annotation (Line(
      points={{-29,69},{-29,78},{110,78}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  annotation (Icon(graphics={   Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,2},{90,-2}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{18,2},{22,100}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),           Text(
        extent={{-150,-92},{150,-132}},
        textString="%name",
        lineColor={0,0,255}),
        Rectangle(
          extent={{-74,12},{-18,-12}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-25.5,11.5},{25.5,-11.5}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0},
          origin={19.5,49.5},
          rotation=90),
        Rectangle(
          extent={{58,2},{62,100}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0})}), Diagram(coordinateSystem(extent={{-100,-60},{100,
            120}})));
end UnidirectionalDistributionSeries;
