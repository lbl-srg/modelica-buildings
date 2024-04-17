within Buildings.DHC.ETS.Combined.Subsystems;
model Chiller
  "Base subsystem with heat recovery chiller"
  replaceable package Medium=Modelica.Media.Interfaces.PartialMedium
    "Medium model"
    annotation (choices(choice(redeclare package Medium=Buildings.Media.Water "Water"),
    choice(redeclare package Medium =
            Buildings.Media.Antifreeze.PropyleneGlycolWater (property_T=293.15,X_a=0.40)
    "Propylene glycol water, 40% mass fraction")));
  parameter Boolean allowFlowReversal=false
    "= true to allow flow reversal, false restricts to design direction (port_a -> port_b)"
    annotation (Dialog(tab="Assumptions"),Evaluate=true);
  replaceable parameter Buildings.Fluid.Chillers.Data.ElectricEIR.Generic dat
    "Chiller performance data"
    annotation (choicesAllMatching=true,Placement(transformation(extent={{60,160},{80,180}})));
  parameter Modelica.Units.SI.PressureDifference dpCon_nominal(displayUnit="Pa")
    "Nominal pressure drop accross condenser"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpEva_nominal(displayUnit="Pa")
    "Nominal pressure drop accross evaporator"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Pressure dpValCon_nominal=dpCon_nominal/2
    "Nominal pressure drop accross control valve on condenser side"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Pressure dpValEva_nominal=dpEva_nominal/2
    "Nominal pressure drop accross control valve on evaporator side"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature TConWatEntMin(displayUnit="degC")=
    dat.TConEntMin "Minimum value of condenser water entering temperature"
    annotation (Dialog(group="Controls"));
  parameter Modelica.Units.SI.Temperature TEvaWatEntMax(displayUnit="degC")=
    dat.TEvaLvgMax - dat.QEva_flow_nominal/cp_default/dat.mEva_flow_nominal
    "Maximum value of evaporator water entering temperature"
    annotation (Dialog(group="Controls"));
  // IO CONNECTORS
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uHea
    "Heating enable signal"
    annotation (Placement(transformation(extent={{-240,168},{-200,208}}),
    iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uCoo
    "Cooling enable signal"
    annotation (Placement(transformation(extent={{-240,148},{-200,188}}),
    iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSupSet(
    final unit="K",
    displayUnit="degC")
    "Chilled water supply temperature set point (may be reset down)"
    annotation (Placement(transformation(extent={{-240,120},{-200,160}}),
    iconTransformation(extent={{-140,-40},{-100,0}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_aChiWat(
    redeclare final package Medium=Medium,
    m_flow(
      min=
        if allowFlowReversal then
          -Modelica.Constants.inf
        else
          0),
    h_outflow(
      start=Medium.h_default,
      nominal=Medium.h_default))
    "Fluid port for chilled water return"
    annotation (Placement(transformation(extent={{190,-70},{210,-50}}),
    iconTransformation(extent={{90,-70},{110,-50}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_bChiWat(
    redeclare final package Medium=Medium,
    m_flow(
      max=
        if allowFlowReversal then
          +Modelica.Constants.inf
        else
          0),
    h_outflow(
      start=Medium.h_default,
      nominal=Medium.h_default))
    "Fluid port for chilled water supply"
    annotation (Placement(transformation(extent={{-210,-70},{-190,-50}}),
    iconTransformation(extent={{-110,-70},{-90,-50}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_aHeaWat(
    redeclare final package Medium=Medium,
    m_flow(
      min=
        if allowFlowReversal then
          -Modelica.Constants.inf
        else
          0),
    h_outflow(
      start=Medium.h_default,
      nominal=Medium.h_default))
    "Fluid port for heating water return"
    annotation (Placement(transformation(extent={{-210,50},{-190,70}}),
    iconTransformation(extent={{-110,50},{-90,70}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_bHeaWat(
    redeclare final package Medium=Medium,
    m_flow(
      max=
        if allowFlowReversal then
          +Modelica.Constants.inf
        else
          0),
    h_outflow(
      start=Medium.h_default,
      nominal=Medium.h_default))
    "Fluid port for heating water supply"
    annotation (Placement(transformation(extent={{190,50},{210,70}}),
    iconTransformation(extent={{90,50},{110,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput PChi(
    final unit="W")
    "Chiller power"
    annotation (Placement(transformation(extent={{200,-20},{240,20}}),
    iconTransformation(extent={{100,0},{140,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput PPum(
    final unit="W")
    "Pump power"
    annotation (Placement(transformation(extent={{200,-160},{240,-120}}),
    iconTransformation(extent={{100,-40},{140,0}})));
  // COMPONENTS
  Fluid.Chillers.ElectricEIR chi(
    redeclare final package Medium1=Medium,
    redeclare final package Medium2=Medium,
    final allowFlowReversal1=allowFlowReversal,
    final allowFlowReversal2=allowFlowReversal,
    final dp1_nominal=0,
    final dp2_nominal=0,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final per=dat)
    "Water cooled chiller (ports indexed 1 are on condenser side)"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.DHC.ETS.BaseClasses.Pump_m_flow pumCon(
    redeclare final package Medium=Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=dat.mCon_flow_nominal,
    final dp_nominal=dpCon_nominal+dpValCon_nominal)
    "Condenser pump"
    annotation (Placement(transformation(extent={{-110,50},{-90,70}})));
  Buildings.DHC.ETS.BaseClasses.Pump_m_flow pumEva(
    redeclare final package Medium=Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=dat.mEva_flow_nominal,
    final dp_nominal=dpEva_nominal+dpValEva_nominal)
    "Evaporator pump"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},rotation=0,origin={-100,-60})));
  Buildings.DHC.ETS.Combined.Controls.Chiller con(
    final TConWatEntMin=TConWatEntMin,
    final TEvaWatEntMax=TEvaWatEntMax)
    "Controller"
    annotation (Placement(transformation(extent={{-70,130},{-50,150}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTConLvg(
    redeclare final package Medium=Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=dat.mCon_flow_nominal)
    "Condenser water leaving temperature"
    annotation (Placement(transformation(extent={{10,10},{-10,-10}},rotation=270,origin={20,20})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTConEnt(
    redeclare final package Medium=Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=dat.mCon_flow_nominal)
    "Condenser water entering temperature"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},rotation=-90,origin={-20,40})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTEvaEnt(
    redeclare final package Medium=Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=dat.mEva_flow_nominal)
    "Evaporator water entering temperature"
    annotation (Placement(transformation(extent={{10,10},{-10,-10}},rotation=270,origin={20,-40})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTEvaLvg(
    redeclare final package Medium=Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=dat.mEva_flow_nominal)
    "Evaporator water leaving temperature"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},rotation=90,origin={-20,-20})));
  Buildings.DHC.ETS.BaseClasses.Junction splEva(
    redeclare final package Medium=Medium,
    final m_flow_nominal=dat.mEva_flow_nominal .* {1,-1,-1})
    "Flow splitter for the evaporator water circuit"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},rotation=0,origin={-140,-60})));
  Buildings.DHC.ETS.BaseClasses.Junction splConMix(
    redeclare final package Medium=Medium,
    final m_flow_nominal=dat.mCon_flow_nominal .* {1,-1,-1})
    "Flow splitter"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},rotation=0,origin={120,60})));
  Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear valEva(
    redeclare final package Medium=Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    from_dp=false,
    use_inputFilter=false,
    final m_flow_nominal=dat.mEva_flow_nominal,
    final dpValve_nominal=dpValEva_nominal,
    final dpFixed_nominal=fill(
      dpEva_nominal,
      2))
    "Control valve for maximum evaporator water entering temperature"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},rotation=180,origin={120,-60})));
  Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear valCon(
    redeclare final package Medium=Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    from_dp=false,
    use_inputFilter=false,
    final m_flow_nominal=dat.mCon_flow_nominal,
    final dpValve_nominal=dpValCon_nominal,
    final dpFixed_nominal=fill(
      dpCon_nominal,
      2))
    "Control valve for minimum condenser water entering temperature"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},rotation=0,origin={-140,60})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea
    "Constant speed primary pumps control signal"
    annotation (Placement(transformation(extent={{-60,170},{-80,190}})));
  Buildings.Controls.OBC.CDL.Reals.Add add2
    annotation (Placement(transformation(extent={{160,-150},{180,-130}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai1(final k=dat.mCon_flow_nominal)
    "Scale to nominal mass flow rate" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-100,114})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai2(final k=dat.mEva_flow_nominal)
    "Scale to nominal mass flow rate" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-100,-22})));
protected
  final parameter Medium.ThermodynamicState sta_default=Medium.setState_pTX(
    T=Medium.T_default,
    p=Medium.p_default,
    X=Medium.X_default[1:Medium.nXi])
    "Medium state at default properties";
  final parameter Modelica.Units.SI.SpecificHeatCapacity cp_default=
      Medium.specificHeatCapacityCp(sta_default)
    "Specific heat capacity of the fluid";
equation
  connect(splConMix.port_3,valCon.port_3)
    annotation (Line(points={{120,70},{120,80},{-140,80},{-140,70}},color={0,127,255}));
  connect(valCon.port_2,pumCon.port_a)
    annotation (Line(points={{-130,60},{-110,60}},color={0,127,255}));
  connect(pumEva.port_b,splEva.port_1)
    annotation (Line(points={{-110,-60},{-130,-60}},color={0,127,255}));
  connect(splEva.port_3,valEva.port_3)
    annotation (Line(points={{-140,-70},{-140,-80},{120,-80},{120,-70}},color={0,127,255}));
  connect(con.yValEva,valEva.y)
    annotation (Line(points={{-48,137},{-32,137},{-32,120},{160,120},{160,-40},{120,-40},{120,-48}},color={0,0,127}));
  connect(con.yValCon,valCon.y)
    annotation (Line(points={{-48,133},{-44,133},{-44,90},{-160,90},{-160,40},{-140,40},{-140,48}},color={0,0,127}));
  connect(con.yChi,chi.on)
    annotation (Line(points={{-48,146},{-36,146},{-36,3},{-12,3}},color={255,0,255}));
  connect(uHea,con.uHea)
    annotation (Line(points={{-220,188},{-180,188},{-180,147},{-72,147}},color={255,0,255}));
  connect(uCoo,con.uCoo)
    annotation (Line(points={{-220,168},{-186,168},{-186,143},{-72,143}},color={255,0,255}));
  connect(senTConEnt.T,con.TConWatEnt)
    annotation (Line(points={{-31,40},{-78,40},{-78,133},{-72,133}},color={0,0,127}));
  connect(senTEvaEnt.T,con.TEvaWatEnt)
    annotation (Line(points={{9,-40},{-80,-40},{-80,137},{-72,137}},color={0,0,127}));
  connect(splConMix.port_2,port_bHeaWat)
    annotation (Line(points={{130,60},{200,60}},color={0,127,255}));
  connect(splEva.port_2,port_bChiWat)
    annotation (Line(points={{-150,-60},{-200,-60}},color={0,127,255}));
  connect(port_aHeaWat,valCon.port_1)
    annotation (Line(points={{-200,60},{-150,60}},color={0,127,255}));
  connect(port_aChiWat,valEva.port_1)
    annotation (Line(points={{200,-60},{130,-60}},color={0,127,255}));
  connect(valEva.port_2,senTEvaEnt.port_a)
    annotation (Line(points={{110,-60},{20,-60},{20,-50}},color={0,127,255}));
  connect(senTEvaLvg.port_b,pumEva.port_a)
    annotation (Line(points={{-20,-30},{-20,-60},{-90,-60}},color={0,127,255}));
  connect(senTEvaLvg.port_a,chi.port_b2)
    annotation (Line(points={{-20,-10},{-20,-6},{-10,-6}},color={0,127,255}));
  connect(senTEvaEnt.port_b,chi.port_a2)
    annotation (Line(points={{20,-30},{20,-6},{10,-6}},color={0,127,255}));
  connect(chi.port_b1,senTConLvg.port_a)
    annotation (Line(points={{10,6},{20,6},{20,10}},color={0,127,255}));
  connect(senTConLvg.port_b,splConMix.port_1)
    annotation (Line(points={{20,30},{20,60},{110,60}},color={0,127,255}));
  connect(pumCon.port_b,senTConEnt.port_a)
    annotation (Line(points={{-90,60},{-20,60},{-20,50}},color={0,127,255}));
  connect(senTConEnt.port_b,chi.port_a1)
    annotation (Line(points={{-20,30},{-20,6},{-10,6}},color={0,127,255}));
  connect(chi.P,PChi)
    annotation (Line(points={{11,9},{14,9},{14,0},{220,0}},color={0,0,127}));
  connect(add2.y,PPum)
    annotation (Line(points={{182,-140},{220,-140}},color={0,0,127}));
  connect(pumEva.P,add2.u2)
    annotation (Line(points={{-111,-51},{-120,-51},{-120,-140},{140,-140},{140,-146},{158,-146}},color={0,0,127}));
  connect(pumCon.P,add2.u1)
    annotation (Line(points={{-89,69},{-60,69},{-60,-134},{158,-134}},color={0,0,127}));
  connect(con.yChi,booToRea.u)
    annotation (Line(points={{-48,146},{-36,146},{-36,180},{-58,180}},color={255,0,255}));
  connect(booToRea.y,gai2.u)
    annotation (Line(points={{-82,180},{-120,180},{-120,0},{-100,0},{-100,-10}},color={0,0,127}));
  connect(gai2.y,pumEva.m_flow_in)
    annotation (Line(points={{-100,-34},{-100,-48}},color={0,0,127}));
  connect(gai1.y,pumCon.m_flow_in)
    annotation (Line(points={{-100,102},{-100,72}},color={0,0,127}));
  connect(booToRea.y,gai1.u)
    annotation (Line(points={{-82,180},{-100,180},{-100,126}},color={0,0,127}));
  connect(TChiWatSupSet,chi.TSet)
    annotation (Line(points={{-220,140},{-188,140},{-188,-3},{-12,-3}},color={0,0,127}));
  annotation (
    defaultComponentName="chi",
    Icon(
      graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-149,-110},{151,-150}},
          textColor={0,0,255},
          textString="%name"),
        Rectangle(
          extent={{-34,38},{38,-40}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-20,-22},{26,-30}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-14,0},{-18,-8},{-10,-8},{-14,0}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-14,0},{-18,8},{-10,8},{-14,0}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{16,18},{20,-22}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{10,6},{28,-12}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{18,6},{10,-6},{28,-6},{18,6}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-16,-8},{-12,-22}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-16,18},{-12,8}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-22,26},{24,18}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{90,-60},{16,-62}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{16,-40},{18,-62}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-16,-40},{-14,-62}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-1,42},{1,-42}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid,
          origin={-56,-61},
          rotation=90),
        Rectangle(
          extent={{-16,60},{-14,38}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{16,60},{18,38}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-1,42},{1,-42}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          origin={-56,59},
          rotation=90),
        Rectangle(
          extent={{90,60},{16,58}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid)}),
    Diagram(
      coordinateSystem(
        extent={{-200,-200},{200,200}})),
    Documentation(
      revisions="<html>
<ul>
<li>
March 27, 2024, by David Blum:<br/>
Update icon and fix port orientation to align with convention.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3606\">issue #3606</a>.
</li>
<li>
July 31, 2020, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>",
      info="<html>
<p>
This is a model for a chiller system with constant speed evaporator and
condenser pumps, and mixing valves modulated to maintain a minimum
condenser inlet temperature (resp. maximum evaporator inlet temperature).
</p>
<p>
The system is controlled based on the logic described in
<a href=\"modelica://Buildings.DHC.ETS.Combined.Controls.Chiller\">
Buildings.DHC.ETS.Combined.Controls.Chiller</a>.
The pump flow rate is considered proportional to the pump speed
under the assumption of a constant flow resistance for both the condenser
and the evaporator loops. This assumption is justified
by the connection of the loops to the buffer tanks, and the additional
assumption that the bypass branch of the mixing valves is balanced
with the direct branch.
</p>
</html>"));
end Chiller;
