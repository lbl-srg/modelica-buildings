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

  replaceable parameter Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.DXCoil datCoi(nSta=1)
    "Water heating coil data"
    annotation (Placement(transformation(extent={{52,20},{72,40}})));

  replaceable parameter Buildings.Fluid.Storage.HeatPumpWaterHeater.Data.WaterHeaterData
    datWT "Water tank data"
    annotation (Placement(transformation(extent={{80,20},{100,40}})));

  replaceable parameter Buildings.Fluid.Movers.Data.Generic fanPer
    constrainedby Buildings.Fluid.Movers.Data.Generic
    "Record with performance data for supply fan"
    annotation (choicesAllMatching=true,Placement(transformation(extent={{24,20},{44,40}})),Dialog(group="Fan parameters"));

  Modelica.Blocks.Math.BooleanToReal yMov "Boolean to real for fan signal"
    annotation (Placement(transformation(extent={{-70,20},{-50,40}})));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heaPorBot
    "Heat port tank bottom (outside insulation)"
    annotation (Placement(transformation(extent={{-10,-90},{10,-70}}), iconTransformation(extent={{-10,-90},{10,-70}})));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heaPorSid
    "Heat port tank side (outside insulation)"
    annotation (Placement(transformation(extent={{50,-10},{70,10}}), iconTransformation(extent={{50,-10},{70,10}})));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heaPorTop
    "Heat port tank top (outside insulation)"
    annotation (Placement(transformation(extent={{-10,70},{10,90}}), iconTransformation(extent={{-10,70},{10,90}})));

  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TSen
    "Temperature tank sensor"
    annotation (Placement(transformation(extent={{-30,-56},{-50,-36}})));

  Modelica.Blocks.Math.Gain gai_mAir_flow(k=mAir_flow_nominal)
    "Nominal mass flow rate"
    annotation (Placement(transformation(extent={{-34,26},{-26,34}})));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heaPorVol[datWT.nSeg]
    "Heat port that connects to the control volumes of the tank"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  replaceable Buildings.Fluid.Storage.StratifiedEnhanced tan(
    redeclare package Medium = MediumTan,
      m_flow_nominal=mWat_flow_nominal,
      VTan=datWT.VTan,
      hTan=datWT.hTan,
      dIns=datWT.dIns,
      kIns=datWT.kIns,
      nSeg=datWT.nSeg)
      "Water tank"
      annotation (Placement(transformation( extent={{-10,-10},{10,10}},rotation=0,origin={36,-26})));

  Buildings.Fluid.Movers.FlowControlled_m_flow fan(
    redeclare package Medium = MediumAir,
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      per=fanPer,
      m_flow_nominal=mAir_flow_nominal,
      dp_nominal=dpAir_nominal)
    annotation (Placement(transformation(extent={{24,50},{44,70}})));

    //--inputs--//
  Modelica.Blocks.Interfaces.BooleanInput on
    "Heat pump water heater on/off signal" annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));

  //--outputs--//

  Modelica.Blocks.Interfaces.RealOutput TWat(
    final unit="K",
    displayUnit="degC") "Absolute temperature as output signal"
    annotation (Placement(transformation(extent={{100,-20},{120,0}}),
        iconTransformation(extent={{100,-20},{120,0}})));

  Modelica.Blocks.Interfaces.RealOutput P(
    final quantity="Power",
    final unit="W")
    "Electrical power consumed by the unit"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}})));

equation
  connect(fan.port_b, port_b1)
    annotation (Line(points={{44,60},{100,60}}, color={0,127,255}));

  connect(port_a2, tan.port_b)
    annotation (Line(points={{100,-60},{36,-60},{36,-36}}, color={0,127,255}));

  connect(tan.port_a, port_b2)
    annotation (Line(points={{36,-16},{36,-10},{-80,-10},{-80,-60},{-100,-60}}, color={0,127,255}));

  connect(TSen.port, tan.heaPorVol[datWT.segTemSen])
    annotation (Line(points={{-30,-46},{14,-46},{14,-26},{36,-26}}, color={191,0,0}));

  connect(tan.heaPorBot, heaPorBot)
    annotation (Line(points={{38,-33.4},{32,-33.4},{32,-80},{0,-80}}, color={191,0,0}));

  connect(tan.heaPorSid, heaPorSid)
    annotation (Line(points={{41.6,-26},{70,-26},{70,0},{60,0}}, color={191,0,0}));

  connect(tan.heaPorTop, heaPorTop)
    annotation (Line(points={{38,-18.6},{38,14},{0,14},{0,80}}, color={191,0,0}));

  connect(yMov.y, gai_mAir_flow.u)
    annotation (Line(points={{-49,30},{-34.8,30}}, color={0,0,127}));

  connect(gai_mAir_flow.y, fan.m_flow_in)
    annotation (Line(points={{-25.6,30},{14,30},{14,76},{34,76},{34,72}}, color={0,0,127}));

  connect(TSen.T, TWat)
    annotation (Line(points={{-51,-46},{-70,-46},{-70,-10},{110,-10}},color={0,0,127}));

  connect(on, yMov.u)
    annotation (Line(points={{-120,0},{-86,0},{-86,30},{-72,30}},color={255,0,255}));

  connect(port_b2, port_b2)
    annotation (Line(points={{-100,-60},{-92,-60},{-92,-60},{-100,-60}}, color={0,127,255}));

  connect(heaPorTop, heaPorTop)
    annotation (Line(points={{0,80},{0,80}}, color={191,0,0}));

  connect(tan.heaPorVol, heaPorVol)
    annotation (Line(points={{36,-26},{20,-26},{20,0},{0,0}}, color={191,0,0}));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-80},{100,80}}),                                         graphics={
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
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-80},{100,80}})),experiment(StopTime=10800,Tolerance=1e-05,
      __Dymola_Algorithm="Cvode"),
    Documentation(
    info="<html>
    <p>
    This partial model is the base class for
    <a href=\"Buildings.Fluid.Storage.HeatPumpWaterHeater.HeatPumpWaterHeaterWrapped\">
    Buildings.Fluid.Storage.HeatPumpWaterHeater.HeatPumpWaterHeaterWrapped</a> and
    <a href=\"Buildings.Fluid.Storage.HeatPumpWaterHeater.HeatPumpWaterHeaterPumped\">
    Buildings.Fluid.Storage.HeatPumpWaterHeater.HeatPumpWaterHeaterPumped</a>.
    </p>
    </html>"));
end PartialHeatPumpWaterHeater;
