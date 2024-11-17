within GED.DistrictElectrical.CHP;
model Combined "Combined-cycle CHP model"

  package MediumSte = Buildings.Media.Steam
    "Steam medium - Medium model for port_b (outlet)";
  package MediumWat =
      Buildings.Media.Specialized.Water.TemperatureDependentDensity
    "Water medium - Medium model for port_a (inlet)";

  Modelica.Blocks.Interfaces.RealOutput PEle
    "Gas turbine electricity generation"
    annotation (Placement(
        transformation(extent={{-10,-10},{10,10}}, origin={110,80}),
                                                    iconTransformation(extent={{100,70},
            {120,90}})));
  Modelica.Blocks.Interfaces.RealOutput mFue
    "Fuel mass flow rate"
    annotation (Placement(
        transformation(extent={{-10,-10},{10,10}}, origin={110,60}),
                                                    iconTransformation(extent={{100,50},
            {120,70}})));
  Modelica.Blocks.Interfaces.RealInput TAmb
    "Ambient temperature"
    annotation (Placement(
        transformation(extent={{-10,-10},{10,10}}, origin={-110,40}),
                                                        iconTransformation(
          extent={{-120,30},{-100,50}})));
  Modelica.Blocks.Interfaces.RealInput y
    "Part load ratio"
    annotation (Placement(transformation(
          extent={{-10,-10},{10,10}}, origin={-110,80}),
                                          iconTransformation(extent={{-120,70},
            {-100,90}})));
  ToppingCycle topCycTab(redeclare
      GED.DistrictElectrical.CHP.Data.SolarTurbines.NaturalGas.Centaur50_T6200S_NG
      per)
    annotation (Placement(transformation(
          extent={{-10,-10},{10,10}}, origin={0,50})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium =
        MediumWat)
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-90,-10},{-110,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare final package Medium =
        MediumSte)
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}}, origin={
            100,0})));
  BottomingCycle botCycExp
    annotation (Placement(transformation(extent={{-10,-40},{10,-22}})));
  Modelica.Blocks.Interfaces.RealOutput PEle_ST
    "Steam turbine electricity generation" annotation (Placement(transformation(
          extent={{-10,-10},{10,10}}, origin={110,40}), iconTransformation(
          extent={{100,50},{120,70}})));
equation
  connect(topCycTab.PEle, PEle) annotation (Line(points={{11.6,58},{20,58},{20,
          80},{110,80}},     color={0,0,127}));
  connect(topCycTab.mFue, mFue) annotation (Line(points={{11.7,52.1},{26,52.1},
          {26,52},{40,52},{40,60},{110,60}},
                         color={0,0,127}));
  connect(port_b, port_b)
    annotation (Line(points={{100,0},{100,0}}, color={0,127,255}));
  connect(y, topCycTab.y) annotation (Line(points={{-110,80},{-60,80},{-60,54},
          {-12,54}}, color={0,0,127}));
  connect(TAmb, topCycTab.TSet) annotation (Line(points={{-110,40},{-60,40},{
          -60,46},{-12,46}}, color={0,0,127}));
  connect(port_b, botCycExp.port_b)
    annotation (Line(points={{100,0},{100,-30},{10,-30}}, color={0,127,255}));
  connect(port_a, botCycExp.port_a) annotation (Line(points={{-100,0},{-100,-30},
          {-10,-30}}, color={0,127,255}));
  connect(botCycExp.TAmb, TAmb) annotation (Line(points={{-11.3,-24.7},{-60,
          -24.7},{-60,40},{-110,40}},         color={0,0,127}));
  connect(topCycTab.TExh, botCycExp.TExh) annotation (Line(points={{8.1,38.1},{
          8.1,16},{8,16},{8,0},{-20,0},{-20,-22},{-11.3,-22},{-11.3,-21.7}},
                                                                 color={0,0,127}));
  connect(topCycTab.mExh, botCycExp.mExh) annotation (Line(points={{1.9,38.1},{
          1.9,40},{2,40},{2,20},{-40,20},{-40,-27.9},{-11.3,-27.9}},
                   color={0,0,127}));
  connect(PEle_ST, PEle_ST)
    annotation (Line(points={{110,40},{110,40}}, color={0,0,127}));
  connect(botCycExp.PEle_ST, PEle_ST) annotation (Line(points={{11.2,-22},{60,
          -22},{60,40},{110,40}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
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
          fillPattern=FillPattern.Solid)}),                      Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>
March 28, 2023, by Zhanwei He:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This is the combined-cycle CHP model including the topping cycle and the bottoming cycle models.
</p>
</html>"));
end Combined;
