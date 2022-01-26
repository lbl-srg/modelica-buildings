within Buildings.Obsolete.DistrictHeatingCooling.Plants;
model LakeWaterHeatExchanger_T "Heat exchanger with lake, ocean or river water"
  extends Buildings.Fluid.Interfaces.PartialFourPortInterface(
    redeclare final package Medium1 = Medium,
    redeclare final package Medium2 = Medium,
    final allowFlowReversal1 = true,
    final allowFlowReversal2 = true,
    final m1_flow_nominal = m_flow_nominal,
    final m2_flow_nominal = m_flow_nominal);

  replaceable package Medium =
    Modelica.Media.Interfaces.PartialMedium "Medium in the component"
      annotation (choicesAllMatching = true);
  parameter Boolean disableHeatExchanger = false
    "Set to true to disable the heat exchanger";

  parameter Modelica.Units.SI.TemperatureDifference TApp(
    min=0,
    displayUnit="K") = 0.5 "Approach temperature difference";

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal
    "Nominal mass flow rate" annotation (Dialog(group="Nominal condition"));

  parameter Modelica.Units.SI.PressureDifference dpValve_nominal(
    displayUnit="Pa",
    min=0) = 1000 "Nominal pressure drop of fully open valve"
    annotation (Dialog(group="Nominal condition"));

  parameter Modelica.Units.SI.PressureDifference dpHex_nominal(displayUnit="Pa",
      min=0)
    "Pressure drop of heat exchanger pipe and other resistances in the heat exchanger flow leg that are in series with the valve"
    annotation (Dialog(group="Nominal condition"));

  parameter Boolean from_dp = false
    "= true, use m_flow = f(dp) else dp = f(m_flow)"
    annotation (Evaluate=true, Dialog(enable = (dpValve_nominal + dpHex_nominal) > 0,
                tab="Flow resistance"));

  parameter Boolean linearizeFlowResistance = false
    "= true, use linear relation between m_flow and dp for any flow rate"
    annotation(Dialog(enable = (dpValve_nominal + dpHex_nominal) > 0,
               tab="Flow resistance"));
  parameter Real deltaM = 0.1
    "Fraction of nominal flow rate where flow transitions to laminar"
    annotation(Dialog(enable = (dpValve_nominal + dpHex_nominal) > 0,
               tab="Flow resistance"));

  Modelica.Blocks.Interfaces.RealInput TSouWat(
    unit="K",
    displayUnit="degC")
    "Temperature of ocean, lake or river"
    annotation (Placement(transformation(extent={{-140,260},{-100,300}})));

  Modelica.Blocks.Interfaces.RealInput TSouHea(
    unit="K",
    displayUnit="degC")
    "Source temperature to add heat the loop water (such as outdoor drybulb temperature)"
    annotation (Placement(transformation(extent={{-140,220},{-100,260}}),
        iconTransformation(extent={{-140,220},{-100,260}})));
  Modelica.Blocks.Interfaces.RealInput TSouCoo(
    unit="K",
    displayUnit="degC")
    "Source temperature to reject heat, such as outdoor wet bulb, outdoor drybulb, or else TSouWat"
    annotation (Placement(transformation(extent={{-140,180},{-100,220}})));

  Modelica.Blocks.Interfaces.RealInput TSetHea(unit="K")
    "Temperature set point for heating"
    annotation (Placement(transformation(extent={{-140,140},{-100,180}}),
        iconTransformation(extent={{-140,140},{-100,180}})));
  Modelica.Blocks.Interfaces.RealInput TSetCoo(unit="K")
    "Temperature set point for cooling"
    annotation (Placement(transformation(extent={{-140,100},{-100,140}}),
        iconTransformation(extent={{-140,100},{-100,140}})));
  Modelica.Blocks.Interfaces.RealOutput QWat_flow(unit="W")
    "Heat exchanged with water reservoir (positive if added to reservoir)"
    annotation (Placement(transformation(extent={{100,110},{120,130}})));
  Buildings.Fluid.Actuators.Valves.ThreeWayLinear valCoo(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    dpValve_nominal=1000,
    use_inputFilter=false,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
    final dpFixed_nominal={if disableHeatExchanger then 0 else dpHex_nominal,0})
    "Switching valve for cooling" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        origin={50,60})));
  Buildings.Fluid.Actuators.Valves.ThreeWayLinear valHea(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    dpValve_nominal=1000,
    use_inputFilter=false,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
    final dpFixed_nominal={if disableHeatExchanger then 0 else dpHex_nominal,0})
    "Switching valve for heating" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        origin={50,-60})));

