within Buildings.Fluid.HeatExchangers.ActiveBeams;
model ActiveBeam

  extends
    Buildings.Fluid.HeatExchangers.ActiveBeams.BaseClasses.PartialSixPortInterface;

    parameter Real nBeams=1 "number of beams";

  replaceable parameter
    Buildings.Fluid.HeatExchangers.ActiveBeams.Data.Generic_coo per_coo
    "Record with performance data" annotation (
    Dialog(group="Nominal condition Cooling"),
    choicesAllMatching=true,
    Placement(transformation(extent={{72,-92},{92,-72}})));

  replaceable parameter
    Buildings.Fluid.HeatExchangers.ActiveBeams.Data.Generic_hea per_hea
    "Record with performance data" annotation (
    Dialog(group="Nominal condition Heating"),
    choicesAllMatching=true,
    Placement(transformation(extent={{40,-92},{60,-72}})));

  Buildings.HeatTransfer.Sources.PrescribedHeatFlow HeatToRoom annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={0,-30})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFlo_WaterCoo(redeclare final
      package Medium = Medium1) annotation (Placement(transformation(
        extent={{6,6},{-6,-6}},
        rotation=180,
        origin={-62,60})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temperatureSensor
    annotation (Placement(transformation(extent={{-12,-54},{-24,-42}})));
  Buildings.Fluid.HeatExchangers.HeaterCooler_u coo(
    redeclare final package Medium = Medium1,
    Q_flow_nominal=per_coo.Q_flow_nominal_coo,
    m_flow_nominal=0.1,
    dp_nominal=10,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
                   annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={46,60})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_b4
    annotation (Placement(transformation(extent={{-10,-98},{10,-78}})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFlo_air(redeclare final package
      Medium = Medium3) annotation (Placement(transformation(
        extent={{-6,6},{6,-6}},
        rotation=180,
        origin={-78,-60})));
  Buildings.Fluid.HeatExchangers.HeaterCooler_u hea(
    redeclare final package Medium = Medium1,
    Q_flow_nominal=-per_hea.Q_flow_nominal_hea,
    m_flow_nominal=0.1,
    dp_nominal=10,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
                   annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={46,20})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFlo_WaterHea(redeclare final
      package Medium = Medium1) annotation (Placement(transformation(
        extent={{6,6},{-6,-6}},
        rotation=180,
        origin={-62,20})));
  Modelica.Blocks.Math.Add add(k1=-1, k2=-1)
    annotation (Placement(transformation(extent={{66,38},{78,50}})));
  BaseClasses.ModificationFactorHea modificationFactorHeating(
    AirFlow_rated(k=per_hea.mAir_flow_nominal),
    WaterFlow_rated(k=per_hea.mWat_flow_nominal_hea),
    TempDiff_rated(k=per_hea.temp_diff_nominal_hea),
    Interpolation_AirFlow(xd=per_hea.primaryair.Normalized_AirFlow, yd=per_hea.primaryair.ModFactor),
    Interpolation_WaterFlow(xd=per_hea.water.Normalized_WaterFlow, yd=per_hea.water.ModFactor),
    Interpolation_TempDiff(xd=per_hea.temp_diff.Normalized_TempDiff, yd=per_hea.temp_diff.ModFactor))
    annotation (Placement(transformation(extent={{-14,32},{0,46}})));

  BaseClasses.ModificationFactorCoo modificationFactorCooling(
    AirFlow_rated(k=per_coo.mAir_flow_nominal),
    WaterFlow_rated(k=per_coo.mWat_flow_nominal_coo),
    TempDiff_rated(k=per_coo.temp_diff_nominal_coo),
    Interpolation_AirFlow(xd=per_coo.primaryair.Normalized_AirFlow, yd=per_coo.primaryair.ModFactor),
    Interpolation_WaterFlow(xd=per_coo.water.Normalized_WaterFlow, yd=per_coo.water.ModFactor),
    Interpolation_TempDiff(xd=per_coo.temp_diff.Normalized_TempDiff, yd=per_coo.temp_diff.ModFactor))
    annotation (Placement(transformation(extent={{-14,72},{0,86}})));

  Modelica.Blocks.Sources.RealExpression InletTempCoo(y=Medium1.temperature(
        state_a1_inflow))
    annotation (Placement(transformation(extent={{-50,66},{-36,78}})));
  Modelica.Blocks.Sources.RealExpression InletTempHea(y=Medium2.temperature(
        state_a2_inflow))
    annotation (Placement(transformation(extent={{-50,26},{-36,38}})));
  Modelica.Blocks.Math.Gain gain(k=1/nBeams)
                                 annotation (Placement(transformation(
        extent={{-4,-4},{4,4}},
        rotation=90,
        origin={-78,-20})));
  Modelica.Blocks.Math.Gain gain1(k=1/nBeams)
                                  annotation (Placement(transformation(
        extent={{-4,-4},{4,4}},
        rotation=90,
        origin={-62,34})));
  Modelica.Blocks.Math.Gain gain2(k=1/nBeams)
                                  annotation (Placement(transformation(
        extent={{-4,-4},{4,4}},
        rotation=90,
        origin={-62,74})));
  Modelica.Blocks.Math.Gain gain3(k=nBeams)
                                 annotation (Placement(transformation(
        extent={{4,-4},{-4,4}},
        rotation=0,
        origin={46,-10})));
equation

        assert( modificationFactorCooling.Interpolation_AirFlow.xd[1]<=0.000001 and modificationFactorCooling.Interpolation_AirFlow.yd[1]<=0.00001, "performance curve has to pass through (0,0)");
        assert( modificationFactorHeating.Interpolation_AirFlow.xd[1]<=0.000001 and modificationFactorHeating.Interpolation_AirFlow.yd[1]<=0.00001, "performance curve has to pass through (0,0)");

        assert( modificationFactorCooling.Interpolation_TempDiff.xd[1]<=0.000001 and modificationFactorCooling.Interpolation_TempDiff.yd[1]<=0.00001, "performance curve has to pass through (0,0)");
        assert( modificationFactorHeating.Interpolation_TempDiff.xd[1]<=0.000001 and modificationFactorHeating.Interpolation_TempDiff.yd[1]<=0.00001, "performance curve has to pass through (0,0)");

        assert( modificationFactorCooling.Interpolation_WaterFlow.xd[1]<=0.000001 and modificationFactorCooling.Interpolation_WaterFlow.yd[1]<=0.00001, "performance curve has to pass through (0,0)");
        assert( modificationFactorHeating.Interpolation_WaterFlow.xd[1]<=0.000001 and modificationFactorHeating.Interpolation_WaterFlow.yd[1]<=0.00001, "performance curve has to pass through (0,0)");

        assert( per_hea.mAir_flow_nominal==per_coo.mAir_flow_nominal, "Nominal air flow rate should be the same for heating and cooling");

  connect(port_a1, senMasFlo_WaterCoo.port_a)
    annotation (Line(points={{-100,60},{-68,60}}, color={0,127,255}));
  connect(port_a3, senMasFlo_air.port_a) annotation (Line(points={{100,-60},{
          -72,-60}},       color={0,127,255}));
  connect(senMasFlo_air.port_b, port_b3) annotation (Line(points={{-84,-60},{
          -100,-60}},       color={0,127,255}));
  connect(port_a2, senMasFlo_WaterHea.port_a)
    annotation (Line(points={{-100,20},{-68,20}}, color={0,127,255}));
  connect(HeatToRoom.port, port_b4)
    annotation (Line(points={{0,-40},{0,-40},{0,-88}}, color={191,0,0}));
  connect(temperatureSensor.port, port_b4)
    annotation (Line(points={{-12,-48},{0,-48},{0,-88}}, color={191,0,0}));
  connect(temperatureSensor.T, modificationFactorHeating.RoomTemp) annotation (
      Line(points={{-24,-48},{-28,-48},{-28,32.84},{-15.4,32.84}},color={0,0,127}));
  connect(modificationFactorCooling.RoomTemp, temperatureSensor.T) annotation (
      Line(points={{-15.4,72.84},{-28,72.84},{-28,-48},{-24,-48}},color={0,0,127}));
  connect(coo.port_b, port_b1)
    annotation (Line(points={{56,60},{78,60},{100,60}}, color={0,127,255}));
  connect(hea.port_b, port_b2)
    annotation (Line(points={{56,20},{100,20}},          color={0,127,255}));
  connect(modificationFactorHeating.y, hea.u) annotation (Line(points={{0.7,39},
          {26,39},{26,26},{34,26}}, color={0,0,127}));
  connect(modificationFactorCooling.y, coo.u) annotation (Line(points={{0.7,79},
          {28,79},{28,66},{34,66}}, color={0,0,127}));
  connect(coo.Q_flow, add.u1) annotation (Line(points={{57,66},{60,66},{60,47.6},
          {64.8,47.6}}, color={0,0,127}));
  connect(hea.Q_flow, add.u2) annotation (Line(points={{57,26},{60,26},{60,40.4},
          {64.8,40.4}}, color={0,0,127}));
  connect(senMasFlo_WaterCoo.port_b, coo.port_a)
    annotation (Line(points={{-56,60},{-10,60},{36,60}}, color={0,127,255}));
  connect(InletTempCoo.y, modificationFactorCooling.WaterTempInlet) annotation (
     Line(points={{-35.3,72},{-32,72},{-32,76.9},{-15.4,76.9}}, color={0,0,127}));
  connect(senMasFlo_WaterHea.port_b, hea.port_a)
    annotation (Line(points={{-56,20},{-10,20},{36,20}}, color={0,127,255}));
  connect(InletTempHea.y, modificationFactorHeating.WaterTempInlet) annotation (
     Line(points={{-35.3,32},{-32,32},{-32,36.9},{-15.4,36.9}}, color={0,0,127}));
  connect(senMasFlo_air.m_flow, gain.u) annotation (Line(points={{-78,-53.4},{-78,
          -40},{-78,-24.8}}, color={0,0,127}));
  connect(gain.y, modificationFactorHeating.AirFlow) annotation (Line(points={{-78,
          -15.6},{-78,45.3},{-15.4,45.3}}, color={0,0,127}));
  connect(modificationFactorCooling.AirFlow, gain.y) annotation (Line(points={{-15.4,
          85.3},{-78,85.3},{-78,-15.6}}, color={0,0,127}));
  connect(senMasFlo_WaterHea.m_flow, gain1.u)
    annotation (Line(points={{-62,26.6},{-62,29.2}}, color={0,0,127}));
  connect(gain1.y, modificationFactorHeating.WaterFlow) annotation (Line(points=
         {{-62,38.4},{-62,41.1},{-15.4,41.1}}, color={0,0,127}));
  connect(senMasFlo_WaterCoo.m_flow, gain2.u) annotation (Line(points={{-62,66.6},
          {-62,69.2}},            color={0,0,127}));
  connect(gain2.y, modificationFactorCooling.WaterFlow) annotation (Line(points=
         {{-62,78.4},{-62,81.1},{-15.4,81.1}}, color={0,0,127}));
  connect(add.y, gain3.u) annotation (Line(points={{78.6,44},{84,44},{84,-10},{50.8,
          -10}}, color={0,0,127}));
  connect(gain3.y, HeatToRoom.Q_flow) annotation (Line(points={{41.6,-10},{22,-10},
          {0,-10},{0,-20}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false,  extent={{-100,-100},
            {100,100}}),       graphics={
        Rectangle(
          extent={{94,26},{76,14}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-76,26},{-94,14}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),Rectangle(
          extent={{-80,80},{80,-80}},
          fillPattern=FillPattern.Solid,
          fillColor={95,95,95},
          pattern=LinePattern.None,
          lineColor={0,0,0}),       Ellipse(
          extent={{38,58},{-38,-18}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-80,-34},{0,-44}},
          fillColor={255,0,0},
          fillPattern=FillPattern.VerticalCylinder,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{0,-34},{80,-44}},
          fillColor={0,128,255},
          fillPattern=FillPattern.VerticalCylinder,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-80,66},{-98,54}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{98,66},{80,54}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-80,-54},{-98,-66}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{98,-54},{80,-66}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid)}), defaultComponentName="beam",Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
Documentation(info="<html>
<p>
Model of an active beam, based on the EnergyPlus beam model  <code>AirTerminal:SingleDuct:ConstantVolume:FourPipeBeam</code>.
</p>
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
  where <i><code>m&#775;<sub>SA</sub></code></i> is the primary air mass flow rate, <i>c<sub>p,SA</sub></i> is the air specific heat capacity, <i>T<sub>SA</sub></i> is the primary air temperature and <i>T<sub>Z</sub></i> is the zone air temperature
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
     <p align=\"center\" style=\"font-style:italic;\">
     <code>&#916;</code>T = T<sub>HW</sub>-T<sub>Z</sub> for heating mode
      <p> 
      where <i>T<sub>CW</sub> </i> is the chilled water temperature entering the convector in cooling mode and <i>T<sub>HW</sub> </i> is the hot water temperature entering the convector in heating mode.
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
end ActiveBeam;
