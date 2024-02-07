within Buildings.Examples.VAVReheat.BaseClasses;
model ParallelDXCoilHea "Model for parallel DX coils"
  extends Buildings.Examples.VAVReheat.BaseClasses.PartialParallelDXCoiInterface;

  parameter Integer nCoiHea(min=1) = 3
    "Number of DX heating coils"
    annotation (Dialog(group="Parameters"));

  parameter Modelica.Units.SI.PressureDifference dpDXCoi_nominal=50
    "Pressure drop at mAir_flow_nominal for DX coils";

  replaceable parameter Buildings.Fluid.DXSystems.Heating.AirSource.Data.Generic.DXCoil datHeaCoi
    "Performance data of DX heating coil"
    annotation (Placement(transformation(extent={{58,72},{78,92}})));

  Buildings.Fluid.DXSystems.Heating.AirSource.SingleSpeed HeaCoi[nCoiHea](
    redeclare each final package Medium = Medium,
    each final dp_nominal=dpDXCoi_nominal,
    each final datCoi=datHeaCoi,
    each final T_start=datHeaCoi.sta[1].nomVal.TConIn_nominal,
    each final show_T=true,
    each final from_dp=true,
    each final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    each final dTHys=1e-6)
    "Single speed DX heating coil"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToReaOn[nCoiHea]
    "Convert Boolean enable signal to Real value 1, disable to Real value 0"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));

  Modelica.Blocks.Interfaces.BooleanInput on[nCoiHea]
    "Set to true to enable compressor, or false to disable compressor"
    annotation (Placement(transformation(extent={{-120,70},{-100,90}}),
      iconTransformation(extent={{-120,70},{-100,90}})));

  Modelica.Blocks.Interfaces.RealInput TOut(
    final unit="K",
    displayUnit="degC")
    "Outside air dry bulb temperature for an air cooled condenser or wetbulb temperature for an evaporative cooled condenser"
    annotation (Placement(transformation(extent={{-120,-90},{-100,-70}}),
      iconTransformation(extent={{-120,-50},{-100,-30}})));

  Modelica.Blocks.Interfaces.RealInput phi(
    final unit="1")
    "Outdoor air relative humidity at evaporator inlet (0...1)"
    annotation (Placement(transformation(extent={{-120,-50},{-100,-30}}),
      iconTransformation(extent={{-120,-90},{-100,-70}})));

  Modelica.Blocks.Interfaces.RealOutput P[nCoiHea](
    each final quantity="Power",
    each final unit="W")
    "Electrical power consumed"
    annotation (Placement(transformation(extent={{100,-90},{120,-70}}),
      iconTransformation(extent={{100,-90},{120,-70}})));

  Modelica.Blocks.Interfaces.RealOutput QSen_flow[nCoiHea](
    each final quantity="Power",
    each final unit="W")
    "Sensible heat flow rate"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}}),
      iconTransformation(extent={{100,-50},{120,-30}})));

  Fluid.Sensors.TemperatureTwoPort TSupHeaCoi[nCoiHea](
    redeclare package Medium = Medium,
    each m_flow_nominal=mAir_flow_nominal,
    each allowFlowReversal=allowFlowReversal)
    "Coil outlet air temperature sensor"
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TAirSupCoi[nCoiHea](
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Supply air temperature at DX cooling coil outlet"
    annotation (Placement(transformation(extent={{100,50},{120,70}}),
      iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Fluid.Actuators.Dampers.PressureIndependent damPreInd[nCoiHea](
    redeclare package Medium = Medium,
    each final m_flow_nominal=mAir_flow_nominal,
    each final dpDamper_nominal=dpDamper_nominal,
    each final dpFixed_nominal=dpFixed_nominal)
    "Damper for controlling airflow passing through DX coils"
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));

equation
  connect(on,booToReaOn. u)
    annotation (Line(points={{-110,80},{-82,80}}, color={255,0,255}));

  connect(on, HeaCoi.on) annotation (Line(points={{-110,80},{-90,80},{-90,54},{-16,
          54},{-16,-8},{-11,-8}}, color={255,0,255}));

  connect(booToReaOn.y, damPreInd.y)
    annotation (Line(points={{-58,80},{-40,80},{-40,12}}, color={0,0,127}));

  for i in 1:nCoiHea loop
  connect(phi, HeaCoi[i].phi) annotation (Line(points={{-110,-40},{-24,-40},{-24,
          8},{-11,8}},   color={0,0,127}));

  connect(TOut, HeaCoi[i].TOut) annotation (Line(points={{-110,-80},{-20,-80},{-20,
          4},{-11,4}},   color={0,0,127}));

  connect(TSupHeaCoi[i].port_b, splRetOut1.port_1)
    annotation (Line(points={{50,0},{60,0}}, color={0,127,255}));

  connect(splRetOut.port_2, damPreInd[i].port_a)
    annotation (Line(points={{-60,0},{-50,0}}, color={0,127,255}));
  end for;

  connect(HeaCoi.QSen_flow,QSen_flow)  annotation (Line(points={{11,-7},{20,-7},
          {20,-40},{110,-40}}, color={0,0,127}));

  connect(HeaCoi.P,P)  annotation (Line(points={{11,-9},{16,-9},{16,-80},{110,-80}},
        color={0,0,127}));

  connect(HeaCoi.port_b, TSupHeaCoi.port_a)
    annotation (Line(points={{10,0},{30,0}}, color={0,127,255}));

  connect(TSupHeaCoi.T, TAirSupCoi)
    annotation (Line(points={{40,11},{40,60},{110,60}}, color={0,0,127}));

  connect(damPreInd.port_b, HeaCoi.port_a)
    annotation (Line(points={{-30,0},{-10,0}}, color={0,127,255}));

  annotation (Icon(graphics={
        Rectangle(
          extent={{-70,60},{70,-60}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-101,5},{100,-4}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{0,-4},{100,5}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-80,80},{80,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
          Text(
          extent={{78,-54},{106,-74}},
          textColor={0,0,127},
          textString="P"),
          Text(
          extent={{-138,-52},{-80,-70}},
          textColor={0,0,127},
          textString="phi"),
          Text(
          extent={{-136,-12},{-82,-30}},
          textColor={0,0,127},
          textString="TOut"),
        Rectangle(
          extent={{-38,-12},{-34,-52}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-36,0},{-46,-12},{-26,-12},{-36,0}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-36,0},{-46,10},{-26,10},{-36,0}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-38,50},{-34,10}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{28,50},{32,-52}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-72,68},{70,50}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{8,22},{52,-20}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{30,22},{12,-10},{48,-10},{30,22}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-27,-5},{27,5}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          origin={63,23},
          rotation=90),
        Rectangle(
          extent={{58,-4},{86,5}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-94,-4},{-66,5}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-27,-5},{27,5}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          origin={-65,23},
          rotation=90),
        Rectangle(
          extent={{-72,-52},{70,-70}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
          Text(
          extent={{82,-12},{122,-30}},
          textColor={0,0,127},
          textString="QSen"),
          Line(points={{-120,80},{-90,80},
            {-90,23.8672},{-4,24},{-4,2.0215},{8,2}},
            color={217,67,180}),
          Text(
          extent={{-120,110},{-98,88}},
          textColor={0,0,255},
          textString="on"),
          Text(
          extent={{80,90},{150,66}},
          textColor={0,0,127},
          textString="TAirSupCoi")}));
end ParallelDXCoilHea;
