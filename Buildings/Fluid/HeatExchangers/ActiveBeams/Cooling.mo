within Buildings.Fluid.HeatExchangers.ActiveBeams;
model Cooling "model of an active beam unit for cooling"

  replaceable package Medium1 =
      Modelica.Media.Interfaces.PartialMedium "Medium 1 in the component"
      annotation (choicesAllMatching = true);
  replaceable package Medium2 =
      Modelica.Media.Interfaces.PartialMedium "Medium 2 in the component"
      annotation (choicesAllMatching = true);

  replaceable parameter
    Buildings.Fluid.HeatExchangers.ActiveBeams.Data.Generic per_coo
    "Record with performance data" annotation (
    Dialog(group="Parameters"),
    choicesAllMatching=true,
    Placement(transformation(extent={{72,-92},{92,-72}})));

  parameter Real nBeams=1 "number of beams";

  parameter Boolean allowFlowReversal1 = true
    "= true to allow flow reversal in medium 1, false restricts to design direction (port_a -> port_b)"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);
  parameter Boolean allowFlowReversal2 = true
    "= true to allow flow reversal in medium 2, false restricts to design direction (port_a -> port_b)"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);

  parameter Modelica.SIunits.MassFlowRate mWatCoo_flow_nominal(final min=0)
    "Water nominal mass flow rate for cooling"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate mAir_flow_nominal(min=0)
    "Air nominal mass flow rate"
    annotation(Dialog(group = "Nominal condition"));
  parameter Medium1.MassFlowRate m1_flow_small(min=0) = 1E-4*abs(mWatCoo_flow_nominal)
    "Small mass flow rate for regularization of zero flow"
    annotation(Dialog(tab = "Advanced"));
  parameter Medium2.MassFlowRate m2_flow_small(min=0) = 1E-4*abs(mAir_flow_nominal)
    "Small mass flow rate for regularization of zero flow"
    annotation(Dialog(tab = "Advanced"));
  // Diagnostics
  parameter Boolean show_T = false
    "= true, if actual temperature at port is computed"
    annotation(Dialog(tab="Advanced",group="Diagnostics"));

  Buildings.HeatTransfer.Sources.PrescribedHeatFlow heaToRoo
    "heat tranferred to the room" annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={0,-36})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heaPor "heat port"
    annotation (Placement(transformation(extent={{-10,-130},{10,-110}})));

  Modelica.Blocks.Math.Sum sum "connector for heating and cooling mode"
    annotation (Placement(transformation(extent={{40,20},{60,40}})));
  Modelica.Blocks.Math.Gain gai_1(k=1/nBeams)
    "Air mass flow rate for a single beam" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-90,-30})));
  Sensors.MassFlowRate senFlo1(redeclare final package Medium = Medium1)
    "Mass flow rate sensor"
    annotation (Placement(transformation(extent={{-120,50},{-100,70}})));
  Sensors.MassFlowRate senFlo(redeclare final package Medium = Medium2)
    "Mass flow rate sensor"
    annotation (Placement(transformation(extent={{-80,-70},{-100,-50}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor senTem
    annotation (Placement(transformation(extent={{-20,-50},{-40,-30}})));
  Modelica.Blocks.Math.Gain gai_2(final k=-nBeams)
    "multiplicator to take into account all the beams" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={50,-20})));

   Modelica.Blocks.Math.Gain gai_3(k=1/nBeams)
    "Water mass flow rate for a single beam" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,100})));

  BaseClasses.Convector conCoo(
    redeclare final package Medium = Medium1,
    hex(Q_flow_nominal=-per_coo.Q_flow_nominal),
    mod(
      airFlo_nom(k=1/per_coo.mAir_flow_nominal),
      watFlo_nom(k=1/per_coo.mWat_flow_nominal),
      temDif_nom(k=1/per_coo.dT_nominal),
      airFlo_mod(xd=per_coo.primaryAir.r_V, yd=per_coo.primaryAir.f),
      watFlo_mod(xd=per_coo.water.r_V, yd=per_coo.water.f),
      temDif_mod(xd=per_coo.dT.Normalized_TempDiff, yd=per_coo.dT.f)),
    final m_flow_nominal=mWatCoo_flow_nominal,
    final allowFlowReversal=allowFlowReversal) "Cooling beam"
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));

  Modelica.Fluid.Interfaces.FluidPort_a watCoo_a(
                     redeclare final package Medium = Medium1,
                     m_flow(min=if allowFlowReversal1 then -Modelica.Constants.inf else 0),
                     h_outflow(start = Medium1.h_default))
    "Fluid connector watCoo_a (positive design flow direction is from watCoo_a to watCoo_b)"
    annotation (Placement(transformation(extent={{-150,50},{-130,70}})));
  Modelica.Fluid.Interfaces.FluidPort_b watCoo_b(
                     redeclare final package Medium = Medium1,
                     m_flow(max=if allowFlowReversal1 then +Modelica.Constants.inf else 0),
                     h_outflow(start = Medium1.h_default))
    "Fluid connector watCoo_b (positive design flow direction is from watCoo_a to watCoo_b)"
    annotation (Placement(transformation(extent={{150,50},{130,70}})));

  Modelica.Fluid.Interfaces.FluidPort_a air_a(
    redeclare final package Medium = Medium2,
    m_flow(min=if allowFlowReversal2 then -Modelica.Constants.inf else 0),
    h_outflow(start=Medium2.h_default))
    "Fluid connector air_a (positive design flow direction is from air_a to air_b)"
    annotation (Placement(transformation(extent={{130,-70},{150,-50}})));
  Modelica.Fluid.Interfaces.FluidPort_b air_b(
    redeclare final package Medium = Medium2,
    m_flow(max=if allowFlowReversal2 then +Modelica.Constants.inf else 0),
    h_outflow(start=Medium2.h_default))
    "Fluid connector air_b (positive design flow direction is from air_a to air_b)"
    annotation (Placement(transformation(extent={{-130,-70},{-150,-50}})));

  Medium1.MassFlowRate m1_flow(start=0) = watCoo_a.m_flow
    "Mass flow rate from watCoo_a to watCoo_b (m1_flow > 0 is design flow direction)";
  Modelica.SIunits.PressureDifference dp1(start=0, displayUnit="Pa")
    "Pressure difference between watCoo_a and watCoo_b";

  Medium2.MassFlowRate m2_flow(start=0) = air_a.m_flow
    "Mass flow rate from air_a to air_b (m2_flow > 0 is design flow direction)";
  Modelica.SIunits.PressureDifference dp2(start=0, displayUnit="Pa")
    "Pressure difference between air_a and air_b";

  Medium1.ThermodynamicState sta_a1=
      Medium1.setState_phX(watCoo_a.p,
                           noEvent(actualStream(watCoo_a.h_outflow)),
                           noEvent(actualStream(watCoo_a.Xi_outflow))) if
         show_T "Medium properties in watCoo_a";
  Medium1.ThermodynamicState sta_b1=
      Medium1.setState_phX(watCoo_b.p,
                           noEvent(actualStream(watCoo_b.h_outflow)),
                           noEvent(actualStream(watCoo_b.Xi_outflow))) if
         show_T "Medium properties in watCoo_b";
  Medium2.ThermodynamicState sta_a2=
      Medium2.setState_phX(air_a.p,
                           noEvent(actualStream(air_a.h_outflow)),
                           noEvent(actualStream(air_a.Xi_outflow))) if
         show_T "Medium properties in air_a";
  Medium2.ThermodynamicState sta_b2=
      Medium2.setState_phX(air_b.p,
                           noEvent(actualStream(air_b.h_outflow)),
                           noEvent(actualStream(air_b.Xi_outflow))) if
         show_T "Medium properties in air_b";

