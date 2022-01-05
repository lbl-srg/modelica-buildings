within Buildings.Examples.VAVReheat.BaseClasses.Controls.Examples;
model OperationModes "Test model for operation modes"
    extends Modelica.Icons.Example;

  Buildings.Examples.VAVReheat.BaseClasses.Controls.ModeSelector operationModes
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow preHeaFlo
    annotation (Placement(transformation(extent={{90,-60},{110,-40}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixTem(T=273.15)
    annotation (Placement(transformation(extent={{-40,90},{-20,110}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor cap(C=20000, T(fixed=
          true))
    annotation (Placement(transformation(extent={{40,100},{60,120}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor con(G=1)
    annotation (Placement(transformation(extent={{0,90},{20,110}})));
  Modelica.Blocks.Logical.Switch switch1
    annotation (Placement(transformation(extent={{60,-60},{80,-40}})));
  Modelica.Blocks.Sources.Constant on(k=200)
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
  Modelica.Blocks.Sources.Constant off(k=0)
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temperatureSensor
    annotation (Placement(transformation(extent={{100,110},{120,130}})));
  Modelica.Blocks.Sources.RealExpression TRooSetHea(
    y=if mode.y == Integer(Buildings.Examples.VAVReheat.BaseClasses.Controls.OperationModes.occupied)
      then 293.15 else 287.15)
    annotation (Placement(transformation(extent={{-160,40},{-140,60}})));
  Modelica.Blocks.Sources.Constant TCoiHea(k=283.15)
    "Temperature after heating coil"
    annotation (Placement(transformation(extent={{-160,-40},{-140,-20}})));
  Buildings.Examples.VAVReheat.BaseClasses.Controls.ControlBus controlBus
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  Modelica.Blocks.Routing.IntegerPassThrough mode "Outputs the control mode"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Modelica.Blocks.Sources.BooleanExpression modSel(
    y=mode.y == Integer(Buildings.Examples.VAVReheat.BaseClasses.Controls.OperationModes.unoccupiedNightSetBack) or
      mode.y == Integer(Buildings.Examples.VAVReheat.BaseClasses.Controls.OperationModes.unoccupiedWarmUp))
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
  Modelica.Blocks.Sources.Constant TOut(k=283.15) "Outside temperature"
    annotation (Placement(transformation(extent={{-160,-80},{-140,-60}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temperatureSensor1
    annotation (Placement(transformation(extent={{100,142},{120,162}})));
  Modelica.Blocks.Sources.BooleanExpression modSel1(
    y=mode.y == Integer(Buildings.Examples.VAVReheat.BaseClasses.Controls.OperationModes.occupied))
    annotation (Placement(transformation(extent={{-20,-130},{0,-110}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow preHeaFlo1
    annotation (Placement(transformation(extent={{112,-130},{132,-110}})));
  Buildings.Controls.Continuous.LimPID PID(initType=Modelica.Blocks.Types.Init.InitialState)
    annotation (Placement(transformation(extent={{-80,-130},{-60,-110}})));
  Modelica.Blocks.Logical.Switch switch2
    annotation (Placement(transformation(extent={{20,-130},{40,-110}})));
  Modelica.Blocks.Math.Gain gain(k=200)
    annotation (Placement(transformation(extent={{62,-130},{82,-110}})));
  Buildings.Controls.SetPoints.OccupancySchedule occSch "Occupancy schedule"
    annotation (Placement(transformation(extent={{-160,80},{-140,100}})));
equation
  connect(fixTem.port, con.port_a) annotation (Line(
      points={{-20,100},{0,100}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(preHeaFlo.port, cap.port) annotation (Line(
      points={{110,-50},{120,-50},{120,100},{50,100}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(con.port_b, cap.port) annotation (Line(
      points={{20,100},{50,100}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(switch1.y, preHeaFlo.Q_flow) annotation (Line(
      points={{81,-50},{90,-50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(on.y, switch1.u1) annotation (Line(
      points={{41,-30},{48,-30},{48,-42},{58,-42}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(off.y, switch1.u3) annotation (Line(
      points={{-39,-70},{48,-70},{48,-58},{58,-58}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(cap.port, temperatureSensor.port) annotation (Line(
      points={{50,100},{64,100},{64,120},{100,120}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(controlBus, operationModes.cb) annotation (Line(
      points={{-50,40},{-50,-3.18182},{-36.8182,-3.18182}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(temperatureSensor.T, controlBus.TRooMin) annotation (Line(
      points={{120,120},{166,120},{166,60},{-50,60},{-50,40}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      textString="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(TCoiHea.y, controlBus.TCoiHeaOut) annotation (Line(
      points={{-139,-30},{-78,-30},{-78,40},{-50,40}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      textString="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(controlBus.controlMode, mode.u) annotation (Line(
      points={{-50,40},{-30,40},{-30,30},{-2,30}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      textString="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(modSel.y, switch1.u2) annotation (Line(
      points={{1,-50},{58,-50}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(TOut.y, controlBus.TOut) annotation (Line(
      points={{-139,-70},{-72,-70},{-72,40},{-50,40}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      textString="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(cap.port, temperatureSensor1.port) annotation (Line(
      points={{50,100},{64,100},{64,152},{100,152}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(temperatureSensor1.T, controlBus.TRooAve) annotation (Line(
      points={{120,152},{166,152},{166,60},{-50,60},{-50,40}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      textString="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(TRooSetHea.y, PID.u_s)
                              annotation (Line(
      points={{-139,50},{-110,50},{-110,-120},{-82,-120}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(temperatureSensor.T, PID.u_m) annotation (Line(
      points={{120,120},{166,120},{166,-150},{-70,-150},{-70,-132}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(modSel1.y, switch2.u2) annotation (Line(
      points={{1,-120},{18,-120}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(off.y, switch2.u3) annotation (Line(
      points={{-39,-70},{-30,-70},{-30,-132},{10,-132},{10,-128},{18,-128}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(preHeaFlo1.port, cap.port) annotation (Line(
      points={{132,-120},{148,-120},{148,100},{50,100}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(PID.y, switch2.u1) annotation (Line(
      points={{-59,-120},{-38,-120},{-38,-100},{8,-100},{8,-112},{18,-112}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gain.y, preHeaFlo1.Q_flow) annotation (Line(
      points={{83,-120},{112,-120}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(switch2.y, gain.u) annotation (Line(
      points={{41,-120},{60,-120}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(occSch.tNexOcc, controlBus.dTNexOcc) annotation (Line(
      points={{-139,96},{-50,96},{-50,40}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      textString="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(TRooSetHea.y, controlBus.TRooSetHea) annotation (Line(
      points={{-139,50},{-100,50},{-100,40},{-50,40}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      textString="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(occSch.occupied, controlBus.occupied) annotation (Line(
      points={{-139,84},{-50,84},{-50,40}},
      color={255,0,255},
      smooth=Smooth.None), Text(
      textString="%second",
      index=1,
      extent={{6,3},{6,3}}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-200,
            -200},{200,200}})),
        __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Examples/VAVReheat/BaseClasses/Controls/Examples/OperationModes.mos"
        "Simulate and plot"),
    experiment(
      StopTime=172800,
      Tolerance=1e-6),
    Documentation(info="<html>
<p>
This model tests the transition between the different modes of operation of the HVAC system.
</p>
</html>"));
end OperationModes;