protected
  Buildings.Fluid.HeatExchangers.SensibleCooler_T coo(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    final dp_nominal=0,
    final allowFlowReversal=true,
    final show_T=false,
    final from_dp=from_dp,
    final linearizeFlowResistance=linearizeFlowResistance,
    final deltaM=deltaM,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    QMin_flow=if disableHeatExchanger then 0 else -Modelica.Constants.inf)
    "Heat exchanger effect for mode in which water is cooled"
    annotation (Placement(transformation(extent={{10,50},{-10,70}})));
  Modelica.Blocks.Sources.RealExpression TWarIn(y=
    Medium.temperature_phX(
      p=port_b1.p,
      h=inStream(port_b1.h_outflow),
      X=cat(1,inStream(port_b1.Xi_outflow),
              {1-sum(inStream(port_b1.Xi_outflow))})))
        "Warm water inlet temperature"
    annotation (Placement(transformation(extent={{-40,156},{-20,176}})));
  Buildings.Fluid.HeatExchangers.Heater_T hea(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    final dp_nominal=0,
    final allowFlowReversal=true,
    final show_T=false,
    final from_dp=from_dp,
    final linearizeFlowResistance=linearizeFlowResistance,
    final deltaM=deltaM,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    QMax_flow=if disableHeatExchanger then 0 else Modelica.Constants.inf)
    "Heat exchanger effect for mode in which water is heated"
    annotation (Placement(transformation(extent={{10,-50},{-10,-30}})));
  Modelica.Blocks.Sources.RealExpression TColIn(y=
    Medium.temperature_phX(
      p=port_a2.p,
      h=inStream(port_a2.h_outflow),
      X=cat(1, inStream(port_a2.Xi_outflow),
               {1-sum(inStream(port_a2.Xi_outflow))}))) "Cold water inlet temperature"
    annotation (Placement(transformation(extent={{-40,98},{-20,118}})));
  Buildings.Utilities.Math.SmoothMax maxHeaLea(deltaX=0.1) "Maximum leaving temperature"
    annotation (Placement(transformation(extent={{8,104},{28,124}})));
  Buildings.Utilities.Math.SmoothMin minHeaLvg(deltaX=0.1) "Minimum leaving temperature"
    annotation (Placement(transformation(extent={{52,120},{72,140}})));
  Buildings.Utilities.Math.SmoothMax maxCooLea(deltaX=0.1) "Maximum leaving temperature"
    annotation (Placement(transformation(extent={{52,156},{72,176}})));
  Buildings.Utilities.Math.SmoothMin minCooLvg(deltaX=0.1) "Minimum leaving temperature"
    annotation (Placement(transformation(extent={{8,150},{28,170}})));
  Modelica.Blocks.Sources.Constant TAppHex(k=TApp)
    "Approach temperature difference"
    annotation (Placement(transformation(extent={{-80,180},{-60,200}})));
  Modelica.Blocks.Math.Add TWatHea(k2=-1)
    "Heat exchanger outlet, taking into account approach"
    annotation (Placement(transformation(extent={{40,190},{60,210}})));
  Modelica.Blocks.Math.Add TWatCoo
    "Heat exchanger outlet, taking into account approach"
    annotation (Placement(transformation(extent={{40,220},{60,240}})));
  Modelica.Blocks.Math.Add QExc_flow(k1=-1) "Heat added to water reservoir"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Buildings.Utilities.Math.SmoothMax smoothMax(deltaX=0.1)
    annotation (Placement(transformation(extent={{-10,198},{10,218}})));
  Buildings.Utilities.Math.SmoothMin smoothMin(deltaX=0.1)
    annotation (Placement(transformation(extent={{-10,230},{10,250}})));

  Controller conCoo(final m_flow_nominal=m_flow_nominal)
    "Controller for hex for cooling" annotation (Placement(transformation(
          extent={{-40,20},{-20,40}})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFloCoo(redeclare package Medium = Medium)
    "Mass flow sensor used for cooling control"
    annotation (Placement(transformation(extent={{-52,50},{-72,70}})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFloHea(redeclare package Medium = Medium)
    "Mass flow sensor used for heating control"
    annotation (Placement(transformation(extent={{-42,-50},{-62,-30}})));
  Controller conHea(final m_flow_nominal=m_flow_nominal)
    "Controller for hex for heating" annotation (Placement(transformation(
          extent={{-60,-90},{-40,-70}})));
equation
  connect(TColIn.y, maxHeaLea.u2) annotation (Line(points={{-19,108},{-19,108},{
          6,108}},             color={0,0,127}));
  connect(maxHeaLea.y, minHeaLvg.u2)
    annotation (Line(points={{29,114},{42,114},{42,120},{42,124},{50,124}},
                                                          color={0,0,127}));
  connect(minHeaLvg.y, hea.TSet) annotation (Line(points={{73,130},{86,130},{86,
          -32},{12,-32}}, color={0,0,127}));
  connect(TWarIn.y, minCooLvg.u1) annotation (Line(points={{-19,166},{-19,166},{
          6,166}},       color={0,0,127}));
  connect(minCooLvg.y, maxCooLea.u2)
    annotation (Line(points={{29,160},{29,160},{50,160}},
                                                color={0,0,127}));
  connect(maxCooLea.y, coo.TSet) annotation (Line(points={{73,166},{80,166},{80,
          80},{20,80},{20,68},{12,68}},
                    color={0,0,127}));
  connect(TAppHex.y, TWatHea.u2)
    annotation (Line(points={{-59,190},{-40,190},{-40,194},{38,194}},
                                                   color={0,0,127}));
  connect(TAppHex.y, TWatCoo.u2) annotation (Line(points={{-59,190},{-40,190},{-40,
          224},{38,224}},  color={0,0,127}));
  connect(TWatCoo.y, minCooLvg.u2) annotation (Line(points={{61,230},{80,230},{80,
          182},{0,182},{0,154},{6,154}},
                         color={0,0,127}));
  connect(TWatHea.y, maxHeaLea.u1) annotation (Line(points={{61,200},{68,200},{68,
          186},{-6,186},{-6,120},{6,120}},
                         color={0,0,127}));
  connect(coo.Q_flow, QExc_flow.u1) annotation (Line(points={{-11,68},{-16,68},
          {-16,6},{18,6}},color={0,0,127}));
  connect(hea.Q_flow, QExc_flow.u2) annotation (Line(points={{-11,-32},{-11,-34},
          {-14,-34},{-14,-6},{18,-6}}, color={0,0,127}));
  connect(QExc_flow.y, QWat_flow) annotation (Line(points={{41,0},{66,0},{90,0},
          {90,120},{110,120}}, color={0,0,127}));
  connect(smoothMax.y, TWatHea.u1) annotation (Line(points={{11,208},{24,208},{24,
          206},{38,206}}, color={0,0,127}));
  connect(smoothMin.y, TWatCoo.u1) annotation (Line(points={{11,240},{20,240},{20,
          236},{38,236}}, color={0,0,127}));
  connect(TSetCoo, maxCooLea.u1) annotation (Line(points={{-120,120},{-88,120},
          {-88,140},{40,140},{40,172},{50,172}},
                             color={0,0,127}));
  connect(valCoo.port_2, port_b1)
    annotation (Line(points={{60,60},{76,60},{100,60}}, color={0,127,255}));
  connect(conCoo.y, valCoo.y) annotation (Line(points={{-19,30},{30,30},{30,76},
          {50,76},{50,72}}, color={0,0,127}));
protected
  model Controller "Controller for bay water heat exchanger"
    parameter Modelica.Units.SI.MassFlowRate m_flow_nominal
      "Nominal mass flow rate" annotation (Dialog(group="Nominal condition"));
    Modelica.Blocks.Nonlinear.Limiter limTem(
      uMax=1,
      uMin=0,
      strict=true) "Signal limiter for switching valve"
      annotation (Placement(transformation(extent={{20,60},{40,80}})));
    Modelica.Blocks.Math.Gain gaiTem(k=4) "Control gain for dT"
      annotation (Placement(transformation(extent={{-30,60},{-10,80}})));
    Modelica.Blocks.Math.Feedback feeBac "Control error"
      annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
    Modelica.Blocks.Interfaces.RealInput u1 annotation (Placement(transformation(
            extent={{-120,60},{-100,80}})));
    Modelica.Blocks.Interfaces.RealInput u2 annotation (Placement(transformation(
          rotation=90,
          extent={{-10,-10},{10,10}},
          origin={0,-10})));
    Modelica.Blocks.Interfaces.RealOutput y
      "Control signal (0: bypass hex, 1: use hex)"
      annotation (Placement(transformation(
            extent={{100,90},{120,110}})));
    Modelica.Blocks.Interfaces.RealInput m_flow "Mass flow rate" annotation (
        Placement(transformation(extent={{-120,120},{-100,140}})));
    Modelica.Blocks.Math.Gain norFlo(final k=1/m_flow_nominal)
      "Normalized flow rate"
      annotation (Placement(transformation(extent={{-80,120},{-60,140}})));
    Modelica.Blocks.Nonlinear.Limiter limFlo(
      uMax=1,
      uMin=0,
      strict=true) "Signal limiter for switching valve"
      annotation (Placement(transformation(extent={{20,120},{40,140}})));
    Modelica.Blocks.Math.Gain gaiFlo(k=100) "Control gain for flow rate"
      annotation (Placement(transformation(extent={{-30,120},{-10,140}})));
    Modelica.Blocks.Math.Product product
      annotation (Placement(transformation(extent={{60,90},{80,110}})));
  equation
    connect(feeBac.y, gaiTem.u)
      annotation (Line(points={{-41,70},{-32,70}}, color={0,0,127}));
    connect(gaiTem.y, limTem.u)
      annotation (Line(points={{-9,70},{22,70},{18,70}}, color={0,0,127}));
    connect(u1, feeBac.u1) annotation (Line(points={{-110,70},{-110,70},{-58,70}},
          color={0,0,127}));
    connect(u2, feeBac.u2) annotation (Line(points={{0,-10},{0,20},{-50,20},{-50,
            62}},
          color={0,0,127}));
    connect(m_flow, norFlo.u)
      annotation (Line(points={{-110,130},{-82,130}}, color={0,0,127}));
    connect(norFlo.y, gaiFlo.u) annotation (Line(points={{-59,130},{-46,130},{-32,
            130}}, color={0,0,127}));
    connect(gaiFlo.y, limFlo.u)
      annotation (Line(points={{-9,130},{18,130}}, color={0,0,127}));
    connect(limFlo.y, product.u1) annotation (Line(points={{41,130},{48,130},{48,
            106},{58,106}}, color={0,0,127}));
    connect(limTem.y, product.u2) annotation (Line(points={{41,70},{46,70},{48,70},
            {48,94},{58,94}}, color={0,0,127}));
    connect(product.y, y) annotation (Line(points={{81,100},{88,100},{88,100},{88,
            100},{110,100}}, color={0,0,127}));
    annotation (Diagram(coordinateSystem(extent={{-100,0},{100,200}},
            preserveAspectRatio=false)), Icon(coordinateSystem(extent={{-100,0},{100,
              200}})));
  end Controller;
equation
  connect(valCoo.port_1, coo.port_a)
    annotation (Line(points={{40,60},{26,60},{10,60}}, color={0,127,255}));
  connect(senMasFloCoo.m_flow, conCoo.m_flow) annotation (Line(points={{-62,71},
          {-62,74},{-48,74},{-48,33},{-41,33}}, color={0,0,127}));
  connect(senMasFloCoo.port_b, port_a1) annotation (Line(points={{-72,60},{-100,
          60}},           color={0,127,255}));
  connect(port_b2, senMasFloHea.port_b) annotation (Line(points={{-100,-60},{-80,
          -60},{-80,-40},{-62,-40}}, color={0,127,255}));
  connect(conHea.m_flow, senMasFloHea.m_flow) annotation (Line(points={{-61,-77},
          {-72,-77},{-72,-24},{-52,-24},{-52,-29}}, color={0,0,127}));
  connect(valHea.port_2, port_a2)
    annotation (Line(points={{60,-60},{80,-60},{100,-60}}, color={0,127,255}));
  connect(valHea.port_1, hea.port_a) annotation (Line(points={{40,-60},{30,-60},
          {30,-40},{10,-40}}, color={0,127,255}));
  connect(conHea.y, valHea.y) annotation (Line(points={{-39,-80},{-20,-80},{36,-80},
          {36,-40},{50,-40},{50,-48}}, color={0,0,127}));
  connect(TColIn.y, conHea.u2) annotation (Line(points={{-19,108},{-10,108},{-10,
          90},{-86,90},{-86,-96},{-50,-96},{-50,-91}}, color={0,0,127}));
  connect(conHea.u1, minHeaLvg.y) annotation (Line(points={{-61,-83},{-70,-83},{
          -70,-94},{86,-94},{86,130},{73,130}}, color={0,0,127}));
  connect(TWarIn.y, conCoo.u1) annotation (Line(points={{-19,166},{-14,166},{
          -14,128},{-50,128},{-50,27},{-41,27}}, color={0,0,127}));
  connect(maxCooLea.y, conCoo.u2) annotation (Line(points={{73,166},{80,166},{
          80,16},{-30,16},{-30,19}}, color={0,0,127}));
  connect(coo.port_b, senMasFloCoo.port_a)
    annotation (Line(points={{-10,60},{-52,60}},          color={0,127,255}));
  connect(valCoo.port_3, senMasFloCoo.port_a) annotation (Line(points={{50,50},{
          50,44},{-32,44},{-32,60},{-52,60}}, color={0,127,255}));
  connect(senMasFloHea.port_a, hea.port_b) annotation (Line(points={{-42,-40},{-26,
          -40},{-10,-40}}, color={0,127,255}));
  connect(senMasFloHea.port_a, valHea.port_3) annotation (Line(points={{-42,-40},
          {-30,-40},{-30,-76},{50,-76},{50,-70}}, color={0,127,255}));
  connect(smoothMin.u2, TSouWat) annotation (Line(points={{-12,234},{-52,234},{
          -52,280},{-120,280}},       color={0,0,127}));
  connect(smoothMax.u2, TSouWat) annotation (Line(points={{-12,202},{-30,202},{
          -52,202},{-52,234},{-52,280},{-120,280}},       color={0,0,127}));
  connect(smoothMax.u1, TSouHea) annotation (Line(points={{-12,214},{-96,214},{
          -96,240},{-120,240}},
                            color={0,0,127}));
  connect(smoothMin.u1, TSouCoo) annotation (Line(points={{-12,246},{-12,246},{-86,
          246},{-86,200},{-120,200}}, color={0,0,127}));
  connect(minHeaLvg.u1, TSetHea) annotation (Line(points={{50,136},{4,136},{-80,
          136},{-80,160},{-120,160}}, color={0,0,127}));
  annotation (
  defaultComponentName="hex",
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            300}})),            Icon(coordinateSystem(extent={{-100,-100},{100,300}},
                   preserveAspectRatio=false), graphics={
                                Rectangle(
        extent={{-100,-100},{100,300}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),  Rectangle(
          extent={{-64,244},{70,118}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,127,0},
          fillPattern=FillPattern.Solid,
          radius=10),
        Rectangle(
          extent={{-100,65},{101,55}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,-55},{101,-65}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),Rectangle(
          extent={{-62,84},{70,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-94,176},{-40,138}},
          textColor={0,0,127},
          textString="TSetHea"),
        Text(
          extent={{-96,138},{-42,100}},
          textColor={0,0,127},
          textString="TSetCoo"),
        Text(
          extent={{-139,-100},{161,-140}},
          textColor={0,0,255},
          textString="%name"),
        Rectangle(
          extent={{-18,137},{-10,84}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{14,137},{22,84}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{12,218},{42,240},{18,182},{48,144},{30,132},{0,138},{-30,132},
              {-34,162},{-34,202},{-18,208},{12,218}},
          smooth=Smooth.Bezier,
          fillPattern=FillPattern.Solid,
          fillColor={0,0,255},
          pattern=LinePattern.None),
        Text(
          extent={{-90,296},{-36,258}},
          textColor={0,0,127},
          textString="TSouWat"),
        Text(
          extent={{-94,218},{-40,180}},
          textColor={0,0,127},
          textString="TSouCoo"),
        Text(
          extent={{-94,256},{-40,218}},
          textColor={0,0,127},
          textString="TSouHea")}),
    Documentation(info="<html>
<p>
Model for a heat exchanger that uses water such as from a lake, the ocean or a river,
or the ambient air to either provide heating or cooling.
The model has built-in controls in order to exchange heat,
up to a maximum approach temperature difference
set by <code>TApp</code>.
<p>
There are three input signals for the heat or cold source:
</p>
<ul>
<li>
<code>TSouWat</code> is the temperature of the ocean, lake or river to which
heat is rejected, or from which heat is extracted from.
</li>
<li>
<code>TSouHea</code> is the temperature used to heat the water.
This could be set to the outdoor drybulb temperature if there is an air-to-water
heat exchanger, or else to the same value as is used for <code>TSouWat</code>
below.
</li>
<li>
<code>TSouCoo</code> is the temperature used to cool the water.
This could be set to the outdoor wet bulb temperature if there is a wet cooling
tower,
to the outdoor dry-bulb temperature if there is a dry cooling tower,
or else to <code>TSouWat</code>.
</li>
</ul>
<p>
The parameters <code>TLooMin</code> and <code>TLooMax</code> are used to avoid
that the water of the district heating/cooling
is below or above a maximum threshold.
</p>
<h4>Implementation</h4>
<p>
The pressure drop of the heat exchanger is implemented in the valve
instances <code>valCoo</code> and <code>valHea</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
February 3, 2017, by Felix Buenning:<br/>
Corrected wrong signs for <code>TApp</code> in <code>TWatCoo</code> and <code>TWatHea</code>.
</li>
<li>
November 8, 2016, by Michael Wetter:<br/>
Corrected wrong argument type in function call of <code>Medium.temperature_phX</code>.
</li>
<li>
September 17, 2016, by Michael Wetter:<br/>
Corrected wrong annotation to avoid an error in the pedantic model check
in Dymola 2017 FD01 beta2.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/557\">issue 557</a>.
</li>
<li>
August 11, 2016, by Michael Wetter:<br/>
Reconfigured output limiters of controllers to avoid event iterations when
they saturate. This decreases the computing time for the system models
by about a factor of two.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/551\">issue 551</a>.
</li>
<li>
May 31, 2016, by Michael Wetter:<br/>
Renamed <code>dp_nominal</code> to <code>dpHex_nominal</code>
as it is the pressure drop of the heat exchanger flow leg.
</li>
<li>
March 30, 2016, by Michael Wetter:<br/>
Removed the flow splitters which are no longer needed.
</li>
<li>
February 16, 2016, by Michael Wetter:<br/>
Improved controls.
</li>
<li>
December 23, 2015, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end LakeWaterHeatExchanger_T;
