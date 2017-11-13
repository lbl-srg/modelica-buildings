within Buildings.Fluid.HeatExchangers;
model DryCoilCounterFlow
  "Counterflow coil with discretization along the flow paths and without humidity condensation"
  extends Buildings.Fluid.Interfaces.PartialFourPortInterface(show_T=false);
  extends Buildings.Fluid.Interfaces.FourPortFlowResistanceParameters(
    final computeFlowResistance1=false,
    final computeFlowResistance2=false,
    from_dp1=false,
    from_dp2=false);

  parameter Modelica.SIunits.ThermalConductance UA_nominal(min=0)
    "Thermal conductance at nominal flow, used to compute heat capacity"
    annotation (Dialog(tab="General", group="Nominal condition"));
  parameter Real r_nominal=2/3
    "Ratio between air-side and water-side convective heat transfer coefficient"
    annotation (Dialog(group="Nominal condition"));
  parameter Integer nEle(min=1) = 4
    "Number of pipe segments used for discretization"
    annotation (Dialog(group="Geometry"));

  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Formulation of energy balance"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));

  parameter Modelica.SIunits.Time tau1=10
    "Time constant at nominal flow for medium 1"
    annotation (Dialog(group="Nominal condition",
                enable=not (energyDynamics==Modelica.Fluid.Types.Dynamics.SteadyState)));
  parameter Modelica.SIunits.Time tau2=2
    "Time constant at nominal flow for medium 2"
    annotation (Dialog(group="Nominal condition",
                enable=not (energyDynamics==Modelica.Fluid.Types.Dynamics.SteadyState)));
  parameter Modelica.SIunits.Time tau_m=5
    "Time constant of metal at nominal UA value"
    annotation (Dialog(group="Nominal condition"));

  parameter Boolean waterSideFlowDependent=true
    "Set to false to make water-side hA independent of mass flow rate"
    annotation (Dialog(tab="Heat transfer"));
  parameter Boolean airSideFlowDependent=true
    "Set to false to make air-side hA independent of mass flow rate"
    annotation (Dialog(tab="Heat transfer"));
  parameter Boolean waterSideTemperatureDependent=false
    "Set to false to make water-side hA independent of temperature"
    annotation (Dialog(tab="Heat transfer"));
  parameter Boolean airSideTemperatureDependent=false
    "Set to false to make air-side hA independent of temperature"
    annotation (Dialog(tab="Heat transfer"));

  parameter Modelica.SIunits.ThermalConductance GDif = 1E-2*UA_nominal/(nEle - 1)
    "Thermal conductance to approximate diffusion (which improves model at near-zero flow rates"
    annotation(Dialog(tab="Experimental"));
  Modelica.SIunits.HeatFlowRate Q1_flow = sum(ele[i].Q1_flow for i in 1:nEle)
    "Heat transferred from solid into medium 1";
  Modelica.SIunits.HeatFlowRate Q2_flow = sum(ele[i].Q2_flow for i in 1:nEle)
    "Heat transferred from solid into medium 2";

  Modelica.SIunits.Temperature T1[nEle] = ele[:].vol1.T "Water temperature";
  Modelica.SIunits.Temperature T2[nEle] = ele[:].vol2.T "Air temperature";
  Modelica.SIunits.Temperature T_m[nEle] = ele[:].con1.solid.T
    "Metal temperature";

  BaseClasses.HADryCoil hA(
    final UA_nominal=UA_nominal,
    final m_flow_nominal_a=m2_flow_nominal,
    final m_flow_nominal_w=m1_flow_nominal,
    final waterSideTemperatureDependent=waterSideTemperatureDependent,
    final waterSideFlowDependent=waterSideFlowDependent,
    final airSideTemperatureDependent=airSideTemperatureDependent,
    final airSideFlowDependent=airSideFlowDependent,
    r_nominal=r_nominal) "Model for convective heat transfer coefficient"
    annotation (Placement(transformation(extent={{-60,70},{-40,90}})));