protected
  Medium1.ThermodynamicState state_a1_inflow=
    Medium1.setState_phX(watCoo_a.p, inStream(watCoo_a.h_outflow), inStream(watCoo_a.Xi_outflow))
    "state for medium inflowing through watCoo_a";
  Medium1.ThermodynamicState state_b1_inflow=
    Medium1.setState_phX(watCoo_b.p, inStream(watCoo_b.h_outflow), inStream(watCoo_b.Xi_outflow))
    "state for medium inflowing through watCoo_b";
  Medium2.ThermodynamicState state_a2_inflow=
    Medium2.setState_phX(air_a.p, inStream(air_a.h_outflow), inStream(air_a.Xi_outflow))
    "state for medium inflowing through air_a";
  Medium2.ThermodynamicState state_b2_inflow=
    Medium2.setState_phX(air_b.p, inStream(air_b.h_outflow), inStream(air_b.Xi_outflow))
    "state for medium inflowing through air_b";

public
  parameter Boolean allowFlowReversal=true
    "= true to allow flow reversal, false restricts to design direction (port_a -> port_b)";

equation
dp1 = watCoo_a.p - watCoo_b.p;
dp2 = air_a.p - air_b.p;

        assert(conCoo.mod.airFlo_mod.xd[1]<=0.000001 and conCoo.mod.airFlo_mod.yd[1]<=0.00001, "performance curve has to pass through (0,0)");

        assert(conCoo.mod.watFlo_mod.xd[1]<=0.000001 and conCoo.mod.watFlo_mod.yd[1]<=0.00001, "performance curve has to pass through (0,0)");

        assert(conCoo.mod.temDif_mod.xd[1]<=0.000001 and conCoo.mod.temDif_mod.yd[1]<=0.00001, "performance curve has to pass through (0,0)");

  connect(heaToRoo.port, heaPor)
    annotation (Line(points={{0,-46},{0,-120}},        color={191,0,0}));
  connect(senFlo.m_flow, gai_1.u)
    annotation (Line(points={{-90,-49},{-90,-49},{-90,-42}},
                                                   color={0,0,127}));
  connect(sum.y,gai_2. u) annotation (Line(points={{61,30},{66,30},{70,30},{70,-20},
          {62,-20}}, color={0,0,127}));
  connect(gai_2.y,heaToRoo. Q_flow)
    annotation (Line(points={{39,-20},{0,-20},{0,-26}}, color={0,0,127}));
  connect(senTem.port, heaPor) annotation (Line(points={{-20,-40},{-14,-40},{
          -14,-52},{0,-52},{0,-120}},
                                  color={191,0,0}));
  connect(air_b, senFlo.port_b)
    annotation (Line(points={{-140,-60},{-100,-60}},color={0,127,255}));
  connect(senFlo.port_a, air_a)
    annotation (Line(points={{-80,-60},{140,-60}}, color={0,127,255}));
  connect(conCoo.port_b, watCoo_b)
    annotation (Line(points={{10,60},{140,60}}, color={0,127,255}));
  connect(conCoo.Q_flow, sum.u[1]) annotation (Line(points={{11,67},{20,67},{20,
          30},{38,30}}, color={0,0,127}));
  connect(senFlo1.m_flow, gai_3.u) annotation (Line(points={{-110,71},{-110,100},
          {-82,100}}, color={0,0,127}));
  connect(gai_3.y, conCoo.mWat_flow) annotation (Line(points={{-59,100},{-30,
          100},{-30,69},{-12,69}}, color={0,0,127}));
  connect(watCoo_a, senFlo1.port_a)
    annotation (Line(points={{-140,60},{-120,60}}, color={0,127,255}));
  connect(senFlo1.port_b, conCoo.port_a) annotation (Line(points={{-100,60},{
          -100,60},{-10,60}}, color={0,127,255}));
  connect(gai_1.y, conCoo.mAir_flow) annotation (Line(points={{-90,-19},{-90,-19},
          {-90,64},{-12,64}}, color={0,0,127}));
  connect(senTem.T, conCoo.TRoo) annotation (Line(points={{-40,-40},{-50,-40},{
          -50,54},{-12,54}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false,  extent={{-140,
            -120},{140,120}}), graphics={Rectangle(
          extent={{-120,100},{120,-100}},
          fillPattern=FillPattern.Solid,
          fillColor={95,95,95},
          pattern=LinePattern.None,
          lineColor={0,0,0}),       Ellipse(
          extent={{48,78},{-48,-18}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-80,-34},{0,-80}},
          fillColor={255,0,0},
          fillPattern=FillPattern.VerticalCylinder,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{0,-34},{80,-80}},
          fillColor={0,128,255},
          fillPattern=FillPattern.VerticalCylinder,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-120,66},{-132,54}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{132,66},{120,54}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-120,-54},{-134,-66}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{134,-54},{120,-66}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
                                 Text(
          extent={{-149,141},{151,101}},
          lineColor={0,0,255},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255},
          textString="%name")}),            defaultComponentName="beaCoo",Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-140,-120},{140,120}})),
