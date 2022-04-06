within Buildings.Templates.ChilledWaterPlant.Components.Chillers;
model Electric "Electric chiller"
  extends
    Buildings.Templates.ChilledWaterPlant.Components.Chillers.Interfaces.PartialChiller(
     final typ=Buildings.Templates.ChilledWaterPlant.Components.Types.Chiller.ElectricChiller,
      dat(redeclare replaceable
        Buildings.Fluid.Chillers.Data.ElectricEIR.Generic per));

  Fluid.Chillers.ElectricEIR chi(
    final per=dat.per,
    redeclare final package Medium1 = Medium1,
    redeclare final package Medium2 = Medium2,
    final dp1_nominal=dp1_nominal,
    final dp2_nominal=dp2_nominal,
    final m1_flow_nominal=m1_flow_nominal,
    final m2_flow_nominal=m2_flow_nominal,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    "Chiller"
    annotation (Placement(transformation(extent={{-10,-8},{10,12}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold evaSta(
    t=1E-2, h=0.5E-2)
    "Evaluate pump status"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={10,50})));
  Buildings.Templates.Components.Sensors.Temperature TChiWatRet(
    redeclare final package Medium = Medium2,
    final have_sen=true,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell,
    final m_flow_nominal=m2_flow_nominal)
    "Chiller chilled water return temperature"
    annotation (Placement(transformation(extent={{60,-70},{80,-50}})));
  Buildings.Templates.Components.Sensors.Temperature TChiWatChiSup(
    redeclare final package Medium = Medium2,
    final have_sen=have_TChiWatChiSup,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell,
    final m_flow_nominal=m2_flow_nominal)
    "Chiller chilled water supply temperature"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  Buildings.Templates.Components.Sensors.Temperature TConWatSup(
    redeclare final package Medium = Medium1,
    final have_sen=true,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell,
    final m_flow_nominal=m1_flow_nominal)
    "Chiller condenser water supply temperature"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Buildings.Templates.Components.Sensors.Temperature TConWatRet(
    redeclare final package Medium = Medium1,
    final have_sen=have_TConWatRet,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell,
    final m_flow_nominal=m1_flow_nominal)
    "Chiller condenser water return temperature"
    annotation (Placement(transformation(extent={{58,50},{78,70}})));

equation
  connect(bus.on, chi.on)
    annotation (Line(
      points={{0,100},{0,80},{-28,80},{-28,6},{-12,6},{-12,5}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(bus.TSet, chi.TSet)
    annotation (Line(
      points={{0,100},{0,80},{-28,80},{-28,-1},{-12,-1}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(chi.P, evaSta.u)
    annotation (Line(points={{11,11},{10,11},{10,38}}, color={0,0,127}));
  connect(evaSta.y, bus.sta)
    annotation (Line(
      points={{10,62},{10,80},{0,80},{0,100}},
      color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(chi.port_a2, TChiWatRet.port_a)
    annotation (Line(points={{10,-4},{40,-4},{40,-60},{60,-60}},
      color={0,127,255}));
  connect(TChiWatRet.port_b, port_a2)
    annotation (Line(points={{80,-60},{100,-60}}, color={0,127,255}));
  connect(port_b2, TChiWatChiSup.port_a)
    annotation (Line(points={{-100,-60},{-80,-60}}, color={0,127,255}));
  connect(TChiWatChiSup.port_b, chi.port_b2)
    annotation (Line(points={{-60,-60},{-40,-60},{-40,-4},{-10,-4}},
      color={0,127,255}));
  connect(port_a1, TConWatSup.port_a)
    annotation (Line(points={{-100,60},{-80,60}}, color={0,127,255}));
  connect(TConWatSup.port_b, chi.port_a1)
    annotation (Line(points={{-60,60},{-40,60},{-40,8},{-10,8}},
      color={0,127,255}));
  connect(chi.port_b1, TConWatRet.port_a)
    annotation (Line(points={{10,8},{40,8},{40,60},{58,60}},
      color={0,127,255}));
  connect(TConWatRet.port_b, port_b1)
    annotation (Line(points={{78,60},{100,60}}, color={0,127,255}));
  connect(TConWatSup.y, bus.TConWatSup)
    annotation (Line(points={{-70,72},{-70,80},{0,80},{0,100}},
      color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(TConWatRet.y, bus.TConWatRet)
    annotation (Line(points={{68,72},{68,80},{0,80},{0,100}},
      color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(TChiWatChiSup.y, bus.TChiWatChiSup)
    annotation (Line(points={{-70,-48},{-28,-48},{-28,80},{0,80},{0,100}},
      color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(TChiWatRet.y, bus.TChiWatRet)
    annotation (Line(
      points={{70,-48},{70,-42},{30,-42},{30,80},{0,80},{0,100}},
      color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-70,80},{70,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-99,64},{102,54}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-99,-56},{102,-66}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-99,-54},{102,-66}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,-66},{0,-54}},
          lineColor={0,0,127},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-104,66},{98,54}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-2,54},{98,66}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-44,52},{-40,12}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-56,70},{58,52}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-42,2},{-52,12},{-32,12},{-42,2}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-42,2},{-52,-10},{-32,-10},{-42,2}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-44,-10},{-40,-50}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{38,52},{42,-50}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-56,-50},{58,-68}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{18,24},{62,-18}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{40,24},{22,-8},{58,-8},{40,24}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-99,-54},{102,-66}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,-66},{0,-54}},
          lineColor={0,0,127},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-104,66},{98,54}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-2,54},{98,66}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-44,52},{-40,12}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-56,70},{58,52}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-42,2},{-52,12},{-32,12},{-42,2}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-42,2},{-52,-10},{-32,-10},{-42,2}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-44,-10},{-40,-50}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{38,52},{42,-50}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-56,-50},{58,-68}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{18,24},{62,-18}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{40,24},{22,-8},{58,-8},{40,24}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),                      Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Electric;