protected
  final parameter Boolean use_temSen_1=
    waterSideTemperatureDependent and allowFlowReversal1 and
    (energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState)
    "Flag, set to true if the temperature sensor 1 is used"
    annotation(Evaluate=true);

  final parameter Boolean use_temSen_2=
    airSideTemperatureDependent and allowFlowReversal2 and
    (energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState)
    "Flag, set to true if the temperature sensor 2 is used"
    annotation(Evaluate=true);

  Buildings.Fluid.Sensors.TemperatureTwoPort temSen_1(
   redeclare package Medium = Medium1,
    allowFlowReversal=allowFlowReversal1,
    m_flow_nominal=m1_flow_nominal,
    tau=if use_temSen_1 then 1 else 0)
    "Temperature sensor, used to obtain temperature for convective heat transfer calculation"
    annotation (Placement(transformation(
          extent={{-58,54},{-46,66}})));
  Buildings.Fluid.Sensors.MassFlowRate masFloSen_1(
    redeclare package Medium = Medium1) "Mass flow rate sensor" annotation (Placement(transformation(
          extent={{-80,54},{-68,66}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort temSen_2(
    redeclare package Medium = Medium2,
    final allowFlowReversal=allowFlowReversal2,
    m_flow_nominal=m2_flow_nominal,
    tau=if use_temSen_2 then 1 else 0)
    "Temperature sensor, used to obtain temperature for convective heat transfer calculation"
    annotation (Placement(transformation(
          extent={{58,-66},{44,-54}})));
  Buildings.Fluid.Sensors.MassFlowRate masFloSen_2(
    redeclare package Medium = Medium2)
    "Mass flow rate sensor" annotation (Placement(transformation(
          extent={{82,-66},{70,-54}})));

  Modelica.Blocks.Math.Gain gai_1(k=1/nEle)
    "Gain medium-side 1 to take discretization into account" annotation (
      Placement(transformation(extent={{-18,84},{-6,96}})));
  Modelica.Blocks.Math.Gain gai_2(k=1/nEle)
    "Gain medium-side 2 to take discretization into account" annotation (
      Placement(transformation(extent={{-18,62},{-6,74}})));

  replaceable BaseClasses.HexElementSensible ele[nEle]
  constrainedby BaseClasses.PartialHexElement(
    redeclare each package Medium1 = Medium1,
    redeclare each package Medium2 = Medium2,
    each allowFlowReversal1=allowFlowReversal1,
    each allowFlowReversal2=allowFlowReversal2,
    each tau1=tau1/nEle,
    each m1_flow_nominal=m1_flow_nominal,
    each tau2=tau2,
    each m2_flow_nominal=m2_flow_nominal,
    each tau_m=tau_m/nEle,
    each UA_nominal=UA_nominal/nEle,
    each energyDynamics=energyDynamics,
    initialize_p1 = {(i == 1 and (not Medium1.singleState)) for i in 1:nEle},
    initialize_p2 = {(i == 1 and (not Medium2.singleState)) for i in 1:nEle},
    each deltaM1=deltaM1,
    each deltaM2=deltaM2,
    each from_dp1=from_dp1,
    each from_dp2=from_dp2,
    dp1_nominal={if i == 1 then dp1_nominal else 0 for i in 1:nEle},
    dp2_nominal={if i == nEle then dp2_nominal else 0 for i in 1:nEle})
    "Heat exchanger element"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Modelica.Blocks.Routing.Replicator rep1(nout=nEle) "Signal replicator"
    annotation (Placement(transformation(extent={{4,82},{18,98}})));
  Modelica.Blocks.Routing.Replicator rep2(nout=nEle) "Signal replicator"
    annotation (Placement(transformation(extent={{4,60},{18,76}})));


  Modelica.Blocks.Sources.RealExpression THA1(
    y=if waterSideTemperatureDependent then
        if allowFlowReversal1 then
          if energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState then
            temSen_1.T
          else
            ele[1].vol1.T
        else
          Medium1.temperature(
            state=Medium1.setState_phX(p=port_a1.p, h=inStream(port_a1.h_outflow), X=inStream(port_a1.Xi_outflow)))
        else
          Medium1.T_default)
    "Temperature used for convective heat transfer calculation for medium 1 (water-side)"
    annotation (Placement(transformation(extent={{-80,78},{-66,88}})));

  Modelica.Blocks.Sources.RealExpression THA2(
    y=if airSideTemperatureDependent then
        if allowFlowReversal1 then
          if energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState then
            temSen_2.T
          else
            ele[nEle].vol2.T
        else
          Medium2.temperature(
            state=Medium2.setState_phX(p=port_a2.p, h=inStream(port_a2.h_outflow), X=inStream(port_a2.Xi_outflow)))
        else
          Medium2.T_default)
    "Temperature used for convective heat transfer calculation for medium 2 (air-side)"
    annotation (Placement(transformation(extent={{-80,72},{-66,82}})));

  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon1[nEle-1](each final G=GDif)
    "Thermal connector to approximate diffusion in medium 1"
    annotation (Placement(transformation(extent={{0,34},{20,54}})));

  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon2[nEle-1](each final G=GDif)
    "Thermal connector to approximate diffusion in medium 2"
    annotation (Placement(transformation(extent={{20,-40},{0,-20}})));

initial equation
  assert(UA_nominal > 0,
    "Parameter UA_nominal is negative. Check heat exchanger parameters.");





equation
  connect(masFloSen_1.m_flow, hA.m1_flow) annotation (Line(points={{-74,66.6},{
          -74,70},{-84,70},{-84,94},{-64,94},{-64,87},{-61,87}},
                                               color={0,0,127}));
  connect(port_a2, masFloSen_2.port_a)
    annotation (Line(points={{100,-60},{82,-60}}, color={0,127,255}));
  connect(masFloSen_2.port_b, temSen_2.port_a)
    annotation (Line(points={{70,-60},{64,-60},{58,-60}},
                                                 color={0,127,255}));
  connect(masFloSen_2.m_flow, hA.m2_flow) annotation (Line(points={{76,-53.4},{
          76,-44},{-86,-44},{-86,73},{-61,73}}, color={0,0,127}));
  connect(hA.hA_1, gai_1.u) annotation (Line(points={{-39,87},{-28,87},{-28,90},
          {-19.2,90}}, color={0,0,255}));
  connect(hA.hA_2, gai_2.u) annotation (Line(points={{-39,73},{-27.5,73},{-27.5,
          68},{-19.2,68}}, color={0,0,255}));
  connect(port_a1, masFloSen_1.port_a) annotation (Line(
      points={{-100,60},{-80,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(masFloSen_1.port_b, temSen_1.port_a) annotation (Line(
      points={{-68,60},{-58,60}},
      color={0,127,255},
      smooth=Smooth.None));

  connect(ele[nEle].port_b1, port_b1) annotation (Line(
      points={{20,16},{40,16},{40,60},{100,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(ele[1].port_b2, port_b2) annotation (Line(
      points={{0,4},{-30,4},{-30,-60},{-100,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  for i in 1:nEle - 1 loop
    connect(ele[i].port_b1, ele[i + 1].port_a1) annotation (Line(
        points={{20,16},{30,16},{30,28},{-10,28},{-10,16},{0,16}},
        color={0,127,255},
        smooth=Smooth.None));
    connect(ele[i].port_a2, ele[i + 1].port_b2) annotation (Line(
        points={{20,4},{-12,4},{-12,-10},{30,-10},{30,4},{0,4}},
        color={0,127,255},
        smooth=Smooth.None));
  connect(theCon1[i].port_a, ele[i].heaPor1) annotation (Line(points={{0,44},{-10,
          44},{-10,32},{10,32},{10,20}}, color={191,0,0}));
  connect(theCon1[i].port_b, ele[i+1].heaPor1) annotation (Line(points={{20,44},{28,
          44},{28,32},{10,32},{10,20}}, color={191,0,0}));
  connect(theCon2[i].port_a, ele[i].heaPor2) annotation (Line(points={{20,-30},{
          24,-30},{24,-14},{10,-14},{10,0}}, color={191,0,0}));
  connect(theCon2[i].port_b, ele[i+1].heaPor2) annotation (Line(points={{0,-30},{-8,
          -30},{-8,-14},{10,-14},{10,0}}, color={191,0,0}));
  end for;

  connect(gai_1.y, rep1.u) annotation (Line(
      points={{-5.4,90},{2.6,90}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(rep1.y, ele.Gc_1) annotation (Line(
      points={{18.7,90},{44,90},{44,26},{6,26},{6,20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gai_2.y, rep2.u) annotation (Line(
      points={{-5.4,68},{2.6,68}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(rep2.y, ele.Gc_2) annotation (Line(
      points={{18.7,68},{48,68},{48,-6},{14,-6},{14,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(THA1.y, hA.T_1) annotation (Line(points={{-65.3,83},{-65.3,83},{-61,
          83}},
        color={0,0,127}));
  connect(THA2.y, hA.T_2) annotation (Line(points={{-65.3,77},{-65.3,77},{-61,
          77}},
        color={0,0,127}));

  connect(temSen_1.port_b, ele[1].port_a1) annotation (Line(
      points={{-46,60},{-30,60},{-30,16},{0,16}},
      color={0,127,255},
      smooth=Smooth.None));

  connect(temSen_2.port_b, ele[nEle].port_a2) annotation (Line(
      points={{44,-60},{30,-60},{30,4},{20,4}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (
defaultComponentName="heaCoi",
Documentation(info="<html>
<p>
Model of a discretized coil without water vapor condensation.
The coil consists of two flow paths which are, at the design flow direction,
in opposite direction to model a counterflow heat exchanger.
The flow paths are discretized into <code>nEle</code> elements.
Each element is modeled by an instance of
<a href=\"modelica://Buildings.Fluid.HeatExchangers.BaseClasses.HexElementSensible\">
Buildings.Fluid.HeatExchangers.BaseClasses.HexElementSensible</a>.
Each element has a state variable for the metal.
</p>
<p>
The convective heat transfer coefficients can, for each fluid individually, be
computed as a function of the flow rate and/or the temperature,
or assigned to a constant. This computation is done using an instance of
<a href=\"modelica://Buildings.Fluid.HeatExchangers.BaseClasses.HADryCoil\">
Buildings.Fluid.HeatExchangers.BaseClasses.HADryCoil</a>.
</p>
<p>
To model humidity condensation, use the model
<a href=\"modelica://Buildings.Fluid.HeatExchangers.WetCoilCounterFlow\">
Buildings.Fluid.HeatExchangers.WetCoilCounterFlow</a> instead of this model, as
this model computes only sensible heat transfer.
</p>
<h4>Implementation</h4>
<p>
At very small flow rates, which may be caused when the fan is off but there is wind pressure
on the building that entrains outside air through the HVAC system, large temperature differences
could occur if diffusion were neglected.
This model therefore approximates a small diffusion between the elements to have more uniform
medium temperatures if the flow is near zero.
The approximation is done using the heat conductors <code>heaCon1</code> and <code>heaCon2</code>.
As this is a rough approximation, neighboring elements are connected through these heat conduction
elements, ignoring the actual geometrical configuration.
Also, radiation between the coil surfaces on the air side is not modelled explicitly, but
rather may be considered as approximated by these heat conductors.
</p>
</html>", revisions="<html>
<ul>
<li>
November 12, 2017, by Michael wetter:<br/>
Changed time constant to more reasonable values, which also makes
closed loop control tuning easier.
</li>
<li>
November 4, 2017, by Michael wetter:<br/>
Added approximation of diffusion.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1038\">Buildings, #1038</a>.
</li>
<li>
September 8, 2017, by Michael Wetter:<br/>
Changed computation of temperature used for <i>hA</i> calculation
to avoid a state variable with small time constant for some model parameterizations.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/678\">Buildings, #678</a>.
</li>
<li>
September 12, 2014, by Michael Wetter:<br/>
Changed assignment of <code>T_m</code> to avoid using the conditionally
enabled model <code>ele[:].mas.T</code>, which is only
valid in a connect statement.
Moved assignments of
<code>Q1_flow</code>, <code>Q2_flow</code>, <code>T1</code>,
<code>T2</code> and <code>T_m</code> outside of equation section
to avoid mixing graphical and textual modeling within the same model.
</li>
<li>
July 3, 2014, by Michael Wetter:<br/>
Added parameters <code>initialize_p1</code> and <code>initialize_p2</code>.
This is required to enable the coil models to initialize the pressure in the
first volume, but not in the downstream volumes. Otherwise,
the initial equations will be overdetermined, but consistent.
This change was done to avoid a long information message that appears
when translating models.
</li>
<li>
June 26, 2014, by Michael Wetter:<br/>
Removed parameters <code>energyDynamics1</code> and <code>energyDynamics2</code>,
and used instead of these two parameters the new parameter <code>energyDynamics</code>.
This was done as this complexity is not required.
</li>
<li>
February 2, 2012, by Michael Wetter:<br/>
Corrected error in assignment of <code>dp2_nominal</code>.
The previous assignment caused a pressure drop in all except one element,
instead of the opposite. This caused too high a flow resistance
of the heat exchanger.
</li>
<li>
October 8, 2011, by Michael Wetter:<br/>
Set <code>show_T=false</code> to avoid state events near zero flow.
</li>
<li>
May 27, 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
        Rectangle(
          extent={{-70,80},{70,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{36,80},{40,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-40,80},{-36,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-2,80},{2,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,-55},{101,-65}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,127,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-98,65},{103,55}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid)}),
    Diagram(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}},
        grid={2,2},
        initialScale=0.5), graphics={Text(
          extent={{60,72},{84,58}},
          lineColor={0,0,255},
          textString="water-side"), Text(
          extent={{50,-32},{90,-38}},
          lineColor={0,0,255},
          textString="air-side")}));
end DryCoilCounterFlow;
