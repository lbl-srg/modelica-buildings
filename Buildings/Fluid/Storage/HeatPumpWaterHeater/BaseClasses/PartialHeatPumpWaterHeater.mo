within Buildings.Fluid.Storage.HeatPumpWaterHeater.BaseClasses;
partial model PartialHeatPumpWaterHeater
  "Partial heat pump water heater model for wrapped and pumped configuration"
  extends Buildings.Fluid.Interfaces.PartialFourPortInterface(
  final m1_flow_nominal=mAir_flow_nominal,
  final m2_flow_nominal=mWat_flow_nominal,
  redeclare package Medium1 = MediumAir,
  redeclare package Medium2 = MediumTan);

  package MediumAir = Buildings.Media.Air "Medium in the air";

  package MediumTan = Buildings.Media.Water "Medium in the tank";

  parameter Modelica.Units.SI.MassFlowRate mAir_flow_nominal
    "Nominal mass flow rate of air"
    annotation(Dialog(group="Nominal conditions"));

  parameter Modelica.Units.SI.MassFlowRate mWat_flow_nominal
    "Nominal mass flow rate of domestic hot water"
    annotation(Dialog(group="Nominal conditions"));

  parameter Modelica.Units.SI.PressureDifference dpAir_nominal
    "Total pressure difference across supply and return ports in airloop"
    annotation(Dialog(group="Nominal conditions"));

  Modelica.Blocks.Math.BooleanToReal yMov
    "Boolean to real for fan signal"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heaPorBot
    "Heat port tank bottom (outside insulation)"
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}}),
      iconTransformation(extent={{-10,-90},{10,-70}})));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heaPorSid
    "Heat port tank side (outside insulation)"
    annotation (Placement(transformation(extent={{90,-30},{110,-10}}),
      iconTransformation(extent={{50,-10},{70,10}})));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heaPorTop
    "Heat port tank top (outside insulation)"
    annotation (Placement(transformation(extent={{-10,90},{10,110}}),
      iconTransformation(extent={{-10,70},{10,90}})));

  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TSen
    "Temperature tank sensor"
    annotation (Placement(transformation(extent={{70,-50},{90,-30}})));

  Modelica.Blocks.Math.Gain gai_mAir_flow(k=mAir_flow_nominal)
    "Nominal mass flow rate"
    annotation (Placement(transformation(extent={{10,70},{30,90}})));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heaPorVol[datHPWH.datTanWat.nSeg]
    "Heat port that connects to the control volumes of the tank"
    annotation (Placement(transformation(extent={{-110,-30},{-90,-10}}),
      iconTransformation(extent={{-10,-10},{10,10}})));

  replaceable Buildings.Fluid.Storage.StratifiedEnhanced tan(
    redeclare package Medium = MediumTan,
    m_flow_nominal=mWat_flow_nominal,
    VTan=datHPWH.datTanWat.VTan,
    hTan=datHPWH.datTanWat.hTan,
    dIns=datHPWH.datTanWat.dIns,
    kIns=datHPWH.datTanWat.kIns,
    nSeg=datHPWH.datTanWat.nSeg)
    "Water tank"
    annotation(Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={40,-30})));

  Buildings.Fluid.Movers.FlowControlled_m_flow fan(
    redeclare package Medium = MediumAir,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    per=datHPWH.datFan,
    m_flow_nominal=mAir_flow_nominal,
    dp_nominal=dpAir_nominal)
    annotation (Placement(transformation(extent={{30,50},{50,70}})));

  replaceable Buildings.Fluid.Storage.HeatPumpWaterHeater.Data.WrappedCondenser datHPWH
    constrainedby Buildings.Fluid.Storage.HeatPumpWaterHeater.Data.WrappedCondenser
    "Data record for system components"
    annotation (Placement(transformation(extent={{70,72},{90,92}})),
      choicesAllMatching=true);

    //--inputs--//
  Modelica.Blocks.Interfaces.BooleanInput on
    "Heat pump water heater on/off signal" annotation (Placement(transformation(extent={{-140,60},
            {-100,100}}), iconTransformation(extent={{-140,-20},{-100,20}})));

  //--outputs--//

  Modelica.Blocks.Interfaces.RealOutput TWat(
    final unit="K",
    displayUnit="degC") "Absolute temperature as output signal"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}}),
        iconTransformation(extent={{100,-20},{120,0}})));

  Modelica.Blocks.Interfaces.RealOutput P(
    final quantity="Power",
    final unit="W")
    "Electrical power consumed by the unit"
    annotation (Placement(transformation(extent={{100,10},{120,30}}),
        iconTransformation(extent={{100,-50},{120,-30}})));

