within Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses;
model PartialWaterCooledDXCoil "Base class for water-cooled DX coils"
  extends
    Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.EssentialParameters(
          redeclare Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.DXCoil datCoi);
  extends Buildings.Fluid.Interfaces.PartialFourPortInterface(
          final m1_flow_nominal=datCoi.sta[nSta].nomVal.m_flow_nominal,
          final m2_flow_nominal=datCoi.sta[nSta].nomVal.mCon_flow_nominal);

  parameter Modelica.SIunits.PressureDifference dpEva_nominal(min=0,displayUnit="Pa")
    "Pressure drop at nominal flowrate in the evaporator";

  parameter Modelica.SIunits.PressureDifference dpCon_nominal(min=0,displayUnit="Pa")
    "Pressure drop at nominal flowrate in the condenser";

  Modelica.Blocks.Interfaces.RealOutput P(quantity="Power", unit="W")
    "Electrical power consumed by the unit"
    annotation (Placement(transformation(extent={{100,70},{120,90}})));
  Modelica.Blocks.Interfaces.RealOutput QEvaSen_flow(quantity="Power", unit="W")
    "Sensible heat flow rate in evaporators"
    annotation (Placement(transformation(extent={{100,24},{120,44}})));
  Modelica.Blocks.Interfaces.RealOutput QEvaLat_flow(quantity="Power", unit="W")
    "Latent heat flow rate in evaporators"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  replaceable PartialDXCoil eva constrainedby PartialDXCoil(
    redeclare final package Medium = Medium1,
    redeclare final Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.DXCoil datCoi=datCoi,
    dxCoo(redeclare final Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.DXCoil datCoi=datCoi,
          wetCoi(redeclare final Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.CoolingCapacityWaterCooled cooCap,
                 redeclare final Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.DXCoil datCoi=datCoi,
                 appDewPt(redeclare final Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.DXCoil datCoi=datCoi,
                         uacp(redeclare final Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.BaseClasses.NominalValues per))),
          dryCoi(redeclare final Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.CoolingCapacityWaterCooled cooCap,
                 redeclare final Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.DXCoil datCoi=datCoi,
                 appDryPt(redeclare final Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.DXCoil datCoi=datCoi,
                         uacp(redeclare final Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.BaseClasses.NominalValues per)))),
    eva(final nomVal=Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Data.Generic.BaseClasses.NominalValues(
        Q_flow_nominal=datCoi.sta[nSta].nomVal.Q_flow_nominal,
        COP_nominal=datCoi.sta[nSta].nomVal.COP_nominal,
        SHR_nominal=datCoi.sta[nSta].nomVal.SHR_nominal,
        m_flow_nominal=datCoi.sta[nSta].nomVal.m_flow_nominal,
        TEvaIn_nominal=datCoi.sta[nSta].nomVal.TEvaIn_nominal,
        TConIn_nominal=datCoi.sta[nSta].nomVal.TConIn_nominal,
        phiIn_nominal=datCoi.sta[nSta].nomVal.phiIn_nominal,
        p_nominal=datCoi.sta[nSta].nomVal.p_nominal,
        tWet= datCoi.sta[nSta].nomVal.tWet,
        gamma=datCoi.sta[nSta].nomVal.gamma)),
    final use_mCon_flow=true,
    final dp_nominal=dpEva_nominal) "Direct evaporative coil"
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));

  Buildings.Fluid.HeatExchangers.HeaterCooler_u watCooCon(
        redeclare package Medium=Medium2,
        final m_flow_nominal = datCoi.sta[nSta].nomVal.mCon_flow_nominal,
        final dp_nominal = dpCon_nominal,
        final Q_flow_nominal=-datCoi.sta[nSta].nomVal.Q_flow_nominal*(1+1/datCoi.sta[nSta].nomVal.COP_nominal))
    "Water-cooled condenser"
    annotation (Placement(transformation(extent={{8,-70},{-12,-50}})));

  Modelica.Blocks.Sources.RealExpression u(final y=(-eva.dxCoo.Q_flow + eva.P)/(
        -datCoi.sta[nSta].nomVal.Q_flow_nominal*(1 + 1/datCoi.sta[nSta].nomVal.COP_nominal)))
    "Signal of total heat flow removed by condenser" annotation (Placement(
        transformation(
        extent={{-13,-10},{13,10}},
        rotation=0,
        origin={-7,-40})));

  Buildings.Fluid.Sensors.TemperatureTwoPort senTem(redeclare package Medium=Medium2,
      m_flow_nominal=datCoi.sta[nSta].nomVal.mCon_flow_nominal)
    "fixme: to be replaced with a realexpression"
    annotation (Placement(transformation(extent={{60,-70},{40,-50}})));

protected
  Modelica.Blocks.Sources.RealExpression mCon(final y=port_a2.m_flow)
    "Inlet water mass flow rate at the condenser"
    annotation (Placement(transformation(extent={{-66,30},{-40,50}})));
equation
  connect(u.y, watCooCon.u) annotation (Line(points={{7.3,-40},{20,-40},{20,-54},
          {10,-54}},color={0,0,127}));
  connect(eva.port_b, port_b1) annotation (Line(points={{10,60},{80,60},{100,60}},
                     color={0,127,255}));
  connect(eva.port_a, port_a1) annotation (Line(points={{-10,60},{-80,60},{-100,
          60}},       color={0,127,255}));
  connect(watCooCon.port_b, port_b2) annotation (Line(points={{-12,-60},{-80,-60},
          {-100,-60}},           color={0,127,255}));
  connect(watCooCon.port_a, senTem.port_b)
    annotation (Line(points={{8,-60},{40,-60}},           color={0,127,255}));
  connect(senTem.port_a, port_a2) annotation (Line(points={{60,-60},{80,-60},{100,
          -60}},           color={0,127,255}));
  connect(senTem.T, eva.TConIn) annotation (Line(points={{50,-49},{42,-49},{42,4},
          {-18,4},{-18,63},{-11,63}}, color={0,0,127}));
  connect(mCon.y, eva.mCon_flow) annotation (Line(points={{-38.7,40},{-24,40},{-24,
          56.8},{-11,56.8}}, color={0,0,127}));
  connect(eva.P, P) annotation (Line(points={{11,69},{62,69},{62,80},{110,80}},
        color={0,0,127}));
  connect(eva.QSen_flow, QEvaSen_flow) annotation (Line(points={{11,67},{58,67},
          {58,34},{110,34}}, color={0,0,127}));
  connect(eva.QLat_flow, QEvaLat_flow) annotation (Line(points={{11,65},{54,65},
          {54,0},{110,0}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-78,74},{80,-74}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-107,66},{94,56}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-6,56},{94,66}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
                                Text(
          extent={{54,12},{98,-8}},
          lineColor={0,0,127},
          textString="QEvaLat"),Text(
          extent={{54,50},{98,30}},
          lineColor={0,0,127},
          textString="QEvaSen"),
        Rectangle(
          extent={{6,-66},{106,-56}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-95,-56},{106,-66}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-6,-66},{94,-56}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
                                Text(
          extent={{54,100},{98,80}},
          lineColor={0,0,127},
          textString="P")}),                                     Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This model can be used to simulate a water-cooled DX cooling coil with single speed compressor.
</p>
<p>
See
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.UsersGuide\">
Buildings.Fluid.HeatExchangers.DXCoils.UsersGuide</a>
for an explanation of the model.
</p>
</html>", revisions="<html>
<ul>
<li>
February 16, 2017 by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialWaterCooledDXCoil;
