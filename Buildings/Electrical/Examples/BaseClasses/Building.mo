within Buildings.Electrical.Examples.BaseClasses;
model Building

  AC.OnePhase.Sources.PVSimple pVSimple(A=A,
    pf=0.95,
    eta_DCAC=0.9,
    V_nominal=V_building_n,
    linearized=linearized)
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  AC.OnePhase.Loads.Inductive      building(
    pf=pf,
    V_nominal=V_building_n,
    mode=Buildings.Electrical.Types.Load.VariableZ_y_input,
    P_nominal=-P_nominal,
    linearized=linearized)  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={10,-30})));
  AC.OnePhase.Interfaces.Terminal_n node "Generalized terminal"
    annotation (Placement(transformation(extent={{-108,-10},{-88,10}})));

  parameter Modelica.SIunits.Voltage V_distrib_n=15000
    "Nominal voltage of the distribution grid";
  parameter Modelica.SIunits.Voltage V_building_n=480
    "Nominal voltage of the building";
  parameter Real pf=0.8 "Power factor";
  parameter Modelica.SIunits.Area A "Net surface area";
  AC.OnePhase.Conversion.ACACTransformer transformer(VHigh=V_distrib_n, VLow=V_building_n,
    XoverR=8,
    Zperc=0.003,
    VABase=2.0*P_nominal)
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));

  parameter Modelica.SIunits.Power P_nominal
    "Nominal power consumption of the building";
  Modelica.Blocks.Interfaces.RealInput G
    "Total solar irradiation per unit area" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=180,
        origin={100,60}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=180,
        origin={80,40})));
  Modelica.Blocks.Sources.Sine loadProfile(
    startTime=startTime,
    amplitude=-0.3,
    freqHz=1/24/3600,
    phase=-0.5235987755983,
    offset=0.65)
    annotation (Placement(transformation(extent={{80,-40},{60,-20}})));
  parameter Modelica.SIunits.Time startTime=0 "Offset for load schedule";
  parameter Boolean linearized=false
    "If =true introduce a linearization in the load";
equation
  connect(node, transformer.terminal_n) annotation (Line(
      points={{-98,0},{-80,0}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(transformer.terminal_p, pVSimple.terminal) annotation (Line(
      points={{-60,0},{-30,0},{-30,30},{-4.44089e-16,30}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(transformer.terminal_p, building.terminal) annotation (Line(
      points={{-60,0},{-30,0},{-30,-30},{0,-30}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(pVSimple.G, G) annotation (Line(
      points={{10,42},{10,60},{100,60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(loadProfile.y, building.y) annotation (Line(
      points={{59,-30},{20,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
        Rectangle(
          extent={{-40,28},{40,-100}},
          lineColor={0,0,0},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-30,14},{-14,4}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-8,14},{8,4}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{14,14},{30,4}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{14,-2},{30,-12}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-8,-2},{8,-12}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-30,-2},{-14,-12}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{14,-18},{30,-28}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-8,-18},{8,-28}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-30,-18},{-14,-28}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{14,-34},{30,-44}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-8,-34},{8,-44}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-30,-34},{-14,-44}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{14,-50},{30,-60}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-8,-50},{8,-60}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-30,-50},{-14,-60}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{14,-66},{30,-76}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-8,-66},{8,-76}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-30,-66},{-14,-76}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{14,-82},{30,-92}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-8,-82},{8,-92}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-30,-82},{-14,-92}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-2,46},{-56,28},{52,28},{-2,46}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid)}));
end Building;
