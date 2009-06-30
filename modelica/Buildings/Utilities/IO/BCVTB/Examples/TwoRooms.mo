within Buildings.Utilities.IO.BCVTB.Examples;
model TwoRooms
  "Thermal model of two rooms that will be linked to Ptolemy which models the controls"
  import Buildings;
  parameter Modelica.SIunits.Time tau = 2*3600 "Room time constant";
  parameter Modelica.SIunits.HeatFlowRate Q_flow_nom = 100 "Nominal heat flow";
  parameter Modelica.SIunits.ThermalConductance UA = Q_flow_nom / 20
    "Thermal conductance of room";
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{240,100}}), graphics),
    experiment(StopTime=21600),
    experimentSetupOutput,
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{240,
            100}})),
    Documentation(info="<html>
This example illustrates the use of Modelica with the Building Controls Virtual Test Bed.
Given a control signal for two heat flow rates, Modelica simulates the thermal response 
of two first order systems. The two systems may represent a first order approximation of a room.
The control signal for the heat flow rate is computed in the Building Controls Virtual Test Bed
using a discrete time implementation of a proportional controller.
This model is implemented in <tt>bcvtb\\examples\\roomPtDymola</tt>.
Every 60 seconds, measured temperatures and control signals for the heat flow rates are
exchanged between Dymola and the Building Controls Virtual Test Bed.
</html>"));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor C1(C=tau*UA, T(start=
          283.15)) "Heat capacity of room" 
    annotation (Placement(transformation(extent={{70,70},{90,90}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor UA1(G=UA)
    "Heat transmission of room" 
    annotation (Placement(transformation(extent={{40,60},{60,80}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature TOut1(T=278.15)
    "Outside air temperature" 
    annotation (Placement(transformation(extent={{0,60},{20,80}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow Q_flow_1
    "Heat input into the room" 
    annotation (Placement(transformation(extent={{42,20},{62,40}})));
  Modelica.Blocks.Math.Gain GaiQ_flow_nom1(k=Q_flow_nom)
    "Gain for nominal heat load" 
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor UA2(G=UA)
    "Heat transmission of room" 
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor C2(C=2*tau*UA, T(start=
         283.15)) "Heat capacity of room" 
    annotation (Placement(transformation(extent={{70,-28},{90,-8}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature TOut2(T=278.15)
    "Outside air temperature" 
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow Q_flow_2
    "Heat input into the room" 
    annotation (Placement(transformation(extent={{44,-80},{64,-60}})));
  Modelica.Blocks.Math.Gain GaiQ_flow_nom2(k=Q_flow_nom)
    "Gain for nominal heat load" 
    annotation (Placement(transformation(extent={{2,-80},{22,-60}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TRoo1
    "Room temperature" 
    annotation (Placement(transformation(extent={{92,60},{112,80}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TRoo2
    "Room temperature" 
    annotation (Placement(transformation(extent={{90,-40},{110,-20}})));
  Buildings.Utilities.IO.BCVTB.BCVTB bcvtb(
    samplePeriod=60,
    nDblWri=2,
    nDblRea=2,
    xmlFileName="socket.cfg") 
    annotation (Placement(transformation(extent={{-80,-16},{-60,4}})));
  Modelica.Blocks.Routing.Multiplex2 multiplex2_1 
    annotation (Placement(transformation(extent={{200,-10},{220,10}})));
  Modelica.Blocks.Routing.DeMultiplex2 deMultiplex2_1 
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Modelica.Blocks.Math.Add add 
    annotation (Placement(transformation(extent={{160,2},{180,22}})));
  Modelica.Blocks.Math.Add add1 
    annotation (Placement(transformation(extent={{160,-28},{180,-8}})));
  Modelica.Blocks.Sources.Constant uniCon(k=-273.15) "Unit conversion" 
    annotation (Placement(transformation(extent={{120,-10},{140,10}})));
equation
  connect(TOut1.port, UA1.port_a) annotation (Line(
      points={{20,70},{40,70}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(UA1.port_b, C1.port) annotation (Line(
      points={{60,70},{80,70}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TOut2.port, UA2.port_a) annotation (Line(
      points={{20,-30},{40,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(UA2.port_b, C2.port) annotation (Line(
      points={{60,-30},{79,-30},{79,-28},{80,-28}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Q_flow_1.port, C1.port) annotation (Line(
      points={{62,30},{80,30},{80,70}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Q_flow_2.port, C2.port) annotation (Line(
      points={{64,-70},{80,-70},{80,-28}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(C1.port, TRoo1.port) annotation (Line(
      points={{80,70},{92,70}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(C2.port, TRoo2.port) annotation (Line(
      points={{80,-28},{80,-30},{90,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(GaiQ_flow_nom1.y, Q_flow_1.Q_flow) annotation (Line(
      points={{21,30},{42,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(GaiQ_flow_nom2.y, Q_flow_2.Q_flow) annotation (Line(
      points={{23,-70},{44,-70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(bcvtb.yR, deMultiplex2_1.u) annotation (Line(
      points={{-59,0},{-42,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(deMultiplex2_1.y1[1], GaiQ_flow_nom1.u) annotation (Line(
      points={{-19,6},{-11.5,6},{-11.5,30},{-2,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(deMultiplex2_1.y2[1], GaiQ_flow_nom2.u) annotation (Line(
      points={{-19,-6},{-10,-6},{-10,-70},{0,-70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(multiplex2_1.y, bcvtb.uR) annotation (Line(
      points={{221,0},{230,0},{230,-92},{-90,-92},{-90,0},{-82,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(uniCon.y, add.u2) annotation (Line(
      points={{141,0},{150,0},{150,6},{158,6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(uniCon.y, add1.u1) annotation (Line(
      points={{141,0},{150,0},{150,-12},{158,-12}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TRoo1.T, add.u1) annotation (Line(
      points={{112,70},{128,70},{128,18},{158,18}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TRoo2.T, add1.u2) annotation (Line(
      points={{110,-30},{128,-30},{128,-24},{158,-24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(add1.y, multiplex2_1.u2[1]) annotation (Line(
      points={{181,-18},{189.5,-18},{189.5,-6},{198,-6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(add.y, multiplex2_1.u1[1]) annotation (Line(
      points={{181,12},{190,12},{190,6},{198,6}},
      color={0,0,127},
      smooth=Smooth.None));
end TwoRooms;