Documentation(info="<html>
<p>
Model of an active beam, based on the EnergyPlus beam model  <code>AirTerminal:SingleDuct:ConstantVolume:FourPipeBeam</code>.
</p>
This model operates only in cooling mode. For a model that operates in both heating and cooling mode use <a href=\"modelica://Buildings.Fluid.HeatExchangers.ActiveBeams.CoolingHea\">
Buildings.Fluid.HeatExchangers.ActiveBeams.CoolingHea</a>
<p> The model proposed is a simple empirical model. Sets of data for rated capacities under corresponding rated operating 
conditions are adjusted by modification factors applied to account for how performance differs when operating away from the design point.
The model assumes that the total power of the active beam unit is the sum of the power provided by the primary air <i>Q<sub>SA</sub></i> and the power provided by the beam convector <i>Q<sub>Beam</sub></i>. 
<p>
<i>Q<sub>SA</sub> </i> is delivered to a thermal zone (e.g. <a href=\"modelica://Buildings.Rooms.MixedAir\">
Buildings.Rooms.MixedAir</a>) through the fluid ports. Conversely, <i>Q<sub>Beam</sub></i> is coupled directly to the heat port. 
</p>
The primary air contribution is easily determined using:
<p align=\"center\" style=\"font-style:italic;\">
  Q<sub>SA</sub> = <code>m&#775;<sub>SA</sub></code>c<sub>p,SA</sub>(T<sub>SA</sub>-T<sub>Z</sub>)
  <p> 
  where <i><code>m&#775;<sub>SA</sub></code></i> is the primary air mass flow rate, <i>c<sub>p,SA</sub></i> is the air specific heat capacity, <i>T<sub>SA</sub></i> is the primary air temperature 
  and <i>T<sub>Z</sub></i> is the zone air temperature
  <p>
The beam convector power <i>Q<sub>Beam</sub></i> is determined using rated capacity that is modified by three separate functions: 
  <p align=\"center\" style=\"font-style:italic;\">
  Q<sub>Beam</sub> = Q<sub>rated</sub> f<sub><code>&#916;</code>T</sub>( ) f<sub>SA</sub>( ) f<sub>W</sub>( ) 
<p>
The modification factor <i>f<sub><code>&#916;</code>T</sub>( )</i> describes how the capacity is adjusted to account for the temperature difference between the zone air and the water entering the convector.
The single independent variable is the ratio between the current temperature difference <i><code>&#916;</code>T</i> and temperature difference used to rate beam performance <i><code>&#916;</code>T<sub>rated</sub></i>.
   <p align=\"center\" style=\"font-style:italic;\">
   f<sub><code>&#916;</code>T</sub>( ) = f<sub><code>&#916;</code>T</sub> ( <code>&#916;</code>T &frasl; <code>&#916;</code>T<sub>rated</sub> ) 
    <p align=\"center\" style=\"font-style:italic;\">
    <code>&#916;</code>T = T<sub>Z</sub>-T<sub>CW</sub> for cooling mode
     
      <p> 
      where <i>T<sub>CW</sub> </i> is the chilled water temperature entering the convector in cooling mode.
   <p>
   The modification factor <i>f<sub>SA</sub>( )</i> describes how the cooling capacity is adjusted to account for the primary air flow rate. 
   The single independent variable is the ratio between the current primary air flow rate <i><code>m&#775;<sub>SA</sub></code></i> and the flow rate used to rate beam performance
   <i><code>m&#775;<sub>SA,rated</sub></code></i>.
    <p align=\"center\" style=\"font-style:italic;\">
    f<sub>SA</sub>( ) = f<sub>SA</sub> ( <code>m&#775;<sub>SA</sub></code> &frasl; <code>m&#775;<sub>SA,rated</sub></code> ) 
   <p>
   
   The modification factor <i>f<sub>W</sub>( )</i> describes describes how the cooling capacity is adjusted to account for the flow rate of water through the convector. 
   The single independent variable is the ratio between the current water flow rate <i><code>m&#775;<sub>W</sub></code></i> and the water flow rate used to rate beam performance
   <i><code>m&#775;<sub>W,rated</sub></code></i>.
    <p align=\"center\" style=\"font-style:italic;\">
    f<sub>W</sub>( ) = f<sub>W</sub> ( <code>m&#775;<sub>W</sub></code> &frasl; <code>m&#775;<sub>W,rated</sub></code> ) 
    <p>
    
    Currently, the model only includes performance data related to the TROX DID632A product with a type H nozzle and 6 foot active lenght. 
    Additional performance data can be developed by providing rated points for temperature difference, primary air flow rate and water flow rate for heating and cooling mode.
   <p>
<h4>References</h4>
<ul>
<li>
DOE(2015) EnergyPlus documentation v8.4.0 - Engineering Reference.
</li>
</ul>
</html>"));
end Cooling;
