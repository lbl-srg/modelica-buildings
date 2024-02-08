within Buildings.Examples.VAVReheat.BaseClasses;
model ParallelDXCoilCoo "Model for parallel DX coils"
  extends
    Buildings.Examples.VAVReheat.BaseClasses.PartialParallelDXCoiInterface;

  parameter Integer nCoiCoo(min=1) = 3
    "Number of DX cooling coils"
    annotation (Dialog(group="Parameters"));

  parameter Modelica.Units.SI.PressureDifference dpDXCoi_nominal=50
    "Pressure drop at mAir_flow_nominal for DX coils";

  parameter Real minSpeRat(
    final min=0,
    final max=1)
    "Minimum speed ratio";

  parameter Real speRatDeaBan= 0.05
    "Deadband for minimum speed ratio";

  replaceable parameter Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.DXCoil datCooCoi
    "Performance data of DX heating coil"
    annotation (Placement(transformation(extent={{52,72},{72,92}})));

  Buildings.Fluid.DXSystems.Cooling.AirSource.VariableSpeed CooCoi[nCoiCoo](
    redeclare each final package Medium = Medium,
    each final dp_nominal=dpDXCoi_nominal,
    final datCoi=fill(datCooCoi,nCoiCoo),
    each final minSpeRat=datCooCoi.minSpeRat,
    each final T_start=datCooCoi.sta[1].nomVal.TEvaIn_nominal,
    each final from_dp=true,
    each final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Variable speed DX cooling coil"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToReaOn[nCoiCoo]
    "Convert Boolean enable signal to Real value 1, disable to Real value 0"
    annotation (Placement(transformation(extent={{-10,70},{10,90}})));

  Modelica.Blocks.Interfaces.RealInput TOut(
    final unit="K",
    displayUnit="degC")
    "Outside air dry bulb temperature for an air cooled condenser or wetbulb temperature for an evaporative cooled condenser"
    annotation (Placement(transformation(extent={{-120,-50},{-100,-30}}),
      iconTransformation(extent={{-120,-50},{-100,-30}})));

  Modelica.Blocks.Interfaces.RealInput speRat[nCoiCoo](
    final unit="1",
    displayUnit="1")
    "Speed ratio"
    annotation (Placement(transformation(extent={{-120,-90},{-100,-70}}),
      iconTransformation(extent={{-120,70},{-100,90}})));

  Modelica.Blocks.Interfaces.RealOutput P[nCoiCoo](
    each final quantity="Power",
    each final unit="W")
    "Electrical power consumed"
    annotation (Placement(transformation(extent={{100,-90},{120,-70}}),
      iconTransformation(extent={{100,-90},{120,-70}})));

  Modelica.Blocks.Interfaces.RealOutput QSen_flow[nCoiCoo](
    each final quantity="Power",
    each final unit="W")
    "Sensible heat flow rate"
    annotation (Placement(transformation(extent={{100,-70},{120,-50}}),
      iconTransformation(extent={{100,-30},{120,-10}})));

  Modelica.Blocks.Interfaces.RealOutput QLat_flow[nCoiCoo](
    final quantity="Power",
    final unit="W")
    "Latent heat flow rate"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}}),
      iconTransformation(extent={{100,-60},{120,-40}})));

  Modelica.Blocks.Logical.Hysteresis deaBan[nCoiCoo](
    each final uLow=minSpeRat - speRatDeaBan/2,
    each final uHigh=minSpeRat + speRatDeaBan/2)
    "Speed ratio deadband"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));

  Buildings.Fluid.Actuators.Dampers.PressureIndependent damPreInd[nCoiCoo](
    redeclare package Medium = Medium,
    each final m_flow_nominal=mAir_flow_nominal,
    each final dpDamper_nominal=dpDamper_nominal,
    each final dpFixed_nominal=dpFixed_nominal)
    annotation (Placement(transformation(extent={{-48,-10},{-28,10}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort TSupCooCoi[nCoiCoo](
    redeclare package Medium = Medium,
    each final m_flow_nominal=mAir_flow_nominal,
    each final allowFlowReversal=allowFlowReversal)
    "Coil outlet air temperature sensor"
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TAirSupCoi[nCoiCoo](
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Supply air temperature at DX heating coil outlet"
    annotation (Placement(transformation(extent={{100,50},{120,70}}),
      iconTransformation(extent={{100,40},{140,80}})));

equation
  connect(CooCoi.port_a, damPreInd.port_b)
    annotation (Line(points={{-10,0},{-28,0}}, color={0,127,255}));

  connect(booToReaOn.y, damPreInd.y)
    annotation (Line(points={{12,80},{18,80},{18,18},{-38,18},{-38,12}},
      color={0,0,127}));

  for i in 1:nCoiCoo loop
  connect(CooCoi[i].TOut,TOut)  annotation (Line(points={{-11,-3},{-24,-3},{-24,
          -40},{-110,-40}}, color={0,0,127}));

  connect(damPreInd[i].port_a, splRetOut.port_2)
    annotation (Line(points={{-48,0},{-60,0}}, color={0,127,255}));

  connect(TSupCooCoi[i].port_b, splRetOut1.port_1)
    annotation (Line(points={{50,0},{60,0}}, color={0,127,255}));
  end for;

  connect(CooCoi.QSen_flow,QSen_flow)  annotation (Line(points={{11,-7},{20,-7},
          {20,-60},{110,-60}}, color={0,0,127}));

  connect(CooCoi.P,P)  annotation (Line(points={{11,-9},{16,-9},{16,-80},{110,-80}},
        color={0,0,127}));

  connect(CooCoi.QLat_flow,QLat_flow)  annotation (Line(points={{11,-5},{24,-5},
          {24,-40},{110,-40}}, color={0,0,127}));

  connect(speRat, CooCoi.speRat) annotation (Line(points={{-110,-80},{-20,-80},{
          -20,-8},{-11,-8}}, color={0,0,127}));

  connect(CooCoi.port_b, TSupCooCoi.port_a)
    annotation (Line(points={{10,0},{30,0}}, color={0,127,255}));

  connect(TSupCooCoi.T, TAirSupCoi)
    annotation (Line(points={{40,11},{40,60},{110,60}}, color={0,0,127}));

  connect(deaBan.y, booToReaOn.u)
    annotation (Line(points={{-59,80},{-12,80}}, color={255,0,255}));

  connect(speRat, deaBan.u) annotation (Line(points={{-110,-80},{-20,-80},{-20,60},
          {-88,60},{-88,80},{-82,80}}, color={0,0,127}));

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
          extent={{76,-72},{104,-92}},
          textColor={0,0,127},
          textString="P"),
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
          extent={{-128,110},{-74,92}},
          textColor={0,0,127},
          textString="speRat"), Text(
          extent={{60,-42},{100,-60}},
          textColor={0,0,127},
          textString="QLat"),   Text(
          extent={{58,-10},{98,-28}},
          textColor={0,0,127},
          textString="QSen"),
          Text(
          extent={{80,92},{150,68}},
          textColor={0,0,127},
          textString="TAirSupCoi")}));
end ParallelDXCoilCoo;
