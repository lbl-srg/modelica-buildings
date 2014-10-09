within Buildings.Fluid.HeatExchangers.HeatPumps.AirToAir.BaseClasses;
block HeatMassFlow "Water to air heat flow operation"
  parameter Boolean computeReevaporation=true
    "Set to true to compute reevaporation of water that accumulated on coil";
  final parameter Integer nCooSta=datHP.nCooSta;

  Modelica.Blocks.Interfaces.IntegerInput mode "Mode of operation"
    annotation (Placement(transformation(extent={{-120,90},{-100,110}})));
  Modelica.Blocks.Interfaces.RealInput speRat "Speed ratio"
    annotation (Placement(transformation(extent={{-120,66},{-100,86}})));
  Modelica.Blocks.Interfaces.RealInput m_flow[2] "Air mass flow rate"
     annotation (Placement(transformation(extent={{-120,14},{-100,34}})));

  Modelica.Blocks.Interfaces.RealInput TIn[2](unit="K")
    "Outside air dry bulb temperature for an air cooled condenser or wetbulb temperature for an evaporative cooled condenser"
   annotation (Placement(transformation(extent={{-120,40},{-100,60}},  rotation=0)));
  Modelica.Blocks.Interfaces.RealOutput Q1_flow(unit="W") "Total capacity"
     annotation (Placement(transformation(extent={{100,50},{120,70}})));

  replaceable package Medium1 =
      Modelica.Media.Interfaces.PartialCondensingGases "Medium model"
     annotation (choicesAllMatching=true);

  constant Boolean variableSpeedCoil
    "Flag, set to true for coil with variable speed";