equation
  connect(fan.port_b, port_b1)
    annotation (Line(points={{50,60},{100,60}}, color={0,127,255}));

  connect(port_a2, tan.port_b)
    annotation (Line(points={{100,-60},{40,-60},{40,-40}}, color={0,127,255}));

  connect(tan.port_a, port_b2)
    annotation (Line(points={{40,-20},{40,-10},{-80,-10},{-80,-60},{-100,-60}}, color={0,127,255}));

  connect(TSen.port, tan.heaPorVol[datHPWH.datTanWat.segTemSen])
    annotation (Line(points={{70,-40},{70,-54},{20,-54},{20,-30},{40,-30}},
                                                                    color={191,0,0}));

  connect(tan.heaPorBot, heaPorBot)
    annotation (Line(points={{42,-37.4},{42,-86},{0,-86},{0,-100}},   color={191,0,0}));

  connect(tan.heaPorSid, heaPorSid)
    annotation (Line(points={{45.6,-30},{66,-30},{66,-20},{100,-20}},
                                                                 color={191,0,0}));

  connect(tan.heaPorTop, heaPorTop)
    annotation (Line(points={{42,-22.6},{42,20},{0,20},{0,100}},color={191,0,0}));

  connect(yMov.y, gai_mAir_flow.u)
    annotation (Line(points={{-59,80},{8,80}},     color={0,0,127}));

  connect(gai_mAir_flow.y, fan.m_flow_in)
    annotation (Line(points={{31,80},{40,80},{40,72}},                    color={0,0,127}));

  connect(TSen.T, TWat)
    annotation (Line(points={{91,-40},{110,-40}},                     color={0,0,127}));

  connect(on, yMov.u)
    annotation (Line(points={{-120,80},{-82,80}},                color={255,0,255}));

  connect(port_b2, port_b2)
    annotation (Line(points={{-100,-60},{-92,-60},{-92,-60},{-100,-60}}, color={0,127,255}));

  connect(heaPorTop, heaPorTop)
    annotation (Line(points={{0,100},{0,100}},
                                             color={191,0,0}));

  connect(tan.heaPorVol, heaPorVol)
    annotation (Line(points={{40,-30},{20,-30},{20,-20},{-100,-20}},
                                                              color={191,0,0}));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}),                                                                                                              graphics={
        Rectangle(extent={{-40,60},{40,20}},lineColor={255,0,0},fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(extent={{-40,-20},{40,-60}},lineColor={0,0,255},pattern=LinePattern.None,fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(extent={{-40,20},{40,-20}},lineColor={255,0,0}, pattern=LinePattern.None,fillColor={0,0,127},
          fillPattern=FillPattern.CrossDiag),
        Rectangle(extent={{-10,10},{10,-10}},lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,fillColor={255,255,255}),
        Rectangle(extent={{50,68},{40,-66}},lineColor={0,0,255},pattern=LinePattern.None,fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Rectangle(extent={{-40,66},{-50,-68}},lineColor={0,0,255},pattern=LinePattern.None,fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Rectangle(extent={{-48,68},{50,60}},lineColor={0,0,255},pattern=LinePattern.None,fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Rectangle(extent={{-48,-60},{50,-68}},lineColor={0,0,255},pattern=LinePattern.None,fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Rectangle(extent={{-40,20},{40,-20}},lineColor={0,0,255},pattern=LinePattern.None,fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(extent={{-10,10},{10,-10}},lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,fillColor={255,255,255}),
        Rectangle(extent={{-40,68},{-50,-66}},lineColor={0,0,255},pattern=LinePattern.None,fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Rectangle(extent={{50,68},{40,-66}},lineColor={0,0,255},pattern=LinePattern.None,fillColor={255,255,0},
          fillPattern=FillPattern.Solid)}),                      Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
                                                                                   experiment(StopTime=10800,Tolerance=1e-05,
      __Dymola_Algorithm="Cvode"),
    Documentation(
    info="<html>
    <p>
    This partial model is the base class for
    <a href=\"Buildings.Fluid.Storage.HeatPumpWaterHeater.WrappedCondenser\">
    Buildings.Fluid.Storage.HeatPumpWaterHeater.WrappedCondenser</a> and
    <a href=\"Buildings.Fluid.Storage.HeatPumpWaterHeater.PumpedCondenser\">
    Buildings.Fluid.Storage.HeatPumpWaterHeater.PumpedCondenser</a>.
    </p>
    </html>", revisions="<html>
<ul>
    <li>
    September 24, 2024 by Xing Lu, Karthik Devaprasad and Cerrina Mouchref:</br>
    First implementation.
    </li>
    </ul>
</html>"));
end PartialHeatPumpWaterHeater;