//  replaceable
  parameter Buildings.Fluid.HeatExchangers.HeatPumps.AirToAir.Data.HPData
                                                                  datHP
    "Performance data";

  Modelica.Blocks.Interfaces.RealOutput T1CoiSur(
    quantity="ThermodynamicTemperature",
    unit="K",
    min=240,
    max=400) "Coil surface temperature"
          annotation (Placement(transformation(extent={{100,30},{120,50}})));

  Modelica.Blocks.Interfaces.RealOutput m1Wat_flow(quantity="MassFlowRate",
      unit="kg/s") "Mass flow rate of water condensed at cooling coil"
    annotation (Placement(transformation(extent={{100,10},{120,30}})));
  Modelica.Blocks.Interfaces.RealInput X1In "Inlet air mass fraction"
    annotation (Placement(transformation(extent={{-120,-60},{-100,-40}})));
  Modelica.Blocks.Interfaces.RealInput p "Pressure at inlet of coil"
    annotation (Placement(transformation(extent={{-120,-34},{-100,-14}})));
  Modelica.Blocks.Interfaces.RealInput h1In
    "Specific enthalpy of air entering the coil"
            annotation (Placement(transformation(extent={{-120,-87},{-100,-67}})));
  Modelica.Blocks.Interfaces.RealOutput Q2_flow(unit="W") "Total capacity"
     annotation (Placement(transformation(extent={{100,-90},{120,-70}})));
  Modelica.Blocks.Interfaces.RealOutput P(
    quantity="Power",
    unit="W") "Electrical power consumed by the unit"
    annotation (Placement(transformation(extent={{100,70},{120,90}}, rotation=
            0)));
  Buildings.Fluid.HeatExchangers.HeatPumps.AirToAir.BaseClasses.HeatFlow heaFlo(
    redeclare package Medium1 = Medium1,
    variableSpeedCoil=true,
    datHP=datHP)
           annotation (Placement(transformation(extent={{-20,40},{0,60}})));
   Buildings.Fluid.HeatExchangers.HeatPumps.AirToAir.BaseClasses.Evaporation eva(
     redeclare final package Medium = Medium1,
    final computeReevaporation = computeReevaporation,
    datHP=datHP,
    m_flow_nominal=datHP.cooSta[nCooSta].nomVal.m1_flow_nominal,
    SHR_nominal=datHP.cooSta[nCooSta].nomVal.SHR_nominal,
    Q_flow_nominal=datHP.cooSta[nCooSta].nomVal.Q_flow_nominal,
    m(start=mSta))
    "Model that computes evaporation of water that accumulated on the coil surface"
    annotation (Placement(transformation(extent={{56,86},{70,100}})));
 //   redeclare Buildings.Fluid.HeatExchangers.HeatPumps.AirToAir.Data.HPData datHP=datHP,
  Modelica.Blocks.Math.IntegerToBoolean onSwi(final threshold=2)
    "On/off switch"
    annotation (Placement(transformation(extent={{-54,80},{-42,92}})));
  Modelica.Blocks.Interfaces.RealInput X1Out(
    min=0,
    max=1,
    unit="1") "Water mass fraction"
    annotation (Placement(transformation(extent={{11,-11},{-11,11}},
        rotation=90, origin={19,111})));
  Modelica.Blocks.Interfaces.RealInput T1Out(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC") "Air temperature"
    annotation (Placement(transformation(extent={{11,-11},{-11,11}},
        rotation=90,
        origin={-19,111})));
  parameter Modelica.SIunits.Mass mSta= 0
    "Mass of water accumulated on the coil at time = 0"
  annotation (Dialog(group="Initial condition"));
equation
  connect(onSwi.y, eva.on) annotation (Line(
      points={{-41.4,86},{26,86},{26,98.6},{54.6,98.6}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(mode, onSwi.u) annotation (Line(
      points={{-110,100},{-66,100},{-66,86},{-55.2,86}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(m_flow[1], eva.mAir_flow) annotation (Line(
      points={{-110,19},{42,19},{42,87.4},{54.6,87.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heaFlo.m1Wat_flow, eva.mWat_flow) annotation (Line(
      points={{1,50},{30,50},{30,95.8},{54.6,95.8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heaFlo.T1CoiSur, eva.TWat) annotation (Line(
      points={{1,52},{36,52},{36,91.6},{54.6,91.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(X1Out, eva.XOut) annotation (Line(
      points={{19,111},{19,80},{58.8,80},{58.8,84.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T1Out, eva.TOut) annotation (Line(
      points={{-19,111},{-19,76},{67.2,76},{67.2,84.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mode, heaFlo.mode) annotation (Line(
      points={{-110,100},{-66,100},{-66,60},{-21,60}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(speRat, heaFlo.speRat) annotation (Line(
      points={{-110,76},{-70,76},{-70,57.6},{-21,57.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TIn, heaFlo.T) annotation (Line(
      points={{-110,50},{-66,50},{-66,55},{-21,55}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(m_flow, heaFlo.m_flow) annotation (Line(
      points={{-110,24},{-62,24},{-62,52.4},{-21,52.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(p, heaFlo.p) annotation (Line(
      points={{-110,-24},{-58,-24},{-58,47.6},{-21,47.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(X1In, heaFlo.X1In) annotation (Line(
      points={{-110,-50},{-54,-50},{-54,45},{-21,45}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(h1In, heaFlo.h1In) annotation (Line(
      points={{-110,-77},{-48,-77},{-48,42.3},{-21,42.3}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heaFlo.P, P) annotation (Line(
      points={{1,58},{88,58},{88,80},{110,80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(eva.mTotWat_flow, m1Wat_flow) annotation (Line(
      points={{70.7,93},{80,93},{80,20},{110,20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heaFlo.T1CoiSur, T1CoiSur) annotation (Line(
      points={{1,52},{36,52},{36,40},{110,40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heaFlo.Q2_flow, Q2_flow) annotation (Line(
      points={{1,42},{4,42},{4,-80},{110,-80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heaFlo.Q1_flow, Q1_flow) annotation (Line(
      points={{1,54},{94,54},{94,60},{110,60}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (defaultComponentName="heaMasFlo", Diagram(coordinateSystem(
          preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
                                                     graphics), Documentation(info="<html>
<p>
This block combines the models for the dry coil and the wet coil.
Output of the block is the coil performance which, depending on the
mass fraction at the apparatus dew point temperature and 
the mass fraction of the coil inlet air,
may be from the dry coil, the wet coil, or a weighted average of the two.
</p>
</html>",
revisions="<html>
<ul>
<li>
September 20, 2012 by Michael Wetter:<br>
Revised implementation.
</li>
<li>
September 4, 2012 by Michael Wetter:<br>
Renamed connector to follow naming convention.
</li>
<li>
April 12, 2012 by Kaustubh Phalak:<br>
First implementation. 
</li>
</ul>
</html>"),Icon(graphics={        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-60,-48},{-50,-90},{-40,-50},{-30,-90},{-20,-50},{-10,-90},
              {0,-50},{10,-90},{20,-50},{30,-90},{40,-50},{50,-90},{60,-50}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{-60,30},{-50,70},{-40,30},{-30,70},{-20,30},{-10,70},{0,30},
              {10,70},{20,30},{30,70},{40,30},{50,70},{60,32}},
          color={255,0,0},
          smooth=Smooth.None),
        Line(
          points={{-78,8},{-78,30}},
          color={255,0,0},
          smooth=Smooth.None),
        Line(
          points={{78,-8},{78,32}},
          color={255,0,0},
          smooth=Smooth.None),
        Line(
          points={{78,-50},{78,-10}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{-78,-48},{-78,-32}},
          color={0,0,255},
          smooth=Smooth.None),
        Ellipse(extent={{-98,8},{-58,-32}},  lineColor={0,0,255}),
        Polygon(
          points={{68,14},{88,-26},{68,-26},{88,14},{68,14}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-98,8},{-58,-32}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          textString="C"),
        Text(
          extent={{-54,-20},{66,-40}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          textString="vol2"),
        Text(
          extent={{-48,20},{52,0}},
          lineColor={255,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          textString="vol1"),
        Line(
          points={{-60,30},{-78,30}},
          color={255,0,0},
          smooth=Smooth.None),
        Line(
          points={{-78,-48},{-60,-48}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{78,32},{60,32}},
          color={255,0,0},
          smooth=Smooth.None),
        Line(
          points={{60,-50},{78,-50}},
          color={0,0,255},
          smooth=Smooth.None),
        Text(
          extent={{-70,110},{70,68}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="%name")}));
end HeatMassFlow;
